# frozen_string_literal: true

require 'json'
require 'securerandom'

module NotAnalyticsClient
  class Hit
    def initialize(app_id:, event: nil, key: nil)
      @app_id = app_id
      @event = event
      @key = key
    end

    def payload
      {
        app_id: @app_id,
        event: @event,
        **auth_params,
      }.to_json
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
