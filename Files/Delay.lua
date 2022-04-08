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
