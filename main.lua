repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Load UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Cool Hub",
   LoadingTitle = "Cool Hub",
   LoadingSubtitle = "Keyless",
   ConfigurationSaving = {Enabled = false}
})

local MainTab = Window:CreateTab("Main", 4483362458)

---------------------------------------------------
-- NOCLIP
---------------------------------------------------
local noclip = false

RunService.Stepped:Connect(function()
    if noclip and character then
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value)
      noclip = Value
   end
})

---------------------------------------------------
-- WALKSPEED
---------------------------------------------------
MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 100},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      character:WaitForChild("Humanoid").WalkSpeed = Value
   end
})

---------------------------------------------------
-- KILL PLAYER
---------------------------------------------------
MainTab:CreateButton({
   Name = "Kill / Reset",
   Callback = function()
      local humanoid = character:FindFirstChildOfClass("Humanoid")
      if humanoid then
         humanoid.Health = 0
      end
   end
})

---------------------------------------------------
-- REJOIN
---------------------------------------------------
MainTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
      TeleportService:Teleport(game.PlaceId, player)
   end
})

---------------------------------------------------
-- MONEY
---------------------------------------------------
local function getStat(name)
    local stats = player:FindFirstChild("leaderstats")
    if stats then
        return stats:FindFirstChild(name)
    end
end

MainTab:CreateInput({
   Name = "Set Money",
   PlaceholderText = "Enter amount...",
   Callback = function(Value)
      local money = getStat("Money") or getStat("Cash")

      if money and tonumber(Value) then
         money.Value = tonumber(Value)

         Rayfield:Notify({
            Title = "Money Updated",
            Content = Value,
            Duration = 3
         })
      end
   end
})

---------------------------------------------------
-- RESPAWN FIX
---------------------------------------------------
player.CharacterAdded:Connect(function(char)
    character = char
end)
---------------------------------------------------
-- 👁️ ESP SYSTEM
---------------------------------------------------
local ESPEnabled = false
local ESPObjects = {}

local function createESP(player)
    if player == Players.LocalPlayer then return end

    local function add(char)
        local highlight = Instance.new("Highlight")
        highlight.Name = "CoolESP"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Adornee = char
        highlight.Parent = char

        ESPObjects[player] = highlight
    end

    if player.Character then
        add(player.Character)
    end

    player.CharacterAdded:Connect(function(char)
        if ESPEnabled then
            add(char)
        end
    end)
end

local function enableESP()
    for _, p in pairs(Players:GetPlayers()) do
        createESP(p)
    end
end

local function disableESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            local esp = p.Character:FindFirstChild("CoolESP")
            if esp then
                esp:Destroy()
            end
        end
    end
    ESPObjects = {}
end

Players.PlayerAdded:Connect(function(p)
    if ESPEnabled then
        createESP(p)
    end
end)

---------------------------------------------------
-- 🔘 ESP TOGGLE
---------------------------------------------------
MainTab:CreateToggle({
   Name = "ESP (See Players)",
   CurrentValue = false,
   Callback = function(Value)
      ESPEnabled = Value

      if ESPEnabled then
         enableESP()
      else
         disableESP()
      end
   end
})
