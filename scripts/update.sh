#!/usr/bin/env bash
cd ~/Applications/sketchbook/elisas_synchronotron
echo "Hold your horses. Reset local changes first, if any.."
git reset --hard
git clean -fxd
echo "Done."
echo "Get updates if available.."
git pull
echo "Done."

#if missing, make new symlink to  processing-io library
ln -s ~/Applications/processing-4.1.2/modes/java/libraries/io/library/linux-armv6hf/libprocessing-io.so ~/Applications/sketchbook/elisas_synchronotron/linux-arm/lib/

# Use Zenity to ask user to cancel shutdown
if zenity --info --title="Elisa was updated" --text="Successful update. Start application a new."; then
    echo "User acknowledged the message."
fi