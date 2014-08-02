require 'spec_helper'

require 'mspire/molecular_formula/aa'

describe Mspire::MolecularFormula::AA do
  specify '::FORMULAS_STRING holds molecular formulas keyed by AA string' do
    hash = Mspire::MolecularFormula::AA::FORMULAS_STRING
    hash.size.should == 22
    hash.values.each {|mf| mf.should be_a(Mspire::MolecularFormula) }
    hash.values.first.to_h.should == { :C=>3, :H=>5, :O=>1, :N=>1 }
    hash['A'].to_h.should == { :C=>3, :H=>5, :O=>1, :N=>1 }
    hash.keys.all? {|key| key.is_a?(String) }.should be_true
  end

  specify '::formulas returns them by symbol or string  or both (symbol by default)' do
    hash = Mspire::MolecularFormula::AA.formulas
    hash.size.should == 22
    hash.values.each {|mf| mf.should be_a(Mspire::MolecularFormula) }
    hash.values.first.to_h.should == { :C=>3, :H=>5, :O=>1, :N=>1 }
    hash.keys.all? {|key| key.is_a?(Symbol) }.should be_true
    hash[:A].to_h.should == { :C=>3, :H=>5, :O=>1, :N=>1 }

    hash = Mspire::MolecularFormula::AA.formulas(by: :string)
    hash.keys.all? {|key| key.is_a?(String) }.should be_true
    hash['A'].to_h.should == { :C=>3, :H=>5, :O=>1, :N=>1 }

    hash = Mspire::MolecularFormula::AA.formulas(by: :both)
    hash.keys.any? {|key| key.is_a?(Symbol) }.should be_true
    hash.keys.any? {|key| key.is_a?(String) }.should be_true
    hash['A'].to_h.should == { :C=>3, :H=>5, :O=>1, :N=>1 }
    hash[:A].to_h.should == { :C=>3, :H=>5, :O=>1, :N=>1 }
  end
end
