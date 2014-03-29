require 'spec_helper'

describe Typist::Constructor do
  describe '#initialize' do
    subject { described_class.new(:Node, :value, :left, :right) }

    it 'sets the @name instance variable' do
      expect(subject.name).to eq(:Node)
    end

    it 'sets the @vars instance variable' do
      expect(subject.vars).to eq([:value, :left, :right])
    end
  end

  describe '#get_class' do
    subject { described_class.new(:Leaf) }

    it 'returns a Class' do
      expect(subject.get_class).to be_a(Class)
    end
  end

  describe '#define!' do
    subject { Typist::Constructor.new(:TestClass, :arg1, :arg2) }
    let(:mod) { Module.new }

    before { subject.define!(mod) }

    describe 'the defined class' do
      let(:instance) {
        mod::TestClass.new(:arg1 => ?a, :arg2 => ?b, :arg3 => ?c)
      }

      it 'has each @var as an accessor' do
        expect(instance).to respond_to((:arg1))
        expect(instance).to respond_to((:arg2))
        expect(instance).to_not respond_to(:arg3)
      end

      it 'accepts a hash in its initializer which sets instance variables' do
        expect(instance.instance_variable_get(:@arg1)).to eq('a')
        expect(instance.instance_variable_get(:@arg2)).to eq('b')
        expect(instance.instance_variable_get(:@arg3)).to eq('c')
      end

      it 'includes the given module' do
        expect(subject.get_class.ancestors).to include(mod)
      end
    end

    describe 'the given module' do
      let(:instance) { mod.test_class(:arg1 => 1, :arg2 => 2) }

      it 'defines a method to create an instance of the defined class' do
        expect(instance).to be_a(mod::TestClass)
        expect(instance.arg1).to eq(1)
        expect(instance.arg2).to eq(2)
      end
    end
  end
end
