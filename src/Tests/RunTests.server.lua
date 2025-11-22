-- RunTests.server.lua
-- Simple test runner for BloodEffect tests
-- Place in ServerScriptService > Tests

print("===========================================")
print("Test Runner Started")
print("===========================================")

-- Wait a moment for all services to initialize
task.wait(2)

-- Run the BloodEffect tests
local success, result = pcall(function()
	return require(script.Parent:WaitForChild("BloodEffect.spec"))
end)

if not success then
	warn("Failed to run tests: " .. tostring(result))
else
	if result then
		print("✓ Test suite completed successfully")
	else
		warn("✗ Test suite reported failures")
	end
end
