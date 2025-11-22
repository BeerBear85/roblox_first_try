local BloodEffect = {}

-- Creates a blood particle effect at the specified position
function BloodEffect.CreateBloodEffect(position, config)
	-- Create an invisible part to hold the particle emitter
	local effectPart = Instance.new("Part")
	effectPart.Name = "BloodEffectPart"
	effectPart.Size = Vector3.new(1, 1, 1)
	effectPart.Position = position
	effectPart.Anchored = true
	effectPart.CanCollide = false
	effectPart.Transparency = 1 -- Invisible
	effectPart.Parent = workspace

	-- Create the particle emitter
	local particles = Instance.new("ParticleEmitter")
	particles.Name = "BloodParticles"
	particles.Parent = effectPart

	-- Configure particle appearance
	particles.Color = ColorSequence.new(Color3.fromRGB(180, 0, 0)) -- Dark red
	particles.Size = NumberSequence.new(config.ParticleSize or 0.5)
	particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
	particles.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.3),
		NumberSequenceKeypoint.new(1, 1)
	})

	-- Configure particle behavior
	particles.Lifetime = NumberRange.new(config.ParticleLifetime or 1, config.ParticleLifetime or 1)
	particles.Rate = 0 -- Don't emit continuously
	particles.Speed = NumberRange.new(config.ParticleSpeed or 15, config.ParticleSpeed or 20)
	particles.SpreadAngle = Vector2.new(180, 180) -- Spread in all directions
	particles.Acceleration = Vector3.new(0, -20, 0) -- Gravity effect
	particles.Drag = 2
	particles.VelocityInheritance = 0

	-- Emit particles in a burst
	particles:Emit(config.ParticleCount or 30)

	-- Clean up after the effect is done
	local cleanupDelay = (config.ParticleLifetime or 1) + 1
	task.delay(cleanupDelay, function()
		effectPart:Destroy()
	end)
end

return BloodEffect
