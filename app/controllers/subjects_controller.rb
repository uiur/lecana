# encoding: UTF-8

class SubjectsController < ApplicationController

  # GET /search
  # GET /subjects
  # GET /subjects.json
  def index
    @ord_scope = 1..2
    @checked_terms = []
    @years = SubjectInfo.select("DISTINCT year").map(&:year)
    params.each do |name, value|
      if name =~ /^term_(\d+)$/
        @checked_terms << $1.to_i
      end
    end
    terms = @checked_terms.empty? ? @ord_scope.to_a : @checked_terms

    @search = Sunspot.search(Subject) do
      fulltext params[:search]
      paginate :page => params[:page], :per_page => 20
      with :terms, terms
      with :subject_infos, params[:year]
    end
    @subjects = @search.results

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subjects }
    end
  end

  # GET /subjects/1
  # GET /subjects/1.json
  def show
    @subject = Subject.find(params[:id])

    unless @subject.info(params[:year])
      params[:year] = @subject.subject_infos.first.year
    end
    @year = params[:year]
    
    @users = User.registering(@subject, @year)

    @years = @subject.subject_infos.map(&:year)
    @teachers = @subject.teachers
    @periods = @subject.periods(@year)
    @terms = @subject.terms(@year)

    @posts = @subject.posts.page(params[:posts_page]).per(10)
    @reviews = @subject.reviews.page(params[:reviews_page]).per(10)

    @note = Note.recent(@subject)

    @upload = Upload.new
    
    @updated = @subject.activities.first.try(:updated_at)

    if signed_in?
      @post = Post.new
      @review = Review.new
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subject }
      format.atom { render :layout => false }
    end
  end

  # GET /subjects/new
  # GET /subjects/new.json
  def new
    @subject = Subject.new
    @subject.subject_infos.build
    @subject.teachers.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subject }
    end
  end

  # GET /subjects/1/edit
  def edit
    @subject = Subject.find(params[:id])
  end

  # POST /subjects
  # POST /subjects.json
  def create
    @subject = Subject.new(params[:subject])

    respond_to do |format|
      if @subject.save
        format.html { redirect_to @subject, notice: '授業科目を作成しました！' }
        format.json { render json: @subject, status: :created, location: @subject }
      else
        format.html { render action: "new" }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # 時間割に登録する
  def register
    @subject = Subject.find(params[:id])
    @year = params[:year]
    @users = User.registering(@subject, @year)
    if signed_in?
      unless current_user.register(@subject.info(@year))
        flash[:error] = '登録できる科目は一つの時限に3つまでです!'
      end
    else
      flash[:error] = 'なにかエラーがあるようです。もう一度試してみてください'
    end
  end

  # 登録済み科目を時間割から取り除く
  def remove
    @subject = Subject.find(params[:id])
    @year = params[:year]
    @users = User.registering(@subject, @year)
    if signed_in?
      current_user.remove(@subject.info(@year))
    else
      flash[:error] = 'なにかエラーが起きたようです。もう一度試してみてください'
    end
  end

  # 授業にタグを追加する
  def create_tag
    subject = Subject.find(params[:subject_id])
    subject.tag_list << params[:tag]
    subject.save

    redirect_to subject , :notice => "タグ 「#{params[:tag]}」を追加しました！"
  end

  # 授業のタグをとりのぞく
  def remove_tag
    subject = Subject.find(params[:subject_id])
    subject.tag_list.delete params[:tag]
    subject.save

    redirect_to subject , :notice => "タグ 「#{params[:tag]}」を取り除きました"
  end
end
