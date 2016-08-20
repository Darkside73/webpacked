module Webpacked
  # Webpack manifest loading, caching and entry point retrieval
  class Manifest
    ASSET_KINDS = [:js, :css]

    # Raised if webpack manifest not readable for whatever reason
    class LoadError < StandardError
    end

    # Raised if something but +:js+ or +:css+ passed as asset kind
    class UnknownAssetKindError < StandardError
      def initialize(kind)
        super "Unknown asset kind: #{kind}"
      end
    end

    # Raised if an entry point does not exist in the webpack manifest
    class EntryMissingError < StandardError
      def initialize(entry)
        super "Entry point is missed: #{entry}"
      end
    end

    class << self
      # Load manifest from file and cache it if +Rails.configuration.webpacked.dev_server+ set to +false+.
      # Return entry point asset path for +:js+ or +:css+ kind or both if +kind+ skipped
      def asset_paths(entry, kind = nil)
        validate_asset_kind(kind)
        if Rails.configuration.webpacked.dev_server
          @manifest = load_manifest!
        else
          @manifest ||= load_manifest!
        end
        validate_entry(entry)

        return @manifest[entry] unless kind
        return @manifest[entry][kind] if @manifest[entry]
      end

      # Force to load manifest from file
      def load_manifest!
        manifest_path = Rails.configuration.webpacked.manifest_path
        manifest_path = Rails.root.join(manifest_path)
        manifest = {}
        if File.exist?(manifest_path)
          manifest = JSON.parse(File.read manifest_path).with_indifferent_access
          clean_asset_paths(manifest)
        elsif Rails.configuration.webpacked.enabled
          raise LoadError, "File #{manifest_path} not found"
        end
        manifest
      end

      private

      def validate_asset_kind(kind)
        return unless kind
        raise UnknownAssetKindError, kind unless ASSET_KINDS.include?(kind)
      end

      def validate_entry(entry)
        unless entry == Rails.configuration.webpacked.common_entry_name
          raise EntryMissingError, entry unless @manifest[entry]
        end
      end

      def clean_asset_paths(manifest)
        manifest.each do |entry, assets|
          assets.each do |kind, asset_path|
            manifest[entry][kind] = if asset_path =~ %r{(http[s]?)://}i
              asset_path
            else
              Pathname.new(asset_path).cleanpath.to_s
            end
          end
        end
      end
    end
  end
end
