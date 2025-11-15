-- WeaponManager.lua
-- Module to handle weapon creation and management

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("GameConfig"))

local WeaponManager = {}

-- Create a weapon tool
function WeaponManager.CreateWeapon(weaponType)
	local weaponData = GameConfig.Weapons[weaponType]
	if not weaponData then
		warn("Unknown weapon type: " .. tostring(weaponType))
		return nil
	end

	local tool = Instance.new("Tool")
	tool.Name = weaponData.Name
	tool.RequiresHandle = true
	tool.CanBeDropped = false

	-- Create handle (the visible part of the weapon)
	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(0.5, 0.5, 3) -- Adjust based on weapon type
	handle.TopSurface = Enum.SurfaceType.Smooth
	handle.BottomSurface = Enum.SurfaceType.Smooth

	-- Set color based on weapon type
	if weaponType == "Sword" then
		handle.BrickColor = BrickColor.new("Medium stone grey")
		handle.Size = Vector3.new(0.4, 0.4, 4)
	elseif weaponType == "Knife" then
		handle.BrickColor = BrickColor.new("Silver")
		handle.Size = Vector3.new(0.3, 0.3, 2)
	elseif weaponType == "FireSword" then
		handle.BrickColor = BrickColor.new("Deep orange")
		handle.Size = Vector3.new(0.5, 0.5, 4.5)
		handle.Material = Enum.Material.Neon

		-- Add fire effect
		local fire = Instance.new("Fire")
		fire.Size = 5
		fire.Heat = 10
		fire.Color = Color3.fromRGB(255, 100, 0)
		fire.SecondaryColor = Color3.fromRGB(255, 200, 0)
		fire.Parent = handle
	end

	handle.Parent = tool

	-- Store weapon data in tool
	local weaponStats = Instance.new("Folder")
	weaponStats.Name = "WeaponStats"
	weaponStats.Parent = tool

	local damage = Instance.new("IntValue")
	damage.Name = "Damage"
	damage.Value = weaponData.Damage
	damage.Parent = weaponStats

	local attackSpeed = Instance.new("NumberValue")
	attackSpeed.Name = "AttackSpeed"
	attackSpeed.Value = weaponData.AttackSpeed
	attackSpeed.Parent = weaponStats

	local range = Instance.new("NumberValue")
	range.Name = "Range"
	range.Value = weaponData.Range
	range.Parent = weaponStats

	return tool
end

-- Get weapon stats from a tool
function WeaponManager.GetWeaponStats(tool)
	if not tool or not tool:FindFirstChild("WeaponStats") then
		return nil
	end

	local stats = tool.WeaponStats
	return {
		Damage = stats.Damage.Value,
		AttackSpeed = stats.AttackSpeed.Value,
		Range = stats.Range.Value
	}
end

return WeaponManager
