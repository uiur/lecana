# encoding: UTF-8
Fabricator(:post) do
  content '私たちを剥製してください'
  user { Fabricate(:user) }
  postable { Fabricate(:subject) }
end
