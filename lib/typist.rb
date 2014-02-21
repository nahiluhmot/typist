# This is the top level module for the gem, used as a namespace and as a
# location for high-level functions.
module Typist
  autoload :Constructor, 'typist/constructor'
  autoload :Data, 'typist/data'
  autoload :Error, 'typist/error'
  autoload :Func, 'typist/func'
  autoload :Util, 'typist/util'

  # Define a new data type.
  def data(*args, &block)
    Data.new(*args, &block).define!(self.is_a?(Module) ? self : Kernel)
  end

  module_function :data
end
