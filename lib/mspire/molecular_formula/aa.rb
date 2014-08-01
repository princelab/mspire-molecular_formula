require 'mspire/molecular_formula'

module Mspire
  module MolecularFormula
    module AA
      # These represent counts for the individual residues (i.e., no extra H
      # and OH on the ends)
      aa_to_el_hash = {
        'A' => { C: 3, H: 5, O: 1, N: 1, S: 0, P: 0 },
        'C' => { C: 3, H: 5, O: 1, N: 1, S: 1, P: 0 },
        'D' => { C: 4, H: 5, O: 3, N: 1, S: 0, P: 0 },
        'E' => { C: 5, H: 7, O: 3, N: 1, S: 0, P: 0 },
        'F' => { C: 9, H: 9, O: 1, N: 1, S: 0, P: 0 },
        'G' => { C: 2, H: 3, O: 1, N: 1, S: 0, P: 0 },
        'I' => { C: 6, H: 11, O: 1, N: 1, S: 0, P: 0 },
        'H' => { C: 6, H: 7, O: 1, N: 3, S: 0, P: 0 },
        'K' => { C: 6, H: 12, O: 1, N: 2, S: 0, P: 0 },
        'L' => { C: 6, H: 11, O: 1, N: 1, S: 0, P: 0 },
        'M' => { C: 5, H: 9, O: 1, N: 1, S: 1, P: 0 },
        'N' => { C: 4, H: 6, O: 2, N: 2, S: 0, P: 0 },
        'O' => { C: 12, H: 19, O: 2, N: 3, S: 0, P: 0 },
        'P' => { C: 5, H: 7, O: 1, N: 1, S: 0, P: 0 },
        'Q' => { C: 5, H: 8, O: 2, N: 2, S: 0, P: 0 },
        'R' => { C: 6, H: 12, O: 1, N: 4, S: 0, P: 0 },
        'S' => { C: 3, H: 5, O: 2, N: 1, S: 0, P: 0 },
        'T' => { C: 4, H: 7, O: 2, N: 1, S: 0, P: 0 },
        'U' => { C: 3, H: 5, O: 1, N: 1, S: 0, P: 0, :Se =>1 },
        'V' => { C: 5, H: 9, O: 1, N: 1, S: 0, P: 0 },
        'W' => { C: 11, H: 10, O: 1, N: 2, S: 0, P: 0 },
        'Y' => { C: 9, H: 9, O: 2, N: 1, S: 0, P: 0 },
      }

      # molecular formulas for each amino acid residue (no H or OH on ends)
      # keyed by AA string.  Shares formula objects with FORMULAS_SYBMOL and
      # FORMULAS.
      FORMULAS_STRING = Hash[
        aa_to_el_hash.map {|k,v| [k, Mspire::MolecularFormula.new(v)] }
      ]

      # molecular formulas for each amino acid residue (no H or OH on ends)
      # keyed by AA symbol. Shares formula objects with FORMULAS_SYBMOL and
      # FORMULAS.
      FORMULAS_SYMBOL = Hash[FORMULAS_STR.map {|k,v| [k.to_sym, v] }]

      # molecular formulas for each amino acid residue (no H or OH on ends)
      # keyed by AA symbol and string.  Shares formula objects with
      # FORMULAS_SYBMOL and FORMULAS.
      FORMULAS = FORMULAS_SYMBOL.merge(FORMULAS_STRING)
    end
  end
end
