local alignmentRadius = 100
local maxForce = Vector3.new(15000, 15000, 15000)
local removeTimer = 15
local AGENT_SPEED = 100
--
local boidsList = {}
local boids = {Boids = boidsList}
local RunService = game:GetService("RunService")
local boidObject = script.Parent.Boid
local boidSize = boidObject.Size

local boidsFolder = Instance.new("Folder")
boidsFolder.Name = "Boids"
boidsFolder.Parent = workspace

function boids:CreateBoid(v3)
	local newBoid = boidObject:Clone()
	newBoid.Name = "Boid"
	newBoid.Position = v3
	local BodyVelocity = Instance.new("BodyVelocity")
	BodyVelocity.Parent = newBoid
	BodyVelocity.MaxForce = maxForce
	boidsList[newBoid] = {BodyVel = BodyVelocity}
	
	newBoid.Parent = boidsFolder
	
	if removeTimer then
		game.Debris:AddItem(newBoid, removeTimer)
	end
	
	coroutine.wrap(function()
		local num = math.random(-10, 10)
		while newBoid and BodyVelocity do
			wait(0.1)
			local initialVelocity = boidVelocity(newBoid) or newBoid.CFrame.LookVector * math.clamp(math.noise(num, num, num) * AGENT_SPEED, -AGENT_SPEED, AGENT_SPEED)
			local velocity = initialVelocity 
			BodyVelocity.Velocity = velocity
			num = num + 0.05
		end
	end)()
end

local function computeAlignmentVelocity(agentObject)
	local vector = Vector3.new()
	local neighborCount = 0
	for boid, v in pairs(boidsList) do
		if boid ~= agentObject then
			if (agentObject.Position - boid.Position).Magnitude <= alignmentRadius then
				vector = boid.Velocity
				neighborCount = neighborCount + 1
			end
		end
	end
	if neighborCount > 0 then
		vector = vector/neighborCount
		vector = vector.Unit
	end
	return vector
end

local function computeCohesionVector(agentObject)
	local vector = Vector3.new()
	local neighborCount = 0
	local agentPosition = agentObject.Position
	for boid, v in pairs(boidsList) do
		if boid ~= agentObject then
			if (agentPosition - boid.Position).Magnitude <= alignmentRadius then
				vector = boid.Position
				neighborCount = neighborCount + 1
			end
		end
	end
	if neighborCount > 0 then
		vector = vector/neighborCount
		vector = vector - agentPosition -- get direction towards center of mass
		vector = vector.Unit -- convert to unit/normalized vector
	end
	return vector
end

local function computeSeparationVector(agentObject)
	local vector = Vector3.new()
	local neighborCount = 0
	local agentPosition = agentObject.Position
	for boid, v in pairs(boidsList) do
		if boid ~= agentObject then
			if (agentPosition - boid.Position).Magnitude <= alignmentRadius then
				vector = boid.Position - agentPosition
				neighborCount = neighborCount + 1
			end
		end
	end
	if neighborCount > 0 then
		vector = vector/neighborCount
		vector = -vector -- steer away from neighbors properly by making the vector negative
		vector = vector.Unit -- convert to unit/normalized vector
	end
	return vector
end

local function isZero(v3)
	return v3.X == 0 and v3.Y == 0 and v3.Z == 0 and true or false
end

local function normalizeTo(vector, normalizingValue)
	return vector.Unit * normalizingValue
end

local randomizer = 1
coroutine.wrap(function()
	local num = 0
	while true do
		num = num + 0.1
		randomizer = math.noise(num, num, num)
		wait(1.5)
	end
end)()

function boidVelocity(agent)
	local alignment = computeAlignmentVelocity(agent)
	local cohesion = computeCohesionVector(agent)
	local separation = computeSeparationVector(agent)
	
	local velocity = alignment + cohesion + separation
	
	if not isZero(velocity) then
		velocity = normalizeTo(velocity, AGENT_SPEED) * randomizer
		
		--velocity = Vector3.new(math.clamp(velocity.X, -1000, 1000), math.max(0, velocity.Y), math.clamp(velocity.Z, -1000, 1000))
	else
		velocity = nil
	end
	
	return velocity
	
	--[[velocity = velocity.X + alignment.X * alignmentWeight + cohesion.X * cohesionWeight + separation.X * separationWeight
	velocity = velocity * alignmentWeight + cohesion * cohesionWeight + separation * separationWeight]]
end

return boids