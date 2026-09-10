-- Farming Module - Fossil Auto Farm
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Config = _G.PEHub.Config

local Farming = {}

function Farming:FindFossil()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local charPos = char.HumanoidRootPart.Position
    local nearest, nearestDist = nil, math.huge
    for _, v in ipairs(Workspace:GetChildren()) do
        local name = v.Name:lower()
        if name:find("fossil") or name:find("bone") or name:find("dig") then
            local root = v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") or v
            if root and root:IsA("BasePart") then
                local dist = (root.Position - charPos).Magnitude
                if dist < nearestDist and dist < Config.FossilRange then
                    nearest, nearestDist = v, dist
                end
            end
        end
    end
    return nearest
end

function Farming:CollectFossil(fossil)
    if not fossil then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = fossil:IsA("Model") and fossil:FindFirstChild("HumanoidRootPart") or fossil
    if not root or not root:IsA("BasePart") then return end
    
    char.HumanoidRootPart.CFrame = CFrame.new(root.Position + Vector3.new(0, 2, 0))
    task.wait(0.05)
    
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(500, 400))
    
    pcall(function()
        if root:FindFirstChild("TouchInterest") then
            root.TouchInterest:Fire(char)
        end
    end)
end

function Farming:StartFossilFarm()
    task.spawn(function()
        while Config.FossilFarm do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local fossil = self:FindFossil()
                if fossil then
                    self:CollectFossil(fossil)
                    task.wait(0.3)
                else
                    task.wait(1)
                end
            end
            task.wait(0.1)
        end
    end)
end

_G.PEHub.Farming = Farming
return Farming
