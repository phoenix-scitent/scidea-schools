# Scidea Schools

Adds school association and lookup to users of Scitent's Scidea LMS platform. This gem is only useful in the context of the proprietary Scidea platform.

## Usage

1. Add `scidea-schools` to your Scidea Gemfile: 

    ```
    # Gemfile
    gem 'requirejs-rails'
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

2. Copy the contents of the Scidea core Gemfile *after* ``gemspec``, and paste it to the end of the Gemfile in the scidea-schools code. When you run rspec/cucumber, they require this Gemfile, thus you need all of the gems that Scidea core requires as well.
    ```
    source 'http://rubygems.org'

    gemspec

    gem 'scidea', :path => 'LOCAL_PATH_TO_SCIDEA-CORE'

    #from scidea core Gemfile:
    gem 'rails', '= 3.1.3'

    # db
    gem 'mysql2', '>= 0.3'

    # authentication and authorization
    gem 'devise', '< 2.0'
    gem 'cancan'
    
    ... and so on
    ```

From scidea-schools, you can run ``rspec`` and ``cucumber``. Note that FactoryGirl factories from the Scidea core are included in the testing runtime and added to whatever you include in ``spec/factories``. The database configuration from the Scidea core will also be used. You must run all rake operations for that database in the context of the Scidea core folder. They will not work in the scidea-schools folder.

## Compiling CSS and Inclusion in the Asset Pipeline

[SASS](https://github.com/nex3/sass) and [Compass](https://github.com/chriseppstein/compass) are configured such that SASS files under the ``app/themes/scidea`` directory are compiled to ``app/assets/stylesheets/scidea`` when you run ``compass compile``.

Because these stylesheets are added to the ``app/assets/stylesheets`` directory, they will be included in the Scidea core asset pipeline. However, because they are not ``scss`` files, Rails won't pick them up during the assets compile task. Therefore, any ``css`` file you add to ``app/assets/stylesheets`` must be included in the assets initializer: ``config/initializers/schools_assets.rb``.

## JS Modules

JS modules live in the ``app/assets/javascript`` directory. This puts them in the asset pipeline when the gem is inlcuded with Rails and the Scidea core.

To work with the core, they must be written as [RequireJS AMDs](http://requirejs.org/). In order for the modules to work in production mode and to be compiled during assets precompilation in the core, you must include them in the requirejs-rails configuration file, ``config/requirejs.yml``.

----

Copyright 2012 Scitent, Inc. See the file MIT-LICENSE for terms.
