#!/bin/bash

# Example of how to use this cleaner

# First you need to load Roombash' functions
# To do that, start off by making the directory of the Roomba.sh file relative to this one:

dir=$(pwd)
# path_to_roomba_from_here="path/to/roombash"
# (While path_to_roomba_from_here is not initialized, it acts as an empty string"")
roomba_dir="$dir$path_to_roomba_from_here/roomba.sh"
echo "Roomba.sh's directory (including name): $roomba_dir"

# Now we load RoombaSH:
source $roomba_dir

# If "RoombaSH has loaded correctly." appears in the console/terminal, you've set up roomba correctly.

# Now, Imagine you want to upload something to a server through ssh
# but you would like to remove some files without losing them
# and to completely erase several folders.

# First, you create a file called ".cleanup", without the quotes.
# If RoombaSH doesn't find this file, it will automatically create it.
# Remember that .cleanup should be on the same location as Roomba.sh

# In our script we want to remove test1.txt, test2.txt, and delete the remove_this_dir folder
# which contains test3
# You can check the .cleanup example.

roombash_do_cleanup

# Here goes your code


echo "Uploading [$dir] => [user@server.ssh.com:~/path/to/upload]"
# I don't actually want to upload anything so I will just print the command
echo "scp -r $dir user@server.ssh.com:~/path/to/upload"

# I use sleep because I want the movement of files to actually show.
# Most Editors with built-in explorers are unable to capture the movement
# due to it being faster than their refresh rate (or so I assume).
sleep 5

# Now we let Roomba undo the changes it has done.
roombash_undo_cleanup