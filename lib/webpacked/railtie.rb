require "rails"
require "rails/railtie"
require "webpacked/manifest"
require "webpacked/helper"
require "webpacked/controller_helper"

module Webpacked
  class Railtie < ::Rails::Railtie

    config.webpacked = ActiveSupport::OrderedOptions.new

    config.webpacked.enabled = true
    config.webpacked.manifest_path = "webpack-assets.json"
    config.webpacked.load_manifest_on_initialize = true
    config.webpacked.common_entry_name = "common"

    initializer "webpacked.load_manifest" do |app|
      Webpacked::Manifest.load_manifest! if Rails.configuration.webpacked.load_manifest_on_initialize
    end

    config.after_initialize do
      ActiveSupport.on_load(:action_view) do
        include Webpacked::Helper
      end
    end
  end
end
