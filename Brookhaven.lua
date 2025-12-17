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
-- CAR FLY ANALÓGICO - MOBILE (FINAL)
--==================================================

getgenv().CarFlyActive = getgenv().CarFlyActive or false
getgenv().CarFlyData = getgenv().CarFlyData or {}

Tab:AddButton({
    Name = "🚗🪽 Car Fly (Analog)",
    Callback = function()

        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")

        local Player = Players.LocalPlayer
        local Camera = workspace.CurrentCamera
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")

        local Data = getgenv().CarFlyData
        local Speed = Data.Speed or 80
        local FlyHeight = 35 -- 🔥 ALTURA DO VOO

        --==============================
        -- LIMPAR
        --==============================
        local function Clear()
            if Data.Render then Data.Render:Disconnect() end
            if Data.BV then Data.BV:Destroy() end
            if Data.BG then Data.BG:Destroy() end
            if Data.Gui then Data.Gui:Destroy() end
            getgenv().CarFlyData = {}
            getgenv().CarFlyActive = false
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
        -- GUI SPEED (ARRASTÁVEL)
        --==============================
        local function CreateGui()
            local gui = Instance.new("ScreenGui", Player.PlayerGui)
            gui.Name = "CarFlyGui"
            gui.ResetOnSpawn = false

            local frame = Instance.new("Frame", gui)
            frame.Size = UDim2.new(0, 150, 0, 95)
            frame.Position = UDim2.new(0.03, 0, 0.55, 0)
            frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
            frame.BackgroundTransparency = 0.1
            frame.Active = true
            frame.Draggable = true
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

            local title = Instance.new("TextLabel", frame)
            title.Size = UDim2.new(1, -50, 0, 25)
            title.Position = UDim2.new(0, 10, 0, 5)
            title.BackgroundTransparency = 1
            title.Text = "Car Fly"
            title.TextColor3 = Color3.new(1,1,1)
            title.TextXAlignment = Left

            local close = Instance.new("TextButton", frame)
            close.Size = UDim2.new(0, 20, 0, 20)
            close.Position = UDim2.new(1, -25, 0, 5)
            close.Text = "X"
            close.BackgroundColor3 = Color3.fromRGB(150,50,50)
            Instance.new("UICorner", close)

            local minimize = Instance.new("TextButton", frame)
            minimize.Size = UDim2.new(0, 20, 0, 20)
            minimize.Position = UDim2.new(1, -50, 0, 5)
            minimize.Text = "-"
            minimize.BackgroundColor3 = Color3.fromRGB(80,80,80)
            Instance.new("UICorner", minimize)

            local plus = Instance.new("TextButton", frame)
            plus.Size = UDim2.new(0.4, 0, 0, 30)
            plus.Position = UDim2.new(0.05, 0, 0.45, 0)
            plus.Text = "+"
            plus.TextScaled = true
            plus.BackgroundColor3 = Color3.fromRGB(40,160,40)
            Instance.new("UICorner", plus)

            local minus = Instance.new("TextButton", frame)
            minus.Size = UDim2.new(0.4, 0, 0, 30)
            minus.Position = UDim2.new(0.55, 0, 0.45, 0)
            minus.Text = "-"
            minus.TextScaled = true
            minus.BackgroundColor3 = Color3.fromRGB(160,50,50)
            Instance.new("UICorner", minus)

            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(1, 0, 0, 25)
            label.Position = UDim2.new(0, 0, 0.75, 0)
            label.BackgroundTransparency = 1
            label.Text = "Speed: "..Speed
            label.TextColor3 = Color3.new(1,1,1)

            plus.MouseButton1Click:Connect(function()
                Speed = Speed + 10
                label.Text = "Speed: "..Speed
            end)

            minus.MouseButton1Click:Connect(function()
                Speed = math.max(20, Speed - 10)
                label.Text = "Speed: "..Speed
            end)

            minimize.MouseButton1Click:Connect(function()
                frame.Size = frame.Size.Y.Offset > 30
                    and UDim2.new(0,150,0,30)
                    or UDim2.new(0,150,0,95)
            end)

            close.MouseButton1Click:Connect(function()
                Clear()
                Window:Notify({
                    Title = "Car Fly",
                    Content = "Car Fly DESATIVADO",
                    Duration = 3
                })
            end)

            Data.Gui = gui
        end

        --==============================
        -- TOGGLE
        --==============================
        if getgenv().CarFlyActive then
            Clear()
            Window:Notify({
                Title = "Car Fly",
                Content = "Car Fly DESATIVADO",
                Duration = 3
            })
            return
        end

        local root = GetCarRoot()
        if not root then return end

        getgenv().CarFlyActive = true

        Window:Notify({
            Title = "Car Fly",
            Content = "Car Fly ATIVADO",
            Duration = 3
        })

        Data.BV = Instance.new("BodyVelocity", root)
        Data.BV.MaxForce = Vector3.new(1e9,1e9,1e9)

        Data.BG = Instance.new("BodyGyro", root)
        Data.BG.MaxTorque = Vector3.new(1e9,1e9,1e9)
        Data.BG.P = 40000

        CreateGui()

        --==============================
        -- LOOP
        --==============================
        Data.Render = RunService.RenderStepped:Connect(function()
            local move = Humanoid.MoveDirection

            if move.Magnitude > 0 then
                Data.BV.Velocity = (move * Speed) + Vector3.new(0, FlyHeight, 0)
            else
                Data.BV.Velocity = Vector3.new(0, FlyHeight, 0)
            end

            Data.BG.CFrame = Camera.CFrame
        end)
    end
})
