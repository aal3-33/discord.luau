-- PROLLY GONNA BE USING IT AS ANNOUNCEMENT EVERYTIME A RETARDED STAFF WILL DELETE THE TICKETS lol
-- ITS INSANELY EASY TO MAKE THIS AND I THOUGHT IT WAS HARD WELL ATLEAST NOW I KNOW

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local token = "YOUR-BOT-TOKEN"
local channelId = "1317183747581546535"

local function sendMessage(channelId, messageContent)
    local url = "https://discord.com/api/v9/channels/" .. channelId .. "/messages"
    local headers = {
        ["Authorization"] = "Bot " .. token,
        ["Content-Type"] = "application/json"
    }
    local data = {
        content = messageContent
    }

    local success, response = pcall(function()
        return HttpService:RequestAsync({
            Url = url,
            Method = "POST",
            Headers = headers,
            Body = HttpService:JSONEncode(data)
        })
    end)

    if success then
        if response.StatusCode == 200 or response.StatusCode == 201 then
            print("Message sent to channel " .. channelId)
        else
            warn("Failed to send message to channel " .. channelId)
            if response.Body then
                warn("Response: " .. response.StatusCode .. " - " .. response.Body)
            end
        end
    else
        warn("Request failed: " .. tostring(response))
    end
end

local function onPlayerChatted(player, message)
    local messageContent = string.match(message, "^/send%-message%s+(.+)")
    if messageContent and messageContent ~= "" then
        print("Send message command received from player: " .. player.Name)
        print("Message Content: " .. messageContent)
        sendMessage(channelId, messageContent)
    else
        warn("Invalid or empty message content from player: " .. player.Name)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end)
