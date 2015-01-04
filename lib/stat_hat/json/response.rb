require 'multi_json'
require 'celluloid/future'

module StatHat
  module Json
    class Response

      attr_accessor :future, :body, :status, :message, :multiple

      alias_method :msg, :message
      alias_method :msg=, :message=

      def initialize(response)
        @parsed = false
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
        _parse
        @status
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
        return if @parsed

        parsed_body = MultiJson.load(body)

        parsed_body.each_pair do |k, v|
          setter = "#{k}="
          public_send(setter, v) if respond_to? setter
        end

        @parsed = true
      end
    end
  end
end