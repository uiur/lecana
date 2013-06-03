# encoding: UTF-8
require 'spec_helper'

describe Post do
  describe 'after_create' do
    before do 
      @post = Post.create(content: 'hoge', postable: Fabricate(:subject), user: Fabricate(:user))
    end

    it 'activityが作られる' do
      @post.activity.activity_type.should == Activity::Post::CREATED
    end
  end
end
