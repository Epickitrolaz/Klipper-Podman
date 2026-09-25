#!/bin/bash

# Enable SPI support
sudo sh -c 'echo "dtparam=spi=on" >> /boot/efi/config.txt'

# Bind the spidev driver manually every boot
sudo tee /etc/systemd/system/spidev-bind.service > /dev/null <<'EOF'
[Unit]
Description=Bind SPI devices to spidev driver
After=systemd-modules-load.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/bash -c 'for device in /sys/bus/spi/devices/spi*; do if [ -e "$device" ]; then dev=$(basename $device); echo spidev > $device/driver_override; echo $dev > /sys/bus/spi/drivers/spidev/bind 2>/dev/null; fi; done'

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload && sudo systemctl enable --now spidev-bind.service

ls -l /dev/spidev0.0
ls /sys/bus/spi/devices/

echo -e "\nDONE!\nReboot to apply"
