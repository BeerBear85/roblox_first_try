-- GameManager.lua
-- Main game manager that controls the game flow
-- Place in ServerScriptService

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local GameConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("GameConfig"))
local BloodEffect = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("BloodEffect"))

-- Wait for ZombieCreator
while not _G.ZombieCreator do
	wait(0.1)
end
local ZombieCreator = _G.ZombieCreator

local GameManager = {}
GameManager.GameState = "Waiting" -- Waiting, InProgress, Won
GameManager.SpawnedZombies = {}
GameManager.AliveZombies = 0

-- Create RemoteEvents for game state
local GameStateEvent = Instance.new("RemoteEvent")
GameStateEvent.Name = "GameStateChanged"
GameStateEvent.Parent = ReplicatedStorage:WaitForChild("RemoteEvents")

local TimerUpdateEvent = Instance.new("RemoteEvent")
TimerUpdateEvent.Name = "TimerUpdate"
TimerUpdateEvent.Parent = ReplicatedStorage:WaitForChild("RemoteEvents")

-- Find or create spider web spawn point
function GameManager.GetSpiderWebSpawn()
	local spawnPoint = workspace:FindFirstChild("SpiderWebSpawn")

	if not spawnPoint then
		-- Create default spawn point
		spawnPoint = Instance.new("Part")
		spawnPoint.Name = "SpiderWebSpawn"
		spawnPoint.Size = Vector3.new(5, 1, 5)
		spawnPoint.Position = Vector3.new(0, 5, 50) -- 50 studs in front of spawn
		spawnPoint.Anchored = true
		spawnPoint.Transparency = 0.5
		spawnPoint.BrickColor = BrickColor.new("Dark stone grey")
		spawnPoint.Material = Enum.Material.Cobblestone
		spawnPoint.Parent = workspace

		-- Add a label
		local attachment = Instance.new("Attachment")
		attachment.Parent = spawnPoint

		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.new(0, 100, 0, 50)
		billboard.StudsOffset = Vector3.new(0, 3, 0)
		billboard.AlwaysOnTop = true
		billboard.Parent = attachment

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = "Spider Web\nSpawn Point"
		label.TextColor3 = Color3.fromRGB(200, 0, 0)
		label.TextScaled = true
		label.Font = Enum.Font.GothamBold
		label.Parent = billboard
	end

	return spawnPoint
end

-- Spawn zombies around the spider web
function GameManager.SpawnZombies()
	local spawnPoint = GameManager.GetSpiderWebSpawn()
	local spawnPosition = spawnPoint.Position

	print("Spawning " .. GameConfig.Spawning.ZombieCount .. " zombies...")

	for i = 1, GameConfig.Spawning.ZombieCount do
		-- Spawn in a circle around the web
		local angle = (i / GameConfig.Spawning.ZombieCount) * math.pi * 2
		local offset = Vector3.new(
			math.cos(angle) * GameConfig.Spawning.SpawnRadius,
			5,
			math.sin(angle) * GameConfig.Spawning.SpawnRadius
		)

		local zombie = ZombieCreator.CreateZombie(spawnPosition + offset)
		table.insert(GameManager.SpawnedZombies, zombie)
		GameManager.AliveZombies = GameManager.AliveZombies + 1

		-- Track zombie death
		local humanoid = zombie:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.Died:Connect(function()
				GameManager.AliveZombies = GameManager.AliveZombies - 1
				print("Zombie died! Remaining: " .. GameManager.AliveZombies)

				-- Create blood effect at zombie position
				local rootPart = zombie:FindFirstChild("HumanoidRootPart")
				if rootPart then
					BloodEffect.CreateBloodEffect(rootPart.Position, GameConfig.BloodEffect)
				end

				-- Check win condition
				if GameManager.AliveZombies <= 0 then
					GameManager.OnWin()
				end

				-- Clean up zombie after a delay
				wait(3)
				if zombie and zombie.Parent then
					zombie:Destroy()
				end
			end)
		end
	end

	GameManager.GameState = "InProgress"
	GameStateEvent:FireAllClients("InProgress")
end

-- Handle win condition
function GameManager.OnWin()
	if GameManager.GameState == "Won" then return end

	GameManager.GameState = "Won"
	print("All zombies defeated! Players win!")

	GameStateEvent:FireAllClients("Won")

	-- Wait a bit then could reset or end game
	wait(5)
	-- Could add game reset logic here
end

-- Start the game countdown
function GameManager.StartGame()
	print("Game starting! Zombies will spawn in " .. GameConfig.Spawning.SpawnDelay .. " seconds...")

	GameManager.GameState = "Waiting"
	GameStateEvent:FireAllClients("Waiting", GameConfig.Spawning.SpawnDelay)

	-- Countdown timer
	for i = GameConfig.Spawning.SpawnDelay, 0, -1 do
		TimerUpdateEvent:FireAllClients(i)
		print("Zombies spawn in: " .. i)
		wait(1)
	end

	-- Spawn zombies
	GameManager.SpawnZombies()
end

-- Start game when first player joins
Players.PlayerAdded:Connect(function(player)
	if GameManager.GameState == "Waiting" and #Players:GetPlayers() == 1 then
		wait(3) -- Give player time to load
		GameManager.StartGame()
	end
end)

-- Initialize
wait(2)
if #Players:GetPlayers() > 0 then
	GameManager.StartGame()
end

print("GameManager initialized")

return GameManager
