# -*- encoding: utf-8 -*-
require File.expand_path('../lib/typist/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Tom Hulihan']
  gem.email         = %w{hulihan.tom159@gmail.com}
  gem.description   = %q{Algebraic data types for Ruby}
  gem.summary       = %q{Algebraic data types for Ruby}
  gem.homepage      = 'https://github.com/nahiluhmot/typist'
  gem.license       = 'MIT'
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'typist'
  gem.require_paths = %w{lib}
  gem.version       = Typist::VERSION
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'cane'
  gem.add_development_dependency 'pry'
end
