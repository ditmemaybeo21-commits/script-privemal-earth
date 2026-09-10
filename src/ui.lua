--[[
    UI Module - Menu giao diện
]]

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Config = _G.PEHub.Config
local Notifier = _G.PEHub.Notifier

local UI = {}

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PEHub_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 620, 0, 450)
Main.Position = UDim2.new(0.5, -310, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Config.AccentColor
MainStroke.Thickness = 2
MainStroke.Parent = Main

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔥 Primeval Earth Hub v1.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -75, 0, 6)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 180, 50)
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Tab container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 150, 1, -52)
TabContainer.Position = UDim2.new(0, 5, 0, 47)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = Main

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 6)
TabCorner.Parent = TabContainer

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 4)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabContainer

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 8)
TabPadding.PaddingLeft = UDim.new(0, 6)
TabPadding.PaddingRight = UDim.new(0, 6)
TabPadding.Parent = TabContainer

-- Content container
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -165, 1, -52)
Content.Position = UDim2.new(0, 160, 0, 47)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Tabs = {}
local CurrentPage = nil

function UI:CreateTab(name, icon)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 32)
    TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    TabBtn.Text = (icon or "") .. " " .. name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.TextSize = 13
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.BorderSizePixel = 0
    TabBtn.Parent = TabContainer
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = TabBtn
    
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Config.AccentColor
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.Visible = false
    Page.Parent = Content
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 6)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Parent = Page
    
    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingTop = UDim.new(0, 8)
    PagePadding.PaddingLeft = UDim.new(0, 8)
    PagePadding.PaddingRight = UDim.new(0, 8)
    PagePadding.Parent = Page
    
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
    end)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, tab in ipairs(Tabs) do
            tab.Page.Visible = false
            tab.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        Page.Visible = true
        TabBtn.BackgroundColor3 = Config.AccentColor
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CurrentPage = Page
    end)
    
    table.insert(Tabs, {Button = TabBtn, Page = Page, Name = name})
    
    if #Tabs == 1 then
        TabBtn.MouseButton1Click:Fire()
    end
    
    return Page
end

function UI:CreateToggle(parent, text, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 32)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, -10, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 50, 0, 24)
    Toggle.Position = UDim2.new(1, -60, 0.5, -12)
    Toggle.BackgroundColor3 = default and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(60, 60, 80)
    Toggle.Text = default and "ON" or "OFF"
    Toggle.TextColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 100, 100)
    Toggle.TextSize = 11
    Toggle.Font = Enum.Font.GothamBold
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Frame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = Toggle
    
    local state = default
    Toggle.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Toggle.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
            Toggle.Text = "ON"
            Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            Toggle.Text = "OFF"
            Toggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        callback(state)
    end)
    
    return Frame
end

function UI:CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 52)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, -10, 0, 20)
    Label.Position = UDim2.new(0, 12, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0.4, -10, 0, 20)
    ValueLabel.Position = UDim2.new(0.6, 10, 0, 5)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Config.AccentColor
    ValueLabel.TextSize = 13
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Frame
    
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -24, 0, 4)
    SliderFrame.Position = UDim2.new(0, 12, 0, 38)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = Frame
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 2)
    SliderCorner.Parent = SliderFrame
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Config.AccentColor
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderFrame
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 2)
    FillCorner.Parent = Fill
    
    local Thumb = Instance.new("TextButton")
    Thumb.Size = UDim2.new(0, 14, 0, 14)
    Thumb.Position = UDim2.new((default - min) / (max - min), -7, -5, 0)
    Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Thumb.Text = ""
    Thumb.BorderSizePixel = 0
    Thumb.Parent = SliderFrame
    
    local ThumbCorner = Instance.new("UICorner")
    ThumbCorner.CornerRadius = UDim.new(1, 0)
    ThumbCorner.Parent = Thumb
    
    local dragging = false
    Thumb.MouseButton1Down:Connect(function() dragging = true end)
    Thumb.MouseButton1Up:Connect(function() dragging = false end)
    Thumb.MouseLeave:Connect(function() dragging = false end)
    SliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    SliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    RunService.Heartbeat:Connect(function()
        if dragging then
            local mouse = UserInputService:GetMouseLocation()
            local absPos = SliderFrame.AbsolutePosition
            local absSize = SliderFrame.AbsoluteSize
            local percent = math.clamp((mouse.X - absPos.X) / absSize.X, 0, 1)
            local value = min + (max - min) * percent
            value = math.floor(value * 100) / 100
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            Thumb.Position = UDim2.new(percent, -7, -5, 0)
            ValueLabel.Text = tostring(value)
            callback(value)
        end
    end)
    
    return Frame
end

function UI:CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    Btn.TextSize = 13
    Btn.Font = Enum.Font.Gotham
    Btn.BorderSizePixel = 0
    Btn.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn
    
    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Config.AccentColor}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}):Play()
    end)
    Btn.MouseButton1Click:Connect(callback)
    
    return Btn
end

function UI:CreateLabel(parent, text, color)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 24)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = parent
    return Label
end

function UI:CreateDivider(parent, text)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 24)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "── " .. text .. " ──"
    Label.TextColor3 = Config.AccentColor
    Label.TextSize = 12
    Label.Font = Enum.Font.GothamBold
    Label.Parent = Frame
    
    return Frame
end

-- =========================================================
-- TẠO CÁC TAB VÀ CHỨC NĂNG
-- =========================================================

-- TAB COMBAT
local CombatTab = UI:CreateTab("Combat", "⚔️")
UI:CreateDivider(CombatTab, "TẤN CÔNG")
UI:CreateToggle(CombatTab, "Auto Attack", false, function(state)
    Config.AutoAttack = state
    if state and _G.PEHub.Combat then _G.PEHub.Combat:StartAutoAttack() end
end)
UI:CreateToggle(CombatTab, "Auto Aim", false, function(state)
    Config.AutoAim = state
end)
UI:CreateToggle(CombatTab, "Auto Eat", false, function(state)
    Config.AutoEat = state
    if state and _G.PEHub.AutoEat then _G.PEHub.AutoEat:Start() end
end)
UI:CreateSlider(CombatTab, "Tốc độ đánh", 0.01, 0.5, 0.05, function(val)
    Config.AttackSpeed = val
end)
UI:CreateSlider(CombatTab, "Khoảng cách đánh", 5, 100, 15, function(val)
    Config.AttackRange = val
end)
UI:CreateSlider(CombatTab, "Hitbox Size", 5, 50, 20, function(val)
    Config.HitboxSize = val
end)
UI:CreateSlider(CombatTab, "Khoảng cách ăn", 20, 200, 80, function(val)
    Config.EatRange = val
end)
UI:CreateDivider(CombatTab, "FLY ATTACK")
UI:CreateToggle(CombatTab, "Fly Attack (bay trên đầu)", false, function(state)
    Config.FlyAttack = state
end)
UI:CreateSlider(CombatTab, "Chiều cao bay", 5, 50, 15, function(val)
    Config.FlyHeight = val
end)
UI:CreateDivider(CombatTab, "TELEPORT")
UI:CreateToggle(CombatTab, "Auto Teleport (săn người)", false, function(state)
    Config.AutoTeleport = state
end)
UI:CreateSlider(CombatTab, "Khoảng cách teleport", 100, 1000, 500, function(val)
    Config.TeleportRange = val
end)

-- TAB MOVEMENT
local MoveTab = UI:CreateTab("Movement", "🏃")
UI:CreateDivider(MoveTab, "TỐC ĐỘ")
UI:CreateSlider(MoveTab, "Tốc độ chạy", 16, 200, 50, function(val)
    Config.WalkSpeed = val
end)
UI:CreateSlider(MoveTab, "Sức nhảy", 50, 300, 100, function(val)
    Config.JumpPower = val
end)
UI:CreateToggle(MoveTab, "Bật tăng tốc chạy", false, function(state)
    Config.SpeedEnabled = state
end)
UI:CreateToggle(MoveTab, "Bật tăng sức nhảy", false, function(state)
    Config.JumpEnabled = state
end)
UI:CreateDivider(MoveTab, "BAY")
UI:CreateToggle(MoveTab, "Fly", false, function(state)
    if _G.PEHub.Movement then _G.PEHub.Movement:ToggleFly(state) end
end)
UI:CreateSlider(MoveTab, "Tốc độ bay", 10, 200, 50, function(val)
    Config.FlySpeed = val
end)
UI:CreateDivider(MoveTab, "KHÁC")
UI:CreateToggle(MoveTab, "Noclip (xuyên vật)", false, function(state)
    if _G.PEHub.Movement then _G.PEHub.Movement:ToggleNoclip(state) end
end)
UI:CreateToggle(MoveTab, "Water Walk", false, function(state)
    Config.WaterWalk = state
end)

-- TAB VISUALS
local VisTab = UI:CreateTab("Visuals", "👁️")
UI:CreateDivider(VisTab, "ESP")
UI:CreateToggle(VisTab, "ESP Player", false, function(state)
    Config.ESP_Player = state
    if _G.PEHub.Visuals then _G.PEHub.Visuals:ToggleESP("Player", state) end
end)
UI:CreateToggle(VisTab, "ESP Dinosaur", false, function(state)
    Config.ESP_Dinosaur = state
    if _G.PEHub.Visuals then _G.PEHub.Visuals:ToggleESP("Dinosaur", state) end
end)
UI:CreateToggle(VisTab, "ESP Food", false, function(state)
    Config.ESP_Food = state
    if _G.PEHub.Visuals then _G.PEHub.Visuals:ToggleESP("Food", state) end
end)
UI:CreateToggle(VisTab, "ESP Fossil", false, function(state)
    Config.ESP_Fossil = state
    if _G.PEHub.Visuals then _G.PEHub.Visuals:ToggleESP("Fossil", state) end
end)
UI:CreateToggle(VisTab, "ESP Zone", false, function(state)
    Config.ESP_Zone = state
    if _G.PEHub.Visuals then _G.PEHub.Visuals:ToggleESP("Zone", state) end
end)

-- TAB FARMING
local FarmTab = UI:CreateTab("Farming", "🌾")
UI:CreateDivider(FarmTab, "FOSSIL")
UI:CreateToggle(FarmTab, "Fossil Auto Farm", false, function(state)
    Config.FossilFarm = state
    if state and _G.PEHub.Farming then _G.PEHub.Farming:StartFossilFarm() end
end)
UI:CreateSlider(FarmTab, "Khoảng cách farm", 20, 200, 100, function(val)
    Config.FossilRange = val
end)
UI:CreateDivider(FarmTab, "KHÁC")
UI:CreateToggle(FarmTab, "Auto Collect", false, function(state)
    Config.AutoCollect = state
end)
UI:CreateToggle(FarmTab, "Auto Craft", false, function(state)
    Config.AutoCraft = state
end)

-- TAB ZONES
local ZoneTab = UI:CreateTab("Zones", "🗺️")
UI:CreateDivider(ZoneTab, "ZONE CONTROL")
UI:CreateToggle(ZoneTab, "Auto Zone (chiếm đóng)", false, function(state)
    Config.AutoZone = state
    if state and _G.PEHub.Zones then _G.PEHub.Zones:StartAutoZone() end
end)
UI:CreateButton(ZoneTab, "Teleport đến Zone gần nhất", function()
    if _G.PEHub.Zones then _G.PEHub.Zones:TeleportToNearestZone() end
end)
UI:CreateButton(ZoneTab, "Hiển thị danh sách Zone", function()
    if _G.PEHub.Zones then _G.PEHub.Zones:ListZones() end
end)

-- TAB SETTINGS
local SetTab = UI:CreateTab("Settings", "⚙️")
UI:CreateDivider(SetTab, "GIAO DIỆN")
UI:CreateButton(SetTab, "Đổi màu Accent", function()
    Config.AccentColor = Color3.fromRGB(math.random(100, 255), math.random(100, 255), math.random(100, 255))
    MainStroke.Color = Config.AccentColor
    Notifier:Notify("UI", "Đã đổi màu accent!", 2)
end)
UI:CreateDivider(SetTab, "THÔNG TIN")
UI:CreateLabel(SetTab, "Primeval Earth Hub v1.0", Color3.fromRGB(255, 200, 0))
UI:CreateLabel(SetTab, "Author: B.Duy Dev", Color3.fromRGB(200, 200, 200))
UI:CreateLabel(SetTab, "GitHub: PrimevalEarth-Hub", Color3.fromRGB(100, 200, 255))

-- =========================================================
-- HOTKEY
-- =========================================================
UserInputService.InputBegan:Connect(function(input, gp)
