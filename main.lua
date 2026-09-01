local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Global Settings
_G.G_LIGHT_SETTINGS = _G.G_LIGHT_SETTINGS or {
    ESP_Roles = false,
    CustomSpeedEnabled = false,
    SpeedValue = 16,
    InfJump = false,
    DashEnabled = false,
    KillAura = false,
    DangerRadar = false,
    CurrentTheme = "Cosmic",
    FlyEnabled = false,
    FlySpeed = 1
}

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

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

---------------------------------------------------------
-- FALLING STARS INTRO ANIMATION
---------------------------------------------------------
local IntroFrame = Instance.new("Frame")
IntroFrame.Name = "IntroFrame"
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
IntroFrame.BackgroundTransparency = 0
IntroFrame.ZIndex = 100
IntroFrame.ClipsDescendants = true
IntroFrame.Parent = ScreenGui

task.spawn(function()
    for i = 1, 40 do
        task.wait(0.04)
        local star = Instance.new("Frame")
        local width = math.random(30, 90)
        star.Size = UDim2.new(0, width, 0, 2)
        star.Position = UDim2.new(math.random() * 1.2 - 0.1, 0, -0.1, 0)
        star.Rotation = 35
        star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        star.BorderSizePixel = 0
        star.ZIndex = 101
        star.Parent = IntroFrame

        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 190, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        }
        gradient.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.7, 0.2),
            NumberSequenceKeypoint.new(1, 0)
        }
        gradient.Parent = star

        local fallDuration = math.random(12, 22) / 10
        local endPos = UDim2.new(star.Position.X.Scale - 0.4, 0, 1.2, 0)
        
        TweenService:Create(star, TweenInfo.new(fallDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = endPos
        }):Play()

        task.delay(fallDuration, function()
            star:Destroy()
        end)
    end
end)

local IntroText = Instance.new("TextLabel")
IntroText.Size = UDim2.new(1, 0, 1, 0)
IntroText.BackgroundTransparency = 1
IntroText.Text = "✨ G LIGHT HUB v5.6 ✨"
IntroText.TextColor3 = Color3.fromRGB(0, 190, 255)
IntroText.TextSize = 30
IntroText.Font = Enum.Font.GothamBold
IntroText.TextTransparency = 1
IntroText.ZIndex = 102
IntroText.Parent = IntroFrame

TweenService:Create(IntroText, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
task.wait(2.2)
TweenService:Create(IntroText, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
TweenService:Create(IntroFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
task.wait(0.8)
IntroFrame:Destroy()

---------------------------------------------------------
-- MAIN GUI DESIGN WITH BACKGROUND STARS
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

-- STARFIELD BACKGROUND
local StarsContainer = Instance.new("Frame")
StarsContainer.Name = "StarsContainer"
StarsContainer.Size = UDim2.new(1, 0, 1, 0)
StarsContainer.BackgroundTransparency = 1
StarsContainer.ZIndex = 1
StarsContainer.Parent = MainFrame

for i = 1, 150 do
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
    
    task.spawn(function()
        while star and star.Parent do
            local tweenTime = math.random(15, 35) / 10
            local targetAlpha = math.random(10, 90) / 100
            TweenService:Create(star, TweenInfo.new(tweenTime, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = targetAlpha}):Play()
            task.wait(tweenTime)
        end
    end)
end

-- Ambient Glow
local Glow1 = Instance.new("ImageLabel")
Glow1.Size = UDim2.new(0, 250, 0, 250)
Glow1.Position = UDim2.new(0, -60, 0, -60)
Glow1.BackgroundTransparency = 1
Glow1.Image = "rbxassetid://5028857472"
Glow1.ImageColor3 = Color3.fromRGB(0, 150, 255)
Glow1.ImageTransparency = 0.85
Glow1.ZIndex = 2
Glow1.Parent = MainFrame

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
Title.Text = "✨ G LIGHT HUB  <font color='#8C00FF'>v5.6</font> ✨"
Title.RichText = true
Title.TextColor3 = Themes.Cosmic.Text
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 4
Title.Parent = Header

-- Close Button
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

-- Sidebar Navigation
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

-- Content Container
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
createPage("Themes")
createPage("Server")

Pages["MM2"].Visible = true

local tabIcons = {
    MM2 = "🗡️",
    Movement = "⚡",
    Combat = "🎯",
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
createTabButton("Themes")
createTabButton("Server")

---------------------------------------------------------
-- UI ELEMENTS (TOGGLES & SLIDERS)
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
-- FILL PAGES
---------------------------------------------------------
createToggle(Pages["MM2"], "Role ESP (Murderer/Sheriff)", "ESP_Roles")

createToggle(Pages["Movement"], "Custom WalkSpeed", "CustomSpeedEnabled", function(v)
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)
createSlider(Pages["Movement"], "Speed Value", 16, 120, 16, function(v)
    _G.G_LIGHT_SETTINGS.SpeedValue = v
end)
createToggle(Pages["Movement"], "Infinite Jump", "InfJump")
createToggle(Pages["Movement"], "Dash (Press Q)", "DashEnabled")

-- FLY MODE WITH SPEED SLIDER
createToggle(Pages["Movement"], "Fly Mode", "FlyEnabled")
createSlider(Pages["Movement"], "Fly Speed Multiplier", 1, 10, 1, function(v)
    _G.G_LIGHT_SETTINGS.FlySpeed = v
end)

createToggle(Pages["Combat"], "Kill Aura", "KillAura")
createToggle(Pages["Combat"], "Murderer Radar Warning", "DangerRadar")

-- SERVER TAB
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

-- THEMES TAB
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
-- FIXED MM2 ESP & RADAR LOGIC
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

-- Усовершенствованная функция определения роли MM2
local function getMM2Role(player)
    if not player or not player.Character then return "Innocent" end
    local char = player.Character
    local backpack = player:FindFirstChild("Backpack")

    local function checkItem(container)
        if not container then return nil end
        for _, item in pairs(container:GetChildren()) do
            if item:IsA("Tool") then
                local name = item.Name:lower()
                if name:find("knife") or name:find("blade") or item:FindFirstChild("KnifeServer") then
                    return "Murderer"
                elseif name:find("revolver") or name:find("gun") or name:find("sheriff") or item:FindFirstChild("GunServer") then
                    return "Sheriff"
                end
            end
        end
        return nil
    end

    local roleFromChar = checkItem(char)
    if roleFromChar then return roleFromChar end

    local roleFromBackpack = checkItem(backpack)
    if roleFromBackpack then return roleFromBackpack end

    return "Innocent"
end

local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local highlight = char:FindFirstChild("GLightESP")
            
            if _G.G_LIGHT_SETTINGS.ESP_Roles then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "GLightESP"
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Adornee = char
                    highlight.Parent = char
                end
                
                local role = getMM2Role(player)
                if role == "Murderer" then
                    highlight.FillColor = Color3.fromRGB(255, 40, 40)
                    highlight.OutlineColor = Color3.fromRGB(255, 100, 100)
                elseif role == "Sheriff" then
                    highlight.FillColor = Color3.fromRGB(0, 140, 255)
                    highlight.OutlineColor = Color3.fromRGB(100, 180, 255)
                else
                    highlight.FillColor = Color3.fromRGB(40, 255, 120)
                    highlight.OutlineColor = Color3.fromRGB(120, 255, 170)
                end
                highlight.FillTransparency = 0.4
                highlight.OutlineTransparency = 0
                highlight.Enabled = true
            else
                if highlight then 
                    highlight:Destroy() 
                end
            end
        end
    end
end

-- RUNTIME LOOPS
local bodyVel, bodyGyro
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        
        -- Fly Mode Logic
        if _G.G_LIGHT_SETTINGS.FlyEnabled then
            if not bodyVel then
                bodyVel = Instance.new("BodyVelocity")
                bodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                bodyVel.Parent = hrp
            end
            if not bodyGyro then
                bodyGyro = Instance.new("BodyGyro")
                bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                bodyGyro.P = 9e4
                bodyGyro.Parent = hrp
            end
            
            local cam = Workspace.CurrentCamera
            bodyGyro.CFrame = cam.CFrame
            
            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            bodyVel.Velocity = moveDir * (_G.G_LIGHT_SETTINGS.FlySpeed * 25)
        else
            if bodyVel then bodyVel:Destroy() bodyVel = nil end
            if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        end
        
        -- Speed
        if _G.G_LIGHT_SETTINGS.CustomSpeedEnabled then
            hum.WalkSpeed = _G.G_LIGHT_SETTINGS.SpeedValue
        end

        -- Kill Aura
        if _G.G_LIGHT_SETTINGS.KillAura then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                for _, target in pairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        local targetHrp = target.Character.HumanoidRootPart
                        if (hrp.Position - targetHrp.Position).Magnitude <= 15 then
                            tool:Activate()
                            if firetouchinterest and tool:FindFirstChild("Handle") then
                                firetouchinterest(tool.Handle, targetHrp, 0)
                                firetouchinterest(tool.Handle, targetHrp, 1)
                            end
                        end
                    end
                end
            end
        end

        -- Danger Radar
        if _G.G_LIGHT_SETTINGS.DangerRadar then
            local murdererFound = false
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and getMM2Role(player) == "Murderer" and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    if (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 40 then
                        murdererFound = true
                        break
                    end
                end
            end
            RadarWarning.Visible = murdererFound
        else
            RadarWarning.Visible = false
        end
    end
    
    updateESP()
end)

-- Jump & Key Binds
UserInputService.JumpRequest:Connect(function()
    if _G.G_LIGHT_SETTINGS.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanState.Jumping)
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    elseif input.KeyCode == Enum.KeyCode.Q and _G.G_LIGHT_SETTINGS.DashEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 15)
        end
    end
end)
