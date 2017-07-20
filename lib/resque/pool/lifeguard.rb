require 'resque/pool'
require "resque/pool/lifeguard/version"

module Resque
  class Pool
    class Lifeguard
      include Logging

      def initialize hostname: Socket.gethostname, defaults: -> (_env) { {} }
        @defaults = defaults
        @hostname = hostname
      end

      def self.pool_key
        'resque-pool-lifeguard'
      end

      def self.all_pools
        all = Resque.redis.hgetall pool_key
        all.map { |k, v|
          [k, Resque.decode(v)]
        }.to_h
      rescue Resque::Helpers::DecodeException
        reset!
        {}
      end

      def self.reset!
        Resque.redis.del pool_key
      end

      def self.reset_empty!
        used_hosts = Resque.workers.map(&:hostname).uniq

        (all_pools.keys - used_hosts).each do |host|
          new(hostname: host).reset!
        end
      end

      def call env
        @values = values || set_defaults(env)
      end

      def reset!
        Resque.redis.hdel pool_key, hostname
      end

      def values
        Resque.decode Resque.redis.hget pool_key, hostname
      rescue Resque::Helpers::DecodeException
        reset!
        nil
      rescue Redis::TimeoutError, Redis::CannotConnectError
        log "Could not get config from redis"
        @values
      end

      def values= values
        Resque.redis.hset pool_key, hostname, (Resque.encode values)
      end

      def [] queues
        values.to_h[queues]
      end

      def []= queues, count
        self.values = if count.zero?
          values.to_h.tap do |vals| vals.delete queues end
        else
          values.to_h.merge queues => count
        end
      end

      private
      attr_reader :defaults
      attr_reader :hostname

      def pool_key
        self.class.pool_key
      end

      def set_defaults env
        self.values = defaults.(env)
      end

    end
  end
end
