-- =============================================================================
-- DELTA MASTER v5.6.4 — LAG-FIXED
-- =============================================================================

if game.CoreGui:FindFirstChild("DeltaCheatMenuV5") then
    game.CoreGui.DeltaCheatMenuV5:Destroy()
end

for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("BoxHandleAdornment") and string.find(obj.Name, "^Delta") then obj:Destroy() end
    if obj:IsA("Highlight") and obj.Name == "DeltaDoorEsp" then obj:Destroy() end
    if obj:IsA("BillboardGui") and obj.Name == "DeltaEspLabel" then obj:Destroy() end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

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

_G.BoxEsp = false
_G.EspTeamColor = false
_G.EspRange = 300
_G.ItemEsp = false
_G.ItemEspToolsOnly = false
_G.KeyEsp = false
_G.BookEsp = false
_G.MechEsp = false
_G.BreakerEsp = false
_G.DoorEsp = false
_G.EntityEsp = false
_G.EntityEspNamed = false
_G.EntityAlert = false
_G.InteractablesEsp = false
_G.ScannerNames = {}

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

-- =============================================================================
-- UI (unchanged from v5.6.3)
-- =============================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaCheatMenuV5"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

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
local MinCorner = Instance.new("UICorner"); MinCorner.CornerRadius = UDim.new(0, 6); MinCorner.Parent = MinimizeBtn
local MinStroke = Instance.new("UIStroke"); MinStroke.Color = CurrentThemeColor; MinStroke.Thickness = 2; MinStroke.Parent = MinimizeBtn

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 380, 0, 320)
MainFrame.Active = true
MainFrame.Visible = false
local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 12); MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke"); MainStroke.Color = CurrentThemeColor; MainStroke.Thickness = 2; MainStroke.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Header.Parent = MainFrame
local HeaderCorner = Instance.new("UICorner"); HeaderCorner.CornerRadius = UDim.new(0, 12); HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DELTA MASTER v5.6.4"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

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

local function CreatePageFrame()
    local f = Instance.new("ScrollingFrame")
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.Visible = false
    f.ScrollBarThickness = 4
    f.ScrollBarImageColor3 = CurrentThemeColor
    f.CanvasSize = UDim2.new(0, 0, 0, 0)
    f.AutomaticCanvasSize = Enum.AutomaticSize.Y
    f.Parent = Container
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = f
    return f
end

local P_Movement = CreatePageFrame()
local P_Combat = CreatePageFrame()
local P_Scanner = CreatePageFrame()
local P_Settings = CreatePageFrame()

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
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = btn
    btn.MouseButton1Click:Connect(function()
        P_Movement.Visible = false; P_Combat.Visible = false; P_Scanner.Visible = false; P_Settings.Visible = false
        targetPage.Visible = true
    end)
    return btn
end

SetupTabLink("Movement", P_Movement, 8)
SetupTabLink("Visuals/ESP", P_Combat, 33)
SetupTabLink("Scanner", P_Scanner, 58)
SetupTabLink("Settings", P_Settings, 83)

P_Movement.Visible = true

local function ApplyNewThemeColor(hexColor)
    CurrentThemeColor = hexColor
    MainStroke.Color = hexColor; MinStroke.Color = hexColor; MinimizeBtn.TextColor3 = hexColor
end

local function AddToggleComponent(targetPage, labelText, varName, callback)
    local item = Instance.new("Frame")
    item.Size = UDim2.new(1, 0, 0, 35)
    item.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = item
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
    local acCorner = Instance.new("UICorner"); acCorner.CornerRadius = UDim.new(0, 4); acCorner.Parent = action
    action.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        action.Text = _G[varName] and "ON" or "OFF"
        action.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 60)
        if callback then callback(_G[varName]) end
    end)
    item.Parent = targetPage
end

local function AddInputComponent(targetPage, labelText, defaultText, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(0, 6); sc.Parent = frame
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
    local sbc = Instance.new("UICorner"); sbc.CornerRadius = UDim.new(0, 4); sbc.Parent = box
    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then callback(val) else box.Text = defaultText end
    end)
    frame.Parent = targetPage
end

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

AddToggleComponent(P_Movement, "Infinite Jump", "InfJump")
AddToggleComponent(P_Movement, "Noclip Engine", "Noclip")
AddInputComponent(P_Movement, "Speed Value:", "16", function(val) _G.SpeedValue = val end)
AddInputComponent(P_Movement, "Jump Power:", "50", function(val) _G.JumpValue = val end)
AddInputComponent(P_Movement, "Gravity Mod:", "196", function(val) _G.GravityValue = val workspace.Gravity = val end)

-- =============================================================================
-- CORE HELPERS
-- =============================================================================

local ENTITY_KEYWORDS = {
    "rush", "ambush", "seek", "figure", "halt", "glitch",
    "screech", "timothy", "jack", "hide", "eyes", "window",
    "void", "shadow", "dupe", "guiding light", "guiding_light",
    "a-60", "a60", "a-90", "a90", "a-120", "a120",
    "blitz", "watchman", "surge", "groundskeeper",
    "rooms", "backrooms", "hq",
    "entity", "monster", "enemy", "boss",
}
local MECHANISM_KEYWORDS = { "anchor", "generator", "lever", "circuit", "breaker" }
local SCANNER_KEYWORDS = {
    "key", "lighter", "lockpick", "flashlight", "torch",
    "book", "breaker", "pole", "anchor", "generator", "lever",
    "door", "button", "switch", "fuse", "battery", "candle",
    "closet", "wardrobe", "room", "hint", "prompt", "pickup", "item",
}
local PICKUP_HINTS = { "pick", "take", "grab", "collect", "use" }

local MAX_ESP_OBJECTS = 60
local MAX_SCANNER_OBJECTS = 40

local function MatchesKeyword(name, list)
    local lname = string.lower(name)
    for _, kw in ipairs(list) do
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
    if obj:IsA("Tool") then
        return obj:FindFirstChildWhichIsA("BasePart") or obj:FindFirstChildWhichIsA("MeshPart")
    end
    if obj:IsA("Model") then
        local direct = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
        if direct then return direct end
        local tool = obj:FindFirstChildWhichIsA("Tool")
        if tool then
            return tool:FindFirstChildWhichIsA("BasePart") or tool:FindFirstChildWhichIsA("MeshPart")
        end
    end
    return nil
end

local function IsHeldByLocal(obj)
    if not LocalPlayer.Character then return false end
    if obj:IsDescendantOf(LocalPlayer.Character) then return true end
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if backpack and obj:IsDescendantOf(backpack) then return true end
    return false
end

local function GetIdentity(obj)
    if obj:IsA("Tool") then return obj end
    if obj:IsA("Model") then return obj end
    if obj:IsA("BasePart") then
        local parent = obj.Parent
        if parent and (parent:IsA("Model") or parent:IsA("Tool")) then
            return parent
        end
        return obj
    end
    return obj
end

-- =============================================================================
-- VISUAL BUILDERS
-- =============================================================================

local function CreateEspBox(parent, adornee, color, name, size, transparency, zindex)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = name
    box.Adornee = adornee
    box.Size = size or Vector3.new(4, 6, 4)
    box.AlwaysOnTop = true
    box.ZIndex = zindex or 9
    box.Transparency = transparency or 0.6
    box.Color3 = color
    box.Parent = parent
    return box
end

local function CreateEspLabel(parent, text, color, size)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "DeltaEspLabel"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 100, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.LightInfluence = 0
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color
    lbl.TextSize = size or 10
    lbl.Font = Enum.Font.GothamBold
    lbl.TextStrokeTransparency = 0.4
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.Parent = billboard
    billboard.Parent = parent
    return billboard
end

local function CreateDoorHighlight(parent, adornee, color)
    local hl = Instance.new("Highlight")
    hl.Name = "DeltaDoorEsp"
    hl.Adornee = adornee
    hl.FillTransparency = 1
    hl.OutlineTransparency = 0
    hl.OutlineColor = color
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = parent
    return hl
end

-- =============================================================================
-- ALERT
-- =============================================================================

local AlertContainer = Instance.new("Frame")
AlertContainer.Name = "DeltaAlertContainer"
AlertContainer.Parent = ScreenGui
AlertContainer.Position = UDim2.new(1, -190, 0, 20)
AlertContainer.Size = UDim2.new(0, 180, 0, 0)
AlertContainer.BackgroundTransparency = 1
local AlertList = Instance.new("UIListLayout")
AlertList.Padding = UDim.new(0, 4)
AlertList.SortOrder = Enum.SortOrder.LayoutOrder
AlertList.Parent = AlertContainer

local function ShowEntityAlert(entityName)
    local alert = Instance.new("Frame")
    alert.Size = UDim2.new(1, 0, 0, 28)
    alert.BackgroundColor3 = Color3.fromRGB(40, 15, 15)
    alert.BackgroundTransparency = 0.1
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = alert
    local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(255, 60, 60); stroke.Thickness = 1.5; stroke.Parent = alert
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 1, 0)
    lbl.Position = UDim2.new(0, 5, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "⚠ " .. entityName .. " SPAWNED"
    lbl.TextColor3 = Color3.fromRGB(255, 220, 220)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = alert
    alert.Parent = AlertContainer
    task.delay(4, function()
        if alert and alert.Parent then
            local tween = TweenService:Create(alert, TweenInfo.new(0.5), { BackgroundTransparency = 1 })
            tween:Play()
            tween.Completed:Connect(function() alert:Destroy() end)
        end
    end)
end

local alertDebounce = {}
workspace.DescendantAdded:Connect(function(child)
    if not _G.EntityAlert then return end
    if not (child:IsA("Model") or child:IsA("BasePart")) then return end
    local kw = MatchesKeyword(child.Name, ENTITY_KEYWORDS)
    if not kw then return end
    local now = os.clock()
    if alertDebounce[kw] and now - alertDebounce[kw] < 3 then return end
    alertDebounce[kw] = now
    ShowEntityAlert(child.Name)
end)

-- =============================================================================
-- CANDIDATE FILTERS (no InCurrentRoom — the scan is already scoped)
-- =============================================================================

local function IsItemCandidate(obj)
    if not obj or not obj.Parent then return false end
    if IsHeldByLocal(obj) then return false end
    if _G.ItemEspToolsOnly then return obj:IsA("Tool") end
    if obj:IsA("Tool") then return true end
    if obj:IsA("BasePart") and obj.Parent == workspace and not obj.Anchored and not obj.CanCollide then return true end
    return false
end

local function IsKeyCandidate(obj)
    if not obj or not obj.Parent then return false end
    if IsHeldByLocal(obj) then return false end
    local lname = string.lower(obj.Name)
    if not (string.find(lname, "key", 1, true) or string.find(lname, "keycard", 1, true) or string.find(lname, "card", 1, true) or string.find(lname, "pass", 1, true)) then return false end
    return obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("BasePart")
end

local function IsBookCandidate(obj)
    if not obj or not obj.Parent then return false end
    if IsHeldByLocal(obj) then return false end
    if not string.find(string.lower(obj.Name), "book", 1, true) then return false end
    return obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("BasePart")
end

local function IsMechCandidate(obj)
    if not obj or not obj.Parent then return false end
    if IsHeldByLocal(obj) then return false end
    if not MatchesKeyword(obj.Name, MECHANISM_KEYWORDS) then return false end
    return obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("BasePart")
end

local function IsBreakerCandidate(obj)
    if not obj or not obj.Parent then return false end
    if IsHeldByLocal(obj) then return false end
    local lname = string.lower(obj.Name)
    if not (string.find(lname, "breaker", 1, true) or string.find(lname, "pole", 1, true) or string.find(lname, "switch", 1, true)) then return false end
    return obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("BasePart")
end

local function IsDoorCandidate(obj)
    if not obj or not obj.Parent then return false end
    if not (obj:IsA("Model") or obj:IsA("BasePart")) then return false end
    local lname = string.lower(obj.Name)
    if not string.find(lname, "door", 1, true) then return false end
    if string.find(lname, "dupe", 1, true) then return false end
    return true
end

local function IsEntityCandidate(obj)
    if not obj or not obj.Parent or not obj:IsA("Model") then return false end
    if IsPlayerCharacter(obj) then return false end
    local hum = obj:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health > 0 then return true end
    if _G.EntityEspNamed and MatchesKeyword(obj.Name, ENTITY_KEYWORDS) then return true end
    return false
end

local function IsInteractable(obj)
    if not obj or not obj.Parent then return false end
    if IsHeldByLocal(obj) then return false end
    if not (obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("Tool")) then return false end
    if obj:IsA("Tool") then return true end
    local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt then
        local act = string.lower(prompt.ActionText or "")
        for _, hint in ipairs(PICKUP_HINTS) do
            if string.find(act, hint, 1, true) then return true end
        end
    end
    return false
end

-- =============================================================================
-- CACHES
-- =============================================================================

local ItemEspCache, EntityEspCache, KeyEspCache = {}, {}, {}
local BookEspCache, MechEspCache, BreakerEspCache, DoorEspCache = {}, {}, {}, {}
local InteractEspCache = {}
local ScannerEspCache = {}

local function CacheCount(cache)
    local n = 0
    for _ in pairs(cache) do n = n + 1 end
    return n
end

local function CleanupCache(cache, isCandidate)
    for obj, data in pairs(cache) do
        if not obj or not obj.Parent or not isCandidate(obj) then
            if data.box and data.box.Parent then data.box:Destroy() end
            if data.label and data.label.Parent then data.label:Destroy() end
            if data.highlight and data.highlight.Parent then data.highlight:Destroy() end
            cache[obj] = nil
        end
    end
end

local function AddEspObject(cache, obj, color, labelText, boxSize, transparency, zindex, useHighlight)
    local identity = GetIdentity(obj)
    if cache[identity] then return end
    if CacheCount(cache) >= MAX_ESP_OBJECTS then return end

    local pos = GetWorldPos(identity) or GetWorldPos(obj)
    if not pos then return end
    if not WithinEspRange(pos) then return end

    local data = {}
    if useHighlight then
        data.highlight = CreateDoorHighlight(identity, identity, color)
    else
        local adornee = GetAdornee(identity) or GetAdornee(obj)
        if not adornee then return end
        data.box = CreateEspBox(identity, adornee, color, "DeltaEspBox", boxSize, transparency, zindex)
    end
    data.label = CreateEspLabel(identity, labelText, color, useHighlight and 12 or 10)
    cache[identity] = data
end

-- =============================================================================
-- ROOM DETECTION (throttled)
-- =============================================================================

local currentRoomModel = nil
local currentRoomNumber = nil
local lastRoomCheck = 0
local roomChanged = false

local function DetectCurrentRoom()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        local hint = pg:FindFirstChild("Hint")
        if hint and hint:IsA("TextLabel") then
            local num = string.match(hint.Text, "%d+")
            if num then
                local newNum = tonumber(num)
                if newNum ~= currentRoomNumber then
                    currentRoomNumber = newNum
                    currentRoomModel = nil
                    roomChanged = true
                end
            end
        end
    end

    if currentRoomModel and currentRoomModel.Parent then return end
    if os.clock() - lastRoomCheck < 2 then return end
    lastRoomCheck = os.clock()

    if currentRoomNumber then
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") and string.find(obj.Name, tostring(currentRoomNumber), 1, true) then
                currentRoomModel = obj
                roomChanged = true
                break
            end
        end
    end

    if not currentRoomModel then
        local hrp = GetLocalHRP()
        if hrp then
            local bestDist, bestModel = math.huge, nil
            for _, obj in pairs(workspace:GetChildren()) do
                if obj:IsA("Model") and (string.find(string.lower(obj.Name), "room") or string.find(string.lower(obj.Name), "door")) then
                    local p = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if p then
                        local d = (hrp.Position - p.Position).Magnitude
                        if d < bestDist then bestDist, bestModel = d, obj end
                    end
                end
            end
            if bestModel and bestDist < 150 then
                currentRoomModel = bestModel
                roomChanged = true
            end
        end
    end
end

-- =============================================================================
-- SCANNER STATE
-- =============================================================================

local ScanList = {}
local ScanToggles = {}
local lastScanDiscover = 0
local lastScanSignature = ""

local function IsInterestingForScanner(obj)
    if not obj or not obj.Parent then return false end
    if obj:IsA("Terrain") or obj:IsA("Camera") then return false end
    if string.find(obj.Name, "^Delta") then return false end
    if not (obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("Tool")) then return false end
    if obj:IsA("Tool") then return true end
    if currentRoomModel and obj == currentRoomModel then return false end
    if MatchesKeyword(obj.Name, SCANNER_KEYWORDS) then return true end
    if obj:FindFirstChildWhichIsA("ProximityPrompt", true) then return true end
    if obj:FindFirstChildWhichIsA("ClickDetector", true) then return true end
    return false
end

local function DiscoverRoomNames(scanList)
    local found = {}
    for _, obj in ipairs(scanList) do
        if IsInterestingForScanner(obj) then found[obj.Name] = true end
    end
    local newList = {}
    for name in pairs(found) do table.insert(newList, name) end
    table.sort(newList)
    ScanList = newList
end

local function RenderScanList()
    for _, ui in pairs(ScanToggles) do
        if ui and ui.Parent then ui:Destroy() end
    end
    ScanToggles = {}

    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 24)
    header.BackgroundTransparency = 1
    header.Text = "Objects in current room (" .. #ScanList .. "):"
    header.TextColor3 = CurrentThemeColor
    header.Font = Enum.Font.GothamBold
    header.TextSize = 11
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = P_Scanner
    ScanToggles["__header"] = header

    for _, name in ipairs(ScanList) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 30)
        row.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        local rc = Instance.new("UICorner"); rc.CornerRadius = UDim.new(0, 6); rc.Parent = row
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.7, 0, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = name
        lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 50, 0, 22)
        btn.Position = UDim2.new(1, -60, 0, 4)
        btn.BackgroundColor3 = _G.ScannerNames[name] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 60)
        btn.Text = _G.ScannerNames[name] and "ON" or "OFF"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 4); bc.Parent = btn
        btn.MouseButton1Click:Connect(function()
            _G.ScannerNames[name] = not _G.ScannerNames[name]
            btn.Text = _G.ScannerNames[name] and "ON" or "OFF"
            btn.BackgroundColor3 = _G.ScannerNames[name] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 60)
        end)
        row.Parent = P_Scanner
        ScanToggles[name] = row
    end
end

local function RenderScanListIfChanged()
    local sig = table.concat(ScanList, "|")
    if sig == lastScanSignature then return end
    lastScanSignature = sig
    RenderScanList()
end

-- =============================================================================
-- MAIN SCAN — scoped to room model, chunked
-- =============================================================================

local scanIndex = 1
local scanList = {}
local SCAN_CHUNK = 200

local function ProcessOneObject(obj)
    if _G.InteractablesEsp and IsInteractable(obj) then
        AddEspObject(InteractEspCache, obj, CurrentThemeColor, obj.Name, Vector3.new(3, 3, 3), 0.4, 15, false)
    end
    if _G.ItemEsp and IsItemCandidate(obj) then
        local c = obj:IsA("Tool") and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(0, 255, 180)
        AddEspObject(ItemEspCache, obj, c, obj.Name, Vector3.new(4, 6, 4), 0.6, 9, false)
    end
    if _G.KeyEsp and IsKeyCandidate(obj) then
        AddEspObject(KeyEspCache, obj, Color3.fromRGB(255, 220, 0), obj.Name, Vector3.new(4, 6, 4), 0.6, 9, false)
    end
    if _G.BookEsp and IsBookCandidate(obj) then
        AddEspObject(BookEspCache, obj, Color3.fromRGB(0, 200, 255), obj.Name, Vector3.new(4, 6, 4), 0.6, 9, false)
    end
    if _G.MechEsp and IsMechCandidate(obj) then
        AddEspObject(MechEspCache, obj, Color3.fromRGB(255, 140, 0), obj.Name, Vector3.new(4, 6, 4), 0.6, 9, false)
    end
    if _G.BreakerEsp and IsBreakerCandidate(obj) then
        AddEspObject(BreakerEspCache, obj, Color3.fromRGB(180, 80, 255), obj.Name, Vector3.new(4, 6, 4), 0.6, 9, false)
    end
    if _G.DoorEsp and IsDoorCandidate(obj) then
        local label = obj.Name
        local nv = obj:FindFirstChildWhichIsA("NumberValue")
        if nv then label = obj.Name .. " (" .. tostring(nv.Value) .. ")" end
        AddEspObject(DoorEspCache, obj, Color3.fromRGB(255, 220, 0), label, nil, nil, nil, true)
    end
    if obj:IsA("Model") or obj:IsA("BasePart") then
        if _G.EntityEsp and IsEntityCandidate(obj) then
            AddEspObject(EntityEspCache, obj, Color3.fromRGB(255, 30, 30), "⚠ " .. obj.Name, Vector3.new(7, 9, 7), 0.25, 20, false)
        end
    end
    if _G.ScannerNames[obj.Name] and CacheCount(ScannerEspCache) < MAX_SCANNER_OBJECTS then
        local identity = GetIdentity(obj)
        if not ScannerEspCache[identity] then
            local pos = GetWorldPos(identity) or GetWorldPos(obj)
            if pos and WithinEspRange(pos) then
                local adornee = GetAdornee(identity) or GetAdornee(obj)
                if adornee then
                    local box = CreateEspBox(identity, adornee, CurrentThemeColor, "DeltaEspBox", Vector3.new(3, 3, 3), 0.5, 8)
                    local label = CreateEspLabel(identity, identity.Name, CurrentThemeColor, 9)
                    ScannerEspCache[identity] = {box = box, label = label}
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.2)  -- 5 ticks per second
        DetectCurrentRoom()

        -- Rebuild scan list only when room changes or list is exhausted
        if roomChanged or scanIndex > #scanList then
            local root = (currentRoomModel and currentRoomModel.Parent) and currentRoomModel or workspace
            scanList = root:GetDescendants()
            scanIndex = 1
            roomChanged = false
            lastScanDiscover = os.clock()
            DiscoverRoomNames(scanList)
            RenderScanListIfChanged()
        end

        -- Process one chunk (200 objects max per tick)
        local endIdx = math.min(scanIndex + SCAN_CHUNK - 1, #scanList)
        for i = scanIndex, endIdx do
            local obj = scanList[i]
            if obj and obj.Parent then
                pcall(ProcessOneObject, obj)
            end
        end
        scanIndex = endIdx + 1

        -- Cheap cleanup pass (no full scan)
        CleanupCache(ItemEspCache, IsItemCandidate)
        CleanupCache(KeyEspCache, IsKeyCandidate)
        CleanupCache(BookEspCache, IsBookCandidate)
        CleanupCache(MechEspCache, IsMechCandidate)
        CleanupCache(BreakerEspCache, IsBreakerCandidate)
        CleanupCache(DoorEspCache, IsDoorCandidate)
        CleanupCache(EntityEspCache, IsEntityCandidate)
        CleanupCache(InteractEspCache, IsInteractable)

        for obj, data in pairs(ScannerEspCache) do
            if not obj or not obj.Parent or not _G.ScannerNames[obj.Name] then
                if data.box and data.box.Parent then data.box:Destroy() end
                if data.label and data.label.Parent then data.label:Destroy() end
                ScannerEspCache[obj] = nil
            else
                local pos = GetWorldPos(obj)
                local show = pos and WithinEspRange(pos)
                if data.box then data.box.Visible = show and true or false end
                if data.label then data.label.Enabled = show and true or false end
            end
        end
    end
end)

-- Entity pulse
task.spawn(function()
    while true do
        task.wait(0.4)
        for _, data in pairs(EntityEspCache) do
            if data.box and data.box.Parent then
                data.box.Transparency = 0.15 + math.abs(math.sin((tick() % 1) * math.pi)) * 0.35
            end
        end
    end
end)

-- =============================================================================
-- PANELS
-- =============================================================================

AddToggleComponent(P_Combat, "Box ESP (Players)", "BoxEsp")
AddToggleComponent(P_Combat, "ESP Team Colors", "EspTeamColor")
AddInputComponent(P_Combat, "ESP Range (studs):", "300", function(val) _G.EspRange = val end)
AddToggleComponent(P_Combat, "Interactables ESP", "InteractablesEsp")
AddToggleComponent(P_Combat, "Item ESP", "ItemEsp")
AddToggleComponent(P_Combat, "Item ESP - Tools Only", "ItemEspToolsOnly")
AddToggleComponent(P_Combat, "Key ESP", "KeyEsp")
AddToggleComponent(P_Combat, "Book ESP (Door 50)", "BookEsp")
AddToggleComponent(P_Combat, "Mechanism ESP (Door 150)", "MechEsp")
AddToggleComponent(P_Combat, "Breaker Pole ESP (Door 100)", "BreakerEsp")
AddToggleComponent(P_Combat, "Door ESP", "DoorEsp")
AddToggleComponent(P_Combat, "Entity ESP (Global)", "EntityEsp")
AddToggleComponent(P_Combat, "Entity ESP - Named", "EntityEspNamed")
AddToggleComponent(P_Combat, "Entity Spawn Alert", "EntityAlert", function(state)
    if not state then return end
    task.spawn(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("BasePart") then
                local kw = MatchesKeyword(obj.Name, ENTITY_KEYWORDS)
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
-- RUNTIME LOOPS
-- =============================================================================

function StartCheatEngineLoops()
    MinimizeBtn.Visible = true
    MainFrame.Visible = true

    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)

    RunService.Heartbeat:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            local rootPart = LocalPlayer.Character.HumanoidRootPart
            if humanoid.MoveDirection.Magnitude > 0 and _G.SpeedValue > 16 then
                local v = humanoid.MoveDirection * _G.SpeedValue
                rootPart.AssemblyLinearVelocity = Vector3.new(v.X, rootPart.AssemblyLinearVelocity.Y, v.Z)
            else
                humanoid.WalkSpeed = _G.SpeedValue
            end
            if humanoid.UseJumpPower then humanoid.JumpPower = _G.JumpValue else humanoid.JumpHeight = _G.JumpValue end
        end
        if _G.Fullbright then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255); Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255); Lighting.Brightness = 2; Lighting.GlobalShadows = false
        end
    end)

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

    UserInputService.JumpRequest:Connect(function()
        if _G.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)

    local playerEspAccum = 0
    RunService.Heartbeat:Connect(function(dt)
        playerEspAccum = playerEspAccum + dt
        if playerEspAccum < 0.1 then return end
        playerEspAccum = 0

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
                    if _G.Nametags and WithinEspRange(head.Position) then
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