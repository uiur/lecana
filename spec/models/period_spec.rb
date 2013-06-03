# encoding: UTF-8
require 'spec_helper'

describe Period do
  describe 'validation' do
    it 'dayが0~6の範囲外だとエラー' do
      Period.new(day: 7, ord: 2).should have(1).errors_on(:day)
    end

    it 'ordが大きすぎるとエラー' do 
      Period.new(day: 4, ord: 100).should have(1).errors_on(:ord)
    end

    it '重複しない' do
      Period.new(day: 1, ord: 1).should have(1).errors_on(:ord)
    end
  end

  describe '#to_s' do
    it '正しい曜時限を返す' do
      Period.new(day: 3, ord: 3).to_s.should == '水曜3限'
    end
  end
  
  describe '.detect' do
    context '見つかるとき' do
      subject { Period.detect(day: 2, ord: 3) }
      it { should_not be_nil }
    end

    context '不正な値のとき' do
      subject { Period.detect(day: 100, ord: 4) }
      it { should be_nil }
    end
  end

  describe 'seeds.rbがロードされてる' do
    it 'データがある' do
      Period.count.should > 0
    end
  end
end
