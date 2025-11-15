-- CombatSystem.lua
-- Server script to handle combat mechanics and damage
-- Place in ServerScriptService

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local WeaponManager = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("WeaponManager"))

-- Track weapon cooldowns per player
local weaponCooldowns = {}

-- Handle weapon activation (when player clicks/attacks)
local function onWeaponActivated(tool)
	local character = tool.Parent
	if not character or not character:IsA("Model") then return end

	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid or humanoid.Health <= 0 then return end

	local player = game.Players:GetPlayerFromCharacter(character)
	if not player then return end

	-- Check cooldown
	local cooldownKey = player.UserId .. "_" .. tool.Name
	if weaponCooldowns[cooldownKey] and tick() < weaponCooldowns[cooldownKey] then
		return -- Still on cooldown
	end

	-- Get weapon stats
	local stats = WeaponManager.GetWeaponStats(tool)
	if not stats then return end

	-- Set cooldown
	weaponCooldowns[cooldownKey] = tick() + stats.AttackSpeed

	-- Play animation
	local animator = humanoid:FindFirstChild("Animator")
	if animator then
		-- Simple slash animation (you can create custom animations in Roblox Studio)
		humanoid.WalkSpeed = 8 -- Slow down during attack
		wait(0.3)
		humanoid.WalkSpeed = 16 -- Return to normal speed
	end

	-- Detect hits
	local handle = tool:FindFirstChild("Handle")
	if not handle then return end

	local hitParts = {}
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	-- Check for enemies in range
	local region = Region3.new(
		rootPart.Position - Vector3.new(stats.Range, stats.Range, stats.Range),
		rootPart.Position + Vector3.new(stats.Range, stats.Range, stats.Range)
	)
	region = region:ExpandToGrid(4)

	-- Find all parts in range
	local partsInRegion = workspace:FindPartsInRegion3(region, character, 100)

	for _, part in ipairs(partsInRegion) do
		if part.Parent and part.Parent:FindFirstChild("Humanoid") and part.Parent ~= character then
			local enemyHumanoid = part.Parent:FindFirstChild("Humanoid")
			local enemyRootPart = part.Parent:FindFirstChild("HumanoidRootPart")

			if enemyHumanoid and enemyRootPart and enemyHumanoid.Health > 0 then
				-- Check if within range
				local distance = (rootPart.Position - enemyRootPart.Position).Magnitude
				if distance <= stats.Range then
					-- Deal damage
					enemyHumanoid:TakeDamage(stats.Damage)

					-- Visual feedback (hit effect)
					local hitEffect = Instance.new("Part")
					hitEffect.Shape = Enum.PartType.Ball
					hitEffect.Size = Vector3.new(1, 1, 1)
					hitEffect.Position = enemyRootPart.Position
					hitEffect.BrickColor = BrickColor.new("Bright red")
					hitEffect.Material = Enum.Material.Neon
					hitEffect.Anchored = true
					hitEffect.CanCollide = false
					hitEffect.Transparency = 0.5
					hitEffect.Parent = workspace
					Debris:AddItem(hitEffect, 0.3)

					print(player.Name .. " hit " .. part.Parent.Name .. " for " .. stats.Damage .. " damage")
					break -- Only hit one enemy per attack
				end
			end
		end
	end
end

-- Connect to all tools
local function setupWeapon(tool)
	if not tool:IsA("Tool") then return end

	tool.Activated:Connect(function()
		onWeaponActivated(tool)
	end)
end

-- Monitor for new tools being equipped
game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		character.ChildAdded:Connect(function(child)
			if child:IsA("Tool") then
				setupWeapon(child)
			end
		end)

		-- Setup existing tools
		for _, child in ipairs(character:GetChildren()) do
			if child:IsA("Tool") then
				setupWeapon(child)
			end
		end
	end)
end)

-- Handle existing players
for _, player in ipairs(game.Players:GetPlayers()) do
	if player.Character then
		for _, child in ipairs(player.Character:GetChildren()) do
			if child:IsA("Tool") then
				setupWeapon(child)
			end
		end
	end
end

print("CombatSystem initialized")
