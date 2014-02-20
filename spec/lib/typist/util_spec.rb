require 'spec_helper'

describe Typist::Util do
  subject { Typist::Util }

  describe '#snakeify' do
    let(:hash) {
      {
        'ThisString' => 'this_string',
        'thatString' => 'that_string',
        'HeLlO' => 'he_ll_o'
      }
    }

    it 'converts CamelCase Strings to snake_case' do
      hash.each { |camel, snake| subject.snakeify(camel).should == snake }
    end
  end
end
