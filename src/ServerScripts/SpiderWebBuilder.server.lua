-- SpiderWebBuilder.lua
-- Server script to create a giant spider web at the spawn point
-- Place in ServerScriptService

local SpiderWebBuilder = {}

-- Create a giant spider web
function SpiderWebBuilder.CreateSpiderWeb(centerPosition)
	-- Create web container
	local webModel = Instance.new("Model")
	webModel.Name = "GiantSpiderWeb"

	-- Web configuration
	local webRadius = 12
	local spokes = 8 -- Number of radial threads
	local circles = 5 -- Number of circular threads

	-- Create center anchor
	local center = Instance.new("Part")
	center.Name = "WebCenter"
	center.Size = Vector3.new(1, 1, 1)
	center.Shape = Enum.PartType.Ball
	center.Position = centerPosition + Vector3.new(0, 0, 0)
	center.Anchored = true
	center.BrickColor = BrickColor.new("Black")
	center.Material = Enum.Material.SmoothPlastic
	center.Parent = webModel

	-- Create radial spokes (from center outward)
	local spokePositions = {}
	for i = 1, spokes do
		local angle = (i / spokes) * math.pi * 2
		local endPos = centerPosition + Vector3.new(
			math.cos(angle) * webRadius,
			0,
			math.sin(angle) * webRadius
		)

		table.insert(spokePositions, endPos)

		-- Create spoke thread
		local spoke = Instance.new("Part")
		spoke.Name = "Spoke" .. i
		spoke.Size = Vector3.new(0.2, 0.2, webRadius * 2)
		spoke.Position = (centerPosition + endPos) / 2
		spoke.CFrame = CFrame.new(spoke.Position, endPos)
		spoke.Anchored = true
		spoke.BrickColor = BrickColor.new("White")
		spoke.Material = Enum.Material.Neon
		spoke.Transparency = 0.3
		spoke.CanCollide = false
		spoke.Parent = webModel

		-- Create anchor point at the end
		local anchor = Instance.new("Part")
		anchor.Name = "Anchor" .. i
		anchor.Size = Vector3.new(0.5, 0.5, 0.5)
		anchor.Shape = Enum.PartType.Ball
		anchor.Position = endPos
		anchor.Anchored = true
		anchor.BrickColor = BrickColor.new("Really black")
		anchor.Material = Enum.Material.SmoothPlastic
		anchor.Parent = webModel
	end

	-- Create circular threads
	for circle = 1, circles do
		local radius = (circle / circles) * webRadius
		local segments = spokes

		for i = 1, segments do
			local angle1 = (i / segments) * math.pi * 2
			local angle2 = ((i + 1) / segments) * math.pi * 2

			local pos1 = centerPosition + Vector3.new(
				math.cos(angle1) * radius,
				0,
				math.sin(angle1) * radius
			)
			local pos2 = centerPosition + Vector3.new(
				math.cos(angle2) * radius,
				0,
				math.sin(angle2) * radius
			)

			local distance = (pos2 - pos1).Magnitude

			-- Create circular thread segment
			local thread = Instance.new("Part")
			thread.Name = "Circle" .. circle .. "_" .. i
			thread.Size = Vector3.new(0.15, 0.15, distance)
			thread.Position = (pos1 + pos2) / 2
			thread.CFrame = CFrame.new(thread.Position, pos2)
			thread.Anchored = true
			thread.BrickColor = BrickColor.new("White")
			thread.Material = Enum.Material.Neon
			thread.Transparency = 0.4
			thread.CanCollide = false
			thread.Parent = webModel
		end
	end

	-- Add some decorative sticky drops
	for i = 1, 15 do
		local randomAngle = math.random() * math.pi * 2
		local randomRadius = math.random() * webRadius
		local dropPos = centerPosition + Vector3.new(
			math.cos(randomAngle) * randomRadius,
			math.random(-2, 2) * 0.5,
			math.sin(randomAngle) * randomRadius
		)

		local drop = Instance.new("Part")
		drop.Name = "StickyDrop" .. i
		drop.Size = Vector3.new(0.3, 0.5, 0.3)
		drop.Shape = Enum.PartType.Ball
		drop.Position = dropPos
		drop.Anchored = true
		drop.BrickColor = BrickColor.new("Institutional white")
		drop.Material = Enum.Material.Neon
		drop.Transparency = 0.2
		drop.CanCollide = false
		drop.Parent = webModel
	end

	-- Add a spooky glow effect
	local light = Instance.new("PointLight")
	light.Color = Color3.fromRGB(200, 200, 255)
	light.Brightness = 2
	light.Range = 30
	light.Parent = center

	-- Parent to workspace
	webModel.Parent = workspace

	print("Giant Spider Web created at position: " .. tostring(centerPosition))

	return webModel
end

-- Find or create the spider web
local function initialize()
	wait(2) -- Wait for other scripts to load

	-- Find the spawn point
	local spawnPoint = workspace:FindFirstChild("SpiderWebSpawn")

	if spawnPoint then
		-- Create web at spawn point
		local webPosition = spawnPoint.Position + Vector3.new(0, 0.5, 0)
		SpiderWebBuilder.CreateSpiderWeb(webPosition)

		-- Make spawn point more web-like
		spawnPoint.BrickColor = BrickColor.new("Black")
		spawnPoint.Material = Enum.Material.Cobblestone
		spawnPoint.Transparency = 0.3
	else
		warn("SpiderWebSpawn not found in workspace. Create it first or GameManager will create it.")
	end
end

-- Initialize after a delay
spawn(initialize)

print("SpiderWebBuilder initialized")

return SpiderWebBuilder
