require 'faraday'
require 'multi_json'
require 'stathat/json/response'

module StatHat
  module Json
    module SyncApi
      extend self

      EZ_URL = 'https://api.stathat.com'.freeze
      EZ_URI = '/ez'.freeze

      ACCESS_URL = 'https://www.stathat.com'.freeze

      # StatHat says they access API returns 3,000 stats at a time at max, but it's actually 10,000
      ACCESS_BATCH_SIZE = 10000.freeze

      attr_accessor :logger

      def logger
        @logger ||= Logger.new(STDOUT)
      end

      def ez_key
        @ez_key ||= ENV['STATHAT_EZKEY']
      end

      def ez_key=(val)
        @ez_key = val
        reset_ez
      end

      def access_token
        @access_token ||= ENV['STATHAT_ACCESS_TOKEN']
      end

      def access_token=(val)
        @access_token = val
        reset_access
      end

      def reset_ez
        @ez_connection = nil
      end

      def reset_access
        @access_uri        = nil
        @access_connection = nil
      end

      def ez_connection
        @ez_connection ||= initialize_connection EZ_URL
      end

      def access_uri
        @access_uri ||= "/x/#{access_token}"
      end

      def access_connection
        @access_connection ||= initialize_connection ACCESS_URL
      end

      def initialize_connection(url)
        Faraday.new url do |conn|
          conn.adapter :net_http_persistent
        end
      end

      def stat_list
        offset = 0
        stats  = []
        loop do
          current_stats = _stat_list(offset).parsed_body
          stats         += current_stats
          offset        = stats.size
          logger.info "Got #{current_stats.size} stats."
          logger.info "Total stats: #{offset}."
          break if current_stats.size < ACCESS_BATCH_SIZE
        end
        stats
      end

      def find_stats(pattern)
        stat_list.select do |stat|
          pattern.match stat['name']
        end
      end

      def delete_stats(pattern)
        find_stats(pattern).each do |stat|
          delete_stat stat
        end
      end

      def delete_stat(stat)
        url = "#{access_uri}/stats/#{stat['id']}"
        response = access_connection.delete do |req|
          req.url(url)
        end
        StatHat::Json::Response.new response
        if response.status == 200
          logger.info "Deleted '#{stat['name'] || stat['id']}'."
        else
          logger.warn "Unable to delete stat '#{stat['name'] || stat['id']}'. status code: #{response.status}"
        end
        response
      end

      def _stat_list(offset=nil)
        response = access_connection.get do |req|
          req.url("#{access_uri}/statlist")
          req.params['offset'] = offset.to_i if offset
        end
        StatHat::Json::Response.new response
      end

      def post_stats(stats)
        response = ez_connection.post do |req|
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
        MultiJson.dump({ezkey: ez_key, data: stats})
      end
    end
  end
end