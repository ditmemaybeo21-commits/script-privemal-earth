-- Zones Module - Auto Zone Control
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Config = _G.PEHub.Config

local Zones = {}

function Zones:GetAllZones()
    local zoneList = {}
    for _, v in ipairs(Workspace:GetChildren()) do
        local name = v.Name:lower()
        if name:find("zone") or name:find("area") or name:find("region") then
            table.insert(zoneList, v)
        end
    end
    return zoneList
end

function Zones:FindNearestZone()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local charPos = char.HumanoidRootPart.Position
    local nearest, nearestDist = nil, math.huge
    for _, zone in ipairs(self:GetAllZones()) do
        local root = zone:IsA("Model") and zone:FindFirstChild("HumanoidRootPart") or zone
        if root and root:IsA("BasePart") then
            local dist = (root.Position - charPos).Magnitude
            if dist < nearestDist then
                nearest, nearestDist = zone, dist
            end
        end
    end
    return nearest
end

function Zones:TeleportToNearestZone()
    local zone = self:FindNearestZone()
    if not zone then
        _G.PEHub.Notifier:Notify("Zone", "Không tìm thấy zone nào!", 3)
        return
    end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = zone:IsA("Model") and zone:FindFirstChild("HumanoidRootPart") or zone
    if root and root:IsA("BasePart") then
        char.HumanoidRootPart.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
        _G.PEHub.Notifier:Notify("Zone", "Đã teleport đến: " .. zone.Name, 3)
    end
end

function Zones:ListZones()
    local zones = self:GetAllZones()
    print("=== Danh sách Zones ===")
    for i, zone in ipairs(zones) do
        print(i .. ". " .. zone.Name)
    end
    _G.PEHub.Notifier:Notify("Zone", "Tìm thấy " .. #zones .. " zones. Xem console.", 4)
end

function Zones:StartAutoZone()
    task.spawn(function()
        while Config.AutoZone do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local zone = self:FindNearestZone()
                if zone then
                    local root = zone:IsA("Model") and zone:FindFirstChild("HumanoidRootPart") or zone
                    if root and root:IsA("BasePart") then
                        local dist = (root.Position - char.HumanoidRootPart.Position).Magnitude
                        if dist > 20 then
                            char.HumanoidRootPart.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
                        end
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new(500, 400))
                    end
                end
            end
            task.wait(1)
        end
    end)
end

_G.PEHub.Zones = Zones
return Zones
