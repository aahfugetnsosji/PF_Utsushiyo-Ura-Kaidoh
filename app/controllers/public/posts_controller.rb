class Public::PostsController < ApplicationController
  def index
    @posts = Post.all
  end
  
  def new
    @tags = Tag.all
    @regions = Region.all
    @prefectures = Prefecture.all
    @post = Post.new
    @post.user_id = current_user.id
    @post.post_tags.build
    @post.post_prefectures.build
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
    @post_comments = @post.post_comments.all
  end
  
  def create
    post = Post.new(post_params)
    post.user_id = current_user.id
    if post.valid?
      post.save!
      redirect_to post_path(post.id)
      flash[:notice] = "投稿しました。"
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    @tags = Tag.all
    @regions = Region.all
    @prefectures = Prefecture.all
  end
  
  def update
    post = Post.find(params[:id])
    post.user_id = current_user.id
    post.update(post_params)
    redirect_to post_path(post.id)
  end
  
  def destroy
    post = Post.find(params[:id])
    if post.user_id == current_user.id
      post.destroy
      redirect_to mypage_path
      flash[:notice] = "投稿を削除しました。"
    else
      render :show
    end
  end
  
  private
  
  def post_params
    params.require(:post).permit(
      :title, :body, :image, :region_id, :user_id,
      post_prefectures_attributes: [:post_id, :prefecture_id],
      post_tags_attributes: [:post_id, :tag_id]
    )
  end
end
