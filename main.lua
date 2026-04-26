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
