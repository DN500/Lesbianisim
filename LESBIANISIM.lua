------------------ CONFIG ------------------
local TP_DELAY = 0.15
local CHECK_DELAY = 0.3
local SPAM_DELAY = 0.05
local SAVE_FILE = "AutoFarmConfig.json"
--------------------------------------------

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
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
local fullBrightEnabled = false

-- ========== REMOVE FOG ==========
local function deleteAtmosphere()
	local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
	if atmosphere then
		atmosphere:Destroy()
	end
end
deleteAtmosphere()
Lighting.ChildAdded:Connect(function(child)
	if child:IsA("Atmosphere") then
		child:Destroy()
	end
end)

-- ========== FULL BRIGHT ==========
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
-- ================================

local Rarities = {
	Common = false,
	Uncommon = false,
	Rare = false,
	Epic = false,
	Legendary = false,
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
			if data.Rarities then
				for k, v in pairs(data.Rarities) do
					Rarities[k] = v
				end
			end
			if data.NameFilters then
				NameFilters = data.NameFilters
			end
		end
	end
end

local function saveConfig()
	if writefile then
		pcall(function()
			writefile(SAVE_FILE, HttpService:JSONEncode({
				Rarities = Rarities,
				NameFilters = NameFilters
			}))
		end)
	end
end

loadConfig()

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 460)
MainFrame.Position = UDim2.new(0.5, -110, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 28)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "HentaiHub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

-- Close Button (proper box)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -30, 0, 2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
	saveConfig()
	running = false
	enabled = false
	spamming = false
	espEnabled = false
	if fullBrightEnabled then disableFullBright() end
	ScreenGui:Destroy()
	print("[Auto Farm] Closed")
end)

-- Dragging
local dragging = false
local dragStart, startPos

Title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)

Title.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Buttons
local function createBtn(text, yPos, parent)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -16, 0, 28)
	btn.Position = UDim2.new(0, 8, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	return btn
end

local ToggleBtn = createBtn("Auto Farm: OFF", 34, MainFrame)
local EspBtn = createBtn("Player ESP: OFF", 66, MainFrame)
local BrightBtn = createBtn("Full Bright: OFF", 98, MainFrame)

-- Rarity Section
local RarityLabel = Instance.new("TextLabel")
RarityLabel.Size = UDim2.new(1, -16, 0, 18)
RarityLabel.Position = UDim2.new(0, 8, 0, 132)
RarityLabel.BackgroundTransparency = 1
RarityLabel.Text = "Rarities"
RarityLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
RarityLabel.Font = Enum.Font.GothamBold
RarityLabel.TextSize = 12
RarityLabel.TextXAlignment = Enum.TextXAlignment.Left
RarityLabel.Parent = MainFrame

local rarityList = {"Common", "Uncommon", "Rare", "Epic", "Legendary"}
for i, rarity in ipairs(rarityList) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -16, 0, 22)
	btn.Position = UDim2.new(0, 8, 0, 152 + (i-1) * 24)
	btn.BackgroundColor3 = Rarities[rarity] and Color3.fromRGB(0, 140, 70) or Color3.fromRGB(45, 45, 45)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = rarity .. (Rarities[rarity] and " ✓" or "")
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 12
	btn.Parent = MainFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 5)
	corner.Parent = btn

	btn.MouseButton1Click:Connect(function()
		Rarities[rarity] = not Rarities[rarity]
		btn.BackgroundColor3 = Rarities[rarity] and Color3.fromRGB(0, 140, 70) or Color3.fromRGB(45, 45, 45)
		btn.Text = rarity .. (Rarities[rarity] and " ✓" or "")
		saveConfig()
	end)
end

-- Name Filter
local NameLabel = Instance.new("TextLabel")
NameLabel.Size = UDim2.new(1, -16, 0, 18)
NameLabel.Position = UDim2.new(0, 8, 0, 280)
NameLabel.BackgroundTransparency = 1
NameLabel.Text = "Name Filter"
NameLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
NameLabel.Font = Enum.Font.GothamBold
NameLabel.TextSize = 12
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.Parent = MainFrame

local NameBox = Instance.new("TextBox")
NameBox.Size = UDim2.new(1, -70, 0, 24)
NameBox.Position = UDim2.new(0, 8, 0, 300)
NameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
NameBox.PlaceholderText = "Item name..."
NameBox.Text = ""
NameBox.Font = Enum.Font.Gotham
NameBox.TextSize = 12
NameBox.Parent = MainFrame

local NameCorner = Instance.new("UICorner")
NameCorner.CornerRadius = UDim.new(0, 5)
NameCorner.Parent = NameBox

local AddBtn = Instance.new("TextButton")
AddBtn.Size = UDim2.new(0, 50, 0, 24)
AddBtn.Position = UDim2.new(1, -58, 0, 300)
AddBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
AddBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AddBtn.Text = "Add"
AddBtn.Font = Enum.Font.GothamBold
AddBtn.TextSize = 12
AddBtn.Parent = MainFrame

local AddCorner = Instance.new("UICorner")
AddCorner.CornerRadius = UDim.new(0, 5)
AddCorner.Parent = AddBtn

local NameListFrame = Instance.new("ScrollingFrame")
NameListFrame.Size = UDim2.new(1, -16, 0, 70)
NameListFrame.Position = UDim2.new(0, 8, 0, 330)
NameListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
NameListFrame.BorderSizePixel = 0
NameListFrame.ScrollBarThickness = 4
NameListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
NameListFrame.Parent = MainFrame

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 5)
ListCorner.Parent = NameListFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 3)
ListLayout.Parent = NameListFrame

local function findBestMatch(input)
	input = input:lower():gsub("^%s*(.-)%s*$", "%1")
	if input == "" then return nil end
	local bestMatch, bestScore = nil, 0
	for _, drop in ipairs(Drops:GetChildren()) do
		local name = drop.Name
		local lowerName = name:lower()
		if lowerName == input then return name end
		if lowerName:sub(1, #input) == input then
			local score = #input / #lowerName
			if score > bestScore then bestScore, bestMatch = score, name end
		elseif lowerName:find(input, 1, true) then
			local score = (#input / #lowerName) * 0.7
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
		btn.Size = UDim2.new(1, -8, 0, 20)
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
		NameBox.Text = ""
		refreshNameList()
		saveConfig()
	elseif text:gsub("%s", "") ~= "" then
		NameFilters[text] = true
		NameBox.Text = ""
		refreshNameList()
		saveConfig()
	end
end)

refreshNameList()

-- Functions
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

ToggleBtn.MouseButton1Click:Connect(function()
	enabled = not enabled
	spamming = enabled
	if enabled then
		ToggleBtn.Text = "Auto Farm: ON"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
		spamE()
	else
		ToggleBtn.Text = "Auto Farm: OFF"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	end
end)

EspBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	EspBtn.Text = espEnabled and "Player ESP: ON" or "Player ESP: OFF"
	EspBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 140, 200) or Color3.fromRGB(50, 50, 50)
end)

BrightBtn.MouseButton1Click:Connect(function()
	fullBrightEnabled = not fullBrightEnabled
	if fullBrightEnabled then
		enableFullBright()
		BrightBtn.Text = "Full Bright: ON"
		BrightBtn.BackgroundColor3 = Color3.fromRGB(200, 160, 0)
	else
		disableFullBright()
		BrightBtn.Text = "Full Bright: OFF"
		BrightBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	end
end)

-- ESP
local espFolder = Instance.new("Folder")
espFolder.Name = "PlayerESP"
espFolder.Parent = ScreenGui

local espObjects = {}

local function createEsp(player)
	if player == LocalPlayer then return end
	local billboard = Instance.new("BillboardGui")
	billboard.Name = player.Name
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
	infoLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
	infoLabel.TextStrokeTransparency = 0.5
	infoLabel.Font = Enum.Font.Gotham
	infoLabel.TextSize = 12
	infoLabel.Parent = billboard

	return billboard, infoLabel
end

local function updateEsp()
	if not espEnabled then
		for _, obj in pairs(espObjects) do
			if obj.billboard then obj.billboard.Enabled = false end
		end
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local char = player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local root = char and char:FindFirstChild("HumanoidRootPart")

			if not espObjects[player] then
				local bb, infoL = createEsp(player)
				espObjects[player] = {billboard = bb, infoLabel = infoL}
			end

			local data = espObjects[player]
			if root and hum and hum.Health > 0 then
				data.billboard.Adornee = root
				data.billboard.Enabled = true
				local distance = (root.Position - (HRP and HRP.Position or Vector3.zero)).Magnitude
				data.infoLabel.Text = string.format("%dm | %d/%d HP", math.floor(distance), math.floor(hum.Health), math.floor(hum.MaxHealth))
				local ratio = hum.Health / hum.MaxHealth
				data.infoLabel.TextColor3 = ratio > 0.6 and Color3.fromRGB(0, 255, 100) or ratio > 0.3 and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 60, 60)
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

RunService.RenderStepped:Connect(function()
	if running then updateEsp() end
end)

-- Auto TP
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

print("[Auto Farm] Loaded - Full Bright + Fog Removed")
