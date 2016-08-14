require "spec_helper"

describe Webpacked::Helper do
  before do
    @common = "common"
    Rails.configuration.webpacked.common_entry_name = @common
  end

  let(:helper) { Class.new { extend DummyApplicationHelper } }

  describe ".webpacked_js_tags" do
    let(:entry) { "main_page" }
    let(:js_common_path) { "/path/to/common.js" }
    let(:js_other_path) { "/path/to/main.js" }
    it "return js script tags including common entry" do
      allow(Webpacked::Manifest).to receive(:asset_paths).with(:js, entry).and_return(js_other_path)
      allow(Webpacked::Manifest).to receive(:asset_paths).with(:js, @common).and_return(js_common_path)

      expect(helper.webpacked_js_tags entry)
        .to include(js_other_path, js_common_path)
    end
  end

  describe ".webpacked_css_tags" do
    let(:entry) { "main_page" }
    let(:css_common_path) { "/path/to/common.css" }
    let(:css_other_path) { "/path/to/main.css" }
    it "return css stylesheet link tags including common entry" do
      allow(Webpacked::Manifest).to receive(:asset_paths).with(:css, entry).and_return(css_other_path)
      allow(Webpacked::Manifest).to receive(:asset_paths).with(:css, @common).and_return(css_common_path)

      expect(helper.webpacked_css_tags entry)
        .to include(css_other_path, css_common_path)
    end
  end

  describe ".webpacked_asset_path" do
    let(:entry) { "main_page" }
    let(:kind) { :js }
    let(:path) { "/path/to/main.js" }
    it "return asset path for entry" do
      allow(Webpacked::Manifest).to receive(:asset_paths).with(kind, entry).and_return(path)

      expect(helper.webpacked_asset_path kind, entry).to eq(path)
    end
  end
end