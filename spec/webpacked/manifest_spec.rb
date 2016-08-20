require 'spec_helper'

describe Webpacked::Manifest do
  context 'when manifest file exists' do
    let(:manifest_path) { 'spec/fixtures/regular_manifest.json' }
    before do
      Rails.configuration.webpacked.manifest_path = manifest_path
    end

    describe '.asset_paths' do
      it 'return js or css asset path for given entry' do
        expect(Webpacked::Manifest.asset_paths 'common', :js)
          .to eq('/assets/webpack/bundle-common.js')
        expect(Webpacked::Manifest.asset_paths 'common', :css)
          .to eq('/assets/webpack/bundle-common.css')
      end

      it 'return js and css asset paths for given entry' do
        expect(Webpacked::Manifest.asset_paths 'common')
          .to include(css: '/assets/webpack/bundle-common.css')
        expect(Webpacked::Manifest.asset_paths 'common')
          .to include(js: '/assets/webpack/bundle-common.js')
      end

      context 'when entry point is missed' do
        it 'raise error' do
          expect { Webpacked::Manifest.asset_paths 'missed', :js }
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

      context 'when unknown asset kind' do
        it 'raise error' do
          expect { Webpacked::Manifest.asset_paths 'common', :png }
            .to raise_error(Webpacked::Manifest::UnknownAssetKindError)
        end
      end
    end
  end

  context 'when manifest file does not exist' do
    let(:manifest_path) { 'not/exists.json' }
    before do
      Rails.configuration.webpacked.manifest_path = manifest_path
    end
    describe '.load_manifest!' do
      it 'raise error' do
        expect { Webpacked::Manifest.load_manifest! }
          .to raise_error(Webpacked::Manifest::LoadError)
      end
    end
  end
end
