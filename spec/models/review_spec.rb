# encoding: UTF-8
require 'spec_helper'

describe Review do
  describe 'after_create' do
    before do
      @review = Review.create(user: Fabricate(:user), content: 'hoge', rating: 2, rating2: 4, subject_id: Fabricate(:subject).id)
    end

    it 'activityが作られる' do
      @review.activity.activity_type.should == Activity::Review::CREATED
    end
  end
end
