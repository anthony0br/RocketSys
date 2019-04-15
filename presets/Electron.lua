stage1 = {
    name = 'stage1';
    model = nil;
    specificImpulseASL = 303;
    specificImpulseVac = 303;
    wetMass = 10200;
    dryMass = 950;
    burnRate = 60.9;
    dragCoefficient = Vector3.new(0.8, 0.8, 0.8)
}
stage2 = {
    name = 'stage2';
    model = nil;
    specificImpulseASL = 333;
    specificImpulseVac = 333;
    wetMass = 2300;
    dryMass = 250;
    burnRate = 6.1;
    dragCoefficient = Vector3.new(0.8, 0.8, 0.8)
}
fairing = {
    name = 'fairing';
    model = nil;
    specificImpulseASL = 0;
    specificImpulseVac = 0;
    wetMass = 50;
    dryMass = 50;
    burnRate = 0;
    dragCoefficient = Vector3.new(0.8, 0.25, 0.8)
}
