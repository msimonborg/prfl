# frozen_string_literal: true

module Prfl
  # Class for managing program configurations
  class Config
    attr_accessor :artisan_path,
                  :boost_path,
                  :target_path,
                  :boost_email,
                  :boost_password,
                  :browser
  end
end
