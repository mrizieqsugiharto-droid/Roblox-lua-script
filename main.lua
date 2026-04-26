repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

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
      character:WaitForChild("Humanoid").WalkSpeed = Value
   end
})

---------------------------------------------------
-- 🦘 JUMP POWER
---------------------------------------------------
local humanoid = character:WaitForChild("Humanoid")

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
-- 🕊️ CAMERA FLY (NO PIECES)
---------------------------------------------------
local flying = false
local flySpeed = 2
local camera = workspace.CurrentCamera

RunService.RenderStepped:Connect(function()
    if flying and character then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = root.CFrame + (camera.CFrame.LookVector * flySpeed)
        end
    end
end)

MainTab:CreateToggle({
   Name = "Camera Fly",
   CurrentValue = false,
   Callback = function(Value)
      flying = Value
   end
})

MainTab:CreateSlider({
   Name = "Fly Speed",
   Range = {1, 10},
   Increment = 1,
   CurrentValue = 2,
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
      local humanoid = character:FindFirstChildOfClass("Humanoid")
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
end)
