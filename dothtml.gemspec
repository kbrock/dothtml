# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dothtml/version'

Gem::Specification.new do |spec|
  spec.name          = "dothtml"
  spec.version       = Dothtml::VERSION
  spec.authors       = ["Keenan Brock"]
  spec.email         = ["keenan@thebrocks.net"]
  spec.summary       = %q{Make conversion of dot to html easier}
  spec.description   = %q{Make conversion of dot to html easier}
  spec.homepage      = "http://github.com/kbrock/dothtml"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'guard'
  spec.add_dependency 'guard-rake'
  spec.add_dependency 'nokogiri'
  # possibly remove this
  spec.add_dependency 'tilt'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
