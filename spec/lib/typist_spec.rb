require 'spec_helper'

describe Typist do
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
      expect(Boolean).to be_a(Module)

      expect(Boolean.false).to be_a(Boolean::False)
      expect(Boolean.true).to be_a(Boolean::True)

      expect(Boolean.false.to_i).to eq(0)
      expect(Boolean.true.to_i).to eq(1)
    end
  end
end
