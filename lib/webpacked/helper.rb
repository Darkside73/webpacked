module Webpacked
  module Helper
    def webpacked_js_tags(entry)
      webpacked_tags :js, entry
    end

    def webpacked_css_tags(entry)
      webpacked_tags :css, entry
    end

    def webpacked_tags(kind, entry)
      common_entry = ::Rails.configuration.webpacked.common_entry_name
      common_bundle = asset_tag(kind, common_entry)
      page_bundle   = asset_tag(kind, entry)
      common_bundle ? common_bundle + page_bundle : page_bundle
    end

    def asset_tag(kind, entry)
      path = webpacked_asset_path(kind, entry)
      case kind
      when :js  then javascript_include_tag path
      when :css then stylesheet_link_tag    path
      end
    end

    def webpacked_asset_path(kind, entry)
      Webpacked::Manifest.asset_paths(kind, entry)
    end
  end
end
