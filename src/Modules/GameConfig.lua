-- GameConfig.lua
-- Central configuration for all game settings

local GameConfig = {}

-- Player Settings
GameConfig.Player = {
	MaxHealth = 100,
	WalkSpeed = 16,
	JumpPower = 50
}

-- Enemy Settings
GameConfig.Zombie = {
	MaxHealth = 50,
	WalkSpeed = 12,
	Damage = 10,
	AttackCooldown = 2, -- seconds between attacks
	DetectionRange = 50 -- studs
}

-- Blood Effect Settings
GameConfig.BloodEffect = {
	ParticleCount = 30, -- number of particles to emit
	ParticleSize = 0.5, -- size of each particle
	ParticleLifetime = 1, -- how long particles last (seconds)
	ParticleSpeed = 15 -- speed particles fly outward
}

-- Spawn Settings
GameConfig.Spawning = {
	SpawnDelay = 15, -- seconds before first wave
	ZombieCount = 4, -- number of zombies to spawn (3-5 range)
	SpawnRadius = 15 -- radius around spawn point
}

-- Weapon Data
GameConfig.Weapons = {
	Sword = {
		Name = "Normal Sword",
		Damage = 20,
		AttackSpeed = 1.0,
		Range = 8,
		Key = Enum.KeyCode.One
	},
	Knife = {
		Name = "Knife",
		Damage = 15,
		AttackSpeed = 0.5, -- faster attacks
		Range = 5,
		Key = Enum.KeyCode.Two
	},
	FireSword = {
		Name = "Fire Sword",
		Damage = 35,
		AttackSpeed = 1.5, -- slower but powerful
		Range = 9,
		Key = Enum.KeyCode.Three
	}
}

-- UI Settings
GameConfig.UI = {
	HealthBarUpdateRate = 0.1,
	TimerPosition = UDim2.new(0.5, 0, 0.05, 0),
	WinMessageDuration = 5
}

return GameConfig
