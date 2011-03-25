
 local msg = "Hey %s, what's up"
 function AutoReply(sender)
    SendChatMessage((msg:format(sender)),"WHISPER",nil, sender)
 end         
 local myEvent(self, event, msg, sender)
    if event == "CHAT_MSG_WHISPER" then
       AutoReply(sender)
    end 
 end


EMUframe = CreateFrame("Frame")
EMUframe:RegisterEvent("CHAT_MSG_WHISPER")
EMUframe:SetScript("OnEvent", myEvent)