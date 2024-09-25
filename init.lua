-- Danh sách mạng Wi-Fi và mật khẩu tương ứng
local wifi_networks = {
    { ssid = "CRM team 3", password = "password" },
    { ssid = "Link_T3_CRM", password = "kHongtHicHcHo@" }
}

-- Biến theo dõi trạng thái mạng hiện tại
local current_index = 1
local max_retries = 5 -- Số lần thử lại tối đa


function getCurrentWiFiNetwork(callback)
    local command = "networksetup -getairportnetwork en0"  -- Thay đổi en0 nếu cần
    hs.task.new("/bin/bash", function(exitCode, stdOut, stdErr)
        -- Lấy tên mạng mà không có phần "Current Wi-Fi Network:"
        local networkName = stdOut:match(":(.+)") -- Lấy phần sau dấu hai chấm
        if networkName then
            networkName = networkName:gsub("^%s*(.-)%s*$", "%1") -- Xóa khoảng trắng
        else
            networkName = "None" -- Không có mạng nào
        end
        if callback then
            callback(networkName) -- Gọi callback với tên mạng
        end
    end, {"-c", command}):start()
end

-- Hàm để chuyển đổi giữa các mạng Wi-Fi
function toggleWiFiNetwork()
    getCurrentWiFiNetwork(function(current_network)
        -- Log tên mạng hiện tại
        print("Current WiFi Network: " .. current_network)
        
        -- Kiểm tra xem mạng hiện tại là mạng nào và chọn mạng tiếp theo
        if current_network == wifi_networks[current_index].ssid then
            -- Chuyển sang mạng tiếp theo
            current_index = current_index % #wifi_networks + 1
        end

        local target_network = wifi_networks[current_index]

        -- Log thông tin về mạng Wi-Fi sẽ chuyển đến
        print("Switching to WiFi Network: " .. target_network.ssid)

        -- Biến theo dõi số lần thử lại
        local retries = 0
        local success = false

        -- Hàm nội bộ để thử kết nối
        local function tryConnect()
            success = hs.wifi.associate(target_network.ssid, target_network.password)
            retries = retries + 1
            if success then
                hs.notify.new({title="WiFi Network", informativeText="Switched to " .. target_network.ssid}):send()
                print("Successfully switched to " .. target_network.ssid)
            elseif retries < max_retries then
                print("Retrying... (" .. retries .. "/" .. max_retries .. ")")
                hs.timer.doAfter(2, tryConnect) -- Thử lại sau 2 giây
            else
                hs.notify.new({title="WiFi Network", informativeText="Failed to switch to " .. target_network.ssid .. " after " .. retries .. " attempts"}):send()
                print("Failed to switch to " .. target_network.ssid .. " after " .. retries .. " attempts")
            end
        end

        -- Bắt đầu thử kết nối lần đầu tiên
        tryConnect()
    end)    
end

-- Đặt phím tắt để chuyển đổi mạng Wi-Fi
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", toggleWiFiNetwork)
