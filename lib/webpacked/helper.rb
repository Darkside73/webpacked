module Webpacked
  module Helper
    def webpacked_js_tags(entry)
      webpacked_tags entry, :js
    end

    def webpacked_css_tags(entry)
      webpacked_tags entry, :css
    end

    def webpacked_tags(entry, kind)
      common_entry = ::Rails.configuration.webpacked.common_entry_name
      common_bundle = asset_tag(common_entry, kind)
      page_bundle   = asset_tag(entry, kind)
      common_bundle ? common_bundle + page_bundle : page_bundle
    end

    def asset_tag(entry, kind)
      path = webpacked_asset_path(entry, kind)
      case kind
      when :js  then javascript_include_tag path
      when :css then stylesheet_link_tag    path
      end
    end

    def webpacked_asset_path(entry, kind)
      Webpacked::Manifest.asset_paths(entry, kind)
    end
  end
end
