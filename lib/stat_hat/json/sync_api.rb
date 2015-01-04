require 'faraday'
require 'json'

module StatHat
  module Json
    module SyncApi
      extend self

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

        yield response if block_given?
        response
      end

      def post_count(stat, count, t=nil, &block)
        post_stats(stat: stat, count: count, t: t, &block)
      end

      def post_value(stat, value, t=nil, &block)
        post_stats(stat: stat, value: value, t: t, &block)
      end

      def build_post_data(stats)
        stats = [stats].flatten
        {
            ezkey: ez_key,
            data:  stats
        }.to_json
      end
    end
  end
end