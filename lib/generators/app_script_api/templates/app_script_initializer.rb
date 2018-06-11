AppScriptApi.configure do |config|
  config.client_id = "YOUR_CLIENT_ID"
  config.client_secret = "YOUR_CLIENT_SECRET"
  config.script_id = "YOUR_SCRIPT_ID"
  config.function_name = "YOUR_APP_SCRIPT_FUNCTION_NAME"
  config.dev_mode = false
  config.redirect_uri = "http://localhost:3000/auth"
  config.scopes = "https://www.googleapis.com/auth/script.projects https://www.googleapis.com/auth/script.container.ui https://www.googleapis.com/auth/script.external_request https://www.googleapis.com/auth/script.scriptapp"
end