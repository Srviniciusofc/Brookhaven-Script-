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
-- CAR FLY - ANALÓGICO MOBILE (SEM ERRO)
--==================================================

getgenv().CarFlyActive = getgenv().CarFlyActive or false
getgenv().CarFlyData = getgenv().CarFlyData or {}

Tab:AddButton({
    Name = "🚗🪽 Car Fly (Analog)",
    Callback = function()

        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")

        local Player = Players.LocalPlayer
        local Camera = workspace.CurrentCamera
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")

        local Data = getgenv().CarFlyData
        local Speed = Data.Speed or 80

        --==============================
        -- LIMPAR
        --==============================
        local function Clear()
            if Data.Render then Data.Render:Disconnect() end
            if Data.BV then Data.BV:Destroy() end
            if Data.BG then Data.BG:Destroy() end
            if Data.Gui then Data.Gui:Destroy() end
            getgenv().CarFlyData = {}
        end

        --==============================
        -- PEGAR CARRO
        --==============================
        local function GetCarRoot()
            if Humanoid.SeatPart then
                local car = Humanoid.SeatPart:FindFirstAncestorOfClass("Model")
                if car then
                    return car.PrimaryPart or car:FindFirstChildWhichIsA("BasePart")
                end
            end
        end

        --==============================
        -- GUI SPEED (MINIMAL)
        --==============================
        local function CreateSpeedGui()
            local gui = Instance.new("ScreenGui")
            gui.Name = "CarFlySpeedGui"
            gui.ResetOnSpawn = false
            gui.Parent = Player:WaitForChild("PlayerGui")

            local frame = Instance.new("Frame", gui)
            frame.Size = UDim2.new(0, 120, 0, 70)
            frame.Position = UDim2.new(0.03, 0, 0.6, 0)
            frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
            frame.BackgroundTransparency = 0.15
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

            local plus = Instance.new("TextButton", frame)
            plus.Size = UDim2.new(0.45,0,0.45,0)
            plus.Position = UDim2.new(0.05,0,0.1,0)
            plus.Text = "+"
            plus.TextScaled = true
            plus.BackgroundColor3 = Color3.fromRGB(40,160,40)
            Instance.new("UICorner", plus).CornerRadius = UDim.new(0,8)

            local minus = Instance.new("TextButton", frame)
            minus.Size = UDim2.new(0.45,0,0.45,0)
            minus.Position = UDim2.new(0.5,0,0.1,0)
            minus.Text = "-"
            minus.TextScaled = true
            minus.BackgroundColor3 = Color3.fromRGB(160,50,50)
            Instance.new("UICorner", minus).CornerRadius = UDim.new(0,8)

            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(1,0,0.35,0)
            label.Position = UDim2.new(0,0,0.55,0)
            label.BackgroundTransparency = 1
            label.TextScaled = true
            label.TextColor3 = Color3.fromRGB(230,230,230)
            label.Text = "Speed: "..Speed

            plus.MouseButton1Click:Connect(function()
                Speed = Speed + 10
                label.Text = "Speed: "..Speed
            end)

            minus.MouseButton1Click:Connect(function()
                Speed = math.max(20, Speed - 10)
                label.Text = "Speed: "..Speed
            end)

            Data.Gui = gui
        end

        --==============================
        -- TOGGLE
        --==============================
        getgenv().CarFlyActive = not getgenv().CarFlyActive

        if getgenv().CarFlyActive then
            local root = GetCarRoot()
            if not root then
                getgenv().CarFlyActive = false
                return
            end

            -- BODY MOVERS
            Data.BV = Instance.new("BodyVelocity", root)
            Data.BV.MaxForce = Vector3.new(1e9,1e9,1e9)

            Data.BG = Instance.new("BodyGyro", root)
            Data.BG.MaxTorque = Vector3.new(1e9,1e9,1e9)
            Data.BG.P = 40000

            CreateSpeedGui()

            -- LOOP (ANALÓGICO REAL)
            Data.Render = RunService.RenderStepped:Connect(function()
                local moveDir = Humanoid.MoveDirection

                if moveDir.Magnitude > 0 then
                    Data.BV.Velocity = moveDir * Speed
                else
                    Data.BV.Velocity = Vector3.new(0,0,0)
                end

                Data.BG.CFrame = Camera.CFrame
            end)

            print("Car Fly Analógico ATIVADO")

        else
            Clear()
            print("Car Fly Analógico DESATIVADO")
        end
    end
})
