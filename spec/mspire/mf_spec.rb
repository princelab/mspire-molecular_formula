require 'spec_helper'

require 'mspire/mf'

describe 'require "mspire/mf" to get Mspire::MF shorthand' do
  specify 'Mspire::MF allows convenient access to MolecularFormula stuff' do
    product = Mspire::MF['H2O'] + Mspire::MF['C2H4']
    Mspire::MF['H2O+'].mass.should == 18.010016083700002
  end
end
