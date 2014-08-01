require 'mspire/mass'

module Mspire
  class MolecularFormula
    module Mass
      # gives the monoisotopic mass adjusted by the current charge (i.e.,
      # adds/subtracts electron masses for the charges)
      def mass(consider_electron_masses = true)
        mss = inject(0.0) do |sum,(el,cnt)| 
          sum + (Mspire::Mass::Element::MONO_STRING[el]*cnt)
        end
        mss -= (Mspire::Mass::ELECTRON * charge) if consider_electron_masses
        mss
      end

      def avg_mass(consider_electron_masses = true)
        mss = inject(0.0) {|sum,(el,cnt)| sum + (Mspire::Mass::Element::AVG_STRING[el]*cnt) }
        mss -= (Mspire::Mass::ELECTRON * charge) if consider_electron_masses
        mss
      end

      # the mass to charge ratio (m/z)
      # returns nil if the charge == 0
      def mz(consider_electron_masses = true, negative_mz_allowed = true)
        if charge == 0
          nil
        else
          mass(consider_electron_masses) / (negative_mz_allowed ? charge : charge.abs)
        end
      end
    end
  end
end

