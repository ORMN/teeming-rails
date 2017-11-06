require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TeemingMembers
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    # config.api_only = false
    config.autoload_paths += %W(#{config.root}/lib #{config.root}/app/lib #{config.root}/app/actions)

    config.time_zone = 'Central Time (US & Canada)'
    config.active_record.default_timezone = :utc

    config.active_job.queue_adapter = :sidekiq
  end
end

