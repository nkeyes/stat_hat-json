# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stathat/json/version'

Gem::Specification.new do |spec|
  spec.name          = 'stathat-json'
  spec.version       = StatHat::Json::VERSION
  spec.authors       = ['Nathan Keyes']
  spec.email         = ['nkeyes@gmail.com']
  spec.summary       = %q{StatHat JSON API Client.}
  spec.description   = %q{StatHat JSON API Client.}
  spec.homepage      = 'https://github.com/nkeyes/stathat-json'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'simplecov', '~> 0.9'


  spec.add_dependency 'celluloid-io', '~> 0.16'
  spec.add_dependency 'faraday', '~> 0.9'
  spec.add_dependency 'multi_json', '~> 1.10'
  spec.add_dependency 'net-http-persistent', '~> 2.9'
end
