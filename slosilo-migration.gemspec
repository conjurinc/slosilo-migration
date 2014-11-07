# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slosilo/migration/version'

Gem::Specification.new do |spec|
  spec.name          = "slosilo-migration"
  spec.version       = Slosilo::Migration::VERSION
  spec.authors       = ["Kevin Gilpin"]
  spec.email         = ["kgilpin@gmail.com"]
  spec.summary       = %q{Slosilo v1-compatible migration helper.}
  spec.homepage      = "https://github.com/conjurinc/slosilo-migration"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
