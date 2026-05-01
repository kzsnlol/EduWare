loadstring(game:HttpGet("https://github.com/benzonati/Rivals-Anticheat-Bypass/raw/refs/heads/main/main.luau"))()

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
    Title = "EduWare",
    Footer = "made by the goat kzsn",
    NotifySide = "Right",
    ShowCustomCursor = false,
    MobileButtonsSide = "Right"
})

local Tabs = {
    Main = Window:AddTab("Main", "user"),
    Aim = Window:AddTab("Aim", "crosshair"),
    ESP = Window:AddTab("ESP", "eye"),
    Visuals = Window:AddTab("Visuals", "palette"),
    Movement = Window:AddTab("Movement", "move"),
    Rage = Window:AddTab("Rage", "skull"),
    Cosmetics = Window:AddTab("Cosmetics", "sparkles"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

local MainGroup = Tabs.Main:AddLeftGroupbox("General", "box")
local SilentAimGroup = Tabs.Aim:AddLeftGroupbox("Silent Aim", "target")
local AimbotGroup = Tabs.Aim:AddRightGroupbox("Aimbot", "crosshair")
local TriggerGroup = Tabs.Aim:AddLeftGroupbox("Triggerbot", "target")
local ESPGroup = Tabs.ESP:AddLeftGroupbox("ESP Settings", "eye")
local LightingGroup = Tabs.Visuals:AddLeftGroupbox("Lighting Customizer", "sun")
local SkyboxGroup = Tabs.Visuals:AddRightGroupbox("Skybox Changer", "cloud")
local MovementGroup = Tabs.Movement:AddLeftGroupbox("Movement", "move")
local EduVoidGroup = Tabs.Rage:AddLeftGroupbox("EduVoid (DANGER)", "skull")
local TPRageGroup = Tabs.Rage:AddLeftGroupbox("TP Rage", "target")
local SpinbotGroup = Tabs.Rage:AddRightGroupbox("Spinbot", "refresh-cw")
local FFAGroup = Tabs.Rage:AddLeftGroupbox("FFA Utilities", "shield")
local CosmeticsGroup = Tabs.Cosmetics:AddLeftGroupbox("Cosmetics Unlocker", "gift")
local ExitGroup = Tabs.Main:AddRightGroupbox("Exit", "door")

local Config = {
    AimbotEnabled = false,
    MouseAimbot = false,
    TeamCheck = true,
    VisibilityCheck = true,
    AimPart = "Head",
    Smoothness = 5,
    FOV = 250,
    ShowFOV = true,
    StickyAim = false,
    Prediction = 0,
    MaxDistance = 1000,
    AutoFire = false,
    TriggerBot = false,
    TriggerDelay = 50,
    AimLine = false,
    HitChance = 100,
    Resolver = false,
    AimShake = 0,
    NearestCursor = false,
    IgnoreDowned = true,
    AntiCurveSmooth = false,
    LockOnce = false,
    BodyAimIfLow = false,
    BodyAimThreshold = 30,
    AimWhileJumping = true,
    FlickBot = false,
    FlickSpeed = 1,
    ESPEnabled = false,
    ESPBoxes = true,
    ESPNames = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPTracers = false,
    ESPTracerOrigin = "Bottom",
    ESPSkeleton = false,
    ESPHeadDot = false,
    ESPFlags = false,
    ESPFillBox = false,
    ESPFillAlpha = 30,
    ESPOutline = false,
    ESPCornerBox = false,
    ESPMaxDist = 2000,
    ESPFontSize = 13,
    ESPThickness = 1,
    ESPTeamColor = false,
    ESPHighlightTarget = false,
    Crosshair = false,
    CrosshairSize = 6,
    CrosshairGap = 4,
    CrosshairDot = false,
    CrosshairT = false,
    CrosshairRotate = 0,
}

local HealthColorFull = Color3.fromRGB(0, 255, 255)
local HealthColorLow = Color3.fromRGB(128, 0, 255)

local flyEnabled = false
local flySpeed = 50
local flyBody = nil
local flyConnection = nil

local walkSpeedEnabled = false
local walkSpeedValue = 50
local originalWalkSpeed = 16

local jumpPowerEnabled = false
local jumpPowerValue = 50
local originalJumpPower = 50

local noClipEnabled = false
local infiniteJumpEnabled = false

local eduVoidEnabled = false
local eduVoidConnection = nil
local shootRemote = nil

pcall(function()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local remotes = replicatedStorage:FindFirstChild("Remotes")
    if remotes then
        local fighter = remotes:FindFirstChild("Fighter")
        if fighter then
            shootRemote = fighter:FindFirstChild("UseItem")
        end
    end
end)

local AimTarget = nil
local LockedOnce = false
local Camera = workspace.CurrentCamera
local LP = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Mouse = LP:GetMouse()
local ToggleActive = false

local FOVCircle, AimLineDraw, CrosshairLines, CrosshairDotDraw = nil, nil, {}, nil

local ESPObjects = {}
local SkeletonPairs = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"},
}

local ChamsEnabled = false
local ChamsColor = Color3.fromRGB(255, 0, 0)
local ChamsTransparency = 0.5

local silentAimRunning = false
local silentAimSettings = nil
local cosmeticsRunning = false
local cosmeticsThread = nil
local tpActive = false
local tpHeight = 5
local tpTeamCheck = true
local spinActive = false
local spinSpeed = 360
local spinConnection = nil
local spinGyro = nil
local ffaAutoRespawn = false
local ffaAutoAmmo = false
local ffaAutoHealth = false
local ffaConnection = nil

local lightingEnabled = false
local originalLighting = {
    Brightness = nil,
    ClockTime = nil,
    Ambient = nil,
    OutdoorAmbient = nil,
    ColorShift_Top = nil,
    ColorShift_Bottom = nil,
    FogColor = nil,
    FogEnd = nil,
    GlobalShadows = nil,
}

local skyAssets = {
    Default = nil,
    ["Classic Sky (Gray)"] = "rbxassetid://104821280309167",
    ["Retro Sky (Vintage Clouds)"] = "rbxassetid://73841228879962",
    ["Autumn Sky (Thanksgiving)"] = "rbxassetid://88177684583675",
    ["Red Sky"] = "rbxassetid://140698133250102",
    ["Green Clouds Skybox"] = "rbxassetid://113036863157630"
}

local function notify(msg, duration)
    Library:Notify({Title = "EduWare", Description = msg, Duration = duration or 2})
end

local function IsAlive(player)
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    if not char:FindFirstChild("HumanoidRootPart") then return false end
    if Config.IgnoreDowned and hum:GetState() == Enum.HumanoidStateType.Dead then return false end
    return true
end

local function IsTeammate(player)
    if not Config.TeamCheck then return false end
    if not LP.Team or not player.Team then return false end
    return LP.Team == player.Team
end

local function IsVisible(part)
    if not Config.VisibilityCheck then return true end
    local origin = Camera.CFrame.Position
    local dir = (part.Position - origin)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { LP.Character }
    local result = workspace:Raycast(origin, dir, params)
    if result then return result.Instance:IsDescendantOf(part.Parent) end
    return true
end

local function GetAimPart(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if Config.BodyAimIfLow and hum and (hum.Health / hum.MaxHealth * 100) <= Config.BodyAimThreshold then
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    end
    return char:FindFirstChild(Config.AimPart) or char:FindFirstChild("HumanoidRootPart")
end

local function GetHealthColor(healthPercent)
    local r = HealthColorFull.R + (HealthColorLow.R - HealthColorFull.R) * (1 - healthPercent)
    local g = HealthColorFull.G + (HealthColorLow.G - HealthColorFull.G) * (1 - healthPercent)
    local b = HealthColorFull.B + (HealthColorLow.B - HealthColorFull.B) * (1 - healthPercent)
    return Color3.new(r, g, b)
end

local function GetTarget(fromMouse)
    local closest = nil
    local shortDist = Config.FOV
    local origin
    if fromMouse or Config.NearestCursor then
        local mp = UIS:GetMouseLocation()
        origin = Vector2.new(mp.X, mp.Y)
    else
        origin = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and IsAlive(player) and not IsTeammate(player) then
            local char = player.Character
            local part = GetAimPart(char)
            if part then
                local localRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if localRoot and (part.Position - localRoot.Position).Magnitude <= Config.MaxDistance then
                    local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local d = (Vector2.new(sp.X, sp.Y) - origin).Magnitude
                        if d < shortDist and IsVisible(part) then
                            shortDist = d
                            closest = player
                        end
                    end
                end
            end
        end
    end
    return closest
end

local function GetClosestEnemyPosition()
    local closest = nil
    local closestDist = math.huge
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local lpPos = LP.Character.HumanoidRootPart.Position
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and IsAlive(plr) and not IsTeammate(plr) then
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local dist = (lpPos - char.HumanoidRootPart.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = char.HumanoidRootPart
                end
            end
        end
    end
    return closest
end

local function startEduVoid()
    if eduVoidConnection then eduVoidConnection:Disconnect() end
    
    eduVoidConnection = RunService.Heartbeat:Connect(function()
        if not eduVoidEnabled or not Window.Visible then return end
        
        local targetPart = GetClosestEnemyPosition()
        if not targetPart then return end
        
        local char = LP.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        local originalPos = char.HumanoidRootPart.Position
        local targetPos = targetPart.Position
        
        pcall(function()
            char:SetPrimaryPartCFrame(CFrame.new(targetPos))
        end)
        
        if shootRemote then
            pcall(function()
                local tool = char:FindFirstChildWhichIsA("Tool")
                if tool then
                    shootRemote:FireServer(tool)
                else
                    for _, item in pairs(char:GetChildren()) do
                        if item:IsA("Tool") then
                            shootRemote:FireServer(item)
                            break
                        end
                    end
                end
            end)
        else
            pcall(function()
                local vim = game:GetService("VirtualInputManager")
                local mp = UIS:GetMouseLocation()
                vim:SendMouseButtonEvent(mp, 0, true, Enum.UserInputType.MouseButton1, 0)
                vim:SendMouseButtonEvent(mp, 0, false, Enum.UserInputType.MouseButton1, 0)
            end)
        end
        
        pcall(function()
            char:SetPrimaryPartCFrame(CFrame.new(originalPos))
        end)
    end)
end

local function stopEduVoid()
    eduVoidEnabled = false
    if eduVoidConnection then eduVoidConnection:Disconnect() end
    eduVoidConnection = nil
end

local function startFly()
    if flyBody then flyBody:Destroy() end
    flyBody = Instance.new("BodyVelocity")
    flyBody.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBody.Velocity = Vector3.zero
    
    local function updateFly()
        if not flyEnabled or not Window.Visible then
            if flyBody and flyBody.Parent then flyBody:Destroy() end
            return
        end
        local char = LP.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if flyBody.Parent ~= char.HumanoidRootPart then
                flyBody.Parent = char.HumanoidRootPart
            end
            local dir = Vector3.zero
            local cam = workspace.CurrentCamera
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
            if dir.Magnitude > 0 then dir = dir.Unit end
            flyBody.Velocity = dir * flySpeed
        end
    end
    
    local connection = RunService.RenderStepped:Connect(updateFly)
    return connection
end

local function updateWalkSpeed()
    local char = LP.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if walkSpeedEnabled then
            hum.WalkSpeed = walkSpeedValue
        else
            hum.WalkSpeed = originalWalkSpeed
        end
    end
end

local function updateJumpPower()
    local char = LP.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if jumpPowerEnabled then
            hum.JumpPower = jumpPowerValue
        else
            hum.JumpPower = originalJumpPower
        end
    end
end

local function updateNoClip()
    local char = LP.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not noClipEnabled
            end
        end
    end
end

local function UpdateChams()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    if ChamsEnabled and Config.ESPEnabled and IsAlive(player) and not IsTeammate(player) then
                        local highlight = part:FindFirstChild("EduWareHighlight")
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.Name = "EduWareHighlight"
                            highlight.FillColor = ChamsColor
                            highlight.FillTransparency = ChamsTransparency
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.OutlineTransparency = 0.2
                            highlight.Parent = part
                        else
                            highlight.FillColor = ChamsColor
                            highlight.FillTransparency = ChamsTransparency
                            highlight.Enabled = true
                        end
                    else
                        local highlight = part:FindFirstChild("EduWareHighlight")
                        if highlight then highlight:Destroy() end
                    end
                end
            end
        end
    end
end

local function SetupDrawingObjects()
    pcall(function()
        FOVCircle = Drawing.new("Circle")
        FOVCircle.Thickness = 1
        FOVCircle.NumSides = 60
        FOVCircle.Radius = Config.FOV
        FOVCircle.Filled = false
        FOVCircle.Visible = Config.ShowFOV
        FOVCircle.Transparency = 0.6
        FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    end)
    pcall(function()
        AimLineDraw = Drawing.new("Line")
        AimLineDraw.Thickness = 1
        AimLineDraw.Color = Color3.fromRGB(255, 255, 255)
        AimLineDraw.Visible = false
        AimLineDraw.Transparency = 0.5
    end)
    pcall(function()
        for i = 1, 4 do
            local l = Drawing.new("Line")
            l.Thickness = 1
            l.Color = Color3.fromRGB(255, 255, 255)
            l.Visible = false
            CrosshairLines[i] = l
        end
        CrosshairDotDraw = Drawing.new("Circle")
        CrosshairDotDraw.Thickness = 1
        CrosshairDotDraw.NumSides = 12
        CrosshairDotDraw.Radius = 2
        CrosshairDotDraw.Filled = true
        CrosshairDotDraw.Color = Color3.fromRGB(255, 255, 255)
        CrosshairDotDraw.Visible = false
    end)
end

SetupDrawingObjects()

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == "RightShift" then
        ToggleActive = not ToggleActive
        Config.AimbotEnabled = ToggleActive
        notify(Config.AimbotEnabled and "Aimbot ON" or "Aimbot OFF", 1)
    end
end)

local renderConnection = RunService.RenderStepped:Connect(function(dt)
    Camera = workspace.CurrentCamera
    if not Camera then return end

    if FOVCircle then
        FOVCircle.Radius = Config.FOV
        FOVCircle.Visible = Config.ShowFOV and Config.AimbotEnabled
        if Config.MouseAimbot or Config.NearestCursor then
            local mp = UIS:GetMouseLocation()
            FOVCircle.Position = Vector2.new(mp.X, mp.Y)
        else
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        end
    end

    local cx = Camera.ViewportSize.X / 2
    local cy = Camera.ViewportSize.Y / 2
    if Config.Crosshair then
        local s = Config.CrosshairSize
        local g = Config.CrosshairGap
        local rot = math.rad(Config.CrosshairRotate)
        local function rotPoint(ox, oy)
            return cx + ox * math.cos(rot) - oy * math.sin(rot), cy + ox * math.sin(rot) + oy * math.cos(rot)
        end
        if CrosshairLines[1] then
            local x1, y1 = rotPoint(-(g + s), 0)
            local x2, y2 = rotPoint(-g, 0)
            CrosshairLines[1].From = Vector2.new(x1, y1); CrosshairLines[1].To = Vector2.new(x2, y2); CrosshairLines[1].Visible = true
        end
        if CrosshairLines[2] then
            local x1, y1 = rotPoint(g, 0)
            local x2, y2 = rotPoint(g + s, 0)
            CrosshairLines[2].From = Vector2.new(x1, y1); CrosshairLines[2].To = Vector2.new(x2, y2); CrosshairLines[2].Visible = true
        end
        if CrosshairLines[3] then
            local x1, y1 = rotPoint(0, -(g + s))
            local x2, y2 = rotPoint(0, -g)
            CrosshairLines[3].From = Vector2.new(x1, y1); CrosshairLines[3].To = Vector2.new(x2, y2); CrosshairLines[3].Visible = not Config.CrosshairT
        end
        if CrosshairLines[4] then
            local x1, y1 = rotPoint(0, g)
            local x2, y2 = rotPoint(0, g + s)
            CrosshairLines[4].From = Vector2.new(x1, y1); CrosshairLines[4].To = Vector2.new(x2, y2); CrosshairLines[4].Visible = true
        end
        if CrosshairDotDraw then CrosshairDotDraw.Position = Vector2.new(cx, cy); CrosshairDotDraw.Visible = Config.CrosshairDot end
    else
        for _, l in ipairs(CrosshairLines) do if l then l.Visible = false end end
        if CrosshairDotDraw then CrosshairDotDraw.Visible = false end
    end

    if not Config.AimWhileJumping and LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum:GetState() == Enum.HumanoidStateType.Freefall then
            if AimLineDraw then AimLineDraw.Visible = false end
            return
        end
    end

    if Config.AimbotEnabled then
        if Config.HitChance < 100 and math.random(1, 100) > Config.HitChance then
            if AimLineDraw then AimLineDraw.Visible = false end
            return
        end

        local target = nil
        if Config.LockOnce and LockedOnce then
            if AimLineDraw then AimLineDraw.Visible = false end
            return
        end
        if Config.StickyAim and AimTarget and IsAlive(AimTarget) then
            target = AimTarget
        else
            target = GetTarget(Config.MouseAimbot)
            AimTarget = target
        end

        if target and target.Character then
            local part = GetAimPart(target.Character)
            if part then
                local aimPos = part.Position

                if Config.Prediction > 0 then
                    local vel = part.AssemblyLinearVelocity or Vector3.zero
                    aimPos = aimPos + vel * (Config.Prediction / 10)
                end

                if Config.Resolver then
                    local root = target.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local mv = root.AssemblyLinearVelocity
                        if mv.Magnitude > 1 then aimPos = aimPos + mv.Unit * 2 end
                    end
                end

                if Config.AimShake > 0 then
                    local sh = Config.AimShake / 10
                    aimPos = aimPos + Vector3.new((math.random() - 0.5) * sh, (math.random() - 0.5) * sh, (math.random() - 0.5) * sh)
                end

                if Config.MouseAimbot then
                    local sp = Camera:WorldToViewportPoint(aimPos)
                    local tp = Vector2.new(sp.X, sp.Y)
                    local mp = UIS:GetMouseLocation()
                    local delta = tp - mp
                    local smooth = math.clamp(1 / Config.Smoothness, 0.05, 1)
                    if Config.FlickBot then smooth = math.clamp(Config.FlickSpeed / 2, 0.1, 1) end
                    if Config.AntiCurveSmooth then
                        local dist = delta.Magnitude
                        smooth = smooth * math.clamp(dist / 200, 0.3, 1)
                    end
                    pcall(function() mousemoverel(delta.X * smooth, delta.Y * smooth) end)
                else
                    local targetCF = CFrame.lookAt(Camera.CFrame.Position, aimPos)
                    local smooth = math.clamp(1 / Config.Smoothness, 0.01, 1)
                    if Config.FlickBot then smooth = math.clamp(Config.FlickSpeed / 2, 0.1, 1) end
                    if Config.AntiCurveSmooth then
                        local angle = math.acos(math.clamp(Camera.CFrame.LookVector:Dot(targetCF.LookVector), -1, 1))
                        smooth = smooth * math.clamp(angle / 1, 0.2, 1)
                    end
                    Camera.CFrame = Camera.CFrame:Lerp(targetCF, smooth)
                end

                if Config.LockOnce then LockedOnce = true end

                if AimLineDraw and Config.AimLine then
                    local sp2 = Camera:WorldToViewportPoint(aimPos)
                    AimLineDraw.From = Vector2.new(cx, cy)
                    AimLineDraw.To = Vector2.new(sp2.X, sp2.Y)
                    AimLineDraw.Visible = true
                else
                    if AimLineDraw then AimLineDraw.Visible = false end
                end

                if Config.AutoFire then pcall(function() mouse1click() end) end
            end
        else
            AimTarget = nil
            LockedOnce = false
            if AimLineDraw then AimLineDraw.Visible = false end
        end
    else
        AimTarget = nil
        LockedOnce = false
        if AimLineDraw then AimLineDraw.Visible = false end
    end
end)

local triggerConnection = RunService.Heartbeat:Connect(function()
    if Config.TriggerBot and LP.Character then
        local tgt = Mouse.Target
        if tgt and tgt.Parent then
            local tp = Players:GetPlayerFromCharacter(tgt.Parent)
            if not tp and tgt.Parent.Parent then tp = Players:GetPlayerFromCharacter(tgt.Parent.Parent) end
            if tp and tp ~= LP and IsAlive(tp) and not IsTeammate(tp) then
                task.delay(Config.TriggerDelay / 1000, function() pcall(function() mouse1click() end) end)
            end
        end
    end
end)

local function CreateESP(player)
    if ESPObjects[player] then return end
    local o = {}
    pcall(function()
        o.Box = Drawing.new("Square"); o.Box.Thickness = 1; o.Box.Filled = false; o.Box.Color = Color3.new(1,1,1); o.Box.Visible = false
        o.OutlineBox = Drawing.new("Square"); o.OutlineBox.Thickness = 3; o.OutlineBox.Filled = false; o.OutlineBox.Color = Color3.new(0,0,0); o.OutlineBox.Visible = false
        o.FillBox = Drawing.new("Square"); o.FillBox.Thickness = 1; o.FillBox.Filled = true; o.FillBox.Color = Color3.new(1,1,1); o.FillBox.Visible = false; o.FillBox.Transparency = 0.3
        o.Name = Drawing.new("Text"); o.Name.Size = 13; o.Name.Center = true; o.Name.Outline = true; o.Name.Color = Color3.new(1,1,1); o.Name.Visible = false
        o.HealthOutline = Drawing.new("Line"); o.HealthOutline.Thickness = 4; o.HealthOutline.Color = Color3.new(0,0,0); o.HealthOutline.Visible = false
        o.Health = Drawing.new("Line"); o.Health.Thickness = 2; o.Health.Color = Color3.new(0,1,0); o.Health.Visible = false
        o.Dist = Drawing.new("Text"); o.Dist.Size = 11; o.Dist.Center = true; o.Dist.Outline = true; o.Dist.Color = Color3.fromRGB(150,150,150); o.Dist.Visible = false
        o.Tracer = Drawing.new("Line"); o.Tracer.Thickness = 1; o.Tracer.Color = Color3.new(1,1,1); o.Tracer.Visible = false
        o.HeadDot = Drawing.new("Circle"); o.HeadDot.Thickness = 1; o.HeadDot.NumSides = 20; o.HeadDot.Radius = 3; o.HeadDot.Filled = true; o.HeadDot.Color = Color3.new(1,1,1); o.HeadDot.Visible = false
        o.Flags = Drawing.new("Text"); o.Flags.Size = 10; o.Flags.Center = false; o.Flags.Outline = true; o.Flags.Color = Color3.fromRGB(200,200,200); o.Flags.Visible = false
        o.CornerTL = Drawing.new("Line"); o.CornerTL.Thickness = 1; o.CornerTL.Color = Color3.new(1,1,1); o.CornerTL.Visible = false
        o.CornerTR = Drawing.new("Line"); o.CornerTR.Thickness = 1; o.CornerTR.Color = Color3.new(1,1,1); o.CornerTR.Visible = false
        o.CornerBL = Drawing.new("Line"); o.CornerBL.Thickness = 1; o.CornerBL.Color = Color3.new(1,1,1); o.CornerBL.Visible = false
        o.CornerBR = Drawing.new("Line"); o.CornerBR.Thickness = 1; o.CornerBR.Color = Color3.new(1,1,1); o.CornerBR.Visible = false
        o.CornerTL2 = Drawing.new("Line"); o.CornerTL2.Thickness = 1; o.CornerTL2.Color = Color3.new(1,1,1); o.CornerTL2.Visible = false
        o.CornerTR2 = Drawing.new("Line"); o.CornerTR2.Thickness = 1; o.CornerTR2.Color = Color3.new(1,1,1); o.CornerTR2.Visible = false
        o.CornerBL2 = Drawing.new("Line"); o.CornerBL2.Thickness = 1; o.CornerBL2.Color = Color3.new(1,1,1); o.CornerBL2.Visible = false
        o.CornerBR2 = Drawing.new("Line"); o.CornerBR2.Thickness = 1; o.CornerBR2.Color = Color3.new(1,1,1); o.CornerBR2.Visible = false
        o.Skeleton = {}
        for i = 1, 12 do local l = Drawing.new("Line"); l.Thickness = 1; l.Color = Color3.new(1,1,1); l.Visible = false; o.Skeleton[i] = l end
    end)
    ESPObjects[player] = o
end

local function HideESP(o)
    for k, v in pairs(o) do
        if k == "Skeleton" then for _, l in ipairs(v) do pcall(function() l.Visible = false end) end
        else pcall(function() v.Visible = false end) end
    end
end

local function DestroyESP(o)
    for k, v in pairs(o) do
        if k == "Skeleton" then for _, l in ipairs(v) do pcall(function() l:Remove() end) end
        else pcall(function() v:Remove() end) end
    end
end

local espRenderConnection = RunService.RenderStepped:Connect(function()
    if not Config.ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if ESPObjects[player] then HideESP(ESPObjects[player]) end
        end
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            if not ESPObjects[player] then CreateESP(player) end
            local o = ESPObjects[player]
            if not o then continue end
            local show = Config.ESPEnabled and IsAlive(player) and not IsTeammate(player)
            if show then
                local char = player.Character
                local root = char:FindFirstChild("HumanoidRootPart")
                local head = char:FindFirstChild("Head")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if root and head and hum then
                    local localRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    local dist3d = localRoot and (root.Position - localRoot.Position).Magnitude or 0
                    if dist3d > Config.ESPMaxDist then HideESP(o); continue end
                    local rp, onScreen = Camera:WorldToViewportPoint(root.Position)
                    local hp = Camera:WorldToViewportPoint((head.CFrame * CFrame.new(0, 0.5, 0)).Position)
                    local lpp = Camera:WorldToViewportPoint((root.CFrame * CFrame.new(0, -3, 0)).Position)
                    if onScreen then
                        local bh = math.abs(hp.Y - lpp.Y)
                        local bw = bh * 0.55
                        local color = Color3.new(1, 1, 1)
                        if Config.ESPTeamColor and player.Team then color = player.TeamColor.Color end
                        if Config.ESPHighlightTarget and AimTarget == player then color = Color3.fromRGB(255, 50, 50) end
                        local thick = Config.ESPThickness
                        local fs = Config.ESPFontSize
                        local bx = rp.X - bw / 2
                        local by = hp.Y

                        if o.OutlineBox then
                            o.OutlineBox.Size = Vector2.new(bw + 2, bh + 2)
                            o.OutlineBox.Position = Vector2.new(bx - 1, by - 1)
                            o.OutlineBox.Visible = Config.ESPBoxes and Config.ESPOutline and not Config.ESPCornerBox
                            o.OutlineBox.Thickness = thick + 2
                        end
                        if o.Box then
                            o.Box.Size = Vector2.new(bw, bh)
                            o.Box.Position = Vector2.new(bx, by)
                            o.Box.Visible = Config.ESPBoxes and not Config.ESPCornerBox
                            o.Box.Color = color
                            o.Box.Thickness = thick
                        end
                        if o.FillBox then
                            o.FillBox.Size = Vector2.new(bw, bh)
                            o.FillBox.Position = Vector2.new(bx, by)
                            o.FillBox.Transparency = Config.ESPFillAlpha / 100
                            o.FillBox.Visible = Config.ESPFillBox
                            o.FillBox.Color = color
                        end

                        local cornerLen = bw * 0.25
                        local showCorner = Config.ESPBoxes and Config.ESPCornerBox
                        if o.CornerTL then o.CornerTL.From = Vector2.new(bx, by); o.CornerTL.To = Vector2.new(bx + cornerLen, by); o.CornerTL.Color = color; o.CornerTL.Visible = showCorner end
                        if o.CornerTL2 then o.CornerTL2.From = Vector2.new(bx, by); o.CornerTL2.To = Vector2.new(bx, by + cornerLen); o.CornerTL2.Color = color; o.CornerTL2.Visible = showCorner end
                        if o.CornerTR then o.CornerTR.From = Vector2.new(bx + bw, by); o.CornerTR.To = Vector2.new(bx + bw - cornerLen, by); o.CornerTR.Color = color; o.CornerTR.Visible = showCorner end
                        if o.CornerTR2 then o.CornerTR2.From = Vector2.new(bx + bw, by); o.CornerTR2.To = Vector2.new(bx + bw, by + cornerLen); o.CornerTR2.Color = color; o.CornerTR2.Visible = showCorner end
                        if o.CornerBL then o.CornerBL.From = Vector2.new(bx, by + bh); o.CornerBL.To = Vector2.new(bx + cornerLen, by + bh); o.CornerBL.Color = color; o.CornerBL.Visible = showCorner end
                        if o.CornerBL2 then o.CornerBL2.From = Vector2.new(bx, by + bh); o.CornerBL2.To = Vector2.new(bx, by + bh - cornerLen); o.CornerBL2.Color = color; o.CornerBL2.Visible = showCorner end
                        if o.CornerBR then o.CornerBR.From = Vector2.new(bx + bw, by + bh); o.CornerBR.To = Vector2.new(bx + bw - cornerLen, by + bh); o.CornerBR.Color = color; o.CornerBR.Visible = showCorner end
                        if o.CornerBR2 then o.CornerBR2.From = Vector2.new(bx + bw, by + bh); o.CornerBR2.To = Vector2.new(bx + bw, by + bh - cornerLen); o.CornerBR2.Color = color; o.CornerBR2.Visible = showCorner end

                        if o.Name then o.Name.Text = player.DisplayName; o.Name.Position = Vector2.new(rp.X, by - fs - 2); o.Name.Visible = Config.ESPNames; o.Name.Color = color; o.Name.Size = fs end
                        
                        if o.HealthOutline and o.Health and Config.ESPHealth then
                            local hbx = bx - 5
                            local outlineX = hbx - 1
                            local hpf = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            local healthColor = GetHealthColor(hpf)
                            
                            o.HealthOutline.From = Vector2.new(outlineX, by - 1)
                            o.HealthOutline.To = Vector2.new(outlineX, by + bh + 1)
                            o.HealthOutline.Visible = true
                            
                            o.Health.From = Vector2.new(hbx, by + bh)
                            o.Health.To = Vector2.new(hbx, by + bh - bh * hpf)
                            o.Health.Color = healthColor
                            o.Health.Visible = true
                        end
                        
                        if o.Dist then o.Dist.Text = math.floor(dist3d) .. "m"; o.Dist.Position = Vector2.new(rp.X, by + bh + 2); o.Dist.Visible = Config.ESPDistance; o.Dist.Size = fs - 2 end
                        
                        if o.Tracer then
                            local vp = Camera.ViewportSize
                            local from
                            if Config.ESPTracerOrigin == "Bottom" then from = Vector2.new(vp.X / 2, vp.Y)
                            elseif Config.ESPTracerOrigin == "Top" then from = Vector2.new(vp.X / 2, 0)
                            elseif Config.ESPTracerOrigin == "Center" then from = Vector2.new(vp.X / 2, vp.Y / 2)
                            else local mp = UIS:GetMouseLocation(); from = Vector2.new(mp.X, mp.Y) end
                            o.Tracer.From = from; o.Tracer.To = Vector2.new(rp.X, by + bh); o.Tracer.Visible = Config.ESPTracers; o.Tracer.Color = color
                        end
                        
                        if o.HeadDot then
                            local hdp = Camera:WorldToViewportPoint(head.Position)
                            o.HeadDot.Position = Vector2.new(hdp.X, hdp.Y); o.HeadDot.Visible = Config.ESPHeadDot; o.HeadDot.Color = color
                        end
                        
                        if o.Flags then
                            local flags = {}
                            table.insert(flags, math.floor(hum.Health) .. "hp")
                            if hum.WalkSpeed > 16 then table.insert(flags, "speed") end
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then table.insert(flags, tool.Name) end
                            o.Flags.Text = table.concat(flags, "\n"); o.Flags.Position = Vector2.new(bx + bw + 4, by); o.Flags.Visible = Config.ESPFlags and #flags > 0
                        end
                        
                        if o.Skeleton and Config.ESPSkeleton then
                            for i, pair in ipairs(SkeletonPairs) do
                                local line = o.Skeleton[i]
                                if line then
                                    local p1 = char:FindFirstChild(pair[1])
                                    local p2 = char:FindFirstChild(pair[2])
                                    if p1 and p2 then
                                        local s1, v1 = Camera:WorldToViewportPoint(p1.Position)
                                        local s2, v2 = Camera:WorldToViewportPoint(p2.Position)
                                        if v1 and v2 then line.From = Vector2.new(s1.X, s1.Y); line.To = Vector2.new(s2.X, s2.Y); line.Color = color; line.Visible = true
                                        else line.Visible = false end
                                    else line.Visible = false end
                                end
                            end
                        else if o.Skeleton then for _, l in ipairs(o.Skeleton) do pcall(function() l.Visible = false end) end end end
                    else HideESP(o) end
                else HideESP(o) end
            else HideESP(o) end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then DestroyESP(ESPObjects[player]); ESPObjects[player] = nil end
end)

local function applyLighting()
    local lighting = game:GetService("Lighting")
    
    if originalLighting.Brightness == nil then
        originalLighting.Brightness = lighting.Brightness
        originalLighting.ClockTime = lighting.ClockTime
        originalLighting.Ambient = lighting.Ambient
        originalLighting.OutdoorAmbient = lighting.OutdoorAmbient
        originalLighting.ColorShift_Top = lighting.ColorShift_Top
        originalLighting.ColorShift_Bottom = lighting.ColorShift_Bottom
        originalLighting.FogColor = lighting.FogColor
        originalLighting.FogEnd = lighting.FogEnd
        originalLighting.GlobalShadows = lighting.GlobalShadows
    end
    
    if lightingEnabled then
    else
        lighting.Brightness = originalLighting.Brightness
        lighting.ClockTime = originalLighting.ClockTime
        lighting.Ambient = originalLighting.Ambient
        lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        lighting.ColorShift_Top = originalLighting.ColorShift_Top
        lighting.ColorShift_Bottom = originalLighting.ColorShift_Bottom
        lighting.FogColor = originalLighting.FogColor
        lighting.FogEnd = originalLighting.FogEnd
        lighting.GlobalShadows = originalLighting.GlobalShadows
    end
end

local function setSky(asset)
    pcall(function()
        local lighting = game:GetService("Lighting")
        for _, obj in pairs(lighting:GetChildren()) do
            if obj:IsA("Sky") then obj:Destroy() end
        end
        if asset then
            local sky = Instance.new("Sky")
            sky.SkyboxBk = asset
            sky.SkyboxDn = asset
            sky.SkyboxFt = asset
            sky.SkyboxLf = asset
            sky.SkyboxRt = asset
            sky.SkyboxUp = asset
            sky.Parent = lighting
        end
    end)
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    updateWalkSpeed()
    updateJumpPower()
    updateNoClip()
    if flyEnabled and flyBody then
        flyBody:Destroy()
        flyBody = Instance.new("BodyVelocity")
        flyBody.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyBody.Velocity = Vector3.zero
    end
end)

UIS.JumpRequest:Connect(function()
    if infiniteJumpEnabled and LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local function loadSilentAim()
    if silentAimRunning then return end
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/EndOverdosing/Soluna-API/refs/heads/main/rivals-silent-aim.lua"))()
    end)
    if success and result then
        silentAimSettings = result
        silentAimRunning = true
        notify("Silent Aim ENABLED", 2)
    else
        notify("Silent Aim FAILED", 2)
    end
end

local function unloadSilentAim()
    if silentAimSettings then pcall(function() silentAimSettings.Enabled = false end) end
    silentAimSettings = nil
    silentAimRunning = false
    notify("Silent Aim DISABLED", 2)
end

local function loadCosmetics()
    if cosmeticsRunning then return end
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://pastefy.app/6ElsMLeb/raw"))()
    end)
    if success and result then
        cosmeticsThread = result
        cosmeticsRunning = true
        notify("Cosmetics Unlocker ENABLED", 2)
    else
        notify("Cosmetics Unlocker FAILED", 2)
    end
end

local function unloadCosmetics()
    cosmeticsRunning = false
    cosmeticsThread = nil
    collectgarbage()
    notify("Cosmetics Unlocker DISABLED", 2)
end

spawn(function()
    while true do
        task.wait(0.1)
        if not tpActive or not Window.Visible then continue end
        
        local lp = game.Players.LocalPlayer
        if not lp.Character then continue end
        local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        local closest = nil
        local closestDist = math.huge
        local lpPos = hrp.Position
        
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= lp then
                if tpTeamCheck and lp.Team and plr.Team and lp.Team == plr.Team then continue end
                local char = plr.Character
                if char then
                    local targetHrp = char:FindFirstChild("HumanoidRootPart")
                    local humanoid = char:FindFirstChild("Humanoid")
                    if targetHrp and humanoid and humanoid.Health > 0 then
                        local dist = (lpPos - targetHrp.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closest = targetHrp
                        end
                    end
                end
            end
        end
        
        if closest then
            local newPos = closest.Position + Vector3.new(0, -tpHeight, 0)
            pcall(function()
                local model = lp.Character
                if model and model.Parent then
                    local oldVelocity = hrp.Velocity
                    model:SetPrimaryPartCFrame(CFrame.new(newPos))
                    hrp.Velocity = oldVelocity
                end
            end)
        end
    end
end)

local function startSpinbot()
    if spinConnection then spinConnection:Disconnect() end
    if spinGyro then spinGyro:Destroy() end
    spinGyro = nil
    
    spinConnection = RunService.RenderStepped:Connect(function()
        if not spinActive or not Window.Visible then
            if spinGyro then spinGyro:Destroy(); spinGyro = nil end
            return
        end
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            if not spinGyro or spinGyro.Parent ~= root then
                if spinGyro then spinGyro:Destroy() end
                spinGyro = Instance.new("BodyGyro")
                spinGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
                spinGyro.P = 10000
                spinGyro.Parent = root
            end
            spinGyro.CFrame = CFrame.Angles(0, math.rad((tick() * spinSpeed) % 360), 0)
        end
    end)
end

local function stopSpinbot()
    if spinConnection then spinConnection:Disconnect() end
    if spinGyro then spinGyro:Destroy() end
    spinConnection = nil
    spinGyro = nil
end

local function startFFA()
    if ffaConnection then ffaConnection:Disconnect() end
    local lp = game.Players.LocalPlayer
    local t = 0
    
    ffaConnection = RunService.RenderStepped:Connect(function(dt)
        if not (ffaAutoAmmo or ffaAutoHealth) then return end
        local char = lp.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        t = t + dt * 8
        local bounce = math.sin(t) * 4
        
        for _, obj in workspace:GetChildren() do
            if obj.Name == "_drop" and obj:IsA("BasePart") then
                local shouldPull = (ffaAutoAmmo and obj:FindFirstChild("Ammo")) or (ffaAutoHealth and obj:FindFirstChild("Health"))
                if shouldPull then
                    pcall(function()
                        obj.Anchored = true
                        obj.CFrame = CFrame.new(hrp.Position + Vector3.new(0, bounce, 0))
                        obj.Transparency = 1
                        for _, child in pairs(obj:GetDescendants()) do
                            if child:IsA("BasePart") or child:IsA("UnionOperation") or child:IsA("MeshPart") then
                                child.Transparency = 1
                            end
                            if child:IsA("BillboardGui") or child:IsA("SurfaceGui") or child:IsA("ParticleEmitter") then
                                child.Enabled = false
                            end
                        end
                    end)
                end
            end
        end
    end)
    
    lp.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            if not ffaAutoRespawn then return end
            task.spawn(function()
                while ffaAutoRespawn do
                    local char = lp.Character
                    if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then break end
                    pcall(function()
                        keypress(0x20)
                        task.wait(0.1)
                        keyrelease(0x20)
                        task.wait(0.1)
                    end)
                end
            end)
        end)
    end)
end

local function stopFFA()
    if ffaConnection then ffaConnection:Disconnect() end
    ffaConnection = nil
end

SilentAimGroup:AddCheckbox("SilentAimToggle", {
    Text = "Enable Silent Aim", Default = false,
    Callback = function(v) if v then loadSilentAim() else unloadSilentAim() end end
})

AimbotGroup:AddCheckbox("MouseAimbot", {Text = "Mouse Aimbot", Default = false, Callback = function(v) Config.MouseAimbot = v end})
AimbotGroup:AddCheckbox("TeamCheck", {Text = "Team Check", Default = true, Callback = function(v) Config.TeamCheck = v end})
AimbotGroup:AddCheckbox("VisibilityCheck", {Text = "Visibility Check", Default = true, Callback = function(v) Config.VisibilityCheck = v end})
AimbotGroup:AddCheckbox("StickyAim", {Text = "Sticky Aim", Default = false, Callback = function(v) Config.StickyAim = v end})
AimbotGroup:AddCheckbox("LockOnce", {Text = "Lock Once", Default = false, Callback = function(v) Config.LockOnce = v end})
AimbotGroup:AddCheckbox("NearestCursor", {Text = "Nearest to Cursor", Default = false, Callback = function(v) Config.NearestCursor = v end})
AimbotGroup:AddCheckbox("IgnoreDowned", {Text = "Ignore Downed", Default = true, Callback = function(v) Config.IgnoreDowned = v end})
AimbotGroup:AddCheckbox("AimWhileJumping", {Text = "Aim While Jumping", Default = true, Callback = function(v) Config.AimWhileJumping = v end})
AimbotGroup:AddDropdown("AimPart", {Text = "Aim Part", Values = {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso"}, Default = 1, Callback = function(v) Config.AimPart = v end})
AimbotGroup:AddCheckbox("BodyAimIfLow", {Text = "Body Aim if Low HP", Default = false, Callback = function(v) Config.BodyAimIfLow = v end})
AimbotGroup:AddSlider("BodyAimThreshold", {Text = "Body Aim Threshold %", Default = 30, Min = 1, Max = 100, Rounding = 1, Callback = function(v) Config.BodyAimThreshold = v end})
AimbotGroup:AddSlider("Smoothness", {Text = "Smoothness", Default = 5, Min = 1, Max = 20, Rounding = 1, Callback = function(v) Config.Smoothness = v end})
AimbotGroup:AddSlider("FOV", {Text = "FOV Radius", Default = 250, Min = 50, Max = 800, Rounding = 0, Callback = function(v) Config.FOV = v end})
AimbotGroup:AddSlider("MaxDistance", {Text = "Max Distance", Default = 1000, Min = 100, Max = 5000, Rounding = 0, Callback = function(v) Config.MaxDistance = v end})
AimbotGroup:AddSlider("Prediction", {Text = "Prediction", Default = 0, Min = 0, Max = 30, Rounding = 1, Callback = function(v) Config.Prediction = v end})
AimbotGroup:AddSlider("HitChance", {Text = "Hit Chance %", Default = 100, Min = 1, Max = 100, Rounding = 0, Callback = function(v) Config.HitChance = v end})
AimbotGroup:AddSlider("AimShake", {Text = "Aim Shake", Default = 0, Min = 0, Max = 20, Rounding = 1, Callback = function(v) Config.AimShake = v end})
AimbotGroup:AddCheckbox("AutoFire", {Text = "Auto Fire", Default = false, Callback = function(v) Config.AutoFire = v end})
AimbotGroup:AddCheckbox("Resolver", {Text = "Resolver", Default = false, Callback = function(v) Config.Resolver = v end})
AimbotGroup:AddCheckbox("FlickBot", {Text = "FlickBot", Default = false, Callback = function(v) Config.FlickBot = v end})
AimbotGroup:AddSlider("FlickSpeed", {Text = "Flick Speed", Default = 1, Min = 1, Max = 10, Rounding = 1, Callback = function(v) Config.FlickSpeed = v end})
AimbotGroup:AddCheckbox("AntiCurveSmooth", {Text = "Anti Curve Smooth", Default = false, Callback = function(v) Config.AntiCurveSmooth = v end})
AimbotGroup:AddCheckbox("ShowFOV", {Text = "Show FOV Circle", Default = true, Callback = function(v) Config.ShowFOV = v end})
AimbotGroup:AddCheckbox("AimLine", {Text = "Aim Line", Default = false, Callback = function(v) Config.AimLine = v end})

TriggerGroup:AddCheckbox("TriggerBot", {Text = "Enable Triggerbot", Default = false, Callback = function(v) Config.TriggerBot = v end})
TriggerGroup:AddSlider("TriggerDelay", {Text = "Trigger Delay (ms)", Default = 50, Min = 0, Max = 500, Rounding = 0, Callback = function(v) Config.TriggerDelay = v end})

ESPGroup:AddCheckbox("ESPEnabled", {Text = "Enable ESP", Default = false, Callback = function(v) Config.ESPEnabled = v; UpdateChams() end})
ESPGroup:AddCheckbox("ESPBoxes", {Text = "Boxes", Default = true, Callback = function(v) Config.ESPBoxes = v end})
ESPGroup:AddCheckbox("ESPCornerBox", {Text = "Corner Box", Default = false, Callback = function(v) Config.ESPCornerBox = v end})
ESPGroup:AddCheckbox("ESPFillBox", {Text = "Filled Boxes", Default = false, Callback = function(v) Config.ESPFillBox = v end})
ESPGroup:AddSlider("ESPFillAlpha", {Text = "Fill Opacity %", Default = 30, Min = 0, Max = 100, Rounding = 0, Callback = function(v) Config.ESPFillAlpha = v end})
ESPGroup:AddCheckbox("ESPOutline", {Text = "Outline", Default = false, Callback = function(v) Config.ESPOutline = v end})
ESPGroup:AddCheckbox("ESPNames", {Text = "Names", Default = true, Callback = function(v) Config.ESPNames = v end})
ESPGroup:AddCheckbox("ESPHealth", {Text = "Health Bars", Default = true, Callback = function(v) Config.ESPHealth = v end})
ESPGroup:AddCheckbox("ESPDistance", {Text = "Distance", Default = true, Callback = function(v) Config.ESPDistance = v end})
ESPGroup:AddCheckbox("ESPTracers", {Text = "Tracers", Default = false, Callback = function(v) Config.ESPTracers = v end})
ESPGroup:AddDropdown("ESPTracerOrigin", {Text = "Tracer Origin", Values = {"Bottom", "Center", "Top", "Mouse"}, Default = 1, Callback = function(v) Config.ESPTracerOrigin = v end})
ESPGroup:AddCheckbox("ESPSkeleton", {Text = "Skeleton", Default = false, Callback = function(v) Config.ESPSkeleton = v end})
ESPGroup:AddCheckbox("ESPHeadDot", {Text = "Head Dot", Default = false, Callback = function(v) Config.ESPHeadDot = v end})
ESPGroup:AddCheckbox("ESPFlags", {Text = "Flags", Default = false, Callback = function(v) Config.ESPFlags = v end})
ESPGroup:AddSlider("ESPMaxDist", {Text = "Max Distance", Default = 2000, Min = 100, Max = 10000, Rounding = 0, Callback = function(v) Config.ESPMaxDist = v end})
ESPGroup:AddSlider("ESPFontSize", {Text = "Font Size", Default = 13, Min = 8, Max = 20, Rounding = 0, Callback = function(v) Config.ESPFontSize = v end})
ESPGroup:AddSlider("ESPThickness", {Text = "Thickness", Default = 1, Min = 1, Max = 5, Rounding = 0, Callback = function(v) Config.ESPThickness = v end})
ESPGroup:AddCheckbox("ESPTeamColor", {Text = "Team Color", Default = false, Callback = function(v) Config.ESPTeamColor = v end})
ESPGroup:AddCheckbox("ESPHighlightTarget", {Text = "Highlight Target", Default = false, Callback = function(v) Config.ESPHighlightTarget = v end})

ESPGroup:AddSection("Health Bar Gradient")
ESPGroup:AddColorPicker("HealthFullColor", {Text = "Full Health Color", Default = Color3.fromRGB(0, 255, 255), Callback = function(v) HealthColorFull = v end})
ESPGroup:AddColorPicker("HealthLowColor", {Text = "Low Health Color", Default = Color3.fromRGB(128, 0, 255), Callback = function(v) HealthColorLow = v end})

ESPGroup:AddSection("Chams")
ESPGroup:AddCheckbox("ChamsEnabled", {Text = "Enable Chams", Default = false, Callback = function(v) 
    ChamsEnabled = v
    if not v then
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    local highlight = part:FindFirstChild("EduWareHighlight")
                    if highlight then highlight:Destroy() end
                end
            end
        end
    else
        UpdateChams()
    end
end})
ESPGroup:AddColorPicker("ChamsColor", {Text = "Chams Color", Default = Color3.fromRGB(255, 0, 0), Callback = function(v) ChamsColor = v; UpdateChams() end})
ESPGroup:AddSlider("ChamsTransparency", {Text = "Chams Transparency", Default = 50, Min = 0, Max = 100, Rounding = 0, Callback = function(v) ChamsTransparency = v / 100; UpdateChams() end})

MovementGroup:AddCheckbox("FlyToggle", {Text = "Fly", Default = false, Callback = function(v) 
    flyEnabled = v
    if flyEnabled then
        if flyConnection then flyConnection:Disconnect() end
        flyConnection = startFly()
        notify("Fly ENABLED", 2)
    else
        if flyConnection then flyConnection:Disconnect() end
        if flyBody then flyBody:Destroy() end
        notify("Fly DISABLED", 1)
    end
end})
MovementGroup:AddSlider("FlySpeedSlider", {Text = "Fly Speed", Default = 50, Min = 10, Max = 500, Rounding = 0, Callback = function(v) flySpeed = v end})

MovementGroup:AddCheckbox("WalkSpeedToggle", {Text = "WalkSpeed", Default = false, Callback = function(v) 
    walkSpeedEnabled = v
    updateWalkSpeed()
    notify(v and "WalkSpeed ENABLED at " .. walkSpeedValue or "WalkSpeed DISABLED", 1)
end})
MovementGroup:AddSlider("WalkSpeedSlider", {Text = "WalkSpeed Value", Default = 50, Min = 16, Max = 500, Rounding = 0, Callback = function(v) 
    walkSpeedValue = v
    if walkSpeedEnabled then updateWalkSpeed() end
end})

MovementGroup:AddCheckbox("JumpPowerToggle", {Text = "Jump Power", Default = false, Callback = function(v) 
    jumpPowerEnabled = v
    updateJumpPower()
    notify(v and "Jump Power ENABLED at " .. jumpPowerValue or "Jump Power DISABLED", 1)
end})
MovementGroup:AddSlider("JumpPowerSlider", {Text = "Jump Power Value", Default = 50, Min = 40, Max = 300, Rounding = 0, Callback = function(v) 
    jumpPowerValue = v
    if jumpPowerEnabled then updateJumpPower() end
end})

MovementGroup:AddCheckbox("NoClipToggle", {Text = "No Clip", Default = false, Callback = function(v) 
    noClipEnabled = v
    updateNoClip()
    notify(v and "No Clip ENABLED" or "No Clip DISABLED", 1)
end})

MovementGroup:AddCheckbox("InfiniteJumpToggle", {Text = "Infinite Jump", Default = false, Callback = function(v) 
    infiniteJumpEnabled = v
    notify(v and "Infinite Jump ENABLED" or "Infinite Jump DISABLED", 1)
end})

EduVoidGroup:AddCheckbox("EduVoidToggle", {Text = "EduVoid", Default = false, Callback = function(v) 
    eduVoidEnabled = v
    if v then 
        startEduVoid()
        notify("I Warned you, You might get fucking Banned", 4)
    else 
        stopEduVoid()
        notify("EduVoid DEACTIVATED", 1)
    end
end})
EduVoidGroup:AddLabel("WARNING: Extremely dangerous and detectable!")
EduVoidGroup:AddLabel("Teleports to enemy, shoots, teleports back instantly")
EduVoidGroup:AddLabel("Completely invisible to the human eye")

LightingGroup:AddCheckbox("LightingEnabled", {Text = "Enable Custom Lighting", Default = false, Callback = function(v) 
    lightingEnabled = v 
    applyLighting()
end})
LightingGroup:AddSlider("BrightnessSlider", {Text = "Brightness", Default = 1, Min = 0, Max = 4, Rounding = 2, Callback = function(v) 
    if lightingEnabled then game:GetService("Lighting").Brightness = v end
end})
LightingGroup:AddSlider("ClockTimeSlider", {Text = "Time of Day", Default = 14, Min = 0, Max = 24, Rounding = 1, Callback = function(v) 
    if lightingEnabled then game:GetService("Lighting").ClockTime = v end
end})
LightingGroup:AddColorPicker("AmbientColor", {Text = "Ambient Color", Default = Color3.fromRGB(128, 128, 128), Callback = function(v) 
    if lightingEnabled then game:GetService("Lighting").Ambient = v end
end})
LightingGroup:AddColorPicker("OutdoorAmbientColor", {Text = "Outdoor Ambient", Default = Color3.fromRGB(128, 128, 128), Callback = function(v) 
    if lightingEnabled then game:GetService("Lighting").OutdoorAmbient = v end
end})
LightingGroup:AddColorPicker("ColorShiftTop", {Text = "Color Shift Top", Default = Color3.fromRGB(0, 0, 0), Callback = function(v) 
    if lightingEnabled then game:GetService("Lighting").ColorShift_Top = v end
end})
LightingGroup:AddColorPicker("ColorShiftBottom", {Text = "Color Shift Bottom", Default = Color3.fromRGB(0, 0, 0), Callback = function(v) 
    if lightingEnabled then game:GetService("Lighting").ColorShift_Bottom = v end
end})
LightingGroup:AddColorPicker("FogColor", {Text = "Fog Color", Default = Color3.fromRGB(128, 128, 128), Callback = function(v) 
    if lightingEnabled then game:GetService("Lighting").FogColor = v end
end})
LightingGroup:AddSlider("FogEndSlider", {Text = "Fog End Distance", Default = 100000, Min = 100, Max = 100000, Rounding = 0, Callback = function(v) 
    if lightingEnabled then game:GetService("Lighting").FogEnd = v end
end})
LightingGroup:AddCheckbox("GlobalShadows", {Text = "Global Shadows", Default = true, Callback = function(v) 
    if lightingEnabled then game:GetService("Lighting").GlobalShadows = v end
end})

SkyboxGroup:AddDropdown("SkyboxDropdown", {Text = "Custom Sky", Values = {"Default", "Classic Sky (Gray)", "Retro Sky (Vintage Clouds)", "Autumn Sky (Thanksgiving)", "Red Sky", "Green Clouds Skybox"}, Default = 1, Callback = function(v) setSky(skyAssets[v]) end})

AimbotGroup:AddSection("Crosshair")
AimbotGroup:AddCheckbox("Crosshair", {Text = "Custom Crosshair", Default = false, Callback = function(v) Config.Crosshair = v end})
AimbotGroup:AddSlider("CrosshairSize", {Text = "Size", Default = 6, Min = 2, Max = 20, Rounding = 0, Callback = function(v) Config.CrosshairSize = v end})
AimbotGroup:AddSlider("CrosshairGap", {Text = "Gap", Default = 4, Min = 0, Max = 15, Rounding = 0, Callback = function(v) Config.CrosshairGap = v end})
AimbotGroup:AddCheckbox("CrosshairDot", {Text = "Center Dot", Default = false, Callback = function(v) Config.CrosshairDot = v end})
AimbotGroup:AddCheckbox("CrosshairT", {Text = "T-Shape", Default = false, Callback = function(v) Config.CrosshairT = v end})
AimbotGroup:AddSlider("CrosshairRotate", {Text = "Rotation", Default = 0, Min = 0, Max = 45, Rounding = 0, Callback = function(v) Config.CrosshairRotate = v end})

TPRageGroup:AddCheckbox("TPRageToggle", {Text = "TP Rage", Default = false, Callback = function(v) tpActive = v end})
TPRageGroup:AddSlider("TPRageHeight", {Text = "Studs Below", Default = 5, Min = 0, Max = 25, Rounding = 1, Callback = function(v) tpHeight = v end})
TPRageGroup:AddCheckbox("TPRageTeamCheck", {Text = "Team Check", Default = true, Callback = function(v) tpTeamCheck = v end})

SpinbotGroup:AddCheckbox("SpinbotToggle", {Text = "Spinbot", Default = false, Callback = function(v) spinActive = v; if v then startSpinbot() else stopSpinbot() end end})
SpinbotGroup:AddSlider("SpinbotSpeed", {Text = "Speed (deg/sec)", Default = 360, Min = 0, Max = 2000, Rounding = 0, Callback = function(v) spinSpeed = v; if spinActive then stopSpinbot(); startSpinbot() end end})

FFAGroup:AddCheckbox("FFAAutoRespawn", {Text = "Auto Respawn", Default = false, Callback = function(v) ffaAutoRespawn = v; if ffaAutoAmmo or ffaAutoHealth or ffaAutoRespawn then startFFA() else stopFFA() end end})
FFAGroup:AddCheckbox("FFAAutoAmmo", {Text = "Auto Ammo", Default = false, Callback = function(v) ffaAutoAmmo = v; if ffaAutoAmmo or ffaAutoHealth or ffaAutoRespawn then startFFA() else stopFFA() end end})
FFAGroup:AddCheckbox("FFAAutoHealth", {Text = "Auto Health", Default = false, Callback = function(v) ffaAutoHealth = v; if ffaAutoAmmo or ffaAutoHealth or ffaAutoRespawn then startFFA() else stopFFA() end end})

CosmeticsGroup:AddCheckbox("CosmeticsToggle", {Text = "Unlock All", Default = false, Callback = function(v) if v then loadCosmetics() else unloadCosmetics() end end})

ExitGroup:AddButton({Text = "Destroy UI", Func = function()
    Config.AimbotEnabled = false
    Config.TriggerBot = false
    Config.ESPEnabled = false
    tpActive = false
    spinActive = false
    eduVoidEnabled = false
    flyEnabled = false
    walkSpeedEnabled = false
    jumpPowerEnabled = false
    noClipEnabled = false
    infiniteJumpEnabled = false
    lightingEnabled = false
    applyLighting()
    unloadSilentAim()
    unloadCosmetics()
    stopFFA()
    stopSpinbot()
    stopEduVoid()
    if flyConnection then flyConnection:Disconnect() end
    if flyBody then flyBody:Destroy() end
    if renderConnection then renderConnection:Disconnect() end
    if triggerConnection then triggerConnection:Disconnect() end
    if espRenderConnection then espRenderConnection:Disconnect() end
    if FOVCircle then FOVCircle:Remove() end
    if AimLineDraw then AimLineDraw:Remove() end
    for _, l in ipairs(CrosshairLines) do if l then l:Remove() end end
    if CrosshairDotDraw then CrosshairDotDraw:Remove() end
    for _, o in pairs(ESPObjects) do DestroyESP(o) end
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                local highlight = part:FindFirstChild("EduWareHighlight")
                if highlight then highlight:Destroy() end
            end
        end
    end
    setSky(nil)
    local char = LP.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        hum.WalkSpeed = originalWalkSpeed
        hum.JumpPower = originalJumpPower
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    Window:Destroy()
    Library:Unload()
end, Risky = true})

MainGroup:AddLabel("EduWare - Final Edition")
MainGroup:AddLabel("Press RightShift to toggle aimbot")
MainGroup:AddLabel("EduVoid: Teleports to enemy, shoots, teleports back instantly")
notify("EduWare Loaded", 3)
