Dir["#{File.dirname(__FILE__)}/#{File.basename(__FILE__, '.rb')}/*.rb"].each {|file| require file }

module StatHat
  module Json
  end
end
