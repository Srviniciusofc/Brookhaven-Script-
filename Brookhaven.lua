local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()



local Window = Library:MakeWindow({
  Title = "Nice Hub : Cool Game",
  SubTitle = "dev by real_redz",
  ScriptFolder = "redz-library-V5"
})



local Minimizer = Window:NewMinimizer({
  KeyCode = Enum.KeyCode.LeftControl
})



local MobileButton = Minimizer:CreateMobileMinimizer({
  Image = "rbxassetid://0",
  BackgroundColor3 = Color3.fromRGB(0, 0, 0)
})



local Tab = Window:MakeTab({
  Title = "Cool Tab",
  Icon = "Home"
})

Tab:AddSection("Section")

-- 1️⃣ Teleporte por estilo
Tab:AddButton({
    Name = "Teleporte Mandrake",
    Description = "Teleporta para Mandrake se estiver com o estilo correto",
    Callback = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local workspace = game:GetService("Workspace")

        local estiloValue = Character:WaitForChild("Estilo", 5)
        if estiloValue and estiloValue:IsA("StringValue") then
            local estilo = estiloValue.Value
            if estilo == "MandrakeStyle" then
                local mandrake = workspace:FindFirstChild("Mandrake")
                if mandrake and mandrake:IsA("BasePart") then
                    local hrp = Character:WaitForChild("HumanoidRootPart")
                    hrp.CFrame = mandrake.CFrame + Vector3.new(0, 5, 0)
                    print("Teleportado para Mandrake!")
                else
                    warn("Mandrake não encontrado no workspace")
                end
            else
                print("Estilo diferente, não vai teleportar")
            end
        else
            warn("Objeto 'Estilo' não encontrado no personagem")
        end
    end
})

-- 2️⃣ Chat Spy / Enviar mensagens
Tab:AddButton({
    Name = "Chat Spy",
    Description = "Envia mensagens de verificação no chat",
    Callback = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local StarterGui = game:GetService("StarterGui")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local TextChatService = game:GetService("TextChatService")

        local function sendChatMessage(message)
            if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                local textChannel = TextChatService.TextChannels.RBXGeneral
                if textChannel then
                    textChannel:SendAsync(message)
                    return true
                else
                    return false
                end
            else
                local success, err = pcall(function()
                    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
                end)
                return success
            end
        end

        sendChatMessage("/Verify")
        wait(0.5)
        sendChatMessage("Coquette Hub")
    end
})

-- 3️⃣ Black Hole
Tab:AddButton({
    Name = "Black Hole",
    Description = "Puxa partes do workspace para você",
    Callback = function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer
        local Workspace = game:GetService("Workspace")

        local angle = 1
        local radius = 10
        local blackHoleActive = false

        local function setupPlayer()
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            local Folder = Instance.new("Folder", Workspace)
            local Part = Instance.new("Part", Folder)
            local Attachment1 = Instance.new("Attachment", Part)
            Part.Anchored = true
            Part.CanCollide = false
            Part.Transparency = 1
            return humanoidRootPart, Attachment1
        end

        local humanoidRootPart, Attachment1 = setupPlayer()

        local function ForcePart(v)
            if v:IsA("BasePart") and not v.Anchored and not v.Parent:FindFirstChildOfClass("Humanoid") then
                for _, x in next, v:GetChildren() do
                    if x:IsA("BodyMover") or x:IsA("RocketPropulsion") then
                        x:Destroy()
                    end
                end
                local Torque = Instance.new("Torque", v)
                Torque.Torque = Vector3.new(1000000, 1000000, 1000000)
                local AlignPosition = Instance.new("AlignPosition", v)
                local Attachment2 = Instance.new("Attachment", v)
                Torque.Attachment0 = Attachment2
                AlignPosition.MaxForce = math.huge
                AlignPosition.MaxVelocity = math.huge
                AlignPosition.Responsiveness = 500
                AlignPosition.Attachment0 = Attachment2
                AlignPosition.Attachment1 = Attachment1
            end
        end

        local function toggleBlackHole()
            blackHoleActive = not blackHoleActive
            if blackHoleActive then
                for _, v in next, Workspace:GetDescendants() do
                    ForcePart(v)
                end
                Workspace.DescendantAdded:Connect(function(v)
                    if blackHoleActive then
                        ForcePart(v)
                    end
                end)
                RunService.RenderStepped:Connect(function()
                    angle = angle + math.rad(2)
                    local offsetX = math.cos(angle) * radius
                    local offsetZ = math.sin(angle) * radius
                    Attachment1.WorldCFrame = humanoidRootPart.CFrame * CFrame.new(offsetX, 0, offsetZ)
                end)
            else
                Attachment1.WorldCFrame = CFrame.new(0, -1000, 0)
            end
        end

        toggleBlackHole()
    end
})

-- 4️⃣ Puxar Parts
Tab:AddButton({
    Name = "Bring Parts",
    Description = "Puxa partes de um jogador selecionado",
    Callback = function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer
        local Workspace = game:GetService("Workspace")

        local Folder = Instance.new("Folder", Workspace)
        local Part = Instance.new("Part", Folder)
        local Attachment1 = Instance.new("Attachment", Part)
        Part.Anchored = true
        Part.CanCollide = false
        Part.Transparency = 1

        if not getgenv().Network then
            getgenv().Network = { BaseParts = {}, Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424) }
            Network.RetainPart = function(Part)
                if Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
                    table.insert(Network.BaseParts, Part)
                    Part.CanCollide = false
                end
            end

            RunService.Heartbeat:Connect(function()
                sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
                for _, Part in pairs(Network.BaseParts) do
                    if Part:IsDescendantOf(Workspace) then
                        Part.Velocity = Network.Velocity
                    end
                end
            end)
        end

        local function ForcePart(v)
            if v:IsA("BasePart") and not v.Anchored and not v.Parent:FindFirstChildOfClass("Humanoid") then
                local Torque = Instance.new("Torque", v)
                Torque.Torque = Vector3.new(100000, 100000, 100000)
                local AlignPosition = Instance.new("AlignPosition", v)
                local Attachment2 = Instance.new("Attachment", v)
                Torque.Attachment0 = Attachment2
                AlignPosition.MaxForce = math.huge
                AlignPosition.MaxVelocity = math.huge
                AlignPosition.Responsiveness = 200
                AlignPosition.Attachment0 = Attachment2
                AlignPosition.Attachment1 = Attachment1
            end
        end
    end
})
