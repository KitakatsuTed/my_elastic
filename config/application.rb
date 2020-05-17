require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MyElastic
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.generators.system_tests = nil

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', 'models', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ja
    config.active_job.queue_adapter = :sidekiq
    config.active_record.default_timezone = :local

    config.time_zone = 'Asia/Tokyo'
    config.generators do |g|
      g.stylesheets     false
      g.javascripts     false
      g.jbuilder        false
      g.helper          false
      g.coffee          false
      g.test_framework :rspec,
                       fixture: true,
                       fixture_replacement: :factory_bot,
                       controller_specs: false,
                       view_specs: false,
                       routing_specs: false,
                       helper_specs: false,
                       integration_tool: false
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
