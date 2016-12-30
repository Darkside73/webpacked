require 'spec_helper'

describe Webpacked::Helper do
  before do
    @common = 'common'
    Rails.configuration.webpacked.common_entry_name = @common
  end

  let(:helper) { Class.new { extend DummyApplicationHelper } }

  describe '.webpacked_js_tags' do
    let(:entry) { 'main_page' }
    let(:js_common_path) { '/path/to/common.js' }
    let(:js_other_path) { '/path/to/main.js' }
    before { allow(Webpacked::Manifest).to receive(:asset_paths).with(@common, :js).and_return(js_common_path) }
    it 'return js script tags including common entry' do
      allow(Webpacked::Manifest).to receive(:asset_paths).with(entry, :js).and_return(js_other_path)
      expect(helper.webpacked_js_tags entry).to include(js_other_path, js_common_path)
    end

    context 'multiple entries' do
      let(:entries) { ['vendor', 'main_page'] }
      let(:js_other_paths) { ['/path/to/vendor.js', '/path/to/main.js'] }
      it 'return js scripts tags for multiple entries' do
        allow(Webpacked::Manifest).to receive(:asset_paths).with(entries[0], :js).and_return(js_other_paths[0])
        allow(Webpacked::Manifest).to receive(:asset_paths).with(entries[1], :js).and_return(js_other_paths[1])
        expect(helper.webpacked_js_tags entries).to include(js_other_paths[0], js_other_paths[1])
      end
    end
  end

  describe '.webpacked_css_tags' do
    let(:entry) { 'main_page' }
    let(:css_common_path) { '/path/to/common.css' }
    let(:css_other_path) { '/path/to/main.css' }
    it 'return css stylesheet link tags including common entry' do
      allow(Webpacked::Manifest).to receive(:asset_paths).with(entry, :css).and_return(css_other_path)
      allow(Webpacked::Manifest).to receive(:asset_paths).with(@common, :css).and_return(css_common_path)

      expect(helper.webpacked_css_tags entry)
        .to include(css_other_path, css_common_path)
    end
  end

  describe '.asset_tag' do
    context 'when common entry is missed' do
      it 'return nil' do
        allow(Webpacked::Manifest).to receive(:asset_paths).with(@common, :css).and_return(nil)
        expect(helper.asset_tag @common, :css).to be_nil
      end
    end
  end

  describe '.webpacked_asset_path' do
    let(:entry) { 'main_page' }
    let(:kind) { :js }
    let(:path) { '/path/to/main.js' }
    it 'return asset path for entry' do
      allow(Webpacked::Manifest).to receive(:asset_paths).with(entry, kind).and_return(path)

      expect(helper.webpacked_asset_path entry, kind).to eq(path)
    end
  end
end
