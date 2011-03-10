require 'pathname'
require 'fileutils'
path = Pathname.new($0).parent.realpath.join('lib')

$LOAD_PATH << path

if ARGV[0] == 'install'
  puts 'Installing CDmon Updater...'
  if File.exist? 'run'
    File.chmod 755, 'run'
    require 'create-init-script'
    puts 'Generating init script...'
    begin
      init.generate
      init = InitScript.new
    rescue => error
      puts 'Cannot generate the script. Terminating installation.'
      exit
    end
    FileUtils.move 'lib/cdmon-updater', '/etc/init.d/'
    puts 'Init script installed.'
  else
    puts 'Error: File not found "run"'
  end
  puts 'Succesfully installed!'
  puts 'To start execute the command "sudo /etc/init.d/cdmon-updater start"'
  puts 'To stop execute the command "sudo /etc/init.d/cdmon-updater stop"'
  puts 'CDmon Updater will log it\'s activity to the logfile /var/log/cdmon-updater.log.'
  puts 'Update the file on "lib/settings.yml" with your user and pass in order to update your IP.'
  puts 'Enjoy!'
elsif ARGV[0] == 'remove'
  puts 'Removing CDmon Updater...'
  FileUtils.rm '/etc/init.d/cdmon-updater'
  FileUtils.rm '/var/log/cdmon-updater.log'
  puts 'Removed!'
else
  puts 'Invalid syntax. Usage: ruby setup.rb { install | remove}'
end
