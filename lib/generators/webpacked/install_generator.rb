module Webpacked
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def use_foreman
      if yes?('Would you like to use foreman to start webpack-dev-server and rails server at same time?')
        gem 'foreman'
        copy_file 'Procfile'
        run 'bundle install' if yes?("Run 'bundle install' for you?")
      end
    end

    def copy_frontend_dir
      directory 'frontend'
    end

    def prepare_package_json
      get 'package.json' do |content|
        content.gsub!(/\{\{(.+?)\}\}/) do
          Rails.configuration.webpacked.send(Regexp.last_match(1))
        end
        create_file 'package.json', content
      end
    end

    def add_to_gitignore
      append_to_file '.gitignore' do
        <<-EOF.strip_heredoc
        # Added by webpacked
        /node_modules
        /public/assets/webpacked
        EOF
      end
    end

    def run_npm_install
      run 'npm install' if yes?("Run 'npm install' for you?")
    end

    def whats_next
      puts <<-EOF.strip_heredoc
        Base webpacked setup completed. Now you can:
          1. Include 'Webpacked::ControllerHelper' into 'ApplicationController'
             and set up entry points for your controllers via 'webpacked_entry' class method
          2. Add the webpacked helpers into your layout instead of regular Rails helpers
          3. Run 'npm run dev:server' to start webpack-dev-server or 'foreman start' to start it alongside rails server
        See https://github.com/Darkside73/webpacked for more info.
        Thanks for using webpacked gem ;)
      EOF
    end
  end
end
