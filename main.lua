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
        Background = Color3.fromRGB(15, 15, 25),
        Header = Color3.fromRGB(25, 25, 40),
        Accent = Color3.fromRGB(0, 170, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 210),
        CornerRadius = UDim.new(0, 10)
    },
    BlackHole = {
        Background = Color3.fromRGB(10, 5, 15),
        Header = Color3.fromRGB(20, 10, 30),
        Accent = Color3.fromRGB(140, 0, 255),
        Text = Color3.fromRGB(240, 220, 255),
        SubText = Color3.fromRGB(150, 120, 180),
        CornerRadius = UDim.new(0, 12)
    },
    Minecraft = {
        Background = Color3.fromRGB(40, 40, 40),
        Header = Color3.fromRGB(60, 60, 60),
        Accent = Color3.fromRGB(85, 255, 85),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(170, 170, 170),
        CornerRadius = UDim.new(0, 0)
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

-- ANIMATED WELCOME INTRO OVERLAY
local IntroFrame = Instance.new("Frame")
IntroFrame.Name = "IntroFrame"
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
IntroFrame.BackgroundTransparency = 0
IntroFrame.ZIndex = 100
IntroFrame.Parent = ScreenGui

local IntroText = Instance.new("TextLabel")
IntroText.Size = UDim2.new(1, 0, 1, 0)
IntroText.BackgroundTransparency = 1
IntroText.Text = "WELCOME TO G LIGHT HUB v5.0"
IntroText.TextColor3 = Color3.fromRGB(0, 170, 255)
IntroText.TextSize = 28
IntroText.Font = Enum.Font.SourceSansBold
IntroText.TextTransparency = 1
IntroText.ZIndex = 101
IntroText.Parent = IntroFrame

task.spawn(function()
    TweenService:Create(IntroText, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    task.wait(1.8)
    TweenService:Create(IntroText, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    TweenService:Create(IntroFrame, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    task.wait(1)
    IntroFrame:Destroy()
end)

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 530, 0, 350)
MainFrame.Position = UDim2.new(0.5, -265, 0.5, -175)
MainFrame.BackgroundColor3 = Themes.Cosmic.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = Themes.Cosmic.CornerRadius
MainCorner.Parent = MainFrame

-- STARFIELD ANIMATED BACKGROUND (200+ STARS)
local StarsContainer = Instance.new("Frame")
StarsContainer.Name = "StarsContainer"
StarsContainer.Size = UDim2.new(1, 0, 1, 0)
StarsContainer.BackgroundTransparency = 1
StarsContainer.ZIndex = 1
StarsContainer.Parent = MainFrame

for i = 1, 200 do
    local star = Instance.new("Frame")
    local size = math.random(1, 3)
    star.Size = UDim2.new(0, size, 0, size)
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    star.BackgroundTransparency = math.random(30, 80) / 100
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

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Themes.Cosmic.Header
Header.BorderSizePixel = 0
Header.ZIndex = 2
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = Themes.Cosmic.CornerRadius
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "✨ G LIGHT HUB v5.0 ✨"
Title.TextColor3 = Themes.Cosmic.Accent
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 3
Title.Parent = Header

-- Sidebar Navigation
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 2
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.Parent = Sidebar
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 5)

-- Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -135, 1, -47)
Content.Position = UDim2.new(0, 135, 0, 47)
Content.BackgroundTransparency = 1
Content.ZIndex = 2
Content.Parent = MainFrame

local Pages = {}

local function createPage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -10, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 4
    Page.ZIndex = 2
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

local function createTabButton(name)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundTransparency = 1
    Btn.Text = name
    Btn.TextColor3 = Themes.Cosmic.SubText
    Btn.TextSize = 15
    Btn.Font = Enum.Font.SourceSans
    Btn.ZIndex = 3
    Btn.Parent = Sidebar
    
    Btn.MouseButton1Click:Connect(function()
        for pageName, page in pairs(Pages) do
            page.Visible = (pageName == name)
        end
        for _, button in pairs(Sidebar:GetChildren()) do
            if button:IsA("TextButton") then
                button.TextColor3 = (button.Text == name) and Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].Accent or Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].SubText
            end
        end
    end)
end

createTabButton("MM2")
createTabButton("Movement")
createTabButton("Combat")
createTabButton("Themes")
createTabButton("Server")

-- Helper UI Elements
local function createToggle(page, text, settingKey, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 3
    Frame.Parent = page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].CornerRadius
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].Text
    Label.TextSize = 14
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 4
    Label.Parent = Frame
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 45, 0, 22)
    Btn.Position = UDim2.new(1, -55, 0.5, -11)
    Btn.BackgroundColor3 = _G.G_LIGHT_SETTINGS[settingKey] and Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].Accent or Color3.fromRGB(50, 50, 60)
    Btn.Text = _G.G_LIGHT_SETTINGS[settingKey] and "ON" or "OFF"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 12
    Btn.ZIndex = 4
    Btn.Parent = Frame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].CornerRadius
    BtnCorner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        _G.G_LIGHT_SETTINGS[settingKey] = not _G.G_LIGHT_SETTINGS[settingKey]
        Btn.BackgroundColor3 = _G.G_LIGHT_SETTINGS[settingKey] and Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].Accent or Color3.fromRGB(50, 50, 60)
        Btn.Text = _G.G_LIGHT_SETTINGS[settingKey] and "ON" or "OFF"
        if callback then callback(_G.G_LIGHT_SETTINGS[settingKey]) end
    end)
end

local function createSlider(page, text, minVal, maxVal, defaultVal, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 3
    Frame.Parent = page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].CornerRadius
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 2)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. tostring(defaultVal)
    Label.TextColor3 = Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].Text
    Label.TextSize = 14
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 4
    Label.Parent = Frame
    
    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(1, -20, 0, 8)
    SliderBack.Position = UDim2.new(0, 10, 0, 26)
    SliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    SliderBack.BorderSizePixel = 0
    SliderBack.ZIndex = 4
    SliderBack.Parent = Frame
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((defaultVal - minVal)/(maxVal - minVal), 0, 1, 0)
    SliderFill.BackgroundColor3 = Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].Accent
    SliderFill.BorderSizePixel = 0
    SliderFill.ZIndex = 4
    SliderFill.Parent = SliderBack
    
    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
        local val = math.floor(minVal + (maxVal - minVal) * pos)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        Label.Text = text .. ": " .. tostring(val)
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

-- Populate Pages
createToggle(Pages["MM2"], "Role ESP", "ESP_Roles")

createToggle(Pages["Movement"], "Custom Speed", "CustomSpeedEnabled", function(v)
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)
createSlider(Pages["Movement"], "Speed Value", 16, 100, 16, function(v)
    _G.G_LIGHT_SETTINGS.SpeedValue = v
end)
createToggle(Pages["Movement"], "Inf Jump", "InfJump")
createToggle(Pages["Movement"], "Dash (Q key)", "DashEnabled")
createToggle(Pages["Movement"], "Fly", "FlyEnabled")
createSlider(Pages["Movement"], "Fly Speed", 1, 5, 1, function(v)
    _G.G_LIGHT_SETTINGS.FlySpeed = v
end)

createToggle(Pages["Combat"], "Kill Aura", "KillAura")
createToggle(Pages["Combat"], "Danger Radar", "DangerRadar")

-- SERVER TAB (REJOIN FEATURE)
local RejoinBtn = Instance.new("TextButton")
RejoinBtn.Size = UDim2.new(1, -10, 0, 40)
RejoinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
RejoinBtn.BorderSizePixel = 0
RejoinBtn.Text = "🔄 Rejoin Server"
RejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinBtn.Font = Enum.Font.SourceSansBold
RejoinBtn.TextSize = 16
RejoinBtn.ZIndex = 3
RejoinBtn.Parent = Pages["Server"]

local RejoinCorner = Instance.new("UICorner")
RejoinCorner.CornerRadius = UDim.new(0, 8)
RejoinCorner.Parent = RejoinBtn

RejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

-- Populate Themes Page
local function applyTheme(themeName)
    if _G.G_LIGHT_SETTINGS.CurrentTheme == themeName then return end
    _G.G_LIGHT_SETTINGS.CurrentTheme = themeName
    local theme = Themes[themeName]
    
    MainFrame.BackgroundColor3 = theme.Background
    Header.BackgroundColor3 = theme.Header
    Title.TextColor3 = theme.Accent
    MainCorner.CornerRadius = theme.CornerRadius
    HeaderCorner.CornerRadius = theme.CornerRadius
    
    for _, btn in pairs(Sidebar:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.TextColor3 = (btn.Text == Pages[btn.Text].Visible) and theme.Accent or theme.SubText
        end
    end
end

for themeName, _ in pairs(Themes) do
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Btn.BorderSizePixel = 0
    Btn.Text = "Theme: " .. themeName
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 14
    Btn.ZIndex = 3
    Btn.Parent = Pages["Themes"]
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        applyTheme(themeName)
    end)
end

-- DANGER RADAR WARNING OVERLAY
local RadarWarning = Instance.new("TextLabel")
RadarWarning.Name = "DangerRadarWarning"
RadarWarning.Size = UDim2.new(0, 400, 0, 50)
RadarWarning.Position = UDim2.new(0.5, -200, 0.15, 0)
RadarWarning.BackgroundTransparency = 1
RadarWarning.Text = "⚠️ MURDERER NEARBY! ⚠️"
RadarWarning.TextColor3 = Color3.fromRGB(255, 30, 30)
RadarWarning.TextSize = 24
RadarWarning.Font = Enum.Font.SourceSansBold
RadarWarning.Visible = false
RadarWarning.Parent = ScreenGui

-- MM2 HELPERS
local function getMM2Role(player)
    if not player or not player.Character then return "Innocent" end
    local char = player.Character
    local backpack = player:FindFirstChild("Backpack")
    
    if char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")) then
        return "Murderer"
    elseif char:FindFirstChild("Revolver") or (backpack and backpack:FindFirstChild("Revolver")) or char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")) then
        return "Sheriff"
    end
    return "Innocent"
end

-- ESP LOGIC
local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local highlight = hrp:FindFirstChild("GLightESP")
            
            if _G.G_LIGHT_SETTINGS.ESP_Roles then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "GLightESP"
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = hrp
                end
                
                local role = getMM2Role(player)
                if role == "Murderer" then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 50, 50)
                elseif role == "Sheriff" then
                    highlight.FillColor = Color3.fromRGB(0, 100, 255)
                    highlight.OutlineColor = Color3.fromRGB(50, 150, 255)
                else
                    highlight.FillColor = Color3.fromRGB(0, 255, 100)
                    highlight.OutlineColor = Color3.fromRGB(100, 255, 150)
                end
                highlight.FillTransparency = 0.4
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end

-- COMBAT & LOGIC LOOP
local bodyVel, bodyGyro
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        
        -- Fly Handling
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
            
            local speedMultiplier = _G.G_LIGHT_SETTINGS.FlySpeed * 25
            bodyVel.Velocity = moveDir * speedMultiplier
        else
            if bodyVel then bodyVel:Destroy() bodyVel = nil end
            if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        end
        
        -- Custom Speed
        if _G.G_LIGHT_SETTINGS.CustomSpeedEnabled then
            hum.WalkSpeed = _G.G_LIGHT_SETTINGS.SpeedValue
        end

        -- Kill Aura (MM2 & General Melee)
        if _G.G_LIGHT_SETTINGS.KillAura then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                for _, target in pairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        local targetHrp = target.Character.HumanoidRootPart
                        local dist = (hrp.Position - targetHrp.Position).Magnitude
                        if dist <= 15 then
                            tool:Activate()
                            if tool:FindFirstChild("Handle") then
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
                    local dist = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= 40 then
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
    
    -- Update ESP Loop
    updateESP()
end)

-- Inf Jump Logic
UserInputService.JumpRequest:Connect(function()
    if _G.G_LIGHT_SETTINGS.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanState.Jumping)
    end
end)

-- Dash & Menu Toggle
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
