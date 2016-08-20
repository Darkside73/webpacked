require 'rails'
require 'webpacked'

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
    "js: #{path}"
  end

  def stylesheet_link_tag(path)
    "css: #{path}"
  end
end

class DummyApplicationController
  include Webpacked::ControllerHelper

  def self.helper_method(*)
  end
end

Rails.application.initialize!
