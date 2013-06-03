# encoding: UTF-8
require "spec_helper"

describe ApplicationHelper do
  describe '#user_path' do
    before do
      @user = Fabricate(:user, name: 'yukio')
    end

    context 'Userを与えると' do
      subject { helper.user_path(@user) }
      it { should == '/users/yukio' }
    end
    
    context 'Stringを与えると' do
      subject { helper.user_path('yukio') }
      it { should == '/users/yukio' }
    end
  end

  describe '#day' do
    it '数値を与えると曜日（文字列）を返す' do
      day(3).should == '水'
    end
  end

  describe '#profile_image_url' do
    before do
      @url = 'http://hoge.com/image.jpg'
      @user = Fabricate(:user, :image_url => @url)
    end

    subject { helper.profile_image_url(@user) }
    it { should == @url}

    context 'urlがnilのとき' do
      before do
        @user2 = Fabricate(:user, :image_url => nil)
      end

      subject { helper.profile_image_url(@user2) }
      it { should_not be_nil }
    end
  end

  describe '#link_to_user' do
    before do
      @user = Fabricate(:user, :name => 'anal')
    end
    
    subject { helper.link_to_user @user }
    it { should == (helper.link_to @user.name, user_path(@user)) }
  end

  describe '#link_to_subject' do
    before do
      @subject = Fabricate(:subject, :name => 'Introduction To Anal')
    end
    
    subject { helper.link_to_subject @subject }
    it { should == (helper.link_to @subject.name, subject_path(@subject)) }
  end

end
