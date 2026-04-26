repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

---------------------------------------------------
-- 📊 PREDICTOR CORE (ADDED)
---------------------------------------------------
local predictorEnabled = false
local ArrowsFolder = Workspace:WaitForChild("ArrowsFolder")

local PlayerGui = player:WaitForChild("PlayerGui")
local PowerGui = PlayerGui:WaitForChild("Power")
local PowerText = PowerGui.BarFrame.TopFrame.PowerTextFrame.PowerText

local predictor = Instance.new("Part")
predictor.Anchored = true
predictor.CanCollide = false
predictor.Shape = Enum.PartType.Cylinder
predictor.Material = Enum.Material.Neon
predictor.Color = Color3.fromRGB(0,255,140)
predictor.Size = Vector3.new(2,0.2,2)
predictor.Transparency = 1
predictor.Parent = Workspace

local a0 = Instance.new("Attachment", Workspace.Terrain)
local a1 = Instance.new("Attachment", Workspace.Terrain)

local beam = Instance.new("Beam")
beam.Attachment0 = a0
beam.Attachment1 = a1
beam.Width0 = 0.25
beam.Width1 = 0.1
beam.Color = ColorSequence.new(Color3.fromRGB(255,60,60))
beam.LightEmission = 1
beam.FaceCamera = true
beam.Enabled = false
beam.Parent = Workspace

local data = {
    ["Power 1"] = 0.846, ["Power 2"] = 1.2449, ["Power 3"] = 1.628,
    ["Power 4"] = 2.04, ["Power 5"] = 2.403, ["Power 6"] = 2.77,
    ["Power 7"] = 3.152, ["Power 8"] = 3.534, ["Power 9"] = 3.916,
    ["Power 10"] = 4.298,
}

local smoothPos = Vector3.new()

RunService.RenderStepped:Connect(function()
    if not predictorEnabled then
        predictor.Transparency = 1
        beam.Enabled = false
        return
    end

    local arrow = ArrowsFolder:FindFirstChild("LocalAimArrow")
    if not arrow then return end

    local power = data[PowerText.Text]
    if not power then return end

    beam.Enabled = true
    predictor.Transparency = 0

    local arrowLength = arrow.Size.X
    local targetPos = (arrow.CFrame * CFrame.new(arrowLength * power, 0, 0)).Position

    smoothPos = smoothPos:Lerp(targetPos, 0.25)

    predictor.Position = smoothPos
    predictor.Orientation = Vector3.new(90,0,0)

    a0.WorldPosition = arrow.Position
    a1.WorldPosition = smoothPos
end)

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
local VisualTab = Window:CreateTab("Visual", 4483362458)
local Knockouttabs = Window:CreateTab("Knockout tabs", 4483362458)

---------------------------------------------------
-- 🎯 PREDICTOR BUTTON (ADDED HERE)
---------------------------------------------------
Knockouttabs:CreateToggle({
    Name = "🎯 Prediction System",
    CurrentValue = false,
    Callback = function(Value)
        predictorEnabled = Value

        Rayfield:Notify({
            Title = "Prediction",
            Content = Value and "Enabled" or "Disabled",
            Duration = 2
        })
    end
})

---------------------------------------------------
-- (REST OF YOUR SCRIPT UNCHANGED)
---------------------------------------------------
-- 🚪 NOCLIP
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

-- WALK SPEED
MainTab:CreateSlider({
Name = "WalkSpeed",
Range = {16, 100},
Increment = 1,
CurrentValue = 16,
Callback = function(Value)
humanoid.WalkSpeed = Value
end
})

-- JUMP POWER
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

-- FLY
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
if flying then startFly() else stopFly() end
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
