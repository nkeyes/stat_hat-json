require 'stat_hat/json/publisher'
require 'stat_hat/json/sync_api'

module StatHat
  module Json
    module Api
      class << self
        extend Forwardable

        def future
          @pool ||= StatHat::Json::Publisher.pool(size: ENV['STATHAT_PUBLISHER_POOL_SIZE'] || 10)
          @pool.future
        end

        def_delegators :future, *StatHat::Json::Publisher.delegates
      end
    end
  end
end