# encoding: UTF-8
#
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 大学のデータ
College.create(YAML::load(File.open("db/data/colleges.yml")))
kyoto = College.find_by_name('京都大学')

# 学部のデータ
FACULTIES = YAML::load(File.open("db/data/faculties/ku.yml"))

FACULTIES.each do |f|
  kyoto.faculties.create(f)
end

# 曜時限のデータ
(0..6).each do |day|
  (0..9).each do |ord|
    Period.create(:day => day, :ord => ord)
  end
end

# 学期のデータ
(0..5).each do |ord|
  Term.create(ord: ord)
end
