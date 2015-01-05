require 'stathat/json/publisher'
require 'stathat/json/sync_api'
require 'stathat/json/response'

module StatHat
  module Json
    module Api
      class << self
        extend Forwardable

        def future
          @pool ||= StatHat::Json::Publisher.pool(size: ENV['STATHAT_PUBLISHER_POOL_SIZE'] || 10)
          @pool.future
        end

        def post_stats(stats)
          StatHat::Json::Response.new(future.post_stats(stats))
        end

        def post_count(stat, count=1, t=nil)
          StatHat::Json::Response.new(future.post_count(stat, count, t))
        end

        def post_value(stat, value, t=nil)
          StatHat::Json::Response.new(future.post_value(stat, value, t))
        end

        def_delegators :future, *(StatHat::Json::Publisher.delegates - [:post_stats, :post_count, :post_value])
      end
    end
  end
end