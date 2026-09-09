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

-- ========== SMART SERVER HOP (1-3 players) ==========
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
		warn("[Server Hop] No 1-3 player servers found, using normal hop")
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
MainFrame.Size = UDim2.new(0, 260, 0, 32)
MainFrame.Position = UDim2.new(0.5, -130, 0.05, 0)
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

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -16, 0, 0)
Content.Position = UDim2.new(0, 8, 0, 36)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)
layout.Parent = Content

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

-- Teleport Buttons
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
local FesteringBtn = createTPButton("TP The Festering", Color3.fromRGB(40, 140, 80))
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

-- Size updater
local function updateSize()
	task.wait()
	if minimized then
		MainFrame.Size = UDim2.new(0, 260, 0, 32)
		Content.Visible = false
	else
		Content.Visible = true
		local total = layout.AbsoluteContentSize.Y + 48
		MainFrame.Size = UDim2.new(0, 260, 0, math.clamp(total, 80, 800))
	end
end
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)

MinBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	MinBtn.Text = minimized and "+" or "–"
	updateSize()
end)

RarityHeader.MouseButton1Click:Connect(function()
	rarityOpen = not rarityOpen
	RarityHeader.Text = rarityOpen and "Rarities  ▲" or "Rarities  ▼"
	RarityContainer.Size = UDim2.new(1, 0, 0, rarityOpen and 130 or 0)
	updateSize()
end)

PlayerHeader.MouseButton1Click:Connect(function()
	playerOpen = not playerOpen
	PlayerHeader.Text = playerOpen and "TP to Player  ▲" or "TP to Player  ▼"
	PlayerFrame.Size = UDim2.new(1, 0, 0, playerOpen and 100 or 0)
	updateSize()
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
	updateSize()
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
local function refreshPlayerList()
	for _, child in ipairs(PlayerFrame:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	local count = 0
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			count += 1
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -6, 0, 22)
			btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Text = plr.Name
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 12
			btn.Parent = PlayerFrame
			local c = Instance.new("UICorner")
			c.CornerRadius = UDim.new(0, 4)
			c.Parent = btn
			btn.MouseButton1Click:Connect(function()
				local char = plr.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if root and HRP then
					HRP.CFrame = root.CFrame + Vector3.new(0, 3, 0)
				end
			end)
		end
	end
	PlayerFrame.CanvasSize = UDim2.new(0, 0, 0, count * 25)
end
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
refreshPlayerList()

-- Teleport CFrames
local function tpToCFrame(cf)
	if HRP then HRP.CFrame = cf end
end

local GemGachaCF = CFrame.new(
	-239.865997, 1471.57495, -5.01026917,
	2.83718109e-05, -0.70481348, 0.709392726,
	1, 2.83718109e-05, -1.18017197e-05,
	-1.18017197e-05, 0.709392726, 0.704813421
)

local FesteringCF = CFrame.new(
	1339.49951, -553.002441, 382.000061,
	0, 0, 1,
	1, 0, 0,
	0, 1, 0
)

GemGachaBtn.MouseButton1Click:Connect(function()
	tpToCFrame(GemGachaCF)
end)

FesteringBtn.MouseButton1Click:Connect(function()
	tpToCFrame(FesteringCF)
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
	if autoHopEnabled then hopTimer = hopMinutes * 60 end
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

-- Item ESP (filtered by rarity + name filter)
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

-- Auto Hop
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
print("[HentaiHub] Fully Loaded - Smart Server Hop (1-3 players)")
