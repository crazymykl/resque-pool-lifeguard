require 'resque/tasks'
require 'resque/pool/tasks'
require 'resque/pool/lifeguard'

namespace :resque do

  namespace :pool do
     # resque pool config.  e.g. after_prefork connection handling
    task :lifeguard do
      defaults = Resque::Pool::ConfigLoaders::FileOrHashLoader.new
      Resque::Pool.config_loader = Resque::Pool::Lifeguard.new(defaults: defaults)
      Resque::Pool.log "Resque Pool Lifeguard on Duty"
    end

    task setup: :lifeguard
  end
end
