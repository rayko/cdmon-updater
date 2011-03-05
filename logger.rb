class Logger
  attr_accessor :file

  def initialize path
    unless File.exist? path
      self.file = File.open path, 'w'
    else
      self.file = File.open path, 'a'
    end
  end

  def log text
    self.file << Time.now.to_s + text + '\n'
  end

  def close
    self.file.close
  end
end
