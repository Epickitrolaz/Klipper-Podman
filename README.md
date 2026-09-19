# Klipper-Docker
### The whole Klipper stack running in Podman containers

---

This whole repo was created and tested on a Raspberry Pi 4B with Fedora IoT, but it should be compatible with other 64bit Raspberry pi version and Fedora CoreOS.

Why not just use MainsailOS or Kiauh?
1. Both of these methods, while simpler, work on a "normal" Debian-based operating system, which can possibly break or become unstable after updates. Fedora IoT, on the other hand, uses and immutable OSTree system which makes everything, but the important directories read-only and replaces the whole system every update. While it has a steeper learning curve, it makes everything much more stable and harder to break.
2. Since the Moonraker API is not protected by any kind of authentication layer, when running on MainsailOS or Raspberry Pi OS, any RCE exploit will make the attacker gain full access to the host operating system. By using Podman containers every service is isolated which, while still not 100% secure, makes it much harder for the attacker to do damage.

---

## Installation guide
1. ### Install Fedora IoT:

You are going to need a PC/Laptop with Fedora Linux already installed, or running the Fedora live installer from a USB drive.
If you are running any other Linux distro, you are on your own (but AI can help you).
Before you start, you are going to need to set up a WiFi connection in the arm-image-installer before flashing (unless you are using ethernet) as well as copy an ssh key into the image.

The flashing process is very well documented on this blog, so follow the instructions here:
`https://fedoramagazine.org/setting-up-fedora-iot-on-raspberry-pi-and-rootless-podman-containers/`

2. ### Setup the OS and install the required packages:

After you boot up the Raspberry Pi, connect to it via SSH (you should be connected without a password if the SSH keys are valid).
First thing to do is to set the root password using:
```
passwd
```
This way you can log into the Pi from other devices.

Next you need to install the basic packages:
```
rpm-ostree install cockpit cockpit-podman git podman-compose
```
(Packages cockpit and cockpit-podman are not required but useful for changing firewall rules)

After that you need to reboot:
```
reboot
```

If you installed Cockpit, you need to start it:
```
systemctl enable --now cockpit.service
```
(It will now be running on 0.0.0.0:9090)

3. ### Cloning the repo and building the containers:

To clone the repo run:
```
git clone https://Epickitrolaz/Klipper-Podman --depth 1 && cd Klipper-Podman
```

Next to set everything up run:
```
./setup.sh
```
(This can take from 10 minutes on the Pi 5 up to almost 2 hours on the Pi Zero 2W)

4. ### Running the containers:

Now to run the containers, you need to run the start script:
```
./start.sh
```

Wait for the log to stop appearing and go to <your raspberry pi ip>:80 in your browser.
If the webpage loads, everything works, if it doesn't, run:
```
./start-debug.sh
```

Check the logs for any errors while starting up the containers.

If the webpage loads, edit the .env file and set your MCU and camera paths.
You can use the included vi editor or install a different one using rpm-ostree (nano, vim, etc.)
If you don't have a camera, put /dev/null in the config.

After you edit the .env file, run the start script again and configure your printer.cfg, moonraker.cfg and other configs.
