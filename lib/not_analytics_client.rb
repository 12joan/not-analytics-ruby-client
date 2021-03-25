# frozen_string_literal: true

require_relative 'not_analytics_client/version'
require_relative 'not_analytics_client/hit'
require_relative 'not_analytics_client/message_encryptor'

module NotAnalyticsClient
  class Error < StandardError; end
end
