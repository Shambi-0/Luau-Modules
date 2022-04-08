--[[

MIT License

Copyright (C) 2021, Luc Rodriguez (Aliases : Shambi, StyledDev).

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

return (function(
	Time : number?, 
	Callback : ((...any) -> (...any)) | thread, 
	... : any
	
) : {
	Cancel : () -> ();
	Skip : () -> ();
	Finished : boolean;
	Arguments : {[number] : any?};
}
	
	local Input : string = typeof(Callback);
	if (Input ~= "function") and (Input ~= "thread") then
		error(string.format("Unexpected type \"%s\" for argument #1 of \"Delay\"."), 2);
	end;
	
	local Class : any? = {
		Arguments = {...};
		Finished = false;
	};
	Class.__index = Class;
	
	local function Activate()
		Class.Finished = true;
		
		if (Input == "function") then
			Callback(unpack(Class.Arguments));
		else
			coroutine.resume(Callback, unpack(Class.Arguments));
		end;
	end;
	
	local Thread : thread = task.delay(Time, Activate, ...);
	
	function Class:Cancel()
		task.cancel(Thread);
	end;
	
	function Class:Skip()
		self:Cancel();
		Activate();
	end;
	
	return (Class);
end);
