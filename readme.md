# Discord Auto-Updater for Linux

This script automatically checks for updates to Discord on Linux, downloads the latest `.deb` package, and installs it if necessary. It runs at user login and opens a terminal for output visibility.

## 📥 Installation

### 1️⃣ Clone the repository
```bash
git clone https://github.com/your-repo/discord-updater.git
cd discord-updater
```

### 2️⃣ Move the scripts to the appropriate location
```bash
mkdir -p $HOME/scripts/discord
mv launch_update.sh update.sh askpass.sh $HOME/scripts/discord/
chmod +x $HOME/scripts/discord/*.sh
```

### 3️⃣ Install dependencies
Ensure that the necessary dependencies are installed:
```bash
sudo apt update && sudo apt install -y curl wget dpkg zenity
```

### 4️⃣ Set up systemd service
Move the systemd service file and reload systemd:
```bash
mkdir -p ~/.config/systemd/user/
mv update_discord.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable update_discord.service
systemctl --user restart update_discord.service
```

## 🚀 Usage
Once installed, the script will automatically run at login and check for updates.
To manually trigger an update, run:
```bash
bash $HOME/scripts/update.sh
```
To check the service logs:
```bash
journalctl --user -u update_discord.service -f
```

## 📜 License
This project is licensed under the MIT License.