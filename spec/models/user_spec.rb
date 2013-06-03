# encoding: UTF-8
require 'spec_helper'

describe User do
  let(:user) { Fabricate(:user) }
  let(:other) { Fabricate(:user) }
  let(:s) { Fabricate(:subject_info) }

  describe 'validation' do
    context '正しいname' do
      subject { Fabricate.build(:user) }
      it { should be_valid }
    end

    describe 'image_url validation' do
#       context 'image_urlがURLでない' do
#         subject { Fabricate.build(:user, image_url: 'poeehtt://hoehh') }
#         it { should_not be_valid }
#       end

      context 'URLのとき' do
        subject { Fabricate.build(:user, image_url: 'https://hoge.com/fuga.jpg') }
        it { should be_valid }
      end
    end
  end

  describe 'association with subject_info' do
    it 'subject_infos' do
      user.subject_infos.should_not be_nil
    end
  end

  describe '#register' do
    it 'SubjectInfoを追加する' do
      user.register(s)
      user.subject_infos.should include(s)
    end

    context '一コマ制限を超える' do
      before do
        period = Period.detect(ord: 1, day: 1)
        @info1 = Fabricate(:subject_info, :periods => [period])
        @info2 = Fabricate(:subject_info, :periods => [period])
        @info3 = Fabricate(:subject_info, :periods => [period])
        @info4 = Fabricate(:subject_info, :periods => [period])
        user.register(@info1)
        user.register(@info2)
        user.register(@info3)
      end

      subject { user.register(@info4) }
      it { should be_false }
    end
  end

  describe '#remove' do
    it 'SubjectInfoを取り除く' do
      user.remove(s)
      user.subject_infos.should_not include(s)
    end
  end

  describe '#registered?' do
    context '登録してないとき' do
      subject { user.registered?(s) }
      it { should be_false }
    end

    context '登録しているとき' do
      before do
        user.register(s)
      end
      subject { user.registered?(s) }
      it { should be_true }
    end

    context '引数にSubjectを渡すとき' do
      pending
    end
  end

  describe '#periods' do
    before do
      user.register(Fabricate(:subject_info, :periods => [Period.detect(day: 1, ord: 2), Period.detect(day: 1, ord: 3)]))
      user.register(Fabricate(:subject_info, :periods => [Period.detect(day: 2, ord: 2), Period.detect(day: 1, ord: 3)]))
    end

    it 'Periodの配列を返す' do
      user.periods.first.should be_an_instance_of Period
    end

    it 'Periodの配列を重複無しに返す' do
      user.periods.should have(3).items
    end
  end

  describe '#timetable' do
    before do
      @info = Fabricate(:subject_info, :terms => [Term.detect(ord: 1), Term.detect(ord: 2)], :subject_id => 1, :periods => [Period.detect(day: 1, ord: 2), Period.detect(day: 1, ord: 3)])
      user.register(@info)
      user.register(Fabricate(:subject_info, :subject_id => 2,  :periods => [Period.detect(day: 2, ord: 2), Period.detect(day: 1, ord: 3)]))
      @period = Period.detect(day: 1, ord: 3)
    end

    it '{Period => [SubjectInfo]}を返す' do
      user.timetable[@period].should have(2).items
    end

    it '要素に含む' do
      user.timetable[@period].should include @info
    end

    context '学期を指定する' do
      it '要素に含む' do
        term = 2
        user.timetable(term)[@period].should include @info
      end
    end
  end

  describe '.registering' do
    before do
      @subject = Fabricate(:subject)
      user.register(@subject.info)
    end

    it '科目に登録しているuserを返す' do
      User.registering(@subject).first.should == user
    end
  end

  describe '#have?' do
    context 'postのユーザ' do
      before do
        @post = Fabricate(:post, :user => user)
      end
      subject { user.have?(@post) }
      it { should be_true }
    end

    context 'postのユーザでない' do
      before do
        @user = Fabricate(:user)
        @post = Fabricate(:post, :user => @user)
      end
      subject { user.have?(@post) }
      it { should be_false }
    end
  end

  describe '#fav' do
    before do
      @post = Fabricate(:post, :user => other)
    end
    
    subject { user.fav(@post) }
    it { should be_an_instance_of Fav }

    context '2重fav' do
      before do
        user.fav(@post)
      end
      subject { @post.favs }
      it { should have(1).item }

      subject { user.favs }
      it { should have(1).item }
    end
  end
end
