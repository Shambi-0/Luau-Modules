local Forward : Vector3 = Vector3.new(0, 0, -1);
local HalfPi : number = math.pi / 2;

local function InverseKinematics(Origin : CFrame, Target : Vector3, UpperLength : number, LowerLength : number) : (CFrame, number, number)
	local Localized : Vector3, Higher = Origin:pointToObjectSpace(Target), math.max(UpperLength, LowerLength);
	
	local Plane : CFrame = Origin * CFrame.fromAxisAngle(
		Forward:Cross(Localized.Unit), -- "Forward" Axis
		math.acos(-Localized.Unit.Z)                 -- Angle
	);
	
	if (Localized.Magnitude < Higher - math.min(UpperLength, LowerLength)) then
		return Plane * CFrame.new(0, 0, Higher - (LowerLength - UpperLength) - Localized.Magnitude), -HalfPi, math.pi;
		
	elseif (Localized.Magnitude > UpperLength + LowerLength) then
		return Plane * CFrame.new(0, 0, UpperLength + LowerLength - Localized.Magnitude), HalfPi, 0;
		
	else
		local UpperPower, LowerPower, MagnifiedPower = UpperLength ^ 2, LowerLength ^ 2, Localized.Magnitude ^ 2;
		local Theta = -math.acos((-LowerPower + UpperPower + MagnifiedPower) / (2 * UpperLength * Localized.Magnitude));
		
		return Plane, Theta + HalfPi, math.acos((LowerPower - UpperPower + MagnifiedPower) / (2 * LowerLength * Localized.Magnitude)) - Theta;
	end;
end;

-- Example :

local Plane : CFrame, ShoulderAngle : number, ElbowAngle : number = InverseKinematics(
	UpperTorso.CFrame * ShoulderOrigin, -- CFrame of the shoulder
	Target.Position, 0.515, 1.031
);

local ShoulderCFrame : CFrame = UpperTorso.CFrame:ToObjectSpace(Plane) * CFrame.Angles(ShoulderAngle, 0, 0);
local ElbowCFrame : CFrame = ElbowOrigin * CFrame.Angles(ElbowAngle, 0, 0);
