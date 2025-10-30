############################
### CREATING START SHELL ###
############################

# Make function to define default path
prompy() {
	local user_input
	local default="${1:-/data/local/rootfs/debian12/tmp}"

	while true; do
		echo "[Default:$default]" >&2
		read -p ": " user_input

		if [ -n "$user_input" ]; then
			break
		
		elif [ -z "$user_input" ]; then
			user_input="$default"
			break
		
		fi
	
	done

	echo "$user_input"

}

printf "[ This programs will create start-debian.sh ]\n"
printf "\n"

# Input initial info from user
printf "Please enter /tmp location!/n"
tmp_location=$(prompy)
printf "\n"

printf "Please enter /debu.sh location!\n"
run_shell=$(prompy "/data/local/rootfs/debu.sh")
printf "\n"

run_file=start-debian.sh

cat << EOF > "$run_file"
#!/bin/bash

# Kill all old prcoesses
killall -9 termux-x11 Xwayland pulseaudio virgl_test_server_android termux-wake-lock

## Start Termux X11
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity

sudo busybox mount --bind $PREFIX/tmp $tmp_location

XDG_RUNTIME_DIR=${TMPDIR} termux-x11 :0 -ac &

sleep 3

# Start Pulse Audio of Termux
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1

# Start virgl server
#virgl_test_server_android &

# Execute chroot Ubuntu script
su -c "sh $run_shell"
EOF

chmod +x start-debian.sh

printf "Creating start-debian.sh has completed!\n"

while true
do
	
	printf "Is you want to install initial package from termux to run the debian on x11?\n"
	read -r -p "[y/N]: " user_input
	
    # The initial package to make x11 server run properly
	if [ "$user_input" = "y" ] || [ -z "$user_input" ]; then
		pkg install x11-repo -y
		pkg install root-repo -y
		pkg install termux-x11-nightly -y
		pkg install pulseaudio -y
		break

	elif [ "$user_input" = "N" ]; then
		break
	
	else
		printf "Invalid input\n"
	
	fi

done

exit 0