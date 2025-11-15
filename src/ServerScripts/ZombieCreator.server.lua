-- ZombieCreator.lua
-- Server script to create zombie NPCs
-- Place in ServerScriptService

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local GameConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("GameConfig"))
local ZombieAI = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ZombieAI"))

local ZombieCreator = {}

-- Create a zombie NPC
function ZombieCreator.CreateZombie(spawnPosition)
	-- Create the zombie model
	local zombie = Instance.new("Model")
	zombie.Name = "Zombie"

	-- Create body parts
	local head = Instance.new("Part")
	head.Name = "Head"
	head.Size = Vector3.new(2, 1, 1)
	head.BrickColor = BrickColor.new("Bright green")
	head.TopSurface = Enum.SurfaceType.Smooth
	head.BottomSurface = Enum.SurfaceType.Smooth
	head.Parent = zombie

	local torso = Instance.new("Part")
	torso.Name = "Torso"
	torso.Size = Vector3.new(2, 2, 1)
	torso.BrickColor = BrickColor.new("Dark green")
	torso.TopSurface = Enum.SurfaceType.Smooth
	torso.BottomSurface = Enum.SurfaceType.Smooth
	torso.Parent = zombie

	local leftArm = Instance.new("Part")
	leftArm.Name = "Left Arm"
	leftArm.Size = Vector3.new(1, 2, 1)
	leftArm.BrickColor = BrickColor.new("Bright green")
	leftArm.Parent = zombie

	local rightArm = Instance.new("Part")
	rightArm.Name = "Right Arm"
	rightArm.Size = Vector3.new(1, 2, 1)
	rightArm.BrickColor = BrickColor.new("Bright green")
	rightArm.Parent = zombie

	local leftLeg = Instance.new("Part")
	leftLeg.Name = "Left Leg"
	leftLeg.Size = Vector3.new(1, 2, 1)
	leftLeg.BrickColor = BrickColor.new("Dark green")
	leftLeg.Parent = zombie

	local rightLeg = Instance.new("Part")
	rightLeg.Name = "Right Leg"
	rightLeg.Size = Vector3.new(1, 2, 1)
	rightLeg.BrickColor = BrickColor.new("Dark green")
	rightLeg.Parent = zombie

	-- Position parts
	torso.Position = spawnPosition
	head.Position = torso.Position + Vector3.new(0, 1.5, 0)
	leftArm.Position = torso.Position + Vector3.new(-1.5, 0, 0)
	rightArm.Position = torso.Position + Vector3.new(1.5, 0, 0)
	leftLeg.Position = torso.Position + Vector3.new(-0.5, -2, 0)
	rightLeg.Position = torso.Position + Vector3.new(0.5, -2, 0)

	-- Create welds
	local function weldParts(part0, part1)
		local weld = Instance.new("Weld")
		weld.Part0 = part0
		weld.Part1 = part1
		weld.C0 = part0.CFrame:inverse() * part1.CFrame
		weld.Parent = part0
	end

	weldParts(torso, head)
	weldParts(torso, leftArm)
	weldParts(torso, rightArm)
	weldParts(torso, leftLeg)
	weldParts(torso, rightLeg)

	-- Add humanoid
	local humanoid = Instance.new("Humanoid")
	humanoid.MaxHealth = GameConfig.Zombie.MaxHealth
	humanoid.Health = GameConfig.Zombie.MaxHealth
	humanoid.WalkSpeed = GameConfig.Zombie.WalkSpeed
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	humanoid.Parent = zombie

	-- Create HumanoidRootPart
	local rootPart = Instance.new("Part")
	rootPart.Name = "HumanoidRootPart"
	rootPart.Size = Vector3.new(2, 2, 1)
	rootPart.Transparency = 1
	rootPart.CanCollide = false
	rootPart.Position = spawnPosition
	rootPart.Parent = zombie

	weldParts(rootPart, torso)

	-- Create health bar (BillboardGui above head)
	ZombieCreator.CreateHealthBar(zombie)

	-- Parent to workspace
	zombie.Parent = workspace

	-- Start AI
	wait(0.5)
	ZombieAI.StartAI(zombie, nil)

	-- Update health bar when health changes
	humanoid.HealthChanged:Connect(function()
		ZombieCreator.UpdateHealthBar(zombie)
	end)

	return zombie
end

-- Create overhead health bar
function ZombieCreator.CreateHealthBar(zombie)
	local head = zombie:FindFirstChild("Head")
	if not head then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "HealthBar"
	billboard.Size = UDim2.new(4, 0, 0.5, 0)
	billboard.StudsOffset = Vector3.new(0, 2, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = head

	local background = Instance.new("Frame")
	background.Size = UDim2.new(1, 0, 1, 0)
	background.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	background.BorderSizePixel = 1
	background.Parent = billboard

	local healthBar = Instance.new("Frame")
	healthBar.Name = "Bar"
	healthBar.Size = UDim2.new(1, 0, 1, 0)
	healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	healthBar.BorderSizePixel = 0
	healthBar.Parent = background

	local healthText = Instance.new("TextLabel")
	healthText.Name = "Text"
	healthText.Size = UDim2.new(1, 0, 1, 0)
	healthText.BackgroundTransparency = 1
	healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
	healthText.TextScaled = true
	healthText.Font = Enum.Font.GothamBold
	healthText.Text = "50/50"
	healthText.Parent = background
end

-- Update health bar
function ZombieCreator.UpdateHealthBar(zombie)
	local humanoid = zombie:FindFirstChild("Humanoid")
	local head = zombie:FindFirstChild("Head")

	if not humanoid or not head then return end

	local billboard = head:FindFirstChild("HealthBar")
	if not billboard then return end

	local healthBar = billboard:FindFirstChild("Frame"):FindFirstChild("Bar")
	local healthText = billboard:FindFirstChild("Frame"):FindFirstChild("Text")

	if healthBar and healthText then
		local healthPercent = humanoid.Health / humanoid.MaxHealth
		healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
		healthText.Text = string.format("%d/%d", math.floor(humanoid.Health), humanoid.MaxHealth)

		-- Change color based on health
		if healthPercent > 0.5 then
			healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		elseif healthPercent > 0.25 then
			healthBar.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
		else
			healthBar.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
		end
	end
end

_G.ZombieCreator = ZombieCreator

print("ZombieCreator initialized")

return ZombieCreator
