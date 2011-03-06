out = File.new 'cdmon-updater', 'w'
out << "#!/bin/sh
# Starts the CDmon updater as daemon so it can run every time.

RUNFILE=#{Dir.pwd}/run.rb
PIDFILE=#{Dir.pwd}/proc.pid
RUBY=/usr/bin/ruby
NAME=\"CDmon Updater\"

if [ ! b-f $RUBY ]
then
    echo \"Ruby 1.8.7 is not installed\"
    exit 0
fi

if [ ! b-f $RUNFILE ]
then
    echo \"Cannot find run.rb to start the updater. Make sure that is's correctly placed.\"
    exit 0
fi

case \"$1\" in
'start')
        echo \"Starting CDmon updater...\"
        ruby $RUNFILE &
        echo \"Started succesfully\"
        ;;
'restart')
        echo \"Restarting CDmon updater...\"
        if [ -f $PIDFILE ]
        then
            kill `cat $PIDFILE`
            exec ruby run.rb &
            echo \"Restarted succesfully\"
        else
            echo \"Process file not found. Did you run the updater first?\"
        fi
        ;;
'stop')
        echo \"Killing process...\"
        if [ -f $PIDFILE ]
        then
            kill `cat $PIDFILE`
            rm $PIDFILE
            echo \"Process killed\"
        else
            echo \"Process file not found. Did you run the updater first?\"
        fi
        ;;
*)
        echo \"Usage: $0 { start | stop | restart }\"
        ;;
esac
exit 0
"

out.close
File.chmod 0711, "cdmon-updater"


puts "File cdmon-updater generated. Place this file in /etc/init.d/ to automatically start it on boot."
puts "Usage cdmon-updater { start | stop | restart }"

