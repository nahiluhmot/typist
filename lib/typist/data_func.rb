# A DataFunc is Typist's equivalent of a class method.
class Typist::DataFunc
  attr_reader :name, :block

  # Create a new DataFunc.
  def initialize(name, &block)
    @name = name
    @block = block
  end

  # Define a DataFunc in the given context.
  def define!(context)
    context.define_singleton_method(name, &block)
  end
end
