--[[
    Primeval Earth Hub - Main Script
    Author: B.Duy Dev
    GitHub: https://github.com/ditmemaybeo21-commits/script-primeval-earth
]]

local BASE_URL = "https://raw.githubusercontent.com/ditmemaybeo21-commits/script-privemal-earth/main/src/"

local function loadModule(name)
    local url = BASE_URL .. name .. ".lua"
    local success, result = pcall(function() return game:HttpGet(url) end)
    if success and result then
        local func, err = loadstring(result)
        if func then
            local ok, mod = pcall(func)
            if ok then return mod end
            warn("[PE Hub] Run error " .. name .. ": " .. tostring(mod))
        else
            warn("[PE Hub] Load error " .. name .. ": " .. tostring(err))
        end
    else
        warn("[PE Hub] Fetch error " .. name)
    end
    return nil
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

_G.PEHub = {
    Config = {
        WalkSpeed = 16, JumpPower = 50, FlySpeed = 50, FlyHeight = 15,
        AutoAttack = false, AutoEat = false, AutoAim = false,
        AttackRange = 15, HitboxSize = 20, AttackSpeed = 0.05, EatRange = 80,
        ESP_Player = false, ESP_Dinosaur = false, ESP_Food = false, ESP_Fossil = false, ESP_Zone = false,
        ESP_Color = Color3.fromRGB(255, 0, 0),
        FossilFarm = false, FossilRange = 100,
        AutoZone = false, CurrentZone = nil,
        FlyEnabled = false, Noclip = false,
        AccentColor = Color3.fromRGB(255, 100, 0),
        SpeedEnabled = false, JumpEnabled = false, WaterWalk = false,
        FlyAttack = false, AutoTeleport = false, TeleportRange = 500
    },
    Notifier = nil, UI = nil
}

local Notifier = {}
function Notifier:Notify(title, text, duration)
    duration = duration or 3
    local ScreenGui = CoreGui or LocalPlayer:WaitForChild("PlayerGui")
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 280, 0, 70)
    Frame.Position = UDim2.new(1, -300, 0, 20)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 8); Corner.Parent = Frame
    local Stroke = Instance.new("UIStroke"); Stroke.Color = _G.PEHub.Config.AccentColor; Stroke.Thickness = 1.5; Stroke.Parent = Frame
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 25); Title.Position = UDim2.new(0, 10, 0, 5)
    Title.BackgroundTransparency = 1; Title.Text = title; Title.TextColor3 = _G.PEHub.Config.AccentColor
    Title.TextSize = 14; Title.Font = Enum.Font.GothamBold; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.Parent = Frame
    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, -20, 0, 30); Text.Position = UDim2.new(0, 10, 0, 30)
    Text.BackgroundTransparency = 1; Text.Text = text; Text.TextColor3 = Color3.fromRGB(220, 220, 220)
    Text.TextSize = 12; Text.Font = Enum.Font.Gotham; Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.TextWrapped = true; Text.Parent = Frame
    task.delay(duration, function()
        TweenService:Create(Frame, TweenInfo.new(0.3), {Position = UDim2.new(1, 20, 0, 20)}):Play()
        task.wait(0.3); Frame:Destroy()
    end)
end
_G.PEHub.Notifier = Notifier

print("[PE Hub] Đang tải modules...")
loadModule("combat")
loadModule("movement")
loadModule("visuals")
loadModule("farming")
loadModule("zones")
local UI = loadModule("ui")
if UI then _G.PEHub.UI = UI end

Notifier:Notify("Primeval Earth Hub", "Đã tải thành công! Nhấn RightShift để mở menu.", 5)
print("[PE Hub] Tải hoàn tất!")
