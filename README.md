# 🌐 NordVPN Complete Manager (Bash Script)

An interactive **menu-driven Bash script** for managing NordVPN directly from the terminal.  
No need to memorize CLI commands — just run the script and navigate through a simple menu.

---

## ✨ Features

- **Color-coded output** for clarity:
  - 🔴 Red → Errors or invalid options
  - 🟢 Green → Success messages and headings
  - 🟡 Yellow → Highlighted settings
  - 🔵 Blue → Status panels and exit messages

- **Interactive menu system** with options to:
  - Connect to recommended servers, specific countries, or cities
  - Disconnect easily
  - Switch between protocols (UDP/TCP) and technologies (NordLynx/OpenVPN)
  - Login, logout, register, and view account info
  - Connect to special servers (Double VPN, P2P)
  - Manage advanced features:
    - Threat Protection Lite
    - Kill Switch
    - Auto-connect
    - Custom DNS
    - Meshnet
    - LAN Discovery
  - Add/remove allowlisted ports and subnets
  - View available countries and cities
  - Check connection status and current settings

---

## 📋 How It Works

1. **Color Variables**  
   ANSI escape codes are used to add colors to terminal output.

2. **Helper Functions**  
   - `press_enter()` → Pauses execution until Enter is pressed  
   - `show_status_panel()` → Displays VPN status, allowlisted ports, and subnets  
   - `get_lan_discovery_status()` → Retrieves LAN Discovery setting  
   - `show_main_menu()` → Prints the interactive menu  

3. **Main Loop**  
   - Continuously shows the menu and status panel  
   - Waits for user input  
   - Executes the corresponding NordVPN command  

---

## 🖥️ Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/sohmee/nordvpn-manager.git
   cd nordvpn-manager

   chmod +x nordvpn-manager.sh
./nordvpn-manager.sh

⚙️ Requirements
NordVPN CLI installed (nordvpn command available) 👉 NordVPN Linux CLI installation guide

Bash shell environment (Linux/macOS)

Active NordVPN account

🚀 Why Use This Script?
Simplifies NordVPN CLI usage with a single interactive tool

Saves time by avoiding repetitive commands

Provides a visual overview of your VPN status and settings

📜 License
This project is licensed under the MIT License. Feel free to use, modify, and share!

🙌 Contributing
Pull requests are welcome! If you’d like to add new features or improve the script, please fork the repo and submit a PR.
