require 'spec_helper'
require 'stathat/json/api'

module StatHat
  module Json
    describe Api do

      describe '.future' do
        let(:pool) {double}
        it 'uses StatHat::Json::Publisher.pool' do
          expect(StatHat::Json::Publisher).to receive(:pool).and_return(pool)
          expect(pool).to receive(:future)
          subject.future
        end
      end

      describe '.post_stats' do
        let(:future) { double }
        it 'uses the celluloid thread pool' do
          expect(subject).to receive(:future).and_return(future)
          expect(future).to receive(:post_stats).with(stat: 'stat', count: 1)
          subject.post_stats(stat: 'stat', count: 1)
        end
      end

      describe '.post_count' do
        let(:future) { double }
        it 'uses the celluloid thread pool' do
          expect(subject).to receive(:future).and_return(future)
          expect(future).to receive(:post_count).with('stat', 1, 12345)
          subject.post_count('stat', 1, 12345)
        end
      end

      describe '.post_value' do
        let(:future) { double }
        it 'uses the celluloid thread pool' do
          expect(subject).to receive(:future).and_return(future)
          expect(future).to receive(:post_value).with('stat', 3.14159, 12345)
          subject.post_value('stat', 3.14159, 12345)
        end
      end
    end
  end
end