class ImagesController < ApplicationController
  # GET /images
  # GET /images.xml
  def index
    #@images = Image.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /images/1
  # GET /images/1.xml
  def show
    #@image = Image.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /images/new
  # GET /images/new.xml
  def new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /images/1/edit
  def edit
    #@image = Image.find(params[:id])
  end

  # POST /images
  def create

    @filename = params[:upload][:image_file].original_filename
    uploaded = params[:upload][:image_file].read

    f = File.open("/tmp/" + @filename, "w")
    f.write uploaded
    f.close

    respond_to do |format|
      format.html { render :text => "the image filename was #{@filename} and it's size was #{uploaded.size.to_s} and the amount of money was #{"XXX.XX"}" }
    end

  end

  # PUT /images/1
  # PUT /images/1.xml
  def update
    @image = Image.find(params[:id])

    respond_to do |format|
      if @image.update_attributes(params[:image])
        format.html { redirect_to(@image, :notice => 'Image was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.xml
  def destroy
   # @image = Image.find(params[:id])
   # @image.destroy

    respond_to do |format|
      format.html { redirect_to(images_url) }
      format.xml  { head :ok }
    end
  end
end
