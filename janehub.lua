-- Janehub - WindUI Version
-- Webhook FIX for Delta Executor

-- ===============================
-- LOAD WIND UI
-- ===============================
local WindUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
))()

-- ===============================
-- HTTP REQUEST UNIVERSAL (WAJIB)
-- ===============================
local HttpService = game:GetService("HttpService")

local http_request =
    request or
    http_request or
    (syn and syn.request) or
    (fluxus and fluxus.request)

if not http_request then
    warn("❌ Executor tidak support HTTP Request")
end

-- ===============================
-- WINDOW
-- ===============================
local Window = WindUI:CreateWindow({
    Title = "Janehub",
    Icon = "rbxassetid://10723415903",
    Author = "Ikyyxz",
    Folder = "JanehubConfig",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

Window:Notify({
    Title = "Janehub",
    Content = "Script loaded successfully!",
    Duration = 5
})

-- ===============================
-- WEBHOOK TAB
-- ===============================
local WebhookTab = Window:Tab({
    Name = "Webhook",
    Icon = "rbxassetid://10723407389",
    Color = Color3.fromRGB(0,125,255)
})

local WebhookSection = WebhookTab:Section({
    Name = "Discord Webhook"
})

local webhookURL = ""
local webhookEnabled = false

WebhookSection:Input({
    Name = "Webhook URL",
    Placeholder = "https://discord.com/api/webhooks/...",
    Callback = function(v)
        webhookURL = v
    end
})

WebhookSection:Toggle({
    Name = "Enable Webhook",
    Callback = function(v)
        webhookEnabled = v
    end
})

-- ===============================
-- SEND WEBHOOK FUNCTION
-- ===============================
local function SendWebhook(content, embed)
    if not webhookEnabled then return end
    if webhookURL == "" then return end
    if not http_request then return end

    local data = {
        username = "Janehub Bot",
        avatar_url = "https://i.imgur.com/AfFp7pu.png",
        content = content,
        embeds = embed and {embed} or nil
    }

    pcall(function()
        http_request({
            Url = webhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(data)
        })
    end)
end

-- ===============================
-- MESSAGE SECTION
-- ===============================
local MessageSection = WebhookTab:Section({
    Name = "Send Message"
})

MessageSection:Input({
    Name = "Message",
    Placeholder = "Type message...",
    Multiline = true,
    Callback = function(text)
        if text ~= "" then
            SendWebhook(text)
            Window:Notify({
                Title = "Webhook",
                Content = "Message sent",
                Duration = 3
            })
        end
    end
})

-- ===============================
-- PLAYER INFO
-- ===============================
local PlayerInfoSection = WebhookTab:Section({
    Name = "Player Info"
})

PlayerInfoSection:Button({
    Name = "Send My Info",
    Callback = function()
        local p = game.Players.LocalPlayer

        local embed = {
            title = "Player Information",
            color = 3447003,
            fields = {
                {name="Username", value=p.Name, inline=true},
                {name="Display Name", value=p.DisplayName, inline=true},
                {name="UserId", value=tostring(p.UserId), inline=true},
                {name="Account Age", value=p.AccountAge.." days", inline=true},
                {name="Game", value=game:GetService("MarketplaceService")
                    :GetProductInfo(game.PlaceId).Name, inline=false},
                {name="Server JobId", value=game.JobId, inline=false}
            },
            thumbnail = {
                url = "https://www.roblox.com/headshot-thumbnail/image?userId="
                    ..p.UserId.."&width=420&height=420&format=png"
            },
            footer = {
                text = "Janehub | "..os.date("%c")
            }
        }

        SendWebhook(nil, embed)
        Window:Notify({
            Title = "Webhook",
            Content = "Player info sent",
            Duration = 3
        })
    end
})

-- ===============================
-- TEST WEBHOOK (PALING PENTING)
-- ===============================
local TestSection = WebhookTab:Section({
    Name = "Test"
})

TestSection:Button({
    Name = "Test Webhook (Delta)",
    Callback = function()
        SendWebhook("✅ Webhook berhasil! (Delta Executor)")
        Window:Notify({
            Title = "Success",
            Content = "Check Discord!",
            Duration = 3
        })
    end
})

-- ===============================
-- SETTINGS TAB
-- ===============================
local SettingsTab = Window:Tab({
    Name = "Settings",
    Icon = "rbxassetid://10734950309"
})

SettingsTab:Section({
    Name = "UI"
}):Button({
    Name = "Destroy UI",
    Callback = function()
        Window:Destroy()
    end
})

-- ===============================
-- INIT LOG
-- ===============================
print("=== Janehub Loaded ===")
print("Webhook: FIXED FOR DELTA")
print("======================")
