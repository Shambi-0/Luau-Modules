--[[

MIT License

Copyright (C) 2022, Luc Rodriguez (Aliases : Shambi, StyledDev).

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

Source : https://github.com/Shambi-0/Luau-Modules/edit/main/Files/InverseKinematics.lua

--]]

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

-->> Usage Example <<--

local Plane : CFrame, ShoulderAngle : number, ElbowAngle : number = InverseKinematics(
	UpperTorso.CFrame * ShoulderOrigin,
	Target.Position, 0.515, 1.031
);

local ShoulderCFrame : CFrame = UpperTorso.CFrame:ToObjectSpace(Plane) * CFrame.Angles(ShoulderAngle, 0, 0);
local ElbowCFrame : CFrame = ElbowOrigin * CFrame.Angles(ElbowAngle, 0, 0);

-- NOTE : <UpperTorso>, <ShoulderOrigin>, <ElbowOrigin> and <Target>; are all not provided in this example.
