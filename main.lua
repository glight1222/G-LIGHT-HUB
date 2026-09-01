--================================================================================--
--                                                                                --
--      ██████╗ ██╗     ██╗██╗██╗  ██╗████████╗    ██╗  ██╗██╗   ██╗██████╗       --
--     ██╔════╝ ██║     ██║██║██║  ██║╚══██╔══╝    ██║  ██║██║   ██║██╔══██╗      --
--     ██║  ███╗██║     ██║██║███████║   ██║       ███████║██║   ██║██████╔╝      --
--     ██║   ██║██║     ██║██║██╔══██║   ██║       ██╔══██║██║   ██║██╔══██╗      --
--     ╚██████╔╝███████╗██║██║██║  ██║   ██║       ██║  ██║╚██████╔╝██████╔╝      --
--      ╚═════╝ ╚══════╝╚═╝╚═╝╚═╝  ╚═╝   ╚═╝       ╚═╝  ╚═╝ ╚═════╝ ╚═════╝       --
--                                                                                --
--            VERSION 8.5 - COSMIC GUI & SHERIFF AUTO-AIM EDITION                 --
--================================================================================--

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

------------------------------------------------------------------------------------
-- GLOBAL CONFIGURATION ENGINE
------------------------------------------------------------------------------------
_G.G_LIGHT_SETTINGS = _G.G_LIGHT_SETTINGS or {
    ESP_Roles = true,
    ESP_Coins = true,
    AutoCoinFarm = true,
    SafeFarmDelay = 0.25,
    CustomSpeedEnabled = false,
    SpeedValue = 24,
    InfJump = true,
    NoclipEnabled = false,
    KillAura = false,
    SheriffAutoAim = true, -- Новая функция авто-аима для Шерифа
    AimSmoothness = 0.2,   -- Плавность наводки (0.1 - мгновенно, 0.5 - очень плавно)
    AntiKick = true,
    AntiAFK = true,
    CoinHighlightsColor = Color3.fromRGB(255, 215, 0),
    MurdererColor = Color3.fromRGB(255, 45, 45),
    SheriffColor = Color3.fromRGB(0, 160, 255),
    InnocentColor = Color3.fromRGB(40, 230, 80)
}

------------------------------------------------------------------------------------
-- SECURITY & BYPASS ENGINE
------------------------------------------------------------------------------------
if hookmetamethod then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if _G.G_LIGHT_SETTINGS.AntiKick and (method == "Kick" or method == "kick") and self == LocalPlayer then
            return nil
        end
        return oldNamecall(self, ...)
    end)
end

LocalPlayer.Idled:Connect(function()
    if _G.G_LIGHT_SETTINGS.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end
end)

------------------------------------------------------------------------------------
-- BASE GUI SETUP
------------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GLightHub_Monolith_v85"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 99999

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

------------------------------------------------------------------------------------
-- INTRO SYSTEM (STARFALL)
------------------------------------------------------------------------------------
local IntroCanvas = Instance.new("Frame")
IntroCanvas.Size = UDim2.new(1, 0, 1, 0)
IntroCanvas.BackgroundColor3 = Color3.fromRGB(6, 8, 14)
IntroCanvas.BorderSizePixel = 0
IntroCanvas.ZIndex = 500
IntroCanvas.Parent = ScreenGui

local StarsIntroContainer = Instance.new("Frame")
StarsIntroContainer.Size = UDim2.new(1, 0, 1, 0)
StarsIntroContainer.BackgroundTransparency = 1
StarsIntroContainer.ZIndex = 501
StarsIntroContainer.Parent = IntroCanvas

local introStars = {}
for i = 1, 60 do
    local star = Instance.new("Frame")
    star.Size = UDim2.new(0, math.random(2, 4), 0, math.random(10, 20))
    star.Position = UDim2.new(math.random(), 0, math.random() - 1, 0)
    star.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    star.BorderSizePixel = 0
    star.ZIndex = 502
    star.Parent = StarsIntroContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = star
    
    table.insert(introStars, {Obj = star, Speed = math.random(500, 900) / 1000})
end

local starAnimConnection
starAnimConnection = RunService.RenderStepped:Connect(function(dt)
    for _, s in ipairs(introStars) do
        local newY = s.Obj.Position.Y.Scale + (s.Speed * dt)
        if newY > 1.1 then newY = -0.1 end
        s.Obj.Position = UDim2.new(s.Obj.Position.X.Scale, 0, newY, 0)
    end
end)

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0, 30)
SubTitle.Position = UDim2.new(0, 0, 0.43, -40)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "G_light Presents..."
SubTitle.TextColor3 = Color3.fromRGB(150, 180, 240)
SubTitle.TextTransparency = 1
SubTitle.TextSize = 22
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.ZIndex = 505
SubTitle.Parent = IntroCanvas

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0, 70)
MainTitle.Position = UDim2.new(0, 0, 0.43, 10)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "✨ G LIGHT HUB ✨"
MainTitle.TextColor3 = Color3.fromRGB(0, 210, 255)
MainTitle.TextTransparency = 1
MainTitle.TextSize = 48
MainTitle.Font = Enum.Font.GothamBold
MainTitle.ZIndex = 505
MainTitle.Parent = IntroCanvas

task.spawn(function()
    local tIn = TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tOut = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    
    TweenService:Create(SubTitle, tIn, {TextTransparency = 0}):Play()
    task.wait(0.9)
    TweenService:Create(MainTitle, tIn, {TextTransparency = 0}):Play()
    task.wait(1.4)
    
    TweenService:Create(SubTitle, tOut, {TextTransparency = 1}):Play()
    TweenService:Create(MainTitle, tOut, {TextTransparency = 1}):Play()
    TweenService:Create(IntroCanvas, tOut, {BackgroundTransparency = 1}):Play()
    
    task.wait(0.5)
    if starAnimConnection then starAnimConnection:Disconnect() end
    IntroCanvas:Destroy()
end)

------------------------------------------------------------------------------------
-- MAIN HUB & INSIDE-GUI STAR SYSTEM
------------------------------------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 640, 0, 420)
MainFrame.Position = UDim2.new(0.5, -320, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 14, 22)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(0, 180, 255)
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

-- ФОНОВЫЕ ЗВЁЗДЫ ВНУТРИ САМОГО GUI
local GuiStarsContainer = Instance.new("Frame")
GuiStarsContainer.Name = "GuiStarsContainer"
GuiStarsContainer.Size = UDim2.new(1, 0, 1, 0)
GuiStarsContainer.BackgroundTransparency = 1
GuiStarsContainer.ZIndex = 10
GuiStarsContainer.Parent = MainFrame

local guiStars = {}
for i = 1, 35 do
    local star = Instance.new("Frame")
    star.Size = UDim2.new(0, math.random(2, 3), 0, math.random(6, 14))
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    star.BackgroundTransparency = math.random(3, 7) / 10
    star.BorderSizePixel = 0
    star.ZIndex = 10
    star.Parent = GuiStarsContainer
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = star
    
    table.insert(guiStars, {Obj = star, Speed = math.random(15, 45) / 1000})
end

RunService.RenderStepped:Connect(function(dt)
    for _, s in ipairs(guiStars) do
        local newY = s.Obj.Position.Y.Scale + (s.Speed * dt)
        if newY > 1 then newY = -0.05 end
        s.Obj.Position = UDim2.new(s.Obj.Position.X.Scale, 0, newY, 0)
    end
end)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundColor3 = Color3.fromRGB(18, 22, 38)
Header.BorderSizePixel = 0
Header.ZIndex = 12
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "✨ G LIGHT HUB  <font color='#00C8FF'>v8.5 Cosmic</font> ⭐"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 13
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 46, 68)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.ZIndex = 13
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -52)
Sidebar.Position = UDim2.new(0, 0, 0, 52)
Sidebar.BackgroundColor3 = Color3.fromRGB(14, 16, 26)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 12
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.Parent = Sidebar
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 6)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 10)
SidebarPadding.PaddingLeft = UDim.new(0, 8)
SidebarPadding.PaddingRight = UDim.new(0, 8)
SidebarPadding.Parent = Sidebar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -172, 1, -60)
Content.Position = UDim2.new(0, 166, 0, 56)
Content.BackgroundTransparency = 1
Content.ZIndex = 12
Content.Parent = MainFrame

local Pages = {}
local TabButtons = {}

local function createPage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -4, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Color3.fromRGB(0, 195, 255)
    Page.ZIndex = 12
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
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
createPage("Server")

Pages["MM2"].Visible = true

local function createTabButton(name, icon)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 38)
    Btn.BackgroundColor3 = (name == "MM2") and Color3.fromRGB(24, 28, 48) or Color3.fromRGB(0, 0, 0)
    Btn.BackgroundTransparency = (name == "MM2") and 0 or 1
    Btn.Text = "  " .. icon .. "  " .. name
    Btn.TextColor3 = (name == "MM2") and Color3.fromRGB(0, 195, 255) or Color3.fromRGB(160, 175, 210)
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.ZIndex = 13
    Btn.Parent = Sidebar
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Btn
    
    TabButtons[name] = Btn
    
    Btn.MouseButton1Click:Connect(function()
        for pName, page in pairs(Pages) do page.Visible = (pName == name) end
        for bName, button in pairs(TabButtons) do
            local active = (bName == name)
            button.BackgroundTransparency = active and 0 or 1
            button.TextColor3 = active and Color3.fromRGB(0, 195, 255) or Color3.fromRGB(160, 175, 210)
            button.BackgroundColor3 = Color3.fromRGB(24, 28, 48)
        end
    end)
end

createTabButton("MM2", "🗡️")
createTabButton("Movement", "⚡")
createTabButton("Combat", "🎯")
createTabButton("Security", "🛡️")
createTabButton("Server", "🌐")

------------------------------------------------------------------------------------
-- SHERIFF AUTO-AIM ENGINE (ПЛАВНЫЙ АВТО-АИМ НА УБИЙЦУ)
------------------------------------------------------------------------------------
local function getMurderer()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            if char:FindFirstChild("Knife") or (plr.Backpack and plr.Backpack:FindFirstChild("Knife")) then
                return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
            end
        end
    end
    return nil
end

RunService.RenderStepped:Connect(function()
    if _G.G_LIGHT_SETTINGS.SheriffAutoAim and LocalPlayer.Character then
        local char = LocalPlayer.Character
        local tool = char:FindFirstChildOfClass("Tool")
        
        -- Проверяем: держит ли игрок в руках пистолет Шерифа
        if tool and tool.Name == "Gun" then
            local targetPart = getMurderer()
            if targetPart then
                local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, _G.G_LIGHT_SETTINGS.AimSmoothness)
            end
        end
    end
end)

------------------------------------------------------------------------------------
-- MM2 COIN SEARCH ENGINE & WALL ESP
------------------------------------------------------------------------------------
local function getMM2Coins()
    local coins = {}
    local function scanObj(parent)
        if not parent then return end
        for _, v in pairs(parent:GetDescendants()) do
            if (v:IsA("BasePart") or v:IsA("Model")) and (v.Name == "CoinContainer" or v.Name == "Coin_Server" or v.Name == "Coin" or v.Name == "CoinVisual") then
                if v:IsA("BasePart") then
                    table.insert(coins, v)
                elseif v:IsA("Model") then
                    for _, child in pairs(v:GetChildren()) do
                        if child:IsA("BasePart") then table.insert(coins, child) end
                    end
                end
            end
        end
    end
    scanObj(Workspace:FindFirstChild("Normal"))
    scanObj(Workspace:FindFirstChild("Map"))
    scanObj(Workspace)
    return coins
end

task.spawn(function()
    while task.wait(0.5) do
        if _G.G_LIGHT_SETTINGS.ESP_Coins then
            local currentCoins = getMM2Coins()
            for _, coin in pairs(currentCoins) do
                local targetObj = coin:IsA("Model") and (coin.PrimaryPart or coin:FindFirstChildWhichIsA("BasePart")) or coin
                if targetObj and not targetObj:FindFirstChild("CoinHL_Ultra") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "CoinHL_Ultra"
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.FillColor = _G.G_LIGHT_SETTINGS.CoinHighlightsColor
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.15
                    hl.OutlineTransparency = 0
                    hl.Adornee = targetObj
                    hl.Parent = targetObj
                end
            end
        end
    end
end)

-- Auto Coin Farm
local isFarming = false
task.spawn(function()
    while true do
        task.wait(_G.G_LIGHT_SETTINGS.SafeFarmDelay)
        if _G.G_LIGHT_SETTINGS.AutoCoinFarm and not isFarming then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            if hrp and hum and hum.Health > 0 then
                local coins = getMM2Coins()
                if #coins > 0 then
                    isFarming = true
                    for _, coinPart in ipairs(coins) do
                        if not _G.G_LIGHT_SETTINGS.AutoCoinFarm then break end
                        local targetPos = coinPart:IsA("BasePart") and coinPart.CFrame or coinPart:GetPivot()
                        if targetPos then
                            hrp.CFrame = targetPos + Vector3.new(0, 1.2, 0)
                            if coinPart:IsA("BasePart") then
                                firetouchinterest(hrp, coinPart, 0)
                                task.wait(0.01)
                                firetouchinterest(hrp, coinPart, 1)
                            end
                            task.wait(_G.G_LIGHT_SETTINGS.SafeFarmDelay)
                        end
                    end
                    isFarming = false
                end
            end
        end
    end
end)

------------------------------------------------------------------------------------
-- ESP ROLES ENGINE
------------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.8) do
        if _G.G_LIGHT_SETTINGS.ESP_Roles then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local char = plr.Character
                    local hl = char:FindFirstChild("RoleHL") or Instance.new("Highlight")
                    hl.Name = "RoleHL"
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    
                    local isMurd = char:FindFirstChild("Knife") or (plr.Backpack and plr.Backpack:FindFirstChild("Knife"))
                    local isSher = char:FindFirstChild("Gun") or (plr.Backpack and plr.Backpack:FindFirstChild("Gun"))
                    
                    if isMurd then
                        hl.FillColor = _G.G_LIGHT_SETTINGS.MurdererColor
                    elseif isSher then
                        hl.FillColor = _G.G_LIGHT_SETTINGS.SheriffColor
                    else
                        hl.FillColor = _G.G_LIGHT_SETTINGS.InnocentColor
                    end
                    
                    hl.FillTransparency = 0.25
                    hl.OutlineTransparency = 0
                    hl.Adornee = char
                    hl.Parent = char
                end
            end
        end
    end
end)

------------------------------------------------------------------------------------
-- MOVEMENT ENGINE
------------------------------------------------------------------------------------
UserInputService.JumpRequest:Connect(function()
    if _G.G_LIGHT_SETTINGS.InfJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.Stepped:Connect(function()
    if _G.G_LIGHT_SETTINGS.NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.G_LIGHT_SETTINGS.CustomSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = _G.G_LIGHT_SETTINGS.SpeedValue
    end
end)

------------------------------------------------------------------------------------
-- UI BUILDER FUNCTIONS
------------------------------------------------------------------------------------
local function createToggle(page, text, settingKey)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -6, 0, 44)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 26, 44)
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 13
    Frame.Parent = page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 14, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "✨ " .. text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 14
    Label.Parent = Frame
    
    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 44, 0, 22)
    Switch.Position = UDim2.new(1, -54, 0.5, -11)
    Switch.BackgroundColor3 = _G.G_LIGHT_SETTINGS[settingKey] and Color3.fromRGB(0, 195, 255) or Color3.fromRGB(45, 52, 75)
    Switch.ZIndex = 14
    Switch.Parent = Frame
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = _G.G_LIGHT_SETTINGS[settingKey] and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.ZIndex = 15
    Circle.Parent = Switch
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle
    
    local ClickBtn = Instance.new("TextButton")
    ClickBtn.Size = UDim2.new(1, 0, 1, 0)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Text = ""
    ClickBtn.ZIndex = 16
    ClickBtn.Parent = Frame
    
    ClickBtn.MouseButton1Click:Connect(function()
        _G.G_LIGHT_SETTINGS[settingKey] = not _G.G_LIGHT_SETTINGS[settingKey]
        local enabled = _G.G_LIGHT_SETTINGS[settingKey]
        
        TweenService:Create(Switch, TweenInfo.new(0.2), {
            BackgroundColor3 = enabled and Color3.fromRGB(0, 195, 255) or Color3.fromRGB(45, 52, 75)
        }):Play()
        TweenService:Create(Circle, TweenInfo.new(0.2), {
            Position = enabled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        }):Play()
    end)
    return Frame
end

local function createSlider(page, text, minVal, maxVal, defaultVal, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -6, 0, 52)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 26, 44)
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 13
    Frame.Parent = page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 22)
    Label.Position = UDim2.new(0, 14, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Text = "⭐ " .. text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 14
    Label.Parent = Frame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0.3, 0, 0, 22)
    ValueLabel.Position = UDim2.new(0.7, -14, 0, 4)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(defaultVal)
    ValueLabel.TextColor3 = Color3.fromRGB(0, 195, 255)
    ValueLabel.TextSize = 13
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.ZIndex = 14
    ValueLabel.Parent = Frame
    
    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(1, -28, 0, 6)
    SliderBack.Position = UDim2.new(0, 14, 0, 34)
    SliderBack.BackgroundColor3 = Color3.fromRGB(45, 52, 75)
    SliderBack.BorderSizePixel = 0
    SliderBack.ZIndex = 14
    SliderBack.Parent = Frame
    
    local SliderBackCorner = Instance.new("UICorner")
    SliderBackCorner.CornerRadius = UDim.new(1, 0)
    SliderBackCorner.Parent = SliderBack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((defaultVal - minVal)/(maxVal - minVal), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 195, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.ZIndex = 15
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
    end)
    return Frame
end

------------------------------------------------------------------------------------
-- POPULATING TABS & OPTIONS
------------------------------------------------------------------------------------
createToggle(Pages["MM2"], "Auto Coin Farm", "AutoCoinFarm")
createToggle(Pages["MM2"], "Coin Highlight ESP (Wall Penetration)", "ESP_Coins")
createToggle(Pages["MM2"], "Role Highlight ESP (Murd/Sher/Inn)", "ESP_Roles")

createToggle(Pages["Combat"], "Sheriff Auto-Aim (Lock on Murderer)", "SheriffAutoAim")
createToggle(Pages["Combat"], "Kill Aura", "KillAura")

createToggle(Pages["Movement"], "Infinite Jump Engine", "InfJump")
createToggle(Pages["Movement"], "Custom WalkSpeed", "CustomSpeedEnabled")
createSlider(Pages["Movement"], "Speed Value", 16, 80, 24, function(v)
    _G.G_LIGHT_SETTINGS.SpeedValue = v
end)
createToggle(Pages["Movement"], "Noclip (Walk Through Walls)", "NoclipEnabled")

createToggle(Pages["Security"], "Anti-Kick Protection", "AntiKick")
createToggle(Pages["Security"], "Anti-AFK System", "AntiAFK")

local RejoinBtn = Instance.new("TextButton")
RejoinBtn.Size = UDim2.new(1, -6, 0, 44)
RejoinBtn.BackgroundColor3 = Color3.fromRGB(22, 26, 44)
RejoinBtn.BorderSizePixel = 0
RejoinBtn.Text = "🔄 Rejoin Current Server"
RejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinBtn.Font = Enum.Font.GothamBold
RejoinBtn.TextSize = 13
RejoinBtn.ZIndex = 13
RejoinBtn.Parent = Pages["Server"]

local RejoinCorner = Instance.new("UICorner")
RejoinCorner.CornerRadius = UDim.new(0, 8)
RejoinCorner.Parent = RejoinBtn

RejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)
