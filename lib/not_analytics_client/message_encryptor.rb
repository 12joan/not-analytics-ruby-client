# frozen_string_literal: true

require 'openssl'
require 'base64'

module NotAnalyticsClient
  MessageEncryptor = Struct.new(:key) do
    def encrypt_and_sign(plain)
      cipher = OpenSSL::Cipher.new('aes-256-gcm')
      cipher.encrypt
      cipher.key = Base64.decode64(key)
      iv = cipher.random_iv
      cipher.auth_data = ''
      ciphertext = cipher.update(plain) + cipher.final
      auth_tag = cipher.auth_tag

      Struct.new(:ciphertext, :iv, :auth_tag).new(
        Base64.encode64(ciphertext),
        Base64.encode64(iv),
        Base64.encode64(auth_tag),
      )
    end

    def decrypt_and_verify(ciphertext, iv:, auth_tag:)
      cipher = OpenSSL::Cipher.new('aes-256-gcm')
      cipher.decrypt
      cipher.key = Base64.decode64(key)
      cipher.iv = Base64.decode64(iv)
      cipher.auth_data = ''
      cipher.auth_tag = Base64.decode64(auth_tag)

      cipher.update(Base64.decode64(ciphertext)) + cipher.final
    end
  end
end
