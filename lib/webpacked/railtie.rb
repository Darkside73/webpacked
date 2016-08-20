require 'rails'
require 'rails/railtie'
require 'webpacked/manifest'
require 'webpacked/helper'
require 'webpacked/controller_helper'

module Webpacked
  class Railtie < ::Rails::Railtie
    config.webpacked = ActiveSupport::OrderedOptions.new

    config.webpacked.enabled = true
    config.webpacked.manifest_path = 'webpack-assets.json'
    config.webpacked.load_manifest_on_initialize = false
    config.webpacked.common_entry_name = 'common'
    config.webpacked.bin = 'node_modules/.bin/webpack'
    config.webpacked.config = 'frontend/main.config.js'
    config.webpacked.dev_server = Rails.env.development?

    initializer 'webpacked.load_manifest' do
      Webpacked::Manifest.load_manifest! if Rails.configuration.webpacked.load_manifest_on_initialize
    end

    config.after_initialize do
      ActiveSupport.on_load(:action_view) do
        include Webpacked::Helper
      end
    end
  end
end
