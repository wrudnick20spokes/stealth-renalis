# coding: utf-8
# frozen_string_literal: true

module Stealth
  module Services
    module Renalis

      class Setup

        class << self
          def trigger
            Stealth::Logger.l(topic: "renalis", message: "There is no setup needed!")
          end
        end

      end

    end
  end
end
