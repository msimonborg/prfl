# frozen_string_literal: true

require "json"

module Prfl
  # Airtable class for interacting with the Airtable API
  class Airtable
    attr_reader :token, :base_id

    def initialize(token, base_id = nil)
      @token = token
      @base_id = base_id || "appc723tjno0eHOLu"
    end

    def list_bases
      Request.new("meta/bases", token).fetch
    end

    def list_tables
      Request.new("meta/bases/#{base_id}/tables", token).fetch
    end

    def list_records(table_name, offset: nil)
      params = {}
      params[:offset] = offset if offset
      Request.new("#{base_id}/#{table_name}", token, params).fetch
    end
  end
end
