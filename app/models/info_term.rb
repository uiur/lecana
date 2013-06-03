class InfoTerm < ActiveRecord::Base
  belongs_to :subject_info
  belongs_to :term
end
