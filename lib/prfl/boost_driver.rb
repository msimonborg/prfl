# frozen_string_literal: true

module Prfl
  # Wrapper around a selenium web driver
  class BoostDriver
    class CookieError < StandardError; end
    include Prfl::Logger

    BROWSER = :chrome

    attr_reader :cookie, :driver

    def initialize
      @config = Prfl.config || Prfl::Config.new
    end

    def quit
      driver&.quit
    end

    def new_session
      log "Starting a new #{BROWSER.to_s.capitalize} session"
      create_driver

      log "Attempting to login to Boost"
      log_in

      log "Login successful, retrieving session cookie"
      @cookie = driver.manage.cookie_named("boost")[:value]

      path = "#{Dir.pwd}/cookie"
      log "Cookie retrieved, writing to #{path}"
      File.write(path, @cookie)
      self
    end

    def get_profile_metadata(options = {})
      count = options[:count] || 20
      response = `#{metadata_request(count)}`
      fail_on_empty(response)
    end

    def get_profile_data(profile_id)
      response = `#{profile_request(profile_id)}`
      fail_on_empty(response)
    end

    def metadata_request(count)
      <<~CMD
        curl -s 'https://boost.stronghold.coffee/rstry/profile/status/list.sq?rc=w0&prodCd=10006&page=1&pageSetCnt=#{count}&minRstTime=0&maxRstTime=1800&prflName=&grnBeanName=' \
        -X 'GET' \
        -H 'Accept: application/json, text/javascript, */*; q=0.01' \
        -H 'Sec-Fetch-Site: same-origin' \
        -H 'Accept-Language: en-US,en;q=0.9' \
        -H 'Accept-Encoding: gzip, deflate, br, zstd' \
        -H 'Sec-Fetch-Mode: cors' \
        -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15' \
        -H 'Referer: https://boost.stronghold.coffee/rstry/prfl.sq?rc=w0&lang=en' \
        -H 'Connection: keep-alive' \
        -H 'Cookie: lang=en; boost=#{cookie}' \
        -H 'Sec-Fetch-Dest: empty' \
        -H 'X-Requested-With: XMLHttpRequest' \
        -H 'Priority: u=3, i'
      CMD
    end

    def profile_request(profile_id)
      <<~CMD
        curl -s 'https://boost.stronghold.coffee/rstry/profile/detail/get.sq?prodCd=10006&prflMCd=#{profile_id}&rc=w0' \
        -X 'GET' \
        -H 'Accept: application/json, text/javascript, */*; q=0.01' \
        -H 'Sec-Fetch-Site: same-origin' \
        -H 'Accept-Language: en-US,en;q=0.9' \
        -H 'Accept-Encoding: gzip, deflate, br, zstd' \
        -H 'Sec-Fetch-Mode: cors' \
        -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15' \
        -H 'Referer: https://boost.stronghold.coffee/rstry/profile/detail.sq?rc=w0&pCd=10006&cd=20261014051737838289&lang=en' \
        -H 'Connection: keep-alive' \
        -H 'Cookie: lang=en; boost=#{cookie}' \
        -H 'Sec-Fetch-Dest: empty' \
        -H 'X-Requested-With: XMLHttpRequest' \
        -H 'Priority: u=3, i'
      CMD
    end

    def create_driver
      options = Selenium::WebDriver::Options.send(BROWSER)
      options.page_load_strategy = :eager
      options.add_argument("--headless=new")
      @driver = Selenium::WebDriver.for(BROWSER, options: options)
    end

    def log_in
      driver.get("https://boost.stronghold.coffee/acct/login.sq?lang=en")
      driver.find_element(id: "userId").send_keys(@config.boost_email)
      driver.find_element(id: "userPwd").send_keys(@config.boost_password)
      driver.find_element(tag_name: "button").click
    rescue Selenium::WebDriver::Error::NoSuchElementError
      raise Error, "Login page did not load correctly, element not found"
    end

    private

    def fail_on_empty(response)
      if response.empty?
        raise CookieError,
              "No response from Boost server. Make sure the cookie is valid."
      else
        response
      end
    end
  end
end
