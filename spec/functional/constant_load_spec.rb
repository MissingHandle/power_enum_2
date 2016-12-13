require 'spec_helper'
# BookingStatus and State models act as enumerated.
# All predefined booking statuses are in "add_booking_statuses" migration.
#
describe 'loading constants' do

  context 'when a constant is defined in the PowerEnum class' do
    class PowerEnum
      SOME_CONSTANT = 1
    end

    it 'should be findable from nested modules' do
      expect(PowerEnum::Enumerated::SOME_CONSTANT).to eq 1
    end

    it 'repeated access should not raise error' do
      expect{
        PowerEnum::Enumerated::SOME_CONSTANT
        PowerEnum::Enumerated::SOME_CONSTANT
      }.not_to raise_error(NameError)
    end
  end

end
