# frozen_string_literal: true

module Prfl
  class Airtable
    # Request class for making requests to the Airtable API
    class Request
      attr_accessor :path, :params, :token

      def initialize(path = nil, token = nil, params = {}, &block)
        @path = path
        @token = token
        @params = params
        block.call(self) if block_given?
      end

      def fetch
        params = @params.map { |k, v| "#{k}=#{v}" }.join("&")
        curl = <<~CURL
          curl -s "#{URI.parse("https://api.airtable.com/v0/#{path}?#{params}")}" \
            -H "Authorization: Bearer #{token}"
        CURL

        response = `#{curl}`

        JSON.parse(response)
      end
    end
  end
end

# https://api.airtable.com/v0/appc723tjno0eHOLu/Roasts?fields%5B%5D=ColorTrack&fields%5B%5D=ID&filterByFormula=ID%3D%3D6754
#
# URI.encode_www_form([["fields[]", "ColorTrack"], ["fields[]", "ID"], ["filterByFormula", "ID=7804"]])
# => "fields%5B%5D=ColorTrack&fields%5B%5D=ID&filterByFormula=ID%3D7804"
#
# {fields: ["Colortrack", "ID"], filter_by: {"ID" => "7804"}}
