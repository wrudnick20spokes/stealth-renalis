# coding: utf-8
# frozen_string_literal: true

require 'digest'

module Stealth
  module Services
    module Renalis
      class MessageHandler < Stealth::Services::BaseMessageHandler

        attr_reader :service_message, :params, :headers

        def initialize(params:, headers:)
          @params = params
          @headers = headers
        end

        def coordinate
          process
        end

        def process
          @service_message = ServiceMessage.new(service: 'renalis')

          # Load the request attributes
          service_message.sender_id = params['user']
          service_message.message = params['message']

          Stealth::Logger.l(topic: "renalis", message: service_message.message)

          # Craft the reply
          bot_controller = BotController.new(service_message: service_message)
          bot_controller.route

          send_renalis_reply
        end

        private

        def send_renalis_reply
          puts MultiJson.dump(Thread.current[:renalis_reply]).inspect
          MultiJson.dump(Thread.current[:renalis_reply])
        end
      end
    end
  end
end
