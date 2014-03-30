# This is the top level module for the gem, used as a namespace and as a
# location for high-level functions.
module Typist
  require 'typist/constructor'
  require 'typist/data'
  require 'typist/error'
  require 'typist/func'
  require 'typist/util'

  # Define a new data type.
  def data(*args, &block)
    Data.new(*args, &block).define!(self.is_a?(Module) ? self : Kernel)
  end

  module_function :data
end
