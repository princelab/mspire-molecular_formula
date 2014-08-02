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

### Create with a string formula

```ruby
mf = Mspire::MolecularFormula[ 'C3H4O2' ]

# with a +2 charge
mf = Mspire::MolecularFormula[ 'C3H4O2', 2 ]
mf = Mspire::MolecularFormula[ 'C3H4O2+2' ]  # alternatively
mf = Mspire::MolecularFormula[ 'C3H4O2++' ]  # alternatively
```

### Arithmetic

Walk through the arithmetic of combustion of ethene using this equation:

    CH2=CH2 + 3 O2 -> 2 CO2 + 2 H2O 

```ruby
ethene = Mspire::MolecularFormula['C2H4']
oxygen = Mspire::MolecularFormula['O2']
water = Mspire::MolecularFormula['H2O']

combustion = ethene + (oxygen*3)
two_carbon_dioxide = combustion - (water*2)
carbon_dioxide = two_carbon_dioxide / 2
```

Note that there are no methods defined on fixnum to deal with MolecularFormula
objects, so fixnums need to follow the MolecularFormula (i.e., "3 * oxygen"
will throw an error but "oxygen * 3" is fine)


require 'mspire/isotope/distribution'  # requires fftw gem
puts butane.isotope_distribution  # :total, :max, :first as arg to normalize

