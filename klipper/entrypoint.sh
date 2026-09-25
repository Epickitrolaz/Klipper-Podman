#!/bin/bash
( while true; do /root/klipper/out/klipper.elf; sleep 1; done ) &
for i in $(seq 1 30); do [ -e /tmp/klipper_host_mcu ] && break; sleep 0.2; done
exec /root/klippy-env/bin/python3 /root/klipper/klippy/klippy.py /root/printer_data/config/printer.cfg -l /root/printer_data/logs/klippy.log -I /root/printer_data/comms/klippy.serial -a /root/printer_data/comms/klippy.sock
