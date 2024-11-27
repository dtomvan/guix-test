#!/bin/bash

# Start the first process
doas guix-daemon --build-users-group=guix-builder --disable-chroot &

# Start the second process
bash

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?
