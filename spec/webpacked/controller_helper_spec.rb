require "spec_helper"

describe Webpacked::ControllerHelper do

  class FooController < DummyApplicationController
    webpacked_entry "foo"
  end

  class BarController < DummyApplicationController
    webpacked_entry "bar"
  end

  it "assign webpacked entry name to specific controller" do
    expect(FooController.webpacked_entry_name).to eq("foo")
    expect(BarController.webpacked_entry_name).to eq("bar")
  end
end
