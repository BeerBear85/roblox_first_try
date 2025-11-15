-- PlayerHealthSystem.lua
-- Server script to manage player health
-- Place in ServerScriptService

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Wait for GameConfig to be available
local GameConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("GameConfig"))

-- Create RemoteEvents for health updates
local RemoteEvents = Instance.new("Folder")
RemoteEvents.Name = "RemoteEvents"
RemoteEvents.Parent = ReplicatedStorage

local HealthChangedEvent = Instance.new("RemoteEvent")
HealthChangedEvent.Name = "HealthChanged"
HealthChangedEvent.Parent = RemoteEvents

local PlayerDiedEvent = Instance.new("RemoteEvent")
PlayerDiedEvent.Name = "PlayerDied"
PlayerDiedEvent.Parent = RemoteEvents

-- Player data storage
local PlayerData = {}

-- Initialize player health when they join
local function onPlayerAdded(player)
	PlayerData[player.UserId] = {
		Health = GameConfig.Player.MaxHealth,
		MaxHealth = GameConfig.Player.MaxHealth,
		IsAlive = true
	}

	player.CharacterAdded:Connect(function(character)
		-- Reset health on respawn
		PlayerData[player.UserId].Health = GameConfig.Player.MaxHealth
		PlayerData[player.UserId].IsAlive = true

		local humanoid = character:WaitForChild("Humanoid")

		-- Set max health
		humanoid.MaxHealth = GameConfig.Player.MaxHealth
		humanoid.Health = GameConfig.Player.MaxHealth

		-- Sync Roblox health with our system
		humanoid.HealthChanged:Connect(function(health)
			if PlayerData[player.UserId] then
				PlayerData[player.UserId].Health = health
				HealthChangedEvent:FireClient(player, health, GameConfig.Player.MaxHealth)
			end
		end)

		humanoid.Died:Connect(function()
			if PlayerData[player.UserId] then
				PlayerData[player.UserId].IsAlive = false
				PlayerDiedEvent:FireClient(player)
			end
		end)

		-- Initial health update
		HealthChangedEvent:FireClient(player, GameConfig.Player.MaxHealth, GameConfig.Player.MaxHealth)
	end)
end

-- Clean up when player leaves
local function onPlayerRemoving(player)
	PlayerData[player.UserId] = nil
end

-- Function to damage a player (can be called by combat system)
local function damagePlayer(player, damage)
	if not PlayerData[player.UserId] or not PlayerData[player.UserId].IsAlive then
		return
	end

	local character = player.Character
	if character then
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid and humanoid.Health > 0 then
			humanoid:TakeDamage(damage)
		end
	end
end

-- Expose damage function for other scripts
_G.DamagePlayer = damagePlayer

-- Get player current health
local function getPlayerHealth(player)
	if PlayerData[player.UserId] then
		return PlayerData[player.UserId].Health, PlayerData[player.UserId].MaxHealth
	end
	return 0, 0
end

_G.GetPlayerHealth = getPlayerHealth

-- Connect events
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Handle existing players (if script loads after players join)
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

print("PlayerHealthSystem initialized")
