-- Classic style launch
-- By Sublivion

RunService = game:GetService('RunService')
rs = require(script.Parent['Rocket System III'].MainModule)

stage1 = {
	name = 'stage1';
	model = workspace.RocketStages.Stage1;
	specificImpulseASL = 275;
	specificImpulseVac = 304;
	wetMass = 150000;
	dryMass = 15000;
	burnRate = 750;
	dragCoefficient = Vector3.new(0.6, 0.7, 0.6)
}
stage2 = {
	name = 'stage2';
	model = workspace.RocketStages.Stage2;
	specificImpulseASL = 342;
	specificImpulseVac = 342;
	wetMass = 75000;
	dryMass = 10000;
	burnRate = 500;
	dragCoefficient = Vector3.new(0.6, 0.7, 0.6)
}
stage3 = {
	name = 'stage3';
	model = workspace.RocketStages.Stage3;
	specificImpulseASL = 0;
	specificImpulseVac = 0;
	wetMass = 2000;
	dryMass = 2000;
	burnRate = 0;
	dragCoefficient = Vector3.new(0.6, 0.1, 0.6)
}

rocket = rs.Rocket.new(stage1, stage2, stage3)
rocket.stages.stage1:setThrottle(1)

RunService.Heartbeat:Connect(function()
	rocket:update()
end)
