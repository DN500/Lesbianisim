------------------ KEY SYSTEM ------------------
local KEY_SYSTEM = {
	Enabled = true,
	ValidKey = "HentaiHub2026", -- CHANGE THIS
	SaveFile = "HentaiHubKey.txt",
	GetKeyLink = "https://link-center.net/9212709/lqK7CtWhOedH",
}
------------------------------------------------

local function checkKey()
	if not KEY_SYSTEM.Enabled then return true end
	if isfile and isfile(KEY_SYSTEM.SaveFile) then
		local saved = readfile(KEY_SYSTEM.SaveFile)
		if saved == KEY_SYSTEM.ValidKey then return true end
	end
	return false
end

if KEY_SYSTEM.Enabled and not checkKey() then
	local KeyGui = Instance.new("ScreenGui")
	KeyGui.Name = "KeySystem"
	KeyGui.ResetOnSpawn = false
	KeyGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(0, 340, 0, 230)
	Frame.Position = UDim2.new(0.5, -170, 0.5, -115)
	Frame.BackgroundColor3 = Color3.fromRGB(25, 18, 35)
	Frame.BorderSizePixel = 0
	Frame.Parent = KeyGui
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, 0, 0, 40)
	Title.BackgroundTransparency = 1
	Title.Text = "HentaiHub V2.8 - Key System"
	Title.TextColor3 = Color3.fromRGB(200, 160, 255)
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 16
	Title.Parent = Frame

	local KeyBox = Instance.new("TextBox")
	KeyBox.Size = UDim2.new(1, -40, 0, 36)
	KeyBox.Position = UDim2.new(0, 20, 0, 50)
	KeyBox.BackgroundColor3 = Color3.fromRGB(40, 30, 55)
	KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	KeyBox.PlaceholderText = "Enter Key..."
	KeyBox.Font = Enum.Font.Gotham
	KeyBox.TextSize = 14
	KeyBox.Parent = Frame
	Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

	local SubmitBtn = Instance.new("TextButton")
	SubmitBtn.Size = UDim2.new(1, -40, 0, 36)
	SubmitBtn.Position = UDim2.new(0, 20, 0, 100)
	SubmitBtn.BackgroundColor3 = Color3.fromRGB(140, 90, 220)
	SubmitBtn.Text = "Submit Key"
	SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	SubmitBtn.Font = Enum.Font.GothamBold
	SubmitBtn.TextSize = 14
	SubmitBtn.Parent = Frame
	Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 8)

	local GetKeyBtn = Instance.new("TextButton")
	GetKeyBtn.Size = UDim2.new(1, -40, 0, 36)
	GetKeyBtn.Position = UDim2.new(0, 20, 0, 148)
	GetKeyBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
	GetKeyBtn.Text = "Click here for the key"
	GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	GetKeyBtn.Font = Enum.Font.GothamBold
	GetKeyBtn.TextSize = 14
	GetKeyBtn.Parent = Frame
	Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8)

	local Status = Instance.new("TextLabel")
	Status.Size = UDim2.new(1, -20, 0, 20)
	Status.Position = UDim2.new(0, 10, 1, -28)
	Status.BackgroundTransparency = 1
	Status.Text = ""
	Status.TextColor3 = Color3.fromRGB(255, 120, 150)
	Status.Font = Enum.Font.Gotham
	Status.TextSize = 12
	Status.Parent = Frame

	GetKeyBtn.MouseButton1Click:Connect(function()
		pcall(function()
			if setclipboard then setclipboard(KEY_SYSTEM.GetKeyLink) end
			game:GetService("GuiService"):OpenBrowserWindow(KEY_SYSTEM.GetKeyLink)
		end)
		Status.TextColor3 = Color3.fromRGB(180, 150, 255)
		Status.Text = "Link opened / copied"
	end)

	local verified = false
	SubmitBtn.MouseButton1Click:Connect(function()
		local input = KeyBox.Text:gsub("%s+", "")
		if input == KEY_SYSTEM.ValidKey then
			verified = true
			if writefile then writefile(KEY_SYSTEM.SaveFile, KEY_SYSTEM.ValidKey) end
			Status.TextColor3 = Color3.fromRGB(150, 255, 180)
			Status.Text = "Key Accepted! Loading..."
			task.wait(0.7)
			KeyGui:Destroy()
		else
			Status.Text = "Invalid Key"
		end
	end)

	while not verified do task.wait(0.1) end
end

------------------ CONFIG ------------------
local SAVE_FILE = "HentaiHubConfig.json"
--------------------------------------------

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Drops = workspace:FindFirstChild("Drops")
local Monsters = workspace:FindFirstChild("Monsters")

local running = true
local espEnabled = false
local itemEspEnabled = false
local chestEspEnabled = false
local bossEspEnabled = false
local fullBrightEnabled = false
local minimized = false
local settingsOpen = false
local filterOpen = false
local speedEnabled = false
local flyEnabled = false
local noclipEnabled = false
local rgbOutline = false
local customSpeed = 30
local flySpeed = 50

local SpeedKey = Enum.KeyCode.V
local FlyKey = Enum.KeyCode.F

local BossNames = {
	["Goblin Warlock"] = true,
	["Hiveling Titan"] = true,
	["Smelter Demon"] = true,
	["The Beholder"] = true,
	["The Crowned Nothing"] = true,
	["The Masquerade"] = true,
	["The Puppeteer"] = true,
	["The Stormcaller"] = true,
	["The Unfinished"] = true,
	["The Cell Of Life"] = true,
	["The Festering Wound"] = true,
}

local Rarities = {Common = false, Uncommon = false, Rare = false, Elite = false, Legendary = false}
local NameFilters = {["Idol of Hatred"] = true, ["Stone Accord"] = true}

-- Herta Theme Colors
local Theme = {
	Bg = Color3.fromRGB(22, 16, 32),
	TitleBar = Color3.fromRGB(35, 25, 50),
	Accent = Color3.fromRGB(160, 110, 255),
	AccentDark = Color3.fromRGB(100, 70, 170),
	Button = Color3.fromRGB(55, 40, 80),
	ButtonHover = Color3.fromRGB(140, 90, 220),
	Text = Color3.fromRGB(240, 230, 255),
	SubText = Color3.fromRGB(180, 160, 210),
	Danger = Color3.fromRGB(200, 70, 110),
	Success = Color3.fromRGB(140, 90, 220),
}

-- Fog
local function deleteAtmosphere()
	local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
	if atmosphere then atmosphere:Destroy() end
end
deleteAtmosphere()
Lighting.ChildAdded:Connect(function(child)
	if child:IsA("Atmosphere") then child:Destroy() end
end)

-- Full Bright
local oldAmbient, oldBrightness, oldClockTime, oldFogEnd, oldGlobalShadows
local function enableFullBright()
	oldAmbient = Lighting.Ambient
	oldBrightness = Lighting.Brightness
	oldClockTime = Lighting.ClockTime
	oldFogEnd = Lighting.FogEnd
	oldGlobalShadows = Lighting.GlobalShadows
	Lighting.Ambient = Color3.fromRGB(255, 255, 255)
	Lighting.Brightness = 2
	Lighting.ClockTime = 14
	Lighting.FogEnd = 100000
	Lighting.GlobalShadows = false
end
local function disableFullBright()
	if oldAmbient then
		Lighting.Ambient = oldAmbient
		Lighting.Brightness = oldBrightness
		Lighting.ClockTime = oldClockTime
		Lighting.FogEnd = oldFogEnd
		Lighting.GlobalShadows = oldGlobalShadows
	end
end

local function loadConfig()
	if isfile and isfile(SAVE_FILE) then
		local success, data = pcall(function() return HttpService:JSONDecode(readfile(SAVE_FILE)) end)
		if success and data then
			if data.Rarities then for k,v in pairs(data.Rarities) do Rarities[k] = v end end
			if data.NameFilters then NameFilters = data.NameFilters end
			if data.itemEspEnabled then itemEspEnabled = data.itemEspEnabled end
			if data.chestEspEnabled then chestEspEnabled = data.chestEspEnabled end
			if data.fullBrightEnabled then fullBrightEnabled = data.fullBrightEnabled end
			if data.espEnabled then espEnabled = data.espEnabled end
			if data.bossEspEnabled then bossEspEnabled = data.bossEspEnabled end
			if data.customSpeed then customSpeed = data.customSpeed end
			if data.flySpeed then flySpeed = data.flySpeed end
			if data.speedEnabled then speedEnabled = data.speedEnabled end
			if data.noclipEnabled then noclipEnabled = data.noclipEnabled end
			if data.rgbOutline then rgbOutline = data.rgbOutline end
			if data.SpeedKey then
				local ok, key = pcall(function() return Enum.KeyCode[data.SpeedKey] end)
				if ok and key then SpeedKey = key end
			end
			if data.FlyKey then
				local ok, key = pcall(function() return Enum.KeyCode[data.FlyKey] end)
				if ok and key then FlyKey = key end
			end
		end
	end
end

local function saveConfig()
	if writefile then
		pcall(function()
			writefile(SAVE_FILE, HttpService:JSONEncode({
				Rarities = Rarities,
				NameFilters = NameFilters,
				itemEspEnabled = itemEspEnabled,
				chestEspEnabled = chestEspEnabled,
				fullBrightEnabled = fullBrightEnabled,
				espEnabled = espEnabled,
				bossEspEnabled = bossEspEnabled,
				customSpeed = customSpeed,
				flySpeed = flySpeed,
				speedEnabled = speedEnabled,
				noclipEnabled = noclipEnabled,
				rgbOutline = rgbOutline,
				SpeedKey = SpeedKey.Name,
				FlyKey = FlyKey.Name
			}))
		end)
	end
end
loadConfig()

-- Server Hop
local function getLowPlayerServers()
	local servers = {}
	local cursor = ""
	for i = 1, 4 do
		local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
		if cursor ~= "" then url = url .. "&cursor=" .. cursor end
		local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
		if success and result and result.data then
			for _, server in ipairs(result.data) do
				local playing = server.playing or 0
				if playing >= 1 and playing <= 3 and server.id ~= game.JobId then
					table.insert(servers, {id = server.id, playing = playing})
				end
			end
			cursor = result.nextPageCursor or ""
			if cursor == "" then break end
		else break end
	end
	table.sort(servers, function(a, b) return a.playing < b.playing end)
	return servers
end

local function smartServerHop()
	saveConfig()
	local servers = getLowPlayerServers()
	if #servers == 0 then
		pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
		return
	end
	pcall(function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[1].id, LocalPlayer)
	end)
end

-- Speed
local function applySpeed()
	local char = LocalPlayer.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum and speedEnabled then
		hum.WalkSpeed = customSpeed
	end
end

-- NoClip
local function setNoClip(state)
	local char = LocalPlayer.Character
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = not state
		end
	end
end

-- Fly
local flyBV, flyBG
local function startFly()
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end

	hum.PlatformStand = true

	flyBV = Instance.new("BodyVelocity")
	flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	flyBV.Velocity = Vector3.zero
	flyBV.Parent = hrp

	flyBG = Instance.new("BodyGyro")
	flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	flyBG.P = 9e4
	flyBG.Parent = hrp

	noclipEnabled = true
	setNoClip(true)
end

local function stopFly()
	local char = LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.PlatformStand = false end
	end
	if flyBV then flyBV:Destroy() flyBV = nil end
	if flyBG then flyBG:Destroy() flyBG = nil end
end

local function updateFly()
	if not flyEnabled or not flyBV or not flyBG then return end
	local cam = workspace.CurrentCamera
	if not cam then return end

	local move = Vector3.zero
	if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end

	if move.Magnitude > 0 then
		flyBV.Velocity = move.Unit * flySpeed
	else
		flyBV.Velocity = Vector3.zero
	end
	flyBG.CFrame = cam.CFrame
end

RunService.Heartbeat:Connect(function()
	if not running then return end
	if speedEnabled then applySpeed() end
	if noclipEnabled then setNoClip(true) end
	if flyEnabled then updateFly() end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	HRP = char:WaitForChild("HumanoidRootPart")
	task.wait(0.5)
	if speedEnabled then applySpeed() end
	if noclipEnabled then setNoClip(true) end
	if flyEnabled then startFly() end
end)

-- ==================== UI (THE HERTA THEME) ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HentaiHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 32)
MainFrame.Position = UDim2.new(0.5, -140, 0.05, 0)
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Theme.TitleBar
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "HentaiHub V2.8"
Title.TextColor3 = Theme.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 26, 0, 26)
MinBtn.Position = UDim2.new(1, -58, 0, 3)
MinBtn.BackgroundColor3 = Theme.Button
MinBtn.Text = "–"
MinBtn.TextColor3 = Theme.Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.Parent = TitleBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -29, 0, 3)
CloseBtn.BackgroundColor3 = Theme.Danger
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
	saveConfig()
	running = false
	stopFly()
	if fullBrightEnabled then disableFullBright() end
	if noclipEnabled then setNoClip(false) end
	ScreenGui:Destroy()
end)

-- Dragging
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)
TitleBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Resize
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Size = UDim2.new(0, 16, 0, 16)
ResizeHandle.Position = UDim2.new(1, -16, 1, -16)
ResizeHandle.BackgroundColor3 = Theme.AccentDark
ResizeHandle.Text = ""
ResizeHandle.Parent = MainFrame
Instance.new("UICorner", ResizeHandle).CornerRadius = UDim.new(0, 4)

local resizing, resizeStart, startSize
ResizeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		resizing = true
		resizeStart = input.Position
		startSize = MainFrame.Size
	end
end)
ResizeHandle.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end
end)
UserInputService.InputChanged:Connect(function(input)
	if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - resizeStart
		MainFrame.Size = UDim2.new(0, math.clamp(startSize.X.Offset + delta.X, 240, 500), 0, math.clamp(startSize.Y.Offset + delta.Y, 120, 700))
	end
end)

-- Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -16, 1, -48)
Content.Position = UDim2.new(0, 8, 0, 36)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.Parent = MainFrame

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)
layout.Parent = Content
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

local function createCheckbox(text, default)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 26)
	frame.BackgroundTransparency = 1
	frame.Parent = Content
	local box = Instance.new("TextButton")
	box.Size = UDim2.new(0, 22, 0, 22)
	box.Position = UDim2.new(0, 0, 0, 2)
	box.BackgroundColor3 = default and Theme.Accent or Theme.Button
	box.Text = default and "✓" or ""
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.Font = Enum.Font.GothamBold
	box.TextSize = 14
	box.Parent = frame
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -30, 1, 0)
	label.Position = UDim2.new(0, 30, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Theme.Text
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame
	return box
end

local ItemEspCheck = createCheckbox("Item ESP (Filtered)", itemEspEnabled)
local ChestEspCheck = createCheckbox("Chest ESP (All)", chestEspEnabled)
local PlayerEspCheck = createCheckbox("Player ESP (Outline)", espEnabled)
local BossEspCheck = createCheckbox("Boss ESP", bossEspEnabled)
local BrightCheck = createCheckbox("Full Bright", fullBrightEnabled)
local SpeedCheck = createCheckbox("Speed Hack", speedEnabled)
local FlyCheck = createCheckbox("Fly", flyEnabled)

local function createButton(text, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 28)
	btn.BackgroundColor3 = color
	btn.Text = text
	btn.TextColor3 = Theme.Text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Parent = Content
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

local FilterBtn = createButton("Item Filter  →", Theme.Button)
local SettingsBtn = createButton("Settings  →", Theme.Button)
local HopBtn = createButton("Server Hop (1-3 Players)", Theme.AccentDark)

-- Rarities
local rarityOpen = false
local RarityHeader = Instance.new("TextButton")
RarityHeader.Size = UDim2.new(1, 0, 0, 28)
RarityHeader.BackgroundColor3 = Theme.Button
RarityHeader.Text = "Rarities  ▼"
RarityHeader.TextColor3 = Theme.Text
RarityHeader.Font = Enum.Font.GothamBold
RarityHeader.TextSize = 13
RarityHeader.Parent = Content
Instance.new("UICorner", RarityHeader).CornerRadius = UDim.new(0, 6)

local RarityContainer = Instance.new("Frame")
RarityContainer.Size = UDim2.new(1, 0, 0, 0)
RarityContainer.BackgroundTransparency = 1
RarityContainer.ClipsDescendants = true
RarityContainer.Parent = Content

local rarityList = {"Common", "Uncommon", "Rare", "Elite", "Legendary"}
for i, rarity in ipairs(rarityList) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 24)
	btn.Position = UDim2.new(0, 0, 0, (i-1)*26)
	btn.BackgroundColor3 = Rarities[rarity] and Theme.Accent or Theme.Button
	btn.TextColor3 = Theme.Text
	btn.Text = rarity .. (Rarities[rarity] and " ✓" or "")
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 12
	btn.Parent = RarityContainer
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
	btn.MouseButton1Click:Connect(function()
		Rarities[rarity] = not Rarities[rarity]
		btn.BackgroundColor3 = Rarities[rarity] and Theme.Accent or Theme.Button
		btn.Text = rarity .. (Rarities[rarity] and " ✓" or "")
		saveConfig()
	end)
end

RarityHeader.MouseButton1Click:Connect(function()
	rarityOpen = not rarityOpen
	RarityHeader.Text = rarityOpen and "Rarities  ▲" or "Rarities  ▼"
	RarityContainer.Size = UDim2.new(1, 0, 0, rarityOpen and 130 or 0)
end)

-- ==================== FILTER PANEL ====================
local FilterPanel = Instance.new("Frame")
FilterPanel.Size = UDim2.new(0, 220, 0, 210)
FilterPanel.BackgroundColor3 = Theme.Bg
FilterPanel.BorderSizePixel = 0
FilterPanel.Visible = false
FilterPanel.Parent = ScreenGui
Instance.new("UICorner", FilterPanel).CornerRadius = UDim.new(0, 10)

local FilterTitle = Instance.new("TextLabel")
FilterTitle.Size = UDim2.new(1, -10, 0, 30)
FilterTitle.Position = UDim2.new(0, 8, 0, 4)
FilterTitle.BackgroundTransparency = 1
FilterTitle.Text = "Item Filter"
FilterTitle.TextColor3 = Theme.Accent
FilterTitle.Font = Enum.Font.GothamBold
FilterTitle.TextSize = 14
FilterTitle.TextXAlignment = Enum.TextXAlignment.Left
FilterTitle.Parent = FilterPanel

local FilterClose = Instance.new("TextButton")
FilterClose.Size = UDim2.new(0, 24, 0, 24)
FilterClose.Position = UDim2.new(1, -28, 0, 4)
FilterClose.BackgroundColor3 = Theme.Danger
FilterClose.Text = "X"
FilterClose.TextColor3 = Color3.fromRGB(255, 255, 255)
FilterClose.Font = Enum.Font.GothamBold
FilterClose.TextSize = 12
FilterClose.Parent = FilterPanel
Instance.new("UICorner", FilterClose).CornerRadius = UDim.new(0, 5)

local NameBox = Instance.new("TextBox")
NameBox.Size = UDim2.new(1, -16, 0, 28)
NameBox.Position = UDim2.new(0, 8, 0, 38)
NameBox.BackgroundColor3 = Theme.Button
NameBox.TextColor3 = Theme.Text
NameBox.PlaceholderText = "Item name..."
NameBox.Font = Enum.Font.Gotham
NameBox.TextSize = 13
NameBox.Parent = FilterPanel
Instance.new("UICorner", NameBox).CornerRadius = UDim.new(0, 6)

local AddBtn = Instance.new("TextButton")
AddBtn.Size = UDim2.new(1, -16, 0, 28)
AddBtn.Position = UDim2.new(0, 8, 0, 72)
AddBtn.BackgroundColor3 = Theme.AccentDark
AddBtn.Text = "Add Filter"
AddBtn.TextColor3 = Theme.Text
AddBtn.Font = Enum.Font.GothamBold
AddBtn.TextSize = 13
AddBtn.Parent = FilterPanel
Instance.new("UICorner", AddBtn).CornerRadius = UDim.new(0, 6)

local NameListFrame = Instance.new("ScrollingFrame")
NameListFrame.Size = UDim2.new(1, -16, 1, -110)
NameListFrame.Position = UDim2.new(0, 8, 0, 108)
NameListFrame.BackgroundColor3 = Theme.TitleBar
NameListFrame.BorderSizePixel = 0
NameListFrame.ScrollBarThickness = 4
NameListFrame.Parent = FilterPanel
Instance.new("UICorner", NameListFrame).CornerRadius = UDim.new(0, 6)
local NameListLayout = Instance.new("UIListLayout")
NameListLayout.Padding = UDim.new(0, 4)
NameListLayout.Parent = NameListFrame

-- ==================== SETTINGS PANEL ====================
local SettingsPanel = Instance.new("Frame")
SettingsPanel.Size = UDim2.new(0, 250, 0, 320)
SettingsPanel.BackgroundColor3 = Theme.Bg
SettingsPanel.BorderSizePixel = 0
SettingsPanel.Visible = false
SettingsPanel.Parent = ScreenGui
Instance.new("UICorner", SettingsPanel).CornerRadius = UDim.new(0, 10)

local SetTitle = Instance.new("TextLabel")
SetTitle.Size = UDim2.new(1, -10, 0, 30)
SetTitle.Position = UDim2.new(0, 8, 0, 4)
SetTitle.BackgroundTransparency = 1
SetTitle.Text = "Settings"
SetTitle.TextColor3 = Theme.Accent
SetTitle.Font = Enum.Font.GothamBold
SetTitle.TextSize = 14
SetTitle.TextXAlignment = Enum.TextXAlignment.Left
SetTitle.Parent = SettingsPanel

local SetClose = Instance.new("TextButton")
SetClose.Size = UDim2.new(0, 24, 0, 24)
SetClose.Position = UDim2.new(1, -28, 0, 4)
SetClose.BackgroundColor3 = Theme.Danger
SetClose.Text = "X"
SetClose.TextColor3 = Color3.fromRGB(255, 255, 255)
SetClose.Font = Enum.Font.GothamBold
SetClose.TextSize = 12
SetClose.Parent = SettingsPanel
Instance.new("UICorner", SetClose).CornerRadius = UDim.new(0, 5)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, -20, 0, 18)
SpeedLabel.Position = UDim2.new(0, 10, 0, 38)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed Value:"
SpeedLabel.TextColor3 = Theme.SubText
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 12
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = SettingsPanel

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(1, -20, 0, 28)
SpeedBox.Position = UDim2.new(0, 10, 0, 58)
SpeedBox.BackgroundColor3 = Theme.Button
SpeedBox.TextColor3 = Theme.Text
SpeedBox.Text = tostring(customSpeed)
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 14
SpeedBox.Parent = SettingsPanel
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0, 6)

local FlySpeedLabel = Instance.new("TextLabel")
FlySpeedLabel.Size = UDim2.new(1, -20, 0, 18)
FlySpeedLabel.Position = UDim2.new(0, 10, 0, 92)
FlySpeedLabel.BackgroundTransparency = 1
FlySpeedLabel.Text = "Fly Speed:"
FlySpeedLabel.TextColor3 = Theme.SubText
FlySpeedLabel.Font = Enum.Font.Gotham
FlySpeedLabel.TextSize = 12
FlySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
FlySpeedLabel.Parent = SettingsPanel

local FlySpeedBox = Instance.new("TextBox")
FlySpeedBox.Size = UDim2.new(1, -20, 0, 28)
FlySpeedBox.Position = UDim2.new(0, 10, 0, 112)
FlySpeedBox.BackgroundColor3 = Theme.Button
FlySpeedBox.TextColor3 = Theme.Text
FlySpeedBox.Text = tostring(flySpeed)
FlySpeedBox.Font = Enum.Font.Gotham
FlySpeedBox.TextSize = 14
FlySpeedBox.Parent = SettingsPanel
Instance.new("UICorner", FlySpeedBox).CornerRadius = UDim.new(0, 6)

local KeyLabel = Instance.new("TextLabel")
KeyLabel.Size = UDim2.new(1, -20, 0, 18)
KeyLabel.Position = UDim2.new(0, 10, 0, 148)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Text = "Keybinds (click to change):"
KeyLabel.TextColor3 = Theme.SubText
KeyLabel.Font = Enum.Font.Gotham
KeyLabel.TextSize = 12
KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
KeyLabel.Parent = SettingsPanel

local SpeedKeyBtn = Instance.new("TextButton")
SpeedKeyBtn.Size = UDim2.new(1, -20, 0, 28)
SpeedKeyBtn.Position = UDim2.new(0, 10, 0, 170)
SpeedKeyBtn.BackgroundColor3 = Theme.Button
SpeedKeyBtn.Text = "Speed Key: " .. SpeedKey.Name
SpeedKeyBtn.TextColor3 = Theme.Text
SpeedKeyBtn.Font = Enum.Font.GothamBold
SpeedKeyBtn.TextSize = 13
SpeedKeyBtn.Parent = SettingsPanel
Instance.new("UICorner", SpeedKeyBtn).CornerRadius = UDim.new(0, 6)

local FlyKeyBtn = Instance.new("TextButton")
FlyKeyBtn.Size = UDim2.new(1, -20, 0, 28)
FlyKeyBtn.Position = UDim2.new(0, 10, 0, 206)
FlyKeyBtn.BackgroundColor3 = Theme.Button
FlyKeyBtn.Text = "Fly Key: " .. FlyKey.Name
FlyKeyBtn.TextColor3 = Theme.Text
FlyKeyBtn.Font = Enum.Font.GothamBold
FlyKeyBtn.TextSize = 13
FlyKeyBtn.Parent = SettingsPanel
Instance.new("UICorner", FlyKeyBtn).CornerRadius = UDim.new(0, 6)

local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Size = UDim2.new(1, -20, 0, 28)
NoclipToggle.Position = UDim2.new(0, 10, 0, 244)
NoclipToggle.BackgroundColor3 = noclipEnabled and Theme.Accent or Theme.Button
NoclipToggle.Text = noclipEnabled and "NoClip: ON" or "NoClip: OFF"
NoclipToggle.TextColor3 = Theme.Text
NoclipToggle.Font = Enum.Font.GothamBold
NoclipToggle.TextSize = 13
NoclipToggle.Parent = SettingsPanel
Instance.new("UICorner", NoclipToggle).CornerRadius = UDim.new(0, 6)

local RgbToggle = Instance.new("TextButton")
RgbToggle.Size = UDim2.new(1, -20, 0, 28)
RgbToggle.Position = UDim2.new(0, 10, 0, 280)
RgbToggle.BackgroundColor3 = rgbOutline and Theme.Accent or Theme.Button
RgbToggle.Text = rgbOutline and "RGB Outline: ON" or "RGB Outline: OFF"
RgbToggle.TextColor3 = Theme.Text
RgbToggle.Font = Enum.Font.GothamBold
RgbToggle.TextSize = 13
RgbToggle.Parent = SettingsPanel
Instance.new("UICorner", RgbToggle).CornerRadius = UDim.new(0, 6)

-- Keybind logic
local waitingForKey = nil
local function startKeyChange(which)
	waitingForKey = which
	if which == "Speed" then
		SpeedKeyBtn.Text = "Press any key..."
		SpeedKeyBtn.BackgroundColor3 = Theme.AccentDark
	else
		FlyKeyBtn.Text = "Press any key..."
		FlyKeyBtn.BackgroundColor3 = Theme.AccentDark
	end
end

SpeedKeyBtn.MouseButton1Click:Connect(function() startKeyChange("Speed") end)
FlyKeyBtn.MouseButton1Click:Connect(function() startKeyChange("Fly") end)

UserInputService.InputBegan:Connect(function(input, gp)
	if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
		if waitingForKey == "Speed" then
			SpeedKey = input.KeyCode
			SpeedKeyBtn.Text = "Speed Key: " .. SpeedKey.Name
			SpeedKeyBtn.BackgroundColor3 = Theme.Button
		else
			FlyKey = input.KeyCode
			FlyKeyBtn.Text = "Fly Key: " .. FlyKey.Name
			FlyKeyBtn.BackgroundColor3 = Theme.Button
		end
		waitingForKey = nil
		saveConfig()
	end

	if input.UserInputType == Enum.UserInputType.Keyboard and not gp then
		if input.KeyCode == SpeedKey then
			speedEnabled = not speedEnabled
			SpeedCheck.Text = speedEnabled and "✓" or ""
			SpeedCheck.BackgroundColor3 = speedEnabled and Theme.Accent or Theme.Button
			if speedEnabled then applySpeed() else
				local char = LocalPlayer.Character
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				if hum then hum.WalkSpeed = 16 end
			end
			saveConfig()
		elseif input.KeyCode == FlyKey then
			flyEnabled = not flyEnabled
			FlyCheck.Text = flyEnabled and "✓" or ""
			FlyCheck.BackgroundColor3 = flyEnabled and Theme.Accent or Theme.Button
			if flyEnabled then
				startFly()
				NoclipToggle.Text = "NoClip: ON"
				NoclipToggle.BackgroundColor3 = Theme.Accent
			else
				stopFly()
			end
			saveConfig()
		end
	end
end)

SpeedBox.FocusLost:Connect(function()
	local num = tonumber(SpeedBox.Text)
	if num and num >= 1 then
		customSpeed = math.floor(num)
		SpeedBox.Text = tostring(customSpeed)
		if speedEnabled then applySpeed() end
		saveConfig()
	else
		SpeedBox.Text = tostring(customSpeed)
	end
end)

FlySpeedBox.FocusLost:Connect(function()
	local num = tonumber(FlySpeedBox.Text)
	if num and num >= 1 then
		flySpeed = math.floor(num)
		FlySpeedBox.Text = tostring(flySpeed)
		saveConfig()
	else
		FlySpeedBox.Text = tostring(flySpeed)
	end
end)

NoclipToggle.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	NoclipToggle.Text = noclipEnabled and "NoClip: ON" or "NoClip: OFF"
	NoclipToggle.BackgroundColor3 = noclipEnabled and Theme.Accent or Theme.Button
	setNoClip(noclipEnabled)
	saveConfig()
end)

RgbToggle.MouseButton1Click:Connect(function()
	rgbOutline = not rgbOutline
	RgbToggle.Text = rgbOutline and "RGB Outline: ON" or "RGB Outline: OFF"
	RgbToggle.BackgroundColor3 = rgbOutline and Theme.Accent or Theme.Button
	saveConfig()
end)

-- Side panels
local function updateSidePanels()
	local p = MainFrame.AbsolutePosition
	local s = MainFrame.AbsoluteSize
	FilterPanel.Position = UDim2.new(0, p.X + s.X + 8, 0, p.Y + 40)
	SettingsPanel.Position = UDim2.new(0, p.X + s.X + 8, 0, p.Y)
end

FilterBtn.MouseButton1Click:Connect(function()
	filterOpen = not filterOpen
	FilterPanel.Visible = filterOpen
	FilterBtn.Text = filterOpen and "Item Filter  ←" or "Item Filter  →"
	if filterOpen then updateSidePanels() end
end)
FilterClose.MouseButton1Click:Connect(function()
	filterOpen = false
	FilterPanel.Visible = false
	FilterBtn.Text = "Item Filter  →"
end)

SettingsBtn.MouseButton1Click:Connect(function()
	settingsOpen = not settingsOpen
	SettingsPanel.Visible = settingsOpen
	SettingsBtn.Text = settingsOpen and "Settings  ←" or "Settings  →"
	if settingsOpen then
		SpeedBox.Text = tostring(customSpeed)
		FlySpeedBox.Text = tostring(flySpeed)
		updateSidePanels()
	end
end)
SetClose.MouseButton1Click:Connect(function()
	settingsOpen = false
	SettingsPanel.Visible = false
	SettingsBtn.Text = "Settings  →"
end)

MainFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateSidePanels)
MainFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSidePanels)

-- Minimize
local function updateSize()
	if minimized then
		MainFrame.Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 32)
		Content.Visible = false
		ResizeHandle.Visible = false
		FilterPanel.Visible = false
		SettingsPanel.Visible = false
	else
		Content.Visible = true
		ResizeHandle.Visible = true
		if MainFrame.Size.Y.Offset < 150 then
			MainFrame.Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 480)
		end
	end
end

MinBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	MinBtn.Text = minimized and "+" or "–"
	updateSize()
end)

-- Name Filter
local function findBestMatch(input)
	input = input:lower():gsub("^%s*(.-)%s*$", "%1")
	if input == "" then return nil end
	local bestMatch, bestScore = nil, 0
	if Drops then
		for _, drop in ipairs(Drops:GetChildren()) do
			local name = drop.Name
			local lower = name:lower()
			if lower == input then return name end
			if lower:sub(1, #input) == input then
				local score = #input / #lower
				if score > bestScore then bestScore, bestMatch = score, name end
			elseif lower:find(input, 1, true) then
				local score = (#input / #lower) * 0.7
				if score > bestScore then bestScore, bestMatch = score, name end
			end
		end
	end
	return bestMatch
end

local function refreshNameList()
	for _, child in ipairs(NameListFrame:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	local count = 0
	for name in pairs(NameFilters) do
		count += 1
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -6, 0, 22)
		btn.BackgroundColor3 = Theme.Button
		btn.TextColor3 = Color3.fromRGB(220, 180, 255)
		btn.Text = name .. "  X"
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 12
		btn.Parent = NameListFrame
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
		btn.MouseButton1Click:Connect(function()
			NameFilters[name] = nil
			refreshNameList()
			saveConfig()
		end)
	end
	NameListFrame.CanvasSize = UDim2.new(0, 0, 0, count * 26)
end

AddBtn.MouseButton1Click:Connect(function()
	local text = NameBox.Text
	local corrected = findBestMatch(text)
	if corrected then NameFilters[corrected] = true
	elseif text:gsub("%s","") ~= "" then NameFilters[text] = true end
	NameBox.Text = ""
	refreshNameList()
	saveConfig()
end)
refreshNameList()

-- Toggles
ItemEspCheck.MouseButton1Click:Connect(function()
	itemEspEnabled = not itemEspEnabled
	ItemEspCheck.Text = itemEspEnabled and "✓" or ""
	ItemEspCheck.BackgroundColor3 = itemEspEnabled and Theme.Accent or Theme.Button
	saveConfig()
end)

ChestEspCheck.MouseButton1Click:Connect(function()
	chestEspEnabled = not chestEspEnabled
	ChestEspCheck.Text = chestEspEnabled and "✓" or ""
	ChestEspCheck.BackgroundColor3 = chestEspEnabled and Theme.Accent or Theme.Button
	saveConfig()
end)

PlayerEspCheck.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	PlayerEspCheck.Text = espEnabled and "✓" or ""
	PlayerEspCheck.BackgroundColor3 = espEnabled and Theme.Accent or Theme.Button
	saveConfig()
end)

BossEspCheck.MouseButton1Click:Connect(function()
	bossEspEnabled = not bossEspEnabled
	BossEspCheck.Text = bossEspEnabled and "✓" or ""
	BossEspCheck.BackgroundColor3 = bossEspEnabled and Theme.Accent or Theme.Button
	saveConfig()
end)

BrightCheck.MouseButton1Click:Connect(function()
	fullBrightEnabled = not fullBrightEnabled
	BrightCheck.Text = fullBrightEnabled and "✓" or ""
	BrightCheck.BackgroundColor3 = fullBrightEnabled and Theme.Accent or Theme.Button
	if fullBrightEnabled then enableFullBright() else disableFullBright() end
	saveConfig()
end)

SpeedCheck.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	SpeedCheck.Text = speedEnabled and "✓" or ""
	SpeedCheck.BackgroundColor3 = speedEnabled and Theme.Accent or Theme.Button
	if speedEnabled then applySpeed() else
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = 16 end
	end
	saveConfig()
end)

FlyCheck.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	FlyCheck.Text = flyEnabled and "✓" or ""
	FlyCheck.BackgroundColor3 = flyEnabled and Theme.Accent or Theme.Button
	if flyEnabled then
		startFly()
		NoclipToggle.Text = "NoClip: ON"
		NoclipToggle.BackgroundColor3 = Theme.Accent
	else
		stopFly()
	end
	saveConfig()
end)

HopBtn.MouseButton1Click:Connect(smartServerHop)

-- ==================== PLAYER ESP ====================
local espFolder = Instance.new("Folder", ScreenGui)
espFolder.Name = "PlayerESP"
local espObjects = {}

local function createEsp(player)
	if player == LocalPlayer then return end
	local highlight = Instance.new("Highlight")
	highlight.FillColor = Theme.Accent
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.FillTransparency = 0.7
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Enabled = false

	local billboard = Instance.new("BillboardGui")
	billboard.AlwaysOnTop = true
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 3.5, 0)
	billboard.Parent = espFolder

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextStrokeTransparency = 0.5
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 14
	nameLabel.Text = player.DisplayName ~= player.Name and (player.DisplayName .. " (@" .. player.Name .. ")") or player.Name
	nameLabel.Parent = billboard

	local infoLabel = Instance.new("TextLabel")
	infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
	infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
	infoLabel.BackgroundTransparency = 1
	infoLabel.TextStrokeTransparency = 0.5
	infoLabel.Font = Enum.Font.Gotham
	infoLabel.TextSize = 12
	infoLabel.Parent = billboard

	return billboard, infoLabel, highlight
end

local function updatePlayerEsp()
	if not espEnabled then
		for _, obj in pairs(espObjects) do
			if obj.billboard then obj.billboard.Enabled = false end
			if obj.highlight then obj.highlight.Enabled = false end
		end
		return
	end
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local char = player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if not espObjects[player] then
				local bb, info, hl = createEsp(player)
				espObjects[player] = {billboard = bb, infoLabel = info, highlight = hl}
			end
			local data = espObjects[player]
			if root and hum and hum.Health > 0 then
				data.billboard.Adornee = root
				data.billboard.Enabled = true
				if data.highlight then
					data.highlight.Adornee = char
					data.highlight.Parent = char
					data.highlight.Enabled = true
				end
				local dist = (root.Position - (HRP and HRP.Position or Vector3.zero)).Magnitude
				data.infoLabel.Text = string.format("%dm | %d/%d HP", math.floor(dist), math.floor(hum.Health), math.floor(hum.MaxHealth))
				local ratio = hum.Health / hum.MaxHealth
				data.infoLabel.TextColor3 = ratio > 0.6 and Color3.fromRGB(0,255,100) or ratio > 0.3 and Color3.fromRGB(255,200,0) or Color3.fromRGB(255,60,60)
			else
				data.billboard.Enabled = false
				if data.highlight then data.highlight.Enabled = false end
			end
		end
	end
end

Players.PlayerRemoving:Connect(function(player)
	if espObjects[player] then
		if espObjects[player].billboard then espObjects[player].billboard:Destroy() end
		if espObjects[player].highlight then espObjects[player].highlight:Destroy() end
		espObjects[player] = nil
	end
end)

-- ==================== BOSS ESP ====================
local bossEspFolder = Instance.new("Folder", ScreenGui)
bossEspFolder.Name = "BossESP"
local bossEspObjects = {}

local function updateBossEsp()
	if not bossEspEnabled or not Monsters then
		for _, obj in pairs(bossEspObjects) do
			if obj.billboard then obj.billboard.Enabled = false end
			if obj.highlight then obj.highlight.Enabled = false end
		end
		return
	end

	for _, monster in ipairs(Monsters:GetChildren()) do
		if BossNames[monster.Name] then
			local root = monster:FindFirstChild("HumanoidRootPart") or monster:FindFirstChildWhichIsA("BasePart")
			local hum = monster:FindFirstChildOfClass("Humanoid")

			if not bossEspObjects[monster] then
				local highlight = Instance.new("Highlight")
				highlight.FillColor = Color3.fromRGB(255, 80, 120)
				highlight.OutlineColor = Color3.fromRGB(255, 180, 220)
				highlight.FillTransparency = 0.6
				highlight.OutlineTransparency = 0
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight.Enabled = false

				local billboard = Instance.new("BillboardGui")
				billboard.AlwaysOnTop = true
				billboard.Size = UDim2.new(0, 220, 0, 50)
				billboard.StudsOffset = Vector3.new(0, 4, 0)
				billboard.Parent = bossEspFolder

				local nameLabel = Instance.new("TextLabel")
				nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
				nameLabel.BackgroundTransparency = 1
				nameLabel.TextColor3 = Color3.fromRGB(255, 120, 160)
				nameLabel.TextStrokeTransparency = 0.4
				nameLabel.Font = Enum.Font.GothamBold
				nameLabel.TextSize = 14
				nameLabel.Text = monster.Name
				nameLabel.Parent = billboard

				local infoLabel = Instance.new("TextLabel")
				infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
				infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
				infoLabel.BackgroundTransparency = 1
				infoLabel.TextStrokeTransparency = 0.4
				infoLabel.Font = Enum.Font.Gotham
				infoLabel.TextSize = 12
				infoLabel.Parent = billboard

				bossEspObjects[monster] = {billboard = billboard, infoLabel = infoLabel, highlight = highlight}
			end

			local data = bossEspObjects[monster]
			if root then
				data.billboard.Adornee = root
				data.billboard.Enabled = true
				if data.highlight then
					data.highlight.Adornee = monster
					data.highlight.Parent = monster
					data.highlight.Enabled = true
				end
				local dist = HRP and (root.Position - HRP.Position).Magnitude or 0
				local hpText = hum and string.format(" | %d/%d HP", math.floor(hum.Health), math.floor(hum.MaxHealth)) or ""
				data.infoLabel.Text = string.format("%dm%s", math.floor(dist), hpText)
				data.infoLabel.TextColor3 = Color3.fromRGB(255, 200, 220)
			else
				data.billboard.Enabled = false
				if data.highlight then data.highlight.Enabled = false end
			end
		end
	end
end

if Monsters then
	Monsters.ChildRemoved:Connect(function(child)
		if bossEspObjects[child] then
			if bossEspObjects[child].billboard then bossEspObjects[child].billboard:Destroy() end
			if bossEspObjects[child].highlight then bossEspObjects[child].highlight:Destroy() end
			bossEspObjects[child] = nil
		end
	end)
end

-- ==================== ITEM ESP ====================
local itemEspFolder = Instance.new("Folder", ScreenGui)
itemEspFolder.Name = "ItemESP"
local itemEspObjects = {}

local function shouldShowItem(drop)
	local rarity = drop:GetAttribute("Rarity")
	local anyRarityEnabled = false
	for _, v in pairs(Rarities) do if v then anyRarityEnabled = true break end end
	if anyRarityEnabled then
		if not rarity or not Rarities[rarity] then return false end
	end
	local hasNameFilter = next(NameFilters) ~= nil
	if hasNameFilter and not NameFilters[drop.Name] then return false end
	return true
end

local function updateItemEsp()
	if not itemEspEnabled or not Drops then
		for _, obj in pairs(itemEspObjects) do if obj then obj.Enabled = false end end
		return
	end
	for _, drop in ipairs(Drops:GetChildren()) do
		if drop.Name:lower():find("chest") then continue end
		if shouldShowItem(drop) then
			if not itemEspObjects[drop] then
				local billboard = Instance.new("BillboardGui")
				billboard.AlwaysOnTop = true
				billboard.Size = UDim2.new(0, 180, 0, 40)
				billboard.StudsOffset = Vector3.new(0, 2.5, 0)
				billboard.Parent = itemEspFolder
				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, 0, 1, 0)
				label.BackgroundTransparency = 1
				label.TextColor3 = Color3.fromRGB(255, 255, 255)
				label.TextStrokeTransparency = 0.4
				label.Font = Enum.Font.GothamBold
				label.TextSize = 12
				label.Parent = billboard
				itemEspObjects[drop] = billboard
			end
			local bb = itemEspObjects[drop]
			local label = bb:FindFirstChildOfClass("TextLabel")
			local rarity = drop:GetAttribute("Rarity") or "?"
			local dist = HRP and (drop:GetPivot().Position - HRP.Position).Magnitude or 0
			local part = drop.PrimaryPart or drop:FindFirstChildWhichIsA("BasePart")
			if part then
				bb.Adornee = part
				bb.Enabled = true
				if label then label.Text = string.format("%s\n%s | %dm", drop.Name, rarity, math.floor(dist)) end
			else
				bb.Enabled = false
			end
		else
			if itemEspObjects[drop] then itemEspObjects[drop].Enabled = false end
		end
	end
end

if Drops then
	Drops.ChildRemoved:Connect(function(child)
		if itemEspObjects[child] then
			itemEspObjects[child]:Destroy()
			itemEspObjects[child] = nil
		end
	end)
end

-- ==================== CHEST ESP (RandomSpawns + Traps) ====================
local chestEspFolder = Instance.new("Folder", ScreenGui)
chestEspFolder.Name = "ChestESP"
local chestEspObjects = {}

local function getChestFolders()
	local folders = {}
	local systems = workspace:FindFirstChild("Systems")
	if not systems then return folders end

	local randomSpawns = systems:FindFirstChild("RandomSpawns")
	if randomSpawns then
		local active = randomSpawns:FindFirstChild("Active")
		if active then table.insert(folders, active) end
	end

	local traps = systems:FindFirstChild("Traps")
	if traps then
		local activeTraps = traps:FindFirstChild("ActiveTraps")
		if activeTraps then table.insert(folders, activeTraps) end
	end

	return folders
end

local function updateChestEsp()
	if not chestEspEnabled then
		for _, obj in pairs(chestEspObjects) do
			if obj.billboard then obj.billboard.Enabled = false end
			if obj.highlight then obj.highlight.Enabled = false end
		end
		return
	end

	local folders = getChestFolders()
	if #folders == 0 then return end

	for _, folder in ipairs(folders) do
		for _, obj in ipairs(folder:GetDescendants()) do
			if obj.Name == "Chest" then
				local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart") or obj.PrimaryPart
				if not part then continue end

				if not chestEspObjects[obj] then
					local highlight = Instance.new("Highlight")
					highlight.FillColor = Color3.fromRGB(255, 200, 80)
					highlight.OutlineColor = Color3.fromRGB(255, 230, 120)
					highlight.FillTransparency = 0.55
					highlight.OutlineTransparency = 0
					highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					highlight.Enabled = false

					local billboard = Instance.new("BillboardGui")
					billboard.AlwaysOnTop = true
					billboard.Size = UDim2.new(0, 140, 0, 40)
					billboard.StudsOffset = Vector3.new(0, 2.5, 0)
					billboard.Parent = chestEspFolder

					local label = Instance.new("TextLabel")
					label.Size = UDim2.new(1, 0, 1, 0)
					label.BackgroundTransparency = 1
					label.TextColor3 = Color3.fromRGB(255, 230, 120)
					label.TextStrokeTransparency = 0.4
					label.Font = Enum.Font.GothamBold
					label.TextSize = 13
					label.Parent = billboard

					chestEspObjects[obj] = {
						billboard = billboard,
						label = label,
						highlight = highlight
					}
				end

				local data = chestEspObjects[obj]
				local dist = HRP and (part.Position - HRP.Position).Magnitude or 0

				data.billboard.Adornee = part
				data.billboard.Enabled = true
				data.label.Text = string.format("Chest\n%dm", math.floor(dist))

				if data.highlight then
					data.highlight.Adornee = obj:IsA("Model") and obj or part
					data.highlight.Parent = obj:IsA("Model") and obj or part
					data.highlight.Enabled = true
				end
			end
		end
	end

	for obj, data in pairs(chestEspObjects) do
		if not obj.Parent then
			if data.billboard then data.billboard:Destroy() end
			if data.highlight then data.highlight:Destroy() end
			chestEspObjects[obj] = nil
		end
	end
end

-- Main loop + RGB for Player + Chest
local hue = 0
RunService.RenderStepped:Connect(function()
	if not running then return end
	updatePlayerEsp()
	updateBossEsp()
	updateItemEsp()
	updateChestEsp()

	if rgbOutline then
		hue = (hue + 0.005) % 1
		local color = Color3.fromHSV(hue, 1, 1)

		-- Player outlines
		if espEnabled then
			for _, obj in pairs(espObjects) do
				if obj.highlight and obj.highlight.Enabled then
					obj.highlight.OutlineColor = color
					obj.highlight.FillColor = color
				end
			end
		end

		-- Chest outlines
		if chestEspEnabled then
			for _, obj in pairs(chestEspObjects) do
				if obj.highlight and obj.highlight.Enabled then
					obj.highlight.OutlineColor = color
					obj.highlight.FillColor = color
				end
			end
		end
	end
end)

-- Restore
task.spawn(function()
	task.wait(1)
	if itemEspEnabled then
		ItemEspCheck.Text = "✓"
		ItemEspCheck.BackgroundColor3 = Theme.Accent
	end
	if chestEspEnabled then
		ChestEspCheck.Text = "✓"
		ChestEspCheck.BackgroundColor3 = Theme.Accent
	end
	if fullBrightEnabled then
		BrightCheck.Text = "✓"
		BrightCheck.BackgroundColor3 = Theme.Accent
		enableFullBright()
	end
	if espEnabled then
		PlayerEspCheck.Text = "✓"
		PlayerEspCheck.BackgroundColor3 = Theme.Accent
	end
	if bossEspEnabled then
		BossEspCheck.Text = "✓"
		BossEspCheck.BackgroundColor3 = Theme.Accent
	end
	if speedEnabled then
		SpeedCheck.Text = "✓"
		SpeedCheck.BackgroundColor3 = Theme.Accent
		applySpeed()
	end
	if flyEnabled then
		FlyCheck.Text = "✓"
		FlyCheck.BackgroundColor3 = Theme.Accent
		startFly()
		NoclipToggle.Text = "NoClip: ON"
		NoclipToggle.BackgroundColor3 = Theme.Accent
	end
	if noclipEnabled then
		NoclipToggle.Text = "NoClip: ON"
		NoclipToggle.BackgroundColor3 = Theme.Accent
		setNoClip(true)
	end
	if rgbOutline then
		RgbToggle.Text = "RGB Outline: ON"
		RgbToggle.BackgroundColor3 = Theme.Accent
	end
end)

updateSize()
print("[HentaiHub V2.8] Loaded | The Herta Theme | Chest ESP (RandomSpawns + Traps) | RGB on Chests")
