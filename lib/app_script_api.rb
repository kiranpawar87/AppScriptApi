require "app_script_api/version"
require 'active_support/configurable'
require 'yaml'

module AppScriptApi
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  def self.get_script_id
    configuration.script_id rescue nil
  end

  def self.get_function_name
    configuration.function_name
  end

  def self.get_dev_mode
    configuration.dev_mode
  end

  class AppScriptApi::Configuration
    include ActiveSupport::Configurable

    config_accessor(:client_id) { "497538968616-f6f8lbgsgl43fecoq1bqipkbl4pjn4l3.apps.googleusercontent.com" }
    config_accessor(:client_secret) { "CKXmLuzWWoyWm3w8u3pw2P_A" }
    config_accessor(:script_id) { "1kdtmXPtQcJF8o95OftZSYH5-3HmdCNCXVf8wjPAyb1hTN-1LtlhNIpBr" }
    config_accessor(:scopes) { "https://www.googleapis.com/auth/script.projects https://www.googleapis.com/auth/drive https://www.googleapis.com/auth/script.container.ui https://www.googleapis.com/auth/script.external_request https://www.googleapis.com/auth/script.scriptapp https://www.googleapis.com/auth/spreadsheets" }
    config_accessor(:redirect_uri) { "http://localhost:3000/auth" }
    config_accessor(:function_name) { "copySheet" }
    config_accessor(:dev_mode) { false }
  end
end
