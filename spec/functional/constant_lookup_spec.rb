require 'spec_helper'

# This spec is simply illustrative of why it is benefecial to use nested namespacing
# (as opposed to linear) when defining modules. There is no way I can think of
# to assert that the files are actually written using nested namespacing
# as opposed to linear
describe 'constant lookup within the PowerEnum Namespace' do
  # These specs here illustrative-of and based off the blog post:
  # http://urbanautomaton.com/blog/2013/08/27/rails-autoloading-hell/

  context 'when linear namespacing is used' do
    it 'multiple access across constant definitions raises error' do
      expect{
        module PowerEnum::Reflection
          EnumerationReflection
          EnumerationReflection
        end
      }.to raise_error(NameError)

      expect{
        class PowerEnum::EnumerationReflection
          Reflection
          Reflection
        end
      }.to raise_error(NameError)
    end
  end

  context 'when nested namespacing is used' do
    it 'multiple access across constant definitions does not raise error' do
      expect{
        module PowerEnum
          module Reflection
            EnumerationReflection
            EnumerationReflection
          end
        end

        module PowerEnum
          class EnumerationReflection
            Reflection
            Reflection
          end
        end
      }.not_to raise_error(NameError)
    end
  end

end
