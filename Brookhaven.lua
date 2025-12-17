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
    Name = "🧲 Telecinese (Carros)",
    Callback = function()

        --==============================
        -- SERVICES
        --==============================
        local Players = game:GetService("Players")
        local UserInputService = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")

        local Player = Players.LocalPlayer
        local Camera = workspace.CurrentCamera

        --==============================
        -- ESTADO
        --==============================
        local Active = false
        local SelectedCar = nil

        local AlignPos, AlignOri
        local CarAttach, TargetAttach
        local RenderConnection
        local TouchConnection

        --==============================
        -- LIMPAR
        --==============================
        local function Clear()
            if RenderConnection then
                RenderConnection:Disconnect()
                RenderConnection = nil
            end
            if TouchConnection then
                TouchConnection:Disconnect()
                TouchConnection = nil
            end

            if AlignPos then AlignPos:Destroy() end
            if AlignOri then AlignOri:Destroy() end
            if CarAttach then CarAttach:Destroy() end
            if TargetAttach then TargetAttach:Destroy() end

            AlignPos, AlignOri, CarAttach, TargetAttach = nil, nil, nil, nil
            SelectedCar = nil
        end

        --==============================
        -- INICIAR TELECINESE
        --==============================
        local function StartTelekinesis()
            if not SelectedCar then return end

            local root =
                SelectedCar.PrimaryPart
                or SelectedCar:FindFirstChildWhichIsA("BasePart")

            if not root then return end

            CarAttach = Instance.new("Attachment", root)
            TargetAttach = Instance.new("Attachment", workspace.Terrain)

            AlignPos = Instance.new("AlignPosition", root)
            AlignPos.Attachment0 = CarAttach
            AlignPos.Attachment1 = TargetAttach
            AlignPos.MaxForce = 300000
            AlignPos.Responsiveness = 70

            AlignOri = Instance.new("AlignOrientation", root)
            AlignOri.Attachment0 = CarAttach
            AlignOri.Attachment1 = TargetAttach
            AlignOri.MaxTorque = 300000
            AlignOri.Responsiveness = 70

            RenderConnection = RunService.RenderStepped:Connect(function()
                if not Active then return end

                local ray = Camera:ViewportPointToRay(
                    Camera.ViewportSize.X / 2,
                    Camera.ViewportSize.Y / 2
                )

                local pos = ray.Origin + ray.Direction * 12

                TargetAttach.WorldPosition = pos
                TargetAttach.WorldCFrame = CFrame.lookAt(
                    pos,
                    pos + ray.Direction
                )
            end)
        end

        --==============================
        -- SELECIONAR CARRO (TOQUE)
        --==============================
        TouchConnection = UserInputService.TouchTap:Connect(function(touches)
            if not Active then return end
            if SelectedCar then return end

            local pos = touches[1]
            local ray = Camera:ViewportPointToRay(pos.X, pos.Y)

            local params = RaycastParams.new()
            params.FilterDescendantsInstances = { Player.Character }
            params.FilterType = Enum.RaycastFilterType.Blacklist

            local result = workspace:Raycast(
                ray.Origin,
                ray.Direction * 500,
                params
            )

            if result and result.Instance then
                local model =
                    result.Instance:FindFirstAncestorOfClass("Model")

                if model
                    and workspace:FindFirstChild("Vehicles")
                    and model:IsDescendantOf(workspace.Vehicles)
                then
                    SelectedCar = model
                    StartTelekinesis()
                end
            end
        end)

        --==============================
        -- TOGGLE
        --==============================
        Active = not Active

        if Active then
            print("🧲 Telecinese ATIVADA — toque em um carro")
        else
            Clear()
            print("🛑 Telecinese DESATIVADA")
        end

    end
})
