# Scidea Schools

Adds school association and lookup to users of Scitent's Scidea LMS platform. This gem is only useful in the context of the proprietary Scidea platform.

## Usage

1. Add `scidea-schools` to your Scidea Gemfile: 

    ```
    # Gemfile
    gem 'scidea-schools'
    ```

2. Add the installation migrations to your ``db/migrate/`` folder:

    ```
    rails g scidea:schools:migrations
    ```

3. Schools will appear in the registration form when there is an audience/profession called *Educator* and there exists at least one school record in the database.

## Development Environment and Testing

The gem is configured to use rspec and cucumber tests. Because there are so many dependencies upon the Scidea core, rspec and cucumber have been configured to launch an instance of the core application with the plugin's resources tied in. The features and specs of the plugin, however, are the only ones executed when you run cucumber and rspec, respectively.

To set up your environment for testing, perform the following:

1. In your local Scidea core instance, add the following line to the Gemfile:

    ```
    # Gemfile
    gem 'scidea-schools', :path => 'LOCAL_PATH_TO_SCIDEA-SCHOOLS'
    ```

2. Add the scidea gem to the scidea-schools Gemfile and add the path to your Scidea core instance. Then, copy the contents of the Scidea core Gemfile *after* ``gemspec`` (overwriting anything currently there), and paste it to the end of the Gemfile in the scidea-schools code. When you run rspec/cucumber, they require this Gemfile, thus you need all of the gems that Scidea core requires as well.

    ```
    source 'http://rubygems.org'

    gemspec

    gem 'scidea', :path => 'LOCAL_PATH_TO_SCIDEA-CORE'

    # contents of scidea core Gemfile here....

    ```

From scidea-schools, you can run ``bundle exec rspec`` and ``bundle exec cucumber``. Note that FactoryGirl factories from the Scidea core are included in the testing runtime and added to whatever you include in ``spec/factories``. The database configuration from the Scidea core will also be used. You must run all rake operations for that database in the context of the Scidea core folder. They will not work in the scidea-schools folder.

## Compiling CSS and Inclusion in the Asset Pipeline

Stylesheets from ``app/themes/scidea`` are added to the ``app/assets/stylesheets`` directory as a part of the asset pipeline. However, because they are not ``scss`` files, Rails won't pick them up during the assets compile task. Therefore, any ``css`` file you add to ``app/assets/stylesheets`` must be included in the assets initializer: ``config/initializers/schools_assets.rb``.

## JS Modules

JS modules live in the ``app/assets/javascript`` directory. This puts them in the asset pipeline when the gem is inlcuded with Rails and the Scidea core.

The plugin can assume that the core loads jquery, so shouldn't require this again.

----

Copyright 2012 Scitent, Inc. See the file MIT-LICENSE for terms.
