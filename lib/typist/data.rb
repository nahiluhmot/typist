# Instances of this class may be included like a module.
class Typist::Data
  attr_reader :name, :constructors, :funcs, :data_funcs, :block

  # Create a new data type with the given name. The block will be evaluated in
  # the context of the new instance.
  def initialize(name, &block)
    @name = name
    @constructors = []
    @funcs = []
    @data_funcs = []
    @block = block
  end

  # Define a constructor for this data type.
  def constructor(*args, &block)
    constructors << Typist::Constructor.new(*args, &block)
  end

  # Define a function which may pattern-matched against
  def func(*args, &block)
    funcs << Typist::Func.new(*args, &block)
  end

  # Define a function whose receiver is the data type.
  def data_func(*args, &block)
    data_funcs << Typist::DataFunc.new(*args, &block)
  end

  # Get the module that is defined.
  def get_module
    @module ||= Module.new
  end

  # Define the module, constructors, and functions.
  def define!(mod = Kernel)
    get_module.tap do |context|
      mod.const_set(name, context)
      instance_eval(&block) unless block.nil?
      dsl_attributes.each { |attr| attr.define!(context) }
    end
  end

  def dsl_attributes
    constructors + funcs + data_funcs
  end
  private :dsl_attributes
end
