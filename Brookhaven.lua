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
-- TELECINESE REAL (BROOKHAVEN)
-- FUNCIONA SEM SENTAR
-- SEGUE O DEDO
--==================================================

getgenv().TeleActive = getgenv().TeleActive or false
getgenv().TeleData = getgenv().TeleData or {}

Tab:AddButton({
    Name = "🧲 Telecinese (Carros)",
    Callback = function()

        local Players = game:GetService("Players")
        local UserInputService = game:GetService("UserInputService")

        local Player = Players.LocalPlayer
        local Camera = workspace.CurrentCamera
        local Data = getgenv().TeleData

        --==============================
        -- LIMPAR TUDO
        --==============================
        local function Clear()
            if Data.TouchSelect then Data.TouchSelect:Disconnect() end
            if Data.TouchMove then Data.TouchMove:Disconnect() end

            if Data.BodyPos then Data.BodyPos:Destroy() end
            if Data.BodyGyro then Data.BodyGyro:Destroy() end

            getgenv().TeleData = {}
        end

        --==============================
        -- INICIAR TELECINESE
        --==============================
        local function StartTelekinesis(car)
            local root = car.PrimaryPart or car:FindFirstChildWhichIsA("BasePart")
            if not root then return end

            Data.BodyPos = Instance.new("BodyPosition")
            Data.BodyPos.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            Data.BodyPos.P = 40000
            Data.BodyPos.D = 1500
            Data.BodyPos.Position = root.Position
            Data.BodyPos.Parent = root

            Data.BodyGyro = Instance.new("BodyGyro")
            Data.BodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            Data.BodyGyro.P = 30000
            Data.BodyGyro.CFrame = root.CFrame
            Data.BodyGyro.Parent = root
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

            -- TOCAR PARA SELECIONAR CARRO
            Data.TouchSelect = UserInputService.TouchTap:Connect(function(touches)
                if Data.Car then return end

                local touch = touches[1]
                local ray = Camera:ViewportPointToRay(touch.X, touch.Y)

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
            Data.TouchMove = UserInputService.TouchMoved:Connect(function(touch)
                if not Data.BodyPos then return end

                local ray = Camera:ViewportPointToRay(
                    touch.Position.X,
                    touch.Position.Y
                )

                Data.BodyPos.Position =
                    ray.Origin + ray.Direction * 14
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
