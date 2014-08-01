# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mspire/molecular_formula/version'

Gem::Specification.new do |spec|
  spec.name          = "mspire-molecular_formula"
  spec.version       = Mspire::MolecularFormula::VERSION
  spec.authors       = ["John T. Prince"]
  spec.email         = ["jtprince@gmail.com"]
  spec.summary       = %q{mspire library to handle molecular formulas (including an optional charge state)}  
  spec.description   = %q{mspire library to handle molecular formulas (including an optional charge state), complete with relevant chemical properties such as mass, m/z, and isotope distribution.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  [
    ["mspire-mass", "~> 0.1.0"],  # which brings in mspire-isotope
  ].each do |args|
    spec.add_dependency(*args)
  end

  [
    ["bundler", "~> 1.6.2"],
    ["rake"],
    ["rspec", "~> 2.14.1"], 
    ["rdoc", "~> 4.1.1"], 
    ["simplecov", "~> 0.8.2"],
  ].each do |args|
    spec.add_development_dependency(*args)
  end
end
