class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  protect_from_forgery except: [ :addViewAddition, :create, :good, :bad, :comment ]

  # GET /articles/getFeed
  # param : my_id, hobby_id
  def getFeed
    login_user_id = params[:my_id].to_i
    login_user = User.find(login_user_id)

    hobby_id = params[:hobby_id].to_i

    limit_num = 20

    articles_new_hash = make_articles_hash(Article.where(hobby_id: hobby_id).order('id DESC').limit(limit_num), login_user)

    articles_hot_hash = make_articles_hash(Article.where(hobby_id: hobby_id).where('published_at >= ?', 1.weeks.ago).limit(limit_num), login_user)

    articles_legend_hash = make_articles_hash(Article.where(hobby_id: hobby_id).order('point DESC').limit(limit_num), login_user)

    if articles_new_hash.blank? && articles_hot_hash.blank? && articles_legend_hash.blank?
      res = {
        result: false,
        data: nil
      }
    else
      res = {
        result: true,
        data: [
          {
            segment_type: 'new',
            articles: articles_new_hash
          },
          {
            segment_type: 'hot',
            articles: articles_hot_hash
          },
          {
            segment_type: 'legend',
            articles: articles_legend_hash
          }
        ]
      }
    end

    render json: res
  end

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new( article_params )
    result = false

    if @article.save
      result = true
    end

    render json: { result: result }
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /article/addViewAddition
  # params: article_id, add_count
  def addViewAddition
    @article = Article.find( params[:article_id] )
    count = @article.view_count

    @article.update_attribute( :view_count, count + params[:add_count].to_i )

    culc_point

    render json: { result: true }
  end

  # POST /article/good
  # params: my_id, article_id
  def good
    @article = Article.find( params[:article_id] )
    @user = User.find( params[:my_id] )

    @article.liked_by @user

    culc_point

    render json: { result: true }
  end

  # POST /article/bad
  # params: my_id, article_id
  def bad
    @article = Article.find( params[:article_id] )
    @user = User.find( params[:my_id] )

    @article.downvote_from @user

    culc_point

    render json: { result: true }
  end

  # POST /article/comment
  # params: my_id, article_id, comment_body
  def comment
    @article = Article.find( params[:article_id] )
    @user = User.find( params[:my_id] )

    comment = @article.comments.create
    comment.user_id = params[:my_id]
    comment.comment = params[:comment_body]
    comment.save

    culc_point

    render json: { result: true }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :image_path, :contents, :view_count, :point, :published_at, :user_id, :hobby_id)
    end

    def culc_point # @article, @user に対象の記事があれば動きます
      point = 0

      @article.comments.each do |comment|
        user = User.find( comment.user_id )

        if user.voted_as_when_voted_for @article
          point += 1
        elsif (user.voted_as_when_voted_for @article) == false
          point -= 1
        end
      end

      point += @article.get_likes.size()
      point -= @article.get_dislikes.size()

      if @user.follows_of_from_user.count != 0 
        point /= @user.follows_of_from_user.count
      end

      @article.update_attribute( :point, point )
    end
end
