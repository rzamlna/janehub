-- IkyyxzHub - WindUI Version
-- Webhook Feature
-- Made for Delta Executor

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "IkyyxzHub",
    Icon = "rbxassetid://10723415903",
    Author = "Ikyyxz",
    Folder = "IkyyxzConfig",
    Size = UDim2.fromOffset(580, 460),
    KeySystem = {
        Key = "IkyyxzKey2024",
        Note = "Join Discord untuk key!",
        URL = "https://discord.gg/yourlink",
        SaveKey = true
    },
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

-- Notifikasi saat load
Window:Notify({
    Title = "Janehub",
    Content = "Script loaded successfully!",
    Duration = 5
})

-- ===================================
-- TAB: WEBHOOK
-- ===================================
local WebhookTab = Window:Tab({
    Name = "Webhook",
    Icon = "rbxassetid://10723407389",
    Color = Color3.fromRGB(0, 125, 255)
})

local WebhookSection = WebhookTab:Section({
    Name = "Discord Webhook Settings"
})

-- Variable untuk menyimpan webhook URL
local webhookURL = ""
local webhookEnabled = false

WebhookSection:Input({
    Name = "Webhook URL",
    Placeholder = "https://discord.com/api/webhooks/...",
    Value = "",
    Callback = function(value)
        webhookURL = value
        if value ~= "" then
            Window:Notify({
                Title = "Webhook",
                Content = "Webhook URL telah disimpan!",
                Duration = 3
            })
        end
    end
})

WebhookSection:Toggle({
    Name = "Enable Webhook",
    Value = false,
    Callback = function(value)
        webhookEnabled = value
        if value then
            Window:Notify({
                Title = "Webhook",
                Content = "Webhook diaktifkan!",
                Duration = 3
            })
        else
            Window:Notify({
                Title = "Webhook",
                Content = "Webhook dinonaktifkan!",
                Duration = 3
            })
        end
    end
})

local MessageSection = WebhookTab:Section({
    Name = "Send Message"
})

MessageSection:Input({
    Name = "Message Content",
    Placeholder = "Type your message here...",
    Value = "",
    Multiline = true,
    Callback = function(value)
        if webhookEnabled and webhookURL ~= "" and value ~= "" then
            -- Kirim message ke webhook
            local data = {
                ["content"] = value,
                ["username"] = "Janehub Bot",
                ["avatar_url"] = "https://i.imgur.com/AfFp7pu.png"
            }
            
            local success, result = pcall(function()
                return request({
                    Url = webhookURL,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = game:GetService("HttpService"):JSONEncode(data)
                })
            end)
            
            if success then
                Window:Notify({
                    Title = "Webhook",
                    Content = "Message sent successfully!",
                    Duration = 3
                })
            else
                Window:Notify({
                    Title = "Error",
                    Content = "Failed to send message!",
                    Duration = 3
                })
            end
        elseif webhookURL == "" then
            Window:Notify({
                Title = "Error",
                Content = "Please set webhook URL first!",
                Duration = 3
            })
        elseif not webhookEnabled then
            Window:Notify({
                Title = "Error",
                Content = "Please enable webhook first!",
                Duration = 3
            })
        end
    end
})

local PlayerInfoSection = WebhookTab:Section({
    Name = "Send Player Info"
})

PlayerInfoSection:Button({
    Name = "Send My Info",
    Callback = function()
        if webhookEnabled and webhookURL ~= "" then
            local player = game.Players.LocalPlayer
            
            -- Buat embed untuk Discord
            local embed = {
                ["title"] = "Player Information",
                ["color"] = 65535, -- Blue color
                ["fields"] = {
                    {
                        ["name"] = "Username",
                        ["value"] = player.Name,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Display Name",
                        ["value"] = player.DisplayName,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "User ID",
                        ["value"] = tostring(player.UserId),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Account Age",
                        ["value"] = tostring(player.AccountAge) .. " days",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Game",
                        ["value"] = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
                        ["inline"] = false
                    },
                    {
                        ["name"] = "Server JobId",
                        ["value"] = game.JobId,
                        ["inline"] = false
                    }
                },
                ["thumbnail"] = {
                    ["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
                },
                ["footer"] = {
                    ["text"] = "Janehub | " .. os.date("%c")
                }
            }
            
            local data = {
                ["username"] = "Janehub Bot",
                ["avatar_url"] = "https://i.imgur.com/AfFp7pu.png",
                ["embeds"] = {embed}
            }
            
            local success, result = pcall(function()
                return request({
                    Url = webhookURL,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = game:GetService("HttpService"):JSONEncode(data)
                })
            end)
            
            if success then
                Window:Notify({
                    Title = "Webhook",
                    Content = "Player info sent successfully!",
                    Duration = 3
                })
            else
                Window:Notify({
                    Title = "Error",
                    Content = "Failed to send player info!",
                    Duration = 3
                })
            end
        else
            Window:Notify({
                Title = "Error",
                Content = "Please configure webhook first!",
                Duration = 3
            })
        end
    end
})

PlayerInfoSection:Button({
    Name = "Send All Players Info",
    Callback = function()
        if webhookEnabled and webhookURL ~= "" then
            local players = game.Players:GetPlayers()
            local playerList = ""
            
            for i, player in ipairs(players) do
                playerList = playerList .. i .. ". " .. player.Name .. " (ID: " .. player.UserId .. ")\n"
            end
            
            local embed = {
                ["title"] = "All Players in Server",
                ["description"] = "Total Players: " .. #players,
                ["color"] = 65535,
                ["fields"] = {
                    {
                        ["name"] = "Player List",
                        ["value"] = playerList ~= "" and playerList or "No players found",
                        ["inline"] = false
                    }
                },
                ["footer"] = {
                    ["text"] = "Janehub | " .. os.date("%c")
                }
            }
            
            local data = {
                ["username"] = "Janehub Bot",
                ["avatar_url"] = "https://i.imgur.com/AfFp7pu.png",
                ["embeds"] = {embed}
            }
            
            local success, result = pcall(function()
                return request({
                    Url = webhookURL,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = game:GetService("HttpService"):JSONEncode(data)
                })
            end)
            
            if success then
                Window:Notify({
                    Title = "Webhook",
                    Content = "All players info sent!",
                    Duration = 3
                })
            else
                Window:Notify({
                    Title = "Error",
                    Content = "Failed to send players info!",
                    Duration = 3
                })
            end
        else
            Window:Notify({
                Title = "Error",
                Content = "Please configure webhook first!",
                Duration = 3
            })
        end
    end
})

local CustomSection = WebhookTab:Section({
    Name = "Custom Webhook"
})

CustomSection:Button({
    Name = "Test Webhook",
    Callback = function()
        if webhookEnabled and webhookURL ~= "" then
            local data = {
                ["content"] = "🔔 **Webhook Test**\n\nThis is a test message from IkyyxzHub!",
                ["username"] = "Janehub Bot",
                ["avatar_url"] = "https://i.imgur.com/AfFp7pu.png"
            }
            
            local success, result = pcall(function()
                return request({
                    Url = webhookURL,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = game:GetService("HttpService"):JSONEncode(data)
                })
            end)
            
            if success then
                Window:Notify({
                    Title = "Success",
                    Content = "Webhook is working!",
                    Duration = 3
                })
            else
                Window:Notify({
                    Title = "Error",
                    Content = "Webhook test failed!",
                    Duration = 3
                })
            end
        else
            Window:Notify({
                Title = "Error",
                Content = "Please configure webhook first!",
                Duration = 3
            })
        end
    end
})

-- ===================================
-- TAB: SETTINGS
-- ===================================
local SettingsTab = Window:Tab({
    Name = "Settings",
    Icon = "rbxassetid://10734950309",
    Color = Color3.fromRGB(150, 150, 150)
})

local InfoSection = SettingsTab:Section({
    Name = "Script Information"
})

InfoSection:Label({
    Text = "Script: IkyyxzHub"
})

InfoSection:Label({
    Text = "Version: 1.0"
})

InfoSection:Label({
    Text = "Author: Ikyyxz"
})

local UISection = SettingsTab:Section({
    Name = "UI Controls"
})

UISection:Button({
    Name = "Destroy UI",
    Callback = function()
        Window:Destroy()
    end
})

-- Init
print("=== Janehub Loaded ===")
print("WindUI Library Active")
print("Webhook Feature Ready")
print("=======================")
