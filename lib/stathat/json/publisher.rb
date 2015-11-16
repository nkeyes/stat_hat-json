require 'stathat/json/sync_api'
require 'celluloid/current'
require 'celluloid/io'

module StatHat
  module Json
    class Publisher
      include StatHat::Json::SyncApi
      include Celluloid::IO
    end
  end
end