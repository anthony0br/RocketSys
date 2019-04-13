
stage1 = {
    name = 'stage1';
    model = nil;
    specificImpulseASL =282;
    specificImpulseVac =311;
    wetMass =410365.5;
    dryMass = 93490.5;  
    burnRate = 1,956;
dragCoefficient = Vector3.new(0.8,0.8, 0.8)
}
stage2 = {
    name = 'stage2';
    model = nil;
    specificImpulseASL = 348;
    specificImpulseVac = 348;
    wetMass = 137263.5;
    dryMass = 31638.5;
    burnRate = 266.1;
    dragCoefficient = Vector3.new(0.8, 0.8, 0.8)
}
fairing= {
    name = 'fairing';
    model = nil;
    specificImpulseASL = 0;
    specificImpulseVac = 0;
    wetMass = 1900;
    dryMass = 1900;
    burnRate = 0;
    dragCoefficient = Vector3.new(0.8, 0.25, 0.8)
}


