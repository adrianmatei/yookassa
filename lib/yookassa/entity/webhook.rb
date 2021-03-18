# frozen_string_literal: true

module Yookassa
  module Entity
    class Webhook < Yookassa::EntityResponse
      option :event
      option :url
    end
  end
end
