--[[  	
--	Shift <Scions of Eternity> / Alexstrasza 
--	FireFly Nerd Quoter
--	Mar2011
--]]
do --[[ Defaults and Quote table ]]--
	SQD = {}
	SQD["activestate"] = true
	SQD["Debug"] = false  
	SQD["channel"] = "PARTY"
	SQD["lootchance"] = 5
	SQD["dechance"] = 5
	SQD["leadchance"] = 60
	
end
do	
	fQuotes = {} 
--	fQuotes[] = { quote="" , response=nil, starter = true }
	fQuotes[1] = { quote="Time for some thrilling heroics." , response= nil , starter = true} 
	fQuotes[2] = { quote="Yes. Yes, this is a fertile land, and we will thrive" , response= 3 , starter = true } 
	fQuotes[3] = { quote="We will rule over all this land, and we will call it... This land.", response = 4 , starter = false } 
	fQuotes[4] = { quote= "I think we should call it...your grave!", response= 5 , starter = false } 
	fQuotes[5] = { quote="Ah, curse your sudden but inevitable betrayal!" , response= 6, starter = false  }  
	fQuotes[6] = { quote="Ha ha HA! Mine is an evil laugh...now die!" , response= nil , starter = false } 
	fQuotes[7] = { quote="Ten percent of nuthin' is...let me do the math here...nuthin' into nuthin'...carry the nuthin'... ", response= nil , starter = true } 
	fQuotes[8] = { quote="If anyone gets nosy, just...you know... shoot 'em.", response= 9 , starter = true } 
	fQuotes[9] = { quote="Shoot 'em?" , response= 10 , starter = false } 
	fQuotes[10] = { quote="Politely.", response= nil  , starter = false } 
	fQuotes[11] = { quote="Shiny!", response=nil , starter = true } 
	fQuotes[12] = { quote="I brought you some supper but if you'd prefer a lecture, I've a few very catchy ones prepped...sin and hellfire... one has lepers." , response=nil, starter = true }
	fQuotes[13] = { quote="Well, you were right about this being a bad idea." , response=14, starter = true }
	fQuotes[14] = { quote="Thanks for sayin', sir." , response=nil, starter = false }
	fQuotes[15] = { quote="We're not gonna die. We can't die, Bendis. You know why? Because we are so...very...pretty. We are just too pretty for God to let us die." , response=nil, starter = true }
	fQuotes[16] = { quote="Wash, we've got some local color happening. Your grand entrance would not go amiss right now." , response=nil, starter = true }
	fQuotes[17] = { quote="There's just an acre of you fellas, ain't there? This is why we lost, you know. Superior numbers." , response=18, starter = true }
	fQuotes[18] = { quote="Thanks for the re-enactment, sir." , response=nil, starter = false }
	fQuotes[19] = { quote="And Kaylee, what the hell's goin' on in the engine room? Were there monkeys? Some terrifying space monkeys maybe got loose?" , response=nil, starter = true }
	fQuotes[20] = { quote="These are stone killers, little man. They ain't cuddly like me." , response=nil, starter = true }
	fQuotes[21] = { quote="Do you know what the chain of command is here? It's the chain I go get and beat you with to show you who's in command." , response=nil, starter = true }
	fQuotes[22] = { quote="Proximity alert. Must be coming up on something." , response=23, starter = true }
	fQuotes[23] = { quote="Oh my god. What can it be? We're all doomed! Who's flying this thing!? Oh right, that would be me. Back to work." , response=nil, starter = false }
	fQuotes[24] = { quote="It's a real burn, being right so often." , response=nil, starter = true }
	fQuotes[25] = { quote="Seems odd you'd name your ship after a battle you were on the wrong side of." , response=26 , starter = true }
	fQuotes[26] = { quote="May have been the losing side. Still not convinced it was the wrong one." , response=nil, starter = false }
	fQuotes[27] = { quote="These girls have the most beautiful dresses. And so do I-- how 'bout that!" , response=28, starter = true }
	fQuotes[28] = { quote="Yeah, well, just be careful. We cheated Badger out of good money to buy that frippery, and you're supposed to make me look respectable" , response=29, starter = false }
	fQuotes[29] = { quote="Yessir, Captain Tight Pants." , response=nil, starter = false }
	fQuotes[30] = { quote="Okay, help me find our man; he's supposed to be older. Kind of stocky, wears a red sash crossways." , response=31, starter = true }
	fQuotes[31] = { quote="Why does he do that?" , response=32, starter = false }
	fQuotes[32] = { quote="Maybe he won the Miss Persephone pageant. Just help me look." , response=nil, starter = false }
--[[ these next two are not linked, but should be linked with an emote. i'll figure that one out later ]]--
	fQuotes[33] = { quote="Dear Diary...today I was pompous and my sister was crazy." , response=nil, starter = true }
	fQuotes[34] = { quote="Today, we were kidnapped by hill folk never to be seen again. It was the best day ever." , response=nil, starter = true }
--[[                                                                                                                                                    ]]--
	fQuotes[35] = { quote="Well, look at this! Appears we got here just in the nick of time. Whaddya suppose that makes us?" , response=36, starter = true }
	fQuotes[36] = { quote="Big damn heroes, sir." , response=37, starter = false }
	fQuotes[37] = { quote="Ain't we just!" , response=nil, starter = false }
end	
	
do --[[ These functions work on getting quotes from the table ]]--
	findQuote = function(msg)
		debugprint("Running Find")
		for i=1,#fQuotes do
			debugprint(fQuotes[i].quote)
			if string.match(strlower(msg), strlower(fQuotes[i].quote) ) then
				local _, Next = getthisQuote(i) 
				debugprint("match "..i.." Next:"..Next)
				if ( type(Next) ~= "nil" ) then 
					SendChatMessage(fQuotes[Next].quote, SQD.channel)
				end
				return
			end
		end
		debugprint("no match")
	end
	StartQuote = function()
		local randStart = math.random(#fQuotes)
		local exitFlag = false
		repeat 
			if fQuotes[randStart].starter == true then
				exitFlag = true
				return fQuotes[randStart].quote, fQuotes[randStart].response
			else
				randStart = randStart + 1
				if randStart > #fQuotes then
					randStart = 1
				end
			end
		until exitFlag == true
	end;
	
	getthisQuote = function(index)
		return fQuotes[index].quote, fQuotes[index].response
	end;
	
	getFullQuote = function()
		first, newLine = StartQuote()
		SendChatMessage( first, SQD.channel )
		if type(newLine) ~= "nil" then
			repeat 
				first, newLine = getthisQuote(newLine)
				SendChatMessage( first, SQD.channel  )
			until type(newLine) == "nil" 
		end
	end;
	

end

do --[[ These are helper functions, print, format, debug, timing ]]--
	print = function(text)
		if(DEFAULT_CHAT_FRAME) then
			DEFAULT_CHAT_FRAME:AddMessage(text);
		end
	end;
	
	debugprint = function(text)
		if SQD.Debug == true then
			print("|cffff0000<SHIFT> "..text);
		end
	end;


	format = function(oVar)
		if(oVar == nil) then 
			return "nil";
		elseif(type(oVar) == "table") then
			local i, v = next(oVar, nil);
			local ret = "{ ";
			while i do
				ret = ret .. Alamo.format(v) .. " ";
				i, v = next(oVar, i);
			end
			ret = ret .. "}";
			return ret;
		elseif(type(oVar)=="boolean") then
			if (oVar==false) then
				return "false";
			else
				return "true";
			end;
		else
		    return oVar;
		end
	end
end
	


--[[ These are event handlers, in the form of a table and they auto-register once the table function is added ]]--	
SQDEvent = { }

SQDEvent["PLAYER_ENTERING_WORLD"] = function()
		print( "|cffff0000<SHIFT> "..UnitName("player").." has loaded in.")
	end;
SQDEvent["CHAT_MSG_SAY"] = function(...)
		msg, author = ...
		debugprint( "Msg Received: " ..msg.." from: "..author)
		if author ~= UnitName("player") then
			findQuote(msg)
		end
	end;
SQDEvent["CHAT_MSG_PARTY"] = function(...)
		msg, author = ...
		debugprint( "Msg Received: " ..msg.." from: "..author)
		if author ~= UnitName("player") then
			findQuote(msg)
		end
	end;
SQDEvent["CHAT_MSG_PARTY_LEADER"] = function(...)
		msg, author = ...
		debugprint( "Leader Msg Received: " ..msg)
		if author ~= UnitName("player") then
			findQuote(msg)
		end
	end;
SQDEvent["CHAT_MSG_MONEY"] = function()
		chanceRand = math.random(100)
		if chanceRand <= SQD.lootchance then
			msg = getthisQuote(11)
			SendChatMessage(msg,"SAY")
		end
		debugprint( UnitName("player") .. "has looted money.\n" .. UnitName("player") .. " rolled "..chanceRand ..". Threshold is "..SQD.lootchance.."%")
	end;
SQDEvent["PARTY_LEADER_CHANGED"] = function()
		chanceRand = math.random(100)
		if chanceRand <= SQD.leadchance then
			msg = getthisQuote(21)
			SendChatMessage(msg,"PARTY")
		end
		debugprint( "Party Leader Changed.\n" .. UnitName("player") .. " rolled "..chanceRand ..". Threshold is "..SQD.lootchance.."%")
	end;
SQDEvent["CONFIRM_DISENCHANT_ROLL"] = function()
		chanceRand = math.random(100)
		if chanceRand <= SQD.dechance then
			msg = getthisQuote(7)
			SendChatMessage(msg,SQD.channel)
		end
		debugprint( UnitName("player") .. "has looted money.\n" .. UnitName("player") .. " rolled "..chanceRand ..". Threshold is "..SQD.dechance.."%")
	end;
	
onEvent = function(self, event, ...)
	SQDEvent[event](...)
end;
	
local SQDframe = CreateFrame("Frame")
for k,_ in pairs(SQDEvent) do
	SQDframe:RegisterEvent(k)
end
SQDframe:SetScript("OnEvent", onEvent)

SLASH_ShiftQuote1 = "/sq"
SLASH_ShiftQuote2 = "/firefly"

do --[[ This is for the slash handler ]]--
	-- globals for slash handler responses
	debugstate = "Debugging has been turned set to %s"
	-- functions needed for slash actions

	SlashCmdList["ShiftQuote"] = function(msg)
		local cmd, arg = string.split(" ", msg)
		cmd = cmd:lower()
		arg = arg:lower()
		if cmd == "on" then
			SQD.activestate = true
		elseif cmd == "off" then
			SQD.activestate = false
		elseif cmd == "debug" then
			if arg == "on" then 
				SQD.Debug = true
			else  
				SQD.Debug = false
			end
			print(msg:format(SQD.Debug) )
		end
	end
end
