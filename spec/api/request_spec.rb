# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Request do
  describe '#initialize' do
    it 'sets the url depending on the env' do
      request = described_class.new('/test', 'staging')
      expect(request.url).to include(APPLICATION_ENVIRONMENT_VARIABLES['staging']['API_HOST'])

      request = described_class.new('/test', 'test')
      expect(request.url).to include(APPLICATION_ENVIRONMENT_VARIABLES['test']['API_HOST'])
    end

    it 'appends .json to the path' do
      request = described_class.new('/test', 'staging')
      expect(request.url).to end_with('/test.json')
    end

    it 'stores the token correspond to the right env' do
      request = described_class.new('/test', 'staging')
      expect(request.token).to include(APPLICATION_ENVIRONMENT_VARIABLES['staging']['HARVESTER_API_KEY'])

      request = described_class.new('/test', 'test')
      expect(request.token).to include(APPLICATION_ENVIRONMENT_VARIABLES['test']['HARVESTER_API_KEY'])
    end

    it 'stores the params ready to be used by RestClient if present' do
      request = described_class.new('/test', 'staging', { param: :value })
      expect(request.params).to eq(params: { param: :value })
    end

    it 'stores the params as empty hash if not present' do
      request = described_class.new('/test', 'staging')
      expect(request.params).to eq({})
    end
  end

  %i[get post put patch delete].each do |method|
    describe "##{method}" do
      it "only calls execute with the #{method} method" do
        request = described_class.new('/test', 'staging')
        expect(request).to receive(:execute).with(method)
        request.send(method)
      end
    end
  end

  describe '#execute' do
    it 'sends the right method' do
      request = described_class.new('/test', 'staging')
      expect(RestClient::Request).to receive(:execute).with(hash_including(method: :get))
      request.get

      request = described_class.new('/test', 'staging')
      expect(RestClient::Request).to receive(:execute).with(hash_including(method: :put))
      request.put
    end

    it 'sends to the set url' do
      request = described_class.new('/test', 'staging')
      expect(RestClient::Request).to receive(:execute).with(hash_including(url: request.url))
      request.get
    end

    it 'sends the Authentication-Token header' do
      request = described_class.new('/test', 'staging')
      expect(RestClient::Request).to receive(:execute).with(hash_including(
        headers: { 'Authentication-Token': request.token }
      ))
      request.get
    end
  end
end
