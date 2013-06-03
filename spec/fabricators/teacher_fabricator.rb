Fabricator(:teacher) do
  name { Faker::Name.name }
  subjects(:count => 2) { Fabricate(:subject) }
end
