# lua-hammerspoon-switch-wifi-shortcut
# author: thanhdevapp@gmail.com

# Wi-Fi Auto Switcher with Retry Logic for Hammerspoon

This script automatically switches between predefined Wi-Fi networks with retry logic in case of connection failure. It is designed for use with [Hammerspoon](https://www.hammerspoon.org/), a powerful automation tool for macOS.

## Features

- Automatically switches between predefined Wi-Fi networks.
- Supports retrying the connection up to 3 times if the connection fails.
- Provides notifications to inform the user of the connection status.
- Simple hotkey (`Cmd + Alt + Ctrl + W`) to switch between Wi-Fi networks.

## Prerequisites

- macOS
- Hammerspoon installed: [Download Hammerspoon](https://www.hammerspoon.org/)

## Setup

1. **Install Hammerspoon**: If you haven't installed Hammerspoon yet, download it from [here](https://www.hammerspoon.org/) and follow the installation instructions.

2. **Clone or download the script**: Save the Lua script from this repository to your computer.

3. **Add the script to Hammerspoon**:
    - Open Hammerspoon and click the Hammerspoon icon in the top menu bar, then click `Open Config`.
    - Replace the contents of `init.lua` with the provided Lua code in this repository or add the code to your existing config file.

4. **Define your Wi-Fi networks**:
    - Update the `wifi_networks` table in the script to include your SSIDs and passwords:
    ```lua
    local wifi_networks = {
        { ssid = "Your_SSID_1", password = "Your_Password_1" },
        { ssid = "Your_SSID_2", password = "Your_Password_2" }
    }
    ```

5. **Reload Hammerspoon Configuration**:
    - After saving the script in `init.lua`, click the Hammerspoon icon in the top menu bar and choose `Reload Config`.
    - You can also reload the configuration by opening the Hammerspoon Console (`Cmd + Alt + Ctrl + R`) and typing:
      ```lua
      hs.reload()
      ```

## Usage

- Press the hotkey combination `Cmd + Alt + Ctrl + W` to switch between the predefined Wi-Fi networks.
- The script will attempt to connect to the next Wi-Fi network in the list.
- If the connection fails, the script will retry up to 3 times, waiting 2 seconds between each attempt.

## Hammerspoon Console

To check the output or debug the script, you can open the Hammerspoon Console with the following steps:

1. **Open Hammerspoon Console**:
   - Click on the Hammerspoon icon in the macOS menu bar and choose `Console` from the dropdown menu.
   - Alternatively, use the hotkey `Cmd + Alt + Ctrl + R` to open the console.

2. **View logs**:
   - The script logs the current Wi-Fi network, the target Wi-Fi network, and the result of the connection attempts in the console.

## Example Log Output

```plaintext
Current WiFi Network: None
Switching to WiFi Network: Your_SSID_1
Successfully switched to Your_SSID_1
