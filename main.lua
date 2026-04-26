repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local character
local humanoid

-- CHARACTER SETUP (RESPAWN SAFE)
local function setupCharacter(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
end

setupCharacter(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(setupCharacter)

-- UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Cool Hub",
   LoadingTitle = "Cool Hub",
   LoadingSubtitle = "Keyless",
   ConfigurationSaving = {Enabled = false}
})

local MainTab = Window:CreateTab("Main", 4483362458)

---------------------------------------------------
-- 🚪 NOCLIP
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
-- 🎚️ WALKSPEED
---------------------------------------------------
MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 100},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      if humanoid then
         humanoid.WalkSpeed = Value
      end
   end
})

---------------------------------------------------
-- 🦘 JUMP SYSTEM
---------------------------------------------------
MainTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 200},
   Increment = 5,
   CurrentValue = 50,
   Callback = function(Value)
      if humanoid then
         humanoid.UseJumpPower = true
         humanoid.JumpPower = Value
      end
   end
})

MainTab:CreateSlider({
   Name = "Jump Height",
   Range = {7, 100},
   Increment = 1,
   CurrentValue = 7,
   Callback = function(Value)
      if humanoid then
         humanoid.UseJumpPower = false
         humanoid.JumpHeight = Value
      end
   end
})

---------------------------------------------------
-- 💀 KILL PLAYER
---------------------------------------------------
MainTab:CreateButton({
   Name = "Kill / Reset",
   Callback = function()
      if humanoid then
         humanoid.Health = 0
      end
   end
})

---------------------------------------------------
-- 🔁 REJOIN
---------------------------------------------------
MainTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
      TeleportService:Teleport(game.PlaceId, player)
   end
})

---------------------------------------------------
-- 💰 MONEY
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
-- 👁️ ESP SYSTEM
---------------------------------------------------
local ESPEnabled = false

local function addESP(char)
    if char:FindFirstChild("CoolESP") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "CoolESP"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.Adornee = char
    highlight.Parent = char
end

local function enableESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            addESP(p.Character)
        end
    end
end

local function disableESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            local esp = p.Character:FindFirstChild("CoolESP")
            if esp then esp:Destroy() end
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        if ESPEnabled then
            addESP(char)
        end
    end)
end)

MainTab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Callback = function(Value)
      ESPEnabled = Value
      if Value then
         enableESP()
      else
         disableESP()
      end
   end
})
