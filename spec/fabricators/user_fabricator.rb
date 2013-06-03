# encoding: UTF-8

Fabricator(:user) do
  name { 'yukio' + sequence(:name).to_s  }
  image_url { 'http://a3.twimg.com/profile_images/1626980170/NEKO_glitch.jpeg' }
end
