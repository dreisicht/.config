# RGB lighting

Static fire orange on every RGB device while the PC is on, and a very dim red
on the RAM while it is suspended, without slowing down suspend.

Each device has exactly one owner, so two tools never open the same device:

| Device | Tool |
| --- | --- |
| 4× Corsair Vengeance RGB DDR5, Gigabyte RTX 4090 Gaming OC | OpenRGB (`openrgb`) |
| ASUS PRIME X870-P board headers (Aura), Corsair H150i pump logo | liquidctl: quicker and simpler for these |

OpenRGB's "ASUS Aura Motherboard" and "Corsair Hydro Series" detectors are
disabled in `~/.config/OpenRGB/OpenRGB.json`, so it never touches the
liquidctl devices.

## Files

| File | What it does |
| --- | --- |
| `fire-rgb` | Sets every device to one colour, then exits: board and pump logo through liquidctl, RAM and GPU through OpenRGB in Direct mode. Uses fire orange `FF3000` by default; pass another hex colour as the first argument, e.g. `fire-rgb 000000` for off. Waits up to ~30 s for the RAM to show up. |
| `~/.config/systemd/user/openrgb-server.service` | Runs `openrgb --server`. It scans the hardware once, so later `openrgb` calls connect to it and take ~35 ms instead of ~2 s. |
| `rgb-sleep-hook` | A systemd-sleep hook. Before suspend it dims the four RAM sticks to `SLEEP_COLOR` through the server. After resume it re-writes the case-fan curve (`/usr/local/bin/case-fans`, see `../cooling/README.md`) and runs `~/.config/startup.sh` again in the background, as the user. |
| `~/.config/startup.sh` | Runs at login and after every resume: liquidctl for the H150i pump and fan curve, then `fire-rgb`, then starts the server. |

## How it works

The system uses deep (S3) suspend.

- **During suspend**, only the Corsair RAM stays powered, and it keeps its
  last colour. Without the hook it glows at full brightness all night.
- **The GPU, board and cooler** lose power and usually wake up showing their
  factory lighting, so they need fire orange set again after resume.

### Why there is a server

Suspend waits for the hook's `pre` step, so that step must be instant. Every
standalone `openrgb` call scans all the hardware first, which takes ~2 s. Earlier
versions of the hook ran `openrgb` directly and added 1–5 s to every suspend.

With `openrgb-server.service` running, `openrgb` connects to the server and
skips the scan, so dimming the RAM takes ~35 ms.

The `pre` step never waits for a scan:
- If nothing listens on port 6742, the hook skips the colour change and logs
  "OpenRGB server not running". The RAM then stays lit, but suspend is still
  instant.
- The call is capped with `timeout -k 0.1 0.5`. The `-k` matters because
  `openrgb` ignores SIGTERM. Without it, a call made while the server is
  still scanning hung for 14 s in testing.

### Order of operations

Two OpenRGB processes, or OpenRGB and liquidctl, must never talk to the
hardware at the same time.

Login and resume run the same script, `startup.sh`. In deep suspend the
H150i, GPU and board lose power, so waking up needs the same setup as login:

1. Stop the server: it may still be running from an earlier session, or hold
   stale handles to USB devices that lost power.
2. Run liquidctl: H150i pump mode and fan curve, which the cooler forgets
   when it loses power.
3. Run `fire-rgb`, which waits for the RAM to appear.
4. Start the server. It only scans once, so starting it last makes sure it
   sees the RAM.

On resume the hook starts this in the background, so resume doesn't wait for
it.

The server unit is deliberately **not enabled**. `startup.sh` starts it so the
order above holds.

## Installation

### 1. Login and server

Nothing to install. The unit lives in `~/.config/systemd/user/`, and Noctalia
runs `~/.config/startup.sh` at login (see `noctalia/settings.json`). After
adding or changing the unit file, run:

```sh
systemctl --user daemon-reload
```

### 2. Suspend/resume: install the sleep hook (needs root)

systemd only runs sleep hooks from a root-owned directory, so the hook has to
be **copied** there:

```sh
sudo install -m 755 ~/.config/rgb_lighting/rgb-sleep-hook /usr/lib/systemd/system-sleep/rgb
```

The installed file is a copy. **After every edit to `rgb-sleep-hook`, e.g.
changing `SLEEP_COLOR`, run the command again.** Do this on a fresh system
too, because the copy is not part of this repo. `startup.sh` and `fire-rgb`
are called from their place in `~/.config`, so editing them needs no
reinstall.

To uninstall:

```sh
sudo rm /usr/lib/systemd/system-sleep/rgb
```

### Requirements

- `openrgb` installed, with i2c access for the RAM, which needs the `i2c-dev`
  module and OpenRGB's udev rules.
- `USER_NAME=peterbaintner` in the hook is used to run `startup.sh` in that
  user's systemd session. Change it if the username changes.

## Changing colours

- Preview any colour live: `~/.config/rgb_lighting/fire-rgb 200000`
- Go back to normal: `~/.config/rgb_lighting/fire-rgb`
- Day colour: change `COLOR` default in `fire-rgb`. No reinstall needed.
- Suspend colour: change `SLEEP_COLOR` in `rgb-sleep-hook`, then **re-run the
  install command**.

The LEDs lean yellow, so keep the green channel low for orange and red.

## Troubleshooting

- `openrgb` exits with 0 even when it fails, so look for the problem in its
  text output:
  - login: `~/.cache/fire-rgb.log`
  - suspend/resume: `journalctl -b -t rgb-sleep`
- Is the server running? `systemctl --user status openrgb-server`. Start it
  with `systemctl --user start openrgb-server`.
- RAM stayed bright during suspend? The journal will say "OpenRGB server not
  running", or show the call timing out.
- Lights or radiator curve not restored after resume? Run
  `~/.config/startup.sh` by hand, and check the journal.
- Check that the hook is installed: `ls -l /usr/lib/systemd/system-sleep/`
