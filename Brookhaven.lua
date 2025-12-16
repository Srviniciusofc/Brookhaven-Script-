local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()



 Window = Library:MakeWindow({
  Title = "Vini Hub : Brookhaven 🏡",
  SubTitle = "Vinicius",
  ScriptFolder = "redz-library-V5"
  })







local Minimizer = Window:NewMinimizer({
  KeyCode = Enum.KeyCode.LeftControl
})

local MobileButton = Minimizer:CreateMobileMinimizer({
  Image = "rbxassetid://0",
  BackgroundColor3 = Color3.fromRGB(98, 37, 209)
})



local Tab = Window:MakeTab({
  Title = "Main",
  Icon = "Home"
})



Tab:AddSection("Matar Players")


--==============================
-- LOOP KILL
--==============================
local RunService = game:GetService("RunService")
getgenv().LoopKill = false

local LoopConnection

Tab:AddToggle({
    Title = "Loop Kill Player",
    Description = "Mata o player selecionado infinitamente",
    Default = false,
    Callback = function(state)
        getgenv().LoopKill = state

        if state then
            LoopConnection = RunService.Heartbeat:Connect(function()
                local plr = getgenv().SelectedPlayer
                if plr and plr.Character then
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        hum.Health = 0
                    end
                end
            end)
        else
            if LoopConnection then
                LoopConnection:Disconnect()
                LoopConnection = nil
            end
        end
    end
})
