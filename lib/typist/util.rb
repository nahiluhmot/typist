# This module contains common logic used throughout the gem.
module Typist::Util
  # Convert a CamelCase String to snake_case. Shamelessly stolen from
  # ActiveSupport.
  def snakeify(string)
    string.to_s.
      gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end

  module_function :snakeify
end
