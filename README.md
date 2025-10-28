# Debian Chroot Installation on Termux
This bashscript for install Debian rootfs on android, with termux and busybox module is require to run chroot.
And can use GUI too with termux-x11 app as x server.

# How to install
Frist open termux clone the repo!

```
git clone https://github.com/ewd-richtofen/DebianChrootInstallationTermux.git
cd DebianChrootInstallationTermux
```

Second run with super user

```
tsu # Can use su too, but I recommend tsu over su
sh install.sh
```

Third run the start-conf.sh to generate <b>start-debian.sh</b>

```
exit # Exit from super user enviroment
sh run-maker.sh
```

# Fix error dbus permission
If you ecounter that permission when try run start-debian.sh, it can be fix by run the debr.sh again and fix permission by run!

```
chmod -R 1777 /tmp
```

And now try to start the start-debian.sh again, it will be fix dbus permission error.

# Next Update
- Will be more rootfs choice, not just Debian

- More proper README.md
