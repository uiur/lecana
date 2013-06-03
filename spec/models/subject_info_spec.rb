# encoding: UTF-8
require 'spec_helper'

describe SubjectInfo do
  describe 'validation: uniqueness of year ' do
    before do
      @s = Fabricate(:subject)
    end
    subject { @s.subject_infos.build(year: 2012, room: 'hoge') }
    it { should be_invalid }
    it { should have(1).errors_on(:year) }
  end
end
