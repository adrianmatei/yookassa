# frozen_string_literal: true

module Yookassa
  class EntityResponse < Response
    option :id, proc(&:to_s)
    option :status, proc(&:to_s), default: proc { nil }
  end
end
