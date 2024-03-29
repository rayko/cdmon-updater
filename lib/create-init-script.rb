class InitScript
  def generate
    out = File.new 'cdmon-updater', 'w'
    out << "#!/bin/sh
# Starts the CDmon updater as daemon so it can run every time.

RUNFILE=#{Dir.pwd}/run
PIDFILE=#{Dir.pwd}/proc.pid
NAME=\"CDmon Updater\"

if [ ! -f $RUNFILE ]
then
    echo \"Cannot find run script to start the updater. Make sure that is's correctly placed.\"
    exit 0
fi

case \"$1\" in
'start')
        echo \"Starting CDmon updater...\"
        exec $RUNFILE &
        echo \"Started succesfully\"
        ;;
'restart')
        echo \"Restarting CDmon updater...\"
        if [ -f $PIDFILE ]
        then
            kill `cat $PIDFILE`
            exec $RUNFILE &
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
  end
end

