repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

---------------------------------------------------
-- UI
---------------------------------------------------
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Cool Hub",
   LoadingTitle = "Cool Hub",
   LoadingSubtitle = "Keyless",
   ConfigurationSaving = {Enabled = false}
})
---------------------------------------------------
-- 👁️ ESP SYSTEM
---------------------------------------------------

local ESPEnabled = false
local ESPObjects = {}
local MainTab = Window:CreateTab("Main", 4483362458)
---------------------------------------------------
-- 🎨 VISUAL TAB
---------------------------------------------------
local function createESP(plr)
    if plr == player then return end

    local function apply(char)
        if not ESPEnabled then return end

        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.Parent = char

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Name"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = char:FindFirstChild("Head") or char

        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.TextScaled = true
        text.TextColor3 = Color3.fromRGB(255, 255, 255)
        text.TextStrokeTransparency = 0
        text.Text = plr.Name
        text.Parent = billboard

        ESPObjects[plr] = {highlight, billboard}
    end

    if plr.Character then
        apply(plr.Character)
    end

    plr.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        apply(char)
    end)
end
local VisualTab = Window:CreateTab("Visual", 4483362458)
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
      humanoid.WalkSpeed = Value
   end
})

---------------------------------------------------
-- 🦘 JUMP POWER
---------------------------------------------------
MainTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 200},
   Increment = 5,
   CurrentValue = humanoid.JumpPower,
   Callback = function(Value)
      humanoid.UseJumpPower = true
      humanoid.JumpPower = Value
   end
})

---------------------------------------------------
-- 🕊️ BODYVELOCITY FLY (MIXED)
---------------------------------------------------
local flying = false
local flySpeed = 60
local camera = workspace.CurrentCamera
local bv

local function startFly()
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if bv then bv:Destroy() end

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bv.Velocity = Vector3.zero
    bv.Parent = root
end

local function stopFly()
    if bv then
        bv:Destroy()
        bv = nil
    end
end

RunService.RenderStepped:Connect(function()
    if flying and character and bv then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            bv.Velocity = camera.CFrame.LookVector * flySpeed
        end
    end
end)

MainTab:CreateToggle({
   Name = "BodyVelocity Fly",
   CurrentValue = false,
   Callback = function(Value)
      flying = Value
      if flying then
         startFly()
      else
         stopFly()
      end
   end
})

MainTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 200},
   Increment = 5,
   CurrentValue = flySpeed,
   Callback = function(Value)
      flySpeed = Value
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
-- 🔁 RESPAWN FIX
---------------------------------------------------
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")

    task.wait(0.5)

    if flying then
        local root = character:WaitForChild("HumanoidRootPart")

        if bv then bv:Destroy() end

        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.zero
        bv.Parent = root
    end
end)
---------------------------------------------------
-- 🌟 BRIGHT MODE TOGGLE
---------------------------------------------------

local function setBright(state)
    if state then
        game.Lighting.Brightness = 3
        game.Lighting.ClockTime = 14
        game.Lighting.FogEnd = 100000

        Rayfield:Notify({
            Title = "Visual",
            Content = "Bright Mode Enabled 🌟",
            Duration = 2
        })
    else
        game.Lighting.Brightness = 2
        game.Lighting.ClockTime = 12
        game.Lighting.FogEnd = 1000

        Rayfield:Notify({
            Title = "Visual",
            Content = "Bright Mode Disabled 🌙",
            Duration = 2
        })
    end
end

VisualTab:CreateToggle({
   Name = "🌟 Bright Mode",
   CurrentValue = false,
   Callback = function(Value)
      setBright(Value)
   end
})
local function setESP(state)
    ESPEnabled = state

    if state then
        for _, plr in pairs(Players:GetPlayers()) do
            createESP(plr)
        end
    else
        for _, obj in pairs(ESPObjects) do
            for _, v in pairs(obj) do
                if v then v:Destroy() end
            end
        end
        ESPObjects = {}
    end
end
Players.PlayerAdded:Connect(function(plr)
    createESP(plr)
end)
VisualTab:CreateToggle({
   Name = "👁️ ESP Players",
   CurrentValue = false,
   Callback = function(Value)
      setESP(Value)
   end
})
