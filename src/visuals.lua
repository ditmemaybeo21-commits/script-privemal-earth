-- Visuals Module - ESP
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Config = _G.PEHub and _G.PEHub.Config or {}

local Visuals = {}
Visuals.ESPObjects = {}

function Visuals:CreateESP(target, color, text)
    if self.ESPObjects[target] then return end
    local root = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChildWhichIsA("BasePart")
    if not root then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PE_ESP"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Adornee = root
    billboard.Parent = root

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = text or target.Name
    nameLabel.TextColor3 = color
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Parent = billboard

    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0, 15)
    distLabel.Position = UDim2.new(0, 0, 0, 20)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = ""
    distLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distLabel.TextSize = 11
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextStrokeTransparency = 0
    distLabel.Parent = billboard

    local highlight = Instance.new("Highlight")
    highlight.Name = "PE_Highlight"
    highlight.FillColor = color
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = target

    self.ESPObjects[target] = {billboard = billboard, highlight = highlight, distLabel = distLabel}
end

function Visuals:RemoveESP(target)
    local obj = self.ESPObjects[target]
    if obj then
        if obj.billboard then obj.billboard:Destroy() end
        if obj.highlight then obj.highlight:Destroy() end
        self.ESPObjects[target] = nil
    end
end

function Visuals:ToggleESP(type, state)
    if not state then
        for target, _ in pairs(self.ESPObjects) do
            self:RemoveESP(target)
        end
    end
end

function Visuals:StartESPLoop()
    task.spawn(function()
        while task.wait(0.5) do
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then
                continue
            end
            local charPos = char.HumanoidRootPart.Position

            if Config.ESP_Player or Config.ESP_Dinosaur then
                for _, v in ipairs(Workspace:GetChildren()) do
                    if v:IsA("Model") and v ~= char then
                        local hum = v:FindFirstChild("Humanoid")
                        local root = v:FindFirstChild("HumanoidRootPart")
                        if hum and hum.Health > 0 and root then
                            local isPlayer = Players:FindFirstChild(v.Name)
                            if isPlayer and Config.ESP_Player then
                                self:CreateESP(v, Color3.fromRGB(255, 0, 0), "[P] " .. v.Name)
                            elseif not isPlayer and Config.ESP_Dinosaur then
                                self:CreateESP(v, Color3.fromRGB(0, 255, 0), "[D] " .. v.Name)
                            end
                            local obj = self.ESPObjects[v]
                            if obj and obj.distLabel then
                                obj.distLabel.Text = math.floor((root.Position - charPos).Magnitude) .. "m"
                            end
                        end
                    end
                end
            end
        end
    end)
end

Visuals:StartESPLoop()
_G.PEHub.Visuals = Visuals
return Visuals
