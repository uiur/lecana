class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, :polymorphic => true
  belongs_to :target2, :polymorphic => true
 
  module Constants
    module Post
      CREATED = 11
    end

    module Review
      CREATED = 21
    end
    
    module Fav
      CREATED = 31
    end

    module File
      UPLOADED = 41
    end

    module Subject
      REGISTERD = 51
    end

    module Note
      CREATED = 61
    end
  end
  include Constants
 
  default_scope :order => 'created_at DESC'

  scope :related_to, ->(user) do
    targets = user.subject_infos.map{|info| [info.subject.id, info.subject.class.to_s]}
    where((['(target2_id = ? AND target2_type = ?)'] * targets.size).join(' OR '), *targets.flatten )
  end

  scope :active, where(['NOT activity_type = ?', Subject::REGISTERD])

  def self.add(user, activity_type, target, target2=nil)
    return false if user.blank? || activity_type.blank? || target.blank?
    Activity.create!(user: user, activity_type: activity_type, target: target, target2: target2)
  end

  def content
    case self.activity_type
    when Post::CREATED
      self.target.content
    when Review::CREATED
      self.target.content
    when Subject::REGISTERD
      self.target.periods.map(&:to_s).join(', ')
    when Note::CREATED
      self.target.content
    when File::UPLOADED
      self.target.name
    end
  end
end
