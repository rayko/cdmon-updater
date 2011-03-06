class CustomLogger
  attr_accessor :path

  def initialize path
    self.path = path
  end

  def open_file
    unless File.exist? self.path
      File.open path, File::WRONLY | File::APPEND | File::CREAT
    else
      File.open path, File::WRONLY | File::APPEND
    end

  end

  def log text, type
    file = open_file
    file << "#{Time.now} - #{type}: #{text}\n"
    file.close
  end


  def info text
    log text, 'INFO'
  end

  def error text
    log text, 'ERROR'
  end
end
