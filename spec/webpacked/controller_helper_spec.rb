require 'spec_helper'

describe Webpacked::ControllerHelper do
  class FooController < DummyApplicationController
    webpacked_entry 'foo'
  end

  class BarController < DummyApplicationController
    webpacked_entry ['bar']
  end

  class BazController < DummyApplicationController
  end

  it 'assign webpacked entry name to specific controller' do
    expect(FooController.webpacked_entry_name).to eq('foo')
    expect(BarController.webpacked_entry_name).to eq(['bar'])
  end

  context 'when entry not defined in controller' do
    it 'take entry name from parent controller' do
      expect(BazController.webpacked_entry_name).to eq('app')
    end
  end
end
