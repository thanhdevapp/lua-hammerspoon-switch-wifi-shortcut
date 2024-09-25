-- Danh sách mạng Wi-Fi và mật khẩu tương ứng
local wifi_networks = {
    { ssid = "CRM team 3", password = "2" },
    { ssid = "Link_T3_CRM", password = "1" }
}


local current_index = 1
local max_retries = 5 -- Số lần thử lại tối đa


function getCurrentWiFiNetwork(callback)
    local command = "networksetup -getairportnetwork en0"  -- Thay đổi en0 nếu cần
    hs.task.new("/bin/bash", function(exitCode, stdOut, stdErr)
        local networkName = stdOut:match(":(.+)") -- Lấy phần sau dấu hai chấm
        if networkName then
            networkName = networkName:gsub("^%s*(.-)%s*$", "%1")
        else
            networkName = "None"
        end
        if callback then
            callback(networkName)
        end
    end, {"-c", command}):start()
end

-- Hàm để chuyển đổi giữa các mạng Wi-Fi
function toggleWiFiNetwork()
    getCurrentWiFiNetwork(function(current_network)
        print("Current WiFi Network: " .. current_network)
        
        if current_network == wifi_networks[current_index].ssid then
            current_index = current_index % #wifi_networks + 1
        end

        local target_network = wifi_networks[current_index]

        print("Switching to WiFi Network: " .. target_network.ssid)

        local retries = 0
        local success = false

        local function tryConnect()
            success = hs.wifi.associate(target_network.ssid, target_network.password)
            retries = retries + 1
            if success then
                hs.notify.new({title="WiFi Network", informativeText="Switched to " .. target_network.ssid}):send()
                print("Successfully switched to " .. target_network.ssid)
            elseif retries < max_retries then
                print("Retrying... (" .. retries .. "/" .. max_retries .. ")")
                hs.timer.doAfter(2, tryConnect)
            else
                hs.notify.new({title="WiFi Network", informativeText="Failed to switch to " .. target_network.ssid .. " after " .. retries .. " attempts"}):send()
                print("Failed to switch to " .. target_network.ssid .. " after " .. retries .. " attempts")
            end
        end

        tryConnect()
    end)    
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", toggleWiFiNetwork)
