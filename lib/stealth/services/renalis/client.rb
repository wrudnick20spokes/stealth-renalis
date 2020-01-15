# coding: utf-8
# frozen_string_literal: true

require 'stealth/services/renalis/message_handler'
require 'stealth/services/renalis/reply_handler'
require 'stealth/services/renalis/setup'

module Stealth
  module Services
    module Renalis

      class Client < Stealth::Services::BaseClient

        attr_reader :reply

        def initialize(reply:)
          @reply = reply
          Thread.current[:renalis_reply] = reply
        end

        def transmit
          Stealth::Logger.l(topic: "renalis", message: "Response sent.")
        end

      end

    end
  end
end
