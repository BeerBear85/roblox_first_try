-- GameUI.lua
-- Client script to display game timer and win message
-- Place in StarterPlayer > StarterPlayerScripts

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for RemoteEvents
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local GameStateEvent = RemoteEvents:WaitForChild("GameStateChanged")
local TimerUpdateEvent = RemoteEvents:WaitForChild("TimerUpdate")

-- Create main UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GameUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Create timer display
local timerFrame = Instance.new("Frame")
timerFrame.Name = "TimerFrame"
timerFrame.Size = UDim2.new(0.25, 0, 0.1, 0)
timerFrame.Position = UDim2.new(0.375, 0, 0.05, 0)
timerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
timerFrame.BackgroundTransparency = 0.3
timerFrame.BorderSizePixel = 3
timerFrame.BorderColor3 = Color3.fromRGB(200, 0, 0)
timerFrame.Parent = screenGui

local timerLabel = Instance.new("TextLabel")
timerLabel.Name = "TimerLabel"
timerLabel.Size = UDim2.new(1, 0, 0.5, 0)
timerLabel.Position = UDim2.new(0, 0, 0, 0)
timerLabel.BackgroundTransparency = 1
timerLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
timerLabel.TextScaled = true
timerLabel.Font = Enum.Font.GothamBold
timerLabel.Text = "MONSTERS INCOMING"
timerLabel.Parent = timerFrame

local timerText = Instance.new("TextLabel")
timerText.Name = "TimerText"
timerText.Size = UDim2.new(1, 0, 0.5, 0)
timerText.Position = UDim2.new(0, 0, 0.5, 0)
timerText.BackgroundTransparency = 1
timerText.TextColor3 = Color3.fromRGB(255, 255, 255)
timerText.TextScaled = true
timerText.Font = Enum.Font.GothamBold
timerText.Text = "60"
timerText.Parent = timerFrame

-- Create win message (hidden by default)
local winFrame = Instance.new("Frame")
winFrame.Name = "WinFrame"
winFrame.Size = UDim2.new(0.5, 0, 0.3, 0)
winFrame.Position = UDim2.new(0.25, 0, 0.35, 0)
winFrame.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
winFrame.BackgroundTransparency = 0.2
winFrame.BorderSizePixel = 5
winFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
winFrame.Visible = false
winFrame.Parent = screenGui

local winTitle = Instance.new("TextLabel")
winTitle.Name = "WinTitle"
winTitle.Size = UDim2.new(1, 0, 0.4, 0)
winTitle.Position = UDim2.new(0, 0, 0.1, 0)
winTitle.BackgroundTransparency = 1
winTitle.TextColor3 = Color3.fromRGB(255, 255, 0)
winTitle.TextScaled = true
winTitle.Font = Enum.Font.GothamBold
winTitle.Text = "VICTORY!"
winTitle.Parent = winFrame

local winMessage = Instance.new("TextLabel")
winMessage.Name = "WinMessage"
winMessage.Size = UDim2.new(1, 0, 0.3, 0)
winMessage.Position = UDim2.new(0, 0, 0.55, 0)
winMessage.BackgroundTransparency = 1
winMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
winMessage.TextScaled = true
winMessage.Font = Enum.Font.Gotham
winMessage.Text = "All monsters defeated!\nYou have earned: Survivor's Badge"
winMessage.Parent = winFrame

-- Update timer
TimerUpdateEvent.OnClientEvent:Connect(function(timeLeft)
	timerText.Text = tostring(timeLeft)

	-- Flash red when time is low
	if timeLeft <= 10 and timeLeft > 0 then
		timerLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		timerText.TextColor3 = Color3.fromRGB(255, 0, 0)

		-- Pulse effect
		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
		local goal = {TextTransparency = 0.5}
		local tween = TweenService:Create(timerLabel, tweenInfo, goal)
		tween:Play()
	end

	if timeLeft == 0 then
		timerLabel.Text = "FIGHT!"
		timerLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		timerText.Text = ""

		wait(2)
		timerFrame.Visible = false
	end
end)

-- Handle game state changes
GameStateEvent.OnClientEvent:Connect(function(state, data)
	if state == "Waiting" then
		timerFrame.Visible = true
		winFrame.Visible = false
		timerLabel.Text = "MONSTERS INCOMING"
		if data then
			timerText.Text = tostring(data)
		end
	elseif state == "InProgress" then
		-- Game has started
		timerFrame.Visible = false
	elseif state == "Won" then
		-- Show win message
		winFrame.Visible = true
		winFrame.Size = UDim2.new(0.1, 0, 0.1, 0)
		winFrame.Position = UDim2.new(0.45, 0, 0.45, 0)

		-- Animate win screen
		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
		local goal = {
			Size = UDim2.new(0.5, 0, 0.3, 0),
			Position = UDim2.new(0.25, 0, 0.35, 0)
		}
		local tween = TweenService:Create(winFrame, tweenInfo, goal)
		tween:Play()

		-- Play celebration sound (if you add one)
		-- local sound = Instance.new("Sound")
		-- sound.SoundId = "rbxassetid://your_sound_id"
		-- sound.Parent = winFrame
		-- sound:Play()
	end
end)

print("GameUI initialized")
