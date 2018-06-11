require 'rails/generators'

module AppScriptApi
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      desc "Creates App script initializer for your application"

      def install
        template "app_script_initializer.rb", "config/initializers/app_script_initializer.rb"

        puts "Generator Installed successfully. \n\n You can find it in config/initializers/app_script_initializer.rb"
      end
    end
  end
end
