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



Tab:AddSection("Soares Gay")










--==================================================
-- TELECINESE REAL (CORRIGIDA)
--==================================================

getgenv().TeleActive = getgenv().TeleActive or false
getgenv().TeleData = getgenv().TeleData or {}

Tab:AddButton({
    Name = "🧲 Telecinese (Carros)",
    Callback = function()

        local Players = game:GetService("Players")
        local UIS = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")

        local Player = Players.LocalPlayer
        local Camera = workspace.CurrentCamera
        local Data = getgenv().TeleData

        --==============================
        -- LIMPAR TUDO
        --==============================
        local function Clear()
            if Data.TouchSelect then Data.TouchSelect:Disconnect() end
            if Data.TouchMove then Data.TouchMove:Disconnect() end

            if Data.AlignPos then Data.AlignPos:Destroy() end
            if Data.AlignOri then Data.AlignOri:Destroy() end
            if Data.CarAttach then Data.CarAttach:Destroy() end
            if Data.TargetAttach then Data.TargetAttach:Destroy() end

            getgenv().TeleData = {}
        end

        --==============================
        -- INICIAR TELECINESE
        --==============================
        local function StartTelekinesis(car)
            local root = car.PrimaryPart or car:FindFirstChildWhichIsA("BasePart")
            if not root then return end

            -- 🔥 ISSO É O QUE FAZ FUNCIONAR SEM SENTAR
            pcall(function()
                root:SetNetworkOwner(Player)
            end)

            Data.CarAttach = Instance.new("Attachment", root)
            Data.TargetAttach = Instance.new("Attachment", workspace.Terrain)

            Data.AlignPos = Instance.new("AlignPosition", root)
            Data.AlignPos.Attachment0 = Data.CarAttach
            Data.AlignPos.Attachment1 = Data.TargetAttach
            Data.AlignPos.MaxForce = 500000
            Data.AlignPos.Responsiveness = 90

            Data.AlignOri = Instance.new("AlignOrientation", root)
            Data.AlignOri.Attachment0 = Data.CarAttach
            Data.AlignOri.Attachment1 = Data.TargetAttach
            Data.AlignOri.MaxTorque = 500000
            Data.AlignOri.Responsiveness = 90
        end

        --==============================
        -- TOGGLE
        --==============================
        getgenv().TeleActive = not getgenv().TeleActive

        if getgenv().TeleActive then
            Window:Notify({
                Title = "🧲 Telecinese",
                Content = "ATIVADA\nToque e arraste um carro",
                Image = "rbxassetid://10734953451",
                Duration = 4
            })

            -- TOCAR PRA SELECIONAR
            Data.TouchSelect = UIS.TouchTap:Connect(function(touches)
                if Data.Car then return end

                local p = touches[1]
                local ray = Camera:ViewportPointToRay(p.X, p.Y)

                local params = RaycastParams.new()
                params.FilterDescendantsInstances = { Player.Character }
                params.FilterType = Enum.RaycastFilterType.Blacklist

                local result = workspace:Raycast(ray.Origin, ray.Direction * 500, params)
                if result and result.Instance then
                    local model = result.Instance:FindFirstAncestorOfClass("Model")
                    if model
                        and workspace:FindFirstChild("Vehicles")
                        and model:IsDescendantOf(workspace.Vehicles) then

                        Data.Car = model
                        StartTelekinesis(model)
                    end
                end
            end)

            -- ARRASTAR COM O DEDO
            Data.TouchMove = UIS.TouchMoved:Connect(function(touch)
                if not Data.TargetAttach then return end

                local ray = Camera:ViewportPointToRay(
                    touch.Position.X,
                    touch.Position.Y
                )

                Data.TargetAttach.WorldPosition =
                    ray.Origin + ray.Direction * 15
            end)

        else
            Clear()

            Window:Notify({
                Title = "🧲 Telecinese",
                Content = "DESATIVADA",
                Image = "rbxassetid://10734953451",
                Duration = 3
            })
        end
    end
})
