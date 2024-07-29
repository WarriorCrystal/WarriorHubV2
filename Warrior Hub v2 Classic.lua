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


local supportedGame = "Booga Booga Classic"
local window = library:Load({Name = "Warrior Hub v2 - " .. supportedGame .. " - " .. localPlayer.name, Theme = "Warrior", SizeX = 440, SizeY = 480, ColorOverrides = {}})

-- TODO: Fix AutoEat and AutoHeal, Improve AutoFarm, Finish pasting other shit

-- Booga Booga Notifications
gtg.notifToggle = true
gtg.notifColor = Color3.fromRGB(255, 0, 0)
local functionBank = require(game:GetService("ReplicatedStorage").Modules.Client_Function_Bank)
local function notif(text, duration)
    if gtg.notifToggle then
        functionBank.CreateNotification(text, gtg.notifColor, duration or 3)
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
local killAuraRangeReset = killAuraSection:Button({Name = "Set to Default", Callback = function()
    killAuraRange:set(20)
    notif("Set Kill Aura Config to Default", 3)
end})
local tpSpamSection = combatTab:Section({Name = "Teleport Spam", column = 2})
gtg.tpSpamTarget = nil
gtg.tpSpamMode = "Normal"
gtg.tpSpamDistance = 0
gtg.tpSpam = false
local tpSpam = tpSpamSection:Toggle({Name = "Toggle", Flag = "Toggle", callback = function(bool)
    gtg.tpSpam = bool
    spawn(function()
        runService.RenderStepped:Connect(function()
            if gtg.tpSpam then
                for i,v in pairs(playerService:GetChildren()) do
                    if v.Name:lower():find(gtg.tpSpamTarget:lower()) then
                        if gtg.tpSpamMode == "Normal" then
                            localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Character.HumanoidRootPart.Position.x, v.Character.HumanoidRootPart.Position.y, v.Character.HumanoidRootPart.Position.z)
                        elseif gtg.tpSpamMode == "Up" then
                            localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Character.HumanoidRootPart.Position.x, v.Character.HumanoidRootPart.Position.y + gtg.tpSpamDistance, v.Character.HumanoidRootPart.Position.z)
                        elseif gtg.tpSpamMode == "Down" then
                            localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Character.HumanoidRootPart.Position.x, v.Character.HumanoidRootPart.Position.y - gtg.tpSpamDistance, v.Character.HumanoidRootPart.Position.z)
                        elseif gtg.tpSpamMode == "Around" then
                            localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Character.HumanoidRootPart.Position.x + math.random(-(gtg.tpSpamDistance), gtg.tpSpamDistance), v.Character.HumanoidRootPart.Position.y, v.Character.HumanoidRootPart.Position.z + math.random(-(gtg.tpSpamDistance), gtg.tpSpamDistance))
                        end
                    end
                end
            end
        end)
    end)
end})
local tpSpamTarget = tpSpamSection:Box({Name = "Target", Flag = "Box", Callback = function(box)
    gtg.tpSpamTarget = box
    notif("Set Target to " .. box, 3)
end})
local tpSpamMode = tpSpamSection:Dropdown({Default = "Normal", Content = {"Normal", "Around", "Up", "Down"}, MultiChoice = false, Flag = "Dropdown", Callback = function(opt)
    gtg.tpSpamMode = opt
    notif("Set Mode to " .. opt, 3)
end})
local tpSpamDistance = tpSpamSection:Slider({Name = "Distance", Min = 0, Max = 10, Default = 0, Flag = "Slider", Callback = function(slider)
    gtg.tpSpamDistance = slider
    notif("Set Distance to " .. slider, 3)
end})
local tpSpamReset = tpSpamSection:Button({Name = "Set to Default", Callback = function()
    tpSpamDistance:set(0)
    tpSpamMode:set("Normal")
    notif("Set Teleport Spam Config to Default", 3)
end})
local invisibilitySection = combatTab:Section({Name = "Invisibility", column = 1})
local invisibilityWarning = invisibilitySection:Label("You re-appear when you die")
local invisibilityWarning2 = invisibilitySection:Label("Armor re-appears re-equipping it")
local invisibleArmor = invisibilitySection:Button({Name = "Invisible Armor", Callback = function()
    spawn(function()
        for i, v in pairs(localPlayer.Character:GetChildren()) do
            if v.Name:find("Greaves") or v.Name:find("Chestplate") or v.Name:find("Mask") or v.Name:find("Helmet") or v.Name:find("Crown") or v.Name:find("Shoulder") or v.Name:find("Bag") then
                v.Handle:Destroy()
                notif("Your armor is now invisible", 3)
            end
        end
    end)
end})
local invisibility = invisibilitySection:Button({Name = "Complete Invisibility", Callback = function()
    loadstring(game:HttpGet("https://pastebin.com/raw/wtxtL2d2", true))()
    notif("You are now invisible", 3)
end})
local panicSection = combatTab:Section({Name = "Panic", column = 2})
local panicInfo = panicSection:Label("Teleports you to Safe Zone")
local manualPanic = panicSection:Keybind({Name = "Manual Panic", Default = Enum.KeyCode.F,  Flag = "Keybind", Callback = function(key)
    localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1682.2772216796875, -3.6036133766174316, -4133.912109375)
end})
gtg.autoPanic = false
gtg.autoPanicMode = "Bloodfruit"
gtg.autoPanicBloodfruits = 100
gtg.autoPanicHealth = 30
local autoPanic = panicSection:Toggle({Name = "Auto Panic", Flag = "Toggle", callback = function(bool)
    gtg.autoPanic = bool
    spawn(function()
        game:GetService("RunService").RenderStepped:Connect(function()
            if gtg.autoPanic then
                if gtg.autoPanicMode == "Bloodfruit" then
                    if not localPlayer.PlayerGui.MainGui.RightPanel.Inventory.List:FindFirstChild("Bloodfruit") or localPlayer.PlayerGui.MainGui.RightPanel.Inventory.List:FindFirstChild("Bloodfruit").QuantityImage.QuantityText.Text < gtg.autoPanicBloodfruits then
                        localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1682.2772216796875, -3.6036133766174316, -4133.912109375)
                    end
                else if gtg.autoPanicMode == "Health" then
                    if localPlayer.Character.Humanoid.Health < gtg.autoPanicHealth then
                        localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1682.2772216796875, -3.6036133766174316, -4133.912109375)
                    end
                else if gtg.autoPanicMode == "Combat Tag" then
                    if localPlayer.Character.Head:FindFirstChild("LogNotice") then
                        localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1682.2772216796875, -3.6036133766174316, -4133.912109375)
                    end
                end
                end
                end
            end
        end)
    end)
end})
local autoPanicMode = panicSection:Dropdown({Default = "Mode", Content = {"Bloodfruit", "Health", "Combat Tag"}, MultiChoice = false, Flag = "Dropdown", Callback = function(opt)
    gtg.autoPanicMode = opt
    notif("Mode set to " .. opt, 3)
end})
local autoPanicBloodfruits = panicSection:Slider({Name = "Bloodfruit", Min = 0, Max = 1000, Default = 100, Flag = "Slider", Callback = function(slider)
    gtg.autoPanicBloodfruits = slider
    notif("Bloodfruit set to " .. slider, 3)
end})
local autoPanicHealth = panicSection:Slider({Name = "Health", Min = 1, Max = 100, Default = 30, Flag = "Slider", Callback = function(slider)
    gtg.autoPanicHealth = slider
    notif("Health set to " .. slider, 3)
end})
local panicReset = panicSection:Button({Name = "Set to Default", Callback = function()
    autoPanicBloodfruits:set(100)
    autoPanicHealth:set(30)
    autoPanicMode:set("Bloodfruit")
    notif("Set Auto Panic Config to Default", 3)
end})
gtg.healItem = "Bloodfruit"
gtg.autoHeal = false
gtg.health = 80
local autoHealSection = combatTab:Section({Name = "AutoHeal", column = 1})
local autoHeal = autoHealSection:Toggle({Name = "Toggle", Flag = "Toggle", callback = function(bool)
    gtg.autoHeal = bool
    spawn(function()
        while wait(0.5) and gtg.health do
            if localPlayer.Character.Humanoid.Health < gtg.health then
                repeat
                    replicatedStorage.Events.UseBagItem:FireServer(gtg.healItem)
                    wait(0.05)
                until localPlayer.Character.Humanoid.Health > gtg.health
            end
        end
    end)
end})
local autoHealItem = autoHealSection:Box({Name = "Item", Flag = "Box", Callback = function(box)
    gtg.healItem = box
    notif("Item set to " .. box, 3)
end})
local autoHealHealth = autoHealSection:Slider({Name = "Heal Below", Min = 1, Max = 99, Default = 80, Flag = "Slider", Callback = function(slider)
    gtg.health = slider
    notif("Health set to " .. slider, 3)
end})
local autoHealReset = autoHealSection:Button({Name = "Set to Default", Callback = function()
    autoHealItem:set("Bloodfruit")
    autoHealHealth:set("80")
    notif("Set Auto Heal Config to Default", 3)
end})
gtg.gearFinderGear = "Magnetite"
gtg.gearFinderMode = "Notification"
local gearFinderSection = combatTab:Section({Name = "Find Players with Gear", column = 1})
local gearFinderLabel = gearFinderSection:Label("Only works with equipped gear")
local gearFinderGear = gearFinderSection:Dropdown({Default = "Magnetite", Content = {"Magnetite", "Crystal", "Adurite", "Iron", "Steel"}, MultiChoice = false, Flag = "Dropdown", Callback = function(opt)
    gtg.gearFinderGear = opt
end})
local gearFinderMode = gearFinderSection:Dropdown({Default = "Notification", Content = {"Notification", "Copy", "Both"}, MultiChoice = false, Flag = "Dropdown", Callback = function(opt)
    gtg.gearFinderMode = opt
end})
local gearFinderFind = gearFinderSection:Button({Name = "Find", Callback = function()
    spawn(function()
        for i, v in pairs(playerService:GetPlayers()) do
            if v ~= localPlayer then
                for i, v2 in pairs(v.Character:GetChildren()) do
                    if v2.Name:find(gtg.gearFinderGear) and not v2.Name:find("Bag") then
                        if gtg.gearFinderMode == "Notification" or gtg.gearFinderMode == "Both" then
                            notif(v.Name .. " has a " .. v2.Name)
                        end
                        if gtg.gearFinderMode == "Copy" or gtg.gearFinderMode == "Both" then
                            setclipboard(v.Name)
                        end
                        wait(0.5)
                    end
                end
            end
        end
    end)
end})