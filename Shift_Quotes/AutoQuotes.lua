--table quotes
--defaults for avars
--do send out-msg
--do receive in-msg
--function table lookup and response


fQuotes = {}
fQuotes.[1] = { quote="Time for some thrilling heroics." , response= nil , starter = true}
fQuotes.[2] = { quote="Yes. Yes, this is a fertile land, and we will thrive" , response= 3 , starter = false }
fQuotes.[3] = { quote="We will rule over all this land, and we will call it... This land.", response = 4 , starter = false }
fQuotes.[4] = { quote= "I think we should call it...your grave!", response= 5 , starter = false }
fQuotes.[5] = { quote="Ah, curse your sudden but inevitable betrayal!" , response= 6, starter = false  }
fQuotes.[6] = { quote="Ha ha HA! Mine is an evil laugh...now die!" , response= nil , starter = false }
fQuotes.[7] = { quote="Ten percent of nuthin' is...let me do the math here...nuthin' into nuthin'...carry the nuthin'... ", response= nil , starter = true }
fQuotes.[8] = { quote="If anyone gets nosy, just...you know... shoot 'em.", response= 9 , starter = false }
fQuotes.[9] = { quote="Shoot 'em?" , response= 10 , starter = false }
fQuotes.[10] = { quote="Politely.", response= nil  , starter = false }

-- Defaults
channel = "SAY"


do
	local randnum = math.random(#fQuotes)
	
end