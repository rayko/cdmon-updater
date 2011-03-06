pid = File.new 'proc.pid', 'w'
pid << Process.pid
pid.close

require 'timer'

timer = Timer.new
timer.run

