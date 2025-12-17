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










Tab:AddButton({
    Name = "🚗 Levitar Carro (Touch)",
    Callback = function()

        -- SERVICES
        local Players = game:GetService("Players")
        local UserInputService = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")

        local Player = Players.LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()

        local Flying = false
        local Speed = 70

        local BV, BG
        local Car
        local Touches = {}
        local FlyConnection

        --==============================
        -- PEGAR CARRO
        --==============================
        local function GetCar()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("VehicleSeat") and v.Occupant then
                    if v.Occupant.Parent == Character then
                        return v.Parent
                    end
                end
            end
        end

        --==============================
        -- START FLY
        --==============================
        local function StartFly(car)
            local root = car:FindFirstChildWhichIsA("BasePart")
            if not root then return end

            BV = Instance.new("BodyVelocity")
            BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            BV.Velocity = Vector3.zero
            BV.Parent = root

            BG = Instance.new("BodyGyro")
            BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            BG.P = 100000
            BG.Parent = root

            FlyConnection = RunService.RenderStepped:Connect(function()
                if not Flying then return end

                local cam = workspace.CurrentCamera
                BG.CFrame = cam.CFrame

                local move = Vector3.zero

                -- 1 dedo = mover
                if #Touches == 1 then
                    local delta = Touches[1].Delta
                    move = move + cam.CFrame.LookVector * (-delta.Y / 6)
                    move = move + cam.CFrame.RightVector * (delta.X / 6)
                end

                -- 2 dedos = subir/descer
                if #Touches >= 2 then
                    local delta = Touches[1].Delta
                    move = move + Vector3.new(0, -delta.Y / 4, 0)
                end

                BV.Velocity = move * Speed
            end)
        end

        --==============================
        -- STOP FLY
        --==============================
        local function StopFly()
            if FlyConnection then
                FlyConnection:Disconnect()
                FlyConnection = nil
            end
            if BV then BV:Destroy() BV = nil end
            if BG then BG:Destroy() BG = nil end
            Touches = {}
        end

        --==============================
        -- TOUCH INPUT
        --==============================
        UserInputService.TouchStarted:Connect(function(input)
            table.insert(Touches, {
                Input = input,
                Delta = Vector2.zero
            })
        end)

        UserInputService.TouchMoved:Connect(function(input)
            for _, t in pairs(Touches) do
                if t.Input == input then
                    t.Delta = input.Delta
                end
            end
        end)

        UserInputService.TouchEnded:Connect(function(input)
            for i, t in ipairs(Touches) do
                if t.Input == input then
                    table.remove(Touches, i)
                    break
                end
            end
        end)

        --==============================
        -- TOGGLE
        --==============================
        Flying = not Flying

        if Flying then
            Car = GetCar()
            if Car then
                StartFly(Car)
                print("🚗 Levitação ATIVADA")
            else
                Flying = false
                warn("❌ Entre em um carro primeiro")
            end
        else
            StopFly()
            print("🛑 Levitação DESATIVADA")
        end

    end
})
