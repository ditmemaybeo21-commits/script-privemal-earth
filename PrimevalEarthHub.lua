--[[ Primeval Earth Hub - All-in-One ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

pcall(function()
    local old = LocalPlayer.PlayerGui:FindFirstChild("PEHub_Menu")
    if old then old:Destroy() end
end)

_G.PEHub = {
    Config = {
        WalkSpeed = 16, JumpPower = 50, FlySpeed = 50,
        AutoAttack = false, AutoEat = false,
        AttackRange = 15, HitboxSize = 20, AttackSpeed = 0.1, EatRange = 80,
        FlyEnabled = false, Noclip = false,
        AccentColor = Color3.fromRGB(255, 100, 0),
        SpeedEnabled = false, JumpEnabled = false
    }
}

local Config = _G.PEHub.Config

local function Notify(title, text, duration)
    duration = duration or 3
    local sg = Instance.new("ScreenGui")
    sg.Name = "PE_Notify"
    sg.ResetOnSpawn = false
    sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 280, 0, 70)
    f.Position = UDim2.new(1, -300, 0, 20)
    f.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    f.BorderSizePixel = 0
    f.Parent = sg
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", f); s.Color = Config.AccentColor; s.Thickness = 1.5
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, -20, 0, 25); t.Position = UDim2.new(0, 10, 0, 5)
    t.BackgroundTransparency = 1; t.Text = title; t.TextColor3 = Config.AccentColor
    t.TextSize = 14; t.Font = Enum.Font.GothamBold; t.TextXAlignment = Enum.TextXAlignment.Left
    local b = Instance.new("TextLabel", f)
    b.Size = UDim2.new(1, -20, 0, 30); b.Position = UDim2.new(0, 10, 0, 30)
    b.BackgroundTransparency = 1; b.Text = text; b.TextColor3 = Color3.fromRGB(220, 220, 220)
    b.TextSize = 12; b.Font = Enum.Font.Gotham; b.TextXAlignment = Enum.TextXAlignment.Left
    b.TextWrapped = true
    task.delay(duration, function() sg:Destroy() end)
end

Notify("PE Hub", "Dang khoi tao...", 2)
print("[PE Hub] Bat dau")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PEHub_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Enabled = true

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 620, 0, 450)
Main.Position = UDim2.new(0.5, -310, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local ms = Instance.new("UIStroke", Main); ms.Color = Config.AccentColor; ms.Thickness = 2

local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -120, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Primeval Earth Hub v1.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16; Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -40, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16; CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.MouseButton1Click:Connect(function() ScreenGui.Enabled = false end)

local TabContainer = Instance.new("Frame", Main)
TabContainer.Size = UDim2.new(0, 150, 1, -52)
TabContainer.Position = UDim2.new(0, 5, 0, 47)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
TabContainer.BorderSizePixel = 0
Instance.new("UICorner", TabContainer).CornerRadius = UDim.new(0, 6)
local TabList = Instance.new("UIListLayout", TabContainer)
TabList.Padding = UDim.new(0, 4); TabList.SortOrder = Enum.SortOrder.LayoutOrder
local TabPad = Instance.new("UIPadding", TabContainer)
TabPad.PaddingTop = UDim.new(0, 8); TabPad.PaddingLeft = UDim.new(0, 6); TabPad.PaddingRight = UDim.new(0, 6)

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -165, 1, -52)
Content.Position = UDim2.new(0, 160, 0, 47)
Content.BackgroundTransparency = 1

local Tabs = {}

local function CreateTab(name)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 13; btn.Font = Enum.Font.Gotham; btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local page = Instance.new("ScrollingFrame", Content)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1; page.BorderSizePixel = 0
    page.ScrollBarThickness = 4; page.ScrollBarImageColor3 = Config.AccentColor
    page.CanvasSize = UDim2.new(0, 0, 0, 0); page.Visible = false
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6); layout.SortOrder = Enum.SortOrder.LayoutOrder
    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop = UDim.new(0, 8); pad.PaddingLeft = UDim.new(0, 8); pad.PaddingRight = UDim.new(0, 8)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)

    btn.MouseButton1Click:Connect(function()
        for _, tab in ipairs(Tabs) do
            tab.page.Visible = false
            tab.btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            tab.btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        page.Visible = true
        btn.BackgroundColor3 = Config.AccentColor
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    table.insert(Tabs, {btn = btn, page = page})
    if #Tabs == 1 then btn.MouseButton1Click:Fire() end
    return page
end

local function CreateToggle(parent, text, default, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 32)
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.7, -10, 1, 0); l.Position = UDim2.new(0, 12, 0, 0)
    l.BackgroundTransparency = 1; l.Text = text
    l.TextColor3 = Color3.fromRGB(220, 220, 220)
    l.TextSize = 13; l.Font = Enum.Font.Gotham; l.TextXAlignment = Enum.TextXAlignment.Left
    local t = Instance.new("TextButton", f)
    t.Size = UDim2.new(0, 50, 0, 24); t.Position = UDim2.new(1, -60, 0.5, -12)
    t.BackgroundColor3 = default and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(60, 60, 80)
    t.Text = default and "ON" or "OFF"
    t.TextColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 100, 100)
    t.TextSize = 11; t.Font = Enum.Font.GothamBold; t.BorderSizePixel = 0
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)
    local state = default
    t.MouseButton1Click:Connect(function()
        state = not state
        if state then
            t.BackgroundColor3 = Color3.fromRGB(0, 200, 80); t.Text = "ON"; t.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            t.BackgroundColor3 = Color3.fromRGB(60, 60, 80); t.Text = "OFF"; t.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        callback(state)
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 52)
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.6, -10, 0, 20); l.Position = UDim2.new(0, 12, 0, 5)
    l.BackgroundTransparency = 1; l.Text = text
    l.TextColor3 = Color3.fromRGB(220, 220, 220)
    l.TextSize = 13; l.Font = Enum.Font.Gotham; l.TextXAlignment = Enum.TextXAlignment.Left
    local vl = Instance.new("TextLabel", f)
    vl.Size = UDim2.new(0.4, -10, 0, 20); vl.Position = UDim2.new(0.6, 10, 0, 5)
    vl.BackgroundTransparency = 1; vl.Text = tostring(default)
    vl.TextColor3 = Config.AccentColor; vl.TextSize = 13; vl.Font = Enum.Font.GothamBold
    vl.TextXAlignment = Enum.TextXAlignment.Right
    local sf = Instance.new("Frame", f)
    sf.Size = UDim2.new(1, -24, 0, 4); sf.Position = UDim2.new(0, 12, 0, 38)
    sf.BackgroundColor3 = Color3.fromRGB(60, 60, 80); sf.BorderSizePixel = 0
    Instance.new("UICorner", sf).CornerRadius = UDim.new(0, 2)
    local fill = Instance.new("Frame", sf)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Config.AccentColor; fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 2)
    local th = Instance.new("TextButton", sf)
    th.Size = UDim2.new(0, 14, 0, 14)
    th.Position = UDim2.new((default - min) / (max - min), -7, -5, 0)
    th.BackgroundColor3 = Color3.fromRGB(255, 255, 255); th.Text = ""; th.BorderSizePixel = 0
    Instance.new("UICorner", th).CornerRadius = UDim.new(1, 0)
    local dragging = false
    th.MouseButton1Down:Connect(function() dragging = true end)
    th.MouseButton1Up:Connect(function() dragging = false end)
    th.MouseLeave:Connect(function() dragging = false end)
    RunService.Heartbeat:Connect(function()
        if dragging then
            local m = UserInputService:GetMouseLocation()
            local ap = sf.AbsolutePosition
            local as = sf.AbsoluteSize
            local p = math.clamp((m.X - ap.X) / as.X, 0, 1)
            local v = min + (max - min) * p
            v = math.floor(v * 100) / 100
            fill.Size = UDim2.new(p, 0, 1, 0)
            th.Position = UDim2.new(p, -7, -5, 0)
            vl.Text = tostring(v)
            callback(v)
        end
    end)
end

local function CreateDivider(parent, text)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 24); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1
    l.Text = "-- " .. text .. " --"
    l.TextColor3 = Config.AccentColor; l.TextSize = 12; l.Font = Enum.Font.GothamBold
end

local CombatTab = CreateTab("Combat")
CreateDivider(CombatTab, "TAN CONG")
CreateToggle(CombatTab, "Auto Attack", false, function(s)
    Config.AutoAttack = s
    if s then
        task.spawn(function()
            while Config.AutoAttack do
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local nearest, dist = nil, math.huge
                    for _, v in ipairs(Workspace:GetChildren()) do
                        if v:IsA("Model") and v ~= char then
                            local h = v:FindFirstChild("Humanoid")
                            local r = v:FindFirstChild("HumanoidRootPart")
                            if h and h.Health > 0 and r then
                                local d = (r.Position - char.HumanoidRootPart.Position).Magnitude
                                if d < dist then nearest, dist = v, d end
                            end
                        end
                    end
                    if nearest then
                        local r = nearest.HumanoidRootPart
                        r.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                        char.HumanoidRootPart.CFrame = CFrame.new(r.Position + Vector3.new(0, 3, 0))
                        char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position, r.Position)
                        for i = 1, 5 do
                            VirtualUser:CaptureController()
                            VirtualUser:ClickButton2(Vector2.new(500, 400))
                            task.wait(0.01)
                        end
                        pcall(function()
                            local tool = char:FindFirstChildWhichIsA("Tool")
                            if tool then tool:Activate() end
                        end)
                    end
                end
                task.wait(Config.AttackSpeed)
            end
        end)
    end
end)
CreateSlider(CombatTab, "Toc do danh", 0.01, 0.5, 0.1, function(v) Config.AttackSpeed = v end)
CreateSlider(CombatTab, "Hitbox Size", 5, 50, 20, function(v) Config.HitboxSize = v end)
CreateToggle(CombatTab, "Auto Eat", false, function(s)
    Config.AutoEat = s
    if s then
        task.spawn(function()
            while Config.AutoEat do
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _, v in ipairs(Workspace:GetChildren()) do
                        local n = v.Name:lower()
                        if n:find("food") or n:find("meat") or n:find("berry") then
                            local r = v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") or v
                            if r and r:IsA("BasePart") then
                                local d = (r.Position - char.HumanoidRootPart.Position).Magnitude
                                if d < Config.EatRange then
                                    char.HumanoidRootPart.CFrame = CFrame.new(r.Position + Vector3.new(0, 2, 0))
                                    task.wait(0.05)
                                    VirtualUser:CaptureController()
                                    VirtualUser:ClickButton2(Vector2.new(500, 400))
                                    break
                                end
                            end
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end)
CreateSlider(CombatTab, "Khoang cach an", 20, 200, 80, function(v) Config.EatRange = v end)

local MoveTab = CreateTab("Movement")
CreateDivider(MoveTab, "TOC DO")
CreateSlider(MoveTab, "Toc do chay", 16, 200, 50, function(v) Config.WalkSpeed = v end)
CreateSlider(MoveTab, "Suc nhay", 50, 300, 100, function(v) Config.JumpPower = v end)
CreateToggle(MoveTab, "Bat tang toc chay", false, function(s) Config.SpeedEnabled = s end)
CreateToggle(MoveTab, "Bat tang suc nhay", false, function(s) Config.JumpEnabled = s end)
CreateDivider(MoveTab, "BAY")
CreateToggle(MoveTab, "Fly", false, function(s)
    Config.FlyEnabled = s
    if s then
        task.spawn(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            if hrp and hum then
                hum.PlatformStand = true
                while Config.FlyEnabled do
                    local mv = Vector3.new(0, 0, 0)
                    local cam = Workspace.CurrentCamera
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv = mv + cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv = mv - cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv = mv - cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv = mv + cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then mv = mv + Vector3.new(0, 1, 0) end
                    hrp.Velocity = mv * Config.FlySpeed
                    task.wait(0.05)
                end
                hum.PlatformStand = false
            end
        end)
    end
end)
CreateSlider(MoveTab, "Toc do bay", 10, 200, 50, function(v) Config.FlySpeed = v end)
CreateToggle(MoveTab, "Noclip", false, function(s)
    Config.Noclip = s
    task.spawn(function()
        while Config.Noclip do
            local char = LocalPlayer.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
            task.wait(0.2)
        end
    end)
end)

local VisTab = CreateTab("Visuals")
CreateDivider(VisTab, "ESP")
CreateToggle(VisTab, "ESP Player", false, function(s) Config.ESP_Player = s end)
CreateToggle(VisTab, "ESP Dinosaur", false, function(s) Config.ESP_Dinosaur = s end)

local FarmTab = CreateTab("Farming")
CreateDivider(FarmTab, "FOSSIL")
CreateToggle(FarmTab, "Fossil Auto Farm", false, function(s) Config.FossilFarm = s end)

local SetTab = CreateTab("Settings")
CreateDivider(SetTab, "INFO")
local info = Instance.new("TextLabel", SetTab)
info.Size = UDim2.new(1, 0, 0, 60); info.BackgroundTransparency = 1
info.Text = "PE Hub v1.0 - B.Duy Dev"
info.TextColor3 = Color3.fromRGB(220, 220, 220)
info.TextSize = 13; info.Font = Enum.Font.Gotham

task.spawn(function()
    while task.wait(0.1) do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            if Config.SpeedEnabled then char.Humanoid.WalkSpeed = Config.WalkSpeed end
            if Config.JumpEnabled then char.Humanoid.JumpPower = Config.JumpPower end
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.F7 then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

Notify("Primeval Earth Hub", "Da tai! Nhan RightShift hoac F7.", 5)
print("[PE Hub] Tai hoan tat")
