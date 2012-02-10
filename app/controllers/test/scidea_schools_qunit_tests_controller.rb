module Test
  class ScideaSchoolsQunitTestsController < ApplicationController

    skip_authorization_check

    def index
      @html_fixtures = html_fixtures 
      @test_js = test_js

      render File.join(qunit_path, 'test_runner')
    end

    private

    # Get and array of test names either from params or inferred from existing test
    # js files 
    def test_names
      if(params[:test_names])
        params[:test_names].split(',')
      else
        Dir["#{qunit_path}/tests/**/*.js"].map do |file|
          file.sub(/.*\/tests\/(.+)?\.js/,'\1')
        end
      end
    end

    def html_fixtures
      test_names.map { |name|
        partial_file_name = name.sub(/(\/)?([^\/]+)$/, '\1_\2')

        paths = ActionController::Base.view_paths.map { |view_path|
          path = File.join(view_path, "../../qunit/html_fixtures/#{partial_file_name}.html.erb")
          # Only load a fixture file if it exists
          File.file?(path) ? "../../qunit/html_fixtures/#{name}" : nil
        }.compact
        paths.empty? ? nil : paths.first
      }.compact # remove nil entry caused by a non-existent fixture file
    end

    # Concatenate a string of all test javascript files for the given test names
    def test_js
      test_names.map { |name| 
        render_to_string File.join(qunit_path, "tests/#{name}.js"), :layout => false 
      }.join
    end

    def qunit_path
      File.expand_path('../../../../qunit', __FILE__)
    end
  end
end
