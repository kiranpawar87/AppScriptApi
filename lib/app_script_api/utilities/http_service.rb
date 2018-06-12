module Utilities
  class HttpService
    attr_reader :authenticate
    include HTTParty
    base_uri ''

    def initialize
      @options = {}
    end

    def post_to_endpoint(path, body, headers = content_type)
      merge_headers(headers)
      result = self.class.post(URI.parse(path), :body => body.to_json, :headers => @options)
      result
    end

    private

    def merge_headers(headers)
      check_and_merge(headers)
    end

    def check_and_merge(attribute)
      @options.merge!(attribute) if attribute.present?
    end
  end
end
