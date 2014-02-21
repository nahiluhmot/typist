# Instances of this class may be included like a module.
class Typist::Data
  attr_reader :name, :constructors, :funcs, :block

  # Create a new data type with the given name. The block will be evaluated in
  # the context of the new instance.
  def initialize(name, &block)
    @name = name
    @constructors = []
    @funcs = []
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

  # Get the module that is defined.
  def get_module
    @module ||= Module.new
  end

  # Define the module, constructors, and functions.
  def define!(mod = Kernel)
    get_module.tap do |context|
      mod.const_set(name, context)
      instance_eval(&block) unless block.nil?
      constructors.each { |constructor| constructor.define!(context) }
      funcs.each { |func| func.define!(context) }
    end
  end
end
