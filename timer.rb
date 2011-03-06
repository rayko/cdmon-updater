require 'yaml'
require 'custom-logger'
require 'cdmon-updater'

class Timer
  attr_accessor :settings, :log, :time, :updater

  def initialize
    self.settings = YAML::load_file 'settings.yml'
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

