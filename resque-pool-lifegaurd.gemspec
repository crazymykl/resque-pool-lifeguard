# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resque/pool/lifegaurd/version'

Gem::Specification.new do |spec|
  spec.name          = "resque-pool-lifegaurd"
  spec.version       = Resque::Pool::Lifegaurd::VERSION
  spec.authors       = ["Mike MacDonald"]
  spec.email         = ["crazymykl@gmail.com"]

  spec.summary       = %q{Adds live GUI queue/worker management to resque-pool}
  spec.homepage      = "https://github.com/crazymykl/resque-pool-lifegaurd"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "resque", "~> 1.22"
  spec.add_dependency "resque-pool", "~> 0.6.0"
  spec.add_dependency "rake"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
