# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resque/pool/lifeguard/version'

Gem::Specification.new do |spec|
  spec.name          = "resque-pool-lifeguard"
  spec.version       = Resque::Pool::Lifeguard::VERSION
  spec.authors       = ["Mike MacDonald"]
  spec.email         = ["crazymykl@gmail.com"]

  spec.summary       = %q{Adds live GUI queue/worker management to resque-pool}
  spec.homepage      = "https://github.com/crazymykl/resque-pool-lifeguard"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 3.0.4'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "resque", "~> 2.4.0"
  spec.add_dependency "resque-pool", "~> 0.7.1"
  spec.add_dependency "rake"
  spec.add_development_dependency "bundler", ">= 2.3.19"
  spec.add_development_dependency "rspec", "~> 3.11.0"
  spec.add_development_dependency "simplecov", "~> 0.21.2"
  spec.add_development_dependency "fakeredis", "~> 0.1.4"
end
