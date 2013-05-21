require 'fileutils'
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

  # GET /show/(cat|dog|other)s?
  def filter
    if !params[:filter].nil?
      filter = params[:filter]
    elsif !params[:atype].nil?
      filter = params[:atype]
    end

    # Cats isn't a valid filter, but cat is.  Let's chop off
    # the "s" if it exists.
    filter = filter[0..-2] if filter[-1,1] == 's'

    if params[:run] == 'animal'
      @posts = Post.where(:animal_type => filter)
    elsif params[:run] == 'state'
      @posts = Post.where(:state => filter)
    elsif params[:run] == 'both'
      @posts = Post.where(:animal_type => filter, :state => params[:state])
    end

    render :index
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
      format.html { redirect_to @post }
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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
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
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
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
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
end
