module Webpacked
  class Manifest
    ASSET_KINDS = [:js, :css]

    class LoadError < StandardError
    end

    class UnknownAssetKindError < StandardError
      def initialize(kind)
        super "Unknown asset kind: #{kind}"
      end
    end

    class EntryMissingError < StandardError
      def initialize(entry)
        super "Entry point is missed: #{entry}"
      end
    end

    class << self

      def asset_paths(entry, kind)
        validate_asset_kind(kind)
        if Rails.configuration.webpacked.dev_server
          @manifest = load_manifest!
        else
          @manifest ||= load_manifest!
        end
        validate_entry(entry)
        @manifest[entry][kind] if @manifest[entry]
      end

      def load_manifest!
        assets_manifest = Rails.root.join(Rails.configuration.webpacked.manifest_path)
        manifest = {}
        if File.exist?(assets_manifest)
          manifest = JSON.parse(File.read assets_manifest).with_indifferent_access
          clean_asset_paths(manifest)
        else
          raise LoadError.new("File #{assets_manifest} not found") if Rails.configuration.webpacked.enabled
        end
        manifest
      end

      private

      def validate_asset_kind(kind)
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
            manifest[entry][kind] = if asset_path =~ /(http[s]?):\/\//i
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
