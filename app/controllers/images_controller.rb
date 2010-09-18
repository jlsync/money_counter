class ImagesController < ApplicationController

  def new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    image = Image.new(:file => params[:upload][:image_file])
    image.save!

    respond_to do |format|
      format.html { render :text => "the image filename was #{image.file_name} and it's size was #{image.data.size} and the amount of money was #{"XXX.XX"}" }
      format.xml { render :xml => image.new.to_xml }
    end

  end

end
