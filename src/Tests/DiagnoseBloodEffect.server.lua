-- DiagnoseBloodEffect.server.lua
-- Diagnostic script to identify why blood effects aren't showing
-- Place in ServerScriptService > Tests
-- This will run checks and print diagnostic information

local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("===========================================")
print("Blood Effect Diagnostic Tool")
print("===========================================")

task.wait(1)

-- Check 1: Verify folder structure
print("\n[1] Checking folder structure...")
local modules = ReplicatedStorage:FindFirstChild("Modules")
if modules then
	print("  ✓ Modules folder exists in ReplicatedStorage")
else
	warn("  ✗ ISSUE: Modules folder not found in ReplicatedStorage!")
	warn("    -> Create a folder named 'Modules' in ReplicatedStorage")
	return
end

-- Check 2: Verify BloodEffect module exists
print("\n[2] Checking BloodEffect module...")
local bloodEffectModule = modules:FindFirstChild("BloodEffect")
if bloodEffectModule then
	print("  ✓ BloodEffect module found")
	print("    -> Type: " .. bloodEffectModule.ClassName)
else
	warn("  ✗ ISSUE: BloodEffect module not found!")
	warn("    -> Make sure BloodEffect.lua is in ReplicatedStorage > Modules")
	warn("    -> The file should be a ModuleScript, not a regular Script")
	return
end

-- Check 3: Try to require the module
print("\n[3] Attempting to require BloodEffect...")
local success, BloodEffect = pcall(function()
	return require(bloodEffectModule)
end)

if success then
	print("  ✓ BloodEffect module loaded successfully")
else
	warn("  ✗ ISSUE: Failed to require BloodEffect module!")
	warn("    -> Error: " .. tostring(BloodEffect))
	return
end

-- Check 4: Verify module has CreateBloodEffect function
print("\n[4] Checking module functions...")
if BloodEffect.CreateBloodEffect then
	print("  ✓ CreateBloodEffect function exists")
else
	warn("  ✗ ISSUE: CreateBloodEffect function not found!")
	return
end

-- Check 5: Verify GameConfig exists
print("\n[5] Checking GameConfig...")
local gameConfig = modules:FindFirstChild("GameConfig")
if gameConfig then
	print("  ✓ GameConfig found")
	local cfg = require(gameConfig)
	if cfg.BloodEffect then
		print("  ✓ BloodEffect configuration exists")
		print("    -> ParticleCount: " .. cfg.BloodEffect.ParticleCount)
		print("    -> ParticleSize: " .. cfg.BloodEffect.ParticleSize)
		print("    -> ParticleLifetime: " .. cfg.BloodEffect.ParticleLifetime)
		print("    -> ParticleSpeed: " .. cfg.BloodEffect.ParticleSpeed)
	else
		warn("  ✗ ISSUE: BloodEffect config not found in GameConfig!")
	end
else
	warn("  ✗ ISSUE: GameConfig module not found!")
end

-- Check 6: Test creating a blood effect
print("\n[6] Testing blood effect creation...")
local testSuccess, testError = pcall(function()
	local GameConfig = require(modules:WaitForChild("GameConfig"))
	BloodEffect.CreateBloodEffect(Vector3.new(0, 50, 0), GameConfig.BloodEffect)
	print("  ✓ Blood effect created at position (0, 50, 0)")
	print("  -> Look up in the sky! You should see red particles falling")

	task.wait(1)

	-- Check if the effect part exists
	local effectPart = workspace:FindFirstChild("BloodEffectPart")
	if effectPart then
		print("  ✓ BloodEffectPart found in workspace")
		local particles = effectPart:FindFirstChild("BloodParticles")
		if particles then
			print("  ✓ ParticleEmitter found in BloodEffectPart")
			print("    -> Color: " .. tostring(particles.Color.Keypoints[1].Value))
			print("    -> Enabled: " .. tostring(particles.Enabled))
		else
			warn("  ✗ ParticleEmitter not found in BloodEffectPart!")
		end
	else
		warn("  ✗ BloodEffectPart not found in workspace!")
	end
end)

if not testSuccess then
	warn("  ✗ ISSUE: Failed to create blood effect!")
	warn("    -> Error: " .. tostring(testError))
end

-- Check 7: Verify GameManager is using BloodEffect
print("\n[7] Checking GameManager integration...")
local ServerScriptService = game:GetService("ServerScriptService")
local gameManagerScript = ServerScriptService:FindFirstChild("GameManager")
if gameManagerScript then
	print("  ✓ GameManager script found")
	print("  -> When zombies die, check console for 'Zombie died!' message")
	print("  -> Blood should appear at the zombie's position")
else
	warn("  ✗ GameManager script not found in ServerScriptService!")
end

print("\n===========================================")
print("Diagnostic Complete!")
print("===========================================")
print("\nIf all checks passed but you still don't see blood:")
print("1. Make sure you're killing zombies (not just watching)")
print("2. Check that zombies have a HumanoidRootPart")
print("3. Look at the zombie's position when it dies")
print("4. The blood particles are small - look carefully!")
print("5. Blood particles fall due to gravity - they appear briefly")
print("\nTo manually test, a blood effect was created at (0, 50, 0)")
print("Look up to see red particles falling!")
