require "bbva/api/market/services"
require 'bbva/api/market/base'

module Bbva
  module Api
    module Market
      class Paystats < Base

        attr_accessor :token_info, :access_token

        def initialize(options = {})
          super
          get_access_token
        end

        def get_access_token
          access_token_path = "#{TOKEN_PATH}?grant_type=client_credentials"
          response = RestClient.post access_token_path, {}, :Authorization => "Basic #{Base64.strict_encode64("#{@client_id}:#{@secret}")}"
          @token_info = JSON.parse(response).with_indifferent_access
          @token_info = @token_info.merge(expires_at: Time.now.to_i + @token_info[:expires_in].to_i)
          @access_token = @token_info[:access_token]
        end

        def check_token
          if @token_info[:expires_at] < Time.now.to_i
            get_access_token
          end
        end

        def zipcode_basic_stats(zipcode, page_key, page_size, category, group_by, max_date, min_date)
          query = "$page_key=#{page_key}&$page_size=#{page_size}&category=#{category}&group_by=#{group_by}&max_date=#{max_date}&min_date=#{min_date}"
          send_request("zipcodes/#{zipcode}/basic_stats?#{query}")
        end

        private

        def send_request(url_completion)
          check_token
          perform_get("#{PAYSTATS_PATH}/#{url_completion}", @access_token)
        end

      end
    end
  end
end
