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
-- VARIÁVEIS GLOBAIS
--==================================================
getgenv().SelectedPlayer = nil
getgenv().LoopKill = false
local LoopConnection

--==================================================
-- FUNÇÃO: PEGAR LISTA DE PLAYERS
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
-- FUNÇÃO: MATAR PLAYER
--==================================================
local function KillPlayer(plr)
    if plr and plr.Character then
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            hum.Health = 0
        end
    end
end

--==================================================
-- DROPDOWN: SELECIONAR PLAYER
--==================================================
Tab:AddDropdown({
    Title = "Selecionar Player",
    Description = "Escolha o player para matar",
    Values = GetPlayersList(),
    Multi = false,
    Default = nil,
    Callback = function(value)
        getgenv().SelectedPlayer = Players:FindFirstChild(value)
        print("🎯 Player selecionado:", value)
    end
})

--==================================================
-- BOTÃO: ATUALIZAR LISTA
--==================================================
Tab:AddButton({
    Title = "Atualizar Lista de Players",
    Callback = function()
        Tab:ClearDropdown("Selecionar Player")
        Tab:AddDropdown({
            Title = "Selecionar Player",
            Description = "Escolha o player para matar",
            Values = GetPlayersList(),
            Multi = false,
            Default = nil,
            Callback = function(value)
                getgenv().SelectedPlayer = Players:FindFirstChild(value)
                print("🎯 Player selecionado:", value)
            end
        })
    end
})

--==================================================
-- TOGGLE: LOOP KILL
--==================================================
Tab:AddToggle({
    Title = "Loop Kill",
    Description = "Mata o player selecionado infinitamente",
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

print("✅ Script Loop Kill carregado com sucesso")
