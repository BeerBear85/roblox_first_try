-- WeaponSwitcher.lua
-- Client script to handle weapon switching with number keys
-- Place in StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local WeaponManager = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("WeaponManager"))

local currentWeaponIndex = 1
local weaponList = {"Sword", "Knife", "FireSword"}
local isEquipping = false

-- Create UI to show current weapon
local function createWeaponUI()
	local playerGui = player:WaitForChild("PlayerGui")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "WeaponUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	local weaponLabel = Instance.new("TextLabel")
	weaponLabel.Name = "WeaponLabel"
	weaponLabel.Size = UDim2.new(0.2, 0, 0.06, 0)
	weaponLabel.Position = UDim2.new(0.4, 0, 0.82, 0)
	weaponLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	weaponLabel.BackgroundTransparency = 0.3
	weaponLabel.BorderSizePixel = 2
	weaponLabel.BorderColor3 = Color3.fromRGB(200, 200, 200)
	weaponLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	weaponLabel.TextScaled = true
	weaponLabel.Font = Enum.Font.GothamBold
	weaponLabel.Text = "Weapon: Normal Sword [1]"
	weaponLabel.Parent = screenGui

	return weaponLabel
end

local weaponLabel = createWeaponUI()

-- Equip weapon by type
local function equipWeapon(weaponType)
	if isEquipping then return end
	isEquipping = true

	local character = player.Character
	if not character then
		isEquipping = false
		return
	end

	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then
		isEquipping = false
		return
	end

	-- Unequip current tool
	if humanoid then
		humanoid:UnequipTools()
	end

	-- Remove current weapon from character
	for _, tool in ipairs(character:GetChildren()) do
		if tool:IsA("Tool") then
			tool:Destroy()
		end
	end

	-- Get weapon from player's weapons folder
	local weaponsFolder = player:FindFirstChild("Weapons")
	if not weaponsFolder then
		isEquipping = false
		return
	end

	local weaponTemplate = weaponsFolder:FindFirstChild(GameConfig.Weapons[weaponType].Name)
	if weaponTemplate then
		local weapon = weaponTemplate:Clone()
		weapon.Parent = character

		wait(0.1)
		humanoid:EquipTool(weapon)

		-- Update UI
		local weaponIndex = table.find(weaponList, weaponType)
		weaponLabel.Text = string.format("Weapon: %s [%d]", weapon.Name, weaponIndex or 1)
	end

	isEquipping = false
end

-- Handle input for weapon switching
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	-- Check for number keys 1, 2, 3
	if input.KeyCode == Enum.KeyCode.One then
		currentWeaponIndex = 1
		equipWeapon("Sword")
	elseif input.KeyCode == Enum.KeyCode.Two then
		currentWeaponIndex = 2
		equipWeapon("Knife")
	elseif input.KeyCode == Enum.KeyCode.Three then
		currentWeaponIndex = 3
		equipWeapon("FireSword")
	end
end)

-- Wait for GameConfig (needed for weapon names)
local GameConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("GameConfig"))

print("WeaponSwitcher initialized")
