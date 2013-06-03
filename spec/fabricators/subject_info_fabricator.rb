# encoding: UTF-8
Fabricator(:subject_info) do
  room { sequence(:room, 10) {|i| "共北#{i}"}}
  year { 2012 }
  subject_id { sequence(:subject_id, 10) }
  periods!(:count => 2) { Period.detect(day: [*(1..5)].sample, ord: [*(1..5)].sample)}
  terms!(:count => 1) { Term.detect(ord: 1) }
end
