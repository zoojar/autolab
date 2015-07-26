require 'spec_helper'
describe 'autolab' do

  context 'with defaults for all parameters' do
    it { should contain_class('autolab') }
  end
end
