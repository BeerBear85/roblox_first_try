-- WeaponSetup.lua
-- Server script to give players their starting weapons
-- Place in ServerScriptService

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local WeaponManager = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("WeaponManager"))

-- Give weapons to player when they spawn
local function onCharacterAdded(character)
	local player = Players:GetPlayerFromCharacter(character)
	if not player then return end

	-- Wait for character to fully load
	local humanoid = character:WaitForChild("Humanoid")
	wait(0.5)

	-- Create weapons storage folder in player
	local weaponsFolder = player:FindFirstChild("Weapons")
	if not weaponsFolder then
		weaponsFolder = Instance.new("Folder")
		weaponsFolder.Name = "Weapons"
		weaponsFolder.Parent = player
	end

	-- Clear old weapons
	weaponsFolder:ClearAllChildren()

	-- Create all weapons and store them
	local sword = WeaponManager.CreateWeapon("Sword")
	if sword then
		sword.Parent = weaponsFolder
	end

	local knife = WeaponManager.CreateWeapon("Knife")
	if knife then
		knife.Parent = weaponsFolder
	end

	local fireSword = WeaponManager.CreateWeapon("FireSword")
	if fireSword then
		fireSword.Parent = weaponsFolder
	end

	-- Equip the first weapon (sword) by default
	if sword then
		local swordClone = sword:Clone()
		swordClone.Parent = character
		wait(0.1)
		humanoid:EquipTool(swordClone)
	end

	print("Weapons given to player: " .. player.Name)
end

-- Connect to player character spawning
local function onPlayerAdded(player)
	player.CharacterAdded:Connect(onCharacterAdded)

	-- Handle if character already exists
	if player.Character then
		onCharacterAdded(player.Character)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)

-- Handle existing players
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

print("WeaponSetup initialized")
