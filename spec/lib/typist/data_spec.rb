require 'spec_helper'

describe Typist::Data do
  describe '#initialize' do
    context 'when no block is given' do
      subject { described_class.new(:Test) }

      it 'sets the @name' do
        subject.name.should == :Test
      end

      it 'sets the @constructors to []' do
        subject.constructors.should be_empty
      end

      it 'sets the @funcs to []' do
        subject.funcs.should be_empty
      end
    end

    context 'when a block is given' do
      subject {
        described_class.new(:Test) do
          instance_variable_set(:@test_var, true)
        end
      }
    end
  end

  describe '#constructor' do
    subject { described_class.new(:BinaryTree) }

    it 'adds a constructor' do
      expect { subject.constructor(:Leaf) }
        .to change { subject.constructors.length }.by(1)

      subject.constructors.should be_all { |constructor|
        constructor.is_a?(Typist::Constructor)
      }
    end
  end

  describe '#func' do
    subject { described_class.new(:Trie) }

    it 'adds a constructor' do
      expect { subject.func(:empty) }
        .to change { subject.funcs.length }.by(1)

      subject.funcs.should be_all { |funcs|
        funcs.is_a?(Typist::Func)
      }
    end
  end

  describe '#get_module' do
    subject { described_class.new(:Set) }

    it 'returns a module' do
      subject.get_module.should be_a(Module)
    end
  end

  describe '#define!' do
    subject! {
      defined?(Tree) ? Tree : Typist::Data.new(:Tree) do
        constructor :Leaf
        constructor :Node, :value, :left, :right

        func :empty? do
          match(Tree::Leaf) { true }
          match(Tree::Node) { false }
        end

        func :size do
          match(Tree::Leaf) { 0 }
          match(Tree::Node) { (left.size + right.size).succ }
        end

        func :contains? do
          match(Tree::Leaf) { |_| false }

          match(Tree::Node) do |element|
            case value <=> element
            when -1
              left.contains?(value)
            when 1
              right.contains?(value)
            else
              true
            end
          end
        end

        func :== do
          match(Tree::Leaf) { |tree| tree.is_a?(Tree::Leaf) }
          match(Tree::Node) do |tree|
            [
              tree.is_a?(Tree::Node),
              value == tree.value,
              left == tree.left,
              right == tree.right
            ].all?
          end
        end
      end.tap(&:define!)
    }

    let(:leaf) { Tree.leaf }
    let(:node) {
      Tree.node(
        :value => 4,
        :left => Tree.leaf,
        :right => Tree.leaf
      )
    }

    it 'defines convenience methods' do
      Tree.should respond_to(:node)
      Tree.should respond_to(:leaf)
    end

    it 'defines each constructor' do
      Tree::Node.should include(Tree)
      Tree::Leaf.should include(Tree)

      node.value.should == 4
      node.left.should == Tree.leaf
      node.right.should == Tree.leaf
    end

    it 'defines functions on the constructors' do
      leaf.should be_empty
      node.should_not be_empty

      leaf.contains?(4).should be_false
      node.contains?(4).should be_true
      node.contains?(5).should be_false

      leaf.size.should == 0
      node.size.should == 1
    end
  end
end
