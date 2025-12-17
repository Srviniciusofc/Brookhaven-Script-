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
-- CAR FLY ULTRA ESTÁVEL (SEM MOLENGO REAL)
--==================================================

getgenv().CarFlyActive = getgenv().CarFlyActive or false
getgenv().CarFlyData = getgenv().CarFlyData or {}

Tab:AddButton({
    Name = "🚗🪽 Car Fly (Ultra Stable)",
    Callback = function()

        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")

        local Player = Players.LocalPlayer
        local Camera = workspace.CurrentCamera
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")

        local Data = getgenv().CarFlyData
        local Speed = 100
        local Lift = 50

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

        -- ⚠️ MUITO IMPORTANTE
        pcall(function()
            root:SetNetworkOwner(Player)
        end)

        getgenv().CarFlyActive = true

        Window:Notify({
            Title = "Car Fly",
            Content = "ATIVADO",
            Duration = 3
        })

        --==============================
        -- LOOP DURO (SEM FÍSICA ELÁSTICA)
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

            -- MOVIMENTO DIRETO (SEM MOLENGO)
            root.AssemblyLinearVelocity = velocity

            -- REMOVE QUALQUER BALANÇO / GIRO
            root.AssemblyAngularVelocity = Vector3.zero
        end)
    end
})
