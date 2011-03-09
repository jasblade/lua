--[[ Shift_TimingLib.lua START     ]]--
local tasks = {}
local cancelledmsg = "Congrats everyone."

function AutoGratsTiming_Schedule(time, func, ...)
	local t = {...}
	t.func = func
	t.time = GetTime() + time
	table.insert(tasks, t)
end

function AutoGratsTiming_Unschedule(func, ...)
	for i = #tasks, 1, -1 do
		local val = tasks[i]
		if val.func == func then
			local matches = true
			for i = 1, select("#", ...) do
				if select(i, ...) ~= val[i] then 
					matches = false
					break
				end
			end
			if matches then
				table.remove(tasks, i)
			end
		end
	end
end


local function onUpdate(self, elapsed)
	for i = #tasks, 1, -1 do 
		local val = tasks[i]
		if val and val.time <= GetTime() and #tasks == 1 then  -- added task size check to see if too many grats are posted in the time interval
			table.remove(tasks, i)
			val.func(unpack(val))
		elseif #tasks > 1 then -- this should unschedule all sendchatmessage gratis and then use the alternate function
			table.wipe(tasks)
			AutoGratsTiming_Schedule(0, SendChatMessage, canelledmsg, ShiftAG_Channel)
		end
	end
end


local frame = CreateFrame("Frame")
local e = 0 
frame:SetScript("OnUpdate", function(self, elapsed)	
	e = e + elapsed
	if e >= 0.5 then
		e = 0
		return onUpdate(self, elapsed)
	end	
end)
