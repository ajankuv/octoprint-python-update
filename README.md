# OctoPrint Python 3.11 In-Place Upgrade Script

This repository provides a script to upgrade an existing OctoPrint installation to Python 3.11 in place. It is designed for OctoPrint setups running in `/home/pi/oprint` on Raspbian systems, preserving all plugins, settings, user data, and environment paths.

---

## What This Script Does

- Installs Python 3.11.9 from source
- Stops the currently running OctoPrint systemd service
- Backs up the existing virtual environment in `/home/pi/oprint` to a timestamped folder
- Creates a new virtual environment in the same path using Python 3.11
- Installs OctoPrint into the new environment
- Automatically reinstalls all previously installed plugins
- Restarts the OctoPrint service using the upgraded environment
- Leaves your configuration files, upload history, and timelapse data untouched

---

## Requirements

- Raspbian Buster or newer
- OctoPrint installed in `/home/pi/oprint`
- OctoPrint running as the `pi` user
- Systemd service named `octoprint` already configured
- Root access (use `sudo -i`)

---

## How to Use

1. SSH into your Raspberry Pi.
2. Elevate to root using `sudo -i`.
3. Download or create the upgrade script in your home directory.
4. Make the script executable using `chmod +x`.
5. Run the script as root.
6. Wait for the process to complete (Python compilation may take several minutes).
7. When complete, your OctoPrint instance will be running under Python 3.11 and all data will be preserved.

---

## Backup and Recovery

Before making changes, the script automatically backs up your original virtual environment to a folder named `/home/pi/oprint_backup_YYYYMMDD_HHMMSS`.

If you encounter any issues, you can:

1. Stop the OctoPrint service.
2. Delete the new `/home/pi/oprint` folder.
3. Restore the backup folder by renaming it to `oprint`.
4. Start the OctoPrint service again.

---

## Troubleshooting

- If you cannot log in after the upgrade, reset your OctoPrint password using the CLI.
- If a plugin fails to reinstall, you can reinstall it manually via the OctoPrint web interface.
- Use `systemctl status octoprint` to check service status.

---

## License

This project is licensed under the MIT License.
