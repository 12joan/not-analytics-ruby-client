# frozen_string_literal: true

require 'json'
require 'securerandom'
require 'net/http'

module NotAnalyticsClient
  class Hit
    def initialize(app_id:, event: nil, key: nil)
      @app_id = app_id
      @event = event
      @key = key
    end

    def payload
      {
        hit: {
          app_id: @app_id,
          event: @event,
          **auth_params,
        }
      }.to_json
    end

    def post!(not_analytics_url:)
      uri = URI(not_analytics_url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'
      
      request = Net::HTTP::Post.new(uri.request_uri, {
        'Content-Type' => 'application/json'
      })

      request.body = payload

      http.request(request)
    end

    private

    def auth_params
      if @key.nil?
        {}
      else
        nonce = SecureRandom.hex

        MessageEncryptor.new(@key).encrypt_and_sign("#{nonce}:#{@event}").then do
          {
            nonce: nonce,
            signature: _1.ciphertext,
            iv: _1.iv,
            auth_tag: _1.auth_tag,
          }
        end
      end
    end
  end
end
