#!/usr/bin/env bash
cd ~/Applications/sketchbook/elisas_synchronotron
echo "Hold your horses. Reset local changes first, if any.."
git reset --hard
git clean -fxd
echo "Done."
echo "Get updates if available.."
git pull
echo "Done."
echo "Start Application with sketch."

#if missing, make new symlink to  processing-io library
ln -s ~/Applications/processing-4.1.2/modes/java/libraries/io/library/linux-armv6hf/libprocessing-io.so ~/Applications/sketchbook/elisas_synchronotron/linux-arm/lib/

#sudo ~/Applications/processing-4.1.2/processing-java --sketch=/home/esc/Applications/sketchbook/synchronotron --run
sudo /home/esc/Applications/sketchbook/elisas_synchronotron/linux-arm/elisas_synchronotron
echo "Done. Hold on.."
