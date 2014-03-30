require 'spec_helper'

describe Typist::DataFunc do
  describe '#initialize' do
    let(:name) { :test_func }
    let(:block) { proc { |x| x.succ } }
    subject { Typist::DataFunc.new(name, &block) }

    it 'creates a new DataFunc with the given name and block' do
      expect(subject.name).to eq(name)
      expect(subject.block.call(1)).to eq(2)
    end
  end

  describe '#define!' do
    let(:name) { :chomp }
    let(:block) { proc { |str| str.chomp } }
    let(:mod) { Module.new }
    subject { Typist::DataFunc.new(name, &block) }

    before { subject.define!(mod) }

    it 'defines its @name on the given module' do
      expect(mod.chomp("test\n")).to eq('test')
    end
  end
end
