# typist

[![Gem Version](https://badge.fury.io/rb/typist.png)](http://badge.fury.io/rb/typist)
[![Build Status](https://travis-ci.org/nahiluhmot/typist.png?branch=master)](https://travis-ci.org/nahiluhmot/typist)
[![Code Climate](https://codeclimate.com/github/nahiluhmot/typist.png)](https://codeclimate.com/github/nahiluhmot/typist)

`typist` is a gem that allows you to define Algebraic Data Types (ADTs) in Ruby.
For a tutorial on ADTs, I recommend [Learn You a Haskell's tutorial](http://learnyouahaskell.com/making-our-own-types-and-typeclasses).

Features:

* A rich DSL that allows for idiomatic defintions of the data types
* Pattern matching
* Runtime support for incomplete pattern matches
* Class-load time support for invalid pattern matches

Planned Improvements:

* Type classes
* Optional runtime type checking

# Installation

From the command line:

```shell
$ gem install typist
```

From a Gemfile:

```ruby
gem 'typist'
```

# Usage

To define a data type, first extend the `Typist` module in a top-level statement, or in the module in which you'd like your data type defined.
For example, to create a new data type in the `Test` module:

```ruby
module Test
  extend Typist

  ...
end
```

Once `Typist` has been extended, the `data` function will define a data type.
The following defines a new data type called `Tree` in the `Test` module:

```ruby
module Test
  extend Typist

  data :Tree do
    ...
  end
end
```

Type constructors may be defined using the `constructor` function.

```ruby
module Test
  extend Typist

  data :Tree do
    constructor :Leaf
    constructor :Node, :value, :left, :right
  end
end
```

Now, `Tree::Leaf` and `Tree::Node` are defined.
The arguments that come after the constructor name are the instance variables -- accessors are defined for each of them.
To create a new Leaf, run `Tree.leaf`.
To create a new Node, run `Tree.node(:value => val, :right => Tree.leaf, :left => Tree.leaf)`.

Finally, the DSL allows the user to define and pattern match in functions.
The `func` method in the context of a data type declares a new function.
For example:

```ruby
module Test
  extend Typist

  data :Tree do
    constructor :Leaf
    constructor :Node, :value, :left, :right

    func :contains? do
      match Tree::Leaf do |element|
        false
      end

      match Tree::Node do |element|
        case value <=> element
        when -1
          left.contains?(element)
        when 1
          right.contains?(element)
        else
          true
        end
      end
    end
  end
end
```

This defines `#contains?` method on `Tree::Node` and `Tree::Leaf`.
Example usage:

```ruby
leaf = Tree.leaf
node = Tree.node(:value => 'a', :left => Tree.leaf, right => Tree.leaf)

leaf.contains?('a')
# => false

node.contains?('a')
# => true
```

# Contributing

1. Fork the repository
2. Create a branch
3. Add tests
4. Commit your changes
5. Push the branch
6. DO NOT bump the version
7. Submit a Pull Request
