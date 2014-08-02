require 'mspire/molecular_formula/aa'

module Mspire
  class MolecularFormula
    module Reader
      # returns the formula portion and the charge portion (signed Int) of a string
      # returns nil for charge if no charge specified.
      # e.g. C2H4+3 => ['C2H4', 3]
      # e.g. C2H4+++ => ['C2H4', 3]
      # e.g. C2H4- => ['C2H4', -1]
      def formula_and_charge(string)
        md = string.match(/([^+-]*)([\+-]+)(\d*)\Z/)
        if md
          charges_string = md[2]
          chrg = 
            if md[3] != ''
              md[2] == '-' ? -md[3].to_i : md[3].to_i
            else
              sign = charges_string[0]
              cnt = charges_string.count(sign)
              sign == '-' ? -cnt : cnt
            end
          [md[1], chrg]
        else
          [string, nil]
        end
      end

    
      # takes a string, with properly capitalized elements making up the
      # formula.  The elements may be in any order. A charge (e.g., +2, +, -,
      # -3 may be affixed to the end )
      def from_string(arg, charge=nil)
        (mol_form_str, chrg_from_str) = formula_and_charge(arg)
        mf = self.new({}, charge || chrg_from_str || 0)
        mol_form_str.scan(/([A-Z][a-z]?)(\d*)/).each do |k,v| 
          mf[k.to_sym] = (v == '' ? 1 : v.to_i)
        end
        mf
      end

      # arg may be a String, Hash, or MolecularFormula object.
      def from_any(arg, charge=nil)
        if arg.is_a?(String)
          from_string(arg, charge)
        else
          self.new(arg, arg.respond_to?(:charge) ? arg.charge : 0)
        end
      end
      alias_method :[], :from_any

    end
  end
end


