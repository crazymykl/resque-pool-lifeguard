$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'fakeredis/rspec'

require 'simplecov'
SimpleCov.start

require 'resque/pool/lifeguard'
