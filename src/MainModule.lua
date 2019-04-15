--[[
	Rocket System III: MainModule
	Authors: Sublivion
	Created: April 12 2019
	
	https://github.com/Sublivion/Rocket-System-III
--]]

--[[
	MIT License

	Copyright (c) 2019 Anthony O"Brien (Sublivion)
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
--]]


--[[
	DOCUMENTATION
	
	
	REQUIRE:
		
		rs = require(thisModule)
	
	
	CLASS ROCKET:
		
		CONSTRUCTOR:
		
			rs.Rocket.new(stage1, stage2, stage3, ...)
			
				ARGUMENTS:
					- stage: A table containing settings about each stage
				
				RETURNS:
					- Class "rocket", consisting of:
						- All methods and properties
						
				DOES:
					- Creates a welded clone of the stages in Workspace
					- Creates a main part to hold body movers
					- Creates BodyMovers
		
		
		METHODS:
		
			Rocket:update()
					
				DOES:
					- Updates BodyMovers
					- Updates sound
		
		
			Rocket.stages.stageName:setThrottle(t)
			
				ARGUMENTS:
					- t: The desired throttle as a decimal - 0 to 1
			
				DOES:
					- Updates the stages" throttle
					- Notifies script that throttle is changed
			
			
			Rocket.stages.stageName:separate(separateFrom)
			
				ARGUMENTS:
					- separateFrom: the rocket class to separate from
			
				DOES:
					- Breaks joints attaching the stage to the main part
					- Creates new rocket for the separated stage
				
				RETURNS:
					- New rocket class for the separated stage
					
					
			Rocket.stages.stageName:setThrustVector(orientation)
			
				ARGUMENTS:
					- orientation: the new orientation of the engines
				
				DOES:
					- Set the orientation of the engines to orientation to simulate thrust vectoring
	
					
	NOTES:
		- Rocket System III uses SI units - as opposed to imperial units found in v1 and v2
		- If your rocket is unbalanced, set asymmetrical parts to massless
		- The PrimaryPart of each stage should be set to the centremost engine nozzle
--]]

-- Constants
SCALE = 0.28 -- studs/meters
PLANET_MASS = 5.972E+24
PLANET_RADIUS = 6371E+3
DENSITY_ASL = 1.225
KARMAN_LINE = 100000
TEMPERATURE = 15
HUMIDITY = 0.75
MOVING_VELOCITY = 0.05
GRAVITY_CONSTANT = 6.673E-11
DIRECTION = Vector3.new(0, 1, 0)

-- Math functions
log = math.log
rad = math.rad
exp = math.exp
sin = math.sin
sqrt = math.sqrt
clamp = math.clamp
rabs = math.abs

-- Constructors
newInstance = Instance.new
V3 = Vector3.new
Cf = CFrame.new


-- Returns all of the parts inside of a model
function getParts(m)
	local t = {}
	for i,v in pairs(m:GetDescendants()) do
		if v:IsA("BasePart") then table.insert(t,v) end
	end
	return t
end

-- Returns the position of the centre of the model
function getModelCentre(model)
	local sX,sY,sZ
	local mX,mY,mZ
	for i, v in pairs(getParts(model)) do
		if v.Transparency ~= 1 then
			local pos = v.CFrame.p
			sX = (not sX and pos.x) or (pos.x < sX and pos.x or sX)
			sY = (not sY and pos.y) or (pos.y < sY and pos.y or sY)
			sZ = (not sZ and pos.z) or (pos.z < sZ and pos.z or sZ)
			mX = (not mX and pos.x) or (pos.x > mX and pos.x or mX)
			mY = (not mY and pos.y) or (pos.y > mY and pos.y or mY)
			mZ = (not mZ and pos.z) or (pos.z > mZ and pos.z or mZ)
		end
	end
	return V3((sX+mX)/2,(sY+mY)/2,(sZ+mZ)/2)
end

-- Returns the air density at a specific altitude
function getDensity(h)
    local t=(h<11000 and TEMPERATURE-((56.46+TEMPERATURE)*(h/11000))) or (h<25000 and -56.46) or -131.21+.00299*h
    local kpa=(h<11000 and 101.29*(((t+273.1)/288.08)^5.256)) or (h<25000 and 22.65*exp(1.73-.000157*h)) or 2.488*(((t+273.1)/216.6)^-11.388)
	return ((kpa/(.2869*(t+273.1)))*(1+HUMIDITY)/(1+(461.5/286.9)*HUMIDITY)) * DENSITY_ASL
end

-- Returns the Roblox mass of a container
function getMass(container)
	local mass = 0
	for i, v in pairs(getParts(container)) do
		mass = mass + v:GetMass()
	end
	return mass
end

-- Returns the air resistance on an object
function getDrag(density, velocity, area, coefficient)
	return (velocity * abs(velocity) * density) / 2 * area * coefficient
end

-- Returns the absolute version of a number or a vector
function abs(x)
	return typeof(x) == "number" and rabs(x) or "vector3" and V3(rabs(x.x), rabs(x.y), rabs(x.z))
end

-- Toggles engine effects
function toggleEngineEffects(container, isVal, val)
	for i, v in pairs(container:GetChildren()) do
		if v:IsA("Beam") or v:IsA("ParticleEmitter") then
			v.Enabled = isVal and val or not v.Enabled
		elseif v:IsA("Sound") then
			if (isVal and val) or not v.Playing then
				v:Play()
			end
		end
	end
end


-- Private Class Stage
do
	Stage = {}
	Stage.__index = Stage
	
	--[[
		Arguments:
			- tab: table including the settings for the stage
			
		Returns:
			- stage: a new stage object
	--]]
	function Stage.new(tab)
		local self = tab
		self.throttle = 0
		self.robloxMass = getMass(self.model)
		if not self.propellant or not self.mass then
			self.propellant = self.wetMass - self.dryMass
			self.mass = self.wetMass
		end
		setmetatable(self, Stage)
		return self
	end
	
	--[[
		Arguments:
			- rocket: the rocket to separate from
		
		Returns:
			- rocket: new rocket object featuring the original stage but physically separated
			  from the rocket
	--]]
	function Stage:separate(rocket)
		if rocket and rocket.model and rocket.model.PrimaryPart and rocket.stages[self.name] then
			self.model.PrimaryPart.StageConnector:Destroy()
			self.model.Parent = workspace
			rocket:removeStage(self.name)
		else
			warn("Argument 1 (rocket) invalid or nil in method :separate()")
		end
		
		return Rocket.new(self)
	end
	
	-- Sets attachment orientation
	function Stage:setThrustVector(orientation)
		self.model.PrimaryPart.Attachment.Orientation = orientation
	end
	
	-- Sets the throttle of the stage
	function Stage:setThrottle(t)
		self.throttle = t
		if t > 0 then
			toggleEngineEffects(self.model.PrimaryPart, true, true)
		else
			toggleEngineEffects(self.model.PrimaryPart, true, false)
		end
	end
end


-- Public Class Rocket
do
	Rocket = {}
	Rocket.__index = Rocket
	local dt = 0
	local lastTick = tick()
	
	--[[
		Arguments:
			- rocket: the rocket to separate from
		
		Returns:
			- rocket: new rocket object featuring the original stage but physically separated
			  from the rocket
	--]]
	function Rocket.new(...)
		local self = {}
		setmetatable(self, Rocket)
		
		-- Create model
		self.model = newInstance("Model")
		self.model.Name = "Rocket System III"
		
		-- Create stages
		local stages = {...}
		self.stages = {}
		for i, v in pairs(stages) do
			if v.name and v.model and v.specificImpulseASL and v.specificImpulseVac 
			and v.wetMass and v.dryMass and v.burnRate and v.dragCoefficient then
				if v.model.PrimaryPart then
					if not self.stages[v.name] then
						local stage = Stage.new(v)
						self.stages[v.name] = stage
						stage.model.Parent = self.model
					else
						warn("A stage with the name", v.name, "already exists.")
					end
				else
					warn("No PrimaryPart set for", v.name)
				end
			else
				warn("Incorrect stage configuration for", v.name and v.name or "an unnamed stage")
			end
		end
		
		-- Create PrimaryPart so stages can be connected
		self.model.PrimaryPart = newInstance("Part")
		self.model.PrimaryPart.Parent = self.model
		self.model.PrimaryPart.Name = "PrimaryPart"
		self.model.PrimaryPart.CFrame = CFrame.new(getModelCentre(self.model), DIRECTION)
		self.model.PrimaryPart.Transparency = 1
		self.model.PrimaryPart.CanCollide = false
		
		-- Create BodyGyro to balance rocket
		local gyro = Instance.new("BodyGyro")
		gyro.Parent = self.model.PrimaryPart
		
		-- Create welds and constraints
		for _, stage in pairs(self.stages) do
			for i, v in pairs(getParts(stage.model)) do
				if v ~= stage.model.PrimaryPart then
					v.Anchored = false
					local weld = newInstance("WeldConstraint")
					weld.Name = "RocketWeld"
					weld.Part0 = stage.model.PrimaryPart
					weld.Part1 = v
					weld.Parent = stage.model.PrimaryPart
				end
			end
			
			local weld = newInstance("WeldConstraint")
			weld.Name = "StageConnector"
			weld.Part1 = stage.model.PrimaryPart
			weld.Part0 = self.model.PrimaryPart
			weld.Parent = stage.model.PrimaryPart
			stage.model.PrimaryPart.Anchored = false
			
			local vf = newInstance("VectorForce")
			vf.Attachment0 = newInstance("Attachment")
			vf.Force = V3()
			vf.RelativeTo = Enum.ActuatorRelativeTo.World
			vf.Attachment0.Parent = stage.model.PrimaryPart
			vf.Parent = stage.model.PrimaryPart
		end
		
		self.model.Parent = workspace
		
		return self
	end
	
	-- Updates the rocket's body movers, sounds, and effects
	function Rocket:update()
		dt = tick() - lastTick
		lastTick = tick()
		local velocity = self.model.PrimaryPart.Velocity * SCALE -- m/s
		local altitude = self.model.PrimaryPart.CFrame.y * SCALE -- m
		local isMoving = velocity.Magnitude > MOVING_VELOCITY
		
		-- Get the frontal stage to calculate forward drag
		local frontalStage, highestStage, lowestStage, highestHeight, lowestHeight
		for i, v in pairs(self.stages) do
			if not highestHeight or v.model.PrimaryPart.CFrame.y > highestHeight then
				highestStage = v
				highestHeight = v.model.PrimaryPart.CFrame.y
			end
			if not lowestHeight or v.model.PrimaryPart.CFrame.y < lowestHeight then
				lowestStage = v
				lowestHeight = v.model.PrimaryPart.CFrame.y
			end
		end
		local forward = abs((self.model.PrimaryPart.CFrame.lookVector - velocity).magnitude) 
						<= ((-self.model.PrimaryPart.CFrame.lookVector - velocity).magnitude)
		frontalStage = forward and highestStage or lowestStage
		
		-- Iterate through stages to update each one
		local force = V3()
		for i, stage in pairs(self.stages) do			
			-- Calculate mass and propellant
			stage.propellant = clamp(stage.propellant - stage.burnRate * stage.throttle * dt, 0, stage.wetMass - stage.dryMass)
			stage.mass = stage.dryMass + stage.propellant
			
			-- Calculate thrust using the rocket equation
			local specificImpulse = ((altitude * stage.specificImpulseVac / KARMAN_LINE) + stage.specificImpulseASL) * stage.throttle
			local dv = clamp(stage.propellant, 0, 1) * (specificImpulse * log(stage.wetMass / stage.dryMass)) / (stage.mass / stage.dryMass)
			local thrust = dv *	stage.robloxMass * stage.model.PrimaryPart.CFrame.lookVector
			
			-- Calculate drag
			local density = getDensity(altitude)
			local eSize = stage.model:GetExtentsSize() * SCALE
			local xArea, zArea, yArea = eSize.x * eSize.y, eSize.z * eSize.y, eSize.z * eSize.x
			local drag = getDrag(density, velocity, V3(xArea, 0, zArea), stage.dragCoefficient)
			if stage == frontalStage then
				drag = drag + getDrag(density, velocity, V3(0, yArea, 0), stage.dragCoefficient)
			end
			
			-- Calculate gravity
			local orbitalSpeed = sqrt(GRAVITY_CONSTANT * PLANET_MASS) / (PLANET_RADIUS + altitude)
			local horizontalSpeed = sqrt(velocity.x^2, velocity.z^2)
			local ga = ((GRAVITY_CONSTANT * PLANET_MASS) / (PLANET_RADIUS + altitude)^2) * (horizontalSpeed - orbitalSpeed) / orbitalSpeed
			local gravity = Vector3.new(0, -(ga * stage.robloxMass), 0)
			
			-- Update VectorForce
			local idleForce = V3(0, workspace.Gravity * stage.robloxMass, 0)
			stage.model.PrimaryPart.VectorForce.Force = (idleForce + thrust) - (gravity + drag)
			force = force + stage.model.PrimaryPart.VectorForce.Force
		end
	end
	
	-- Used by :separate to ensure that separated stages are no longer simulated
	function Rocket:removeStage(stage)
		self.stages[stage] = nil
		self.model.PrimaryPart.CFrame = CFrame.new(getModelCentre(self.model), DIRECTION)
		print(CFrame.new(getModelCentre(self.model)))
	end
end


-- Exports
return {
	Rocket = Rocket
}
