require 'spec_helper'

require 'mspire/molecular_formula'

MF = Mspire::MolecularFormula
describe Mspire::MolecularFormula do

  describe 'initialization' do

    it 'is initialized with Hash' do
      data = {H: 22, C: 12, N: 1, O: 3, S: 2}
      mf = MF.new(data)
      mf.to_h.should == {:H=>22, :C=>12, :N=>1, :O=>3, :S=>2}
      mf.to_h.should == data
    end

    it 'can be initialized with charge, too' do
      mf = MF["H22BeC12N1O3S2Li2", 2]
      mf.to_h.should == {:H=>22, :Be=>1, :C=>12, :N=>1, :O=>3, :S=>2, :Li=>2}
      mf.charge.should == 2
    end

    it 'from_string or ::[] to make from a capitalized string formula' do
      MF.from_string("H22BeC12N1O3S2Li2").to_h.should == {:H=>22, :Be=>1, :C=>12, :N=>1, :O=>3, :S=>2, :Li=>2}

      mf = MF['Ni7Se3', 1]
      mf.charge.should == 1
      mf.to_h.should == {:Ni=>7, :Se=>3}

      # there is no such thing as the E element, so this is going to get the
      # user in trouble.  However, this is the proper interpretation of the
      # formula.
      mf = MF['Ni7SE3']
      mf.charge.should == 0
      mf.to_h.should == {:Ni=>7, :S=>1, :E=>3}
    end

    it 'from_string or ::[] to make from a capitalized string formula with charge attached' do
      mf = MF.from_string("H22BeC12N1O3S2Li2+")
      mf.charge.should == 1
      mf.to_h.should == {:H=>22, :Be=>1, :C=>12, :N=>1, :O=>3, :S=>2, :Li=>2}

      mf = MF.from_string("H22BeC12N1O3S2Li2++++")
      mf.charge.should == 4
      mf.to_h.should == {:H=>22, :Be=>1, :C=>12, :N=>1, :O=>3, :S=>2, :Li=>2}

      mf = MF.from_string("H22BeC12N1O3S2Li2+4")
      mf.charge.should == 4
      mf.to_h.should == {:H=>22, :Be=>1, :C=>12, :N=>1, :O=>3, :S=>2, :Li=>2}

      mf = MF.from_string("H22BeC12N1O3S2Li2-")
      mf.charge.should == -1 
      mf.to_h.should == {:H=>22, :Be=>1, :C=>12, :N=>1, :O=>3, :S=>2, :Li=>2}

      mf = MF.from_string("H22BeC12N1O3S2Li2-3")
      mf.charge.should == -3
      mf.to_h.should == {:H=>22, :Be=>1, :C=>12, :N=>1, :O=>3, :S=>2, :Li=>2}
    end
  end

  describe 'conversion (to_s and to_h)' do

    subject {
      data = {H: 22, C: 12, N: 1, O: 3, S: 2, Be: 1}
      MF.new(data)
    }

    specify '#to_s a standard molecular formula, alphabetized by default' do
      subject.to_s.should == "BeC12H22NO3S2"
    end

    specify '#to_s contains the charge by default' do
      subject.charge = 3
      subject.to_s.should == "BeC12H22NO3S2+3"
      subject.charge = -3
      subject.to_s.should == "BeC12H22NO3S2-3"
    end

    specify '#to_s(false) turns off charge' do
      subject.charge = 3
      subject.to_s(false).should == "BeC12H22NO3S2"
      subject.charge = -3
      subject.to_s(false).should == "BeC12H22NO3S2"
    end

    specify '#to_s(true, false) does not sort' do
      subject.charge = 2
      subject.to_s(true, false) == "H22C12NO3S2Be+2"
    end

    specify '#to_h converts to a hash' do
      subject.charge = 2
      subject.to_h.should == {H: 22, C: 12, N: 1, O: 3, S: 2, Be: 1}
    end
  end

  describe 'equality' do
    subject {
      data = {H: 22, C: 12, N: 1, O: 3, S: 2, Be: 1}
      MF.new(data)
    }
    it 'is only equal if the charge is equal' do
      another = subject.dup
      another.should == subject
      another.charge = 2
      another.should_not == subject
    end
  end

  describe 'arithmetic' do
    subject {
      data = {H: 22, C: 12, N: 1, O: 3, S: 2, Be: 1}
      MF.new(data, 2)
    }
    it 'can do non-destructive arithmetic' do
      orig = subject.dup
      reply = subject + MF["H2C3P2", 2]
      reply.to_h.should == {H: 24, C: 15, N: 1, O: 3, S: 2, Be: 1, P: 2}
      reply.charge.should == 4
      subject.should == orig

      reply = subject - MF["H2C3P2", 2]
      reply.to_h.should == {H: 20, C: 9, N: 1, O: 3, S: 2, Be: 1, P: -2}
      reply.charge.should == 0
      subject.should == orig

      by2 = subject * 2
      by2.to_h.should == {H: 44, C: 24, N: 2, O: 6, S: 4, Be: 2}
      by2.charge.should == 4
      subject.should == orig

      reply = by2 / 2
      reply.to_h.should == {H: 22, C: 12, N: 1, O: 3, S: 2, Be: 1}
      reply.charge.should == 2
      subject.should == orig
    end

    it 'can do destructive arithmetic' do
      orig = subject.dup
      subject.sub!(MF["H2C3"]).to_h.should == {H: 20, C: 9, N: 1, O: 3, S: 2, Be: 1}
      subject.should_not == orig
      subject.add!(MF["H2C3"]).to_h.should == {H: 22, C: 12, N: 1, O: 3, S: 2, Be: 1}
      subject.should == orig

      by2 = subject.mul!(2)
      subject.should_not == orig
      by2.to_h.should == {H: 44, C: 24, N: 2, O: 6, S: 4, Be: 2}
      by2.div!(2).to_h.should == {H: 22, C: 12, N: 1, O: 3, S: 2, Be: 1}
      by2.to_h.should == orig
    end

  end

  describe 'reading in a formula and charge from a string' do
    subject { MF }
    specify 'Mspire::MolecularFormula.formula_and_charge' do
      subject.formula_and_charge( 'C2H4+3' ).should == ['C2H4', 3]
      subject.formula_and_charge( 'C2H4+++' ).should == ['C2H4', 3]
      subject.formula_and_charge( 'C2H4-').should == ['C2H4', -1]
      subject.formula_and_charge( 'C2H4-2').should == ['C2H4', -2]
    end
  end

  describe 'mass and mz' do
    # (for all these, checked to make sure in close ballpark, but not
    # necessarily exact, unless otherwise stated)

    before do
      @exact = 65.02654910101
      @avg = 65.07332
      @e = 0.0005486  # set with -> Mspire::Mass::ELECTRON
      @exact_plus_2e = @exact + (2*@e)
    end

    subject {
      data = {H: 3, C: 4, N: 1}
      MF.new(data, -2)
    }

    specify '#mass (of an uncharged molecule) -> the exact mass' do
      subject.charge = 0
      subject.mass.should == @exact # BMRB databank says: 65.0265491015
    end

    specify '#mass -> the exact mass (adjusts for electrons)' do
      subject.mass.should == @exact_plus_2e
    end

    specify '#mass (no charge adjustment)' do
      subject.mass(false).should == @exact  # BMRB databank says: 65.0265491015
    end

    specify '#avg_mass' do
      subject.avg_mass.should == (@avg + 2*@e)
      # changes the value
      subject.charge = 0
      subject.avg_mass.should == @avg  # BMRB databank says: 65.073320
    end

    specify '#mz -> the m/z ratio' do
      subject.mz.should == (@exact_plus_2e / -2.0)
      subject.charge = +2
      subject.mz.should == ((@exact - 2*@e) / 2.0)
    end

    specify '#mz(true, false) will only yield positive m/z ratio' do
      subject.mz(true, false).should == (@exact_plus_2e / 2.0)
    end

    specify '#mz(false, true) will not consider electrons in mass determination' do
      subject.mz(false, true).should == (@exact / -2.0)
    end
  end

end
