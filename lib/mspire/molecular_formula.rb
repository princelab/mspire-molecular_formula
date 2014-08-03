module Mspire
  class MolecularFormula < Hash

    # integer desribing the charge state
    # mass calculations will add/remove electron mass from this
    attr_accessor :charge

    # Takes a hash and an optional Integer expressing the charge
    #     {H: 22, C: 12, N: 1, O: 3, S: 2}  # case and string/sym doesn't matter
    def initialize(hash={}, charge=0)
      @charge = charge
      self.merge!(hash)
    end

    def to_s(include_charge_if_nonzero=true, alphabetize=true)
      h = alphabetize ? self.sort : self
      st = ''
      h.each do |k,v|
        if v > 0
          st << k.to_s.capitalize
          st << v.to_s if v > 1
        end
      end
      if include_charge_if_nonzero
        st << "#{charge > 0 ? '+' : '-'}#{charge.abs if charge.abs > 1}" unless charge.zero?
      end
      st
    end

    def inspect
      "{MolecularFormula #{super[1...-1]}, @charge=#{self.charge}}"
    end

    # returns a hash (note: does not pass along charge info!)
    def to_h
      Hash[ self ]
    end

    alias_method :old_equal, '=='.to_sym

    def ==(other)
      old_equal(other) && self.charge == other.charge
    end

  end
end


require "mspire/molecular_formula/version"

# class methods for reading from different string input
require 'mspire/molecular_formula/reader'

# the modules for these 3 are included at the bottom
require 'mspire/molecular_formula/arithmetic'
require 'mspire/molecular_formula/mass'

# currently can't execute isotope dist code without this gem
# TODO: remove dep.
def have_fftw3?
  begin
    response = require('fftw3')
    true
  rescue
    begin
      Kernel.const_get('FFTW3')
    rescue
      false
    end
  end
end

require 'mspire/molecular_formula/isotope_distribution' if have_fftw3?

module Mspire
  class MolecularFormula
    extend Reader
     
    ####################################################
    # include other behaviors
    ####################################################
    include Arithmetic
    include Mass
    if have_fftw3?
      include IsotopeDistribution 
    end
  end
end
