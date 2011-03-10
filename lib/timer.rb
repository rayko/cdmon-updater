require 'yaml'
require 'custom-logger'
require 'cdmon-updater'
require 'pathname'

class Timer
  attr_accessor :settings, :log, :time, :updater, :path

  def initialize path
    self.path = Pathname.new path
    self.settings = YAML::load_file self.path.join 'settings.yml'
    self.log = CustomLogger.new self.settings[:logger][:path]
    self.time = self.settings[:timer][:ok]
    self.updater = CDmonUpdater.new self.log, self.settings
  end

  def run
    while true do
      sleep(self.updater.update_ip)
    end
  end
end

