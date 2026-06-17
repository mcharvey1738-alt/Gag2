-- ============================================================
--  BELLE.SG - GAG2 ULTIMATE EDITION
--  UI: Rayfield | Auto Steal | Farm | Buy | Plant | Pet | Anti-AFK
-- ============================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- ============================================================
-- 1. GLOBAL FEATURE TOGGLES
-- ============================================================
_G.BelleSG = {
    AutoSteal = false,
    AutoCollectFruits = false,
    AutoHarvest = false,
    AutoBuyPlant = false,
    AntiAFK = false,
    AutoFarm = false,
    AutoPet = false,

    -- Seeds
    AutoBuy_Carrot = false,
    AutoBuy_Strawberry = false,
    AutoBuy_Blueberry = false,
    AutoBuy_Tomato = false,
    AutoBuy_Corn = false,
    AutoBuy_Daffodil = false,
    AutoBuy_Tulip = false,
    AutoBuy_Bamboo = false,
    AutoBuy_Watermelon = false,
    AutoBuy_Pumpkin = false,
    AutoBuy_AppleTree = false,
    AutoBuy_OrangeTree = false,
    AutoBuy_Cactus = false,
    AutoBuy_DragonFruit = false,
    AutoBuy_Mango = false,
    AutoBuy_Grape = false,
    AutoBuy_Mushroom = false,
    AutoBuy_Beanstalk = false,
    AutoBuy_SugarApple = false,
    AutoBuy_EmberLily = false,

    -- Gears
    AutoBuy_CommonWateringCan = false,
    AutoBuy_UncommonWateringCan = false,
    AutoBuy_RareWateringCan = false,
    AutoBuy_LegendaryWateringCan = false,
    AutoBuy_CommonSprinkler = false,
    AutoBuy_UncommonSprinkler = false,
    AutoBuy_RareSprinkler = false,
    AutoBuy_JumpMushroom = false,
    AutoBuy_SpeedMushroom = false,
    AutoBuy_Gnome = false,
    AutoBuy_Trowel = false,
    AutoBuy_MasterSprinkler = false,

    -- Props
    AutoBuy_LadderCrate = false,
    AutoBuy_BenchCrate = false,
    AutoBuy_BearTrapCrate = false,
    AutoBuy_LightCrate = false,
    AutoBuy_BridgeCrate = false,
    AutoBuy_SeesawCrate = false,
    AutoBuy_OwnerDoorCrate = false,
    AutoBuy_RoleplayCrate = false,
    AutoBuy_FountainCrate = false,
    AutoBuy_TreehouseCrate = false,

    AutoPlantAfterBuy = true,

    ThreadID = 0,
}

_G.BelleSG.ThreadID = _G.BelleSG.ThreadID + 1
local currentThread = _G.BelleSG.ThreadID

-- ============================================================
-- 2. LOAD RAYFIELD UI LIBRARY
-- ============================================================
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)

if not success then
    warn("[BELLE.SG] Failed to load Rayfield: " .. tostring(Rayfield))
    return
end

-- ============================================================
-- 3. CREATE WINDOW
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name = "BELLE.SG",
    LoadingTitle = "BELLE.SG Hub",
    LoadingSubtitle = "Grow a Garden 2 | Ultimate Edition",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BelleSG",
        FileName = "GAG2Config"
    },
    KeySystem = false,
})

-- ============================================================
-- 4. TAB: FARMING
-- ============================================================
local FarmTab = Window:CreateTab("🌾 Farming", 4483362458)

FarmTab:CreateToggle({
    Name = "Auto Harvest",
    CurrentValue = false,
    Flag = "AutoHarvest",
    Callback = function(v) _G.BelleSG.AutoHarvest = v end,
})

FarmTab:CreateToggle({
    Name = "Auto Farm & Sell",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(v) _G.BelleSG.AutoFarm = v end,
})

FarmTab:CreateToggle({
    Name = "Auto Buy & Plant",
    CurrentValue = false,
    Flag = "AutoBuyPlant",
    Callback = function(v) _G.BelleSG.AutoBuyPlant = v end,
})

FarmTab:CreateToggle({
    Name = "Auto Plant After Buy",
    CurrentValue = true,
    Flag = "AutoPlantAfterBuy",
    Callback = function(v) _G.BelleSG.AutoPlantAfterBuy = v end,
})

FarmTab:CreateSection("Collection")

FarmTab:CreateToggle({
    Name = "Auto Collect Fruits",
    CurrentValue = false,
    Flag = "AutoCollectFruits",
    Callback = function(v) _G.BelleSG.AutoCollectFruits = v end,
})

FarmTab:CreateToggle({
    Name = "Auto Steal (Night)",
    CurrentValue = false,
    Flag = "AutoSteal",
    Callback = function(v) _G.BelleSG.AutoSteal = v end,
})

FarmTab:CreateSection("Pet")

FarmTab:CreateToggle({
    Name = "Auto Buy Legendary Pet",
    CurrentValue = false,
    Flag = "AutoPet",
    Callback = function(v) _G.BelleSG.AutoPet = v end,
})

FarmTab:CreateSection("Utility")

FarmTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(v) _G.BelleSG.AntiAFK = v end,
})

FarmTab:CreateButton({
    Name = "Teleport to My Garden",
    Callback = function()
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        for _, obj in pairs(Workspace:GetDescendants()) do
            if string.find(string.lower(obj.Name), string.lower(LocalPlayer.Name)) then
                if obj:IsA("BasePart") then
                    root.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                    Rayfield:Notify({ Title = "Teleported!", Content = "Moved to your garden.", Duration = 3 })
                    return
                end
            end
        end
        Rayfield:Notify({ Title = "Not Found", Content = "Garden not found.", Duration = 3 })
    end,
})

-- ============================================================
-- 5. TAB: SEEDS
-- ============================================================
local SeedsTab = Window:CreateTab("🌱 Seeds", 4483362458)

SeedsTab:CreateSection("Common Seeds")

local seedList = {
    { name = "Carrot",       flag = "AutoBuy_Carrot" },
    { name = "Strawberry",   flag = "AutoBuy_Strawberry" },
    { name = "Blueberry",    flag = "AutoBuy_Blueberry" },
    { name = "Tomato",       flag = "AutoBuy_Tomato" },
    { name = "Corn",         flag = "AutoBuy_Corn" },
    { name = "Daffodil",     flag = "AutoBuy_Daffodil" },
    { name = "Tulip",        flag = "AutoBuy_Tulip" },
    { name = "Bamboo",       flag = "AutoBuy_Bamboo" },
    { name = "Watermelon",   flag = "AutoBuy_Watermelon" },
    { name = "Pumpkin",      flag = "AutoBuy_Pumpkin" },
    { name = "Cactus",       flag = "AutoBuy_Cactus" },
    { name = "Mushroom",     flag = "AutoBuy_Mushroom" },
}

local raresSeedList = {
    { name = "Apple Tree",   flag = "AutoBuy_AppleTree" },
    { name = "Orange Tree",  flag = "AutoBuy_OrangeTree" },
    { name = "Dragon Fruit", flag = "AutoBuy_DragonFruit" },
    { name = "Mango",        flag = "AutoBuy_Mango" },
    { name = "Grape",        flag = "AutoBuy_Grape" },
}

local legendSeedList = {
    { name = "Beanstalk",    flag = "AutoBuy_Beanstalk" },
    { name = "Sugar Apple",  flag = "AutoBuy_SugarApple" },
    { name = "Ember Lily",   flag = "AutoBuy_EmberLily" },
}

for _, seed in pairs(seedList) do
    SeedsTab:CreateToggle({
        Name = "Auto Buy " .. seed.name,
        CurrentValue = false,
        Flag = seed.flag,
        Callback = function(v) _G.BelleSG[seed.flag] = v end,
    })
end

SeedsTab:CreateSection("Rare Seeds")

for _, seed in pairs(raresSeedList) do
    SeedsTab:CreateToggle({
        Name = "Auto Buy " .. seed.name,
        CurrentValue = false,
        Flag = seed.flag,
        Callback = function(v) _G.BelleSG[seed.flag] = v end,
    })
end

SeedsTab:CreateSection("Legendary Seeds")

for _, seed in pairs(legendSeedList) do
    SeedsTab:CreateToggle({
        Name = "Auto Buy " .. seed.name,
        CurrentValue = false,
        Flag = seed.flag,
        Callback = function(v) _G.BelleSG[seed.flag] = v end,
    })
end

SeedsTab:CreateButton({
    Name = "Enable All Seeds",
    Callback = function()
        for _, s in pairs(seedList) do _G.BelleSG[s.flag] = true end
        for _, s in pairs(raresSeedList) do _G.BelleSG[s.flag] = true end
        for _, s in pairs(legendSeedList) do _G.BelleSG[s.flag] = true end
        Rayfield:Notify({ Title = "Seeds", Content = "All seed auto-buy enabled!", Duration = 3 })
    end,
})

SeedsTab:CreateButton({
    Name = "Disable All Seeds",
    Callback = function()
        for _, s in pairs(seedList) do _G.BelleSG[s.flag] = false end
        for _, s in pairs(raresSeedList) do _G.BelleSG[s.flag] = false end
        for _, s in pairs(legendSeedList) do _G.BelleSG[s.flag] = false end
        Rayfield:Notify({ Title = "Seeds", Content = "All seed auto-buy disabled.", Duration = 3 })
    end,
})

-- ============================================================
-- 6. TAB: GEARS
-- ============================================================
local GearsTab = Window:CreateTab("⚙️ Gears", 4483362458)

GearsTab:CreateSection("Watering Cans")

local wateringList = {
    { name = "Common Watering Can",    flag = "AutoBuy_CommonWateringCan" },
    { name = "Uncommon Watering Can",  flag = "AutoBuy_UncommonWateringCan" },
    { name = "Rare Watering Can",      flag = "AutoBuy_RareWateringCan" },
    { name = "Legendary Watering Can", flag = "AutoBuy_LegendaryWateringCan" },
}

for _, gear in pairs(wateringList) do
    GearsTab:CreateToggle({
        Name = "Auto Buy " .. gear.name,
        CurrentValue = false,
        Flag = gear.flag,
        Callback = function(v) _G.BelleSG[gear.flag] = v end,
    })
end

GearsTab:CreateSection("Sprinklers")

local sprinklerList = {
    { name = "Common Sprinkler",   flag = "AutoBuy_CommonSprinkler" },
    { name = "Uncommon Sprinkler", flag = "AutoBuy_UncommonSprinkler" },
    { name = "Rare Sprinkler",     flag = "AutoBuy_RareSprinkler" },
    { name = "Master Sprinkler",   flag = "AutoBuy_MasterSprinkler" },
}

for _, gear in pairs(sprinklerList) do
    GearsTab:CreateToggle({
        Name = "Auto Buy " .. gear.name,
        CurrentValue = false,
        Flag = gear.flag,
        Callback = function(v) _G.BelleSG[gear.flag] = v end,
    })
end

GearsTab:CreateSection("Other Gears")

local otherGearList = {
    { name = "Jump Mushroom",  flag = "AutoBuy_JumpMushroom" },
    { name = "Speed Mushroom", flag = "AutoBuy_SpeedMushroom" },
    { name = "Gnome",          flag = "AutoBuy_Gnome" },
    { name = "Trowel",         flag = "AutoBuy_Trowel" },
}

for _, gear in pairs(otherGearList) do
    GearsTab:CreateToggle({
        Name = "Auto Buy " .. gear.name,
        CurrentValue = false,
        Flag = gear.flag,
        Callback = function(v) _G.BelleSG[gear.flag] = v end,
    })
end

GearsTab:CreateButton({
    Name = "Enable All Gears",
    Callback = function()
        for _, g in pairs(wateringList) do _G.BelleSG[g.flag] = true end
        for _, g in pairs(sprinklerList) do _G.BelleSG[g.flag] = true end
        for _, g in pairs(otherGearList) do _G.BelleSG[g.flag] = true end
        Rayfield:Notify({ Title = "Gears", Content = "All gear auto-buy enabled!", Duration = 3 })
    end,
})

GearsTab:CreateButton({
    Name = "Disable All Gears",
    Callback = function()
        for _, g in pairs(wateringList) do _G.BelleSG[g.flag] = false end
        for _, g in pairs(sprinklerList) do _G.BelleSG[g.flag] = false end
        for _, g in pairs(otherGearList) do _G.BelleSG[g.flag] = false end
        Rayfield:Notify({ Title = "Gears", Content = "All gear auto-buy disabled.", Duration = 3 })
    end,
})

-- ============================================================
-- 7. TAB: PROPS
-- ============================================================
local PropsTab = Window:CreateTab("🪵 Props", 4483362458)

PropsTab:CreateSection("Crates")

local propsList = {
    { name = "Ladder Crate",     flag = "AutoBuy_LadderCrate" },
    { name = "Bench Crate",      flag = "AutoBuy_BenchCrate" },
    { name = "Bear Trap Crate",  flag = "AutoBuy_BearTrapCrate" },
    { name = "Light Crate",      flag = "AutoBuy_LightCrate" },
    { name = "Bridge Crate",     flag = "AutoBuy_BridgeCrate" },
    { name = "Seesaw Crate",     flag = "AutoBuy_SeesawCrate" },
    { name = "Owner Door Crate", flag = "AutoBuy_OwnerDoorCrate" },
    { name = "Roleplay Crate",   flag = "AutoBuy_RoleplayCrate" },
    { name = "Fountain Crate",   flag = "AutoBuy_FountainCrate" },
    { name = "Treehouse Crate",  flag = "AutoBuy_TreehouseCrate" },
}

for _, prop in pairs(propsList) do
    PropsTab:CreateToggle({
        Name = "Auto Buy " .. prop.name,
        CurrentValue = false,
        Flag = prop.flag,
        Callback = function(v) _G.BelleSG[prop.flag] = v end,
    })
end

PropsTab:CreateButton({
    Name = "Enable All Props",
    Callback = function()
        for _, p in pairs(propsList) do _G.BelleSG[p.flag] = true end
        Rayfield:Notify({ Title = "Props", Content = "All props auto-buy enabled!", Duration = 3 })
    end,
})

PropsTab:CreateButton({
    Name = "Disable All Props",
    Callback = function()
        for _, p in pairs(propsList) do _G.BelleSG[p.flag] = false end
        Rayfield:Notify({ Title = "Props", Content = "All props auto-buy disabled.", Duration = 3 })
    end,
})

-- ============================================================
-- 8. UTILITY FUNCTIONS
-- ============================================================
local function getRootPart()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function teleportTo(cframe)
    local root = getRootPart()
    if root then root.CFrame = cframe; task.wait(0.3) end
end

local function getWallet()
    local stats = LocalPlayer:FindFirstChild("leaderstats")
    if stats then
        local money = stats:FindFirstChild("Coins") or stats:FindFirstChild("Cash") or stats:FindFirstChild("Sheckles") or stats:FindFirstChild("Money")
        if money then return money.Value end
    end
    return 0
end

local function checkInventoryFull()
    local isFull = false
    pcall(function()
        local stats = LocalPlayer:FindFirstChild("leaderstats")
        if stats then
            local current, max
            for _, child in pairs(stats:GetChildren()) do
                if child:IsA("IntValue") or child:IsA("NumberValue") then
                    local cName = string.lower(child.Name)
                    if cName == "maxinventory" or cName == "maxbag" or cName == "capacity" then max = child.Value
                    elseif cName == "inventory" or cName == "bag" or cName == "fruits" then current = child.Value end
                end
            end
            if current and max and max > 0 and current >= max then isFull = true end
        end
    end)
    return isFull
end

local function isNightTime()
    return Lighting.ClockTime >= 18 or Lighting.ClockTime <= 6
end

-- ── Try to buy item by name via proximity prompt or remote
local function tryBuyItem(itemName)
    local root = getRootPart()
    if not root then return end
    local nameLower = itemName:lower():gsub(" ", ""):gsub("_", "")
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local pName = (v.Parent and v.Parent.Name or ""):lower():gsub(" ", ""):gsub("_", "")
            local act   = v.ActionText:lower()
            if string.find(pName, nameLower) and (string.find(act, "buy") or string.find(act, "purchase") or string.find(act, "shop")) then
                root.CFrame = v.Parent.CFrame * CFrame.new(0, 2, 0)
                task.wait(0.3)
                fireproximityprompt(v)
                task.wait(0.5)
                return true
            end
        end
    end
    -- Try remote fallback
    local remote = ReplicatedStorage:FindFirstChild("BuyItem", true)
        or ReplicatedStorage:FindFirstChild("PurchaseItem", true)
        or ReplicatedStorage:FindFirstChild("BuySeed", true)
        or ReplicatedStorage:FindFirstChild("BuyGear", true)
    if remote then
        pcall(function() remote:FireServer(itemName) end)
        return true
    end
    return false
end

-- ============================================================
-- 9. CACHE SYSTEM
-- ============================================================
local sellPartCache    = nil
local harvestPrompts   = {}
local plantPrompts     = {}

task.spawn(function()
    while true do
        if _G.BelleSG.ThreadID ~= currentThread then break end
        pcall(function()
            if not sellPartCache then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and string.find(string.lower(obj.Name), "sell") then
                        sellPartCache = obj; break
                    end
                end
            end
            local tH, tP = {}, {}
            for _, p in pairs(Workspace:GetDescendants()) do
                if p:IsA("ProximityPrompt") then
                    local act   = string.lower(tostring(p.ActionText))
                    local pName = p.Parent and string.lower(p.Parent.Name) or ""
                    if (string.find(act, "harvest") or string.find(act, "take") or string.find(act, "pick") or string.find(pName, "fruit") or string.find(pName, "crop")) and not string.find(act, "talk") then
                        if p.Parent:IsA("BasePart") then table.insert(tH, p) end
                    elseif string.find(act, "plant") or string.find(act, "sow") then
                        if p.Parent:IsA("BasePart") then table.insert(tP, p) end
                    end
                end
            end
            harvestPrompts = tH
            plantPrompts   = tP
        end)
        task.wait(1.5)
    end
end)

-- ============================================================
-- 10. MAIN THREADS
-- ============================================================

-- THREAD A: Auto Harvest + Auto Buy & Plant
task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.BelleSG.ThreadID ~= currentThread then break end
        if not (_G.BelleSG.AutoHarvest or _G.BelleSG.AutoBuyPlant) then continue end

        local root = getRootPart()
        if not root then continue end

        if checkInventoryFull() and sellPartCache then
            local savedPos = root.CFrame
            root.CFrame = sellPartCache.CFrame * CFrame.new(0, 3, 0)
            task.wait(0.8)
            pcall(function()
                for _, p in pairs(Workspace:GetDescendants()) do
                    if p:IsA("ProximityPrompt") and (root.Position - p.Parent.Position).Magnitude < 25 then
                        fireproximityprompt(p); break
                    end
                end
            end)
            while checkInventoryFull() and _G.BelleSG.ThreadID == currentThread do task.wait(0.5) end
            root.CFrame = savedPos
            task.wait(0.5)
        else
            -- Auto Buy Seeds
            if _G.BelleSG.AutoBuyPlant then
                for _, seed in pairs(seedList) do
                    if _G.BelleSG[seed.flag] then
                        tryBuyItem(seed.name)
                        task.wait(0.3)
                    end
                end
                for _, seed in pairs(raresSeedList) do
                    if _G.BelleSG[seed.flag] then
                        tryBuyItem(seed.name)
                        task.wait(0.3)
                    end
                end
                for _, seed in pairs(legendSeedList) do
                    if _G.BelleSG[seed.flag] then
                        tryBuyItem(seed.name)
                        task.wait(0.3)
                    end
                end

                -- Auto Plant
                if _G.BelleSG.AutoPlantAfterBuy and #plantPrompts > 0 then
                    local activePlot = plantPrompts[1]
                    if activePlot and activePlot.Parent and activePlot.Parent:IsA("BasePart") then
                        root.CFrame = activePlot.Parent.CFrame * CFrame.new(0, 2, 0)
                        task.wait(0.3)
                        fireproximityprompt(activePlot)
                        task.wait(0.1)
                    end
                end
            end

            -- Auto Harvest
            if _G.BelleSG.AutoHarvest then
                for _, prompt in pairs(harvestPrompts) do
                    if not _G.BelleSG.AutoHarvest or checkInventoryFull() or _G.BelleSG.ThreadID ~= currentThread then break end
                    if #plantPrompts > 0 then break end
                    if prompt and prompt.Parent and prompt.Parent:IsA("BasePart") then
                        root.CFrame = prompt.Parent.CFrame * CFrame.new(0, 2, 0)
                        task.wait(0.3)
                        fireproximityprompt(prompt)
                        task.wait(0.1)
                    end
                end
            end
        end
    end
end)

-- THREAD B: Auto Buy Gears
task.spawn(function()
    while true do
        task.wait(5)
        if _G.BelleSG.ThreadID ~= currentThread then break end
        if not _G.BelleSG.AutoBuyPlant then continue end

        for _, gear in pairs(wateringList) do
            if _G.BelleSG[gear.flag] then tryBuyItem(gear.name); task.wait(0.5) end
        end
        for _, gear in pairs(sprinklerList) do
            if _G.BelleSG[gear.flag] then tryBuyItem(gear.name); task.wait(0.5) end
        end
        for _, gear in pairs(otherGearList) do
            if _G.BelleSG[gear.flag] then tryBuyItem(gear.name); task.wait(0.5) end
        end
    end
end)

-- THREAD C: Auto Buy Props
task.spawn(function()
    while true do
        task.wait(8)
        if _G.BelleSG.ThreadID ~= currentThread then break end
        if not _G.BelleSG.AutoBuyPlant then continue end

        for _, prop in pairs(propsList) do
            if _G.BelleSG[prop.flag] then tryBuyItem(prop.name); task.wait(0.5) end
        end
    end
end)

-- THREAD D: Auto Farm
task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.BelleSG.ThreadID ~= currentThread then break end
        if not _G.BelleSG.AutoFarm then continue end
        local root = getRootPart()
        if not root then continue end
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") and _G.BelleSG.AutoFarm then
                local n = string.lower(v.Parent.Name)
                if string.find(n, "fruit") or string.find(n, "harvest") or v.ObjectText == "Harvest" or v.ActionText == "Harvest" then
                    root.CFrame = v.Parent.CFrame * CFrame.new(0, 2, 0)
                    task.wait(0.2)
                    fireproximityprompt(v)
                    task.wait(0.1)
                end
            end
        end
    end
end)

-- THREAD E: Timed Auto Sell
task.spawn(function()
    while true do
        if _G.BelleSG.AutoFarm then
            task.wait(15)
            local root = getRootPart()
            if root then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if (obj:IsA("Part") or obj:IsA("MeshPart")) and string.find(string.lower(obj.Name), "sell") and _G.BelleSG.AutoFarm then
                        local savedPos = root.CFrame
                        root.CFrame = obj.CFrame
                        task.wait(1.5)
                        root.CFrame = savedPos
                        break
                    end
                end
            end
        else
            task.wait(1)
        end
        if _G.BelleSG.ThreadID ~= currentThread then break end
    end
end)

-- THREAD F: Auto Collect Fruits
task.spawn(function()
    while true do
        task.wait(0.4)
        if _G.BelleSG.ThreadID ~= currentThread then break end
        if not _G.BelleSG.AutoCollectFruits then continue end
        local root = getRootPart()
        if not root then continue end
        for _, item in pairs(Workspace:GetChildren()) do
            if item:IsA("Tool") or (item:IsA("Part") and item:FindFirstChild("TouchInterest")) then
                local name = string.lower(item.Name)
                if string.find(name, "fruit") or string.find(name, "apple") or string.find(name, "berry") or string.find(name, "seed") then
                    if item:IsA("Tool") and item:FindFirstChild("Handle") then
                        root.CFrame = item.Handle.CFrame
                    elseif item:IsA("Part") then
                        root.CFrame = item.CFrame
                    end
                    task.wait(0.3)
                end
            end
        end
    end
end)

-- THREAD G: Auto Steal Night Mode
task.spawn(function()
    while true do
        task.wait(1)
        if _G.BelleSG.ThreadID ~= currentThread then break end
        if not _G.BelleSG.AutoSteal then continue end
        if isNightTime() then
            local plots = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("Gardens")
            if plots then
                for _, plot in pairs(plots:GetChildren()) do
                    if plot.Name ~= LocalPlayer.Name and plot.Name ~= "Plot_"..LocalPlayer.Name then
                        for _, obj in pairs(plot:GetDescendants()) do
                            if obj:IsA("ProximityPrompt") and (obj.Parent.Name:lower():match("ready") or obj.Parent.Name:lower():match("crop") or obj.ActionText:lower():match("steal") or obj.ActionText:lower():match("harvest")) then
                                if obj.Parent:IsA("BasePart") then
                                    teleportTo(obj.Parent.CFrame * CFrame.new(0, 3, 0))
                                    task.wait(0.2)
                                    fireproximityprompt(obj)
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                end
            end
        else
            task.wait(5)
        end
    end
end)

-- THREAD H: Auto Buy Pet
task.spawn(function()
    while true do
        task.wait(2)
        if _G.BelleSG.ThreadID ~= currentThread then break end
        if not _G.BelleSG.AutoPet then continue end
        local wallet = getWallet()
        if wallet >= 50000 then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") and (string.find(string.lower(v.Parent.Name), "legendary") or string.find(string.lower(v.Parent.Name), "egg")) then
                    fireproximityprompt(v)
                end
            end
            local buyRemote = ReplicatedStorage:FindFirstChild("BuyPet", true) or ReplicatedStorage:FindFirstChild("PurchasePet", true)
            if buyRemote then pcall(function() buyRemote:FireServer("Legendary") end) end
        end
    end
end)

-- THREAD I: Anti-AFK
pcall(function()
    LocalPlayer.Idled:Connect(function()
        if _G.BelleSG.AntiAFK and _G.BelleSG.ThreadID == currentThread then
            VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
            task.wait(0.2)
            VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        end
    end)
end)

-- ============================================================
-- 11. NOTIFICATION
-- ============================================================
task.spawn(function()
    task.wait(1)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "BELLE.SG Loaded!",
            Text = "GAG2 Ultimate Edition | Rayfield UI",
            Duration = 5,
        })
    end)
end)

print("[BELLE.SG] GAG2 Rayfield script loaded!")
