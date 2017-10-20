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

          def perform_get url, token = nil
            token ||= @token
            response  = RestClient.get url, headers(token)
            parsed_response(response)
          end

          def perform_post url, body = {}, token = nil
            # We need to receive token param in order to use the Second Factor Authentication token when required
            token ||= @token
            response = RestClient.post(url, body.to_json, headers(token))
            parsed_response(response)
          end

          def parsed_response(response)
            data = JSON.parse(response)["data"]
            data.is_a?(Hash) ? data.with_indifferent_access : data
          end

          # This function is used for the Second Factor Authentication (2FA) at POST Api calls
          # Some services require a 2FA. Ex: a code send via SMS to the user
          # How it works:
          # => We request the service for first time, with the regular token. It response with a 428 (2FA needed) a ticket and a new token (otp token)
          # => With this ticket and the back url, we generate a URL in order to redirect the user
          # => The user goes to that URL and insert the SMS code
          # => The external app redirects the user to our back_url with the result
          # => If result is OK, the otp token is activated, and we are able to make the same request like the first one but with the otp token, instead the regular one

          def get_otp_url_and_token url, body = {}
            # We need to use the &block in order to not raise exception of the 428 required for the 2FA
            response = RestClient.post(url, body.to_json, headers(@token)){|response, request, result| response }
            parsed_response = JSON.parse(response)
            if parsed_response["result"]["code"] == 428
              data = parsed_response["data"]
              ["#{data["otp_url"]}?ticket=#{data["ticket"]}&back_url=#{Settings.bbva.otp_back_url}", data["token"]]
            else
              raise "RestClient::RequestFailed Exception: HTTP status code #{parsed_response["result"]["code"]}"
            end
          end

          # This function is used for the Second Factor Authentication (2FA) at GET Api calls
          # Some services require a 2FA. Ex: a code send via SMS to the user
          # How it works:
          # => We request the service for first time, with the regular token. It response with a 428 (2FA needed) a ticket and a new token (otp token)
          # => With this ticket and the back url, we generate a URL in order to redirect the user
          # => The user goes to that URL and insert the SMS code
          # => The external app redirects the user to our back_url with the result
          # => If result is OK, the otp token is activated, and we are able to make the same request like the first one but with the otp token, instead the regular one

          def get_otp_auth url, body = {}
            response = RestClient.get(url, headers(@token)){|response, request, result| response }
            parsed_response = JSON.parse(response)
            case parsed_response["result"]["code"]
            when 428
              data = parsed_response["data"]
              {otp_url: "#{data["otp_url"]}?ticket=#{data["ticket"]}", otp_token: data["token"] }
            when 200
              parsed_response(response)
            else
              raise "RestClient::RequestFailed Exception: HTTP status code #{parsed_response["result"]["code"]}"
            end
          end

          def headers(token)
            {
              :accept => "application/json",
              :content_type => "application/json",
              :Authorization => "jwt #{token}"
            }
          end

      end

    end
  end
end
