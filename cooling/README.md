# Cooling

| What | Controlled by | Where |
|---|---|---|
| H150i Pro radiator fans + pump | liquidctl; the curve (coolant °C → %) is stored on the pump, which runs it itself | `~/.config/startup.sh`, at login and again after every resume (via `rgb_lighting/rgb-sleep-hook`) |
| Case fans (board headers 1, 3, 4, 6) | the board's fan chip (NCT6799), following SYSTIN ("Motherboard" in the UEFI) | `case-fans`, written at boot by udev and after suspend by `rgb-sleep-hook` |

Nothing keeps running: both curves live in hardware, Linux only writes them.
The UEFI Q-Fan curve is just the fallback for the seconds before the driver
loads (and after a CMOS reset / BIOS update until the next boot).

## Why these sensors

- Radiator: top-mounted, blowing out, so it breathes case air; coolant
  temperature is the right input and the pump can read it itself.
- Case fans: SYSTIN was the only board sensor that rose and fell with GPU heat
  in the case (≈3 °C between idle and a 350 W GPU load). AUXTIN0–3/5 didn't
  move at all; CPUTIN also jumps with CPU load. Because SYSTIN moves so little,
  the curve is narrow: 35 % up to 37 °C, 50 % at 40 °C, 100 % at 43 °C.
- Minimum 35 %: measured from standstill, fan1/fan4 start at 25 %, fan6 only
  at 35 %, fan3 never drops below ~600 rpm. The chip's `pwm_floor` doesn't
  stick on this board, so the lowest curve point is the only floor.

## Installation (once, as root)

```sh
echo nct6775 | sudo tee /etc/modules-load.d/nct6775.conf
sudo install -m 755 ~/.config/cooling/case-fans /usr/local/bin/case-fans
sudo install -m 644 ~/.config/cooling/99-case-fans.rules /etc/udev/rules.d/
sudo install -m 755 ~/.config/rgb_lighting/rgb-sleep-hook /usr/lib/systemd/system-sleep/rgb
```

The script runs as root, so it is installed as a root-owned copy; after
editing `case-fans`, run the second line again.

Check: `journalctl -b -t case-fans` and `sensors nct6799-isa-0290`.
