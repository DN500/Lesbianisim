------------------ CONFIG ------------------
local TP_DELAY = 1
local CHECK_DELAY = 0.3
local SPAM_DELAY = 0.05
local SAVE_FILE = "AutoFarmConfig.json"
--------------------------------------------

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VIM = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Drops = workspace:WaitForChild("Drops")

local enabled = false
local spamming = false
local running = true
local espEnabled = false
local itemEspEnabled = false
local fullBrightEnabled = false
local autoHopEnabled = false
local minimized = false
local bossListOpen = false

local hopMinutes = 10
local hopTimer = hopMinutes * 60

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

local Rarities = {
	Common = false, Uncommon = false, Rare = false, Elite = false, Legendary = false
}
local NameFilters = {
	["Idol of Hatred"] = true,
	["Stone Accord"] = true,
}

local function loadConfig()
	if isfile and isfile(SAVE_FILE) then
		local success, data = pcall(function()
			return HttpService:JSONDecode(readfile(SAVE_FILE))
		end)
		if success and data then
			if data.Rarities then for k,v in pairs(data.Rarities) do Rarities[k] = v end end
			if data.NameFilters then NameFilters = data.NameFilters end
			if data.hopMinutes then
				hopMinutes = data.hopMinutes
				hopTimer = hopMinutes * 60
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
				hopMinutes = hopMinutes
			}))
		end)
	end
end
loadConfig()

-- ========== SMART SERVER HOP ==========
local function getLowPlayerServers()
	local servers = {}
	local cursor = ""
	
	for i = 1, 4 do
		local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
		if cursor ~= "" then
			url = url .. "&cursor=" .. cursor
		end
		
		local success, result = pcall(function()
			return HttpService:JSONDecode(game:HttpGet(url))
		end)
		
		if success and result and result.data then
			for _, server in ipairs(result.data) do
				local playing = server.playing or 0
				local jobId = server.id
				
				if playing >= 1 and playing <= 3 and jobId ~= game.JobId then
					table.insert(servers, {
						id = jobId,
						playing = playing
					})
				end
			end
			
			cursor = result.nextPageCursor or ""
			if cursor == "" then break end
		else
			break
		end
	end
	
	table.sort(servers, function(a, b)
		return a.playing < b.playing
	end)
	
	return servers
end

local function smartServerHop()
	local servers = getLowPlayerServers()
	
	if #servers == 0 then
		warn("[Server Hop] No 1-3 player servers found")
		pcall(function()
			TeleportService:Teleport(game.PlaceId, LocalPlayer)
		end)
		return
	end
	
	local target = servers[1]
	print("[Server Hop] Joining server with", target.playing, "players")
	
	local success, err = pcall(function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, target.id, LocalPlayer)
	end)
	
	if not success then
		warn("[Server Hop] Failed:", err)
		pcall(function()
			TeleportService:Teleport(game.PlaceId, LocalPlayer)
		end)
	end
end

-- ==================== UI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 32)
MainFrame.Position = UDim2.new(0.5, -140, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "HentaiHub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 26, 0, 26)
MinBtn.Position = UDim2.new(1, -58, 0, 3)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinBtn.Text = "–"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.Parent = TitleBar
local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -29, 0, 3)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TitleBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
	saveConfig()
	running = false
	enabled = false
	spamming = false
	espEnabled = false
	itemEspEnabled = false
	autoHopEnabled = false
	if fullBrightEnabled then disableFullBright() end
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

-- Resize Handle
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Size = UDim2.new(0, 16, 0, 16)
ResizeHandle.Position = UDim2.new(1, -16, 1, -16)
ResizeHandle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
ResizeHandle.Text = ""
ResizeHandle.AutoButtonColor = false
ResizeHandle.Parent = MainFrame
local rhC = Instance.new("UICorner")
rhC.CornerRadius = UDim.new(0, 4)
rhC.Parent = ResizeHandle

local resizing = false
local resizeStart, startSize

ResizeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		resizing = true
		resizeStart = input.Position
		startSize = MainFrame.Size
	end
end)

ResizeHandle.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		resizing = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - resizeStart
		local newWidth = math.clamp(startSize.X.Offset + delta.X, 240, 500)
		local newHeight = math.clamp(startSize.Y.Offset + delta.Y, 120, 850)
		MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
	end
end)

-- Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -16, 1, -48)
Content.Position = UDim2.new(0, 8, 0, 36)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.Parent = MainFrame

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)
layout.Parent = Content

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

-- Checkbox helper
local function createCheckbox(text, default)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 26)
	frame.BackgroundTransparency = 1
	frame.Parent = Content

	local box = Instance.new("TextButton")
	box.Size = UDim2.new(0, 22, 0, 22)
	box.Position = UDim2.new(0, 0, 0, 2)
	box.BackgroundColor3 = default and Color3.fromRGB(0, 170, 80) or Color3.fromRGB(50, 50, 50)
	box.Text = default and "✓" or ""
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.Font = Enum.Font.GothamBold
	box.TextSize = 14
	box.Parent = frame
	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 5)
	bc.Parent = box

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -30, 1, 0)
	label.Position = UDim2.new(0, 30, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	return box
end

local FarmCheck = createCheckbox("Auto Farm", false)
local ItemEspCheck = createCheckbox("Item ESP", false)
local BrightCheck = createCheckbox("Full Bright", false)
local PlayerEspCheck = createCheckbox("Player ESP", false)

-- Buttons
local function createTPButton(text, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 28)
	btn.BackgroundColor3 = color
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Parent = Content
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 6)
	c.Parent = btn
	return btn
end

local GemGachaBtn = createTPButton("TP Named Gem Gacha", Color3.fromRGB(120, 40, 180))
local BossListBtn = createTPButton("Boss List  →", Color3.fromRGB(40, 120, 90))
local HopBtn = createTPButton("Server Hop (1-3 Players)", Color3.fromRGB(180, 60, 60))

local AutoHopCheck = createCheckbox("Auto Server Hop", false)

local HopTimerFrame = Instance.new("Frame")
HopTimerFrame.Size = UDim2.new(1, 0, 0, 45)
HopTimerFrame.BackgroundTransparency = 1
HopTimerFrame.Parent = Content

local HopLabel = Instance.new("TextLabel")
HopLabel.Size = UDim2.new(0.6, 0, 0, 20)
HopLabel.BackgroundTransparency = 1
HopLabel.Text = "Timer (minutes):"
HopLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
HopLabel.Font = Enum.Font.Gotham
HopLabel.TextSize = 12
HopLabel.TextXAlignment = Enum.TextXAlignment.Left
HopLabel.Parent = HopTimerFrame

local HopBox = Instance.new("TextBox")
HopBox.Size = UDim2.new(0, 50, 0, 22)
HopBox.Position = UDim2.new(0.65, 0, 0, 0)
HopBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
HopBox.TextColor3 = Color3.fromRGB(255, 255, 255)
HopBox.Text = tostring(hopMinutes)
HopBox.Font = Enum.Font.Gotham
HopBox.TextSize = 12
HopBox.Parent = HopTimerFrame
local hbC = Instance.new("UICorner")
hbC.CornerRadius = UDim.new(0, 5)
hbC.Parent = HopBox

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(1, 0, 0, 18)
TimerLabel.Position = UDim2.new(0, 0, 0, 24)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "Auto Hop disabled"
TimerLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
TimerLabel.Font = Enum.Font.Gotham
TimerLabel.TextSize = 11
TimerLabel.TextXAlignment = Enum.TextXAlignment.Left
TimerLabel.Parent = HopTimerFrame

HopBox.FocusLost:Connect(function()
	local num = tonumber(HopBox.Text)
	if num and num > 0 then
		hopMinutes = num
		hopTimer = hopMinutes * 60
		saveConfig()
	else
		HopBox.Text = tostring(hopMinutes)
	end
end)

-- Rarities
local rarityOpen = false
local RarityHeader = Instance.new("TextButton")
RarityHeader.Size = UDim2.new(1, 0, 0, 28)
RarityHeader.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
RarityHeader.Text = "Rarities  ▼"
RarityHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
RarityHeader.Font = Enum.Font.GothamBold
RarityHeader.TextSize = 13
RarityHeader.Parent = Content
local rhC = Instance.new("UICorner")
rhC.CornerRadius = UDim.new(0, 6)
rhC.Parent = RarityHeader

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
	btn.BackgroundColor3 = Rarities[rarity] and Color3.fromRGB(0, 140, 70) or Color3.fromRGB(45, 45, 45)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = rarity .. (Rarities[rarity] and " ✓" or "")
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 12
	btn.Parent = RarityContainer
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 5)
	c.Parent = btn

	btn.MouseButton1Click:Connect(function()
		Rarities[rarity] = not Rarities[rarity]
		btn.BackgroundColor3 = Rarities[rarity] and Color3.fromRGB(0, 140, 70) or Color3.fromRGB(45, 45, 45)
		btn.Text = rarity .. (Rarities[rarity] and " ✓" or "")
		saveConfig()
	end)
end

-- Item Filter
local FilterHeader = Instance.new("TextLabel")
FilterHeader.Size = UDim2.new(1, 0, 0, 18)
FilterHeader.BackgroundTransparency = 1
FilterHeader.Text = "Item Filter"
FilterHeader.TextColor3 = Color3.fromRGB(180, 180, 180)
FilterHeader.Font = Enum.Font.GothamBold
FilterHeader.TextSize = 12
FilterHeader.TextXAlignment = Enum.TextXAlignment.Left
FilterHeader.Parent = Content

local FilterRow = Instance.new("Frame")
FilterRow.Size = UDim2.new(1, 0, 0, 26)
FilterRow.BackgroundTransparency = 1
FilterRow.Parent = Content

local NameBox = Instance.new("TextBox")
NameBox.Size = UDim2.new(1, -60, 1, 0)
NameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
NameBox.PlaceholderText = "Item name..."
NameBox.Font = Enum.Font.Gotham
NameBox.TextSize = 12
NameBox.Parent = FilterRow
local nc = Instance.new("UICorner")
nc.CornerRadius = UDim.new(0, 5)
nc.Parent = NameBox

local AddBtn = Instance.new("TextButton")
AddBtn.Size = UDim2.new(0, 52, 1, 0)
AddBtn.Position = UDim2.new(1, -52, 0, 0)
AddBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
AddBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AddBtn.Text = "Add"
AddBtn.Font = Enum.Font.GothamBold
AddBtn.TextSize = 12
AddBtn.Parent = FilterRow
local ac = Instance.new("UICorner")
ac.CornerRadius = UDim.new(0, 5)
ac.Parent = AddBtn

local NameListFrame = Instance.new("ScrollingFrame")
NameListFrame.Size = UDim2.new(1, 0, 0, 60)
NameListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
NameListFrame.BorderSizePixel = 0
NameListFrame.ScrollBarThickness = 4
NameListFrame.CanvasSize = UDim2.new(0,0,0,0)
NameListFrame.Parent = Content
local lc = Instance.new("UICorner")
lc.CornerRadius = UDim.new(0, 5)
lc.Parent = NameListFrame
local ll = Instance.new("UIListLayout")
ll.Padding = UDim.new(0, 3)
ll.Parent = NameListFrame

-- TP to Player
local playerOpen = false
local PlayerHeader = Instance.new("TextButton")
PlayerHeader.Size = UDim2.new(1, 0, 0, 28)
PlayerHeader.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
PlayerHeader.Text = "TP to Player  ▼"
PlayerHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerHeader.Font = Enum.Font.GothamBold
PlayerHeader.TextSize = 13
PlayerHeader.Parent = Content
local phC = Instance.new("UICorner")
phC.CornerRadius = UDim.new(0, 6)
phC.Parent = PlayerHeader

local PlayerFrame = Instance.new("ScrollingFrame")
PlayerFrame.Size = UDim2.new(1, 0, 0, 0)
PlayerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
PlayerFrame.BorderSizePixel = 0
PlayerFrame.ScrollBarThickness = 4
PlayerFrame.CanvasSize = UDim2.new(0,0,0,0)
PlayerFrame.ClipsDescendants = true
PlayerFrame.Parent = Content
local pfC = Instance.new("UICorner")
pfC.CornerRadius = UDim.new(0, 5)
pfC.Parent = PlayerFrame
local pfL = Instance.new("UIListLayout")
pfL.Padding = UDim.new(0, 3)
pfL.Parent = PlayerFrame

-- ========== BOSS LIST SIDE PANEL (FIXED) ==========
local BossPanel = Instance.new("Frame")
BossPanel.Size = UDim2.new(0, 200, 0, 160)
BossPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
BossPanel.BorderSizePixel = 0
BossPanel.Visible = false
BossPanel.Parent = ScreenGui
local bpC = Instance.new("UICorner")
bpC.CornerRadius = UDim.new(0, 10)
bpC.Parent = BossPanel

local BossTitle = Instance.new("TextLabel")
BossTitle.Size = UDim2.new(1, -10, 0, 30)
BossTitle.Position = UDim2.new(0, 8, 0, 4)
BossTitle.BackgroundTransparency = 1
BossTitle.Text = "Boss Teleports"
BossTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
BossTitle.Font = Enum.Font.GothamBold
BossTitle.TextSize = 14
BossTitle.TextXAlignment = Enum.TextXAlignment.Left
BossTitle.Parent = BossPanel

local BossClose = Instance.new("TextButton")
BossClose.Size = UDim2.new(0, 24, 0, 24)
BossClose.Position = UDim2.new(1, -28, 0, 4)
BossClose.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
BossClose.Text = "X"
BossClose.TextColor3 = Color3.fromRGB(255, 255, 255)
BossClose.Font = Enum.Font.GothamBold
BossClose.TextSize = 12
BossClose.Parent = BossPanel
local bcC = Instance.new("UICorner")
bcC.CornerRadius = UDim.new(0, 5)
bcC.Parent = BossClose

local BossList = Instance.new("ScrollingFrame")
BossList.Size = UDim2.new(1, -16, 1, -40)
BossList.Position = UDim2.new(0, 8, 0, 36)
BossList.BackgroundTransparency = 1
BossList.BorderSizePixel = 0
BossList.ScrollBarThickness = 4
BossList.CanvasSize = UDim2.new(0, 0, 0, 0)
BossList.Parent = BossPanel

local BossLayout = Instance.new("UIListLayout")
BossLayout.Padding = UDim.new(0, 6)
BossLayout.Parent = BossList

-- Boss Data (easy to add more)
local Bosses = {
	{
		Name = "The Festering",
		CFrame = CFrame.new(
			1339.49951, -553.002441, 382.000061,
			0, 0, 1,
			1, 0, 0,
			0, 1, 0
		)
	},
}

for _, boss in ipairs(Bosses) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 32)
	btn.BackgroundColor3 = Color3.fromRGB(50, 100, 70)
	btn.Text = boss.Name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Parent = BossList
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 6)
	c.Parent = btn

	btn.MouseButton1Click:Connect(function()
		if HRP then
			HRP.CFrame = boss.CFrame
		end
	end)
end

BossLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	BossList.CanvasSize = UDim2.new(0, 0, 0, BossLayout.AbsoluteContentSize.Y + 10)
end)

local function updateBossPanelPosition()
	local mainPos = MainFrame.AbsolutePosition
	local mainSize = MainFrame.AbsoluteSize
	BossPanel.Position = UDim2.new(0, mainPos.X + mainSize.X + 8, 0, mainPos.Y)
end

BossListBtn.MouseButton1Click:Connect(function()
	bossListOpen = not bossListOpen
	BossPanel.Visible = bossListOpen
	BossListBtn.Text = bossListOpen and "Boss List  ←" or "Boss List  →"
	if bossListOpen then
		updateBossPanelPosition()
	end
end)

BossClose.MouseButton1Click:Connect(function()
	bossListOpen = false
	BossPanel.Visible = false
	BossListBtn.Text = "Boss List  →"
end)

MainFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
	if bossListOpen then updateBossPanelPosition() end
end)
MainFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	if bossListOpen then updateBossPanelPosition() end
end)

-- Confirm Popup
local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(0, 220, 0, 110)
ConfirmFrame.Position = UDim2.new(0.5, -110, 0.5, -55)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ConfirmFrame.BorderSizePixel = 0
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 10
ConfirmFrame.Parent = ScreenGui
local cfC = Instance.new("UICorner")
cfC.CornerRadius = UDim.new(0, 10)
cfC.Parent = ConfirmFrame

local ConfirmTitle = Instance.new("TextLabel")
ConfirmTitle.Size = UDim2.new(1, -20, 0, 40)
ConfirmTitle.Position = UDim2.new(0, 10, 0, 8)
ConfirmTitle.BackgroundTransparency = 1
ConfirmTitle.Text = "TP to Player?"
ConfirmTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmTitle.Font = Enum.Font.GothamBold
ConfirmTitle.TextSize = 14
ConfirmTitle.TextWrapped = true
ConfirmTitle.Parent = ConfirmFrame

local ConfirmYes = Instance.new("TextButton")
ConfirmYes.Size = UDim2.new(0, 90, 0, 32)
ConfirmYes.Position = UDim2.new(0, 15, 1, -45)
ConfirmYes.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
ConfirmYes.Text = "Confirm"
ConfirmYes.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmYes.Font = Enum.Font.GothamBold
ConfirmYes.TextSize = 13
ConfirmYes.Parent = ConfirmFrame
local cyC = Instance.new("UICorner")
cyC.CornerRadius = UDim.new(0, 6)
cyC.Parent = ConfirmYes

local ConfirmNo = Instance.new("TextButton")
ConfirmNo.Size = UDim2.new(0, 90, 0, 32)
ConfirmNo.Position = UDim2.new(1, -105, 1, -45)
ConfirmNo.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
ConfirmNo.Text = "Cancel"
ConfirmNo.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmNo.Font = Enum.Font.GothamBold
ConfirmNo.TextSize = 13
ConfirmNo.Parent = ConfirmFrame
local cnC = Instance.new("UICorner")
cnC.CornerRadius = UDim.new(0, 6)
cnC.Parent = ConfirmNo

local pendingPlayer = nil

ConfirmYes.MouseButton1Click:Connect(function()
	if pendingPlayer and HRP then
		local char = pendingPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if root then
			HRP.CFrame = root.CFrame + Vector3.new(0, 3, 0)
		end
	end
	ConfirmFrame.Visible = false
	pendingPlayer = nil
end)

ConfirmNo.MouseButton1Click:Connect(function()
	ConfirmFrame.Visible = false
	pendingPlayer = nil
end)

-- Size / Minimize
local function updateSize()
	if minimized then
		MainFrame.Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 32)
		Content.Visible = false
		ResizeHandle.Visible = false
		BossPanel.Visible = false
	else
		Content.Visible = true
		ResizeHandle.Visible = true
		if MainFrame.Size.Y.Offset < 150 then
			MainFrame.Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 450)
		end
	end
end

MinBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	MinBtn.Text = minimized and "+" or "–"
	updateSize()
end)

RarityHeader.MouseButton1Click:Connect(function()
	rarityOpen = not rarityOpen
	RarityHeader.Text = rarityOpen and "Rarities  ▲" or "Rarities  ▼"
	RarityContainer.Size = UDim2.new(1, 0, 0, rarityOpen and 130 or 0)
end)

PlayerHeader.MouseButton1Click:Connect(function()
	playerOpen = not playerOpen
	PlayerHeader.Text = playerOpen and "TP to Player  ▲" or "TP to Player  ▼"
	PlayerFrame.Size = UDim2.new(1, 0, 0, playerOpen and 110 or 0)
end)

-- Name filter
local function findBestMatch(input)
	input = input:lower():gsub("^%s*(.-)%s*$", "%1")
	if input == "" then return nil end
	local bestMatch, bestScore = nil, 0
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
		btn.Size = UDim2.new(1, -6, 0, 20)
		btn.BackgroundColor3 = Color3.fromRGB(60, 40, 40)
		btn.TextColor3 = Color3.fromRGB(255, 200, 200)
		btn.Text = name .. "  X"
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 11
		btn.Parent = NameListFrame
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 4)
		c.Parent = btn
		btn.MouseButton1Click:Connect(function()
			NameFilters[name] = nil
			refreshNameList()
			saveConfig()
		end)
	end
	NameListFrame.CanvasSize = UDim2.new(0, 0, 0, count * 23)
end

AddBtn.MouseButton1Click:Connect(function()
	local text = NameBox.Text
	local corrected = findBestMatch(text)
	if corrected then
		NameFilters[corrected] = true
	elseif text:gsub("%s","") ~= "" then
		NameFilters[text] = true
	end
	NameBox.Text = ""
	refreshNameList()
	saveConfig()
end)
refreshNameList()

-- Player list
-- Player list (with DisplayName)
local function refreshPlayerList()
	for _, child in ipairs(PlayerFrame:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	local count = 0
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			count += 1
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -6, 0, 24)
			btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 12
			btn.Parent = PlayerFrame

			-- Show DisplayName + Username
			if plr.DisplayName ~= plr.Name then
				btn.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
			else
				btn.Text = plr.Name
			end

			local c = Instance.new("UICorner")
			c.CornerRadius = UDim.new(0, 4)
			c.Parent = btn

			btn.MouseButton1Click:Connect(function()
				pendingPlayer = plr
				ConfirmTitle.Text = "TP to " .. plr.DisplayName .. "?"
				ConfirmFrame.Visible = true
			end)
		end
	end
	PlayerFrame.CanvasSize = UDim2.new(0, 0, 0, count * 27)
end
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
refreshPlayerList()

-- Gem Gacha
local GemGachaCF = CFrame.new(
	-239.865997, 1471.57495, -5.01026917,
	2.83718109e-05, -0.70481348, 0.709392726,
	1, 2.83718109e-05, -1.18017197e-05,
	-1.18017197e-05, 0.709392726, 0.704813421
)

GemGachaBtn.MouseButton1Click:Connect(function()
	if HRP then HRP.CFrame = GemGachaCF end
end)

-- Logic
local function tpTo(drop)
	if HRP and drop then
		HRP.CFrame = drop:GetPivot() + Vector3.new(0, 3, 0)
	end
end

local function spamE()
	task.spawn(function()
		while spamming and running do
			pcall(function()
				VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
				task.wait(0.03)
				VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
			end)
			task.wait(SPAM_DELAY)
		end
	end)
end

FarmCheck.MouseButton1Click:Connect(function()
	enabled = not enabled
	spamming = enabled
	FarmCheck.Text = enabled and "✓" or ""
	FarmCheck.BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 80) or Color3.fromRGB(50, 50, 50)
	if enabled then spamE() end
end)

ItemEspCheck.MouseButton1Click:Connect(function()
	itemEspEnabled = not itemEspEnabled
	ItemEspCheck.Text = itemEspEnabled and "✓" or ""
	ItemEspCheck.BackgroundColor3 = itemEspEnabled and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(50, 50, 50)
end)

BrightCheck.MouseButton1Click:Connect(function()
	fullBrightEnabled = not fullBrightEnabled
	BrightCheck.Text = fullBrightEnabled and "✓" or ""
	BrightCheck.BackgroundColor3 = fullBrightEnabled and Color3.fromRGB(200, 160, 0) or Color3.fromRGB(50, 50, 50)
	if fullBrightEnabled then enableFullBright() else disableFullBright() end
end)

PlayerEspCheck.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	PlayerEspCheck.Text = espEnabled and "✓" or ""
	PlayerEspCheck.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 140, 200) or Color3.fromRGB(50, 50, 50)
end)

AutoHopCheck.MouseButton1Click:Connect(function()
	autoHopEnabled = not autoHopEnabled
	AutoHopCheck.Text = autoHopEnabled and "✓" or ""
	AutoHopCheck.BackgroundColor3 = autoHopEnabled and Color3.fromRGB(200, 80, 80) or Color3.fromRGB(50, 50, 50)
	if autoHopEnabled then
		hopTimer = hopMinutes * 60
	end
end)

HopBtn.MouseButton1Click:Connect(function()
	smartServerHop()
end)

-- Player ESP
local espFolder = Instance.new("Folder")
espFolder.Name = "PlayerESP"
espFolder.Parent = ScreenGui
local espObjects = {}

local function createEsp(player)
	if player == LocalPlayer then return end
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
	nameLabel.Text = player.Name
	nameLabel.Parent = billboard
	local infoLabel = Instance.new("TextLabel")
	infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
	infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
	infoLabel.BackgroundTransparency = 1
	infoLabel.TextStrokeTransparency = 0.5
	infoLabel.Font = Enum.Font.Gotham
	infoLabel.TextSize = 12
	infoLabel.Parent = billboard
	return billboard, infoLabel
end

local function updatePlayerEsp()
	if not espEnabled then
		for _, obj in pairs(espObjects) do if obj.billboard then obj.billboard.Enabled = false end end
		return
	end
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local char = player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if not espObjects[player] then
				local bb, info = createEsp(player)
				espObjects[player] = {billboard = bb, infoLabel = info}
			end
			local data = espObjects[player]
			if root and hum and hum.Health > 0 then
				data.billboard.Adornee = root
				data.billboard.Enabled = true
				local dist = (root.Position - (HRP and HRP.Position or Vector3.zero)).Magnitude
				data.infoLabel.Text = string.format("%dm | %d/%d HP", math.floor(dist), math.floor(hum.Health), math.floor(hum.MaxHealth))
				local ratio = hum.Health / hum.MaxHealth
				data.infoLabel.TextColor3 = ratio > 0.6 and Color3.fromRGB(0,255,100) or ratio > 0.3 and Color3.fromRGB(255,200,0) or Color3.fromRGB(255,60,60)
			else
				data.billboard.Enabled = false
			end
		end
	end
end

Players.PlayerRemoving:Connect(function(player)
	if espObjects[player] then
		espObjects[player].billboard:Destroy()
		espObjects[player] = nil
	end
end)

-- Item ESP
local itemEspFolder = Instance.new("Folder")
itemEspFolder.Name = "ItemESP"
itemEspFolder.Parent = ScreenGui
local itemEspObjects = {}

local function shouldShowItem(drop)
	local rarity = drop:GetAttribute("Rarity")
	if not rarity or not Rarities[rarity] then return false end
	local hasNameFilter = next(NameFilters) ~= nil
	if hasNameFilter and not NameFilters[drop.Name] then return false end
	return true
end

local function updateItemEsp()
	if not itemEspEnabled then
		for _, obj in pairs(itemEspObjects) do if obj then obj.Enabled = false end end
		return
	end
	for _, drop in ipairs(Drops:GetChildren()) do
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
			bb.Adornee = drop.PrimaryPart or drop:FindFirstChildWhichIsA("BasePart")
			bb.Enabled = true
			if label then
				label.Text = string.format("%s\n%s | %dm", drop.Name, rarity, math.floor(dist))
			end
		else
			if itemEspObjects[drop] then
				itemEspObjects[drop].Enabled = false
			end
		end
	end
end

Drops.ChildRemoved:Connect(function(child)
	if itemEspObjects[child] then
		itemEspObjects[child]:Destroy()
		itemEspObjects[child] = nil
	end
end)

RunService.RenderStepped:Connect(function()
	if running then
		updatePlayerEsp()
		updateItemEsp()
	end
end)

-- Auto Farm
task.spawn(function()
	while running do
		if enabled then
			Character = LocalPlayer.Character
			if Character then HRP = Character:FindFirstChild("HumanoidRootPart") end
			if HRP and HRP.Parent then
				local hasNameFilter = next(NameFilters) ~= nil
				for _, drop in ipairs(Drops:GetChildren()) do
					local rarity = drop:GetAttribute("Rarity")
					local name = drop.Name
					if rarity and Rarities[rarity] then
						if hasNameFilter and not NameFilters[name] then continue end
						tpTo(drop)
						task.wait(TP_DELAY)
					end
				end
			end
		end
		task.wait(CHECK_DELAY)
	end
end)

-- Auto Hop (stays ON)
task.spawn(function()
	while running do
		if autoHopEnabled then
			hopTimer = hopTimer - 1
			local mins = math.floor(hopTimer / 60)
			local secs = hopTimer % 60
			TimerLabel.Text = string.format("Next hop in: %02d:%02d", mins, secs)
			
			if hopTimer <= 0 then
				TimerLabel.Text = "Hopping to 1-3 player server..."
				smartServerHop()
				hopTimer = hopMinutes * 60
			end
		else
			TimerLabel.Text = "Auto Hop disabled"
		end
		task.wait(1)
	end
end)

updateSize()
print("[HentaiHub] Fully Loaded - Boss List Fixed")
