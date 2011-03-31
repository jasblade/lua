--[[  	
--	Shift <Scions of Eternity> / Alexstrasza 
--	FireFly Nerd Quoter
--	Mar2011
--]]

	SQD = {}
	SQD["lootchance"] = 10
	SQD["dechance"] = 5
	SQD["Debug"] = false  
	SQD["channel"] = "PARTY"
	
	fQuotes = {} 
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

do --[[ These functions work on getting quotes from the table ]]--
	findQuote = function(msg)
		debugprint("Running Find")
		for i=1,#fQuotes do
			--debugprint(fQuotes[i].quote)
			if string.match(strlower(msg), strlower(fQuotes[i].quote) ) then
				_, Next = getthisQuote(i) 
				--debugprint("match "..i.." Next:"..Next)
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
end
	


--[[ These are event handlers, in the form of a table and they auto-register once the table function is added ]]--	
SQDEvent = { }
SQDEvent["PLAYER_ENTERING_WORLD"] = function()
		print( UnitName("player").." has loaded in.")
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
			SendChatMessage(msg,SQD.channel)
		end
		debugprint( UnitName("player") .. "has looted money.\n" .. UnitName("player") .. " rolled "..chanceRand ..". Threshold is "..SQD.lootchance.."%")
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