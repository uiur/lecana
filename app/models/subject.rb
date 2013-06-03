class Subject < ActiveRecord::Base
  belongs_to :college
  has_and_belongs_to_many :teachers
  has_many :subject_infos, :dependent => :destroy
  has_many :posts, :as => :postable, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_many :activities, :as => :target2
  has_many :notes
  has_many :uploads

  acts_as_taggable

  accepts_nested_attributes_for :teachers
  accepts_nested_attributes_for :subject_infos

  before_validation :find_or_create_teachers

  validates :name, :presence => true
  validates :college_id, :presence => true

  searchable do 
    text :name, :boost => 2
    text :teachers do 
      teachers.map(&:name)
    end
    text :subject_infos do |subject|
      subject.subject_infos.map(&:room)
    end
    text :periods do
      subject_infos.map(&:periods).flatten.uniq.map(&:to_s)
    end
    text :tags do
      tags.map(&:name)
    end
    integer :terms, :multiple => true  do
      subject_infos.flat_map{|info| info.terms.map(&:ord) }
    end
    integer :subject_infos, :multiple => true do
      subject_infos.map(&:year)
    end
  end

  # SubjectInfo, Periodなども一緒につくる
  # attributes: {name: ?, college_id: ?, teachers: [{name: ?},..], room: ?, year: ?, periods: [{day: ?, ord: ?},..], terms: [1,..], tags: [..]}
  def self.create_with_infos(attributes)
    (subject, info) = self.new_with_infos(attributes)

    ActiveRecord::Base.transaction do 
      subject.save!
      info.save!
    end

    subject.tag_list = attributes[:tags]
    subject.save

    return subject
  end

  # for rake task
  def self.build!(attributes)
    subject = Subject.new(name: attributes['name'], college_id: attributes['college_id'])

    attributes['teachers'].each do |teacher|
      subject.teachers << Teacher.find_or_create_by_name(teacher['name'])
    end
    subject.save

    subject.build_infos!(attributes['infos'])
  end

  def build_infos!(infos)
    infos.each do |info|
      subject_info = self.subject_infos.new(room: info['room'], year: info['year'])
      info['periods'].each do |period|
        subject_info.periods << Period.detect(period)
      end

      if info['terms']
        info['terms'].each do |ord|
          subject_info.terms << Term.detect(ord: ord)
        end
      else
        subject_info.terms << Term.detect(ord: TERM)
      end
      subject_info.save
    end
  end

  def self.new_with_infos(attributes)
    subject = Subject.new(name: attributes[:name], college_id: attributes[:college_id])
    subject.load_infos(attributes)
  end

  def load_infos(attributes)
    subject = self
    info = subject.subject_infos.new(room: attributes[:room], year: attributes[:year])

    if attributes[:teachers]
      attributes[:teachers].each do |teacher|
        subject.teachers << Teacher.find_or_create_by_name(teacher[:name])
      end
    end

    if attributes[:periods]
      attributes[:periods].each do |period|
        info.periods << Period.detect(period)
      end
    end

    if attributes[:terms]
      attributes[:terms].each do |ord|
        info.terms << Term.detect(ord: ord)
      end
    else
      info.terms << Term.detect(ord: TERM)
    end

    return [subject, info]
  end


  # 曜時限でSubjectを検索する
  # period: { day: ?, ord: ? }
  # option: { year: ? }
  def self.find_by_period(period,option={year: YEAR})
    self.joins(:subject_infos => :periods).where(:subject_infos => { :year => option[:year], :periods => { day: period[:day], ord: period[:ord] }})
  end

  def periods(year=YEAR)
    self.info(year).periods
  end

  # 教室を返す
  def room(year=YEAR)
    self.info(year).room
  end

  def info(year=YEAR)
    self.subject_infos.where(year: year).first
  end

  def teacher_names
    self.teachers.select('name').map(&:name)
  end

  def terms(year=YEAR)
    self.info(year).terms
  end

  def rating_average
    m = ((r1 = self.reviews.average(:rating)) ? 1 : 0) + ((r2 = self.reviews.average(:rating2)) ? 1 : 0)
    return (m != 0) ? ((r1 + r2)/m) : nil
  end

  private
  # 教師名を一意にするため
  def find_or_create_teachers
    new_teachers = []
    self.teachers.each do |teacher|
      new_teachers << Teacher.find_or_create_by_name(teacher.name)
    end

    self.teachers = new_teachers
  end
end
