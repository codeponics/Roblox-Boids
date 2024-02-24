local boidModule = require(script.BoidsModule)

while true do
	for i = 1, 2 do
		boidModule:CreateBoid((workspace.Baseplate.CFrame * CFrame.new(0, workspace.Baseplate.Size.Y/2 + 100, 0)).Position + Vector3.new(math.random(1, 100), math.random(1, 100), math.random(1, 100)))
	end
	wait(1)
end