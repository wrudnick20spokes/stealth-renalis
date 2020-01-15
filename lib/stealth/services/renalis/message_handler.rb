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
          service_message.sender_id = get_sender_id
          service_message.session_values = get_session_values
          get_request_details

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

        def get_sender_id
          Digest::MD5.hexdigest(params.dig('session', 'user', 'userId'))
        end

        def get_session_values
          params.dig('session', 'attributes')
        end

        def get_request_details
          case params.dig('request', 'type')
          when 'CanFulfillIntentRequest'
            Stealth::Logger.l(topic: "renalis", message: "CanFulfillIntentRequest received.")
            # Not yet implemented
          when 'LaunchRequest'
            service_message.timestamp = DateTime.parse(params.dig('request', 'timestamp'))
            service_message.locale = params.dig('request', 'locale')
            service_message.payload = 'LaunchRequest'
            Stealth::Logger.l(topic: "renalis", message: "LaunchRequest received.")
          when 'IntentRequest'
            service_message.timestamp = DateTime.parse(params.dig('request', 'timestamp'))
            service_message.locale = params.dig('request', 'locale')
            service_message.payload = params.dig('request', 'intent', 'name')
            Stealth::Logger.l(topic: "renalis", message: "IntentRequest [#{service_message.payload}] received.")

            # Load the slots (if any)
            params.dig('request', 'intent', 'slots')&.each do |slot_name, slot|
              service_message.slots[slot_name] = slot.dig('value')
            end
          when 'SessionEndedRequest'
            service_message.timestamp = DateTime.parse(params.dig('request', 'timestamp'))
            service_message.locale = params.dig('request', 'locale')
            service_message.payload = 'SessionEndedRequest'
            Stealth::Logger.l(topic: "renalis", message: "SessionEndedRequest received.")
          end
        end

      end

      module Extensions
        attr_accessor :slots, :session_values, :locale

        def initialize(service:)
          @slots = @session_values = {}
          @locale = nil

          super
        end
      end
    end
  end

  class ServiceMessage
    prepend Services::Renalis::Extensions
  end

end
