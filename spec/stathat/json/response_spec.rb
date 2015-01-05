require 'spec_helper'
require 'stathat/json/response'
require 'multi_json'
module StatHat
  module Json
    describe Response do
      let(:ok_200) { MultiJson.dump({status: 200, msg: 'ok', multiple: 10}) }
      let(:error_500) { MultiJson.dump({status: 500, msg: 'no stat'}) }

      it 'parses a 200 response' do

        response = Response.new(ok_200)

        expect(response.status).to eq 200
        expect(response.message).to eq 'ok'
        expect(response.multiple).to eq 10

      end

      it 'parses a 500 response' do
        response = Response.new(error_500)

        expect(response.status).to eq 500
        expect(response.message).to eq 'no stat'

      end
    end
  end
end