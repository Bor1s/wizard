class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new
    session[:step] = @post.step = Post::STEPS.first

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    session[:step] = @post.step = Post::STEPS.first
  end

  # POST /posts
  # POST /posts.json
  def create
    session[:post] ||= {}
    session[:post].deep_merge!(params[:post].except(:image))

    @post = Post.new(session[:post])
    @post.image = params[:post][:image]
    @post.step = session[:step]


    if params[:prev_step].present?
      session[:step] = @post.prev_step
    else
      if @post.last_step? && @post.all_valid?
        @post.save
        clear_post_session
        redirect_to @post, notice: 'Post was successfully created.' and return
      else
        session[:step] = @post.next_step if @post.valid?
      end
    end
    render :new
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])
    session[:post] ||= {}
    session[:post].deep_merge!(params[:post].except(:image))
    @post.attributes = session[:post]
    @post.step = session[:step]

    if params[:prev_step].present?
      session[:step] = @post.prev_step
    else
      if @post.last_step? && @post.all_valid?
        @post.image = params[:post][:image]
        @post.update_attributes(session[:post])
        clear_post_session
        redirect_to @post, notice: 'Post was successfully updated.' and return
      else
        session[:step] = @post.next_step if @post.valid?
      end
    end
    render :edit
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
  
  private

  def clear_post_session
    session[:post] = nil
    session[:step] = nil
  end
end
