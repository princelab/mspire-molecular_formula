require 'mspire/molecular_formula'

module Mspire
  class MolecularFormula
    module AA
      # These represent counts for the individual residues (i.e., no extra H
      # and OH on the ends)
      aa_to_el_hash = {
        'A' => { C: 3, H: 5, O: 1, N: 1 },
        'C' => { C: 3, H: 5, O: 1, N: 1, S: 1 },
        'D' => { C: 4, H: 5, O: 3, N: 1 },
        'E' => { C: 5, H: 7, O: 3, N: 1 },
        'F' => { C: 9, H: 9, O: 1, N: 1 },
        'G' => { C: 2, H: 3, O: 1, N: 1 },
        'I' => { C: 6, H: 11, O: 1, N: 1 },
        'H' => { C: 6, H: 7, O: 1, N: 3 },
        'K' => { C: 6, H: 12, O: 1, N: 2 },
        'L' => { C: 6, H: 11, O: 1, N: 1 },
        'M' => { C: 5, H: 9, O: 1, N: 1, S: 1 },
        'N' => { C: 4, H: 6, O: 2, N: 2 },
        'O' => { C: 12, H: 19, O: 2, N: 3 },
        'P' => { C: 5, H: 7, O: 1, N: 1 },
        'Q' => { C: 5, H: 8, O: 2, N: 2 },
        'R' => { C: 6, H: 12, O: 1, N: 4 },
        'S' => { C: 3, H: 5, O: 2, N: 1 },
        'T' => { C: 4, H: 7, O: 2, N: 1 },
        'U' => { C: 3, H: 5, O: 1, N: 1, Se: 1 },
        'V' => { C: 5, H: 9, O: 1, N: 1 },
        'W' => { C: 11, H: 10, O: 1, N: 2 },
        'Y' => { C: 9, H: 9, O: 2, N: 1 },
      }

      # molecular formulas for each amino acid residue (no H or OH on ends)
      # keyed by AA string.  Shares formula objects with FORMULAS_SYBMOL and
      # FORMULAS.
      FORMULAS_STRING = aa_to_el_hash.map {|k,v| [k, Mspire::MolecularFormula.new(v)] }.to_h

      class << self
        # returns hash of molecular formulas keyed by amino acid single letter
        # symbol
        #
        # options:
        #
        #     :by =  :symbol | :string | :both
        #     (:symbol is default)
        def formulas(by: :symbol)
          case by
          when :symbol, :both
            sym_hash = Mspire::MolecularFormula::AA::FORMULAS_STRING.map {|k,v| [k.to_sym, v] }.to_h
          when :string
            return Mspire::MolecularFormula::AA::FORMULAS_STRING
          else
            raise ArgumentError, ":by must be :symbol, :string, or :both"
          end

          if by == :symbol
            sym_hash
          else
            Mspire::MolecularFormula::AA::FORMULAS_STRING.merge(sym_hash)
          end
        end
      end
    end

    module Reader

      # a linear peptide (so includes all the residue masses plus water)
      def from_aaseq(aaseq, charge=0, aa_formula_hash=Mspire::MolecularFormula::AA::FORMULAS_STRING)
        hash = aaseq.each_char.inject({}) do |hash,aa| 
          hash.merge(aa_formula_hash[aa]) {|hash,old,new| (old ? old : 0) + new }
        end
        hash[:H] += 2
        hash[:O] += 1
        self.new(hash, charge)
      end
    end

  end # molecular_formula
end # mspire
