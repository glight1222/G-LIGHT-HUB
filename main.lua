-- ========================================================
--    G LIGHT HUB v5.0 - THEMES & CUSTOMIZATION EDITION
-- ========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local PlayerName = LocalPlayer.DisplayName or LocalPlayer.Name

-- Контейнер GUI
local ParentContainer
local success, result = pcall(function()
    if gethui then return gethui() end
    if syn and syn.protect_gui then
        local sg = Instance.new("ScreenGui")
        syn.protect_gui(sg)
        return sg
    end
    return CoreGui:FindFirstChild("RobloxGui") or LocalPlayer:WaitForChild("PlayerGui")
end)

ParentContainer = success and result or LocalPlayer:WaitForChild("PlayerGui")

if ParentContainer:FindFirstChild("GLightHub_v50") then
    ParentContainer.GLightHub_v50:Destroy()
end

local GLightHub = Instance.new("ScreenGui")
GLightHub.Name = "GLightHub_v50"
GLightHub.ResetOnSpawn = false
GLightHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GLightHub.Parent = ParentContainer

-- Глобальное Состояние
local State = {
    WalkSpeed = 16, SpeedEnabled = false,
    JumpPower = 50, JumpEnabled = false,
    Noclip = false, InfJump = false, DashEnabled = true,
    
    KillAura = false, AuraRange = 15,
    RoleESP = true, GunESP = true, DangerRadar = true,
    TurboFPS = false,
    
    CurrentTheme = "Cosmic",
    
    MurderColor = Color3.fromRGB(255, 35, 35),
    SheriffColor = Color3.fromRGB(0, 140, 255),
    InnocentColor = Color3.fromRGB(40, 220, 90)
}

-- Главный Интерфейс
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 680, 0, 440)
MainFrame.Position = UDim2.new(0.5, -340, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 12, 22)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = GLightHub

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 170, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.4

-- 200+ Звезд на фоне UI
local UIStarsFrame = Instance.new("Frame", MainFrame)
UIStarsFrame.Size = UDim2.new(1, 0, 1, 0)
UIStarsFrame.BackgroundTransparency = 1
UIStarsFrame.ZIndex = 1

task.spawn(function()
    for i = 1, 200 do
        local star = Instance.new("Frame", UIStarsFrame)
        local sz = math.random(1, 3)
        star.Size = UDim2.new(0, sz, 0, sz)
        star.BackgroundColor3 = Color3.fromRGB(180, 225, 255)
        star.ZIndex = 1
        Instance.new("UICorner", star).CornerRadius = UDim.new(1, 0)

        local function FloatStar()
            local startX, startY = math.random(-10, 110) / 100, math.random(-10, 110) / 100
            star.Position = UDim2.new(startX, 0, startY, 0)
            star.BackgroundTransparency = math.random(10, 90) / 100
            
            local duration = math.random(15, 45)
            local endX, endY = startX + (math.random(-15, 15) / 100), startY + (math.random(-15, 15) / 100)
            
            local tween = TweenService:Create(star, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
                Position = UDim2.new(endX, 0, endY, 0),
                BackgroundTransparency = math.random(20, 80) / 100
            })
            tween:Play()
            tween.Completed:Wait()
            if GLightHub.Parent then FloatStar() end
        end
        task.spawn(FloatStar)
    end
end)

-- TopBar
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(12, 18, 32)
TopBar.BackgroundTransparency = 0.2
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 5

local LogoLabel = Instance.new("TextLabel", TopBar)
LogoLabel.Size = UDim2.new(0, 350, 1, 0)
LogoLabel.Position = UDim2.new(0, 15, 0, 0)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "✨ G LIGHT HUB v5.0  [THEMES EDITION]"
LogoLabel.TextColor3 = Color3.fromRGB(0, 215, 255)
LogoLabel.Font = Enum.Font.GothamBold
LogoLabel.TextSize = 15
LogoLabel.TextXAlignment = Enum.TextXAlignment.Left
LogoLabel.ZIndex = 6

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(24, 34, 54)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 220, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.ZIndex = 6
local CloseCorner = Instance.new("UICorner", CloseBtn)
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() GLightHub:Destroy() end)

-- Перетаскивание
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = MainFrame.Position end
end)
TopBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- SideBar & Content
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 160, 1, -45)
SideBar.Position = UDim2.new(0, 0, 0, 45)
SideBar.BackgroundColor3 = Color3.fromRGB(10, 14, 25)
SideBar.BackgroundTransparency = 0.3
SideBar.BorderSizePixel = 0
SideBar.ZIndex = 5

local SideLayout = Instance.new("UIListLayout", SideBar)
SideLayout.Padding = UDim.new(0, 6)
Instance.new("UIPadding", SideBar).PaddingTop = UDim.new(0, 10)

local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -170, 1, -55)
ContentArea.Position = UDim2.new(0, 165, 0, 50)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex = 5

local Tabs = {}
local AllCards = {}
local ActiveTabBtn = nil

local function CreateTab(name, icon)
    local TabButton = Instance.new("TextButton", SideBar)
    TabButton.Size = UDim2.new(1, -20, 0, 36)
    TabButton.Position = UDim2.new(0, 10, 0, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(16, 24, 40)
    TabButton.Text = "  " .. icon .. "  " .. name
    TabButton.TextColor3 = Color3.fromRGB(160, 180, 210)
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.TextSize = 13
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.ZIndex = 6
    local TabCorner = Instance.new("UICorner", TabButton)
    TabCorner.CornerRadius = UDim.new(0, 6)

    local Page = Instance.new("ScrollingFrame", ContentArea)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 2
    Page.Visible = false
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.ZIndex = 6
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            TweenService:Create(t.Btn, TweenInfo.new(0.2), {BackgroundColor3 = State.CurrentTheme == "Minecraft" and Color3.fromRGB(30, 45, 25) or (State.CurrentTheme == "BlackHole" and Color3.fromRGB(20, 10, 30) or Color3.fromRGB(16, 24, 40)), TextColor3 = Color3.fromRGB(160, 180, 210)}):Play()
        end
        Page.Visible = true
        ActiveTabBtn = TabButton
        local activeColor = State.CurrentTheme == "Minecraft" and Color3.fromRGB(85, 140, 40) or (State.CurrentTheme == "BlackHole" and Color3.fromRGB(140, 30, 200) or Color3.fromRGB(0, 130, 240))
        TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = activeColor, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    table.insert(Tabs, {Btn = TabButton, Page = Page, Corner = TabCorner})
    if #Tabs == 1 then ActiveTabBtn = TabButton Page.Visible = true TabButton.BackgroundColor3 = Color3.fromRGB(0, 130, 240) TabButton.TextColor3 = Color3.fromRGB(255, 255, 255) end
    return Page
end

local function AddToggle(page, text, defaultState, callback)
    local Card = Instance.new("Frame", page)
    Card.Size = UDim2.new(1, -10, 0, 50)
    Card.BackgroundColor3 = Color3.fromRGB(14, 20, 34)
    Card.BackgroundTransparency = 0.2
    Card.ZIndex = 6
    local CardCorner = Instance.new("UICorner", Card)
    CardCorner.CornerRadius = UDim.new(0, 8)
    table.insert(AllCards, {Frame = Card, Corner = CardCorner})

    local Label = Instance.new("TextLabel", Card)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 235, 255)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 7

    local Switch = Instance.new("TextButton", Card)
    Switch.Size = UDim2.new(0, 46, 0, 24)
    Switch.Position = UDim2.new(1, -58, 0.5, -12)
    Switch.BackgroundColor3 = defaultState and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(30, 42, 65)
    Switch.Text = ""
    Switch.ZIndex = 7
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Dot = Instance.new("Frame", Switch)
    Dot.Size = UDim2.new(0, 18, 0, 18)
    Dot.Position = defaultState and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    Dot.BackgroundColor3 = defaultState and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 160, 190)
    Dot.ZIndex = 8
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    local state = defaultState
    Switch.MouseButton1Click:Connect(function()
        state = not state
        local targetPos = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        local activeThemeColor = State.CurrentTheme == "Minecraft" and Color3.fromRGB(85, 170, 40) or (State.CurrentTheme == "BlackHole" and Color3.fromRGB(160, 40, 230) or Color3.fromRGB(0, 170, 255))
        local targetBg = state and activeThemeColor or Color3.fromRGB(30, 42, 65)
        TweenService:Create(Dot, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = targetBg}):Play()
        callback(state)
    end)
end

local function AddSlider(page, text, min, max, defaultVal, callback)
    local Card = Instance.new("Frame", page)
    Card.Size = UDim2.new(1, -10, 0, 60)
    Card.BackgroundColor3 = Color3.fromRGB(14, 20, 34)
    Card.BackgroundTransparency = 0.2
    Card.ZIndex = 6
    local CardCorner = Instance.new("UICorner", Card)
    CardCorner.CornerRadius = UDim.new(0, 8)
    table.insert(AllCards, {Frame = Card, Corner = CardCorner})

    local Label = Instance.new("TextLabel", Card)
    Label.Size = UDim2.new(0.6, 0, 0, 25)
    Label.Position = UDim2.new(0, 12, 0, 6)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 235, 255)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 7

    local ValLabel = Instance.new("TextLabel", Card)
    ValLabel.Size = UDim2.new(0.3, 0, 0, 25)
    ValLabel.Position = UDim2.new(0.7, -12, 0, 6)
    ValLabel.BackgroundTransparency = 1
    ValLabel.Text = tostring(defaultVal)
    ValLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    ValLabel.Font = Enum.Font.GothamBold
    ValLabel.TextSize = 13
    ValLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValLabel.ZIndex = 7

    local SliderBack = Instance.new("Frame", Card)
    SliderBack.Size = UDim2.new(1, -24, 0, 8)
    SliderBack.Position = UDim2.new(0, 12, 1, -16)
    SliderBack.BackgroundColor3 = Color3.fromRGB(30, 42, 65)
    SliderBack.ZIndex = 7
    Instance.new("UICorner", SliderBack).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", SliderBack)
    Fill.Size = UDim2.new((defaultVal - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Fill.ZIndex = 8
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local sliding = false
    local function UpdateSlider(input)
        local ratio = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * ratio)
        Fill.Size = UDim2.new(ratio, 0, 1, 0)
        ValLabel.Text = tostring(value)
        callback(value)
    end
    SliderBack.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true UpdateSlider(input) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
    UserInputService.InputChanged:Connect(function(input) if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider(input) end end)
end

local function AddButton(page, text, callback)
    local Card = Instance.new("Frame", page)
    Card.Size = UDim2.new(1, -10, 0, 50)
    Card.BackgroundColor3 = Color3.fromRGB(14, 20, 34)
    Card.BackgroundTransparency = 0.2
    Card.ZIndex = 6
    local CardCorner = Instance.new("UICorner", Card)
    CardCorner.CornerRadius = UDim.new(0, 8)
    table.insert(AllCards, {Frame = Card, Corner = CardCorner})

    local Btn = Instance.new("TextButton", Card)
    Btn.Size = UDim2.new(1, -20, 1, -12)
    Btn.Position = UDim2.new(0, 10, 0, 6)
    Btn.BackgroundColor3 = Color3.fromRGB(0, 130, 240)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 13
    Btn.ZIndex = 7
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

-- Система Тем
local ThemeButtons = {}

local function ApplyTheme(themeName)
    if State.CurrentTheme == themeName then return end
    State.CurrentTheme = themeName

    local mainBg, topBg, sideBg, strokeColor, accentColor, radius
    
    if themeName == "Cosmic" then
        mainBg = Color3.fromRGB(8, 12, 22)
        topBg = Color3.fromRGB(12, 18, 32)
        sideBg = Color3.fromRGB(10, 14, 25)
        strokeColor = Color3.fromRGB(0, 170, 255)
        accentColor = Color3.fromRGB(0, 130, 240)
        radius = 12
        UIStarsFrame.Visible = true
    elseif themeName == "Minecraft" then
        mainBg = Color3.fromRGB(24, 18, 12)
        topBg = Color3.fromRGB(35, 26, 18)
        sideBg = Color3.fromRGB(18, 14, 10)
        strokeColor = Color3.fromRGB(85, 170, 40)
        accentColor = Color3.fromRGB(85, 140, 40)
        radius = 0
        UIStarsFrame.Visible = false
    elseif themeName == "BlackHole" then
        mainBg = Color3.fromRGB(5, 3, 8)
        topBg = Color3.fromRGB(12, 6, 18)
        sideBg = Color3.fromRGB(8, 4, 12)
        strokeColor = Color3.fromRGB(140, 30, 200)
        accentColor = Color3.fromRGB(140, 30, 200)
        radius = 16
        UIStarsFrame.Visible = true
    end

    MainFrame.BackgroundColor3 = mainBg
    TopBar.BackgroundColor3 = topBg
    SideBar.BackgroundColor3 = sideBg
    MainStroke.Color = strokeColor
    MainCorner.CornerRadius = UDim.new(0, radius)
    LogoLabel.TextColor3 = strokeColor

    for _, c in pairs(AllCards) do
        c.Corner.CornerRadius = UDim.new(0, radius > 0 and 8 or 0)
    end

    for _, t in pairs(Tabs) do
        t.Corner.CornerRadius = UDim.new(0, radius > 0 and 6 or 0)
        if t.Btn == ActiveTabBtn then
            t.Btn.BackgroundColor3 = accentColor
        end
    end

    -- Обновление кнопок в меню тем
    for tName, btn in pairs(ThemeButtons) do
        if tName == themeName then
            btn.Text = "✅ " .. tName .. " [ACTIVE]"
            btn.BackgroundColor3 = Color3.fromRGB(50, 60, 70)
            btn.AutoButtonColor = false
        else
            btn.Text = "🎨 Switch to " .. tName
            btn.BackgroundColor3 = accentColor
            btn.AutoButtonColor = true
        end
    end
end

-- Вкладки
local CombatTab = CreateTab("Combat", "⚔️")
AddToggle(CombatTab, "Smart Auto Attack (Kill Aura)", false, function(v) State.KillAura = v end)
AddSlider(CombatTab, "Aura Distance (Studs)", 5, 40, 15, function(v) State.AuraRange = v end)

local MM2Tab = CreateTab("MM2 ESP", "🔪")
AddToggle(MM2Tab, "Role Colors ESP", true, function(v) State.RoleESP = v end)
AddToggle(MM2Tab, "Highlight Dropped Gun", true, function(v) State.GunESP = v end)
AddToggle(MM2Tab, "Danger Radar Pulse", true, function(v) State.DangerRadar = v end)

local MovementTab = CreateTab("Movement", "🏃")
AddToggle(MovementTab, "Enable Custom Speed", false, function(v) State.SpeedEnabled = v end)
AddSlider(MovementTab, "WalkSpeed Value", 16, 250, 50, function(v) State.WalkSpeed = v end)
AddToggle(MovementTab, "Enable Custom Jump", false, function(v) State.JumpEnabled = v end)
AddSlider(MovementTab, "Jump Power", 50, 300, 100, function(v) State.JumpPower = v end)
AddToggle(MovementTab, "Kinetic Dash (Press 'Q')", true, function(v) State.DashEnabled = v end)
AddToggle(MovementTab, "Noclip (Pass Through Walls)", false, function(v) State.Noclip = v end)
AddToggle(MovementTab, "Infinite Jump", false, function(v) State.InfJump = v end)

local ThemesTab = CreateTab("Themes", "🎨")
ThemeButtons["Cosmic"] = AddButton(ThemesTab, "✅ Cosmic [ACTIVE]", function() ApplyTheme("Cosmic") end)
ThemeButtons["Minecraft"] = AddButton(ThemesTab, "🎨 Switch to Minecraft", function() ApplyTheme("Minecraft") end)
ThemeButtons["BlackHole"] = AddButton(ThemesTab, "🎨 Switch to BlackHole", function() ApplyTheme("BlackHole") end)
ThemeButtons["Cosmic"].BackgroundColor3 = Color3.fromRGB(50, 60, 70)

local SettingsTab = CreateTab("Settings", "⚙️")
AddToggle(SettingsTab, "⚡ Turbo FPS Boost", false, function(v)
    State.TurboFPS = v
    if v then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
            if v:IsA("PostEffect") or v:IsA("BlurEffect") then v.Enabled = false end
        end
    end
end)

AddButton(SettingsTab, "🔄 Quick Rejoin Server", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

-- Danger Radar
local RadarFrame = Instance.new("Frame", GLightHub)
RadarFrame.Size = UDim2.new(1, 0, 1, 0)
RadarFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
RadarFrame.BackgroundTransparency = 1
RadarFrame.ZIndex = 150
local RadarStroke = Instance.new("UIStroke", RadarFrame)
RadarStroke.Color = Color3.fromRGB(255, 0, 0)
RadarStroke.Thickness = 6
RadarStroke.Transparency = 1

-- Управление
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Q and State.DashEnabled then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(1e5, 0, 1e5)
            bv.Velocity = hrp.CFrame.LookVector * 120
            task.wait(0.18) bv:Destroy()
        end
    end
    if not gpe and input.KeyCode == Enum.KeyCode.RightControl then MainFrame.Visible = not MainFrame.Visible end
end)

UserInputService.JumpRequest:Connect(function()
    if State.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if State.SpeedEnabled then hum.WalkSpeed = State.WalkSpeed end
        if State.JumpEnabled then
            hum.UseJumpPower = true
            hum.JumpPower = State.JumpPower
        end
        if State.Noclip then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

-- Игровой цикл
task.spawn(function()
    local isRadarTweening = false
    while task.wait(0.1) do
        if not GLightHub.Parent then break end
        local localChar = LocalPlayer.Character
        local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
        local myRole = "Innocent"
        if localChar then
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if localChar:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")) then myRole = "Murder"
            elseif localChar:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")) or localChar:FindFirstChild("Revolver") or (backpack and backpack:FindFirstChild("Revolver")) then myRole = "Sheriff" end
        end
        local murderClose = false

        if State.KillAura and localChar and localChar:FindFirstChildOfClass("Humanoid") then
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if backpack then
                local weapon = backpack:FindFirstChild("Knife") or backpack:FindFirstChild("Gun") or backpack:FindFirstChild("Revolver")
                if weapon then localChar.Humanoid:EquipTool(weapon) end
            end
        end
        local equippedWeapon = localChar and (localChar:FindFirstChild("Knife") or localChar:FindFirstChild("Gun") or localChar:FindFirstChild("Revolver"))

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local targetChar = plr.Character
                local targetRole = "Innocent"
                local backpack = plr:FindFirstChild("Backpack")
                if targetChar:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")) then targetRole = "Murder"
                elseif targetChar:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")) or targetChar:FindFirstChild("Revolver") or (backpack and backpack:FindFirstChild("Revolver")) then targetRole = "Sheriff" end

                local dist = localHRP and (localHRP.Position - targetChar.HumanoidRootPart.Position).Magnitude or 999

                if State.KillAura and localHRP and dist <= State.AuraRange and equippedWeapon then
                    if myRole == "Murder" or (myRole == "Sheriff" and targetRole == "Murder") then
                        equippedWeapon:Activate()
                    end
                end

                if targetRole == "Murder" and dist <= 35 then murderClose = true end

                if State.RoleESP then
                    local color = (targetRole == "Murder" and State.MurderColor) or (targetRole == "Sheriff" and State.SheriffColor) or State.InnocentColor
                    local txt = (targetRole == "Murder" and "[MURDER]") or (targetRole == "Sheriff" and "[SHERIFF]") or "[INNOCENT]"
                    
                    local hl = targetChar:FindFirstChild("GL_ESP") or Instance.new("Highlight", targetChar)
                    hl.Name = "GL_ESP" hl.FillColor = color hl.FillTransparency = 0.4
                    
                    local head = targetChar:FindFirstChild("Head")
                    if head then
                        local bbg = head:FindFirstChild("GL_Name") or Instance.new("BillboardGui", head)
                        bbg.Name = "GL_Name" bbg.Size = UDim2.new(0, 200, 0, 40) bbg.StudsOffset = Vector3.new(0, 2.5, 0) bbg.AlwaysOnTop = true
                        local tag = bbg:FindFirstChild("Tag") or Instance.new("TextLabel", bbg)
                        tag.Name = "Tag" tag.Size = UDim2.new(1,0,1,0) tag.BackgroundTransparency = 1 tag.Font = Enum.Font.GothamBold tag.TextSize = 13 tag.TextStrokeTransparency = 0.3
                        tag.TextColor3 = color tag.Text = plr.DisplayName .. "\n" .. txt .. " [" .. math.floor(dist) .. "m]"
                    end
                end
            end
        end

        if State.DangerRadar and murderClose then
            if not isRadarTweening then isRadarTweening = true TweenService:Create(RadarFrame, TweenInfo.new(0.4), {BackgroundTransparency = 0.85}):Play() TweenService:Create(RadarStroke, TweenInfo.new(0.4), {Transparency = 0.2}):Play() end
        else
            if isRadarTweening then isRadarTweening = false TweenService:Create(RadarFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play() TweenService:Create(RadarStroke, TweenInfo.new(0.4), {Transparency = 1}):Play() end
        end
    end
end)

-- Интро
local IntroFrame = Instance.new("Frame", GLightHub)
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(5, 8, 15)
IntroFrame.ZIndex = 200
IntroFrame.ClipsDescendants = true

task.spawn(function()
    for i = 1, 150 do
        local star = Instance.new("Frame", IntroFrame)
        local sz = math.random(2, 6)
        star.Size = UDim2.new(0, sz, 0, sz)
        local startX, startY = math.random(-20, 120)/100, math.random(-30, 40)/100
        star.Position = UDim2.new(startX, 0, startY, 0)
        star.BackgroundColor3 = Color3.fromRGB(180, 230, 255)
        star.BackgroundTransparency = math.random(10, 60) / 100
        star.ZIndex = 201
        Instance.new("UICorner", star).CornerRadius = UDim.new(1, 0)
        TweenService:Create(star, TweenInfo.new(math.random(25, 55)/10, Enum.EasingStyle.Linear), {Position = UDim2.new(startX + 0.5, 0, startY + 0.8, 0)}):Play()
    end
end)

local WelcomeLabel = Instance.new("TextLabel", IntroFrame)
WelcomeLabel.Size, WelcomeLabel.Position = UDim2.new(1, 0, 0, 60), UDim2.new(0, 0, 0.42, 0)
WelcomeLabel.BackgroundTransparency, WelcomeLabel.TextTransparency = 1, 1
WelcomeLabel.Text = "WELCOME, " .. string.upper(PlayerName)
WelcomeLabel.TextColor3, WelcomeLabel.Font, WelcomeLabel.TextSize = Color3.fromRGB(0, 210, 255), Enum.Font.GothamBold, 32
WelcomeLabel.ZIndex = 206

task.wait(0.3)
TweenService:Create(WelcomeLabel, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
task.wait(2.5)
TweenService:Create(WelcomeLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
local fadeOut = TweenService:Create(IntroFrame, TweenInfo.new(0.8), {BackgroundTransparency = 1})
fadeOut:Play()
fadeOut.Completed:Connect(function() IntroFrame:Destroy() MainFrame.Visible = true end)
