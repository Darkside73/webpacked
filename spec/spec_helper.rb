require "rails"
require "webpacked"

module DummyApplication
  # :nodoc:
  class Application < Rails::Application
    config.eager_load = false
    config.webpacked.load_manifest_on_initialize = false
  end
end

module DummyApplicationHelper
  include Webpacked::Helper

  def javascript_include_tag(path)
    path
  end

  def stylesheet_link_tag(path)
    path
  end
end

class DummyApplicationController
  include Webpacked::ControllerHelper

  def self.helper_method(*args)
  end
end

Rails.application.initialize!
