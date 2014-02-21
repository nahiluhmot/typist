require 'spec_helper'

describe Typist do
  it { should be_a Module }

  describe '#data' do
    before do
      extend Typist

      data :Boolean do
        constructor :True
        constructor :False

        func :to_i do
          match(Boolean::False) { 0 }
          match(Boolean::True) { 1 }
        end
      end
    end

    it 'defines a data type' do
      Boolean.should be_a Module

      Boolean.false.should be_a Boolean::False
      Boolean.true.should be_a Boolean::True

      Boolean.false.to_i.should == 0
      Boolean.true.to_i.should == 1
    end
  end
end
