require 'faraday'
require 'multi_json'
require 'stathat/json/response'

module StatHat
  module Json
    module SyncApi
      extend self

      attr_accessor :ez_key

      EZ_URL = 'https://api.stathat.com'.freeze
      EZ_URI = '/ez'.freeze

      def ez_key
        @ez_key ||= ENV['STATHAT_EZKEY']
      end

      def connection
        @connection ||= initialize_connection
      end

      def initialize_connection
        Faraday.new EZ_URL do |conn|
          conn.adapter :net_http_persistent
        end
      end

      def post_stats(stats)
        response = connection.post do |req|
          req.url(EZ_URI)
          req.headers['Content-Type'] = 'application/json'
          req.body                    = build_post_data(stats)
        end

        StatHat::Json::Response.new response
      end

      def post_count(stat, count=1, t=nil)
        post_stats(stat: stat, count: count, t: t)
      end

      def post_value(stat, value, t=nil)
        post_stats(stat: stat, value: value, t: t)
      end

      def build_post_data(stats)
        stats = [stats].flatten
        MultiJson.dump({ ezkey: ez_key, data: stats })
      end
    end
  end
end