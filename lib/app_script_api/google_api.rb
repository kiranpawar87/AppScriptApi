require 'httparty'
require 'app_script_api/utilities/http_service'
require 'app_script_api/google_authentication'

class AppScriptApi::GoogleApi
  attr_accessor :apis, :service, :headers, :auth

  def initialize
    @auth = AppScriptApi::GoogleAuthentication.new
    file_path = File.join(File.dirname(__FILE__),'config/apis.yaml')
    @apis = YAML.load_file(file_path) if File.exist?(file_path) || nil
    @service = Utilities::HttpService.new
    @headers = {}
    @headers.merge!(authorization).merge!(content_type)
  end

  # POST https://script.googleapis.com/v1/scripts/%{SCRIPT_ID}:run
  def run(payload = {})
    url = apis['run']['url']
    body = {
        function: AppScriptApi.get_function_name,
        devMode: AppScriptApi.get_dev_mode,
        parameters: [payload.to_json]
    }
    interpolate(url, 'SCRIPT_ID', AppScriptApi.get_script_id)
    service.post_to_endpoint(url, body, headers)
  end

  private

  def content_type
   { "Content-Type" => 'application/json' }
  end

  def authorization
    { "Authorization" => "Bearer #{auth.get_access_token}"}
  end

  def interpolate(str, name, value)
    str.gsub!("%{#{name}}", value)
  end
end
