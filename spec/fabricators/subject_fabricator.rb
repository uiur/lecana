# encoding: UTF-8

Fabricator(:subject) do
  name {  ['剥製','人肉嗜好','搾取','降霊術'].sample + ['入門', '基礎論','続論'].sample }
  college! { College.first || Fabricate(:college) }
  teachers!(:count => 2)
  subject_infos!(:count => 1)
end
