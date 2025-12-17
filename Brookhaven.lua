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
-- CAR FLY RÍGIDO (SEM MOLENGO / SEM +=)
--==================================================

getgenv().CarFlyActive = getgenv().CarFlyActive or false
getgenv().CarFlyData = getgenv().CarFlyData or {}

Tab:AddButton({
    Name = "🚗🪽 Car Fly (Estável)",
    Callback = function()

        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")

        local Player = Players.LocalPlayer
        local Camera = workspace.CurrentCamera
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")

        local Data = getgenv().CarFlyData
        local Speed = Data.Speed or 90
        local Lift = 45

        --==============================
        -- LIMPAR
        --==============================
        local function Clear()
            if Data.Render then Data.Render:Disconnect() end
            if Data.Linear then Data.Linear:Destroy() end
            if Data.Align then Data.Align:Destroy() end
            if Data.Attach then Data.Attach:Destroy() end
            if Data.Gui then Data.Gui:Destroy() end
            getgenv().CarFlyData = {}
            getgenv().CarFlyActive = false
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

        getgenv().CarFlyActive = true

        Window:Notify({
            Title = "Car Fly",
            Content = "ATIVADO",
            Duration = 3
        })

        --==============================
        -- FÍSICA RÍGIDA
        --==============================
        local attach = Instance.new("Attachment")
        attach.Parent = root
        Data.Attach = attach

        local linear = Instance.new("LinearVelocity")
        linear.Attachment0 = attach
        linear.MaxForce = math.huge
        linear.RelativeTo = Enum.ActuatorRelativeTo.World
        linear.Parent = root
        Data.Linear = linear

        local align = Instance.new("AlignOrientation")
        align.Attachment0 = attach
        align.MaxTorque = math.huge
        align.Responsiveness = 200
        align.RigidityEnabled = true
        align.Parent = root
        Data.Align = align

        --==============================
        -- LOOP (CONTROLE FIRME)
        --==============================
        Data.Render = RunService.RenderStepped:Connect(function()
            local throttle = seat.Throttle
            local steer = seat.Steer

            local cam = Camera.CFrame
            local move =
                (cam.LookVector * throttle) +
                (cam.RightVector * steer)

            local velocity = Vector3.new(0, Lift, 0)

            if move.Magnitude > 0 then
                velocity = velocity + (move.Unit * Speed)
            end

            linear.VectorVelocity = velocity

            -- mantém o carro reto
            align.CFrame = CFrame.new(root.Position, root.Position + cam.LookVector)
        end)
    end
})
