module Webpacked
  module ControllerHelper
    extend ActiveSupport::Concern

    module ClassMethods
      def webpacked_entry(name)
        helper_method :webpacked_entry_name
        cattr_accessor :webpacked_entry_name

        self.webpacked_entry_name = name
      end
    end
  end
end
