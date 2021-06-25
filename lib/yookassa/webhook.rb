# frozen_string_literal: true

module Yookassa
  class Webhook < Evil::Client
    option :shop_id,  proc(&:to_s)
    option :api_key,  proc(&:to_s)

    path { 'https://api.yookassa.ru/v3/webhooks' }
    security { basic_auth shop_id, api_key }

    operation :delete do
      option :id, proc(&:to_s)

      http_method :delete

      path { "/#{id}" }

      format 'json'

      response(200) { |*res| Response.new({}) }
      response(400) { |*res| Error.build(*res) }
    end

    operation :create do
      option :payload
      option :idempotency_key, proc(&:to_s)

      http_method :post

      format 'json'
      headers { { 'Idempotence-Key' => idempotency_key } }
      body { payload }

      response(200) { |*res| Entity::Webhook.build(*res) }
      response(400, 401, 403, 404, 429, 500) { |*res| Error.build(*res) }
    end
  end
end
