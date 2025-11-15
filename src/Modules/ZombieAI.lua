-- ZombieAI.lua
-- Module to handle zombie AI behavior

local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("GameConfig"))

local ZombieAI = {}

-- Make zombie chase and attack player
function ZombieAI.StartAI(zombie, targetPlayer)
	local humanoid = zombie:FindFirstChild("Humanoid")
	local rootPart = zombie:FindFirstChild("HumanoidRootPart")

	if not humanoid or not rootPart then
		warn("Zombie missing humanoid or root part")
		return
	end

	local isAttacking = false
	local lastAttackTime = 0

	-- AI loop
	spawn(function()
		while zombie and zombie.Parent and humanoid.Health > 0 do
			wait(0.5)

			-- Find nearest player
			local target = targetPlayer
			if not target or not target.Character then
				target = ZombieAI.FindNearestPlayer(rootPart.Position)
			end

			if target and target.Character then
				local targetChar = target.Character
				local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
				local targetHumanoid = targetChar:FindFirstChild("Humanoid")

				if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
					local distance = (rootPart.Position - targetRoot.Position).Magnitude

					-- Attack if close enough
					if distance <= 5 then
						if not isAttacking and tick() - lastAttackTime >= GameConfig.Zombie.AttackCooldown then
							isAttacking = true
							ZombieAI.AttackPlayer(zombie, target)
							lastAttackTime = tick()
							wait(GameConfig.Zombie.AttackCooldown)
							isAttacking = false
						end
					else
						-- Chase player
						ZombieAI.ChaseTarget(zombie, targetRoot.Position)
					end
				end
			else
				-- Idle if no target
				humanoid.WalkSpeed = 0
			end
		end
	end)
end

-- Find nearest player
function ZombieAI.FindNearestPlayer(position)
	local nearestPlayer = nil
	local shortestDistance = math.huge

	for _, player in ipairs(game.Players:GetPlayers()) do
		if player.Character then
			local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
			local humanoid = player.Character:FindFirstChild("Humanoid")

			if rootPart and humanoid and humanoid.Health > 0 then
				local distance = (position - rootPart.Position).Magnitude
				if distance < shortestDistance then
					shortestDistance = distance
					nearestPlayer = player
				end
			end
		end
	end

	return nearestPlayer
end

-- Chase target
function ZombieAI.ChaseTarget(zombie, targetPosition)
	local humanoid = zombie:FindFirstChild("Humanoid")
	local rootPart = zombie:FindFirstChild("HumanoidRootPart")

	if not humanoid or not rootPart then return end

	humanoid.WalkSpeed = GameConfig.Zombie.WalkSpeed

	-- Simple pathfinding
	local path = PathfindingService:CreatePath({
		AgentRadius = 2,
		AgentHeight = 5,
		AgentCanJump = true,
		AgentMaxSlope = 45
	})

	local success, errorMessage = pcall(function()
		path:ComputeAsync(rootPart.Position, targetPosition)
	end)

	if success and path.Status == Enum.PathStatus.Success then
		local waypoints = path:GetWaypoints()

		for i, waypoint in ipairs(waypoints) do
			if i > 1 then -- Skip first waypoint (current position)
				humanoid:MoveTo(waypoint.Position)

				-- Wait until reached or timeout
				local timeout = humanoid.MoveToFinished:Wait()

				-- Check if zombie still exists
				if not zombie or not zombie.Parent or humanoid.Health <= 0 then
					break
				end
			end
		end
	else
		-- Fallback: move directly toward target
		humanoid:MoveTo(targetPosition)
	end
end

-- Attack player
function ZombieAI.AttackPlayer(zombie, player)
	if not player or not player.Character then return end

	local targetHumanoid = player.Character:FindFirstChild("Humanoid")
	if targetHumanoid and targetHumanoid.Health > 0 then
		-- Deal damage using global function from PlayerHealthSystem
		if _G.DamagePlayer then
			_G.DamagePlayer(player, GameConfig.Zombie.Damage)
			print("Zombie attacked " .. player.Name .. " for " .. GameConfig.Zombie.Damage .. " damage")
		else
			targetHumanoid:TakeDamage(GameConfig.Zombie.Damage)
		end
	end
end

return ZombieAI
