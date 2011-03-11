-- saved data object
AlamoData = {
	-- addon-controlled variables
	LastForm = nil,			-- Last form the player was in.  keeping this here prevents
							-- shapeshift messages from occurring when a player first logs in.
	
	-- player-controlled variables
	ChanceToSay = 30,		-- Percentage probability a shapeshift will be announced
	MessageSystem = "say",	-- Target message system (say, party, etc.)
	WhisperTargets = { } ,	-- People to whisper when your target message system is "Whisper"
	Debug = false,			-- Debug mode?  (enable debug output)
	Active = true,			-- On/Off switch for the addon
};

-- the addon's guts!
Alamo = {
	-- Metadata about the Alamo addon and its origins
	-- Version = "2.0";
	Version = "4.0.6";   -- I changed the version to match the current client -- Shift
	Author = "valanduil @ lightninghoof(alliance) - updated 02/02/07 by Tornik - Shdowsong EU (Horde) - updated by Tornik again 06/06/07 to add 	in more lines for various forms including Tree and Flight forms  - Ressurected from not working to working by Shift <Scions of Eternity> // Alexstrasza 03/05/11 by creating a frame to listen for events and hooking the onEvent to it." ;

	OnLoad = function()
		-- don't load this addon for any class other than Druid.
	   local _,playerClass = UnitClass("player");
		if (playerClass~="DRUID") then
			-- don't even bother saying we didn't load.  just pretend we don't exist.
			-- sum durids is 4 keeping their mouths shut when they play their alts.
			AlamoData.Active = false
			return;
		end;		

		-- Set up slash command handler
		SlashCmdList["AlamoCOMMAND"] = Alamo.SlashHandler;
		SLASH_AlamoCOMMAND1 = "/alamo";

		-- hooking this event lets us intercept shapeshifts (and a whole lot of other junk, too)
		--this:RegisterEvent("UNIT_MODEL_CHANGED");

		--grab the initial form information
		Alamo.debug("Setting initial form.");
		AlamoData.LastForm = Alamo.GetCurrentForm();
		Alamo.debug("Initial form set to "..Alamo.format(AlamoData.LastForm));

		Alamo.print("Alamo "..Alamo.Version.." is loaded, u nub LOL!");
	end;
	
	onEvent = function(self, event )
	
		if (event == "UNIT_AURA") then
			Alamo.debug("Alamo caught UNIT_AURA");
		
			-- check if this is a shapeshift
			local currentFormName = Alamo.GetCurrentForm();
			
			Alamo.debug("Checking for shapeshift: last form was "..Alamo.format(AlamoData.LastForm)..", current form is "..Alamo.format(currentFormName));
			
			if (currentFormName ~= AlamoData.LastForm) then
				Alamo.debug("Shapeshift detected.");
				
				-- this was an actual shapeshift.  remember the new form, 
				-- fire off a message to our target, and return
				AlamoData.LastForm = currentFormName;
				
				if (AlamoData.Active == false) then
					Alamo.debug("Not announcing shapeshift: addon is currently disabled.");
					return;
				else
					Alamo.debug("Announcing shapeshift.")
					Alamo.AnnounceForm(false);	
				end
								
			else
				-- we caught the event, but it wasn't a shapeshift.  probably changed armor or something.
				Alamo.debug("No shapeshift detected for this event.");
			end
		end
	end;
	
	AnnounceForm = function(forceAnnouncement, forcedFormName)
	
		local roll = math.random(1,100);

		if ((roll > (100 - AlamoData.ChanceToSay)) or forceAnnouncement==true) then
			Alamo.debug ("Rolled "..roll.." on chanceToSay "..AlamoData.ChanceToSay.."... Getting message.");
			local message = Alamo.GetShapeshiftMessage(forcedFormName);
		
			if (message == nil) then
				Alamo.debug("Not announcing shapeshift: problem fetching message.");
				return;
			end
		
			Alamo.debug ("Announcing shapeshift with message: "..message);
		
			if (AlamoData.MessageSystem == "whisper") then
				local whisperTargetCount = table.getn(AlamoData.WhisperTargets);
				
				if (whisperTargetCount == 0) then
					Alamo.debug("No whisper targets defined!");
					return;
				end
				
				for i=1, whisperTargetCount, 1 do
					local whisperTarget = AlamoData.WhisperTargets[i];
				
					-- this is wishful thinking.  there doesn't seem to be a good way to determine if a player is online,
					-- because the Who APIs appear to be asynchronous, and I'm not about to try dealing with that
					-- just to manage something as stupid as this addon.  i'll be happy to add it in if i learn how
					-- to do this synchronously one day.
					
--					if (not Alamo.playerIsOnline(whisperTarget)) then
--						Alamo.debug("Target "..whisperTarget.." cannot be whispered.");
--					else
						Alamo.debug("Whispering target "..whisperTarget);
						SendChatMessage(message, AlamoData.MessageSystem, nil, whisperTarget);
--					end		            					
				end
			else
				if (AlamoData.MessageSystem == "party") then
					if (GetNumPartyMembers() < 2) then
						Alamo.debug("No party members to message!");
						return;
					end
				elseif (AlamoData.MessageSystem == "raid") then
					if (GetNumRaidMembers() < 2) then
						Alamo.debug("No raid members to message!");
						return;
					end
				elseif (AlamoData.MessageSystem == "guild") then
					if (not IsInGuild()) then
						Alamo.debug("No guild to message!");
						return;
					end
				end
				
				Alamo.debug("Sending chat message to "..AlamoData.MessageSystem);
				
				SendChatMessage(message, AlamoData.MessageSystem);
			end

		else
			Alamo.debug ("Not announcing shapeshift: roll "..roll.." was too low for chanceToSay "..AlamoData.ChanceToSay);					
		end
	end;

	SlashHandler = function(msg)
		Alamo.debug("Got command: "..msg);
	
		local cmdArray = Alamo.textParse(string.lower(msg));
		
		local command = cmdArray[1];
		local arg1 = cmdArray[2];
		local arg2 = cmdArray[3];
		
		if (command=="debug") then
			if (arg1 == "on" or arg1 == "true") then
				AlamoData.Debug = true;
			elseif (arg1 == "off" or arg2 == "false") then
				AlamoData.Debug = false;
			elseif (not arg1) then
				-- toggle the debug state
				Alamo.print ("Toggling Alamo debug state.");
				AlamoData.Debug = not AlamoData.Debug;
			end
			
			Alamo.print("Alamo debug mode is now: "..Alamo.format(AlamoData.Debug));
			return;
			
		elseif (command=="on" or arg1 == "true") then
			AlamoData.Active = true;
			Alamo.print("Alamo is now active!");
			return;
		elseif (command=="off" or arg1 == "false") then
			AlamoData.Active = false;
			Alamo.print("Alamo is now inactive!");
			return;			
		elseif (command == "chance" and arg1 and tonumber(arg1)) then
			local chanceToSay = tonumber(arg1);
			
			if (chanceToSay < 0) then
				chanceToSay = 0;
			elseif (chanceToSay > 100) then
				chanceToSay = 100;
			end
			
			AlamoData.ChanceToSay = chanceToSay;
			
			Alamo.print("Alamo now has a "..AlamoData.ChanceToSay.."% chance of announcing a shapeshift.");
			
			return;
		elseif (command == "say" or command == "party" or command == "whisper" or command=="yell" or command=="guild" or command=="raid") then
			
			if (command == "whisper") then
				if (arg1) then
					if (arg1 == "clear") then
						-- clear the whisper target list
						Alamo.debug("Clearing the whisper target list.");
						AlamoData.WhisperTargets = { };
						Alamo.print("Whisper list cleared.")
						return;						
					elseif (arg1 == "add") then
						if (arg2) then
							-- add this whisper target
							Alamo.debug("Adding whisper target "..Alamo.format(arg2));
							Alamo.SetWhisperTarget(arg2, true);
						else
							Alamo.print("Please specify the player to add to the whisper list.");
						end
						
						return;
						
					elseif (arg1 == "remove") then
						if (arg2) then
							-- remove this whisper target
							Alamo.debug("Removing whisper target "..Alamo.format(arg2));
							Alamo.SetWhisperTarget(arg2, false);
						else
							Alamo.print("Please specify the player to remove from the whisper list.")
						end

						return;
					end
				end
			end			
		
			AlamoData.MessageSystem = command;
			Alamo.print("Alamo target message system is now ".. string.upper(AlamoData.MessageSystem));
			
			if (command == "whisper") then
				Alamo.PrintWhisperTargets(false);
			end
			
			return;			
		elseif (command == "force") then
			Alamo.debug("Forcing announcement!");
			Alamo.AnnounceForm(true, arg1);
			return;
		elseif (command == "info") then
			Alamo.PrintInfo();			
			return;
		end
		
		-- print usage if we didn't do anything else		
		Alamo.print("Usage:");
		Alamo.print("/alamo [on | off] - enables/disables Alamo");
		Alamo.print("/alamo debug <on | off> - toggles debug mode");
		Alamo.print("/alamo chance [0-100] - sets chance to announce");
		Alamo.print("/alamo [whisper | say | yell | party | guild | raid] - sets the announcement target");
		Alamo.print("/alamo whisper [add | remove | clear] targetName - add or remove a player as a whisper target, or clear the whisper target list");
		Alamo.print("/alamo force <cat | bear | moonkin | humanoid | aqua | travel | tree | flight> - force a statement for the current or specified form");
		Alamo.print("/alamo info - display info for the current session");
	end;
	
	PrintInfo = function()
		Alamo.print ("ALAMO version "..Alamo.Version.." is the fault of "..Alamo.Author);
		Alamo.print ("Active=".. Alamo.format(AlamoData.Active) ..", Debug="..Alamo.format(AlamoData.Debug)..", Chance="..AlamoData.ChanceToSay..", MessageSystem="..AlamoData.MessageSystem..", CurrentForm="..Alamo.format(AlamoData.LastForm));
		Alamo.PrintWhisperTargets(false);
	end;
	
	PrintWhisperTargets = function(isDebug)
		local msg = "Whisper targets are:";
		
		for key,value in AlamoData.WhisperTargets do
			msg = msg.." "..value;
		end

		if (isDebug) then
			Alamo.debug(msg);
		else
			Alamo.print(msg);
		end
	end;
	
	SetWhisperTarget = function(whisperTarget, isAdd)
		local target = string.lower(whisperTarget);

		for key,value in AlamoData.WhisperTargets do 
			if (value == target) then
				-- we found this value in the table.  were we adding it?
				if (isAdd == true) then
					-- we found the value, so we don't need to add it again.
					Alamo.print("Player "..whisperTarget.." is already in your whisper list!");
					return;
				else
					-- we found the value, and we need to remove it.
					table.remove(AlamoData.WhisperTargets, key);
					Alamo.print("Removed player "..whisperTarget.." from your whisper list.");
					return;
				end
			end
		end
		
		--we didn't find the value in the table.  were we supposed to add it?
		if (isAdd == true) then
			--add this value to the table.
			table.insert(AlamoData.WhisperTargets, table.getn(AlamoData.WhisperTargets)+1, target);
			Alamo.print("Player "..whisperTarget.." added to your whisper list.");
		else
			--this was a delete, but we didn't find the player in our list.
			Alamo.print("Player "..whisperTarget.." is not in your whisper list!");
		end
	end;

	GetCurrentForm = function()
--[[		local maxForms = GetNumShapeshiftForms();
		local currentFormIndex = 0;
		local currentFormName = nil;
		
		for i=1, maxForms, 1 do
			icon, name, active, castable = GetShapeshiftFormInfo(i);
			if (active ~= nil) then
				currentFormIndex = i;
				currentFormName = name;
			end
		end
		
		if (currentFormIndex == 0) then
			currentFormName = "Humanoid Form";
		end
		
		return currentFormName;
]]--	
		--[[ I think there's a better way to write this function ]]--
		local tshape = {}
		tshape = { 
			1="Cat Form",
			2="Tree of Life Form", 
			3="Travel Form",
			4="Aquatic Form", 
			5="Bear Form", 
			27="Flight Form", 
			31="Moonkin Form" 
		}
		id = GetShapeshiftFormID()
		return tshape[id] or "Humanoid Form"
		
	end;

	GetShapeshiftMessage = function(formName)
		local bearMessages = {
			"OK, Sum durids is bare. Tehm whos bare durids, can B 4 tank.",
			"Tehm whos bare durids, can B 4 tank.",
			"Man, sum bare druids can maek sum peeps poop in feer bc/ tehms so storng.",
			"A bare durid haf many armors & when a thing hits durid, maybe thing gets borken hand LOL!",
			"Bare durids is 4 funs when u can charje & stun & haf sum armors lol.",
			"ONE THING NOW IS BARES IS CAN DUNCE! DUN DUN DUN! LOL!",
			"IS YOU LIEK A NISE HOT CUP O MANGEL?"
		};

		local sealMessages = {
	    		"Seel is can fite, but is kind week.",
	    		"Seel for swim, is fast & dont breeth.",
	    		"When seel is gone for fish, is nobody will catch.",
	    		"Seel is can teech frends how is swim. FREE SWIMIN LESSINS LOL!"
		};

  		local cheetahMessages = {
	    		"dont \"cheet\" or u get bann LOL! JK!!",
	    		"Cheetuh can run fast and him is can run away frum trubul."
		};

		local moonkinMessages = {
	    		"Moonkins is look all funny liek maybe form MOON! LOL!",
	    		"mostly uh moonkin is 4 a spam moonfare",
	    		"Moonkin haf sum good armors & fite storng."
		};

  		local catMessages = {
  	    		"when cat durid is FITE do not ask for HEEL and NINIRVATE!",
			"I AM TELLS U B4: STORNG CAT DURID IS HAF NO NINERVATE OK!!! DRINK A POT NOOB LOL!!",	
  	    		"Is a cat durid for eat sum1's hed & stuff? OMG YES LOL!",
  	    		"OK now sum durid is cat. Cat durid, tehm dosent heel.  Cat uis for fite.",
  	    		"CAT DURIDS is no spam moonfare! Sum cat durids dosent no wut is uh moonfare!",
			"CAT DURID IS NOT SPEEK MOONFARE!",
			"cat durids is life on MANE street LOL!",
			"cat durids is love some mangel!"
		};

		local casterMessages = {
			"DURIDS IS VEERY FAST AND STORNG IN PVP CAN CAST ROOT 4 MAKE PEEPS STOP WHEN MOVE!!",
			"Maybe B4 durids was week & stuff but now Durids is very storng.",
	    		"DURIDS IS 4 haf FUN TIME WIT FRENS",
			"every1 is like a fun time durid!!",
	    		"Durids is storng for bare or cat or seel or WHATVER",
			"DURIDS IS ALWAYS FRENDS, SO PLAY NISE, OK?"
		};

		local treeMessages = {
			"TREE DURIDS IS HEEL, BUT DOSENT RUN! IS OK, DURID IS CAN HAF FAST RUN ANYWAY",
			"TREE DURID IS MAKE STORNG HOT! ONLY DONT GIT 2 CLOSE 2 FIRES LOL!",
	    		"MAYBE U NO SEUM PEEPS WHO IS DONT UNDERSTAND TREE DURID! U CAN TELL THEM SUMTHING SILLY!",
			"I HEER IN XPAC SOME DRUIDS IS TREE!"
	    	};

		local flightMessages = {
			"STORMCROW IS LIKE SHINY THING AND PECK AT EYES!",
			"B4 DURIDS IS CANT FLY, BUT NOW CAN EVEN POOP ON HEDS OF PEEPS LOL!"
	    	};

		local name;
		
		if (formName ~= nil) then
			name = string.lower(formName);
		else
			name = string.lower(AlamoData.LastForm);
		end

        if string.find(name, "bear") then
			return bearMessages[math.random(table.getn(bearMessages))];
        elseif string.find(name, "cat") then
 	    	return catMessages[math.random(table.getn(catMessages))];
        elseif string.find(name, "humanoid") then
 	    	return casterMessages[math.random(table.getn(casterMessages))];
        elseif string.find(name, "moonkin") then
		return moonkinMessages[math.random(table.getn(moonkinMessages))];
        elseif string.find(name, "travel") then
		return cheetahMessages[math.random(table.getn(cheetahMessages))];
        elseif string.find(name, "aqua") then
		return sealMessages[math.random(table.getn(sealMessages))];
        elseif string.find(name, "tree") then
		return treeMessages[math.random(table.getn(treeMessages))];
        elseif string.find(name, "flight") then
		return flightMessages[math.random(table.getn(flightMessages))];
	else
		Alamo.debug("Can't get shapeshift message: form \""..Alamo.format(name).."\" not recognized.");
		return nil;
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
    end;


	print = function(text)
		if(DEFAULT_CHAT_FRAME) then
			DEFAULT_CHAT_FRAME:AddMessage(text);
		end
	end;
   
	debug = function(text)
       if(AlamoData.Debug==true) then
           Alamo.print("|cffff0000ALAMO: "..text);
       end            
   end;	

	--Text Parsing. Yay!
	textParse = function(InputString)
	--[[ By FERNANDO!
		This function should take a string and return a table with each word from the string in
		each entry. IE, "Linoleum is teh awesome" returns {"Linoleum", "is", "teh", "awesome"}
		Some good should come of this, I've been avoiding writing a text parser for a while, and
		I need one I understand completely. ^_^

		If you want to gank this function and use it for whatever, feel free. Just give me props
		somewhere. This function, as far as I can tell, is fairly foolproof. It's hard to get it
		to screw up. It's also completely self-contained. Just cut and paste.]]
	   local Text = InputString;
	   local TextLength = 1;
	   local OutputTable = {};
	   local OTIndex = 1;
	   local StartAt = 1;
	   local StopAt = 1;
	   local TextStart = 1;
	   local TextStop = 1;
	   local TextRemaining = 1;
	   local NextSpace = 1;
	   local Chunk = "";
	   local Iterations = 1;
	   local EarlyError = false;

	   if ((Text ~= nil) and (Text ~= "")) then
	   -- ... Yeah. I'm not even going to begin without checking to make sure Im not getting
	   -- invalid data. The big ol crashes I got with my color functions taught me that. ^_^

	      -- First, it's time to strip out any extra spaces, ie any more than ONE space at a time.
	      while (string.find(Text, "  ") ~= nil) do
	         Text = string.gsub(Text, "  ", " ");
	      end

	      -- Now, what if text consisted of only spaces, for some ungodly reason? Well...
	      if (string.len(Text) <= 1) then
	         EarlyError = true;
	      end

	      -- Now, if there is a leading or trailing space, we nix them.
	      if EarlyError ~= true then
	        TextStart = 1;
	        TextStop = string.len(Text);

	        if (string.sub(Text, TextStart, TextStart) == " ") then
	           TextStart = TextStart+1;
	        end

	        if (string.sub(Text, TextStop, TextStop) == " ") then
	           TextStop = TextStop-1;
	        end

	        Text = string.sub(Text, TextStart, TextStop);
	      end

	      -- Finally, on to breaking up the goddamn string.

	      OTIndex = 1;
	      TextRemaining = string.len(Text);

	      while (StartAt <= TextRemaining) and (EarlyError ~= true) do
	         -- NextSpace is the index of the next space in the string...
	         NextSpace = string.find(Text, " ",StartAt);
	         -- if there isn't another space, then StopAt is the length of the rest of the
	         -- string, otherwise it's just before the next space...
	         if (NextSpace ~= nil) then
	            StopAt = (NextSpace - 1);
	         else
	            StopAt = string.len(Text);
	            LetsEnd = true;
	         end

	         Chunk = string.sub(Text, StartAt, StopAt);
	         OutputTable[OTIndex] = Chunk;
	         OTIndex = OTIndex + 1;

	         StartAt = StopAt + 2;

	      end
	   else
	      OutputTable[1] = "Error: Bad value passed to TextParse!";
	   end

	   if (EarlyError ~= true) then
	      return OutputTable;
	   else
	      return {"Error: Bad value passed to TextParse!"};
	   end
	end
};

--[[  
 --  I kept getting this error when registering the event (which I think the event doesnt exist anymore, anyhow).  I changed the listening event to UNIT_AURA per wowwiki, but the hook wasn't working at all. So
 --  I created this local alamoframe and registered the event to listen, then hooked it back to the Alamo table onEvent (rename was OnEvent, I changed the spelling with lowercase "o").  I'm an amateur at Lua and just
 --  wanted my friend, Tsukiyomi // Kargath, to have her favorite addon working again.  /cheer  -- Shìft <Scions of Eternity> // Alexstrasza US 
 --]]

local alamoframe = CreateFrame("Frame")   
alamoframe:RegisterEvent("UNIT_AURA")
alamoframe:SetScript("OnEvent", Alamo.onEvent)