require 'multi_json'
require 'celluloid/future'

module StatHat
  module Json
    class Response

      attr_accessor :future, :body, :status, :message, :multiple
      attr_reader :raw_response, :parsed_body

      alias_method :msg, :message
      alias_method :msg=, :message=

      def initialize(response)
        @raw_response = response
        @parsed_body  = nil
        case response
          when Celluloid::Future
            @future = response
          when Faraday::Response
            @body = response.body
          else
            @body = response
        end
      end

      def body
        @body ||= future.value.body if future
        @body
      end

      def status
        @status ||= if future
                      future.value.status
                    elsif raw_response.respond_to?(:status)
                      raw_response.status
                    end
        @status
      end

      def parsed_body
        _parse
        @parsed_body
      end

      def message
        _parse
        @message
      end

      def multiple
        _parse
        @multiple
      end

      def valid?
        status == 200
      end

      private
      def _parse
        return if @parsed_body

        @parsed_body = MultiJson.load(body) rescue nil

        if @parsed_body.respond_to?(:each_pair)
          @parsed_body.each_pair do |k, v|
            setter = "#{k}="
            public_send(setter, v) if respond_to? setter
          end
        end
      end
    end
  end
end