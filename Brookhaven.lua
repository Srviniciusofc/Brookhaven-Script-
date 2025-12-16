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










--==================================================
-- SERVICES
--==================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--==================================================
-- VARIÁVEIS
--==================================================
getgenv().SelectedPlayer = nil
getgenv().LoopKill = false
local LoopConnection

--==================================================
-- FUNÇÃO: PEGAR PLAYERS
--==================================================
local function GetPlayersList()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(list, plr.Name)
        end
    end
    return list
end

--==================================================
-- FUNÇÃO: TENTAR MATAR (MULTI MÉTODOS)
--==================================================
local function KillPlayer(plr)
    if not plr or not plr.Character then return end

    local char = plr.Character
    local hum = char:FindFirstChildOfClass("Humanoid")

    if hum then
        pcall(function()
            hum.Health = 0
            hum:TakeDamage(9e9)
            hum.BreakJointsOnDeath = true
            hum:ChangeState(Enum.HumanoidStateType.Dead)
        end)
    end

    pcall(function()
        char:BreakJoints()
    end)
end

--==================================================
-- DROPDOWN
--==================================================
Tab:AddDropdown({
    Name = "Selecionar Player",
    Options = GetPlayersList(),
    Default = nil,
    Callback = function(Value)
        getgenv().SelectedPlayer = Players:FindFirstChild(Value)
        print("🎯 Player selecionado:", Value)
    end
})

--==================================================
-- TOGGLE LOOP KILL
--==================================================
Tab:AddToggle({
    Name = "Loop Kill",
    Default = false,
    Callback = function(state)
        getgenv().LoopKill = state

        if state then
            LoopConnection = RunService.Heartbeat:Connect(function()
                if getgenv().SelectedPlayer then
                    KillPlayer(getgenv().SelectedPlayer)
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

print("✅ Loop Kill agressivo carregado")
