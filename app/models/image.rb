require 'rexml/document'
class Image

  BASE_PATH = Rails.root.join 'tmp'
  OPENCV_LIB_PATH = Rails.root.join 'lib', 'opencv'

  class ImageFileError < Exception; end

  attr_accessor :file_name, :data

  def initialize(options={})
    file = options[:file]
    return unless file
    @file_name = file.original_filename
    @data = file.read
  end

  def to_xml
    xml = REXML::Document.new
    root = xml.add_element 'name'
    root.add_element 'name1'
    xml
  end

  def full_path
    return unless file_name
    BASE_PATH.join(prepend_time_before_saving).to_s
  end

  def save!
    unless is_png?
      system("python #{OPENCV_LIB_PATH/to_png.py} #{full_path}")
    end
    File.open(full_path, "w"){|f| f.write data }
  end

  private

  def is_png?
    return unless file_name
    file_name.downcase.match(/\.png$/)
  end

  def prepend_time_before_saving
    raise ImageFileError, 'No file name present' unless file_name
    "#{Time.now.to_i}_#{file_name}"
  end

end
