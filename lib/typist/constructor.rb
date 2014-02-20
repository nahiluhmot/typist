# This class represents a data-type contstructor.
class Typist::Constructor
  attr_reader :name, :vars

  # Create a new constructor with the given name and instance variable(s).
  def initialize(name, *vars)
    @name = name
    @vars = vars
  end

  # Get the Class that this Constructor defines.
  def get_class
    @class ||= Class.new
  end

  # Turn the constructor into a class definition, then define a convenience
  # method in the given module.
  def define!(context)
    get_class.tap do |klass|
      define_class(context, klass)
      define_initializer(context, klass)
    end
  end

  def define_class(context, klass)
    attrs = vars
    klass.instance_eval do
      include context
      attr_accessor(*attrs)

      define_method(:initialize) do |hash = {}|
        hash.each { |key, val| instance_variable_set(:"@#{key}", val) }
      end
    end
    context.const_set(name, klass)
  end
  private :define_class

  def define_initializer(context, klass)
    method_name = Typist::Util.snakeify(name)

    context.module_eval do
      define_method(method_name) { |*args| klass.new(*args) }
      module_function method_name
    end
  end
  private :define_initializer
end
