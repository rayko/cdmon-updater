CDmon Updater

        This is a small script that comunicates with CDmon API for IP updates. It's very simple.

Requirements

        1. Ruby 1.8.7
        2. Root permissions

Usage

        1. Grab a copy of the repo and place it wherever you like.
        2. Edit the settings.yml file on the lib folder and place your data.
        3. Run the setup.rb to install the script: "sudo ruby setup.rb install"
        4. Enjoy!

Usage of the init script

        cdmon-updater { start | stop | restart }

Additional Notes

        The program creates a logfile /var/log/cdmon-updater.log to follow each update or error.
        Make sure the mode and owner are correct for the boot script.

	To remove CDmon updater just run "sudo ruby setup.rb remove"

