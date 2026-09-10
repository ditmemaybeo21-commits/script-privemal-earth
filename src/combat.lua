-- Combat Module - Auto Attack, Auto Aim, Auto Eat
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Config = _G.PEHub.Config

local Combat = {}
local AutoEat = {}

function Combat:GetTargets()
    local targets = {}
    for _, v in ipairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v ~= LocalPlayer.Character then
            local hum = v:FindFirstChild("Humanoid")
            local root = v:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and root then
                table.insert(targets, v)
            end
        end
    end
    return targets
end

function Combat:FindNearest()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local charPos = char.HumanoidRootPart.Position
    local nearest, nearestDist = nil, math.huge
    for _, target in ipairs(self:GetTargets()) do
        local root = target:FindFirstChild("HumanoidRootPart")
        if root then
            local dist = (root.Position - charPos).Magnitude
            if dist < nearestDist then
                nearest, nearestDist = target, dist
            end
        end
    end
    return nearest, nearestDist
end

function Combat:ExpandHitbox(target)
    if not target then return end
    local root = target:FindFirstChild("HumanoidRootPart")
    if root then
        root.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
        root.Transparency = 0.7
        root.CanCollide = false
        root.Massless = true
    end
end

function Combat:AutoAim(target)
    if not target then return end
    local root = target:FindFirstChild("HumanoidRootPart")
    if root and Workspace.CurrentCamera then
        Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, root.Position)
    end
end

function Combat:Attack(target)
    if not target then return end
    local root = target:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local dist = (root.Position - char.HumanoidRootPart.Position).Magnitude
    if dist > Config.AttackRange then
        char.HumanoidRootPart.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
        task.wait(0.03)
    end
    
    char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position, root.Position)
    
    for i = 1, 8 do
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(500, 400))
        VirtualUser:ClickButton1(Vector2.new(500, 400))
        task.wait(0.01)
    end
    
    pcall(function()
        for _, container in ipairs({ReplicatedStorage, char}) do
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("RemoteEvent") then
                    local n = child.Name:lower()
                    if n:find("attack") or n:find("damage") or n:find("hit") then
                        child:FireServer(root)
                        child:FireServer(target)
                    end
                end
            end
        end
    end)
    
    pcall(function()
        local tool = char:FindFirstChildWhichIsA("Tool")
        if tool then
            for i = 1, 5 do
                tool:Activate()
                task.wait(0.01)
            end
        end
    end)
end

function Combat:StartAutoAttack()
    task.spawn(function()
        while Config.AutoAttack do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local target = self:FindNearest()
                if target then
                    if Config.AutoAim then self:AutoAim(target) end
                    self:ExpandHitbox(target)
                    self:Attack(target)
                end
            end
            task.wait(Config.AttackSpeed)
        end
    end)
end

function AutoEat:FindFood()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local charPos = char.HumanoidRootPart.Position
    local nearest, nearestDist = nil, math.huge
    for _, v in ipairs(Workspace:GetChildren()) do
        local isFood = false
        local name = v.Name:lower()
        for _, kw in ipairs({"food", "meat", "berry", "fruit", "carcass", "corpse", "fish", "egg"}) do
            if name:find(kw) then isFood = true break end
        end
        if not isFood and v:IsA("Model") then
            local hum = v:FindFirstChild("Humanoid")
            if hum and hum.Health <= 0 then isFood = true end
        end
        if isFood then
            local root = v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") or v
            if root and root:IsA("BasePart") then
                local dist = (root.Position - charPos).Magnitude
                if dist < nearestDist and dist < Config.EatRange then
                    nearest, nearestDist = v, dist
                end
            end
        end
    end
    return nearest
end

function AutoEat:Eat(food)
    if not food then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local foodPart = food:IsA("Model") and food:FindFirstChild("HumanoidRootPart") or food
    if not foodPart or not foodPart:IsA("BasePart") then return end
    char.HumanoidRootPart.CFrame = CFrame.new(foodPart.Position + Vector3.new(0, 2, 0))
    task.wait(0.05)
    for _, container in ipairs({ReplicatedStorage, char}) do
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("RemoteEvent") and child.Name:lower():find("eat") then
                pcall(function() child:FireServer(food) end)
            end
        end
    end
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(500, 400))
end

function AutoEat:Start()
    task.spawn(function()
        while Config.AutoEat do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local food = self:FindFood()
                if food then
                    self:Eat(food)
                    task.wait(Config.AttackSpeed)
                else
                    task.wait(0.5)
                end
            end
            task.wait(0.1)
        end
    end)
end

_G.PEHub.Combat = Combat
_G.PEHub.AutoEat = AutoEat
return {Combat = Combat, AutoEat = AutoEat}
