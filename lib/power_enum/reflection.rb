# Copyright (c) 2011 Artem Kuzko
# Copyright (c) 2013 Zach Belzer
# Copyright (c) 2013 Arthur Shagall
# Released under the MIT license.  See LICENSE for details.

# Used to patch ActiveRecord reflections.
module PowerEnum
  module Reflection
    extend ActiveSupport::Concern

    # Class-level extensions injected into ActiveRecord
    module ClassMethods
      def self.extended(base) # :nodoc:
        class << base
          alias_method_chain :reflect_on_all_associations, :enumeration
          alias_method_chain :reflect_on_association, :enumeration
        end
      end

      # All {PowerEnum::EnumerationReflection} reflections
      def reflect_on_all_enumerated
        # Need to give it a full namespace to avoid getting Rails confused in development
        # mode where all objects are reloaded on every request.
        reflections.values.grep(PowerEnum::EnumerationReflection)
      end

      # If the reflection of the given name is an EnumerationReflection, returns
      # the reflection, otherwise returns nil.
      # @return [PowerEnum::EnumerationReflection]
      def reflect_on_enumerated( enumerated )
        key = if Rails.version =~ /^4\.2.*/
                enumerated.to_s
              else
                enumerated.to_sym
              end
        reflections[key].is_a?(PowerEnum::EnumerationReflection) ? reflections[key] : nil
      end

      # Extend associations with enumerations, preferring enumerations
      def reflect_on_all_associations_with_enumeration(macro = nil)
        reflect_on_all_enumerated + reflect_on_all_associations_without_enumeration(macro)
      end

      # Extend associations with enumerations, preferring enumerations
      def reflect_on_association_with_enumeration( associated )
        reflect_on_enumerated(associated) || reflect_on_association_without_enumeration(associated)
      end
    end

  end
end
