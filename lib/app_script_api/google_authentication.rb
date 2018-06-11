module AppScriptApi
  class GoogleAuthentication
    attr_reader :client_id, :client_secret, :scopes, :redirect_uri

    def initialize
      config = AppScriptApi.configuration
      @client_id = config.client_id
      @client_secret = config.client_secret
      @scopes = config.scopes
      @redirect_uri = config.redirect_uri
      authenticate
    end

    def authenticate
      @tokens = nil
      @tokens = tokens = load_tokens_yml rescue nil
      unless File.exist?(".tokens.yml")
        File.new(".tokens.yml", "w+") unless File.exist?(".tokens.yml")
        @tokens = tokens = YAML.load_file(".tokens.yml")
      end

      puts tokens
      if !tokens || tokens.nil?
        auth_client_obj = OAuth2::Client.new(client_id, client_secret, {:site => 'https://accounts.google.com', :authorize_url => "/o/oauth2/auth", :token_url => "/o/oauth2/token"})
        puts "\n\nPaste the below URL to browser : \n"
        puts auth_client_obj.auth_code.authorize_url(:scope => scopes, :access_type => "offline", :redirect_uri => redirect_uri, :approval_prompt => 'force')

        code = STDIN.gets.chomp.strip
        access_token_obj = auth_client_obj.auth_code.get_token(code, { :redirect_uri => redirect_uri, :token_method => :post })

        values = {}
        values["access_token"] = access_token_obj.token
        values["expires_at"] = access_token_obj.expires_at
        values["refresh_token"] = access_token_obj.refresh_token

        File.open(".tokens.yml","w") do |file|
          YAML.dump(values, file)
        end
      elsif expired?
        get_new_access_token
      end
    end

    def get_access_token
      if expired?
        get_new_access_token
      end
      get_tokens[:access_token]
    end

    private

    def get_new_access_token
      begin
        refresh_client_obj = OAuth2::Client.new(config.client_id, config.client_secret, {:site => 'https://accounts.google.com', :authorize_url => '/o/oauth2/auth', :token_url => '/o/oauth2/token'})
        refresh_access_token_obj = OAuth2::AccessToken.new(refresh_client_obj, @access_token, { "refresh_token" => @refresh_token })
        tokens = refresh_access_token_obj.refresh!
        values = {}
        values["access_token"] = tokens.token
        values["expires_at"] = tokens.expires_at
        values["refresh_token"] = tokens.refresh_token
        File.open(".tokens.yml","w") do |file|
          YAML.dump(values, file)
        end
      rescue Exception => e
        puts e
      end
    end

    def load_tokens_yml
      @tokens = YAML.load_file(".tokens.yml") if File.exist?(".tokens.yml") && @tokens.nil?
      @tokens
    end

    def get_tokens
      tokens = load_tokens_yml
      { access_token: tokens["access_token"], refresh_token: tokens["refresh_token"] }
    end

    def expired?
      tokens = load_tokens_yml
      return (Time.at(tokens["expires_at"]) < Time.now) ? true : false
    end
  end
end