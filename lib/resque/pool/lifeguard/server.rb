require 'resque/server'
require 'resque/pool/lifeguard'

module Resque
  class Pool
    class Lifeguard
      module Server
        VIEW_PATH = File.join(__dir__, 'server', 'views')

        def self.registered app
          app.get '/pools' do
            pools_view
          end

          app.post '/pools/:host' do
            host, queues, count = params.values_at(*%i[host queues count])

            Lifeguard.new(hostname: host)[queues] = Integer(count)
            redirect u :pools
          end

          app.get "/pools.poll" do
            content_type "text/plain"
            @polling = true

            pools_view layout: false
          end

          app.helpers do
            def pools_view(options = {}, locals = {})
              erb File.read(File.join VIEW_PATH, "pool.erb"), options, locals
            end
          end

          app.tabs << 'Pools'
        end

      end

      Resque::Server.register Server
    end
  end
end
