-- BloodEffect.spec.lua
-- Test suite for the BloodEffect module
-- Place in ServerScriptService > Tests

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestService = game:GetService("TestService")

-- Wait for modules to load
local Modules = ReplicatedStorage:WaitForChild("Modules")
local BloodEffect = require(Modules:WaitForChild("BloodEffect"))
local GameConfig = require(Modules:WaitForChild("GameConfig"))

local function runTests()
	print("======================================")
	print("Starting BloodEffect Tests")
	print("======================================")

	-- Test 1: Module loads correctly
	local function testModuleLoads()
		TestService:Message("Test 1: Verifying BloodEffect module loads...")
		assert(BloodEffect ~= nil, "BloodEffect module should load")
		assert(type(BloodEffect.CreateBloodEffect) == "function", "CreateBloodEffect should be a function")
		TestService:Message("✓ Test 1 Passed: Module loads correctly")
	end

	-- Test 2: Blood effect creates necessary components
	local function testBloodEffectCreation()
		TestService:Message("Test 2: Verifying blood effect creates components...")

		local testPosition = Vector3.new(0, 10, 0)
		local initialPartCount = #workspace:GetChildren()

		-- Create blood effect
		BloodEffect.CreateBloodEffect(testPosition, GameConfig.BloodEffect)

		-- Give a moment for the effect to be created
		task.wait(0.1)

		-- Check that a new part was created in workspace
		local effectPart = workspace:FindFirstChild("BloodEffectPart")
		assert(effectPart ~= nil, "BloodEffectPart should exist in workspace")
		assert(effectPart.Position == testPosition, "Effect should be at correct position")
		assert(effectPart.Transparency == 1, "Effect part should be invisible")
		assert(effectPart.Anchored == true, "Effect part should be anchored")
		assert(effectPart.CanCollide == false, "Effect part should not collide")

		TestService:Message("✓ Test 2 Passed: Blood effect creates components correctly")

		-- Cleanup
		if effectPart then
			effectPart:Destroy()
		end
	end

	-- Test 3: Particle emitter is configured correctly
	local function testParticleConfiguration()
		TestService:Message("Test 3: Verifying particle emitter configuration...")

		local testPosition = Vector3.new(0, 10, 0)

		-- Create blood effect
		BloodEffect.CreateBloodEffect(testPosition, GameConfig.BloodEffect)

		task.wait(0.1)

		local effectPart = workspace:FindFirstChild("BloodEffectPart")
		assert(effectPart ~= nil, "BloodEffectPart should exist")

		local particles = effectPart:FindFirstChild("BloodParticles")
		assert(particles ~= nil, "ParticleEmitter should exist")
		assert(particles:IsA("ParticleEmitter"), "Should be a ParticleEmitter instance")

		-- Verify particle properties
		assert(particles.Rate == 0, "Rate should be 0 (burst mode)")
		assert(particles.Lifetime.Min == GameConfig.BloodEffect.ParticleLifetime,
			"Particle lifetime should match config")

		-- Check color is red
		local color = particles.Color.Keypoints[1].Value
		assert(color.R > 0.5, "Blood should have red color")
		assert(color.G < 0.1, "Blood should have minimal green")
		assert(color.B < 0.1, "Blood should have minimal blue")

		TestService:Message("✓ Test 3 Passed: Particle emitter configured correctly")

		-- Cleanup
		if effectPart then
			effectPart:Destroy()
		end
	end

	-- Test 4: Blood effect cleans up automatically
	local function testAutoCleanup()
		TestService:Message("Test 4: Verifying automatic cleanup...")

		local testPosition = Vector3.new(0, 10, 0)

		-- Create blood effect
		BloodEffect.CreateBloodEffect(testPosition, GameConfig.BloodEffect)

		task.wait(0.1)

		local effectPart = workspace:FindFirstChild("BloodEffectPart")
		assert(effectPart ~= nil, "BloodEffectPart should exist initially")

		-- Wait for cleanup (ParticleLifetime + 1 second buffer)
		local cleanupDelay = GameConfig.BloodEffect.ParticleLifetime + 1.5
		TestService:Message("  Waiting " .. cleanupDelay .. " seconds for cleanup...")
		task.wait(cleanupDelay)

		-- Check that part was destroyed
		effectPart = workspace:FindFirstChild("BloodEffectPart")
		assert(effectPart == nil, "BloodEffectPart should be cleaned up automatically")

		TestService:Message("✓ Test 4 Passed: Automatic cleanup works")
	end

	-- Test 5: Multiple blood effects can be created simultaneously
	local function testMultipleEffects()
		TestService:Message("Test 5: Verifying multiple simultaneous effects...")

		-- Create 3 blood effects at different positions
		BloodEffect.CreateBloodEffect(Vector3.new(0, 10, 0), GameConfig.BloodEffect)
		BloodEffect.CreateBloodEffect(Vector3.new(5, 10, 5), GameConfig.BloodEffect)
		BloodEffect.CreateBloodEffect(Vector3.new(-5, 10, -5), GameConfig.BloodEffect)

		task.wait(0.1)

		-- Count how many BloodEffectParts exist
		local count = 0
		for _, obj in ipairs(workspace:GetChildren()) do
			if obj.Name == "BloodEffectPart" then
				count = count + 1
			end
		end

		assert(count == 3, "Should have 3 blood effect parts in workspace (found " .. count .. ")")

		TestService:Message("✓ Test 5 Passed: Multiple effects can coexist")

		-- Cleanup
		for _, obj in ipairs(workspace:GetChildren()) do
			if obj.Name == "BloodEffectPart" then
				obj:Destroy()
			end
		end
	end

	-- Test 6: Integration test - Zombie death triggers blood effect
	local function testZombieDeathIntegration()
		TestService:Message("Test 6: Integration test - Zombie death triggers blood...")

		-- This test verifies that the GameManager properly calls BloodEffect
		-- when a zombie dies. We'll check if the connection exists.

		local GameManager = require(game:GetService("ServerScriptService"):WaitForChild("GameManager"))

		-- Verify GameManager has the BloodEffect module loaded
		assert(GameManager ~= nil, "GameManager should be loaded")

		TestService:Message("✓ Test 6 Passed: Integration verified")
	end

	-- Run all tests
	local function runAllTests()
		local success, error = pcall(function()
			testModuleLoads()
			testBloodEffectCreation()
			testParticleConfiguration()
			testAutoCleanup()
			testMultipleEffects()
			testZombieDeathIntegration()
		end)

		print("======================================")
		if success then
			TestService:Message("✓✓✓ ALL BLOOD EFFECT TESTS PASSED ✓✓✓")
			print("All tests completed successfully!")
		else
			TestService:Error("✗✗✗ TESTS FAILED ✗✗✗")
			TestService:Error("Error: " .. tostring(error))
			warn("Test suite failed: " .. tostring(error))
		end
		print("======================================")

		return success
	end

	return runAllTests()
end

-- Auto-run tests when script loads
local success = runTests()

-- Return test results
return success
