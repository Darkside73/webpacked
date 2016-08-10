require "spec_helper"

describe Webpacked::Manifest do
  let(:manifest) do
    <<-EOF
      {
        "common": {
          "js": "/assets/webpack/bundle-common.js",
          "css": "/./assets/webpack/bundle-common.css"
        },
        "main_page": {
          "js": "/assets/webpack/bundle-main_page.js",
          "css": "/assets/webpack/bundle-main_page.css"
        }
      }
    EOF
  end

  context "when manifest file exists" do
    before do
      manifest_path = ::Rails.root.join("webpack-assets.json")
      allow(File).to receive(:exist?).with(manifest_path).and_return(true)
      allow(File).to receive(:read).with(manifest_path).and_return(manifest)
    end

    describe "#asset_paths" do
      it "load assets" do
        expect(Webpacked::Manifest.asset_paths "common", :js)
          .to eq("/assets/webpack/bundle-common.js")
        expect(Webpacked::Manifest.asset_paths "common", :css)
          .to eq("/assets/webpack/bundle-common.css")
      end

      context "when entry point is missed" do
        it "raise error" do
          expect { Webpacked::Manifest.asset_paths "missed", :js }
            .to raise_error(Webpacked::Manifest::EntryMissingError)
        end
      end

      context "when unknown asset kind" do
        it "raise error" do
          expect { Webpacked::Manifest.asset_paths "common", :png }
            .to raise_error(Webpacked::Manifest::UnknownAssetKindError)
        end
      end
    end
  end

end
