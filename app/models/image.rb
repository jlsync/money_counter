require 'rexml/document'
class Image

  BASE_PATH = Rails.root.join 'tmp'
  OPENCV_LIB_PATH = Rails.root.join 'lib', 'opencv'
  PUBLIC_IMG_PATH = Rails.root.join 'public'

  class ImageFileError < Exception; end

  attr_accessor :file_name

  def initialize(options={})
    file = options[:file]
    return unless file
    @file_name    = file.original_filename
    @data         = file.read
    @prepend_time = Time.now.to_i
  end

  def file_name=(file_name)
    @file_name = file_name
    @data      = BASE_PATH.join(file_name).read
  end

  def to_json
      {
        'file-name' => file_name,
        'radii'     => coins_radii,
        'image_url' => image_url,
        'total_money' => total,
      }.to_json
  end

  def to_xml
    xml  = REXML::Document.new
    root = xml.add_element 'name'
    root.add_element 'name1'
    xml
  end

  def full_path
    return unless file_name
    path = BASE_PATH.join(prepend_time).to_s
    return to_png(path)
  end

  def image_url
    p = Pathname.new(public_path)
    return p.basename.to_s
  end

  def public_path
    return unless file_name
    path = PUBLIC_IMG_PATH.join(prepend_time).to_s
    return to_png(path)
  end

  def save!
    unless is_png?
      system("python #{OPENCV_LIB_PATH}/to_png.py #{full_path}")
    end
    File.open(full_path, "w"){|f| f.write @data }
  end

  def total
    money = Money.new(diameters)
    return money.total
  end

  def set_coins_radii
    data   = `./lib/opencv/circledetect #{full_path} #{public_path.to_s}`
    get_radii = data.split("\n").map{|x| x.scan(/radius=(?=(.*))/) }.flatten
    @radii = get_radii.map &:to_f
  end

  def coins_radii
    @radii ||= set_coins_radii
  end

  def diameters
    coins_radii.map{|radius| 2 * radius}
  end

  private

  def is_png?
    return unless file_name
    file_name.downcase.match(/\.png$/)
  end

  def prepend_time
    @prepend_time ||= Time.now.to_i # set this if it is not set during object initialization
    raise ImageFileError, 'No file name present' unless file_name
    "#{@prepend_time}_#{file_name}"
  end

  def to_png(path)
    return path if is_png?
    path.sub /\.\w*$/, '.png'
  end

end
