------------------ CONFIG ------------------
local ALLOWED_RARITIES = {
	["Common"] = false,
	["Uncommon"] = true,
	["Rare"] = false,
	["Epic"] = true,
	["Legendary"] = true,
}

local UNCOMMON_ONLY = {
	["Idol of Hatred"] = true,
	["Stone Accord"] = true,
}

local TP_DELAY = 0.15
local CHECK_DELAY = 0.3
local SPAM_DELAY = 0.05
--------------------------------------------

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Drops = workspace:WaitForChild("Drops")

local enabled = false
local spamming = false

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 160, 0, 45)
ToggleBtn.Position = UDim2.new(0.5, -80, 0.05, 0) -- Top center
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "Auto Farm: OFF"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 16
ToggleBtn.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleBtn

-- Dragging
local dragging = false
local dragStart = nil
local startPos = nil

ToggleBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = ToggleBtn.Position
	end
end)

ToggleBtn.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		ToggleBtn.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

local function tpTo(part)
	if HRP and part then
		HRP.CFrame = part.CFrame + Vector3.new(0, 3, 0)
	end
end

local function spamE()
	task.spawn(function()
		while spamming do
			pcall(function()
				VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
				task.wait(0.03)
				VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
			end)
			task.wait(SPAM_DELAY)
		end
	end)
end

-- Button Toggle
ToggleBtn.MouseButton1Click:Connect(function()
	enabled = not enabled
	spamming = enabled

	if enabled then
		ToggleBtn.Text = "Auto Farm: ON"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
		print("ON")
		spamE()
	else
		ToggleBtn.Text = "Auto Farm: OFF"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		print("OFF")
	end
end)

-- Auto TP Loop
task.spawn(function()
	while true do
		if enabled then
			Character = LocalPlayer.Character
			if Character then
				HRP = Character:FindFirstChild("HumanoidRootPart")
			end

			if HRP and HRP.Parent then
				for _, drop in ipairs(Drops:GetChildren()) do
					local rarity = drop:GetAttribute("Rarity")
					local name = drop.Name

					if rarity and ALLOWED_RARITIES[rarity] then
						if rarity == "Uncommon" and not UNCOMMON_ONLY[name] then
							continue
						end

						local part = drop:FindFirstChildWhichIsA("BasePart") or drop.PrimaryPart
						if part then
							tpTo(part)
							task.wait(TP_DELAY)
						end
					end
				end
			end
		end
		task.wait(CHECK_DELAY)
	end
end)

print("[Script] UI Loaded - Button is at the top")