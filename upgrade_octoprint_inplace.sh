#!/bin/bash

set -e

echo "🔧 In-Place OctoPrint Python 3.11 Upgrade Script (pi user /home/pi/oprint)"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# 1. Install build dependencies
echo "📦 Installing dependencies..."
apt update
apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev \
  libnss3-dev libssl-dev libreadline-dev libffi-dev wget libsqlite3-dev \
  libbz2-dev tk-dev uuid-dev liblzma-dev lsof

# 2. Download + build Python 3.11
cd /usr/src
PY_VER="3.11.9"
if [ ! -d "Python-$PY_VER" ]; then
  echo "⬇️ Downloading Python $PY_VER..."
  wget https://www.python.org/ftp/python/$PY_VER/Python-$PY_VER.tgz
  tar xzf Python-$PY_VER.tgz
fi

cd Python-$PY_VER
echo "⚙️ Building Python $PY_VER (this may take time)..."
./configure --enable-optimizations
make -j$(nproc)
make altinstall

# 3. Save plugin list from old env
echo "📋 Saving plugin list from current oprint env..."
sudo -u pi /home/pi/oprint/bin/pip freeze > /home/pi/plugin_list.txt

# 4. Stop OctoPrint
echo "🛑 Stopping OctoPrint service..."
systemctl stop octoprint

# 5. Backup old environment
echo "🧯 Backing up current /home/pi/oprint to /home/pi/oprint_backup_$TIMESTAMP"
mv /home/pi/oprint /home/pi/oprint_backup_$TIMESTAMP

# 6. Recreate virtualenv with Python 3.11
echo "📁 Creating new virtualenv with Python 3.11..."
sudo -u pi python3.11 -m venv /home/pi/oprint

# 7. Activate new env and install OctoPrint
echo "📦 Installing OctoPrint into new environment..."
sudo -u pi /home/pi/oprint/bin/pip install --upgrade pip
sudo -u pi /home/pi/oprint/bin/pip install octoprint

# 8. Reinstall plugins
echo "🔁 Reinstalling plugins..."
sudo -u pi /home/pi/oprint/bin/pip install -r /home/pi/plugin_list.txt || true

# 9. Start OctoPrint again
echo "🔁 Restarting OctoPrint service..."
systemctl start octoprint

# 10. Clean up plugin list
rm /home/pi/plugin_list.txt

# 11. Done!
echo ""
echo "✅ Upgrade complete! OctoPrint is now running on Python 3.11"
echo "📁 Old environment saved at: /home/pi/oprint_backup_$TIMESTAMP"
echo "🌐 Access at: http://<your-pi-ip>:5000"
