# encoding: UTF-8
namespace :db do 
  namespace :populate do 
    desc "テスト用科目データを作る"
    task :subjects => :environment do
      infos = YAML.load(File.open("db/data/test/subjects.yml"))

      infos.each do |info|
        Subject.build!(info)
      end
    end

    desc "KULASISのデータたちを入植させる"
    task :kulasis_ => :environment do
      infos = YAML.load(File.open("db/data/kulasis/kulasis_common_.yml"))

      infos.each do |info| 
        Subject.create_with_infos(adapt_kulasis(info))
      end
    end

    desc "KULASISの専門科目を全部入れる"
    task :kulasis_all => :environment do
      Types.each do |k,v|
        v.each do |k2,v2|
          p Types[k][k2]
          infos = YAML.load(File.open("db/data/kulasis/kulasis_#{k2.to_s}_#{k.to_s}.yml"))
 
          p infos.first
          infos.each do |info| 
            Subject.create_with_infos(adapt_kulasis(info, {year: 2011, type: k2, type2: k, college_id: 1}))
          end
        end
      end
    end

    desc "KULASISの科目を全部入れる。2011年度分も"
    task :kulasis => :environment do
      puts "YAMLのロード"
      subjects_row = []
      infos = YAML.load(File.open("db/data/kulasis/kulasis_common_.yml"))
      infos.each do |info|
        info = adapt_kulasis(info, {year: 2011, type: :let, type2: :u, college_id: 1})
      end
      subjects_row += infos
      Types.each do |k,v|
        v.each do |k2,v2|
          p Types[k][k2]
          infos = YAML.load(File.open("db/data/kulasis/kulasis_#{k2.to_s}_#{k.to_s}.yml"))
          infos.each do |info|
            info = adapt_kulasis(info, {year: 2011, type: k2, type2: k, college_id: 1})
          end
          subjects_row += infos
        end
      end
      infos = YAML.load(File.open("db/data/kulasis/2012/kulasis_common_.yml"))
      infos.each do |info|
        info = adapt_kulasis(info, {year: 2012, type: :let, type2: :u, college_id: 1})
      end
      subjects_row += infos
      Types.each do |k,v|
        v.each do |k2,v2|
          p Types[k][k2]
          infos = YAML.load(File.open("db/data/kulasis/2012/kulasis_#{k2.to_s}_#{k.to_s}.yml"))
          infos.each do |info|
            info = adapt_kulasis(info, {year: 2012, type: k2, type2: k, college_id: 1})
          end
          subjects_row += infos
        end
      end

      puts "subjectsとsubject_infosをユニークに作る"
      subjects = {}
      subject_infos = {}
      
      subjects_row.each_with_index do |s|
        k_of_subjects = [s[:name], (s[:teachers]).map{|t| t[:name]}.sort].flatten.join("_")
        k_of_subject_infos = [k_of_subjects, s[:year], s[:room]].flatten.join("_")
        
        tags = []
        if subjects[k_of_subjects] then
          tags += subjects[k_of_subjects][:tags]
        end
        tags += s[:tags]
        tags.uniq!
        subjects[k_of_subjects] = {:name => s[:name], :college_id => s[:college_id], :teachers => s[:teachers],
          :tags => tags}
        subject_infos[k_of_subject_infos] = {:subject_key => k_of_subjects,
          :room => s[:room], :year => s[:year], :periods => s[:periods], :terms => s[:terms]}
      end

      puts "subjectsのINSERT"
      subject_key_to_id = {}
      subjects.each do |k, s|
        if true || Subject.where(:name => s[:name], :college_id => s[:college_id]).empty? then
          subject = Subject.new()
          subject.name = s[:name]
          subject.college_id = s[:college_id]
          subject.save!
        end
        s[:teachers].each do |t|
          if !subject.teachers.map{|t| t.name}.include?(t[:name])
            teacher = Teacher.find_by_name(t[:name])
            if !teacher
              teacher = Teacher.new()
              teacher.name = t[:name]
              teacher.save!
            end
            subject.teachers << teacher
          end
        end
        subject.tag_list += s[:tags]
        subject.save!
        subject_key_to_id[k] = subject.id
      end

      puts "subject_infosのINSERT"
      subject_infos.each do |k, s|
        si = SubjectInfo.new()
        si.subject_id = subject_key_to_id[s[:subject_key]]
        si.room = s[:room]
        si.year = s[:year]
        if s[:periods]
          s[:periods].each do |p|
            si.periods << Period.where(p)
          end
        end
        if s[:terms]
          s[:terms].each do |t|
            si.terms << Term.where(:ord => t)
          end
        end
        si.save!
      end
    end

    desc "カニバリズム山脈からデータをイミグレする"
    task :cannibalism => :environment do
      require 'open-uri'
      puts "YAMLのロード"
      inports = YAML.load(open("db/data/cannibalism/db.yml").read)

      uotn = {}

      puts "ユーザーのINSERT"
      inports[:users].each_pair do |k, v|
        u = User.new
        u.name = v[:name]
        u.created_at = v[:created_at]
        u.updated_at = v[:updated_at]
        begin
          raise
          str = URI.parse("http://twitter.com/" + v[:name] ).read
          str =~ /"profile-user".*?src="(.*?)"/m
          url = $+
          url = url.split(//e).reverse.join
          url = url.sub( /(lamron_|inim_|reggib_)/ , "" )
          url = url.sub(/\./, ".lamron_")
          u.image_url = url.split(//e).reverse.join
        rescue
          u.image_url = "http://a0.twimg.com/sticky/default_profile_images/default_profile_1_normal.png"
        end
        u.save!
        begin
          u.update_imageurl!
        rescue
        end

        uotn[k] = u

        a = Userauth.new(v[:auth])
        a.user_id = u.id
        a.created_at = v[:created_at]
        a.updated_at = v[:updated_at]
        a.save!
      end

      puts "subjectsとsubject_infosへ、旧データを対応付ける"
      sotn = {}
      siotn = {}
      error = []
      errori = []
      inports[:subjects].each_pair do |k, v|
        ss = Subject.select("DISTINCT subjects.*").where(name: [v[:name], v[:name].tr('ａ-ｚＡ-Ｚ０-９', 'a-zA-Z0-9')])
        if ss.size == 1 then
          sotn[k] = ss.first
        elsif ss.size > 1 then
          ss.each do |s|
            v_teachers = [v[:lecturer], v[:lecturer2]].compact.map{|t| (tn = t.gsub(/[\s　]/, "")) == "" ? nil : tn}.compact.sort
            o_teachers = s.teachers.map{|t| t.name}.sort
            if (v_teachers.size > 0 && o_teachers.include?(v_teachers[0])) && (v_teachers.size == 1 || o_teachers.include?(v_teachers[1]))
              sotn[k] = s
              break
            else
              si = s.subject_infos.where(:year => 2011)
              if si.size == 1 then
                sotn[k] = si.first.subject
                siotn[k] = si.first
              else
                si.each do |si_|
                  if /#{si_.periods.map{|p| p.to_s.gsub(/[曜限]/, "")}.join("|")}/ =~ v[:periods] || si_.periods.map{|p| p.to_s}.include?("その他")
                    sotn[k] = si_.subject
                    siotn[k] = si_
                    break
                  elsif si_.room == v[:place]
                    sotn[k] = si_.subject
                    siotn[k] = si_
                  end
                end
              end
            end
          end
          if !sotn[k]
            error << [2, k ,v, ss]
          end
        else
          error << [0, k, v]
        end
        if !siotn[k] && sotn[k] then
          si = sotn[k].subject_infos.where(:year => 2011)
          if si.size == 1 then
            siotn[k] = si.first
          else
            si.each do |si_|
              if /#{si_.periods.map{|p| p.to_s.gsub(/[曜限]/, "")}.join("|")}/ =~ v[:periods] || si_.periods.map{|p| p.to_s}.include?("その他")
                siotn[k] = si_
                break
              elsif si_.room == v[:place]
                siotn[k] = si_
                break
              end
            end
          end
        end
        if !siotn[k] then
          errori << [0, k, v, sotn[k]]
        end
      end
      puts "subjectsエラー数: #{error.size} / #{inports[:subjects].size}"
      puts "subject_infosエラー数: #{errori.size} / #{inports[:subjects].size}\n"
      
      puts "postsのINSERT"
      potn = {}
      inports[:posts].each do |k,v|
        next unless sotn[v[:subject_id_]]
        p = Post.new
        p.user = uotn[v[:user_id_]]
        p.postable_id = sotn[v[:subject_id_]].id
        p.postable_type = "Subject"
        p.content = v[:content][0...200]
        p.created_at = v[:created_at]
        p.updated_at = v[:updated_at]
        p.save!
        potn[k] = p
      end
      
      puts "tagsのINSERT"
      inports[:tags].each do |k,v|
        next unless (subject = sotn[v[:subject_id_]])
        subject.tag_list << v[:name]
        subject.save!
      end
      
      puts "reviewsのINSERT"
      rotn = {}
      inports[:reviews].each do |k,v|
        next unless sotn[v[:subject_id_]]
        r = Review.new
        r.user = uotn[v[:user_id_]]
        r.subject = sotn[v[:subject_id_]]
        r.rating = v[:rating]
        r.rating2 = v[:rating2]
        r.content = v[:content]
        r.created_at = v[:created_at]
        r.updated_at = v[:updated_at]
        r.save!
        rotn[k] = r
      end
      
      puts "favsのINSERT"
      inports[:favs].each do |k,v|
        f = Fav.new
        if v[:favable_type] == "Post"
          next unless potn[v[:favable_id_]]
          f.favable_id = potn[v[:favable_id_]].id
        else
          next unless rotn[v[:favable_id_]]
          f.favable_id = rotn[v[:favable_id_]].id
        end
        f.user = uotn[v[:user_id_]]
        f.favable_type = v[:favable_type]
        f.created_at = v[:created_at]
        f.updated_at = v[:updated_at]
        f.save!
      end
      
      puts "uploadsのINSERT"
      inports[:uploads].each do |k,v|
        next unless sotn[v[:subject_id_]]
        begin
          Upload.find_by_sql("INSERT INTO uploads (subject_id, user_id, name, file) VALUES(#{sotn[v[:subject_id_]].id}, #{uotn[v[:user_id_]].id}, \"#{v[:name]}\", \"#{v[:file]}\")")
        rescue
        end
        Upload.where(subject_id: sotn[v[:subject_id_]].id, name: v[:name]).update_all(created_at: v[:created_at], updated_at: v[:updated_at])
      end
      
      puts "subject_infos_usersのINSERT"
      inports[:sius].each do |k,v|
        next unless siotn[v[:subject_id_]]
        s = SubjectInfosUser.new
        s.subject_info = siotn[v[:subject_id_]]
        s.user = uotn[v[:user_id_]]
        s.save!
      end
    end


    desc "2012年度KULASISの科目を修復する。"
    task :fix_2012 => :environment do
      subjects_row = []
      puts "YAMLのロード"
      infos = YAML.load(File.open("db/data/kulasis/2012/kulasis_common_.yml"))
      infos.each do |info|
        info = adapt_kulasis(info, {year: 2012, type: :let, type2: :u, college_id: 1})
      end
      subjects_row += infos
      Types.each do |k,v|
        v.each do |k2,v2|
          p Types[k][k2]
          infos = YAML.load(File.open("db/data/kulasis/2012/kulasis_#{k2.to_s}_#{k.to_s}.yml"))
          infos.each do |info|
            info = adapt_kulasis(info, {year: 2012, type: k2, type2: k, college_id: 1})
          end
          subjects_row += infos
        end
      end

      puts "subjects_row.each do ..."
      subjects_row.each do |s|
        sis = SubjectInfo.includes(:periods,
                                   :terms,
                                   :subject => :teachers
                                   ).where(:subject => {:name => s[:name],
                                                        :teachers => {:name => s[:teachers].map{|t| t[:name]
                                                                                                }.empty_to_nil}},
                                           :year => 2012, :room => s[:room],
                                           :periods => {:id => s[:periods].map{|p| Period.where(p).first.id}},
                                           :terms => {:ord => s[:terms]}
                                           ).map{|s| s}
        if sis.size != s[:teachers].size_left_join * s[:periods].size_left_join * s[:terms].size_left_join then
          si = nil
          sis.uniq!
          sis.each do |si_|
            if si_[:room] == s[:room] &&
               si_.subject.teachers.map{|t| t.name}.sort == s[:teachers].map{|t| t[:name]}.sort &&
               si_.periods.map{|p| {:ord => p.ord, :day => p.day}} == s[:periods] &&
               si_.terms.map{|t| t.ord}.sort == s[:terms].sort then
              si = si_
              break;
            else
              next
            end
          end
          if si then
            (sis - [si]).each do |si_|
              if si_.subject.teachers.map{|t| t.name}.sort == s[:teachers].map{|t| t[:name]}.sort &&
                 si_.periods.map{|p| {:ord => p.ord, :day => p.day}} == s[:periods] &&
                 si_.terms.map{|t| t.ord}.sort == s[:terms].sort then
                si.users = si.users | si_.users
                si_.users = []
                si_.periods = []
                if (su_ = si_.subject).subject_infos.size == 1 then
                  su = si.subject
                  su.activities += su_.activities
                  su.posts += su_.posts
                  su.notes += su_.notes
                  su.uploads += su_.uploads
                  su.tag_list = su.tag_list | su_.tag_list
                  su.save!
                  su_.destroy
                end
                si_.destroy
              end
            end
            next;
          end
          su = nil
          Subject.includes(:teachers,
                           :subject_infos
                           ).where(:name => s[:name],
                                   :teachers => {:name => s[:teachers].map{|t| t[:name]}.empty_to_nil},
                                   :subject_infos => {:year => 2011}
                                   ).uniq.each do |su_|
            if su_.teachers.map{|t| t.name}.sort == s[:teachers].map{|t| t[:name]}.sort &&
               su_.subject_infos.where(:year => 2012).empty? then
              su = su_
            end
          end
          if !su then
            su = Subject.new
            su.name = s[:name]
            s[:teachers].each do |t_|
              t = Teacher.find_by_name(t_[:name])
              if !t then
                t = Teacher.new
                t.name = t_[:name]
                t.save!
              end
              su.teachers << t
            end
            su.tag_list = s[:tags]
            su.college_id = 1
            su.save!
          end
          si = SubjectInfo.new
          si.subject = su
          si.periods = s[:periods].map{|p| Period.where(p)}.flatten
          si.terms = Term.where(ord: s[:terms])
          si.room = s[:room]
          si.year = 2012
          si.save!
        else
          si = sis.first
        end
      end

      puts "subject_infosについて、2012年度で1つのsubjectが対応するようにする"
      Subject.find_by_sql("SELECT s.* FROM subjects s INNER JOIN (SELECT subject_id FROM subject_infos WHERE year=2012 GROUP BY subject_id HAVING COUNT(*) > 1) si ON s.id=si.subject_id").each do |su|
        su.subject_infos.where(:year => 2012).each do |si|
          if si.subject.subject_infos.where(:year => 2012).size == 1 then
            break;
          end
          su_ = Subject.new
          su_.name = su.name
          su_.college_id = 1
          su_.teachers = su.teachers
          su_.tag_list = su.tag_list
          su_.save!
          si.subject = su_
          si.save!
        end
      end

      puts "periodsのないsubject_infosに、その他を入れてあげる"
      SubjectInfo.includes(:periods).where(:periods => {:id => nil}).each do |si|
        si.periods = Period.where(day: 0, ord: 0)
        si.save!
      end
    end

  end

  namespace :admin do
    desc '初めのユーザに管理者権限をつける'
    task :on => :environment do
      u = User.first
      u.admin = true
      u.save
      p User.first
    end
  end
end

Types = 
{g: 
  {let: '文学研究科', 
    ed: '教育学研究科', 
    ec: '経済学研究科', 
    p: '薬学研究科', 
    t: '工学研究科', 
    ene: 'エネルギー科学研究科', 
    aa: 'アジア・アフリカ地域研究研究科', 
    i: '情報学研究科', 
    ert: '地球環境学舎', 
    man: '経営管理大学院'}, 
 u: 
 {let: '文学部',
   ed: '教育学部',
   ec: '経済学部', 
   l: '法学部', 
   s: '理学部', 
   med: '医学部医学科', 
   medh: '医学部人間健康科学科', 
   p: '薬学部', 
   t: '工学部', 
   a: '農学部', 
   h: '総合人間学部' }}

def adapt_kulasis(info, option={year: 2011, type: :let, type2: :u, college_id: 1})

  if !info[:teachers][0].is_a?(Hash)
    info[:teachers].map!{|t| t.blank? ? nil : {name: t} }
  end
  info[:teachers].compact!

  info[:terms] = case info[:term]
                when '前期', '前期集中'
                  [1]
                when '後期', '後期集中'
                  [2]
                when '通年', '通年集中'
                  [1,2]
                end

  info[:periods].map! do |name|
    day,ord = false, false
    ['月','火','水','木','金','土'].each_with_index do |d,i|
      if name =~ Regexp.new(d)
        day = i+1 
        break
      end
    end

    (1..5).each do |i|
      if name =~ Regexp.new(i.to_s)
        ord = i 
        break
      end
    end

    if name == 'その他'
      day, ord = 0, 0
    end

    (day && ord) ? {day: day, ord: ord} : nil
  end
  info[:periods].compact!

  info[:tags] = []
  if info[:faculty] == :common
    info[:tags] << "全学共通科目"
  elsif option[:type]
    faculty = Types[option[:type2]][option[:type]]
    info[:tags] << faculty
    info[:tags] << info[:course] if info[:course]
  end

  unless info[:category].blank?
    info[:tags] << info[:category]
  end

  info[:year] = option[:year]

  info[:college_id] = option[:college_id]

  info[:name] = info[:name].tr('ａ-ｚＡ-Ｚ０-９', 'a-zA-Z0-9')

  return info
end

class Array
  def size_left_join
    self.empty? ? 1 : self.size
  end
  def empty_to_nil
    self.empty? ? nil : self
  end
end

class NilClass
  def size_left_join
    1
  end
  def empty_to_nil
    nil
  end
  def sort
    []
  end
end

