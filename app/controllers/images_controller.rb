class ImagesController < ApplicationController

  def new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    image = Image.new(:file => params[:upload][:image_file])
    image.save!


    # force text response until Jason fixes client to request json
    render :text => image.to_json

    #respond_to do |format|
      #format.html { render :text => image.to_json }
      #format.json { render :text => image.to_json }
      #format.xml { render :xml => image.to_xml }
    #end

  end

end
