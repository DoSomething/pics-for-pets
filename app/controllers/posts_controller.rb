class PostsController < ApplicationController
  include Services

  before_filter :is_not_authenticated
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found
    render :not_found
  end

  def not_found
    respond_to do |format|
      format.html
    end
  end

  # GET /posts
  # GET /posts.json
  def index
    page = params[:page] || 0
    offset = (page.to_i * Post.per_page)

    @posts = Post
              .joins('LEFT JOIN shares ON shares.post_id = posts.id')
              .select('posts.*, COUNT(shares.*) AS share_count')
              .where(:flagged => false)
              .group('shares.post_id, posts.id')
              .order('posts.created_at DESC')
              .limit(Post.per_page)
    if !params[:last].nil?
      @posts = @posts.where('posts.id < ?', params[:last])
    else
      @posts = @posts.offset(offset)
    end
    @count = Post.where(:flagged => false).count

    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.json { render json: @posts }
      format.csv { render csv: @posts }
    end
  end

  # GET /(cat|dog|other)s?
  # GET /([A-Z]{2})
  # GET /(cat|dog|other)s?-([A-Z]{2})
  # GET /featured
  # GET /mypics
  def filter
    if params[:atype].is_a? String
      # Cats isn't a valid filter, but cat is.  Let's chop off
      # the "s" if it exists.
      params[:atype] = params[:atype].chop unless params[:atype][-1,1] != 's'
    end

    page = params[:page] || 0
    offset = (page.to_i * Post.per_page)

    # Preliminary queries.  These are "finished" later.
    @posts = Post
               .joins('LEFT JOIN shares ON shares.post_id = posts.id')
               .select('posts.*, COUNT(shares.*) AS share_count')
               .where(:flagged => false)
               .group('posts.id, shares.post_id')
               .order('posts.created_at DESC')
               .limit(Post.per_page)
    @count = Post
              .order('posts.created_at DESC')
              .where(:flagged => false)

    if params[:run] == 'animal'
      @posts = @posts.where(:animal_type => params[:atype])
      @count = @count.where(:animal_type => params[:atype]).count
    elsif params[:run] == 'state'
      @posts = @posts.where(:state => params[:state])
      @count = @count.where(:state => params[:state]).count
    elsif params[:run] == 'both'
      @posts = @posts.where(:animal_type => params[:atype], :state => params[:state])
      @count = @count.where(:animal_type => params[:atype], :state => params[:state]).count
    elsif params[:run] == 'featured'
      @posts = @posts.where(:promoted => true)
      @count = @count.where(:promoted => true).count
    elsif params[:run] == 'my'
      user_id = session[:drupal_user_id]
      @posts = @posts.where('shares.uid = ? OR posts.uid = ?', user_id, user_id)
      @count = @count
               .joins('LEFT JOIN shares ON shares.post_id = posts.id')
               .where('shares.uid = ? OR posts.uid = ?', user_id, user_id)
               .count
    end

    if !params[:last].nil?
      @posts = @posts.where('posts.id < ?', params[:last])
    else
      @posts = @posts.offset(offset)
    end

    @path = request.fullpath[1..-1]
    respond_to do |format|
      format.js
      format.html
      format.json { render json: @posts }
      format.csv { send_data @posts.as_csv }
    end
  end

  def autoimg
    path = params[:file].tempfile.path()
    name = params[:file].original_filename
    dir = 'public/system/tmp'

    if !File.exists? path
      render json: { 'success' => false }
    else
      if File.exists? dir and File.exists? path
        newfile = File.join(dir, name)
        File.open(newfile, 'wb') { |f| f.write(params[:file].tempfile.read()) }
      end
    end

    render json: { 'success' => true, 'filename' => name }
  end

  # GET /alterimg/1
  # Alters image by adding top and bottom text, within semi-transparent block.
  def alterimg
    @post = Post.find(params[:id])
    image = @post.image.url(:gallery)
    image = '/public' + image.gsub(/\?.*/, '')

    if File.exists? Rails.root.to_s + image
      PostsHelper.image_writer(image, @post.top_text, @post.bottom_text)
    end
    
    respond_to do |format|
      format.html { redirect_to show_post_path(@post) }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post
              .where(:id => params[:id], :flagged => false)
              .joins('LEFT JOIN shares ON shares.post_id = posts.id')
              .select('posts.*, COUNT(shares.*) AS share_count')
              .group('shares.post_id, posts.id')
              .order('posts.created_at DESC')
              .limit(Post.per_page)
              .first

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
      format.csv { send_data @post.as_csv }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    # Shouldn't be here if they're not an admin.
    if !admin?
      redirect_to :root
    end

    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    render :status => :forbidden unless authenticated?

    params[:post][:uid] = session[:drupal_user_id]
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html { redirect_to alter_image_path(@post) }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    # Shouldn't be here if they're not an admin.
    if !admin?
      redirect_to :root
    end

    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to show_post_path(@post), notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    # Shouldn't be here if they're not an admin.
    if !admin?
      redirect_to :root
    end

    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end


  def flag
    # Shouldn't be here if they're not an admin.
    if !admin?
      redirect_to :root
    end

    @post = Post.find(params[:id])
    @post.flagged = true
    @post.save

    respond_to do |format|
      format.html { redirect_to request.env["HTTP_REFERER"] }
    end
  end

  def loaderio
    render :text => 'loaderio-41509449f6c0cd90528875300c3606af'
  end
end
