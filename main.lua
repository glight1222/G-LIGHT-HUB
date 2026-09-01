local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- Global variables
_G.G_LIGHT_SETTINGS = _G.G_LIGHT_SETTINGS or {
    ESP_Roles = false,
    CustomSpeedEnabled = false,
    SpeedValue = 16,
    InfJump = false,
    DashEnabled = false,
    KillAura = false,
    DangerRadar = false,
    CurrentTheme = "Default",
    FlyEnabled = false,
    FlySpeed = 1
}

local Themes = {
    Default = {
        Background = Color3.fromRGB(20, 20, 25),
        Header = Color3.fromRGB(30, 30, 40),
        Accent = Color3.fromRGB(0, 170, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 200),
        CornerRadius = UDim.new(0, 8)
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

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Themes.Default.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = Themes.Default.CornerRadius
MainCorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Themes.Default.Header
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = Themes.Default.CornerRadius
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "G LIGHT HUB v5.0"
Title.TextColor3 = Themes.Default.Accent
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Sidebar Navigation
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.Parent = Sidebar
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 5)

-- Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -135, 1, -45)
Content.Position = UDim2.new(0, 135, 0, 45)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local Pages = {}

local function createPage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -10, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 4
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

Pages["MM2"].Visible = true

local function createTabButton(name)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundTransparency = 1
    Btn.Text = name
    Btn.TextColor3 = Themes.Default.SubText
    Btn.TextSize = 15
    Btn.Font = Enum.Font.SourceSans
    Btn.Parent = Sidebar
    
    Btn.MouseButton1Click:Connect(function()
        for pageName, page in pairs(Pages) do
            page.Visible = (pageName == name)
        end
        for _, button in pairs(Sidebar:GetChildren()) do
            if button:IsA("TextButton") then
                button.TextColor3 = (button.Text == name) and Themes.Default.Accent or Themes.Default.SubText
            end
        end
    end)
end

createTabButton("MM2")
createTabButton("Movement")
createTabButton("Combat")
createTabButton("Themes")

-- Helper UI Elements
local function createToggle(page, text, settingKey, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Frame.BorderSizePixel = 0
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
    Label.Parent = Frame
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 45, 0, 22)
    Btn.Position = UDim2.new(1, -55, 0.5, -11)
    Btn.BackgroundColor3 = _G.G_LIGHT_SETTINGS[settingKey] and Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].Accent or Color3.fromRGB(50, 50, 60)
    Btn.Text = _G.G_LIGHT_SETTINGS[settingKey] and "ON" or "OFF"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 12
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
    Label.Parent = Frame
    
    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(1, -20, 0, 8)
    SliderBack.Position = UDim2.new(0, 10, 0, 26)
    SliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    SliderBack.BorderSizePixel = 0
    SliderBack.Parent = Frame
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((defaultVal - minVal)/(maxVal - minVal), 0, 1, 0)
    SliderFill.BackgroundColor3 = Themes[_G.G_LIGHT_SETTINGS.CurrentTheme].Accent
    SliderFill.BorderSizePixel = 0
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

-- Populate MM2 Page
createToggle(Pages["MM2"], "Role ESP", "ESP_Roles")

-- Populate Movement Page
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

-- NEW: FLY & FLY SPEED SLIDER
createToggle(Pages["Movement"], "Fly", "FlyEnabled")
createSlider(Pages["Movement"], "Fly Speed", 1, 5, 1, function(v)
    _G.G_LIGHT_SETTINGS.FlySpeed = v
end)

-- Populate Combat Page
createToggle(Pages["Combat"], "Kill Aura", "KillAura")
createToggle(Pages["Combat"], "Danger Radar", "DangerRadar")

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
    Btn.Parent = Pages["Themes"]
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        applyTheme(themeName)
    end)
end

-- Fly Logic
local bodyVel, bodyGyro
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        
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
        
        -- Custom Speed Logic
        if _G.G_LIGHT_SETTINGS.CustomSpeedEnabled then
            hum.WalkSpeed = _G.G_LIGHT_SETTINGS.SpeedValue
        end
    end
end)

-- Inf Jump Logic
UserInputService.JumpRequest:Connect(function()
    if _G.G_LIGHT_SETTINGS.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanState.Jumping)
    end
end)

-- Dash Logic
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
