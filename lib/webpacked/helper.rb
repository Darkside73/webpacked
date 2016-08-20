module Webpacked
  # Add new view helpers
  module Helper
    # Return +javascript_include_tag+ for entry point.
    # Also common Javascript file could be included
    def webpacked_js_tags(entry)
      webpacked_tags entry, :js
    end

    # Return +stylesheet_link_tag+ for entry point.
    # Also common CSS file could be included
    def webpacked_css_tags(entry)
      webpacked_tags entry, :css
    end

    # Return include tags for entry point by given asset kind.
    # Also common file could be included
    def webpacked_tags(entry, kind)
      common_entry = ::Rails.configuration.webpacked.common_entry_name
      common_bundle = asset_tag(common_entry, kind)
      page_bundle   = asset_tag(entry, kind)
      common_bundle ? common_bundle + page_bundle : page_bundle
    end

    # Return include tags for entry point by given asset kind.
    # No extra common file included even if it exists
    def asset_tag(entry, kind)
      path = webpacked_asset_path(entry, kind)
      if path
        case kind
        when :js  then javascript_include_tag path
        when :css then stylesheet_link_tag    path
        end
      end
    end

    # Alias for Webpacked::Manifest.asset_paths
    def webpacked_asset_path(entry, kind = nil)
      Webpacked::Manifest.asset_paths(entry, kind)
    end
  end
end
