# This class defines the `func` DSL.
class Typist::Func
  attr_reader :name, :matches, :block

  # Create a new function with the given name (String/Symbol). If a block is
  # given, it will be evaluated in the context of the new instance.
  def initialize(name, &block)
    @name = name
    @matches = {}
    @block = block
  end

  # Pattern match against the given class.
  def match(klass, &block)
    matches[klass] = block
  end

  # Given a module define this function, plus the pattern matches for all of its
  # subclasses.
  def define!(context)
    instance_eval(&block) unless block.nil?
    define_base(context)
    matches.each { |klass, block| define_match(context, klass, &block) }
    context
  end

  def define_base(context)
    method_name = name

    context.class_eval do
      define_method(method_name) do |*_, &_|
        raise Typist::Error::PatternError,
          "Patterns not exhaustive in #{context}##{method_name}"
      end
    end
  end
  private :define_base

  def define_match(context, klass, &block)
    unless klass.ancestors.include?(context)
      raise Typist::Error::MatchError,
        "#{klass} is not a valid constructor for #{context}"
    end

    method_name = name
    klass.class_eval { define_method(method_name, &block) }
  end
  private :define_match
end
