# encoding: UTF-8
require 'spec_helper'

describe Term do
  describe 'validation' do
    it 'should have uniqueness of ord' do
      Term.new(ord: 1).should_not be_valid
    end
  end

  describe '.detect' do
    it 'should be an alias of find_by_ord' do
      Term.detect(ord: 1).should == Term.find_by_ord(1)
    end
  end
  
  describe '.ranged' do
    it '範囲を指定する' do
      Term.ranged(0..2).should have(3).items
    end
  end

  describe '.active' do
    # とりあえずデフォルトは0..2
    it 'an alias of ranged(0..2)' do
      Term.active.should == Term.ranged(0..2)
    end
  end
end
