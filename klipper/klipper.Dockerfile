FROM debian:latest

WORKDIR /root

RUN apt-get update \
    && apt-get install -y --no-install-recommends python3-virtualenv python3-dev libffi-dev build-essential libncurses-dev avrdude gcc-avr binutils-avr avr-libc stm32flash dfu-util libnewlib-arm-none-eabi gcc-arm-none-eabi binutils-arm-none-eabi libusb-dev libusb-1.0-0 libusb-1.0-0-dev pkg-config python3 python3-pip python3-venv git netcat-openbsd curl \
    && rm -rf /var/lib/apt/lists/*

RUN cd /root && git clone https://github.com/Klipper3d/klipper --depth 1

RUN python3 -m venv /root/klippy-env && /root/klippy-env/bin/pip install -r /root/klipper/scripts/klippy-requirements.txt

RUN mkdir /root/printer_data

# Install the gcode shell comamnd extension to the klipper container
RUN curl -fsSL https://raw.githubusercontent.com/dw-0/kiauh/master/kiauh/extensions/gcode_shell_cmd/assets/gcode_shell_command.py -o /root/klipper/klippy/extras/gcode_shell_command.py

RUN cd /root/klipper \
    && printf 'CONFIG_MACH_LINUX=y\n' > .config \
    && make olddefconfig && make

COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]
