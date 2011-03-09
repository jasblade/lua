--[[
--   Shift Auto-Grats
--   Shift <Scions of Eternity> // Alexstrasza
--   Dec2010 // rewrite Mar2011
--]]

-- Globals that will be saved with the addon
ShiftAG_achieveTime = 2
ShiftAG_Channel = "GUILD"
ShiftAG_prefix = "[ShiftAutoGrats] "
ShiftAG_prefixState = "off"
cheertbl = {}
cheertbl[1] = "Congrats GUILDY."
cheertbl[2] = "Hey GUILDY, nice job on the achievement."


-- Declarations
local gmember =  nil
local AddonActive = "off"
do 
   function GetRdmCheer()
      local cheerNum = math.random(#cheertbl)
      return cheertbl[cheerNum]      
   end
end

do
   function GiveGrats(gmember)   -- send a grats to the scheduler with delay   
      local cheer = GetRdmCheer()
      cheer = ShiftAG_prefix .. cheer
      if ShiftAG_achieveTime >= 2  and gmember ~= UnitName("player")  then   
		SimpleTimingLib_Schedule(ShiftAG_achieveTime - 2, SendChatMessage, cheer:gsub("GUILDY",gmember), ShiftAG_Channel)		
      end         
   end
end


do 
	function cancelMessages()
		gmember = nil
		SimpleTimingLib_Unschedule(SendChatMessage)
		--SimpleTimingLib_Schedule(0, SendChatMessage, canelledmsg, ShiftAG_Channel)
	end
end

function onEvent(self, event, msg, gmember)
   if event == "CHAT_MSG_GUILD_ACHIEVEMENT" and AddonActive == "on" and gmember then
      GiveGrats(gmember)
   end
end

local sagframe = CreateFrame("Frame")
sagframe:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
sagframe:SetScript("OnEvent", onEvent)

SLASH_ShiftAutoGrats1 = "/shiftautograts"
SLASH_ShiftAutoGrats2 = "/sag"

do
	local setChannel = "Channel is now \"%s\""
	local setTime = "Time is now %s"
	local currChannel = "Channel is currently set to \"%s\""
	local currTime = "Time is currently set to %s"
	local currStatus = "Shift AutoGrats is %s"
	local cheertable = "List of all possible cheers"
	local addedToCheer = "\"%s\", was added to list of cheers."
	local removedFromCheer = "\"%s\", was removed from the list of cheers."
	local prefixState = "Shift Auto Grats addon prefix is %s."

	local function toggleMe(val)
		if val and val == "on" then
			val = "off"
			return val
		elseif val and val == "off" then
			val = "on"
			return val
		end
	end
        local function addToCheer(...)
		msg = ...
		table.insert(cheertbl,msg)
		print(addedToCheer:format(msg))
	end
	
	local function removeFromCheer(...)
		msg = ...
		if type(msg) == "string" then
			for i=#cheertbl, 1, -1 do
				if cheertbl[i] == msg then
					table.remove(cheertbl,i)
					print(removedFromCheer:format(msg))
				end
			end
		elseif type(msg) == "number"  then
			print(removedFromCheer:format(cheertbl[msg]))
			table.remove(cheertbl,msg)
		end
        end

	local function changePrefix(newprefix)
		if newprefix and type(newprefix) == "string" then
			ShiftAG_prefix = newprefix.." "
		end
	end
	SlashCmdList["ShiftAutoGrats"] = function(msg)
		local cmd, arg = string.split(" ", msg)
		cmd = cmd:lower()
		if cmd == "stop" then 
			cancelMessages()
		elseif cmd == "channel" then
			if arg then 
				ShiftAG_Channel = arg:upper()
				print(setChannel:format(ShiftAG_Channel))
			else
				print(currChannel:format(ShiftAG_Channel))
			end
		elseif cmd == "prefix" then
			ShiftAG_prefixState = toggleMe(ShiftAG_prefixState)
			if ShiftAG_prefixState == "off" then
				ShiftAG_prefix = ""
			else
				ShiftAG_prefix = "[ShiftAutoGrats] "
			end
			print(prefixState:format(ShiftAG_prefixState))
		elseif cmd == "time" then
			if arg and tonumber(arg) then
				ShiftAG_achieveTime = tonumber(arg)
				print(setTime:format(ShiftAG_achieveTime))
			else
				print(currTime:format(ShiftAG_achieveTime))
			end
		elseif cmd == "grats" then
			if not arg then
				print(cheertable)
				for k,v in pairs(cheertbl) do 
					print(tostring(k).." "..tostring(v))
				end
			elseif arg:lower() == "add" then
				msg = string.gsub(msg,"(%w+)(%s)(%w+)(%s)(.*)","%5")	
				addToCheer(msg)
			elseif arg:lower() == "remove" then
				msg = string.gsub(msg,"(%w+)(%s)(%w+)(%s)(.*)","%5")
				removeFromCheer(msg)
			end
		elseif cmd == "off" or cmd == "on" or cmd == "toggle" then
			if AddonActive == "on" and (cmd == "off" or cmd == "toggle") then
				AddonActive = "off"
				print(currStatus:format(AddonActive))
			elseif  AddonActive == "off" and (cmd == "on" or cmd == "toggle") then
				AddonActive = "on"
				print(currStatus:format(AddonActive))
			elseif  AddonActive == "on" and  cmd == "on" then
			   print(currStatus:format(AddonActive))
			elseif  AddonActive == "off" and  cmd == "off" then
			   print(currStatus:format(AddonActive))
			else
				print(currStatus:format(AddonActive))
			end
		end
	end
end