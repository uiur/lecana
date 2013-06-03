require 'spec_helper'

describe Activity do
  describe '.add' do
    before do
      @user = Fabricate(:user)
      @target = Fabricate(:post, :user => @user)
    end

    subject { Activity.add(@user, Activity::Post::CREATED, @target) }
    it { should_not be_false }

    context 'target2' do
      before do
        @target2 = @target.postable
      end
      subject { Activity.add(@user, Activity::Post::CREATED, @target, @target2) }
      it { should_not be_false }
    end
  end

  describe '.related_to' do
    before do
      @subject = Fabricate(:subject)
      @user = Fabricate(:user)
      @user.register(@subject.subject_infos.first)
      post = @user.post('hoge', @subject)
      @activity = post.activity
    end

    subject { Activity.related_to(@user) }
    it { should include @activity }
  end
end
