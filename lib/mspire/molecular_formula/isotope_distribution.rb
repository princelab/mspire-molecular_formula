require 'mspire/mass'
require 'mspire/isotope'

# depends on FFTW3 from mspire/molecular_formula right which does the: require 'fftw3'

module Mspire
  class MolecularFormula
    module IsotopeDistribution
      NORMALIZE = :total

      # Returns isotopic distribution beginning with the lightest possible peak.
      # (for most molecules this will also be the monoisotopic peak)
      #
      # Two cutoff protocols may be specified, percent_cutoff or
      # peak_cutoff.  Normalization is performed *after* cutoff.
      #
      #     percent_cutoff: cuts off when no more peaks contribute more than percent_cutoff 
      #                         to the total distribution.  
      #     peak_cutoff:    cuts off after that many peaks.
      #
      # prefer_lowest_index controls the behavior if both percent_cutoff and
      # peak_cutoff are specified.  If true, then the lowest index found between
      # the two methods will be used, otherwise the highest index.
      #
      # all values will be fractional.  normalize may be one of:
      #
      #     :total   normalize to the total intensity
      #     :max     normalize to the highest peak intensity
      #     :first   normalize to the intensity of the first peak 
      #             (this is typically the monoisotopic peak)
      def isotope_intensity_distribution(normalize: NORMALIZE, peak_cutoff: nil, percent_cutoff: nil, prefer_lowest_index: true, isotope_table: Mspire::Isotope::BY_ELEMENT)
        mono_dist = raw_isotope_distribution(isotope_table: isotope_table)

        cutoff_index = [ 
          if percent_cutoff
            total_signal = mono_dist.reduce(:+)
            cutoff_index_less1 = (mono_dist.size-1).downto(0).find do |i|
              # finds the index
              (mono_dist[i] / total_signal) >= (percent_cutoff/100.0)
            end
            cutoff_index = cutoff_index_less1 ? (cutoff_index_less1 + 1) : 0
        end,
        peak_cutoff
        ].compact.send( prefer_lowest_index ? :min : :max ) || mono_dist.size

        # mono_dist.size will result in nothing sliced off (i.e., for no cutoff)

        mono_dist.slice!(cutoff_index..-1)

        # normalization
        norm_by =
          case normalize
          when :total
            total_signal || mono_dist.reduce(:+)
          when :max
            mono_dist.max
          when :first
            mono_dist.first
          end
        mono_dist.map do |i| 
          v = i / norm_by
          (v > 0) ? v : 0
        end
      end

      # returns an array of two arrays: mass values (or m/z values of charged)
      # and intensity values.  Arguments are passed directly to
      # isotope_intensity_distribution.  the molecule has a charge, this will be
      # used to adjust the m/z values (by removing or adding electrons to the
      # m/z and as the z)
      def isotope_distribution(*args)
        intensities = isotope_intensity_distribution(*args)
        #mono = self.map {|el,cnt| Mspire::Mass::Element::MONO[el]*cnt }.reduce(:+)
        mono = self.map {|el,cnt| Mspire::Isotope::BY_ELEMENT[el].find(&:mono).atomic_mass*cnt }.reduce(:+)
        masses = Array.new(intensities.size)
        neutron = Mspire::Mass::NEUTRON
        masses[0] = mono
        (1...masses.size).each {|i| masses[i] = masses[i-1] + neutron }
        if self.charge && self.charge != 0
          masses.map! do |mass| 
            (mass - (self.charge * Mspire::Mass::ELECTRON)) / self.charge 
          end
        end
        [masses, intensities]
      end

      # returns relative ratios from low nominal mass to high nominal mass.
      # These are *not* normalized at all.
      def raw_isotope_distribution(isotope_table: Mspire::Isotope::BY_ELEMENT)
        low_nominal = 0
        high_nominal = 0
        self.each do |el,cnt|
          isotopes = isotope_table[el]
          low_nominal += (isotopes.first.mass_number * cnt)
          high_nominal += (isotopes.last.mass_number * cnt)
        end

        ffts = self.map do |el, cnt|
          isotope_el_ar = NArray.float(high_nominal+1)
          isotope_table[el].each do |isotope|
            isotope_el_ar[isotope.mass_number] = isotope.relative_abundance
          end
          FFTW3.fft(isotope_el_ar)**cnt
        end
        FFTW3.ifft(ffts.reduce(:*)).real.to_a[low_nominal..high_nominal]
      end
    end
  end
end
