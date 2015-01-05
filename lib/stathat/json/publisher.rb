require 'stathat/json/sync_api'
require 'celluloid/io'

module StatHat
  module Json
    class Publisher
      include StatHat::Json::SyncApi
      include Celluloid::IO

      def self.delegates
        StatHat::Json::SyncApi.public_instance_methods(false)
      end
    end
  end
end