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
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

	local KeyGui = Instance.new("ScreenGui")
	KeyGui.Name = "KeySystem"
	KeyGui.ResetOnSpawn = false
	KeyGui.Parent = PlayerGui

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
	Title.Text = "HentaiHub V3 - Key System"
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

------------------ MAIN ------------------
local SAVE_FILE = "HentaiHubConfig.json"
local CHEST_NEAR_DISTANCE = 12
local ITEM_NEAR_DISTANCE = 15
local INTERACT_LOOP_DELAY = 0.07

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local VIM = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Drops = workspace:FindFirstChild("Drops") or workspace:WaitForChild("Drops", 5)
local Monsters = workspace:FindFirstChild("Monsters")

local running = true
local espEnabled = false
local autoCollectEnabled = false
local chestEspEnabled = false
local bossEspEnabled = false
local fullBrightEnabled = false
local minimized = false
local settingsOpen = false
local filterOpen = false
local funnyOpen = false
local speedEnabled = false
local flyEnabled = false
local noclipEnabled = false
local rgbOutline = false
local autoChestEnabled = false
local alertEnabled = false
local alertSoundId = "rbxassetid://1000123073"
local alertVolume = 30
local customSpeed = 30
local flySpeed = 50

local orbitEnabled = false
local lockTopEnabled = false
local orbitTargetPart = nil
local orbitTargetLabel = ""
local orbitRadius = 18
local orbitSpeed = 2.5
local orbitAngle = 0
local orbitHeight = 8

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

local Rarities = {
	Common = true,
	Uncommon = true,
	Rare = true,
	Elite = true,
	Legendary = true,
	Mythic = true,
}

local NameFilters = {
	["Idol of Hatred"] = true,
	["Stone Accord"] = true,
}
local NameFilterRarities = {}

local function deleteAtmosphere()
	local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
	if atmosphere then atmosphere:Destroy() end
end
deleteAtmosphere()
Lighting.ChildAdded:Connect(function(child)
	if child:IsA("Atmosphere") then child:Destroy() end
end)

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
		local success, data = pcall(function()
			return HttpService:JSONDecode(readfile(SAVE_FILE))
		end)
		if success and data then
			if data.Rarities then for k, v in pairs(data.Rarities) do Rarities[k] = v end end
			if data.NameFilters then NameFilters = data.NameFilters end
			if data.NameFilterRarities then NameFilterRarities = data.NameFilterRarities end
			if data.autoCollectEnabled ~= nil then autoCollectEnabled = data.autoCollectEnabled end
			if data.chestEspEnabled ~= nil then chestEspEnabled = data.chestEspEnabled end
			if data.fullBrightEnabled ~= nil then fullBrightEnabled = data.fullBrightEnabled end
			if data.espEnabled ~= nil then espEnabled = data.espEnabled end
			if data.bossEspEnabled ~= nil then bossEspEnabled = data.bossEspEnabled end
			if data.customSpeed then customSpeed = data.customSpeed end
			if data.flySpeed then flySpeed = data.flySpeed end
			if data.speedEnabled ~= nil then speedEnabled = data.speedEnabled end
			if data.noclipEnabled ~= nil then noclipEnabled = data.noclipEnabled end
			if data.rgbOutline ~= nil then rgbOutline = data.rgbOutline end
			if data.autoChestEnabled ~= nil then autoChestEnabled = data.autoChestEnabled end
			if data.alertEnabled ~= nil then alertEnabled = data.alertEnabled end
			if data.alertSoundId then alertSoundId = data.alertSoundId end
			if data.alertVolume then alertVolume = data.alertVolume end
			if data.orbitRadius then orbitRadius = data.orbitRadius end
			if data.orbitSpeed then orbitSpeed = data.orbitSpeed end
			if data.orbitHeight then orbitHeight = data.orbitHeight end
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
				NameFilterRarities = NameFilterRarities,
				autoCollectEnabled = autoCollectEnabled,
				chestEspEnabled = chestEspEnabled,
				fullBrightEnabled = fullBrightEnabled,
				espEnabled = espEnabled,
				bossEspEnabled = bossEspEnabled,
				customSpeed = customSpeed,
				flySpeed = flySpeed,
				speedEnabled = speedEnabled,
				noclipEnabled = noclipEnabled,
				rgbOutline = rgbOutline,
				autoChestEnabled = autoChestEnabled,
				alertEnabled = alertEnabled,
				alertSoundId = alertSoundId,
				alertVolume = alertVolume,
				orbitRadius = orbitRadius,
				orbitSpeed = orbitSpeed,
				orbitHeight = orbitHeight,
				SpeedKey = SpeedKey.Name,
				FlyKey = FlyKey.Name
			}))
		end)
	end
end
loadConfig()

local function playDropAlert(dropName, rarity)
	if not alertEnabled then return end
	pcall(function()
		local sound = Instance.new("Sound")
		sound.SoundId = alertSoundId
		sound.Volume = math.clamp(alertVolume / 10, 0, 10)
		sound.PlaybackSpeed = 1
		sound.Parent = SoundService
		sound:Play()
		sound.Ended:Connect(function()
			if sound then sound:Destroy() end
		end)
		task.delay(8, function()
			if sound and sound.Parent then sound:Destroy() end
		end)
	end)
	print(string.format("[Alert] %s dropped: %s", rarity, dropName))
end

if Drops then
	Drops.ChildAdded:Connect(function(drop)
		task.wait(0.2)
		local rarity = drop:GetAttribute("Rarity")
		if rarity == "Legendary" or rarity == "Mythic" then
			playDropAlert(drop.Name, rarity)
		end
	end)
end

local function getLowPlayerServers()
	local servers = {}
	local cursor = ""
	for i = 1, 4 do
		local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
		if cursor ~= "" then url = url .. "&cursor=" .. cursor end
		local success, result = pcall(function()
			return HttpService:JSONDecode(game:HttpGet(url))
		end)
		if success and result and result.data then
			for _, server in ipairs(result.data) do
				local playing = server.playing or 0
				if playing >= 1 and playing <= 3 and server.id ~= game.JobId then
					table.insert(servers, {id = server.id, playing = playing})
				end
			end
			cursor = result.nextPageCursor or ""
			if cursor == "" then break end
		else
			break
		end
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

local function applySpeed()
	local char = LocalPlayer.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum and speedEnabled then hum.WalkSpeed = customSpeed end
end

local function setNoClip(state)
	local char = LocalPlayer.Character
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then part.CanCollide = not state end
	end
end

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
	flyBV.Velocity = move.Magnitude > 0 and move.Unit * flySpeed or Vector3.zero
	flyBG.CFrame = cam.CFrame
end

local function pressE()
	pcall(function()
		VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
		task.wait(0.03)
		VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
	end)
end

local function syncNameFilterRarities()
	if not Drops then return end
	for _, drop in ipairs(Drops:GetChildren()) do
		if NameFilters[drop.Name] and not NameFilterRarities[drop.Name] then
			NameFilterRarities[drop.Name] = drop:GetAttribute("Rarity")
		end
	end
end

local function isAllowedDrop(drop)
	local rarity = drop:GetAttribute("Rarity")
	if not rarity or Rarities[rarity] ~= true then
		return false
	end
	local rarityHasFilters = false
	for name, r in pairs(NameFilterRarities) do
		if NameFilters[name] and r == rarity then
			rarityHasFilters = true
			break
		end
	end
	if not rarityHasFilters then
		for name, _ in pairs(NameFilters) do
			if NameFilters[name] and not NameFilterRarities[name] and drop.Name == name then
				return true
			end
		end
	end
	if rarityHasFilters then
		return NameFilters[drop.Name] == true
	end
	return true
end

local function manageIsInteractable()
	if not Drops then return end
	syncNameFilterRarities()
	for _, drop in ipairs(Drops:GetChildren()) do
		local interact = drop:FindFirstChild("IsInteractable")
		if isAllowedDrop(drop) then
			if not interact then
				local b = Instance.new("BoolValue")
				b.Name = "IsInteractable"
				b.Value = true
				b.Parent = drop
			elseif interact:IsA("BoolValue") then
				interact.Value = true
			end
		else
			if interact then interact:Destroy() end
		end
	end
end

local function isNearAllowedItem()
	if not HRP or not Drops then return false end
	for _, drop in ipairs(Drops:GetChildren()) do
		if isAllowedDrop(drop) then
			local part = drop.PrimaryPart or drop:FindFirstChildWhichIsA("BasePart")
			if part and (part.Position - HRP.Position).Magnitude <= ITEM_NEAR_DISTANCE then
				return true
			end
		end
	end
	return false
end

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

local function isNearChest()
	if not HRP then return false end
	for _, folder in ipairs(getChestFolders()) do
		for _, obj in ipairs(folder:GetDescendants()) do
			if obj.Name == "Chest" then
				local part = obj:IsA("BasePart") and obj or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
				if part and (part.Position - HRP.Position).Magnitude <= CHEST_NEAR_DISTANCE then
					return true
				end
			end
		end
	end
	return false
end

local function getNearestBoss()
	if not Monsters or not HRP then return nil, nil, math.huge end
	local best, bestRoot, bestDist = nil, nil, math.huge
	for _, m in ipairs(Monsters:GetChildren()) do
		if BossNames[m.Name] then
			local root = m:FindFirstChild("HumanoidRootPart") or m:FindFirstChildWhichIsA("BasePart")
			if root then
				local d = (root.Position - HRP.Position).Magnitude
				if d < bestDist then
					best, bestRoot, bestDist = m, root, d
				end
			end
		end
	end
	return best, bestRoot, bestDist
end

local function tpNearPart(part)
	if not part or not HRP then return false end
	HRP.CFrame = CFrame.new(part.Position + Vector3.new(0, 5, 12))
	return true
end

local function stopFunnyLock()
	orbitEnabled = false
	lockTopEnabled = false
	orbitTargetPart = nil
	orbitTargetLabel = ""
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then hum.PlatformStand = false end
	if not noclipEnabled and not flyEnabled then setNoClip(false) end
end

local function startOrbitOnPart(part, label)
	if not part then return end
	stopFunnyLock()
	orbitTargetPart = part
	orbitTargetLabel = label or "Target"
	orbitEnabled = true
	orbitAngle = 0
	setNoClip(true)
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then hum.PlatformStand = true end
end

local function startLockTopOnPart(part, label)
	if not part then return end
	stopFunnyLock()
	orbitTargetPart = part
	orbitTargetLabel = label or "Target"
	lockTopEnabled = true
	setNoClip(true)
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then hum.PlatformStand = true end
end

local function updateFunnyLock(dt)
	if not orbitTargetPart or not orbitTargetPart.Parent or not HRP then return end
	if orbitEnabled then
		orbitAngle = orbitAngle + (orbitSpeed * (dt or 0.016))
		local x = math.cos(orbitAngle) * orbitRadius
		local z = math.sin(orbitAngle) * orbitRadius
		local pos = orbitTargetPart.Position + Vector3.new(x, orbitHeight, z)
		HRP.CFrame = CFrame.new(pos, orbitTargetPart.Position)
	elseif lockTopEnabled then
		local pos = orbitTargetPart.Position + Vector3.new(0, orbitHeight, 0)
		HRP.CFrame = CFrame.new(pos, orbitTargetPart.Position + Vector3.new(0, 0, 0.1))
	end
end

RunService.Heartbeat:Connect(function(dt)
	if not running then return end
	if speedEnabled then applySpeed() end
	if noclipEnabled or flyEnabled or orbitEnabled or lockTopEnabled then setNoClip(true) end
	if flyEnabled then updateFly() end
	if orbitEnabled or lockTopEnabled then updateFunnyLock(dt) end
end)

task.spawn(function()
	while running do
		pcall(manageIsInteractable)
		if autoCollectEnabled and isNearAllowedItem() then pressE() end
		if autoChestEnabled and isNearChest() then pressE() end
		task.wait(INTERACT_LOOP_DELAY)
	end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	HRP = char:WaitForChild("HumanoidRootPart")
	task.wait(0.5)
	if speedEnabled then applySpeed() end
	if noclipEnabled or flyEnabled or orbitEnabled or lockTopEnabled then setNoClip(true) end
	if flyEnabled then startFly() end
	if orbitEnabled or lockTopEnabled then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.PlatformStand = true end
	end
end)

-- ==================== UI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HentaiHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 32)
MainFrame.Position = UDim2.new(0.5, -140, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 16, 32)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 25, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "HentaiHub V3  |  Herta"
Title.TextColor3 = Color3.fromRGB(200, 160, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 26, 0, 26)
MinBtn.Position = UDim2.new(1, -58, 0, 3)
MinBtn.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
MinBtn.Text = "–"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.Parent = TitleBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -29, 0, 3)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 110)
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
	stopFunnyLock()
	if fullBrightEnabled then disableFullBright() end
	if noclipEnabled then setNoClip(false) end
	ScreenGui:Destroy()
end)

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

local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Size = UDim2.new(0, 16, 0, 16)
ResizeHandle.Position = UDim2.new(1, -16, 1, -16)
ResizeHandle.BackgroundColor3 = Color3.fromRGB(100, 70, 170)
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
		MainFrame.Size = UDim2.new(0, math.clamp(startSize.X.Offset + delta.X, 240, 500), 0, math.clamp(startSize.Y.Offset + delta.Y, 120, 750))
	end
end)

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
	box.BackgroundColor3 = default and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
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
	label.TextColor3 = Color3.fromRGB(240, 230, 255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame
	return box, frame
end

local AutoCollectCheck, AutoCollectFrame = createCheckbox("Auto Collect (Filtered)", autoCollectEnabled)

local InfoBtn = Instance.new("TextButton")
InfoBtn.Size = UDim2.new(0, 20, 0, 20)
InfoBtn.Position = UDim2.new(1, -22, 0, 3)
InfoBtn.BackgroundColor3 = Color3.fromRGB(100, 70, 170)
InfoBtn.Text = "i"
InfoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoBtn.Font = Enum.Font.GothamBold
InfoBtn.TextSize = 12
InfoBtn.Parent = AutoCollectFrame
Instance.new("UICorner", InfoBtn).CornerRadius = UDim.new(1, 0)

local InfoPopup = Instance.new("Frame")
InfoPopup.Size = UDim2.new(0, 270, 0, 120)
InfoPopup.BackgroundColor3 = Color3.fromRGB(30, 22, 45)
InfoPopup.BorderSizePixel = 0
InfoPopup.Visible = false
InfoPopup.ZIndex = 50
InfoPopup.Parent = ScreenGui
Instance.new("UICorner", InfoPopup).CornerRadius = UDim.new(0, 8)

local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(1, -12, 1, -12)
InfoText.Position = UDim2.new(0, 6, 0, 6)
InfoText.BackgroundTransparency = 1
InfoText.TextColor3 = Color3.fromRGB(230, 220, 255)
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = 11
InfoText.TextWrapped = true
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.TextYAlignment = Enum.TextYAlignment.Top
InfoText.ZIndex = 51
InfoText.Text = "Rarities: toggle OFF a rarity so you won't collect items of that rarity.\n\nItem Filter: adding a name only filters that item's rarity. Other rarities stay fully collectable when toggled ON."
InfoText.Parent = InfoPopup

InfoBtn.MouseButton1Click:Connect(function()
	InfoPopup.Visible = not InfoPopup.Visible
	if InfoPopup.Visible then
		local abs = InfoBtn.AbsolutePosition
		InfoPopup.Position = UDim2.new(0, abs.X + 24, 0, abs.Y - 20)
	end
end)

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
	btn.TextColor3 = Color3.fromRGB(240, 230, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Parent = Content
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

local FilterBtn = createButton("Item Filter  →", Color3.fromRGB(55, 40, 80))
local FunnyBtn = createButton("Funny  →", Color3.fromRGB(180, 90, 160))
local SettingsBtn = createButton("Settings  →", Color3.fromRGB(55, 40, 80))
local HopBtn = createButton("Server Hop (1-3 Players)", Color3.fromRGB(100, 70, 170))

local rarityOpen = false
local RarityHeader = Instance.new("TextButton")
RarityHeader.Size = UDim2.new(1, 0, 0, 28)
RarityHeader.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
RarityHeader.Text = "Rarities  ▼"
RarityHeader.TextColor3 = Color3.fromRGB(240, 230, 255)
RarityHeader.Font = Enum.Font.GothamBold
RarityHeader.TextSize = 13
RarityHeader.Parent = Content
Instance.new("UICorner", RarityHeader).CornerRadius = UDim.new(0, 6)

local RarityContainer = Instance.new("Frame")
RarityContainer.Size = UDim2.new(1, 0, 0, 0)
RarityContainer.BackgroundTransparency = 1
RarityContainer.ClipsDescendants = true
RarityContainer.Parent = Content

local rarityList = {"Common", "Uncommon", "Rare", "Elite", "Legendary", "Mythic"}
for i, rarity in ipairs(rarityList) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 24)
	btn.Position = UDim2.new(0, 0, 0, (i - 1) * 26)
	btn.BackgroundColor3 = Rarities[rarity] and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(45, 35, 60)
	btn.TextColor3 = Color3.fromRGB(240, 230, 255)
	btn.Text = rarity .. (Rarities[rarity] and " ✓" or "")
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 12
	btn.Parent = RarityContainer
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
	btn.MouseButton1Click:Connect(function()
		Rarities[rarity] = not Rarities[rarity]
		btn.BackgroundColor3 = Rarities[rarity] and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(45, 35, 60)
		btn.Text = rarity .. (Rarities[rarity] and " ✓" or "")
		saveConfig()
	end)
end

RarityHeader.MouseButton1Click:Connect(function()
	rarityOpen = not rarityOpen
	RarityHeader.Text = rarityOpen and "Rarities  ▲" or "Rarities  ▼"
	RarityContainer.Size = UDim2.new(1, 0, 0, rarityOpen and 156 or 0)
end)

-- Filter Panel
local FilterPanel = Instance.new("Frame")
FilterPanel.Size = UDim2.new(0, 220, 0, 210)
FilterPanel.BackgroundColor3 = Color3.fromRGB(22, 16, 32)
FilterPanel.BorderSizePixel = 0
FilterPanel.Visible = false
FilterPanel.Parent = ScreenGui
Instance.new("UICorner", FilterPanel).CornerRadius = UDim.new(0, 10)

local FilterTitle = Instance.new("TextLabel")
FilterTitle.Size = UDim2.new(1, -10, 0, 30)
FilterTitle.Position = UDim2.new(0, 8, 0, 4)
FilterTitle.BackgroundTransparency = 1
FilterTitle.Text = "Item Filter"
FilterTitle.TextColor3 = Color3.fromRGB(200, 160, 255)
FilterTitle.Font = Enum.Font.GothamBold
FilterTitle.TextSize = 14
FilterTitle.TextXAlignment = Enum.TextXAlignment.Left
FilterTitle.Parent = FilterPanel

local FilterClose = Instance.new("TextButton")
FilterClose.Size = UDim2.new(0, 24, 0, 24)
FilterClose.Position = UDim2.new(1, -28, 0, 4)
FilterClose.BackgroundColor3 = Color3.fromRGB(200, 70, 110)
FilterClose.Text = "X"
FilterClose.TextColor3 = Color3.fromRGB(255, 255, 255)
FilterClose.Font = Enum.Font.GothamBold
FilterClose.TextSize = 12
FilterClose.Parent = FilterPanel
Instance.new("UICorner", FilterClose).CornerRadius = UDim.new(0, 5)

local NameBox = Instance.new("TextBox")
NameBox.Size = UDim2.new(1, -16, 0, 28)
NameBox.Position = UDim2.new(0, 8, 0, 38)
NameBox.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
NameBox.TextColor3 = Color3.fromRGB(240, 230, 255)
NameBox.PlaceholderText = "Item name..."
NameBox.Font = Enum.Font.Gotham
NameBox.TextSize = 13
NameBox.Parent = FilterPanel
Instance.new("UICorner", NameBox).CornerRadius = UDim.new(0, 6)

local AddBtn = Instance.new("TextButton")
AddBtn.Size = UDim2.new(1, -16, 0, 28)
AddBtn.Position = UDim2.new(0, 8, 0, 72)
AddBtn.BackgroundColor3 = Color3.fromRGB(100, 70, 170)
AddBtn.Text = "Add Filter"
AddBtn.TextColor3 = Color3.fromRGB(240, 230, 255)
AddBtn.Font = Enum.Font.GothamBold
AddBtn.TextSize = 13
AddBtn.Parent = FilterPanel
Instance.new("UICorner", AddBtn).CornerRadius = UDim.new(0, 6)

local NameListFrame = Instance.new("ScrollingFrame")
NameListFrame.Size = UDim2.new(1, -16, 1, -110)
NameListFrame.Position = UDim2.new(0, 8, 0, 108)
NameListFrame.BackgroundColor3 = Color3.fromRGB(35, 25, 50)
NameListFrame.BorderSizePixel = 0
NameListFrame.ScrollBarThickness = 4
NameListFrame.Parent = FilterPanel
Instance.new("UICorner", NameListFrame).CornerRadius = UDim.new(0, 6)

local NameListLayout = Instance.new("UIListLayout")
NameListLayout.Padding = UDim.new(0, 4)
NameListLayout.Parent = NameListFrame

-- Confirm
local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(0, 280, 0, 140)
ConfirmFrame.Position = UDim2.new(0.5, -140, 0.5, -70)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(30, 22, 45)
ConfirmFrame.BorderSizePixel = 0
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 100
ConfirmFrame.Parent = ScreenGui
Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0, 10)

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(1, -20, 0, 60)
ConfirmText.Position = UDim2.new(0, 10, 0, 12)
ConfirmText.BackgroundTransparency = 1
ConfirmText.TextColor3 = Color3.fromRGB(240, 230, 255)
ConfirmText.Font = Enum.Font.Gotham
ConfirmText.TextSize = 13
ConfirmText.TextWrapped = true
ConfirmText.ZIndex = 101
ConfirmText.Parent = ConfirmFrame

local ConfirmYes = Instance.new("TextButton")
ConfirmYes.Size = UDim2.new(0, 110, 0, 32)
ConfirmYes.Position = UDim2.new(0, 20, 1, -48)
ConfirmYes.BackgroundColor3 = Color3.fromRGB(160, 110, 255)
ConfirmYes.Text = "Confirm"
ConfirmYes.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmYes.Font = Enum.Font.GothamBold
ConfirmYes.TextSize = 13
ConfirmYes.ZIndex = 101
ConfirmYes.Parent = ConfirmFrame
Instance.new("UICorner", ConfirmYes).CornerRadius = UDim.new(0, 6)

local ConfirmNo = Instance.new("TextButton")
ConfirmNo.Size = UDim2.new(0, 110, 0, 32)
ConfirmNo.Position = UDim2.new(1, -130, 1, -48)
ConfirmNo.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
ConfirmNo.Text = "Cancel"
ConfirmNo.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmNo.Font = Enum.Font.GothamBold
ConfirmNo.TextSize = 13
ConfirmNo.ZIndex = 101
ConfirmNo.Parent = ConfirmFrame
Instance.new("UICorner", ConfirmNo).CornerRadius = UDim.new(0, 6)

local pendingAction = nil
local function askConfirm(message, onYes)
	ConfirmText.Text = message
	ConfirmFrame.Visible = true
	pendingAction = onYes
end
ConfirmYes.MouseButton1Click:Connect(function()
	ConfirmFrame.Visible = false
	if pendingAction then pendingAction() pendingAction = nil end
end)
ConfirmNo.MouseButton1Click:Connect(function()
	ConfirmFrame.Visible = false
	pendingAction = nil
end)

-- Funny Panel
local FunnyPanel = Instance.new("Frame")
FunnyPanel.Size = UDim2.new(0, 280, 0, 500)
FunnyPanel.BackgroundColor3 = Color3.fromRGB(22, 16, 32)
FunnyPanel.BorderSizePixel = 0
FunnyPanel.Visible = false
FunnyPanel.Parent = ScreenGui
Instance.new("UICorner", FunnyPanel).CornerRadius = UDim.new(0, 10)

local FunnyTitle = Instance.new("TextLabel")
FunnyTitle.Size = UDim2.new(1, -10, 0, 28)
FunnyTitle.Position = UDim2.new(0, 8, 0, 4)
FunnyTitle.BackgroundTransparency = 1
FunnyTitle.Text = "Funny  ·  Boss / Players"
FunnyTitle.TextColor3 = Color3.fromRGB(255, 160, 220)
FunnyTitle.Font = Enum.Font.GothamBold
FunnyTitle.TextSize = 14
FunnyTitle.TextXAlignment = Enum.TextXAlignment.Left
FunnyTitle.Parent = FunnyPanel

local FunnyClose = Instance.new("TextButton")
FunnyClose.Size = UDim2.new(0, 24, 0, 24)
FunnyClose.Position = UDim2.new(1, -28, 0, 4)
FunnyClose.BackgroundColor3 = Color3.fromRGB(200, 70, 110)
FunnyClose.Text = "X"
FunnyClose.TextColor3 = Color3.fromRGB(255, 255, 255)
FunnyClose.Font = Enum.Font.GothamBold
FunnyClose.TextSize = 12
FunnyClose.Parent = FunnyPanel
Instance.new("UICorner", FunnyClose).CornerRadius = UDim.new(0, 5)

local OrbitStatus = Instance.new("TextLabel")
OrbitStatus.Size = UDim2.new(1, -16, 0, 18)
OrbitStatus.Position = UDim2.new(0, 8, 0, 32)
OrbitStatus.BackgroundTransparency = 1
OrbitStatus.Text = "Lock: OFF"
OrbitStatus.TextColor3 = Color3.fromRGB(180, 160, 210)
OrbitStatus.Font = Enum.Font.Gotham
OrbitStatus.TextSize = 12
OrbitStatus.TextXAlignment = Enum.TextXAlignment.Left
OrbitStatus.Parent = FunnyPanel

local BossSection = Instance.new("TextLabel")
BossSection.Size = UDim2.new(1, -16, 0, 18)
BossSection.Position = UDim2.new(0, 8, 0, 54)
BossSection.BackgroundTransparency = 1
BossSection.Text = "Nearest Boss"
BossSection.TextColor3 = Color3.fromRGB(200, 160, 255)
BossSection.Font = Enum.Font.GothamBold
BossSection.TextSize = 12
BossSection.TextXAlignment = Enum.TextXAlignment.Left
BossSection.Parent = FunnyPanel

local NearestBossLabel = Instance.new("TextLabel")
NearestBossLabel.Size = UDim2.new(1, -16, 0, 18)
NearestBossLabel.Position = UDim2.new(0, 8, 0, 72)
NearestBossLabel.BackgroundTransparency = 1
NearestBossLabel.Text = "None nearby"
NearestBossLabel.TextColor3 = Color3.fromRGB(180, 160, 210)
NearestBossLabel.Font = Enum.Font.Gotham
NearestBossLabel.TextSize = 11
NearestBossLabel.TextXAlignment = Enum.TextXAlignment.Left
NearestBossLabel.Parent = FunnyPanel

local TpBossBtn = Instance.new("TextButton")
TpBossBtn.Size = UDim2.new(0.32, -4, 0, 28)
TpBossBtn.Position = UDim2.new(0, 8, 0, 94)
TpBossBtn.BackgroundColor3 = Color3.fromRGB(100, 70, 170)
TpBossBtn.Text = "TP"
TpBossBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TpBossBtn.Font = Enum.Font.GothamBold
TpBossBtn.TextSize = 12
TpBossBtn.Parent = FunnyPanel
Instance.new("UICorner", TpBossBtn).CornerRadius = UDim.new(0, 6)

local LockBossBtn = Instance.new("TextButton")
LockBossBtn.Size = UDim2.new(0.32, -4, 0, 28)
LockBossBtn.Position = UDim2.new(0.34, 0, 0, 94)
LockBossBtn.BackgroundColor3 = Color3.fromRGB(180, 90, 160)
LockBossBtn.Text = "Orbit"
LockBossBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LockBossBtn.Font = Enum.Font.GothamBold
LockBossBtn.TextSize = 12
LockBossBtn.Parent = FunnyPanel
Instance.new("UICorner", LockBossBtn).CornerRadius = UDim.new(0, 6)

local TopBossBtn = Instance.new("TextButton")
TopBossBtn.Size = UDim2.new(0.32, -4, 0, 28)
TopBossBtn.Position = UDim2.new(0.66, 0, 0, 94)
TopBossBtn.BackgroundColor3 = Color3.fromRGB(80, 160, 200)
TopBossBtn.Text = "Top"
TopBossBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TopBossBtn.Font = Enum.Font.GothamBold
TopBossBtn.TextSize = 12
TopBossBtn.Parent = FunnyPanel
Instance.new("UICorner", TopBossBtn).CornerRadius = UDim.new(0, 6)

TpBossBtn.MouseButton1Click:Connect(function()
	local m, root, dist = getNearestBoss()
	if not root then
		OrbitStatus.Text = "No boss found"
		OrbitStatus.TextColor3 = Color3.fromRGB(255, 120, 150)
		return
	end
	askConfirm(string.format("TP near %s?\n(%.0fm away)", m.Name, dist), function()
		if tpNearPart(root) then
			OrbitStatus.Text = "TP near: " .. m.Name
			OrbitStatus.TextColor3 = Color3.fromRGB(150, 255, 180)
		end
	end)
end)

LockBossBtn.MouseButton1Click:Connect(function()
	local m, root, dist = getNearestBoss()
	if not root then
		OrbitStatus.Text = "No boss found"
		OrbitStatus.TextColor3 = Color3.fromRGB(255, 120, 150)
		return
	end
	askConfirm(string.format("Orbit %s?\n(%.0fm away)", m.Name, dist), function()
		startOrbitOnPart(root, m.Name)
		OrbitStatus.Text = "Orbiting: " .. m.Name
		OrbitStatus.TextColor3 = Color3.fromRGB(255, 180, 220)
	end)
end)

TopBossBtn.MouseButton1Click:Connect(function()
	local m, root, dist = getNearestBoss()
	if not root then
		OrbitStatus.Text = "No boss found"
		OrbitStatus.TextColor3 = Color3.fromRGB(255, 120, 150)
		return
	end
	askConfirm(string.format("Lock TOP on %s?\nHeight: %s studs", m.Name, tostring(orbitHeight)), function()
		startLockTopOnPart(root, m.Name)
		OrbitStatus.Text = "Top lock: " .. m.Name
		OrbitStatus.TextColor3 = Color3.fromRGB(120, 200, 255)
	end)
end)

local StopOrbitBtn = Instance.new("TextButton")
StopOrbitBtn.Size = UDim2.new(1, -16, 0, 26)
StopOrbitBtn.Position = UDim2.new(0, 8, 0, 128)
StopOrbitBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 110)
StopOrbitBtn.Text = "Stop Lock"
StopOrbitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopOrbitBtn.Font = Enum.Font.GothamBold
StopOrbitBtn.TextSize = 12
StopOrbitBtn.Parent = FunnyPanel
Instance.new("UICorner", StopOrbitBtn).CornerRadius = UDim.new(0, 6)
StopOrbitBtn.MouseButton1Click:Connect(function()
	stopFunnyLock()
	OrbitStatus.Text = "Lock: OFF"
	OrbitStatus.TextColor3 = Color3.fromRGB(180, 160, 210)
end)

local PlayerSection = Instance.new("TextLabel")
PlayerSection.Size = UDim2.new(1, -16, 0, 18)
PlayerSection.Position = UDim2.new(0, 8, 0, 162)
PlayerSection.BackgroundTransparency = 1
PlayerSection.Text = "Players (confirm TP / Orbit / Top)"
PlayerSection.TextColor3 = Color3.fromRGB(200, 160, 255)
PlayerSection.Font = Enum.Font.GothamBold
PlayerSection.TextSize = 12
PlayerSection.TextXAlignment = Enum.TextXAlignment.Left
PlayerSection.Parent = FunnyPanel

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1, -16, 0, 150)
PlayerScroll.Position = UDim2.new(0, 8, 0, 182)
PlayerScroll.BackgroundColor3 = Color3.fromRGB(35, 25, 50)
PlayerScroll.BorderSizePixel = 0
PlayerScroll.ScrollBarThickness = 4
PlayerScroll.Parent = FunnyPanel
Instance.new("UICorner", PlayerScroll).CornerRadius = UDim.new(0, 6)

local PlayerLayout = Instance.new("UIListLayout")
PlayerLayout.Padding = UDim.new(0, 4)
PlayerLayout.Parent = PlayerScroll

local function refreshPlayerList()
	for _, c in ipairs(PlayerScroll:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end
	local count = 0
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr == LocalPlayer then continue end
		count += 1
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, -6, 0, 28)
		row.BackgroundTransparency = 1
		row.Parent = PlayerScroll

		local nameLbl = Instance.new("TextLabel")
		nameLbl.Size = UDim2.new(0.34, 0, 1, 0)
		nameLbl.BackgroundTransparency = 1
		nameLbl.Text = plr.DisplayName ~= plr.Name and plr.DisplayName or plr.Name
		nameLbl.TextColor3 = Color3.fromRGB(240, 230, 255)
		nameLbl.Font = Enum.Font.Gotham
		nameLbl.TextSize = 11
		nameLbl.TextXAlignment = Enum.TextXAlignment.Left
		nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
		nameLbl.Parent = row

		local tpBtn = Instance.new("TextButton")
		tpBtn.Size = UDim2.new(0, 36, 0, 24)
		tpBtn.Position = UDim2.new(0.36, 0, 0, 2)
		tpBtn.BackgroundColor3 = Color3.fromRGB(100, 70, 170)
		tpBtn.Text = "TP"
		tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		tpBtn.Font = Enum.Font.GothamBold
		tpBtn.TextSize = 10
		tpBtn.Parent = row
		Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 4)

		local lockBtn = Instance.new("TextButton")
		lockBtn.Size = UDim2.new(0, 42, 0, 24)
		lockBtn.Position = UDim2.new(0.52, 0, 0, 2)
		lockBtn.BackgroundColor3 = Color3.fromRGB(180, 90, 160)
		lockBtn.Text = "Orbit"
		lockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		lockBtn.Font = Enum.Font.GothamBold
		lockBtn.TextSize = 10
		lockBtn.Parent = row
		Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 4)

		local topBtn = Instance.new("TextButton")
		topBtn.Size = UDim2.new(0, 36, 0, 24)
		topBtn.Position = UDim2.new(0.72, 0, 0, 2)
		topBtn.BackgroundColor3 = Color3.fromRGB(80, 160, 200)
		topBtn.Text = "Top"
		topBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		topBtn.Font = Enum.Font.GothamBold
		topBtn.TextSize = 10
		topBtn.Parent = row
		Instance.new("UICorner", topBtn).CornerRadius = UDim.new(0, 4)

		tpBtn.MouseButton1Click:Connect(function()
			local char = plr.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if not root then
				OrbitStatus.Text = "Player has no character"
				OrbitStatus.TextColor3 = Color3.fromRGB(255, 120, 150)
				return
			end
			askConfirm("TP near " .. (plr.DisplayName or plr.Name) .. "?", function()
				if tpNearPart(root) then
					OrbitStatus.Text = "TP near: " .. plr.Name
					OrbitStatus.TextColor3 = Color3.fromRGB(150, 255, 180)
				end
			end)
		end)

		lockBtn.MouseButton1Click:Connect(function()
			local char = plr.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if not root then
				OrbitStatus.Text = "Player has no character"
				OrbitStatus.TextColor3 = Color3.fromRGB(255, 120, 150)
				return
			end
			askConfirm("Orbit " .. (plr.DisplayName or plr.Name) .. "?", function()
				startOrbitOnPart(root, plr.Name)
				OrbitStatus.Text = "Orbiting: " .. plr.Name
				OrbitStatus.TextColor3 = Color3.fromRGB(255, 180, 220)
			end)
		end)

		topBtn.MouseButton1Click:Connect(function()
			local char = plr.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if not root then
				OrbitStatus.Text = "Player has no character"
				OrbitStatus.TextColor3 = Color3.fromRGB(255, 120, 150)
				return
			end
			askConfirm("Lock TOP on " .. (plr.DisplayName or plr.Name) .. "?", function()
				startLockTopOnPart(root, plr.Name)
				OrbitStatus.Text = "Top lock: " .. plr.Name
				OrbitStatus.TextColor3 = Color3.fromRGB(120, 200, 255)
			end)
		end)
	end
	PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, count * 32)
end

local RadiusLabel = Instance.new("TextLabel")
RadiusLabel.Size = UDim2.new(0.48, -6, 0, 14)
RadiusLabel.Position = UDim2.new(0, 8, 0, 340)
RadiusLabel.BackgroundTransparency = 1
RadiusLabel.Text = "Orbit Radius:"
RadiusLabel.TextColor3 = Color3.fromRGB(180, 160, 210)
RadiusLabel.Font = Enum.Font.Gotham
RadiusLabel.TextSize = 11
RadiusLabel.TextXAlignment = Enum.TextXAlignment.Left
RadiusLabel.Parent = FunnyPanel

local RadiusBox = Instance.new("TextBox")
RadiusBox.Size = UDim2.new(0.48, -6, 0, 26)
RadiusBox.Position = UDim2.new(0, 8, 0, 356)
RadiusBox.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
RadiusBox.TextColor3 = Color3.fromRGB(240, 230, 255)
RadiusBox.Text = tostring(orbitRadius)
RadiusBox.Font = Enum.Font.Gotham
RadiusBox.TextSize = 13
RadiusBox.Parent = FunnyPanel
Instance.new("UICorner", RadiusBox).CornerRadius = UDim.new(0, 5)

local SpeedOrbitLabel = Instance.new("TextLabel")
SpeedOrbitLabel.Size = UDim2.new(0.48, -6, 0, 14)
SpeedOrbitLabel.Position = UDim2.new(0.52, 0, 0, 340)
SpeedOrbitLabel.BackgroundTransparency = 1
SpeedOrbitLabel.Text = "Spin Speed:"
SpeedOrbitLabel.TextColor3 = Color3.fromRGB(180, 160, 210)
SpeedOrbitLabel.Font = Enum.Font.Gotham
SpeedOrbitLabel.TextSize = 11
SpeedOrbitLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedOrbitLabel.Parent = FunnyPanel

local SpeedOrbitBox = Instance.new("TextBox")
SpeedOrbitBox.Size = UDim2.new(0.48, -6, 0, 26)
SpeedOrbitBox.Position = UDim2.new(0.52, 0, 0, 356)
SpeedOrbitBox.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
SpeedOrbitBox.TextColor3 = Color3.fromRGB(240, 230, 255)
SpeedOrbitBox.Text = tostring(orbitSpeed)
SpeedOrbitBox.Font = Enum.Font.Gotham
SpeedOrbitBox.TextSize = 13
SpeedOrbitBox.Parent = FunnyPanel
Instance.new("UICorner", SpeedOrbitBox).CornerRadius = UDim.new(0, 5)

local HeightLabel = Instance.new("TextLabel")
HeightLabel.Size = UDim2.new(1, -16, 0, 14)
HeightLabel.Position = UDim2.new(0, 8, 0, 388)
HeightLabel.BackgroundTransparency = 1
HeightLabel.Text = "Top / Orbit Height (studs):"
HeightLabel.TextColor3 = Color3.fromRGB(180, 160, 210)
HeightLabel.Font = Enum.Font.Gotham
HeightLabel.TextSize = 11
HeightLabel.TextXAlignment = Enum.TextXAlignment.Left
HeightLabel.Parent = FunnyPanel

local HeightBox = Instance.new("TextBox")
HeightBox.Size = UDim2.new(1, -16, 0, 26)
HeightBox.Position = UDim2.new(0, 8, 0, 404)
HeightBox.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
HeightBox.TextColor3 = Color3.fromRGB(240, 230, 255)
HeightBox.Text = tostring(orbitHeight)
HeightBox.Font = Enum.Font.Gotham
HeightBox.TextSize = 13
HeightBox.Parent = FunnyPanel
Instance.new("UICorner", HeightBox).CornerRadius = UDim.new(0, 5)

local RefreshPlayersBtn = Instance.new("TextButton")
RefreshPlayersBtn.Size = UDim2.new(1, -16, 0, 26)
RefreshPlayersBtn.Position = UDim2.new(0, 8, 0, 438)
RefreshPlayersBtn.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
RefreshPlayersBtn.Text = "Refresh Player List"
RefreshPlayersBtn.TextColor3 = Color3.fromRGB(240, 230, 255)
RefreshPlayersBtn.Font = Enum.Font.GothamBold
RefreshPlayersBtn.TextSize = 12
RefreshPlayersBtn.Parent = FunnyPanel
Instance.new("UICorner", RefreshPlayersBtn).CornerRadius = UDim.new(0, 6)
RefreshPlayersBtn.MouseButton1Click:Connect(refreshPlayerList)

RadiusBox.FocusLost:Connect(function()
	local n = tonumber(RadiusBox.Text)
	if n and n >= 3 then
		orbitRadius = n
		RadiusBox.Text = tostring(orbitRadius)
		saveConfig()
	else
		RadiusBox.Text = tostring(orbitRadius)
	end
end)
SpeedOrbitBox.FocusLost:Connect(function()
	local n = tonumber(SpeedOrbitBox.Text)
	if n and n > 0 then
		orbitSpeed = n
		SpeedOrbitBox.Text = tostring(orbitSpeed)
		saveConfig()
	else
		SpeedOrbitBox.Text = tostring(orbitSpeed)
	end
end)
HeightBox.FocusLost:Connect(function()
	local n = tonumber(HeightBox.Text)
	if n and n >= 2 then
		orbitHeight = n
		HeightBox.Text = tostring(orbitHeight)
		saveConfig()
	else
		HeightBox.Text = tostring(orbitHeight)
	end
end)

task.spawn(function()
	while running do
		if funnyOpen then
			local m, root, dist = getNearestBoss()
			if m then
				NearestBossLabel.Text = string.format("%s  (%.0fm)", m.Name, dist)
				NearestBossLabel.TextColor3 = Color3.fromRGB(150, 255, 180)
			else
				NearestBossLabel.Text = "None nearby"
				NearestBossLabel.TextColor3 = Color3.fromRGB(180, 160, 210)
			end
		end
		task.wait(0.5)
	end
end)

-- Settings (taller for alert controls)
local SettingsPanel = Instance.new("Frame")
SettingsPanel.Size = UDim2.new(0, 250, 0, 520)
SettingsPanel.BackgroundColor3 = Color3.fromRGB(22, 16, 32)
SettingsPanel.BorderSizePixel = 0
SettingsPanel.Visible = false
SettingsPanel.Parent = ScreenGui
Instance.new("UICorner", SettingsPanel).CornerRadius = UDim.new(0, 10)

local SetTitle = Instance.new("TextLabel")
SetTitle.Size = UDim2.new(1, -10, 0, 30)
SetTitle.Position = UDim2.new(0, 8, 0, 4)
SetTitle.BackgroundTransparency = 1
SetTitle.Text = "Settings"
SetTitle.TextColor3 = Color3.fromRGB(200, 160, 255)
SetTitle.Font = Enum.Font.GothamBold
SetTitle.TextSize = 14
SetTitle.TextXAlignment = Enum.TextXAlignment.Left
SetTitle.Parent = SettingsPanel

local SetClose = Instance.new("TextButton")
SetClose.Size = UDim2.new(0, 24, 0, 24)
SetClose.Position = UDim2.new(1, -28, 0, 4)
SetClose.BackgroundColor3 = Color3.fromRGB(200, 70, 110)
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
SpeedLabel.TextColor3 = Color3.fromRGB(180, 160, 210)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 12
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = SettingsPanel

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(1, -20, 0, 28)
SpeedBox.Position = UDim2.new(0, 10, 0, 58)
SpeedBox.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
SpeedBox.TextColor3 = Color3.fromRGB(240, 230, 255)
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
FlySpeedLabel.TextColor3 = Color3.fromRGB(180, 160, 210)
FlySpeedLabel.Font = Enum.Font.Gotham
FlySpeedLabel.TextSize = 12
FlySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
FlySpeedLabel.Parent = SettingsPanel

local FlySpeedBox = Instance.new("TextBox")
FlySpeedBox.Size = UDim2.new(1, -20, 0, 28)
FlySpeedBox.Position = UDim2.new(0, 10, 0, 112)
FlySpeedBox.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
FlySpeedBox.TextColor3 = Color3.fromRGB(240, 230, 255)
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
KeyLabel.TextColor3 = Color3.fromRGB(180, 160, 210)
KeyLabel.Font = Enum.Font.Gotham
KeyLabel.TextSize = 12
KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
KeyLabel.Parent = SettingsPanel

local SpeedKeyBtn = Instance.new("TextButton")
SpeedKeyBtn.Size = UDim2.new(1, -20, 0, 28)
SpeedKeyBtn.Position = UDim2.new(0, 10, 0, 170)
SpeedKeyBtn.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
SpeedKeyBtn.Text = "Speed Key: " .. SpeedKey.Name
SpeedKeyBtn.TextColor3 = Color3.fromRGB(240, 230, 255)
SpeedKeyBtn.Font = Enum.Font.GothamBold
SpeedKeyBtn.TextSize = 13
SpeedKeyBtn.Parent = SettingsPanel
Instance.new("UICorner", SpeedKeyBtn).CornerRadius = UDim.new(0, 6)

local FlyKeyBtn = Instance.new("TextButton")
FlyKeyBtn.Size = UDim2.new(1, -20, 0, 28)
FlyKeyBtn.Position = UDim2.new(0, 10, 0, 206)
FlyKeyBtn.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
FlyKeyBtn.Text = "Fly Key: " .. FlyKey.Name
FlyKeyBtn.TextColor3 = Color3.fromRGB(240, 230, 255)
FlyKeyBtn.Font = Enum.Font.GothamBold
FlyKeyBtn.TextSize = 13
FlyKeyBtn.Parent = SettingsPanel
Instance.new("UICorner", FlyKeyBtn).CornerRadius = UDim.new(0, 6)

local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Size = UDim2.new(1, -20, 0, 28)
NoclipToggle.Position = UDim2.new(0, 10, 0, 244)
NoclipToggle.BackgroundColor3 = noclipEnabled and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
NoclipToggle.Text = noclipEnabled and "NoClip: ON" or "NoClip: OFF"
NoclipToggle.TextColor3 = Color3.fromRGB(240, 230, 255)
NoclipToggle.Font = Enum.Font.GothamBold
NoclipToggle.TextSize = 13
NoclipToggle.Parent = SettingsPanel
Instance.new("UICorner", NoclipToggle).CornerRadius = UDim.new(0, 6)

local RgbToggle = Instance.new("TextButton")
RgbToggle.Size = UDim2.new(1, -20, 0, 28)
RgbToggle.Position = UDim2.new(0, 10, 0, 280)
RgbToggle.BackgroundColor3 = rgbOutline and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
RgbToggle.Text = rgbOutline and "RGB Outline: ON" or "RGB Outline: OFF"
RgbToggle.TextColor3 = Color3.fromRGB(240, 230, 255)
RgbToggle.Font = Enum.Font.GothamBold
RgbToggle.TextSize = 13
RgbToggle.Parent = SettingsPanel
Instance.new("UICorner", RgbToggle).CornerRadius = UDim.new(0, 6)

local AutoChestToggle = Instance.new("TextButton")
AutoChestToggle.Size = UDim2.new(1, -20, 0, 28)
AutoChestToggle.Position = UDim2.new(0, 10, 0, 316)
AutoChestToggle.BackgroundColor3 = autoChestEnabled and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
AutoChestToggle.Text = autoChestEnabled and "Auto Open Chest: ON" or "Auto Open Chest: OFF"
AutoChestToggle.TextColor3 = Color3.fromRGB(240, 230, 255)
AutoChestToggle.Font = Enum.Font.GothamBold
AutoChestToggle.TextSize = 13
AutoChestToggle.Parent = SettingsPanel
Instance.new("UICorner", AutoChestToggle).CornerRadius = UDim.new(0, 6)

-- L/M Drop Alert
local AlertToggle = Instance.new("TextButton")
AlertToggle.Size = UDim2.new(1, -20, 0, 28)
AlertToggle.Position = UDim2.new(0, 10, 0, 352)
AlertToggle.BackgroundColor3 = alertEnabled and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
AlertToggle.Text = alertEnabled and "L/M Drop Alert: ON" or "L/M Drop Alert: OFF"
AlertToggle.TextColor3 = Color3.fromRGB(240, 230, 255)
AlertToggle.Font = Enum.Font.GothamBold
AlertToggle.TextSize = 13
AlertToggle.Parent = SettingsPanel
Instance.new("UICorner", AlertToggle).CornerRadius = UDim.new(0, 6)

local SoundIdLabel = Instance.new("TextLabel")
SoundIdLabel.Size = UDim2.new(1, -20, 0, 16)
SoundIdLabel.Position = UDim2.new(0, 10, 0, 386)
SoundIdLabel.BackgroundTransparency = 1
SoundIdLabel.Text = "Alert Sound ID:"
SoundIdLabel.TextColor3 = Color3.fromRGB(180, 160, 210)
SoundIdLabel.Font = Enum.Font.Gotham
SoundIdLabel.TextSize = 11
SoundIdLabel.TextXAlignment = Enum.TextXAlignment.Left
SoundIdLabel.Parent = SettingsPanel

local SoundIdBox = Instance.new("TextBox")
SoundIdBox.Size = UDim2.new(1, -20, 0, 26)
SoundIdBox.Position = UDim2.new(0, 10, 0, 404)
SoundIdBox.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
SoundIdBox.TextColor3 = Color3.fromRGB(240, 230, 255)
SoundIdBox.Text = alertSoundId
SoundIdBox.Font = Enum.Font.Gotham
SoundIdBox.TextSize = 11
SoundIdBox.ClearTextOnFocus = false
SoundIdBox.Parent = SettingsPanel
Instance.new("UICorner", SoundIdBox).CornerRadius = UDim.new(0, 6)

local VolumeLabel = Instance.new("TextLabel")
VolumeLabel.Size = UDim2.new(1, -20, 0, 16)
VolumeLabel.Position = UDim2.new(0, 10, 0, 436)
VolumeLabel.BackgroundTransparency = 1
VolumeLabel.Text = "Alert Volume (0–100):"
VolumeLabel.TextColor3 = Color3.fromRGB(180, 160, 210)
VolumeLabel.Font = Enum.Font.Gotham
VolumeLabel.TextSize = 11
VolumeLabel.TextXAlignment = Enum.TextXAlignment.Left
VolumeLabel.Parent = SettingsPanel

local VolumeBox = Instance.new("TextBox")
VolumeBox.Size = UDim2.new(1, -20, 0, 26)
VolumeBox.Position = UDim2.new(0, 10, 0, 454)
VolumeBox.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
VolumeBox.TextColor3 = Color3.fromRGB(240, 230, 255)
VolumeBox.Text = tostring(alertVolume)
VolumeBox.Font = Enum.Font.Gotham
VolumeBox.TextSize = 13
VolumeBox.Parent = SettingsPanel
Instance.new("UICorner", VolumeBox).CornerRadius = UDim.new(0, 6)

local TestAlertBtn = Instance.new("TextButton")
TestAlertBtn.Size = UDim2.new(1, -20, 0, 26)
TestAlertBtn.Position = UDim2.new(0, 10, 0, 488)
TestAlertBtn.BackgroundColor3 = Color3.fromRGB(100, 70, 170)
TestAlertBtn.Text = "Test Alert Sound"
TestAlertBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TestAlertBtn.Font = Enum.Font.GothamBold
TestAlertBtn.TextSize = 12
TestAlertBtn.Parent = SettingsPanel
Instance.new("UICorner", TestAlertBtn).CornerRadius = UDim.new(0, 6)

AlertToggle.MouseButton1Click:Connect(function()
	alertEnabled = not alertEnabled
	AlertToggle.Text = alertEnabled and "L/M Drop Alert: ON" or "L/M Drop Alert: OFF"
	AlertToggle.BackgroundColor3 = alertEnabled and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
	saveConfig()
end)

SoundIdBox.FocusLost:Connect(function()
	local t = SoundIdBox.Text:gsub("%s+", "")
	if t ~= "" then
		if not t:find("rbxassetid://") and tonumber(t) then
			t = "rbxassetid://" .. t
		end
		alertSoundId = t
		SoundIdBox.Text = alertSoundId
		saveConfig()
	else
		SoundIdBox.Text = alertSoundId
	end
end)

VolumeBox.FocusLost:Connect(function()
	local n = tonumber(VolumeBox.Text)
	if n and n >= 0 and n <= 100 then
		alertVolume = n
		VolumeBox.Text = tostring(alertVolume)
		saveConfig()
	else
		VolumeBox.Text = tostring(alertVolume)
	end
end)

TestAlertBtn.MouseButton1Click:Connect(function()
	playDropAlert("Test Item", "Legendary")
end)

local waitingForKey = nil
local function startKeyChange(which)
	waitingForKey = which
	if which == "Speed" then
		SpeedKeyBtn.Text = "Press any key..."
		SpeedKeyBtn.BackgroundColor3 = Color3.fromRGB(100, 70, 170)
	else
		FlyKeyBtn.Text = "Press any key..."
		FlyKeyBtn.BackgroundColor3 = Color3.fromRGB(100, 70, 170)
	end
end
SpeedKeyBtn.MouseButton1Click:Connect(function() startKeyChange("Speed") end)
FlyKeyBtn.MouseButton1Click:Connect(function() startKeyChange("Fly") end)

UserInputService.InputBegan:Connect(function(input, gp)
	if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
		if waitingForKey == "Speed" then
			SpeedKey = input.KeyCode
			SpeedKeyBtn.Text = "Speed Key: " .. SpeedKey.Name
			SpeedKeyBtn.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
		else
			FlyKey = input.KeyCode
			FlyKeyBtn.Text = "Fly Key: " .. FlyKey.Name
			FlyKeyBtn.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
		end
		waitingForKey = nil
		saveConfig()
		return
	end
	if gp or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	if input.KeyCode == SpeedKey then
		speedEnabled = not speedEnabled
		SpeedCheck.Text = speedEnabled and "✓" or ""
		SpeedCheck.BackgroundColor3 = speedEnabled and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
		if speedEnabled then applySpeed() else
			local char = LocalPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = 16 end
		end
		saveConfig()
	elseif input.KeyCode == FlyKey then
		flyEnabled = not flyEnabled
		FlyCheck.Text = flyEnabled and "✓" or ""
		FlyCheck.BackgroundColor3 = flyEnabled and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
		if flyEnabled then
			startFly()
			NoclipToggle.Text = "NoClip: ON"
			NoclipToggle.BackgroundColor3 = Color3.fromRGB(160, 110, 255)
		else
			stopFly()
		end
		saveConfig()
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
	NoclipToggle.BackgroundColor3 = noclipEnabled and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
	setNoClip(noclipEnabled)
	saveConfig()
end)
RgbToggle.MouseButton1Click:Connect(function()
	rgbOutline = not rgbOutline
	RgbToggle.Text = rgbOutline and "RGB Outline: ON" or "RGB Outline: OFF"
	RgbToggle.BackgroundColor3 = rgbOutline and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
	saveConfig()
end)
AutoChestToggle.MouseButton1Click:Connect(function()
	autoChestEnabled = not autoChestEnabled
	AutoChestToggle.Text = autoChestEnabled and "Auto Open Chest: ON" or "Auto Open Chest: OFF"
	AutoChestToggle.BackgroundColor3 = autoChestEnabled and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
	saveConfig()
end)

local function updateSidePanels()
	local p = MainFrame.AbsolutePosition
	local s = MainFrame.AbsoluteSize
	FilterPanel.Position = UDim2.new(0, p.X + s.X + 8, 0, p.Y + 40)
	FunnyPanel.Position = UDim2.new(0, p.X + s.X + 8, 0, p.Y)
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
FunnyBtn.MouseButton1Click:Connect(function()
	funnyOpen = not funnyOpen
	FunnyPanel.Visible = funnyOpen
	FunnyBtn.Text = funnyOpen and "Funny  ←" or "Funny  →"
	if funnyOpen then
		RadiusBox.Text = tostring(orbitRadius)
		SpeedOrbitBox.Text = tostring(orbitSpeed)
		HeightBox.Text = tostring(orbitHeight)
		refreshPlayerList()
		updateSidePanels()
	end
end)
FunnyClose.MouseButton1Click:Connect(function()
	funnyOpen = false
	FunnyPanel.Visible = false
	FunnyBtn.Text = "Funny  →"
end)
SettingsBtn.MouseButton1Click:Connect(function()
	settingsOpen = not settingsOpen
	SettingsPanel.Visible = settingsOpen
	SettingsBtn.Text = settingsOpen and "Settings  ←" or "Settings  →"
	if settingsOpen then
		SpeedBox.Text = tostring(customSpeed)
		FlySpeedBox.Text = tostring(flySpeed)
		SoundIdBox.Text = alertSoundId
		VolumeBox.Text = tostring(alertVolume)
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

local function updateSize()
	if minimized then
		MainFrame.Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 32)
		Content.Visible = false
		ResizeHandle.Visible = false
		FilterPanel.Visible = false
		FunnyPanel.Visible = false
		SettingsPanel.Visible = false
		InfoPopup.Visible = false
		ConfirmFrame.Visible = false
	else
		Content.Visible = true
		ResizeHandle.Visible = true
		if MainFrame.Size.Y.Offset < 150 then
			MainFrame.Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 520)
		end
	end
end

MinBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	MinBtn.Text = minimized and "+" or "–"
	updateSize()
end)

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
		btn.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
		btn.TextColor3 = Color3.fromRGB(220, 180, 255)
		local r = NameFilterRarities[name]
		btn.Text = r and (name .. " [" .. r .. "]  X") or (name .. "  X")
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 12
		btn.Parent = NameListFrame
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
		btn.MouseButton1Click:Connect(function()
			NameFilters[name] = nil
			NameFilterRarities[name] = nil
			refreshNameList()
			saveConfig()
		end)
	end
	NameListFrame.CanvasSize = UDim2.new(0, 0, 0, count * 26)
end

AddBtn.MouseButton1Click:Connect(function()
	local text = NameBox.Text
	local corrected = findBestMatch(text)
	local finalName = corrected or (text:gsub("%s", "") ~= "" and text or nil)
	if finalName then
		NameFilters[finalName] = true
		local foundRarity = nil
		if Drops then
			for _, drop in ipairs(Drops:GetChildren()) do
				if drop.Name == finalName then
					foundRarity = drop:GetAttribute("Rarity")
					break
				end
			end
		end
		NameFilterRarities[finalName] = foundRarity
		NameBox.Text = ""
		refreshNameList()
		saveConfig()
	end
end)
refreshNameList()

AutoCollectCheck.MouseButton1Click:Connect(function()
	autoCollectEnabled = not autoCollectEnabled
	AutoCollectCheck.Text = autoCollectEnabled and "✓" or ""
	AutoCollectCheck.BackgroundColor3 = autoCollectEnabled and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
	saveConfig()
end)
ChestEspCheck.MouseButton1Click:Connect(function()
	chestEspEnabled = not chestEspEnabled
	ChestEspCheck.Text = chestEspEnabled and "✓" or ""
	ChestEspCheck.BackgroundColor3 = chestEspEnabled and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
	saveConfig()
end)
PlayerEspCheck.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	PlayerEspCheck.Text = espEnabled and "✓" or ""
	PlayerEspCheck.BackgroundColor3 = espEnabled and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
	saveConfig()
end)
BossEspCheck.MouseButton1Click:Connect(function()
	bossEspEnabled = not bossEspEnabled
	BossEspCheck.Text = bossEspEnabled and "✓" or ""
	BossEspCheck.BackgroundColor3 = bossEspEnabled and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
	saveConfig()
end)
BrightCheck.MouseButton1Click:Connect(function()
	fullBrightEnabled = not fullBrightEnabled
	BrightCheck.Text = fullBrightEnabled and "✓" or ""
	BrightCheck.BackgroundColor3 = fullBrightEnabled and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
	if fullBrightEnabled then enableFullBright() else disableFullBright() end
	saveConfig()
end)
SpeedCheck.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	SpeedCheck.Text = speedEnabled and "✓" or ""
	SpeedCheck.BackgroundColor3 = speedEnabled and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
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
	FlyCheck.BackgroundColor3 = flyEnabled and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
	if flyEnabled then
		startFly()
		NoclipToggle.Text = "NoClip: ON"
		NoclipToggle.BackgroundColor3 = Color3.fromRGB(160, 110, 255)
	else
		stopFly()
	end
	saveConfig()
end)
HopBtn.MouseButton1Click:Connect(smartServerHop)

-- ESP (same as before)
local espFolder = Instance.new("Folder", ScreenGui)
espFolder.Name = "PlayerESP"
local espObjects = {}

local function createEsp(player)
	if player == LocalPlayer then return end
	local highlight = Instance.new("Highlight")
	highlight.FillColor = Color3.fromRGB(160, 110, 255)
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
				data.infoLabel.TextColor3 = ratio > 0.6 and Color3.fromRGB(0, 255, 100) or ratio > 0.3 and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 60, 60)
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

local itemEspFolder = Instance.new("Folder", ScreenGui)
itemEspFolder.Name = "ItemESP"
local itemEspObjects = {}

local function updateItemEsp()
	if not autoCollectEnabled or not Drops then
		for _, obj in pairs(itemEspObjects) do
			if obj then obj.Enabled = false end
		end
		return
	end
	for _, drop in ipairs(Drops:GetChildren()) do
		if drop.Name:lower():find("chest") then continue end
		if isAllowedDrop(drop) then
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

local chestEspFolder = Instance.new("Folder", ScreenGui)
chestEspFolder.Name = "ChestESP"
local chestEspObjects = {}

local function updateChestEsp()
	if not chestEspEnabled then
		for _, obj in pairs(chestEspObjects) do
			if obj.billboard then obj.billboard.Enabled = false end
			if obj.highlight then obj.highlight.Enabled = false end
		end
		return
	end
	for _, folder in ipairs(getChestFolders()) do
		for _, obj in ipairs(folder:GetDescendants()) do
			if obj.Name == "Chest" then
				local part = obj:IsA("BasePart") and obj or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
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
					chestEspObjects[obj] = {billboard = billboard, label = label, highlight = highlight}
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
		if not obj or not obj.Parent then
			if data.billboard then data.billboard:Destroy() end
			if data.highlight then data.highlight:Destroy() end
			chestEspObjects[obj] = nil
		end
	end
end

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
		if espEnabled then
			for _, obj in pairs(espObjects) do
				if obj.highlight and obj.highlight.Enabled then
					obj.highlight.OutlineColor = color
					obj.highlight.FillColor = color
				end
			end
		end
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

task.spawn(function()
	task.wait(1)
	if autoCollectEnabled then
		AutoCollectCheck.Text = "✓"
		AutoCollectCheck.BackgroundColor3 = Color3.fromRGB(160, 110, 255)
	end
	if chestEspEnabled then
		ChestEspCheck.Text = "✓"
		ChestEspCheck.BackgroundColor3 = Color3.fromRGB(160, 110, 255)
	end
	if fullBrightEnabled then
		BrightCheck.Text = "✓"
		BrightCheck.BackgroundColor3 = Color3.fromRGB(160, 110, 255)
		enableFullBright()
	end
	if espEnabled then
		PlayerEspCheck.Text = "✓"
		PlayerEspCheck.BackgroundColor3 = Color3.fromRGB(160, 110, 255)
	end
	if bossEspEnabled then
		BossEspCheck.Text = "✓"
		BossEspCheck.BackgroundColor3 = Color3.fromRGB(160, 110, 255)
	end
	if speedEnabled then
		SpeedCheck.Text = "✓"
		SpeedCheck.BackgroundColor3 = Color3.fromRGB(160, 110, 255)
		applySpeed()
	end
	if flyEnabled then
		FlyCheck.Text = "✓"
		FlyCheck.BackgroundColor3 = Color3.fromRGB(160, 110, 255)
		startFly()
		NoclipToggle.Text = "NoClip: ON"
		NoclipToggle.BackgroundColor3 = Color3.fromRGB(160, 110, 255)
	end
	if noclipEnabled then
		NoclipToggle.Text = "NoClip: ON"
		NoclipToggle.BackgroundColor3 = Color3.fromRGB(160, 110, 255)
		setNoClip(true)
	end
	if rgbOutline then
		RgbToggle.Text = "RGB Outline: ON"
		RgbToggle.BackgroundColor3 = Color3.fromRGB(160, 110, 255)
	end
	if autoChestEnabled then
		AutoChestToggle.Text = "Auto Open Chest: ON"
		AutoChestToggle.BackgroundColor3 = Color3.fromRGB(160, 110, 255)
	end
	if alertEnabled then
		AlertToggle.Text = "L/M Drop Alert: ON"
		AlertToggle.BackgroundColor3 = Color3.fromRGB(160, 110, 255)
	end
	SoundIdBox.Text = alertSoundId
	VolumeBox.Text = tostring(alertVolume)
end)

updateSize()
print("[HentaiHub V3] Loaded | L/M Drop Alert + Funny TP/Orbit/Top + Independent filter")
