local TweenService = game:GetService("TweenService")
local _hvPlayers = game:GetService("Players")
local _hvMarketplaceService = game:GetService("MarketplaceService")
local _hvLocalPlayer = _hvPlayers.LocalPlayer

local function getHiddenVaultsIdentity()
  local playerName = (_hvLocalPlayer.DisplayName and _hvLocalPlayer.DisplayName ~= "" and _hvLocalPlayer.DisplayName) or _hvLocalPlayer.Name
  local gameName = "Unknown Experience"
  local avatarUrl = ""

  pcall(function()
    local info = _hvMarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then
      gameName = info.Name
    end
  end)

  pcall(function()
    avatarUrl = _hvPlayers:GetUserThumbnailAsync(
      _hvLocalPlayer.UserId,
      Enum.ThumbnailType.HeadShot,
      Enum.ThumbnailSize.Size100x100
    )
  end)

  return avatarUrl, playerName, gameName
end

local function attachHiddenVaultsIdentity(parent, position, size)
  local avatarUrl, playerName, gameName = getHiddenVaultsIdentity()

  local shell = Instance.new("Frame")
  shell.Size = size
  shell.Position = position
  shell.BackgroundColor3 = Color3.fromRGB(18, 20, 33)
  shell.BackgroundTransparency = 0.02
  shell.BorderSizePixel = 0
  shell.Parent = parent

  local shellCorner = Instance.new("UICorner")
  shellCorner.CornerRadius = UDim.new(0, 16)
  shellCorner.Parent = shell

  local shellStroke = Instance.new("UIStroke")
  shellStroke.Color = Color3.fromRGB(88, 93, 126)
  shellStroke.Transparency = 0.62
  shellStroke.Thickness = 1
  shellStroke.Parent = shell

  local avatar = Instance.new("ImageLabel")
  avatar.Size = UDim2.fromOffset(42, 42)
  avatar.Position = UDim2.fromOffset(12, 11)
  avatar.BackgroundColor3 = Color3.fromRGB(44, 47, 72)
  avatar.BorderSizePixel = 0
  avatar.Image = avatarUrl
  avatar.Parent = shell

  local avatarCorner = Instance.new("UICorner")
  avatarCorner.CornerRadius = UDim.new(1, 0)
  avatarCorner.Parent = avatar

  local avatarStroke = Instance.new("UIStroke")
  avatarStroke.Color = Color3.fromRGB(120, 123, 164)
  avatarStroke.Transparency = 0.42
  avatarStroke.Parent = avatar

  local nameLabel = Instance.new("TextLabel")
  nameLabel.BackgroundTransparency = 1
  nameLabel.Size = UDim2.new(1, -66, 0, 20)
  nameLabel.Position = UDim2.fromOffset(62, 11)
  nameLabel.Font = Enum.Font.GothamSemibold
  nameLabel.TextSize = 13
  nameLabel.TextColor3 = Color3.fromRGB(240, 242, 255)
  nameLabel.TextXAlignment = Enum.TextXAlignment.Left
  nameLabel.Text = playerName
  nameLabel.Parent = shell

  local gameLabel = Instance.new("TextLabel")
  gameLabel.BackgroundTransparency = 1
  gameLabel.Size = UDim2.new(1, -66, 0, 18)
  gameLabel.Position = UDim2.fromOffset(62, 31)
  gameLabel.Font = Enum.Font.Gotham
  gameLabel.TextSize = 11
  gameLabel.TextColor3 = Color3.fromRGB(151, 155, 182)
  gameLabel.TextXAlignment = Enum.TextXAlignment.Left
  gameLabel.TextTruncate = Enum.TextTruncate.AtEnd
  gameLabel.Text = gameName
  gameLabel.Parent = shell

  return shell
end

local function hvTween(object, time, properties)
  local animation = TweenService:Create(
    object,
    TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    properties
  )
  animation:Play()
  return animation
end

local function createKoZraYLoader()
  local gui = Instance.new("ScreenGui")
  gui.Name = "KoZraYLoaderStatus"
  gui.ResetOnSpawn = false
  gui.IgnoreGuiInset = true
  gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
  gui.Parent = game:GetService("CoreGui")

  local frame = Instance.new("Frame")
  frame.Size = UDim2.fromOffset(430, 116)
  frame.Position = UDim2.new(1, 460, 1, -26)
  frame.AnchorPoint = Vector2.new(1, 1)
  frame.BackgroundColor3 = Color3.fromRGB(3, 3, 5)
  frame.BorderSizePixel = 0
  frame.ClipsDescendants = true
  frame.Parent = gui

  local frameCorner = Instance.new("UICorner")
  frameCorner.CornerRadius = UDim.new(0, 14)
  frameCorner.Parent = frame

  local frameGradient = Instance.new("UIGradient")
  frameGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(36, 36, 42)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(11, 11, 15)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
  })
  frameGradient.Rotation = 18
  frameGradient.Parent = frame

  local stroke = Instance.new("UIStroke")
  stroke.Thickness = 1
  stroke.Color = Color3.fromRGB(55, 55, 68)
  stroke.Transparency = 0.35
  stroke.Parent = frame

  -- Main title "KoZraY" with glow effect
  local glow = Instance.new("TextLabel")
  glow.BackgroundTransparency = 1
  glow.Size = UDim2.fromOffset(200, 96)
  glow.Position = UDim2.fromOffset(10, 10)
  glow.Font = Enum.Font.GothamBlack
  glow.TextSize = 48
  glow.TextColor3 = Color3.fromRGB(255, 255, 255)
  glow.TextTransparency = 0.76
  glow.Text = "KoZraY"
  glow.Parent = frame

  local kz = glow:Clone()
  kz.TextTransparency = 0
  kz.Parent = frame

  local kzStroke = Instance.new("UIStroke")
  kzStroke.Color = Color3.fromRGB(255, 255, 255)
  kzStroke.Thickness = 1.5
  kzStroke.Transparency = 0.22
  kzStroke.Parent = kz

  task.spawn(function()
    while gui.Parent do
      hvTween(glow, 1.25, { TextTransparency = 0.62, TextSize = 56 })
      task.wait(1.25)
      hvTween(glow, 1.25, { TextTransparency = 0.82, TextSize = 48 })
      task.wait(1.25)
    end
  end)

  local divider = Instance.new("Frame")
  divider.Size = UDim2.new(0, 1, 1, -42)
  divider.Position = UDim2.fromOffset(118, 21)
  divider.BackgroundColor3 = Color3.fromRGB(85, 85, 95)
  divider.BackgroundTransparency = 0.5
  divider.BorderSizePixel = 0
  divider.Parent = frame

  local brand = Instance.new("TextLabel")
  brand.BackgroundTransparency = 1
  brand.Size = UDim2.new(1, -154, 0, 16)
  brand.Position = UDim2.fromOffset(138, 18)
  brand.Font = Enum.Font.GothamMedium
  brand.TextSize = 11
  brand.TextColor3 = Color3.fromRGB(140, 140, 155)
  brand.TextXAlignment = Enum.TextXAlignment.Left
  brand.Text = "KoZraY Runtime"
  brand.Parent = frame

  local status = Instance.new("TextLabel")
  status.BackgroundTransparency = 1
  status.Size = UDim2.new(1, -204, 0, 28)
  status.Position = UDim2.fromOffset(138, 36)
  status.Font = Enum.Font.GothamBlack
  status.TextSize = 22
  status.TextColor3 = Color3.fromRGB(255, 255, 255)
  status.TextXAlignment = Enum.TextXAlignment.Left
  status.Text = "Loading..."
  status.Parent = frame

  local percent = Instance.new("TextLabel")
  percent.BackgroundTransparency = 1
  percent.Size = UDim2.fromOffset(58, 20)
  percent.Position = UDim2.new(1, -18, 0, 42)
  percent.AnchorPoint = Vector2.new(1, 0)
  percent.Font = Enum.Font.GothamBold
  percent.TextSize = 12
  percent.TextColor3 = Color3.fromRGB(140, 140, 155)
  percent.TextXAlignment = Enum.TextXAlignment.Right
  percent.Text = "0%"
  percent.Parent = frame

  local subtitle = Instance.new("TextLabel")
  subtitle.BackgroundTransparency = 1
  subtitle.Size = UDim2.new(1, -154, 0, 16)
  subtitle.Position = UDim2.fromOffset(138, 64)
  subtitle.Font = Enum.Font.Gotham
  subtitle.TextSize = 12
  subtitle.TextColor3 = Color3.fromRGB(95, 95, 110)
  subtitle.TextXAlignment = Enum.TextXAlignment.Left
  subtitle.Text = "Preparing secure runtime delivery"
  subtitle.Parent = frame

  local track = Instance.new("Frame")
  track.Size = UDim2.new(1, -156, 0, 8)
  track.Position = UDim2.fromOffset(138, 90)
  track.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
  track.BorderSizePixel = 0
  track.Parent = frame

  local trackCorner = Instance.new("UICorner")
  trackCorner.CornerRadius = UDim.new(0, 999)
  trackCorner.Parent = track

  local fill = Instance.new("Frame")
  fill.Size = UDim2.fromScale(0, 1)
  fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  fill.BorderSizePixel = 0
  fill.Parent = track

  local fillCorner = Instance.new("UICorner")
  fillCorner.CornerRadius = UDim.new(0, 999)
  fillCorner.Parent = fill

  local fillGradient = Instance.new("UIGradient")
  fillGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 140, 155))
  })
  fillGradient.Parent = fill

  local loader = {}
  loader.gui = gui

  function loader:show()
    hvTween(frame, 0.42, {
      Position = UDim2.new(1, -26, 1, -26),
    })
  end

  function loader:setProgress(value, label)
    local normalized = math.clamp(value, 0, 100)
    percent.Text = string.format("%d%%", normalized)
    if label then
      status.Text = label
    end
    hvTween(fill, 0.26, {
      Size = UDim2.fromScale(normalized / 100, 1),
    })
  end

  function loader:complete(text)
    status.Text = text or "Successfully loaded.."
    status.TextColor3 = Color3.fromRGB(140, 255, 180)
    percent.Text = "100%"
    hvTween(fill, 0.22, {
      Size = UDim2.fromScale(1, 1),
    })
  end

  function loader:fail(text)
    status.Text = text or "Load failed."
    status.TextColor3 = Color3.fromRGB(255, 120, 120)
  end

  function loader:dismiss(delayTime)
    task.delay(delayTime or 1, function()
      local tweenOut = TweenService:Create(frame, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 460, 1, -26),
      })
      tweenOut:Play()
      tweenOut.Completed:Wait()
      gui:Destroy()
    end)
  end

  loader:show()
  return loader
end

local _hvSecurityState = {
  createdAt = os.clock(),
  failCount = 0,
  lastReason = nil,
}

local _hvOriginals = {
  pcall = pcall,
  xpcall = xpcall,
  type = type,
  typeof = typeof,
  tostring = tostring,
  tonumber = tonumber,
  pairs = pairs,
  ipairs = ipairs,
  taskWait = task and task.wait,
  taskSpawn = task and task.spawn,
  gameHttpGet = game and game.HttpGet,
  loadstring = loadstring,
}

local function hvSecuritySilentFail(loader, reason)
  _hvSecurityState.failCount += 1
  _hvSecurityState.lastReason = tostring(reason or "blocked")

  if loader and type(loader.fail) == "function" then
    loader:fail("Load failed.")
  end

  if loader and type(loader.dismiss) == "function" then
    loader:dismiss(1.15)
  end

  return false
end

local function hvSecurityScore(reason, amount, flags)
  flags[reason] = true
  return amount
end

local function hvSecurityCheckPrimitives(flags)
  local score = 0

  if type(pcall) ~= "function" or pcall ~= _hvOriginals.pcall then
    score += hvSecurityScore("pcall_changed", 4, flags)
  end

  if type(loadstring) ~= "function" or loadstring ~= _hvOriginals.loadstring then
    score += hvSecurityScore("loadstring_changed", 5, flags)
  end

  if type(type) ~= "function" or type ~= _hvOriginals.type then
    score += hvSecurityScore("type_changed", 4, flags)
  end

  if typeof and typeof ~= _hvOriginals.typeof then
    score += hvSecurityScore("typeof_changed", 3, flags)
  end

  if task and _hvOriginals.taskWait and task.wait ~= _hvOriginals.taskWait then
    score += hvSecurityScore("task_wait_changed", 2, flags)
  end

  if task and _hvOriginals.taskSpawn and task.spawn ~= _hvOriginals.taskSpawn then
    score += hvSecurityScore("task_spawn_changed", 2, flags)
  end

  return score
end

local function hvSecurityCheckEnvironment(flags)
  local score = 0
  local okPlayers, players = pcall(function()
    return game:GetService("Players")
  end)
  local okRunService, runService = pcall(function()
    return game:GetService("RunService")
  end)
  local okHttpService, httpService = pcall(function()
    return game:GetService("HttpService")
  end)

  if not okPlayers or not players or not players.LocalPlayer then
    score += hvSecurityScore("missing_local_player", 6, flags)
  end

  if not okRunService or not runService or not runService:IsClient() then
    score += hvSecurityScore("invalid_context", 6, flags)
  end

  if not okHttpService or not httpService then
    score += hvSecurityScore("missing_http_service", 4, flags)
  end

  local okMetatable, gameMeta = pcall(function()
    return getmetatable(game)
  end)
  if okMetatable and type(gameMeta) == "table" then
    local namecall = rawget(gameMeta, "__namecall")
    local index = rawget(gameMeta, "__index")
    local newindex = rawget(gameMeta, "__newindex")
    if namecall ~= nil or index ~= nil or newindex ~= nil then
      score += hvSecurityScore("game_metatable_exposed", 2, flags)
    end
  end

  return score
end

local function hvSecurityCheckExecutorSurface(flags)
  local score = 0
  local suspiciousGlobals = {
    "hookfunction",
    "hookmetamethod",
    "replaceclosure",
    "newcclosure",
    "getrawmetatable",
    "setrawmetatable",
    "setreadonly",
    "isreadonly",
    "getgc",
    "getreg",
    "getregistry",
    "getrenv",
    "getgenv",
    "getsenv",
    "getcallingscript",
    "checkcaller",
  }

  for _, name in ipairs(suspiciousGlobals) do
    local value = rawget(getfenv and getfenv() or _G, name)
    if value ~= nil then
      score += 1
      flags["global_" .. name] = true
    end
  end

  if debug then
    local debugHits = 0
    if type(debug.getinfo) == "function" then debugHits += 1 end
    if type(debug.getupvalue) == "function" then debugHits += 1 end
    if type(debug.setupvalue) == "function" then debugHits += 1 end
    if type(debug.getregistry) == "function" then debugHits += 1 end
    if debugHits >= 2 then
      score += hvSecurityScore("debug_surface", 3, flags)
    end
  end

  return score
end

local function hvSecurityCheckHttpSurface(flags)
  local score = 0

  if type(game.HttpGet) ~= "function" or game.HttpGet ~= _hvOriginals.gameHttpGet then
    score += hvSecurityScore("httpget_changed", 5, flags)
  end

  local env = getfenv and getfenv() or _G
  local requestAliases = {
    "request",
    "http_request",
    "syn",
    "http",
    "fluxus",
    "krnl",
  }

  local foundRequestSurface = 0
  for _, name in ipairs(requestAliases) do
    local value = rawget(env, name)
    if value ~= nil then
      foundRequestSurface += 1
      flags["request_surface_" .. name] = true
    end
  end

  if foundRequestSurface >= 2 then
    score += 2
  end

  return score
end

local function hvSecurityTimingCheck(flags)
  local start = os.clock()
  local checksum = 0
  for i = 1, 42000 do
    checksum = (checksum + i) % 9973
  end
  local elapsed = os.clock() - start

  if checksum ~= 591 then
    return hvSecurityScore("timing_checksum", 4, flags)
  end

  if elapsed > 0.85 then
    return hvSecurityScore("timing_delay", 2, flags)
  end

  return 0
end

local function hvSecurityPreflight(loader)
  local flags = {}
  local score = 0

  local ok, err = pcall(function()
    score += hvSecurityCheckPrimitives(flags)
    score += hvSecurityCheckEnvironment(flags)
    score += hvSecurityCheckExecutorSurface(flags)
    score += hvSecurityCheckHttpSurface(flags)
    score += hvSecurityTimingCheck(flags)
  end)

  if not ok then
    return hvSecuritySilentFail(loader, "preflight_exception")
  end

  if flags.loadstring_changed or flags.httpget_changed or flags.invalid_context or flags.missing_local_player then
    return hvSecuritySilentFail(loader, "critical_preflight")
  end

  if score >= 12 then
    return hvSecuritySilentFail(loader, "high_risk_preflight")
  end

  return true
end

local function hvProtectedCompile(source, loader)
  if type(source) ~= "string" or source == "" then
    hvSecuritySilentFail(loader, "empty_source")
    return nil, "empty source"
  end

  if source:match("^%s*%-%-") then
    hvSecuritySilentFail(loader, "server_message")
    return nil, "server message"
  end

  if not hvSecurityPreflight(loader) then
    return nil, "blocked"
  end

  local compiled, compileError = _hvOriginals.loadstring(source)
  if type(compiled) ~= "function" then
    hvSecuritySilentFail(loader, "compile_failed")
    return nil, compileError or "compile failed"
  end

  return compiled, nil
end

local function hvProtectedExecute(sourceOrFunction, loader)
  if type(sourceOrFunction) == "string" then
    local compiled, compileError = hvProtectedCompile(sourceOrFunction, loader)
    if not compiled then
      return false, compileError
    end
    sourceOrFunction = compiled
  end

  if type(sourceOrFunction) ~= "function" then
    hvSecuritySilentFail(loader, "invalid_chunk")
    return false, "invalid chunk"
  end

  if not hvSecurityPreflight(loader) then
    return false, "blocked"
  end

  local ok, result = _hvOriginals.pcall(sourceOrFunction)
  if not ok then
    hvSecuritySilentFail(loader, "runtime_error")
    return false, result
  end

  return true, result
end

local HttpService = game:GetService("HttpService")
local Analytics = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local loader = createKoZraYLoader()
loader:setProgress(12, "Loading...")

local function getPublicIp()
  local ok, response = pcall(function()
    return game:HttpGet("https://ipwho.is/")
  end)
  if not ok then
    return nil
  end

  local success, payload = pcall(function()
    return HttpService:JSONDecode(response)
  end)
  if not success or type(payload) ~= "table" then
    return nil
  end

  local ip = payload.ip
  if type(ip) ~= "string" or ip == "" then
    return nil
  end

  return ip
end

local function isServerMessage(message)
  return message:match("^%-%-")
end

loader:setProgress(48, "Authenticating...")
local ok, response = pcall(function()
  local url = "https://hiddenvaults.org/api/loader/e02ab19a11993ed0b2d68198?direct=1"
    .. "&hwid=" .. HttpService:UrlEncode(Analytics:GetClientId())
    .. "&username=" .. HttpService:UrlEncode(LocalPlayer.Name)
    .. "&userId=" .. HttpService:UrlEncode(tostring(LocalPlayer.UserId))
  local publicIp = getPublicIp()
  if publicIp then
    url = url .. "&clientIp=" .. HttpService:UrlEncode(publicIp)
  end
  return game:HttpGet(url)
end)

if not ok then
  loader:fail("Could not reach server.")
  loader:dismiss(1.4)
  warn("[KoZraY]: [   ERROR   ] - Could not reach the KoZraY runtime server")
  return
end

if isServerMessage(response) then
  loader:fail("Load failed.")
  loader:dismiss(1.4)
  warn(response:gsub("^%-%-%s*", ""))
  return
end

loader:setProgress(86, "Decrypting...")
local chunk, err = hvProtectedCompile(response, loader)
if not chunk then
  return
end
loader:setProgress(100, "Finalizing...")
loader:complete("Successfully loaded..")
loader:dismiss(0.9)
hvProtectedExecute(chunk, loader)
