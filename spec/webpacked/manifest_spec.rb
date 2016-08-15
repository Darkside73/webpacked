require "spec_helper"

describe Webpacked::Manifest do

  context "when manifest file exists" do
    let(:manifest_path) { 'spec/fixtures/regular_manifest.json' }
    before do
      Rails.configuration.webpacked.manifest_path = manifest_path
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

        context "when entry is 'common'" do
          let(:manifest_path) { 'spec/fixtures/manifest_without_common_entry.json' }
          it 'do not raise error' do
            common_name = Rails.configuration.webpacked.common_entry_name
            expect(Webpacked::Manifest.asset_paths common_name, :js).to be_nil
          end
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
