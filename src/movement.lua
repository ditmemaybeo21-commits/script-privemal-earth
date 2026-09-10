-- Movement Module - Speed, Jump, Fly, Noclip
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Config = _G.PEHub.Config

local Movement = {}

function Movement:StartSpeedLoop()
    task.spawn(function()
        while task.wait(0.1) do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                if Config.SpeedEnabled then
                    char.Humanoid.WalkSpeed = Config.WalkSpeed
                end
                if Config.JumpEnabled then
                    char.Humanoid.JumpPower = Config.JumpPower
                end
                if Config.WaterWalk then
                    pcall(function()
                        if char.Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
                            char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                            char.Humanoid.WalkSpeed = Config.WalkSpeed
                        end
                    end)
                end
            end
        end
    end)
end

function Movement:ToggleFly(state)
    Config.FlyEnabled = state
    if state then
        task.spawn(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            if hrp and hum then
                hum.PlatformStand = true
                while Config.FlyEnabled do
                    local move = Vector3.new(0, 0, 0)
                    local cam = Workspace.CurrentCamera
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
                    hrp.Velocity = move * Config.FlySpeed
                    task.wait(0.05)
                end
                hum.PlatformStand = false
            end
        end)
    end
end

function Movement:ToggleNoclip(state)
    Config.Noclip = state
    task.spawn(function()
        while Config.Noclip do
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
            task.wait(0.2)
        end
    end)
end

Movement:StartSpeedLoop()
_G.PEHub.Movement = Movement
return Movement
