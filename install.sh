#!/bin/sh

echo "--------------------------------------"
echo "||| CHROOT INSTALLATION ON ANDROID |||"
echo "--------------------------------------"
printf "\n"

ROOTFS_PATH="/data/local/rootfs/"

while true
do
    
    # Make user input loop, determine the process
    echo "Continue the process of installation rootfs? [y/N]"
    read -p ": " user_input

    if [ "$user_input" = "y" ] || [ -z "$user_input" ]; then

	    break

    elif [ "$user_input" = "N" ]; then
        
	    echo "Cancel the process installation!"
        
	    exit 1
    
    else
	echo "Invalid input. Try again."
    
    fi

done

# Creating the rootfs directory if directory dosn't exist
if [ -d "$ROOTFS_PATH" ]; then    
	
	break

else
	mkdir -p /data/local/rootfs/
	echo "Create the rootfs directory on /data/local/rootfs complete."
    
	break

fi

while true
do

    # Checking the busybox is already installed, or not
    echo "Checking the busybox module"

    if command -v busybox >/dev/null 2>&1; then
        echo "The busybox module already installed, process continue!"
        
	    break
    
    else
        echo "The busybox not installed, please install the busybox module frist!"
        
	exit 1
    
    fi

done

while true
do

    # Select the rootf files from, or make the link directly
    echo "Please select rootf from, to be install!"
    echo "[1] Debian 12 arm64 rootfs \"LinuxDroidMaster\". (Recommended)"
    echo "[2] Debian Trixie aarch64 rootfs \"termux/proot-distro\". (Test)"
    echo "[?] I want the Debian rootfs from my url! (Test)"
    read -p ": " user_input

    if [ "$user_input" -eq 1 ]; then
        echo "[1] is selected, please wait the download process!"
        cd /data/local/rootfs
	
        while true
	do
		
		printf "\e[1;33m[!] Checking the directory...\e[0m\n"
		
		if [ -d "/data/local/rootfs/debian12" ]; then
			printf "\n\e[1;33m[!] The directory are exist.\e[0m\n"
			
			break

		else
			printf "\n\e[1;32[!] The directory dosn't exist, Process downloading...\e[0m\n"
            mkdir debian12
        	cd debian12
			wget https://github.com/LinuxDroidMaster/Termux-Desktops/releases/download/Debian/debian12-arm64.tar.gz
			tar xpvf debian12-arm64.tar.gz --numeric-owner
			
			break

		fi

	done
        
	cd ../

        # Making chroot runner to debian rootfs
        run_file=debr.sh # r for root user

        cat <<- EOF > "$run_file"
#!/bin/sh

debp="/data/local/rootfs/debian12"

# Fix setuid issue (Linux file permissions allows an executable to run with the effective user ID (EUID) of its owner)
busybox mount -o remount,dev,suid /data

busybox mount --bind /dev \$debp/dev
busybox mount --bind /sys \$debp/sys
busybox mount --bind /proc \$debp/proc
busybox mount -t devpts devpts \$debp/dev/pts

# /dev/shm for Electron apps
mkdir \$debp/dev/shm
busybox mount -t tmpfs -o size=256M tmpfs \$debp/dev/shm

# Mount internal storage
mkdir \$debp/internal
busybox mount --bind /sdcard \$debp/internal

# run chroot into runner script
busybox chroot \$debp /bin/su - root
EOF

        chmod +x debr.sh
        
        break
    
    elif [ "$user_input" -eq 2 ]; then
        echo "[2] is selected, please wait the download process!"
        cd /data/local/rootfs

        while true
	do
		
		printf "\e[1;33m[!] Checking the directory...\e[0m\n"
		
		if [ -d "/data/local/rootfs/debian-trixie-aarch64" ]; then
			echo -e "\n\e[1;33m[!] The directory are exist.\e[0m"
			
			break

		else
			printf "\n\e[1;32[!] The directory dosn't exist, Process downloading...\e[0m\n"
			wget https://github.com/termux/proot-distro/releases/download/v4.29.0/debian-trixie-aarch64-pd-v4.29.0.tar.xz
			tar xpvf debian-trixie-aarch64-pd-v4.29.0.tar.xz --numeric-owner
			
			break

		fi
	
	done

        # Making chroot runner to debian rootfs
        run_file=debr.sh # r for root user

        cat <<- EOF > "$run_file"
#!/bin/sh

debp="/data/local/rootfs/debian-trixie-aarch64"

# Fix setuid issue (Linux file permissions allows an executable to run with the effective user ID (EUID) of its owner)
busybox mount -o remount,dev,suid /data

busybox mount --bind /dev \$debp/dev
busybox mount --bind /sys \$debp/sys
busybox mount --bind /proc \$debp/proc
busybox mount -t devpts devpts \$debp/dev/pts

# /dev/shm for Electron apps
mkdir \$debp/dev/shm
busybox mount -t tmpfs -o size=256M tmpfs \$debp/dev/shm

# Mount internal storage
mkdir \$debp/internal
busybox mount --bind /sdcard \$debp/internal

# run chroot into runner script
busybox chroot \$debp /bin/su - root
EOF

        chmod +x debr.sh
        
        break

    elif [ "$user_input" -eq 3 ]; then
        echo "[3] selected, process the url with wget to download the files!"
        cd /data/local/rootfs
        printf "\nBedore that, if your rootfs in directory, please input [Directory Name]\n"
        echo "if not in directory, please input [N]"
        read -p ": " user_dir

        if [ "$user_dir" = "N" ]; then
            mkdir debian12
            cd /data/local/rootfs/debian12
        
        else
            echo "$user_dir will be store on runner file"

        fi
	
	while true
	do

		printf "\e[1;33m[!] Checking the directory...\e[0m\n"
		
		if [-d "/data/local/rootfs/$user_dir" ]; then
			printf "\n\e[1;33m[!] The directory are exist.\e[0m\n"
			
			break

		else
			printf "\n\e[1;32m[!] The directory dosn\'t exist, Process downloading...\e[0m\n"
			echo "Please input the url!"
			read -p ": " url
			wget $url

			# Make sure if the name of the file is right
			while true
			do

			    printf "\nPlease input the rootfs filename!\n"
			    read -p ": " url_name

			    if tar xpvf "$url_name" --numeric-owner; then
			    
				    break

			    else
				echo "The name of files is incorrect, please input the right name"
			    
			    fi
			
			done
		fi

	done

        # Making chroot runner to debian rootfs
        run_file=debr.sh # r for root user

        echo "#!/bin/sh" >> "$run_file"
        echo -e "debp=\"/data/local/rootfs/$user_dir\"" >> "$run_file"

        cat << EOF >> "$run_file"
# Fix setuid issue (Linux file permissions allows an executable to run with the effective user ID (EUID) of its owner)
busybox mount -o remount,dev,suid /data

busybox mount --bind /dev \$debp/dev
busybox mount --bind /sys \$debp/sys
busybox mount --bind /proc \$debp/proc
busybox mount -t devpts devpts \$debp/dev/pts

# /dev/shm for Electron apps
mkdir \$debp/dev/shm
busybox mount -t tmpfs -o size=256M tmpfs \$debp/dev/shm

# Mount internal storage
mkdir \$debp/internal
busybox mount --bind /sdcard \$debp/internal

# run chroot into runner script
busybox chroot \$debp /bin/su - root
EOF

        chmod +x debr.sh
        
        break

    else
        echo "The option input is not on list, please input the correct option"
    
    fi

done

# Confirm the debp is default or user dir
if [ "$user_dir" = "N" ] || [ -z "$user_dir" ]; then
	debp="/data/local/rootfs/debian12"

else
	debp="/data/local/rootfs/$user_dir"

fi

# Fix permission issue when run this program
busybox mount -o remount,dev,suid /data
busybox mount --bind /dev \$debp/dev
busybox mount --bind /sys \$debp/sys
busybox mount --bind /proc \$debp/proc
busybox mount -t devpts devpts \$debp/dev/pts
busybox mount -t tmpfs -o mode=1777,size=256M tmpfs \$debp/tmp

# Make correct permission for /tmp
busybox chroot $debp /bin/su - root -c 'chmod -R 1777 /tmp'

# Make dns and localhost (dns still don't work on certain device)
busybox chroot $debp /bin/su - root -c '\
	echo "nameserver 1.1.1.1" > /etc/resolv.conf; \
	echo "nameserver 8.8.8.8" >> /etc/resolv.conf; \
	echo "127.0.0.1 localhost" > /etc/hosts'

# Install essential package
busybox chroot $debp /bin/su - root -c '\
	apt update -y && apt upgrade -y; \
	apt install openssh-client openssh-server -y; \
	apt install xorg xserver-xorg-core xinit -y; \
	apt install sudo nano vim git curl wget -y; \
	apt install adduser -y; \
	apt install dbus-x11 -y; \
    apt install locales fonts-noto-cjk -y; \
    apt install unzip xz-utils -y; \
	echo -e "\e[1;32mThe essential install has finished!\e[0m"'

printf "\n"
printf "\e[0;31mPlease input your username!\n"
read -r -p "username: " username

busybox chroot $debp /bin/su - root -c "adduser $username"

while true
do

    echo "Are you want to add user to sudoers? [y/N]"
    read -p ": " user_input

    if [ "$user_input" = "y" ] || [ -z "$user_input" ]; then
        busybox chroot $debp /bin/su - root -c 'usermod -aG sudo $username'
        
	    break
    
    elif [ "$user_input" = "N" ]; then
        
	    break
    
    else
        echo "Invalid input, please input [y/N]"
    
    fi

done

while true
do

    echo "You want install Desktop Enviroment? [N] for no"
    echo "List:"
    echo "[1] XFCE4 (recommended)"
    echo "[2] KDE PLASMA (recommended middle class phone)"
    echo "[0] Dynamic Window Manager DWM (not recommended, light, server GUI use)"
    read -p ": " user_choice

    if [ "$user_choice" -eq 1 ]; then
        busybox chroot $debp /bin/su - root -c 'apt install xfce4 xfce4-goodies -y'
        echo "XFCE4 Ready to use"
        
	    break
    
    elif [ "$user_choice" -eq 2 ]; then
        busybox chroot $debp /bin/su - root -c 'apt install kde-plasma-desktop -y'
        echo "KDE PLASMA Ready to use"
        
	    break
    
    elif [ "$user_choice" -eq 0 ]; then
        busybox chroot $debp /bin/su - root -c 'apt install make cmake gcc build-essential libx11-dev libxft-dev libxinerama-dev picom rofi nitrogen -y'
        echo "Then just compiling the source code"
        
	    break
    
    else
        echo "The option input is not on list, please input the correct option"

    fi

done

while true
do

    printf "\nDo you want to create debr.sh for user, and DE version?\n"
    read -r -p "[y/N]: " user_input

    if [ "$user_input" = "y" ] || [ -z "$user_input" ]; then
        cd /data/local/rootfs/
        cp debr.sh debu.sh # u for user
        sed -i '22s/^/#/' debu.sh
        
        if [ "$user_choice" -eq 1 ]; then
            cat << EOF >> "debu.sh"

while true; do

    printf "\n"
    printf "Start with X server or SSH only? \e[1;33m[Y (X server ON) / N (SSH only)]\e[0m"
    read -p ": " user_input

    if [ "\$user_input" == "Y" ] || [ "\$user_input" == "y" ] || [ "\$user_input" == "N" ] || [ "\$user_input" == "n" ] || [ -z "\$user_input" ]; then
        break
    
    else
        printf "\e[1;31mInput Invalid!"

    fi

done

if [ "\$user_input" == "N" ] || [ "\$user_input" == "n" ]; then
    busybox chroot \$debp /bin/su - root -c '/etc/init.d/ssh start'

else
    busybox chroot \$debp /bin/su - root -c '/etc/init.d/ssh start'
    busybox chroot \$debp /bin/su - $username -c 'USER_UID=\$(id -u); export XDG_RUNTIME_DIR="/tmp/run-user/\$USER_UID"; mkdir -p "\$XDG_RUNTIME_DIR" && chmod 0700 "\$XDG_RUNTIME_DIR"; export DISPLAY=:0 && export PULSE_SERVER=127.0.0.1 && dbus-launch --exit-with-session startxfce4'

fi
EOF
        
        elif [ "$user_choice" -eq 2 ]; then
            cat << EOF >> "debu.sh"

while true; do

    printf "\n"
    printf "Start with X server or SSH only? \e[1;33m[Y (X server ON) / N (SSH only)]\e[0m"
    read -p ": " user_input

    if [ "\$user_input" == "Y" ] || [ "\$user_input" == "y" ] || [ "\$user_input" == "N" ] || [ "\$user_input" == "n" ] || [ -z "\$user_input" ]; then
        break
    
    else
        printf "\e[1;31mInput Invalid!"

    fi

done

if [ "\$user_input" == "N" ] || [ "\$user_input" == "n" ]; then
    busybox chroot \$debp /bin/su - root -c '/etc/init.d/ssh start'

else
    busybox chroot \$debp /bin/su - root -c '/etc/init.d/ssh start'
    busybox chroot \$debp /bin/su - $username -c 'USER_UID=\$(id -u); export XDG_RUNTIME_DIR="/tmp/run-user/\$USER_UID"; mkdir -p "\$XDG_RUNTIME_DIR" && chmod 0700 "\$XDG_RUNTIME_DIR"; export DISPLAY=:0 && export PULSE_SERVER=127.0.0.1 && dbus-launch --exit-with-session startplasma-x11'

fi
EOF

        elif [ "$user_choice" -eq 0 ]; then
            cat << EOF >> "debu.sh"

while true; do

    printf "\n"
    printf "Start with X server or SSH only? \e[1;33m[Y (X server ON) / N (SSH only)]\e[0m"
    read -p ": " user_input

    if [ "\$user_input" == "Y" ] || [ "\$user_input" == "y" ] || [ "\$user_input" == "N" ] || [ "\$user_input" == "n" ] || [ -z "\$user_input" ]; then
        break
    
    else
        printf "\e[1;31mInput Invalid!"

    fi

done

if [ "\$user_input" == "N" ] || [ "\$user_input" == "n" ]; then
    busybox chroot \$debp /bin/su - root -c '/etc/init.d/ssh start'

else
    busybox chroot \$debp /bin/su - root -c '/etc/init.d/ssh start'
    busybox chroot \$debp /bin/su - $username -c 'USER_UID=\$(id -u); export XDG_RUNTIME_DIR="/tmp/run-user/\$USER_UID"; mkdir -p "\$XDG_RUNTIME_DIR" && chmod 0700 "\$XDG_RUNTIME_DIR"; export DISPLAY=:0 && export PULSE_SERVER=127.0.0.1 && dbus-launch --exit-with-session dwm'

fi
EOF

        else
            printf "Just user without DE\n"
            echo "busybox chroot \$debp /bin/su - $username" >> debu.sh

        fi

        break
    
    elif [ "$user_input" = "N" ]; then
        echo "You can modified the debr.sh to add user and DE you want manualy."
        
	break
   
    else
        print "Invalid input, please input [y/N]\n"
    
    fi

done

printf "\n\n"
echo "-----------------------------"
echo "||| INSTALLATION COMPLETE |||"
echo "-----------------------------"
echo "Now creating the run file!!!"
printf "\n\n"

exit 0