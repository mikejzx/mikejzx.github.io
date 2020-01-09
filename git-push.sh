#!/bin/bash

# Update date timestamp.
update_time=$(date +"%d.%m.%y @ %H:%M (%z)")
echo "Update time set to $update_time"
sed "s/const datetime = \".*/const datetime = \"$update_time\";/g" include/include-bottombar.js | sponge include/include-bottombar.js

git add include/include-bottombar.js

git status
echo "Is this okay? (y/n)"
read isokay

# Not okay.
if [[ "$isokay" = "n" ]]; then
	echo "Cancelling..."
	exit 1
fi

# Totally fine.
if [[ ! "$isokay" = "y" ]]; then
	echo "Unknown response. Aborting..."
	exit 1
fi

echo "Enter commit message:"
read commitmsg

echo "Committing..."

git commit -m "$commitmsg"

git push origin master
