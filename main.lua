repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- 🔗 LINKS
local KEY_URL = "https://raw.githubusercontent.com/mrizieqsugiharto-droid/Roblox-lua-script/main/keys.json"
local KEY_LINK = "https://pastebin.com/raw/XXPRyEAG"

-- 🔑 Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Cool Hub",
   LoadingTitle = "Cool Hub",
   LoadingSubtitle = "Key System",
   ConfigurationSaving = {Enabled = false}
})

local KeyTab = Window:CreateTab("Key", 4483362458)
local MainTab = Window:CreateTab("Main", 4483362458)

local enteredKey = ""
local unlocked = false

---------------------------------------------------
-- 🔗 GET KEY
---------------------------------------------------
KeyTab:CreateButton({
   Name = "Get Key",
   Callback = function()
      if setclipboard then
         setclipboard(KEY_LINK)
      end

      Rayfield:Notify({
         Title = "Cool Hub",
         Content = "Key link copied! Open browser.",
         Duration = 5
      })
   end
})

---------------------------------------------------
-- 🔑 INPUT
---------------------------------------------------
KeyTab:CreateInput({
   Name = "Enter Key",
   PlaceholderText = "Type your key...",
   Callback = function(Value)
      enteredKey = Value
   end
})

---------------------------------------------------
-- 🔐 CHECK KEY
---------------------------------------------------
local function checkKey(key)
    local success, response = pcall(function()
        return game:HttpGet(KEY_URL)
    end)

    if not success then return false, "API Error" end

    local data = HttpService:JSONDecode(response)
    local expireTime = data[key]

    if not expireTime then
        return false, "Invalid Key"
    end

    if os.time() > expireTime then
        return false, "Key Expired"
    end

    return true, "Valid"
end

---------------------------------------------------
-- 🔐 SUBMIT
---------------------------------------------------
KeyTab:CreateButton({
   Name = "Submit Key",
   Callback = function()
      local valid, message = checkKey(enteredKey)

      if valid then
         unlocked = true

         Rayfield:Notify({
            Title = "Access Granted",
            Content = "Welcome to Cool Hub 🔥",
            Duration = 3
         })
      else
         Rayfield:Notify({
            Title = "Access Denied",
            Content = message,
            Duration = 3
         })
      end
   end
})

---------------------------------------------------
-- 🚪 NOCLIP
---------------------------------------------------
local noclip = false

RunService.Stepped:Connect(function()
    if noclip and unlocked and character then
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
      if unlocked then
         noclip = Value
      end
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
      if unlocked then
         character:WaitForChild("Humanoid").WalkSpeed = Value
      end
   end
})

---------------------------------------------------
-- 💀 KILL PLAYER
---------------------------------------------------
MainTab:CreateButton({
   Name = "Kill / Reset",
   Callback = function()
      if unlocked then
         local humanoid = character:FindFirstChildOfClass("Humanoid")
         if humanoid then
            humanoid.Health = 0
         end
      end
   end
})

---------------------------------------------------
-- 🔁 REJOIN
---------------------------------------------------
MainTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
      if unlocked then
         TeleportService:Teleport(game.PlaceId, player)
      end
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
      if unlocked then
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
   end
})

---------------------------------------------------
-- 🔁 RESPAWN FIX
---------------------------------------------------
player.CharacterAdded:Connect(function(char)
    character = char
end)
