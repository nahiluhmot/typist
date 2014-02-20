# This module holds all errors thrown in the gem.
module Typist::Error
  # This class is never thrown, but can be used as a catch-all.
  class BaseError < StandardError; end

  # This is thrown when a pattern match is not exhaustive.
  class PatternError < BaseError; end

  # This is thrown when an invalid type contstructor is matched against.
  class MatchError < BaseError; end
end
