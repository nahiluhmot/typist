require 'spec_helper'

describe Typist::Data do
  describe '#initialize' do
    context 'when no block is given' do
      subject { described_class.new(:Test) }

      it 'sets the @name' do
        expect(subject.name).to eq(:Test)
      end

      it 'sets the @constructors to []' do
        expect(subject.constructors).to be_empty
      end

      it 'sets the @funcs to []' do
        expect(subject.funcs).to be_empty
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

      expect(subject.constructors).to be_all { |constructor|
        constructor.is_a?(Typist::Constructor)
      }
    end
  end

  describe '#func' do
    subject { described_class.new(:Trie) }

    it 'adds a constructor' do
      expect { subject.func(:empty) }
        .to change { subject.funcs.length }.by(1)

      expect(subject.funcs).to be_all { |funcs|
        funcs.is_a?(Typist::Func)
      }
    end
  end

  describe '#get_module' do
    subject { described_class.new(:Set) }

    it 'returns a module' do
      expect(subject.get_module).to be_a(Module)
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
      expect(Tree).to respond_to(:node)
      expect(Tree).to respond_to(:leaf)
    end

    it 'defines each constructor' do
      expect(Tree::Node).to include(Tree)
      expect(Tree::Leaf).to include(Tree)

      expect(node.value).to eq(4)
      expect(node.left).to eq(Tree.leaf)
      expect(node.right).to eq(Tree.leaf)
    end

    it 'defines functions on the constructors' do
      expect(leaf).to be_empty
      expect(node).to_not be_empty

      expect(leaf.contains?(4)).to be_false
      expect(node.contains?(4)).to be_true
      expect(node.contains?(5)).to be_false

      expect(leaf.size).to eq(0)
      expect(node.size).to eq(1)
    end
  end
end
