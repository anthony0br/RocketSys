RunService = game:GetService('RunService')
rs = require(script.Parent['Rocket System III'].MainModule)

stage1 = {
    name = 'stage1';
    model = workspace.RocketStages.Stage1;
    specificImpulseASL =282;
    specificImpulseVac =311;
    wetMass = 410365.5;
    dryMass = 93490.5;
    burnRate = 1956;
	dragCoefficient = Vector3.new(0.8, 0.8, 0.8)
}
stage2 = {
    name = 'stage2';
    model = workspace.RocketStages.Stage2;
    specificImpulseASL = 348;
    specificImpulseVac = 348;
    wetMass = 137263.5;
    dryMass = 31638.5;
    burnRate = 266.1;
    dragCoefficient = Vector3.new(0.8, 0.8, 0.8)
}
fairing = {
    name = 'fairing';
    model = workspace.RocketStages.Fairing;
    specificImpulseASL = 0;
    specificImpulseVac = 0;
    wetMass = 1900;
    dryMass = 1900;
    burnRate = 0;
    dragCoefficient = Vector3.new(0.8, 0.25, 0.8)
}

local rocket, rocket2
RunService.Heartbeat:Connect(function()
	if rocket then
		rocket:update()
	end
	if rocket2 then
		rocket2:update()
	end
end)

rocket = rs.Rocket.new(stage1, stage2, fairing)
rocket.stages.stage1:setThrottle(1)
