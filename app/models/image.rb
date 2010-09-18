require 'rexml/document'
class Image

  BASE_PATH = Rails.root.join 'tmp'
  OPENCV_LIB_PATH = Rails.root.join 'lib', 'opencv'

  class ImageFileError < Exception; end

  attr_accessor :file_name, :data

  def initialize(options={})
    file = options[:file]
    return unless file
    @file_name    = file.original_filename
    @data         = file.read
    @prepend_time = Time.now.to_i
  end

  def to_xml
    xml  = REXML::Document.new
    root = xml.add_element 'name'
    root.add_element 'name1'
    xml
  end

  def full_path
    return unless file_name
    path = BASE_PATH.join(prepend_time_before_saving).to_s
    return path if is_png?
    return path.sub /\.\w*$/, '.png'
  end

  def save!
    unless is_png?
      system("python #{OPENCV_LIB_PATH}/to_png.py #{full_path}")
    end
    File.open(full_path, "w"){|f| f.write data }
  end

  private

  def is_png?
    return unless file_name
    file_name.downcase.match(/\.png$/)
  end

  def prepend_time_before_saving
    @prepend_time ||= Time.now.to_i # set this if it is not set during object initialization
    raise ImageFileError, 'No file name present' unless file_name
    "#{@prepend_time}_#{file_name}"
  end

end
