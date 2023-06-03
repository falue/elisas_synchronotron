#!/usr/bin/env bash
cd ~/Applications/sketchbook/synchronotron
echo "Hold your horses. Reset local changes first, if any.."
git reset --hard
git clean -fxd
echo "Done."
echo "Get updates if available.."
git pull
echo "Done."
echo "Start Application with sketch."
sudo ~/Applications/processing-4.1.2/processing-java --sketch=/home/esc/Applications/sketchbook/synchronotron --run
echo "Done. Hold on.."
