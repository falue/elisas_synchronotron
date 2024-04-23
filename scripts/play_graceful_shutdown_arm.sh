#!/usr/bin/env bash

# link missing java from processing export
ln -s /home/esc/Applications/processing-4.1.2/modes/java/libraries/io/library/linux-armv6hf/libprocessing-io.so /home/esc/Applications/sketchbook/elisas_synchronotron/linux-arm/lib/

sudo /home/esc/Applications/sketchbook/elisas_synchronotron/linux-arm/elisas_synchronotron
# shutdown after elisas_synchronotron has exit()ed

# Use Zenity to ask user to cancel shutdown
if zenity --question --title="Shutdown now?" --text="Press Yes or wait to shutdown now; or No to stop the shutdown." --timeout=7; then
    echo "Shutting down now..."
    shutdown -h now
else
    echo "Shutdown canceled."
fi