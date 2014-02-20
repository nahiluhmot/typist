require 'spec_helper'

describe Typist::Constructor do
  describe '#initialize' do
    subject { described_class.new(:Node, :value, :left, :right) }

    it 'sets the @name instance variable' do
      subject.name.should == :Node
    end

    it 'sets the @vars instance variable' do
      subject.vars.should == [:value, :left, :right]
    end
  end

  describe '#get_class' do
    subject { described_class.new(:Leaf) }

    it 'returns a Class' do
      subject.get_class.should be_a Class
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
        instance.should respond_to(:arg1)
        instance.should respond_to(:arg2)
        instance.should_not respond_to(:arg3)
      end

      it 'accepts a hash in its initializer which sets instance variables' do
        instance.instance_variable_get(:@arg1).should == ?a
        instance.instance_variable_get(:@arg2).should == ?b
        instance.instance_variable_get(:@arg3).should == ?c
      end

      it 'includes the given module' do
        subject.get_class.ancestors.should include(mod)
      end
    end

    describe 'the given module' do
      let(:instance) { mod.test_class(:arg1 => 1, :arg2 => 2) }

      it 'defines a method to create an instance of the defined class' do
        instance.should be_a mod::TestClass
        instance.arg1.should == 1
        instance.arg2.should == 2
      end
    end
  end
end
