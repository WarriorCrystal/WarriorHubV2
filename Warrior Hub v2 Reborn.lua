local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/WarriorCrystal/WarriorHubV2/main/Edited%20UI%20Lib", true))()
local creditList = loadstring(game:HttpGet("https://raw.githubusercontent.com/WarriorCrystal/WarriorHubV2/main/Shit.lua", true))()
local inviteModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Discord%20Inviter/Source.lua"))()


local playerService = game:GetService("Players")
local localPlayer = playerService.LocalPlayer
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local mouse = localPlayer:GetMouse()
local gtg = getgenv()


local supportedGame = "Booga Booga Reborn"
local window = library:Load({Name = "Warrior Hub v2 - " .. supportedGame .. " - " .. localPlayer.name, Theme = "Warrior", SizeX = 440, SizeY = 480, ColorOverrides = {}})

-- TODO: Everything

-- Booga Booga Notifications

gtg.notifToggle = true
gtg.notifColor = Color3.fromRGB(255, 0, 0)
local functionBank = getsenv(localPlayer.PlayerScripts["Local Handler"])
local function notif(text, duration)
    if gtg.notifToggle then
        functionBank.functionBank.CreateNotification(text, gtg.notifColor, duration or 3)
    end
end


-- Main

local mainTab = window:Tab("Main")

local mainSection = mainTab:Section({Name = "Main", column = 1})

local welcomeLabel = mainSection:Label("Welcome to Warrior Hub")

local toggleGuiLabel = mainSection:Label("Toggle GUI with RSHIFT")

local joinDc = mainSection:Button({Name = "Join Discord", Callback = function()
    inviteModule.Join("https://discord.gg/EdHhqP7TzZ")
end})

local destroyGui = mainSection:Button({Name = "Destroy GUI", Callback = function()
    game:GetService("CoreGui").WarriorHub:Destroy()
end})

local creditsSection = mainTab:Section({Name = "Donators/Credits", column = 1})

local donators = creditsSection:Dropdown({Default = "Donators", Content = gtg.Donators, MultiChoice = false, Flag = "Dropdown", Callback = function(opt)
end})

local credits = creditsSection:Dropdown({Default = "Credits", Content = gtg.Credits, MultiChoice = false, Flag = "Dropdown", Callback = function(opt)
end})

local notifSection = mainTab:Section({Name = "Notifications", column = 2})

local notifToggle = notifSection:Toggle({Name = "Toggle", Flag = "Toggle", callback = function(bool)
    gtg.notifToggle = bool
end})

notifToggle:Toggle(true)

local notifColor = notifSection:ColorPicker({name = "Notification Color", Default = Color3.fromRGB(255, 0, 0),  Flag = "Color Picker", Callback = function(color)
    gtg.notifColor = color
end})

-- Combat

local combatTab = window:Tab("Combat")

local killAuraSection = combatTab:Section({Name = "Kill Aura", column = 1})

gtg.killAura = false

gtg.killAuraRange = 20

local function killAura()
    spawn(function()
        runService.RenderStepped:Connect(function()
            if gtg.killAura then
                for i, v in pairs(playerService:GetPlayers()) do
                    if v ~= localPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 and localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") and localPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character.Humanoid.Health > 0 and (localPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude < gtg.killAuraRange then
                        local rTV = replicatedStorage.RelativeTime.Value
                        local auraTable = {
                            [1] = v.Character.HumanoidRootPart,
                        }
                        replicatedStorage.Events.SwingTool:FireServer(rTV, auraTable)
                    end
                end
            end
        end)
    end)
end

local killAuraToggle = killAuraSection:Toggle({Name = "Toggle", Flag = "Toggle", callback = function(bool)
    gtg.killAura = bool
    killAura()
end})

local killAuraRange = killAuraSection:Slider({Name = "Range", Min = 1, Max = 100, Default = 20, Flag = "Slider", Callback = function(slider)
    gtg.killAuraRange = slider
    notif("Set Kill Aura Range to " .. slider)
end})