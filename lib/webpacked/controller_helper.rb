module Webpacked
  # Mixin for Rails controllers
  module ControllerHelper
    extend ActiveSupport::Concern

    # :nodoc:
    module ClassMethods
      # Mix in controller's class method to set up an entry point name
      # and reveal +webpacked_entry_name+ helper to get this name in view
      def webpacked_entry(name)
        helper_method :webpacked_entry_name
        cattr_accessor :webpacked_entry_name

        self.webpacked_entry_name = name
      end
    end
  end
end
