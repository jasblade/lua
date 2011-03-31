--globals
TWS = {}
TWS.Debug = false


SpellList = {}
SpellList[1] = {SpellName="Time Warp", msg="Do the time warp!"}
SpellList[2] = {SpellName="Polymorph", msg="Sheeping %s"}
SpellList[3] = {SpellName="Pain Suppression", msg="Pain Suppression on %s"}
SpellList[3] = {SpellName="Heroism", msg="GO HERO!"}


do
   function AnnounceSpell(msg)
	if ( GetNumRaidMembers() > 0 ) then
		SendChatMessage(msg, "RAID", nil)
	elseif (GetNumPartyMembers() > 0 ) then
		SendChatMessage(msg, "PARTY", nil)
	else
		SendChatMessage(msg, "EMOTE", nil)
	end
   end
end

do
	local name, realm
	name = UnitName("player")
	function eventHandler(self, event, ...)
		if (event == "PLAYER_ENTERING_WORLD" ) then
			TWS.myDebugPrint(name.." has loaded in." )
		end
		if (event == "UNIT_SPELLCAST_SENT") then
			whom, what, _, where = ...
			TWS.myDebugPrint(event.." "..whom.." "..what.." "..where)
			if whom == "player" then
				for i=1,#SpellList,1 do
					if what == SpellList[i].SpellName then
						AnnounceSpell(SpellList[i].msg:format(UnitName("target")))
					end
				end
			end
		end
	end 
end
	
local TWframe = CreateFrame("Frame")
TWframe:RegisterEvent("UNIT_SPELLCAST_SENT")
TWframe:RegisterEvent("PLAYER_ENTERING_WORLD")
TWframe:SetScript("OnEvent", eventHandler)

TWS.myDebugPrint = function(text)
	if(TWS.Debug==true) then
		print("|cffff0000TWS: ",text);
	end            
end	