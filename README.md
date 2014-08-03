# Mspire::MolecularFormula

mspire library to handle molecular formulas (including an optional charge state), complete with relevant chemical properties such as mass, m/z, and isotope distribution.

## Installation

    gem install mspire-molecular_formula

## Usage

```ruby
require 'mspire/molecular_formula'
```

### Create with a hash

```ruby
mf = Mspire::MolecularFormula.new( C:3, H:4, O:2 )

# with a +2 charge
mf = Mspire::MolecularFormula.new( {C:3, H:4, O:2}, 2)
```

### Create with a string formula or AA seq

```ruby
mf = Mspire::MolecularFormula[ 'C3H4O2' ]

# with a +2 charge
mf = Mspire::MolecularFormula[ 'C3H4O2', 2 ]
mf = Mspire::MolecularFormula[ 'C3H4O2+2' ]  # alternatively
mf = Mspire::MolecularFormula[ 'C3H4O2++' ]  # alternatively

# from amino acid sequence
Mspire::MolecularFormula.from_aaseq('APEPTIDE') # .to_s => "C37H58N8O16"
Mspire::MolecularFormula.from_aaseq('APEPTIDE', -2) # w/ -2 charge .to_s => "C37H58N8O16-2"
```

### Output string or hash formula

```ruby
mf = Mspire::MolecularFormula[ 'C3H4O2', 2 ]
mf.inspect     # => {MolecularFormula :C=>3, :H=>4, :O=>2, @charge=2}
mf.to_s        # => 'C3H4O2+2'
mf.to_s(false) # (hide charge) => 'C3H4O2'
mf.to_h        # => {:C=>3, :H=>4, :O=>2}
```

### Arithmetic

Walk through the arithmetic of combustion of ethene:

    CH2=CH2 + 3 O2 -> 2 CO2 + 2 H2O 

```ruby
ethene = Mspire::MolecularFormula['C2H4']
oxygen = Mspire::MolecularFormula['O2']
water = Mspire::MolecularFormula['H2O']

combustion = ethene + (oxygen*3)
two_carbon_dioxide = combustion - (water*2)
carbon_dioxide = two_carbon_dioxide / 2
```

Note: there are no methods defined on fixnum to deal with MolecularFormula
objects, so fixnums need to go after the MolecularFormula (i.e., "3 * oxygen"
will throw an error but "oxygen * 3" is fine)

### Isotope Distribution

[Note, currently requires the fftw3 gem to be installed and accessible.]

#### isotope\_intensity\_distribution

```ruby
# by default normalizes by total intensity with no peak or percent cuttoff
ethene.isotope_intensity_distribution
#   => [0.9777084818979036, 0.02215911350461325, 0.0001323273147371948, 7.726507349638125e-08, 
#       1.7670756693524035e-11, 1.81473621216667e-15, 2.6146991408856273e-17]

# return/use only first 4 peaks and normalize by max peak 
ethene.isotope_intensity_distribution(normalize: :max, peak_cutoff: 4)
#   => [1.0, 0.022664335959936163, 0.00013534434566868467, 7.902669857828807e-08]

# cut at less than 0.01% total intensity and normalize by max peak 
ethene.isotope_intensity_distribution(normalize: :first, percent_cutoff: 0.01)
#   => [1.0, 0.022664335959936163, 0.00013534434566868467]
```

#### isotope\_distribution

Returns an array of masses (mz's if charged) and intensities.  Although the
monoisotopic mass will be, the other peaks are not quite as accurate as those
from [emass](https://github.com/princelab/emass) or
[BRAIN](https://code.google.com/p/brain-isotopic-distribution/); however, they
should be accurate enough for many purposes.

```ruby
# zero charge, so returns masses and intensities
ethene.isotope_distribution
#   => [[28.03130012828, 29.039965043880002, 30.048629959480003, ...], 
#       [0.9777084818979036, 0.02215911350461325, 0.0001323273147371948, ...]]

# if charged, will return m/z's and intensities
ethene.charge = 2
#   => [[14.01510146414, 14.519433921940001, 15.023766379740001, 15.528098837540002...], 
#       [0.9777084818979036, 0.02215911350461325, 0.0001323273147371948, ...]]
```

## Convenience method to get at formulas fast

```
require 'mspire/mf'
ethene = Mspire::MF['C2H4']
```

This is just like calling 'mspire/molecular_formula' but it sets the MF
constant equal to MolecularFormula.  Include Mspire or set your own constant
if you want something even shorter.
