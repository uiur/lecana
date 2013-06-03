# encoding: UTF-8
require 'spec_helper'
require "ruby-debug"

describe Subject do
  let(:s) { Fabricate(:subject) }
  describe ".create_with_infos" do
    it 'Subjectが作られる' do
      Subject.create_with_infos(name: '剥製学', room: 'hoge', year: 'fuga', college_id: 1)
    end

    context 'room, yearを与える場合' do
      subject { Subject.create_with_infos(name: '剥製学', college_id: 1, room: '共北38', year: 2011) }
      its(:subject_infos) { should have(1).items }
    end

    context 'periodsを与える場合' do
      subject { Subject.create_with_infos(name: '剥製学', college_id: 1, room: '共北38', year: 2011, periods: [{day: 1, ord: 2}, {day: 2, ord: 4}]).subject_infos.first.periods }
      it { should have(2).items }
    end

    context 'teachersを与える場合' do
      subject { Subject.create_with_infos(name: '剥製学', college_id: 1, teachers: [{name: '小沢一郎'}, {name: '鳩山由紀夫'}], room: '共北36', year: 2011).teachers }
      it { should have(2).items }
    end

    context 'termsを与える場合' do
      subject { Subject.create_with_infos(name: '剥製学', college_id: 1, teachers: [{name: '鳩山由紀夫'}], terms: [1,2], room: '共北36', year: 2012).terms }
      it { should have(2).items }
    end
  end

  describe "#periods" do
    it '配列を返す' do
      s.should have(2).periods
    end

    it 'それはPeriod' do
      s.periods.first.should be_an_instance_of Period
    end
  end

  describe "#room" do
    it '文字列を返す' do
      s.room.should be_an_instance_of String
    end

    it '正しいroomを返す' do
      s.room.should =~ /共北/
    end
  end

  before do
    Subject.create_with_infos(name: '剥製入門', teachers: [{name: '宇井玲央'}],college_id: 1, room: '共北88', year: 2012, periods: [{day: 5, ord: 5}, {day: 6, ord: 6}])
    Subject.create_with_infos(name: '剥製概論', terms: [1,2], teachers: [{name: '桐田切嗣'}],college_id: 1, room: '共北88', year: 2012, periods: [{day: 3, ord: 3}, {day: 6, ord: 6}])
    Subject.create_with_infos(name: 'ザリガニの現代哲学', teachers: [{name: 'ザーリ・マルクス'}],college_id: 1, room: '共北38', year: 2011, periods: [{day: 4, ord: 4}, {day: 6, ord: 6}])
  end


  describe ".find_by_period" do
    subject { Subject.find_by_period(day: 6, ord: 6) }
    it { should have(2).items }
    its(:first) { should be_an_instance_of Subject }

    context 'yearを指定したとき' do
      subject { Subject.find_by_period({day: 6, ord: 6},{year: 2011}) }
      it { should have(1).items }
    end
  end
end
