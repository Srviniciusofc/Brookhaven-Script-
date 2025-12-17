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
-- CAR FLY FINAL (ESTÁVEL + ALTITUDE FIXA)
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
        local Speed = Data.Speed or 100
        local HoverY = nil
        local Up = false
        local Down = false

        --==============================
        -- LIMPAR
        --==============================
        local function Clear()
            if Data.Render then Data.Render:Disconnect() end
            if Data.Gui then Data.Gui:Destroy() end
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
        -- GUI SPEED
        --==============================
        local function CreateGui()
            local gui = Instance.new("ScreenGui", Player.PlayerGui)
            gui.ResetOnSpawn = false
            gui.Name = "CarFlyGui"

            local frame = Instance.new("Frame", gui)
            frame.Size = UDim2.new(0,160,0,90)
            frame.Position = UDim2.new(0.03,0,0.55,0)
            frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
            frame.Active = true
            frame.Draggable = true
            Instance.new("UICorner", frame)

            local title = Instance.new("TextLabel", frame)
            title.Size = UDim2.new(1,0,0.3,0)
            title.BackgroundTransparency = 1
            title.Text = "Car Fly"
            title.TextScaled = true
            title.TextColor3 = Color3.new(1,1,1)

            local plus = Instance.new("TextButton", frame)
            plus.Size = UDim2.new(0.45,0,0.3,0)
            plus.Position = UDim2.new(0.05,0,0.35,0)
            plus.Text = "+"
            plus.TextScaled = true

            local minus = Instance.new("TextButton", frame)
            minus.Size = UDim2.new(0.45,0,0.3,0)
            minus.Position = UDim2.new(0.5,0,0.35,0)
            minus.Text = "-"
            minus.TextScaled = true

            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(1,0,0.25,0)
            label.Position = UDim2.new(0,0,0.7,0)
            label.BackgroundTransparency = 1
            label.TextScaled = true
            label.TextColor3 = Color3.new(1,1,1)
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

        pcall(function()
            root:SetNetworkOwner(Player)
        end)

        HoverY = root.Position.Y
        getgenv().CarFlyActive = true

        Window:Notify({
            Title = "Car Fly",
            Content = "ATIVADO",
            Duration = 3
        })

        CreateGui()

        --==============================
        -- LOOP FINAL
        --==============================
        Data.Render = RunService.RenderStepped:Connect(function()
            local throttle = seat.Throttle
            local steer = seat.Steer

            local cam = Camera.CFrame
            local move =
                (cam.LookVector * throttle) +
                (cam.RightVector * steer)

            -- controle de altura
            if Up then HoverY = HoverY + 1 end
            if Down then HoverY = HoverY - 1 end

            local targetPos = Vector3.new(
                root.Position.X,
                HoverY,
                root.Position.Z
            )

            local velocity = (targetPos - root.Position) * 10

            if move.Magnitude > 0 then
                velocity = velocity + (move.Unit * Speed)
            end

            root.AssemblyLinearVelocity = velocity
            root.AssemblyAngularVelocity = Vector3.zero
        end)
    end
})
