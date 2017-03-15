require 'rest-client'
module Bbva
  module Api
    module Market
      class Base

        attr_accessor :token, :secret, :code, :refresh_token, :client_id

        def initialize(options = {})
          options.each do |key, value|
            instance_variable_set("@#{key}", value)
          end
          yield(self) if block_given?
        end

        def credentials
          {
            secret:         secret,
            code:           code,
            token:          token,
            refresh_token:  refresh_token,
            client_id:      client_id
          }
        end

        def refresh_token path
          refresh_token_path = "#{path}?grant_type=refresh_token"
          RestClient.post refresh_token_path,
          {:refresh_token => @refresh_token},
            :Authorization => "Basic #{Base64.strict_encode64("#{@client_id}:#{@secret}")}"
        end

        private

          def perform_get url
            response  = RestClient.get url, :content_type => "application/json", :Authorization => "jwt #{@token}"
            JSON.parse(response)["data"].with_indifferent_access
          end

          def perform_post url, body = {}, token = nil
            # We need to receive token param in order to use the Second Factor Authentication token when required
            token ||= @token
            response = RestClient.post(url, body.to_json, {:accept => "application/json",
                                    :content_type => "application/json",
                                    :Authorization => "jwt #{token}"})
            JSON.parse(response)["data"].with_indifferent_access
          end

          def get_otp_url_and_token url, body = {}
            # We need to use the &block in order to not raise exception of the 428 required for the 2FA
            response = RestClient.post(url, body.to_json, {:accept => "application/json",
                                    :content_type => "application/json",
                                    :Authorization => "jwt #{@token}"}){|response, request, result| response }
            parsed_response = JSON.parse(response)
            if parsed_response["result"]["code"] == 428
              data = parsed_response["data"]
              ["#{data["otp_url"]}?ticket=#{data["ticket"]}&back_url=#{Settings.bbva.otp_back_url}", data["token"]]
            else
              raise "RestClient::RequestFailed Exception: HTTP status code #{parsed_response["result"]["code"]}"
            end
          end

      end

    end
  end
end
