local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

-- Global Settings
_G.G_LIGHT_SETTINGS = _G.G_LIGHT_SETTINGS or {
    ESP_Roles = false,
    AutoCoinFarm = false,
    CoinFarmSpeed = 25,
    CustomSpeedEnabled = false,
    SpeedValue = 16,
    InfJump = false,
    DashEnabled = false,
    NoclipEnabled = false,
    KillAura = false,
    DangerRadar = false,
    CurrentTheme = "Cosmic",
    FlyEnabled = false,
    FlySpeed = 1,
    AntiKick = true,
    AntiAFK = true
}

---------------------------------------------------------
-- ANTI-KICK & ANTI-BAN PROTECTION SYSTEM
---------------------------------------------------------
task.spawn(function()
    if hookmetamethod then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if _G.G_LIGHT_SETTINGS.AntiKick and (method == "Kick" or method == "kick") and self == LocalPlayer then
                warn("[G LIGHT HUB Protection]: Blocked server/script kick attempt!")
                return nil
            end
            return oldNamecall(self, ...)
        end)
    end

    if LocalPlayer.Kick then
        local oldKick = LocalPlayer.Kick
        LocalPlayer.Kick = function(self, ...)
            if _G.G_LIGHT_SETTINGS.AntiKick then
                warn("[G LIGHT HUB Protection]: Blocked direct kick call!")
                return nil
            end
            return oldKick(self, ...)
        end
    end

    LocalPlayer.Idled:Connect(function()
        if _G.G_LIGHT_SETTINGS.AntiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end)

local Themes = {
    Cosmic = {
        Background = Color3.fromRGB(15, 17, 28),
        Header = Color3.fromRGB(24, 28, 48),
        Sidebar = Color3.fromRGB(18, 20, 34),
        Card = Color3.fromRGB(28, 32, 54),
        Accent = Color3.fromRGB(0, 190, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(160, 170, 200),
        CornerRadius = UDim.new(0, 12)
    },
    BlackHole = {
        Background = Color3.fromRGB(12, 10, 18),
        Header = Color3.fromRGB(24, 18, 36),
        Sidebar = Color3.fromRGB(16, 12, 24),
        Card = Color3.fromRGB(28, 20, 42),
        Accent = Color3.fromRGB(170, 0, 255),
        Text = Color3.fromRGB(250, 240, 255),
        SubText = Color3.fromRGB(170, 140, 190),
        CornerRadius = UDim.new(0, 12)
    },
    Cyber = {
        Background = Color3.fromRGB(15, 23, 20),
        Header = Color3.fromRGB(22, 38, 32),
        Sidebar = Color3.fromRGB(18, 28, 24),
        Card = Color3.fromRGB(25, 45, 38),
        Accent = Color3.fromRGB(0, 255, 170),
        Text = Color3.fromRGB(240, 255, 250),
        SubText = Color3.fromRGB(140, 190, 175),
        CornerRadius = UDim.new(0, 12)
    }
}

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GLightHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

---------------------------------------------------------
-- ULTRA HIGH-QUALITY INTRO ANIMATION
---------------------------------------------------------
local IntroFrame = Instance.new("Frame")
IntroFrame.Name = "IntroFrame"
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.Position = UDim2.new(0, 0, 0, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
IntroFrame.BackgroundTransparency = 0
IntroFrame.ZIndex = 100
IntroFrame.ClipsDescendants = true
IntroFrame.Parent = ScreenGui

-- Ambient Background Particle Layer (Twinkling Stars)
local bgStarsActive = true
task.spawn(function()
    for i = 1, 120 do
        local star = Instance.new("Frame")
        local sz = math.random(1, 3)
        star.Size = UDim2.new(0, sz, 0, sz)
        star.Position = UDim2.new(math.random(), 0, math.random(), 0)
        star.BackgroundColor3 = Color3.fromRGB(220, 240, 255)
        star.BackgroundTransparency = math.random(4, 9) / 10
        star.BorderSizePixel = 0
        star.ZIndex = 101
        star.Parent = IntroFrame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = star

        task.spawn(function()
            while bgStarsActive and star.Parent do
                local targetAlpha = math.random(2, 9) / 10
                local dur = math.random(10, 25) / 10
                TweenService:Create(star, TweenInfo.new(dur, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    BackgroundTransparency = targetAlpha
                }):Play()
                task.wait(dur)
            end
        end)
    end
end)

-- Intensive Falling Shooting Stars Generator
local starSpawning = true
task.spawn(function()
    local starColors = {
        Color3.fromRGB(0, 200, 255),
        Color3.fromRGB(180, 100, 255),
        Color3.fromRGB(0, 255, 180),
        Color3.fromRGB(255, 255, 255)
    }

    while starSpawning do
        task.wait(0.02)
        local star = Instance.new("Frame")
        local width = math.random(40, 120)
        star.Size = UDim2.new(0, width, 0, 2)
        star.Position = UDim2.new(math.random() * 1.3 - 0.15, 0, -0.15, 0)
        star.Rotation = 35
        star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        star.BorderSizePixel = 0
        star.ZIndex = 102
        star.Parent = IntroFrame

        local mainColor = starColors[math.random(1, #starColors)]

        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, mainColor),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        }
        gradient.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.6, 0.15),
            NumberSequenceKeypoint.new(1, 0)
        }
        gradient.Parent = star

        local fallDuration = math.random(8, 18) / 10
        local endPos = UDim2.new(star.Position.X.Scale - 0.5, 0, 1.3, 0)

        TweenService:Create(star, TweenInfo.new(fallDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = endPos
        }):Play()

        task.delay(fallDuration, function()
            star:Destroy()
        end)
    end
end)

-- Central Text + Neon Glow Effect Frame
local TextContainer = Instance.new("Frame")
TextContainer.Size = UDim2.new(1, 0, 0, 100)
TextContainer.Position = UDim2.new(0, 0, 0.5, -50)
TextContainer.BackgroundTransparency = 1
TextContainer.ZIndex = 105
TextContainer.Parent = IntroFrame

-- Neon Glow Behind Text
local TextGlow = Instance.new("TextLabel")
TextGlow.Size = UDim2.new(1, 0, 1, 0)
TextGlow.BackgroundTransparency = 1
TextGlow.Text = "G_light present..."
TextGlow.TextColor3 = Color3.fromRGB(0, 190, 255)
TextGlow.TextSize = 32
TextGlow.Font = Enum.Font.GothamBold
TextGlow.TextTransparency = 0.7
TextGlow.ZIndex = 104
TextGlow.Parent = TextContainer

local IntroText = Instance.new("TextLabel")
IntroText.Size = UDim2.new(1, 0, 1, 0)
IntroText.BackgroundTransparency = 1
IntroText.Text = "G_light present..."
IntroText.TextColor3 = Color3.fromRGB(255, 255, 255)
IntroText.TextSize = 28
IntroText.Font = Enum.Font.GothamBold
IntroText.TextTransparency = 1
IntroText.ZIndex = 105
IntroText.Parent = TextContainer

-- Light Flash Pulse Overlay
local FlashOverlay = Instance.new("Frame")
FlashOverlay.Size = UDim2.new(1, 0, 1, 0)
FlashOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FlashOverlay.BackgroundTransparency = 1
FlashOverlay.ZIndex = 110
FlashOverlay.Parent = ScreenGui

-- Pulse Loop for Dynamic Breathing Effect
local pulsing = true
task.spawn(function()
    while pulsing do
        TweenService:Create(TextContainer, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(1, 0, 0, 110)
        }):Play()
        task.wait(1.2)
        if not pulsing then break end
        TweenService:Create(TextContainer, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(1, 0, 0, 95)
        }):Play()
        task.wait(1.2)
    end
end)

-- Intro Sequences Timeline with Sound & Visual Tweaks
task.spawn(function()
    TweenService:Create(IntroText, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(TextGlow, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0.6}):Play()
    task.wait(5)

    TweenService:Create(IntroText, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    TweenService:Create(TextGlow, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    task.wait(0.4)

    IntroText.Text = "A new best hub for mm2"
    TextGlow.Text = "A new best hub for mm2"
    TextGlow.TextColor3 = Color3.fromRGB(180, 100, 255)
    IntroText.TextColor3 = Color3.fromRGB(240, 220, 255)

    TweenService:Create(IntroText, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(TextGlow, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0.5}):Play()
    task.wait(5)

    TweenService:Create(IntroText, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    TweenService:Create(TextGlow, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    task.wait(0.3)

    TweenService:Create(FlashOverlay, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.75}):Play()
    task.delay(0.15, function()
        TweenService:Create(FlashOverlay, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    end)

    IntroText.Text = "G_LIGHT HUB!!!"
    TextGlow.Text = "G_LIGHT HUB!!!"
    IntroText.TextSize = 36
    TextGlow.TextSize = 42
    TextGlow.TextColor3 = Color3.fromRGB(0, 255, 170)
    IntroText.TextColor3 = Color3.fromRGB(255, 255, 255)

    TweenService:Create(IntroText, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(TextGlow, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {TextTransparency = 0.3}):Play()
    task.wait(1)

    pulsing = false
    starSpawning = false
    bgStarsActive = false

    TweenService:Create(TextContainer, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(1.3, 0, 0, 140)
    }):Play()
    TweenService:Create(IntroText, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    TweenService:Create(TextGlow, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    
    TweenService:Create(IntroFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    }):Play()

    task.wait(0.7)
    IntroFrame:Destroy()
    FlashOverlay:Destroy()
end)

---------------------------------------------------------
-- MAIN GUI
---------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 360)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
MainFrame.BackgroundColor3 = Themes.Cosmic.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = Themes.Cosmic.CornerRadius
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(45, 52, 80)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

-- STARFIELD BACKGROUND FOR MAIN GUI
local StarsContainer = Instance.new("Frame")
StarsContainer.Name = "StarsContainer"
StarsContainer.Size = UDim2.new(1, 0, 1, 0)
StarsContainer.BackgroundTransparency = 1
StarsContainer.ZIndex = 1
StarsContainer.Parent = MainFrame

for i = 1, 100 do
    local star = Instance.new("Frame")
    local size = math.random(1, 3)
    star.Size = UDim2.new(0, size, 0, size)
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    star.BackgroundTransparency = math.random(30, 85) / 100
    star.BorderSizePixel = 0
    star.ZIndex = 1
    star.Parent = StarsContainer
    
    local starCorner = Instance.new("UICorner")
    starCorner.CornerRadius = UDim.new(1, 0)
    starCorner.Parent = star
end

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = Themes.Cosmic.Header
Header.BorderSizePixel = 0
Header.ZIndex = 3
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = Themes.Cosmic.CornerRadius
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "✨ G LIGHT HUB  <font color='#8C00FF'>v6.0</font> 🛡️"
Title.RichText = true
Title.TextColor3 = Themes.Cosmic.Text
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 4
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.ZIndex = 4
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 145, 1, -48)
Sidebar.Position = UDim2.new(0, 0, 0, 48)
Sidebar.BackgroundColor3 = Themes.Cosmic.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 3
Sidebar.Parent = MainFrame

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 10)
SidebarPadding.PaddingLeft = UDim.new(0, 8)
SidebarPadding.PaddingRight = UDim.new(0, 8)
SidebarPadding.Parent = Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.Parent = Sidebar
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 6)

-- Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -155, 1, -56)
Content.Position = UDim2.new(0, 150, 0, 52)
Content.BackgroundTransparency = 1
Content.ZIndex = 3
Content.Parent = MainFrame

local Pages = {}
local TabButtons = {}

local function createPage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -6, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Themes.Cosmic.Accent
    Page.ZIndex = 3
    Page.Parent = Content
    
    local List = Instance.new("UIListLayout")
    List.Parent = Page
    List.SortOrder = Enum.SortOrder.LayoutOrder
    List.Padding = UDim.new(0, 8)
    
    Pages[name] = Page
    return Page
end

createPage("MM2")
createPage("Movement")
createPage("Combat")
createPage("Security")
createPage("Themes")
createPage("Server")

Pages["MM2"].Visible = true

local tabIcons = {
    MM2 = "🗡️",
    Movement = "⚡",
    Combat = "🎯",
    Security = "🛡️",
    Themes = "🎨",
    Server = "🌐"
}

local function createTabButton(name)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 36)
    Btn.BackgroundColor3 = (name == "MM2") and Themes.Cosmic.Card or Color3.fromRGB(0, 0, 0)
    Btn.BackgroundTransparency = (name == "MM2") and 0 or 1
    Btn.Text = "  " .. (tabIcons[name] or "") .. "  " .. name
    Btn.TextColor3 = (name == "MM2") and Themes.Cosmic.Accent or Themes.Cosmic.SubText
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.ZIndex = 4
    Btn.Parent = Sidebar
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Btn
    
    TabButtons[name] = Btn
    
    Btn.MouseButton1Click:Connect(function()
        for pageName, page in pairs(Pages) do
            page.Visible = (pageName == name)
        end
        for btnName, button in pairs(TabButtons) do
            local isSelected = (btnName == name)
            local currentTheme = Themes[_G.G_LIGHT_SETTINGS.CurrentTheme]
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundTransparency = isSelected and 0 or 1,
                TextColor3 = isSelected and currentTheme.Accent or currentTheme.SubText
            }):Play()
            button.BackgroundColor3 = currentTheme.Card
        end
    end)
end

createTabButton("MM2")
createTabButton("Movement")
createTabButton("Combat")
createTabButton("Security")
createTabButton("Themes")
createTabButton("Server")

---------------------------------------------------------
-- UI HELPERS
---------------------------------------------------------
local function createToggle(page, text, settingKey, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -6, 0, 42)
    Frame.BackgroundColor3 = Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].Card
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 4
    Frame.Parent = page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].Text
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 5
    Label.Parent = Frame
    
    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 42, 0, 22)
    Switch.Position = UDim2.new(1, -52, 0.5, -11)
    Switch.BackgroundColor3 = _G.G_LIGHT_SETTINGS[settingKey] and Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].Accent or Color3.fromRGB(45, 50, 68)
    Switch.ZIndex = 5
    Switch.Parent = Frame
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = _G.G_LIGHT_SETTINGS[settingKey] and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.ZIndex = 6
    Circle.Parent = Switch
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle
    
    local ClickBtn = Instance.new("TextButton")
    ClickBtn.Size = UDim2.new(1, 0, 1, 0)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Text = ""
    ClickBtn.ZIndex = 7
    ClickBtn.Parent = Frame
    
    ClickBtn.MouseButton1Click:Connect(function()
        _G.G_LIGHT_SETTINGS[settingKey] = not _G.G_LIGHT_SETTINGS[settingKey]
        local enabled = _G.G_LIGHT_SETTINGS[settingKey]
        
        TweenService:Create(Switch, TweenInfo.new(0.2), {
            BackgroundColor3 = enabled and Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].Accent or Color3.fromRGB(45, 50, 68)
        }):Play()
        TweenService:Create(Circle, TweenInfo.new(0.2), {
            Position = enabled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        }):Play()
        
        if callback then callback(enabled) end
    end)
end

local function createSlider(page, text, minVal, maxVal, defaultVal, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -6, 0, 50)
    Frame.BackgroundColor3 = Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].Card
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 4
    Frame.Parent = page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 22)
    Label.Position = UDim2.new(0, 12, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].Text
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 5
    Label.Parent = Frame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0.3, 0, 0, 22)
    ValueLabel.Position = UDim2.new(0.7, -12, 0, 4)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(defaultVal)
    ValueLabel.TextColor3 = Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].Accent
    ValueLabel.TextSize = 13
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.ZIndex = 5
    ValueLabel.Parent = Frame
    
    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(1, -24, 0, 6)
    SliderBack.Position = UDim2.new(0, 12, 0, 32)
    SliderBack.BackgroundColor3 = Color3.fromRGB(45, 50, 68)
    SliderBack.BorderSizePixel = 0
    SliderBack.ZIndex = 5
    SliderBack.Parent = Frame
    
    local SliderBackCorner = Instance.new("UICorner")
    SliderBackCorner.CornerRadius = UDim.new(1, 0)
    SliderBackCorner.Parent = SliderBack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((defaultVal - minVal)/(maxVal - minVal), 0, 1, 0)
    SliderFill.BackgroundColor3 = Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].Accent
    SliderFill.BorderSizePixel = 0
    SliderFill.ZIndex = 6
    SliderFill.Parent = SliderBack
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    
    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
        local val = math.floor(minVal + (maxVal - minVal) * pos)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        ValueLabel.Text = tostring(val)
        if callback then callback(val) end
    end
    
    SliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)
end

---------------------------------------------------------
-- POPULATE PAGES
---------------------------------------------------------
createToggle(Pages["MM2"], "Role & Coin ESP", "ESP_Roles")
createToggle(Pages["MM2"], "Auto Money Farm (Fly Bypass)", "AutoCoinFarm")
createSlider(Pages["MM2"], "Coin Farm Speed", 10, 50, 25, function(v)
    _G.G_LIGHT_SETTINGS.CoinFarmSpeed = v
end)

createToggle(Pages["Movement"], "Custom WalkSpeed", "CustomSpeedEnabled", function(v)
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)
createSlider(Pages["Movement"], "Speed Value", 16, 120, 16, function(v)
    _G.G_LIGHT_SETTINGS.SpeedValue = v
end)
createToggle(Pages["Movement"], "Safe Inf Jump", "InfJump")
createToggle(Pages["Movement"], "Dash (Press Q)", "DashEnabled")
createToggle(Pages["Movement"], "Noclip (Walk Through Walls)", "NoclipEnabled")

createToggle(Pages["Movement"], "Bypass Fly Mode", "FlyEnabled")
createSlider(Pages["Movement"], "Fly Speed Multiplier", 1, 10, 1, function(v)
    _G.G_LIGHT_SETTINGS.FlySpeed = v
end)

createToggle(Pages["Combat"], "Kill Aura", "KillAura")
createToggle(Pages["Combat"], "Murderer Radar Warning", "DangerRadar")

createToggle(Pages["Security"], "Anti-Kick Bypass", "AntiKick")
createToggle(Pages["Security"], "Anti-AFK (No Disconnect)", "AntiAFK")

local RejoinBtn = Instance.new("TextButton")
RejoinBtn.Size = UDim2.new(1, -6, 0, 42)
RejoinBtn.BackgroundColor3 = Themes.Cosmic.Card
RejoinBtn.BorderSizePixel = 0
RejoinBtn.Text = "🔄 Rejoin Current Server"
RejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinBtn.Font = Enum.Font.GothamBold
RejoinBtn.TextSize = 13
RejoinBtn.ZIndex = 4
RejoinBtn.Parent = Pages["Server"]

local RejoinCorner = Instance.new("UICorner")
RejoinCorner.CornerRadius = UDim.new(0, 8)
RejoinCorner.Parent = RejoinBtn

RejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

local function applyTheme(themeName)
    if not Themes[themeName] then return end
    _G.G_LIGHT_SETTINGS.CurrentTheme = themeName
    local theme = Themes[themeName]
    
    MainFrame.BackgroundColor3 = theme.Background
    Header.BackgroundColor3 = theme.Header
    Sidebar.BackgroundColor3 = theme.Sidebar
    MainCorner.CornerRadius = theme.CornerRadius
    HeaderCorner.CornerRadius = theme.CornerRadius
    
    for btnName, btn in pairs(TabButtons) do
        local isSelected = Pages[btnName] and Pages[btnName].Visible
        btn.BackgroundColor3 = isSelected and theme.Card or Color3.fromRGB(0, 0, 0)
        btn.TextColor3 = isSelected and theme.Accent or theme.SubText
    end
end

for themeName, _ in pairs(Themes) do
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -6, 0, 40)
    Btn.BackgroundColor3 = Themes.Cosmic.Card
    Btn.BorderSizePixel = 0
    Btn.Text = "Theme: " .. themeName
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 13
    Btn.ZIndex = 4
    Btn.Parent = Pages["Themes"]
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        applyTheme(themeName)
    end)
end

---------------------------------------------------------
-- AUTO MONEY FARM LOGIC (FLY BYPASS + NOCLIP)
---------------------------------------------------------
local function getClosestCoin()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = char.HumanoidRootPart

    local closestCoin = nil
    local shortestDistance = math.huge

    for _, obj in ipairs(Workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if (name == "coin" or name == "coincontainer" or name == "goldcoin" or obj:FindFirstChild("CoinID")) and not obj:IsDescendantOf(char) then
            local coinPart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if coinPart and (obj:FindFirstChild("TouchInterest") or coinPart:FindFirstChild("TouchInterest")) then
                local dist = (hrp.Position - coinPart.Position).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closestCoin = coinPart
                end
            end
        end
    end

    return closestCoin
end

-- Noclip loop for Farm & Noclip Mode
RunService.Stepped:Connect(function()
    if _G.G_LIGHT_SETTINGS.AutoCoinFarm or _G.G_LIGHT_SETTINGS.NoclipEnabled then
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Fly Farm Loop
RunService.Heartbeat:Connect(function(deltaTime)
    if not _G.G_LIGHT_SETTINGS.AutoCoinFarm then return end

    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    humanoid:ChangeState(Enum.HumanoidStateType.Swimming)

    local targetCoin = getClosestCoin()
    if targetCoin then
        local targetPos = targetCoin.Position
        local direction = (targetPos - hrp.Position).Unit
        local distance = (targetPos - hrp.Position).Magnitude

        if distance > 1.5 then
            local speed = _G.G_LIGHT_SETTINGS.CoinFarmSpeed or 25
            hrp.CFrame = hrp.CFrame + (direction * math.min(distance, speed * deltaTime * 8))
            hrp.Velocity = Vector3.new(0, 0, 0)
        else
            hrp.CFrame = CFrame.new(targetPos)
        end
    end
end)

---------------------------------------------------------
-- MM2 ESP SYSTEM
---------------------------------------------------------
local RadarWarning = Instance.new("TextLabel")
RadarWarning.Name = "DangerRadarWarning"
RadarWarning.Size = UDim2.new(0, 320, 0, 40)
RadarWarning.Position = UDim2.new(0.5, -160, 0.12, 0)
RadarWarning.BackgroundColor3 = Color3.fromRGB(220, 30, 50)
RadarWarning.Text = "⚠️ DANGER: MURDERER NEARBY! ⚠️"
RadarWarning.TextColor3 = Color3.fromRGB(255, 255, 255)
RadarWarning.TextSize = 14
RadarWarning.Font = Enum.Font.GothamBold
RadarWarning.Visible = false
RadarWarning.ZIndex = 50
RadarWarning.Parent = ScreenGui

local RadarCorner = Instance.new("UICorner")
RadarCorner.CornerRadius = UDim.new(0, 8)
RadarCorner.Parent = RadarWarning

local function getMM2Role(player)
    if not player or not player.Character then return "Innocent" end
    
    local char = player.Character
    local backpack = player:FindFirstChild("Backpack")

    local function scanContainer(container)
        if not container then return nil end
        for _, item in pairs(container:GetChildren()) do
            if item:IsA("Tool") then
                local itemName = item.Name:lower()
                
                if itemName:find("knife") or itemName:find("blade") or itemName:find("scythe") or item:FindFirstChild("KnifeServer") or item:FindFirstChild("KnifeClient") then
                    return "Murderer"
                end
                
                if itemName:find("gun") or itemName:find("revolver") or itemName:find("sheriff") or itemName:find("luger") or item:FindFirstChild("GunServer") or item:FindFirstChild("GunClient") then
                    return "Sheriff"
                end
            end
        end
        return nil
    end

    return scanContainer(char) or scanContainer(backpack) or "Innocent"
end

local function applyCoinESP(obj)
    if not _G.G_LIGHT_SETTINGS.ESP_Roles then return end
    if obj:FindFirstChild("GLightCoinHighlight") then return end

    local hl = Instance.new("Highlight")
    hl.Name = "GLightCoinHighlight"
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillColor = Color3.fromRGB(255, 215, 0)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.2
    hl.OutlineTransparency = 0
    hl.Adornee = obj
    hl.Parent = obj
end

local function clearCoinESP(obj)
    local hl = obj:FindFirstChild("GLightCoinHighlight")
    if hl then hl:Destroy() end
end

task.spawn(function()
    while task.wait(0.2) do
        if _G.G_LIGHT_SETTINGS.ESP_Roles then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local char = player.Character
                    local hl = char:FindFirstChild("GLightESP")
                    
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "GLightESP"
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Adornee = char
                        hl.Parent = char
                    end
                    
                    local role = getMM2Role(player)
                    if role == "Murderer" then
                        hl.FillColor = Color3.fromRGB(255, 30, 30)
                        hl.OutlineColor = Color3.fromRGB(255, 100, 100)
                    elseif role == "Sheriff" then
                        hl.FillColor = Color3.fromRGB(0, 150, 255)
                        hl.OutlineColor = Color3.fromRGB(120, 200, 255)
                    else
                        hl.FillColor = Color3.fromRGB(50, 255, 100)
                        hl.OutlineColor = Color3.fromRGB(150, 255, 180)
                    end
                    hl.FillTransparency = 0.35
                    hl.OutlineTransparency = 0
                    hl.Enabled = true
                end
            end
            
            for _, desc in pairs(Workspace:GetDescendants()) do
                local name = desc.Name:lower()
                if (name == "coincontainer" or name == "coin" or name == "goldcoin") and (desc:IsA("Model") or desc:IsA("BasePart")) then
                    if not desc:IsDescendantOf(LocalPlayer.Character) then
                        applyCoinESP(desc)
                    end
                end
            end
        else
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("GLightESP") then
                    player.Character.GLightESP:Destroy()
                end
            end
            for _, desc in pairs(Workspace:GetDescendants()) do
                clearCoinESP(desc)
            end
        end
    end
end)
