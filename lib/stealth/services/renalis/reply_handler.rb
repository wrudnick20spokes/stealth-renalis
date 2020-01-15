# coding: utf-8
# frozen_string_literal: true

module Stealth
  module Services
    module Renalis

      class ReplyHandler < Stealth::Services::BaseReplyHandler

        attr_reader :recipient_id, :reply

        def initialize(recipient_id: nil, reply: nil)
          @recipient_id = recipient_id
          @reply = reply
        end

        def text
          reply
        end
      end
    end
  end
end
