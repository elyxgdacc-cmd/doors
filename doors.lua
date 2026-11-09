-- =============================================================================
-- PART 1: CORE FRAMEWORK, ENGINE LAYERS, & INTERFACE CONFIGURATION
-- =============================================================================

-- Destroy existing UI if re-running
if game.CoreGui:FindFirstChild("DeltaCheatMenuV5") then
    game.CoreGui.DeltaCheatMenuV5:Destroy()
end

-- Clean up leftover ESP adornments from a previous run
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("BoxHandleAdornment") and (
        obj.Name == "DeltaBoxEsp" or
        obj.Name == "DeltaItemEsp" or
        obj.Name == "DeltaEntityEsp"
    ) then
        obj:Destroy()
    end
end

-- Core Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Global Environment Value Safeguards
local _G = getgenv and getgenv() or _G
_G.SpeedValue = 16
_G.JumpValue = 50
_G.GravityValue = 196.2
_G.FovValue = 70
_G.InfJump = false
_G.Noclip = false
_G.Fullbright = false
_G.Nametags = false
_G.AntiAfk = true

-- ESP state
_G.BoxEsp = false
_G.EspTeamColor = false
_G.EspRange = 300
_G.ItemEsp = false
_G.ItemEspToolsOnly = false
_G.EntityEsp = false
_G.EntityEspNamed = false
_G.EntityAlert = false

-- Backup Initial Lighting Environments
local LightBackup = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
    GlobalShadows = Lighting.GlobalShadows
}

local CurrentThemeColor = Color3.fromHex("#00F5FF")
local Presets = {
    ["Cyber Cyan"] = "#00F5FF",
    ["Neon Purple"] = "#BF00FF",
    ["Laser Green"] = "#39FF14",
    ["Neon Red"] = "#FF1744",
    ["Plasma Gold"] = "#FFD000",
    ["Hot Pink"] = "#FF00AA"
}

-- Initialize Root Interface Layers
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaCheatMenuV5"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Compact Floating Access Target
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = ScreenGui
MinimizeBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
MinimizeBtn.Size = UDim2.new(0, 60, 0, 35)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MinimizeBtn.Text = "MENU"
MinimizeBtn.TextColor3 = CurrentThemeColor
MinimizeBtn.TextSize = 12
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Active = true
MinimizeBtn.Visible = false

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

local MinStroke = Instance.new("UIStroke")
MinStroke.Color = CurrentThemeColor
MinStroke.Thickness = 2
MinStroke.Parent = MinimizeBtn

-- =============================================================================
-- PART 2: UI LAYOUT BUILDER & PAGINATION HUB
-- =============================================================================

-- Main Master Panel Board
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 380, 0, 320)
MainFrame.Active = true
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = CurrentThemeColor
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Panel Header Setup
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DELTA MASTER v5.3.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Left Tab Sidebar Hub
local TabBar = Instance.new("Frame")
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.Size = UDim2.new(0, 100, 1, -40)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabBar.Parent = MainFrame

local Container = Instance.new("Frame")
Container.Position = UDim2.new(0, 110, 0, 50)
Container.Size = UDim2.new(1, -120, 1, -60)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- Scrolling Canvas Factory Function
local function CreatePageFrame()
    local f = Instance.new("ScrollingFrame")
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.Visible = false
    f.ScrollBarThickness = 0
    f.CanvasSize = UDim2.new(0, 0, 0, 560)
    f.Parent = Container

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = f
    return f
end

local P_Movement = CreatePageFrame()
local P_Combat = CreatePageFrame()
local P_Settings = CreatePageFrame()

-- Tab Navigation Assembler Links
local function SetupTabLink(btnName, targetPage, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 22)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    btn.Text = btnName
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 9
    btn.Parent = TabBar

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    btn.MouseButton1Click:Connect(function()
        P_Movement.Visible = false; P_Combat.Visible = false; P_Settings.Visible = false
        targetPage.Visible = true
    end)
    return btn
end

SetupTabLink("Movement", P_Movement, 8)
SetupTabLink("Visuals/ESP", P_Combat, 33)
SetupTabLink("Settings", P_Settings, 58)

P_Movement.Visible = true

local function ApplyNewThemeColor(hexColor)
    CurrentThemeColor = hexColor
    MainStroke.Color = hexColor; MinStroke.Color = hexColor; MinimizeBtn.TextColor3 = hexColor
end

-- Interactive Toggle Generator Component
local function AddToggleComponent(targetPage, labelText, varName, callback)
    local item = Instance.new("Frame")
    item.Size = UDim2.new(1, 0, 0, 35)
    item.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = item

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = item

    local action = Instance.new("TextButton")
    action.Size = UDim2.new(0, 50, 0, 22)
    action.Position = UDim2.new(1, -60, 0, 6)
    action.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 60)
    action.Text = _G[varName] and "ON" or "OFF"
    action.TextColor3 = Color3.fromRGB(255, 255, 255)
    action.Font = Enum.Font.GothamBold
    action.TextSize = 10
    action.Parent = item
    local acCorner = Instance.new("UICorner")
    acCorner.CornerRadius = UDim.new(0, 4)
    acCorner.Parent = action

    action.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        action.Text = _G[varName] and "ON" or "OFF"
        action.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 60)
        if callback then callback(_G[varName]) end
    end)
    item.Parent = targetPage
end

-- Numerical Input Field Assembly Component
local function AddInputComponent(targetPage, labelText, defaultText, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, 6)
    sc.Parent = frame
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 60, 0, 25)
    box.Position = UDim2.new(1, -70, 0, 7)
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    box.Text = defaultText
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 12
    box.Parent = frame
    local sbc = Instance.new("UICorner")
    sbc.CornerRadius = UDim.new(0, 4)
    sbc.Parent = box
    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then callback(val) else box.Text = defaultText end
    end)
    frame.Parent = targetPage
end

-- Mobile Panel Drag Hook
local function EnableDragModule(targetUi)
    local dragToggle = false
    local dragStart, startPos
    targetUi.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true; dragStart = input.Position; startPos = targetUi.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            targetUi.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

EnableDragModule(MainFrame)
EnableDragModule(MinimizeBtn)
MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- MOVEMENT PANEL POPULATION
AddToggleComponent(P_Movement, "Infinite Jump", "InfJump")
AddToggleComponent(P_Movement, "Noclip Engine", "Noclip")
AddInputComponent(P_Movement, "Speed Value:", "16", function(val) _G.SpeedValue = val end)
AddInputComponent(P_Movement, "Jump Power:", "50", function(val) _G.JumpValue = val end)
AddInputComponent(P_Movement, "Gravity Mod:", "196", function(val) _G.GravityValue = val workspace.Gravity = val end)

-- =============================================================================
-- PART 3: VISUALS / ESP
-- =============================================================================

-- Entity keyword list (Doors-aware)
local ENTITY_KEYWORDS = {
    "rush", "ambush", "seek", "figure", "halt", "glitch",
    "screech", "timothy", "jack", "hide", "eyes", "window",
    "void", "shadow", "dupe", "guiding light", "guiding_light",
    "a-60", "a60", "a-90", "a90", "a-120", "a120",
    "blitz", "watchman", "surge", "groundskeeper",
    "rooms", "backrooms", "hq",
    "entity", "monster", "enemy", "boss",
}

local function MatchesEntityKeyword(name)
    local lname = string.lower(name)
    for _, kw in ipairs(ENTITY_KEYWORDS) do
        if string.find(lname, kw, 1, true) then return kw end
    end
    return nil
end

local function GetLocalHRP()
    if LocalPlayer.Character then
        return LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local function WithinEspRange(worldPos)
    if not _G.EspRange or _G.EspRange <= 0 then return true end
    local hrp = GetLocalHRP()
    if not hrp then return true end
    return (hrp.Position - worldPos).Magnitude <= _G.EspRange
end

local function IsPlayerCharacter(model)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character == model then return true end
    end
    return false
end

local function GetWorldPos(obj)
    if obj:IsA("BasePart") then return obj.Position end
    if obj:IsA("Model") then
        local p = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
        return p and p.Position or nil
    end
    if obj:IsA("Tool") then
        local p = obj:FindFirstChildWhichIsA("BasePart")
        return p and p.Position or nil
    end
    return nil
end

local function GetAdornee(obj)
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then
        return obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
    end
    if obj:IsA("Tool") then
        return obj:FindFirstChildWhichIsA("BasePart")
    end
    return nil
end

local function IsItemCandidate(obj)
    if not obj or not obj.Parent then return false end
    if _G.ItemEspToolsOnly then return obj:IsA("Tool") end
    if obj:IsA("Tool") then return true end
    if obj:IsA("BasePart") and obj.Parent == workspace and not obj.Anchored and not obj.CanCollide then
        return true
    end
    return false
end

local function IsEntityCandidate(obj)
    if not obj or not obj.Parent or not obj:IsA("Model") then return false end
    if IsPlayerCharacter(obj) then return false end
    local hum = obj:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health > 0 then return true end
    if _G.EntityEspNamed and MatchesEntityKeyword(obj.Name) then return true end
    return false
end

local function CreateEspBox(parent, adornee, color, name)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = name
    box.Adornee = adornee
    box.Size = Vector3.new(4, 6, 4)
    box.AlwaysOnTop = true
    box.ZIndex = 9
    box.Transparency = 0.6
    box.Color3 = color
    box.Parent = parent
    return box
end

-- Alert UI
local AlertContainer = Instance.new("Frame")
AlertContainer.Name = "DeltaAlertContainer"
AlertContainer.Parent = ScreenGui
AlertContainer.Position = UDim2.new(0.5, -150, 0, 80)
AlertContainer.Size = UDim2.new(0, 300, 0, 0)
AlertContainer.BackgroundTransparency = 1

local AlertList = Instance.new("UIListLayout")
AlertList.Padding = UDim.new(0, 6)
AlertList.SortOrder = Enum.SortOrder.LayoutOrder
AlertList.Parent = AlertContainer

local function ShowEntityAlert(entityName)
    local alert = Instance.new("Frame")
    alert.Size = UDim2.new(1, 0, 0, 36)
    alert.BackgroundColor3 = Color3.fromRGB(40, 15, 15)
    alert.BackgroundTransparency = 0.1

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = alert

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 60, 60)
    stroke.Thickness = 2
    stroke.Parent = alert

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -12, 1, 0)
    lbl.Position = UDim2.new(0, 6, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "⚠ " .. entityName .. " SPAWNED"
    lbl.TextColor3 = Color3.fromRGB(255, 220, 220)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.Parent = alert

    alert.Parent = AlertContainer

    task.delay(5, function()
        if alert and alert.Parent then
            local tween = TweenService:Create(alert, TweenInfo.new(0.6), { BackgroundTransparency = 1 })
            tween:Play()
            tween.Completed:Connect(function() alert:Destroy() end)
        end
    end)
end

local alertDebounce = {}

workspace.DescendantAdded:Connect(function(child)
    if not _G.EntityAlert then return end
    if not (child:IsA("Model") or child:IsA("BasePart")) then return end
    local kw = MatchesEntityKeyword(child.Name)
    if not kw then return end
    local now = os.clock()
    if alertDebounce[kw] and now - alertDebounce[kw] < 3 then return end
    alertDebounce[kw] = now
    ShowEntityAlert(child.Name)
end)

-- Item / Entity caches + refresh
local ItemEspCache = {}
local EntityEspCache = {}

local function RefreshItemEsp()
    for item, adorn in pairs(ItemEspCache) do
        if not item or not item.Parent or not IsItemCandidate(item) then
            if adorn and adorn.Parent then adorn:Destroy() end
            ItemEspCache[item] = nil
        else
            local pos = GetWorldPos(item)
            adorn.Visible = _G.ItemEsp and pos ~= nil and WithinEspRange(pos)
        end
    end

    if not _G.ItemEsp then return end

    for _, obj in pairs(workspace:GetDescendants()) do
        if IsItemCandidate(obj) and not ItemEspCache[obj] then
            local pos = GetWorldPos(obj)
            if pos and WithinEspRange(pos) then
                local adornee = GetAdornee(obj)
                if adornee then
                    local color = obj:IsA("Tool") and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(0, 255, 180)
                    ItemEspCache[obj] = CreateEspBox(obj, adornee, color, "DeltaItemEsp")
                end
            end
        end
    end
end

local function RefreshEntityEsp()
    for ent, adorn in pairs(EntityEspCache) do
        if not ent or not ent.Parent or not IsEntityCandidate(ent) then
            if adorn and adorn.Parent then adorn:Destroy() end
            EntityEspCache[ent] = nil
        else
            local pos = GetWorldPos(ent)
            adorn.Visible = _G.EntityEsp and pos ~= nil and WithinEspRange(pos)
        end
    end

    if not _G.EntityEsp then return end

    for _, obj in pairs(workspace:GetDescendants()) do
        if IsEntityCandidate(obj) and not EntityEspCache[obj] then
            local pos = GetWorldPos(obj)
            if pos and WithinEspRange(pos) then
                local adornee = GetAdornee(obj)
                if adornee then
                    EntityEspCache[obj] = CreateEspBox(obj, adornee, Color3.fromRGB(255, 80, 80), "DeltaEntityEsp")
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(RefreshItemEsp)
        pcall(RefreshEntityEsp)
    end
end)

-- VISUALS / ESP PANEL POPULATION
AddToggleComponent(P_Combat, "Box ESP", "BoxEsp")
AddToggleComponent(P_Combat, "ESP Team Colors", "EspTeamColor")
AddInputComponent(P_Combat, "ESP Range (studs):", "300", function(val) _G.EspRange = val end)
AddToggleComponent(P_Combat, "Item ESP", "ItemEsp")
AddToggleComponent(P_Combat, "Item ESP - Tools Only", "ItemEspToolsOnly")
AddToggleComponent(P_Combat, "Entity ESP (Humanoid)", "EntityEsp")
AddToggleComponent(P_Combat, "Entity ESP - Named", "EntityEspNamed")
AddToggleComponent(P_Combat, "Entity Spawn Alert", "EntityAlert", function(state)
    if not state then return end
    task.spawn(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("BasePart") then
                local kw = MatchesEntityKeyword(obj.Name)
                if kw then
                    ShowEntityAlert(obj.Name)
                    alertDebounce[kw] = os.clock()
                    break
                end
            end
        end
    end)
end)
AddToggleComponent(P_Combat, "Dynamic Nametags", "Nametags")
AddToggleComponent(P_Combat, "Fullbright Module", "Fullbright", function(state)
    if not state then
        Lighting.Ambient = LightBackup.Ambient; Lighting.OutdoorAmbient = LightBackup.OutdoorAmbient
        Lighting.Brightness = LightBackup.Brightness; Lighting.GlobalShadows = LightBackup.GlobalShadows
    end
end)
AddInputComponent(P_Combat, "Camera FOV:", "70", function(val)
    _G.FovValue = val
    workspace.CurrentCamera.FieldOfView = val
end)

-- SETTINGS PANEL POPULATION
local GridContainer = Instance.new("Frame")
GridContainer.Size = UDim2.new(1, 0, 0, 50); GridContainer.BackgroundTransparency = 1; GridContainer.Parent = P_Settings
local grid = Instance.new("UIGridLayout"); grid.CellSize = UDim2.new(0.48, 0, 0, 22); grid.CellPadding = UDim2.new(0, 4, 0, 4); grid.Parent = GridContainer

for name, hex in pairs(Presets) do
    local p = Instance.new("TextButton")
    p.BackgroundColor3 = Color3.fromHex(hex); p.Text = name; p.TextColor3 = Color3.fromRGB(20, 20, 20); p.Font = Enum.Font.GothamBold; p.TextSize = 9
    local pc = Instance.new("UICorner"); pc.CornerRadius = UDim.new(0, 4); pc.Parent = p
    p.MouseButton1Click:Connect(function() ApplyNewThemeColor(Color3.fromHex(hex)) end)
    p.Parent = GridContainer
end

-- =============================================================================
-- PART 4: RUNTIME LOOPS
-- =============================================================================

function StartCheatEngineLoops()
    MinimizeBtn.Visible = true
    MainFrame.Visible = true

    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)

    -- Speed + jump
    RunService.Heartbeat:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            local rootPart = LocalPlayer.Character.HumanoidRootPart
            if humanoid.MoveDirection.Magnitude > 0 and _G.SpeedValue > 16 then
                local velocityVector = humanoid.MoveDirection * _G.SpeedValue
                rootPart.AssemblyLinearVelocity = Vector3.new(velocityVector.X, rootPart.AssemblyLinearVelocity.Y, velocityVector.Z)
            else
                humanoid.WalkSpeed = _G.SpeedValue
            end
            if humanoid.UseJumpPower then humanoid.JumpPower = _G.JumpValue else humanoid.JumpHeight = _G.JumpValue end
        end
        if _G.Fullbright then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255); Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255); Lighting.Brightness = 2; Lighting.GlobalShadows = false
        end
    end)

    -- Noclip
    RunService.Stepped:Connect(function()
        if _G.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
            if LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.NoClip)
            end
        end
    end)

    -- Infinite jump
    UserInputService.JumpRequest:Connect(function()
        if _G.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)

    -- Player box ESP + nametags
    RunService.Heartbeat:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local box = p.Character:FindFirstChild("DeltaBoxEsp")

                if not hum or hum.Health <= 0 then
                    if box then box:Destroy() end
                elseif hrp and _G.BoxEsp and WithinEspRange(hrp.Position) then
                    if not box then
                        box = CreateEspBox(p.Character, hrp, CurrentThemeColor, "DeltaBoxEsp")
                    else
                        box.Adornee = hrp
                    end
                    box.Color3 = (_G.EspTeamColor and p.Team) and p.Team.TeamColor.Color or CurrentThemeColor
                    box.Visible = true
                else
                    if box then box.Visible = false end
                end

                local head = p.Character:FindFirstChild("Head")
                if head then
                    local tag = head:FindFirstChild("DeltaNametag")
                    local tagVisible = _G.Nametags and WithinEspRange(head.Position)
                    if tagVisible then
                        if not tag then
                            tag = Instance.new("BillboardGui")
                            tag.Name = "DeltaNametag"
                            tag.AlwaysOnTop = true
                            tag.Size = UDim2.new(0, 120, 0, 30)
                            tag.StudsOffset = Vector3.new(0, 2, 0)
                            local lbl = Instance.new("TextLabel")
                            lbl.Name = "Label"
                            lbl.Size = UDim2.new(1, 0, 1, 0)
                            lbl.BackgroundTransparency = 1
                            lbl.Font = Enum.Font.GothamBold
                            lbl.TextSize = 10
                            lbl.Parent = tag
                            tag.Parent = head
                        end
                        local dist = hrp and math.floor((hrp.Position - head.Position).Magnitude) or 0
                        tag.Label.Text = p.Name .. " [" .. dist .. " studs]"
                        tag.Label.TextColor3 = CurrentThemeColor
                        tag.Enabled = true
                    elseif tag then
                        tag.Enabled = false
                    end
                end
            end
        end
    end)
end

StartCheatEngineLoops()