-- HealthBarUI.lua
-- Client script to display player health bar
-- Place in StarterPlayer > StarterPlayerScripts

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for RemoteEvents
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local HealthChangedEvent = RemoteEvents:WaitForChild("HealthChanged")
local PlayerDiedEvent = RemoteEvents:WaitForChild("PlayerDied")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HealthBarUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Create health bar background
local healthBarBg = Instance.new("Frame")
healthBarBg.Name = "HealthBarBackground"
healthBarBg.Size = UDim2.new(0.3, 0, 0.04, 0)
healthBarBg.Position = UDim2.new(0.35, 0, 0.9, 0)
healthBarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
healthBarBg.BorderSizePixel = 2
healthBarBg.BorderColor3 = Color3.fromRGB(0, 0, 0)
healthBarBg.Parent = screenGui

-- Create health bar fill
local healthBarFill = Instance.new("Frame")
healthBarFill.Name = "HealthBarFill"
healthBarFill.Size = UDim2.new(1, 0, 1, 0)
healthBarFill.Position = UDim2.new(0, 0, 0, 0)
healthBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
healthBarFill.BorderSizePixel = 0
healthBarFill.Parent = healthBarBg

-- Create health text
local healthText = Instance.new("TextLabel")
healthText.Name = "HealthText"
healthText.Size = UDim2.new(1, 0, 1, 0)
healthText.Position = UDim2.new(0, 0, 0, 0)
healthText.BackgroundTransparency = 1
healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
healthText.TextStrokeTransparency = 0.5
healthText.TextScaled = true
healthText.Font = Enum.Font.GothamBold
healthText.Text = "100 / 100"
healthText.Parent = healthBarBg

-- Update health bar
local function updateHealthBar(currentHealth, maxHealth)
	local healthPercent = math.clamp(currentHealth / maxHealth, 0, 1)

	-- Tween the health bar
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local goal = {Size = UDim2.new(healthPercent, 0, 1, 0)}
	local tween = TweenService:Create(healthBarFill, tweenInfo, goal)
	tween:Play()

	-- Update color based on health percentage
	if healthPercent > 0.6 then
		healthBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green
	elseif healthPercent > 0.3 then
		healthBarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Yellow
	else
		healthBarFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red
	end

	-- Update text
	healthText.Text = string.format("%d / %d", math.floor(currentHealth), maxHealth)
end

-- Listen for health changes
HealthChangedEvent.OnClientEvent:Connect(function(health, maxHealth)
	updateHealthBar(health, maxHealth)
end)

-- Listen for player death
PlayerDiedEvent.OnClientEvent:Connect(function()
	updateHealthBar(0, 100)
	wait(2)
	-- Could add death screen here
end)

print("HealthBarUI initialized")
