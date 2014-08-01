module Mspire
  class MolecularFormula
    module Arithmetic
      # returns a new formula object where all the atoms have been added up
      def +(*others)
        self.dup.add!(*others)
      end

      # returns self
      def add!(*others)
        others.each do |other|
          self.merge!(other) {|key, oldval, newval| self[key] = oldval + newval }
          self.charge += other.charge
        end
        self
      end

      # returns a new formula object where all the formulas have been subtracted
      # from the caller
      def -(*others)
        self.dup.sub!(*others)
      end

      def sub!(*others)
        others.each do |other|
          oth = other.dup
          self.each do |k,v|
            if oth.key?(k)
              self[k] -= oth.delete(k)
            end
          end
          oth.each do |k,v|
            self[k] = -v
          end
          self.charge -= other.charge
        end
        self
      end

      def *(int)
        self.dup.mul!(int)
      end

      def mul!(int, also_do_charge=true)
        raise ArgumentError, "must be an integer" unless int.is_a?(Integer)
        self.each do |k,v|
          self[k] = v * int
        end
        self.charge *= int if also_do_charge
        self
      end

      def /(int)
        self.dup.div!(int)
      end

      def div!(int, also_do_charge=true)
        raise ArgumentError, "must be an integer" unless int.is_a?(Integer)
        self.each do |k,v|
          quotient, modulus = v.divmod(int)
          raise ArgumentError "all numbers must be divisible by int" unless modulus == 0
          self[k] = quotient
        end
        if also_do_charge
          quotient, modulus = self.charge.divmod(int) 
          raise ArgumentError "charge must be divisible by int" unless modulus == 0
          self.charge = quotient
        end
        self
      end

    end
    include Arithmetic
  end
end
