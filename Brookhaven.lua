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
-- CAR FLY FINAL DEFINITIVO (SEM GIRAR COM CÂMERA)
--==================================================

getgenv().CarFlyActive = getgenv().CarFlyActive or false
getgenv().CarFlyData = getgenv().CarFlyData or {}

Tab:AddButton({
    Name = "🚗🪽 Car Fly",
    Callback = function()

        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local UIS = game:GetService("UserInputService")

        local Player = Players.LocalPlayer
        local Camera = workspace.CurrentCamera
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")

        local Data = getgenv().CarFlyData
        local Speed = 100
        local TurnSpeed = 2 -- velocidade de giro

        local Up = false
        local Down = false
        local Yaw = 0

        --==============================
        -- LIMPAR
        --==============================
        local function Clear()
            if Data.Render then Data.Render:Disconnect() end
            getgenv().CarFlyActive = false
            getgenv().CarFlyData = {}
        end

        --==============================
        -- PEGAR CARRO
        --==============================
        local function GetCar()
            if Humanoid.SeatPart and Humanoid.SeatPart:IsA("VehicleSeat") then
                local seat = Humanoid.SeatPart
                local car = seat:FindFirstAncestorOfClass("Model")
                if car then
                    local root = car.PrimaryPart or car:FindFirstChildWhichIsA("BasePart")
                    return seat, root
                end
            end
        end

        --==============================
        -- INPUT SUBIR / DESCER
        --==============================
        UIS.InputBegan:Connect(function(i,g)
            if g then return end
            if i.KeyCode == Enum.KeyCode.Space then Up = true end
            if i.KeyCode == Enum.KeyCode.LeftControl then Down = true end
        end)

        UIS.InputEnded:Connect(function(i,g)
            if i.KeyCode == Enum.KeyCode.Space then Up = false end
            if i.KeyCode == Enum.KeyCode.LeftControl then Down = false end
        end)

        --==============================
        -- TOGGLE
        --==============================
        if getgenv().CarFlyActive then
            Clear()
            Window:Notify({
                Title = "Car Fly",
                Content = "DESATIVADO",
                Duration = 3
            })
            return
        end

        local seat, root = GetCar()
        if not seat or not root then return end

        -- física local
        pcall(function()
            root:SetNetworkOwner(Player)
        end)

        -- yaw inicial baseado no carro (NÃO câmera)
        local look = root.CFrame.LookVector
        Yaw = math.atan2(look.X, look.Z)

        getgenv().CarFlyActive = true

        Window:Notify({
            Title = "Car Fly",
            Content = "ATIVADO",
            Duration = 3
        })

        --==============================
        -- LOOP FINAL CORRETO
        --==============================
        Data.Render = RunService.RenderStepped:Connect(function(dt)
            local throttle = seat.Throttle
            local steer = seat.Steer

            -- atualiza yaw APENAS pelo steer
            Yaw = Yaw - (steer * TurnSpeed * dt)

            local forward = Vector3.new(
                math.sin(Yaw),
                0,
                math.cos(Yaw)
            )

            local right = Vector3.new(
                forward.Z,
                0,
                -forward.X
            )

            local move = (forward * throttle) + (right * steer)

            -- eixo Y somente por input
            local yVel = 0
            if Up then yVel = Speed end
            if Down then yVel = -Speed end

            local velocity = Vector3.new(0, yVel, 0)

            if move.Magnitude > 0 then
                velocity = velocity + (move.Unit * Speed)
            end

            -- movimento duro
            root.AssemblyLinearVelocity = velocity
            root.AssemblyAngularVelocity = Vector3.zero

            -- trava rotação (SEM câmera)
            root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, Yaw, 0)
        end)
    end
})
