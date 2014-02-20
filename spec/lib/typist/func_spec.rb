require 'spec_helper'

describe Typist::Func do
  describe '#initialize' do
    context 'when there is no block' do
      subject { described_class.new(:a_function) }

      it 'sets the @name instance variable to the first argument' do
        subject.name.should == :a_function
      end

      it 'has no matches intially' do
        subject.matches.should be_empty
      end
    end

    context 'when there is a block' do
      subject {
        Typist::Func.new(:this_function) do
          @test_var = 15
        end
      }

      it '`#instance_eval`s the block' do
        subject.instance_variable_get(:@test_var).should == 15
      end
    end
  end

  describe '#match' do
    subject { described_class.new(:test_func) }

    before { subject.match(Fixnum) { :it_works } }

    it 'adds that to the @matches hash' do
      subject.matches[Fixnum].call.should == :it_works
    end
  end

  describe '#define!' do

    context 'when an invalid class is matched against' do
      subject {
        module BaseModule; end

        class TestClass; end

        Typist::Func.new(:alpha) do
          match(TestClass) { puts 'This should not happen!' }
        end
      }

      it 'raises a MatchError' do
        expect { subject.define!(BaseModule) }
          .to raise_error(Typist::Error::MatchError)
      end
    end

    context 'when only valid subclasses are matched against' do
      subject {
        module BaseModule; end

        class Matches; include BaseModule; end
        class DoesNotMatch; include BaseModule; end

        Typist::Func.new(:alpha) do
          match(Matches) { 'qt3.14' }
        end
      }

      before { subject.define!(BaseModule) }

      context 'when a subclass does not match against this function' do
        it 'raises a PatternError' do
          expect { DoesNotMatch.new.alpha }
            .to raise_error(Typist::Error::PatternError)
        end
      end

      context 'when a subclass does match against the function' do
        it 'evaluates its match' do
          Matches.new.alpha.should == 'qt3.14'
        end
      end
    end
  end
end
