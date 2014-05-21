# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'skr/api/version'

Gem::Specification.new do |spec|
    spec.name          = "skr-api"
    spec.version       = Skr::API::VERSION
    spec.authors       = ["Nathan Stitt"]
    spec.email         = ["nathan@stitt.org"]
    spec.summary       = %q{Stockor API is a REST API for the Stockor ERP system}
    spec.description   = %q{Stockor API is a REST API for the Stockor ERP system. } +
                         %q{It exposes the models and business logic defined in Skr::Core.}

    spec.homepage      = "http://stockor.org/"
    spec.license       = "GPL-3.0"

    spec.files         = `git ls-files`.split($/)
    spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
    spec.test_files    = spec.files.grep(%r{^test/})

    spec.require_paths = ["lib"]

    spec.add_dependency "grape", '~> 0.7.0'
    spec.add_dependency "grape-entity", '~> 0.4.2'

    spec.add_development_dependency "bundler", "~> 1.5"
    spec.add_development_dependency "rake"
    spec.add_development_dependency "guard"
    spec.add_development_dependency "guard-rack"
    spec.add_development_dependency "guard-minitest"
    spec.add_development_dependency "rack-test"

    spec.add_development_dependency "growl"
    spec.add_development_dependency "pry-plus"

end
