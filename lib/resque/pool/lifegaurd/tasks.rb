require 'resque/tasks'
require 'resque/pool/tasks'
require 'resque/pool/lifegaurd'

namespace :resque do

  namespace :pool do
     # resque pool config.  e.g. after_prefork connection handling
    task :lifegaurd do
      defaults = FileOrHashLoader.new
      Resque::Pool.config_loader = Resque::Pool::Lifegaurd.new defaults: defaults
      Resque::Pool.procline "Resque Pool Lifegaurd on Duty"
    end

    task setup: :lifegaurd

  end

end
