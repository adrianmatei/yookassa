# frozen_string_literal: true

RSpec.describe Yookassa::Webhook do
  let(:settings) { { shop_id: 'SHOP_ID', api_key: 'API_KEY' } }
  let(:idempotency_key) { 12_345 }
  let(:webhook) { described_class.new(settings) }

  shared_examples 'returns_webhook_object' do
    it 'returns success' do
      expect(subject).to be_kind_of Yookassa::Response
      expect(subject.id).to eq 'e44e8088-bd73-43b1-959a-954f3a7d0c54'
      expect(subject.url).to eq 'https://www.merchant-website.com/notification_url'
      expect(subject.event).to eq 'payment.succeeded'
    end
  end

  describe '#create' do
    let(:payload) { File.read('spec/fixtures/webhook.json') }
    let(:url) { 'https://api.yookassa.ru/v3/webhooks' }
    let(:body) { File.read('spec/fixtures/webhook_response.json') }

    before  { stub_request(:any, //).to_return(body: body) }
    subject { webhook.create(payload: payload, idempotency_key: idempotency_key) }

    it 'sends a request' do
      subject
      expect(a_request(:post, url)).to have_been_made
    end

    it_behaves_like 'returns_webhook_object'
  end

  describe '#delete' do
    let(:id) { 'e44e8088-bd73-43b1-959a-954f3a7d0c54' }
    let(:url) { "https://api.yookassa.ru/v3/webhooks/#{id}" }
    let(:body) { '' }

    before  { stub_request(:any, //).to_return(body: body) }
    subject { webhook.delete(id: id) }

    it 'sends a request' do
      subject
      expect(a_request(:delete, url)).to have_been_made
    end
  end
end
