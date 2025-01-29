-- MAKE SURE THIS IS IN A SERVERSIDE SCRIPT
-- I MADE  THIS FOR ZTEOZ BECAUSE THEIR CHANNELS WERE FILLED WITH TICKETS AND THE DUMB MODS DONT KNOW HOW TO HOST DISCORD BOTS
-- FEEL FREE TO TAKE INSPIRATION :D

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local token = "REPLACE-WITH-YOUR-BOT-TOKEN"
local targetGuildId = "1317183746998407220"

local function deleteChannel(channelId)
    local url = "https://discord.com/api/v9/channels/" .. channelId
    local headers = {
        ["Authorization"] = "Bot " .. token,
        ["Content-Type"] = "application/json"
    }

    local success, response = pcall(function()
        return HttpService:RequestAsync({
            Url = url,
            Method = "DELETE",
            Headers = headers
        })
    end)

    if success and response.StatusCode == 204 then
        print("Deleted channel " .. channelId)
    else
        warn("Failed to delete channel " .. channelId)
        if response then
            warn("Response: " .. response.StatusCode .. " - " .. response.Body)
        end
    end
end

local function getGuildChannels()
    local url = "https://discord.com/api/v9/guilds/" .. targetGuildId .. "/channels"
    local headers = {
        ["Authorization"] = "Bot " .. token
    }

    local success, response = pcall(function()
        return HttpService:GetAsync(url, true, headers)
    end)

    if success then
        print("Successfully retrieved channels")
        local channels = HttpService:JSONDecode(response)
        for _, channel in ipairs(channels) do
            if string.match(channel.name, "^ticket%-") then
                print("Channel name: " .. channel.name)
            end
        end
        return channels
    else
        warn("Failed to get channels")
        if response then
            warn("Response: " .. response.StatusCode .. " - " .. response.Body)
        end
        return {}
    end
end

local function deleteTicketChannels()
    local channels = getGuildChannels()
    local channelsDeleted = false

    for _, channel in ipairs(channels) do
        if string.match(channel.name, "^ticket%-") then
            deleteChannel(channel.id)
            channelsDeleted = true
        end
    end

    return channelsDeleted
end

local function onPlayerChatted(player, message)
    if message == "/delete-tickets" then
        print("Delete tickets command received.")
        while deleteTicketChannels() do
            wait(1)
        end
        print("All matching channels have been deleted.")
        wait(0.5)
        player:Kick("Channels have been deleted")
    end
end

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end)
