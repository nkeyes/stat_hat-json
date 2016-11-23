require 'spec_helper'
require 'stathat/json/sync_api'

module StatHat
  module Json
    describe SyncApi do
      describe '.initialize_connection' do
        it 'should use net_http_persistent' do
          expect_any_instance_of(Faraday::Connection).to receive(:adapter).with(:net_http_persistent)
          subject.ez_connection
        end
      end

      describe '.post_stats' do
        let(:json_string) { '{"ezkey":"EZ_KEY","data":[{"stat":"stat","count":1}]}' }
        specify do
          expect_any_instance_of(Faraday::Request).to receive(:url).with subject::EZ_URI
          expect_any_instance_of(Faraday::Request).to receive(:headers).at_least(1).times.and_call_original
          expect_any_instance_of(Faraday::Request).to receive(:body=).with(json_string)

          subject.ez_key = 'EZ_KEY'
          subject.post_stats(stat: 'stat', count: 1)
        end
      end

      describe '.post_count' do
        let(:stat) { {stat: 'count_stat', count: 2, t: nil} }
        it 'should proxy to .post_stats' do
          expect(subject).to receive(:post_stats).with(stat)

          subject.post_count('count_stat', 2)
        end
      end

      describe '.post_count' do
        let(:stat) { {stat: 'value_stat', value: 3.14159, t: 12345} }
        it 'should proxy to .post_stats' do
          expect(subject).to receive(:post_stats).with(stat)

          subject.post_value('value_stat', 3.14159, 12345)
        end
      end
    end
  end
end