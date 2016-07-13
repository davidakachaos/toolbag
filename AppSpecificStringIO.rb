class AppSpecificStringIO < StringIO
  attr_accessor :filepath

  def initialize(path, text)
    super(text)
    @filepath = path
  end

  def original_filename
    File.basename(filepath)
  end
end
