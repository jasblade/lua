 do --[[ Math Functions ]]--
	mymath = {}
	function mymath:print()
		for k,v in pairs(self) do
			print(tostring(k).."\t\t\t"..tostring(v))
		end
	end
	mymath.fac = function(n)
		if n==1 then 
			return 1
		else
			return n * fac(n-1)
		end
	end
		
	mymath.percInc = function(base, perc)
		if base and perc then
			return (string.format("%.2f",(base + (base * (perc/100)))))
		else
			print("Usage: percInc( BASE, PERCENTAGE )")
			return nil
		end
	end
	mymath.percDec = function(base, perc)
		if base and perc then
			return (string.format("%.2f",(base - (base * (perc/100)))))
		else
			print("Usage: percDec( BASE, PERCENTAGE )")
			return nil
		end
	end
		

	mymath.perc = function(perc, val, result, mytype)
		local msg = "%.2f%% of %.2f is %.2f"
		-- same as WHAT perc OF val IS result
		if (perc) and (val) and not result then -- calc result
			result = tonumber((string.format("%.2f",((perc/100) * val))))
			if mytype then
				return result
			else
				return msg:format(perc, val, result)
			end
			
		elseif (perc) and (result) and not (val) then -- calc Val
			val = tonumber(string.format((result / (perc/100))))
				if mytype then
				return val
			else
				return msg:format(perc, val, result)
			end
			
		elseif (val) and (result) and not perc then -- calc %
			perc = tonumber(string.format("%.2f",(result / (val)*100)))
			if mytype then
				return perc
			else
				return msg:format(perc, val, result)
			end
		else
			return "usage: perc( PERCENTAGE, VALUE, RESULT, BOOLEAN ) \nEnter at least (2) values. Use \"nil\" for unknown values.\nBy adding ARG4 boolean the result can be just a value and not a string."
		end
	end
end
do --[[ Printing Functions ]]--
	myprint = {}	
	function myprint:print()
		for k,v in pairs(self) do
			print(tostring(k).."\t\t\t"..tostring(v))
		end
	end
	myprint.printlines = function(...)
		for i=1, select("#", ...) do
			print((select(i, ...)))
		end
	end
	
	myprint.chat = function(text)
		if (DEFAULT_CHAT_FRAME) then
			DEFAULT_CHAT_FRAME:AddMessage(text);
		end
	end
	
	myprint.debug = function(text)
		if (DEBUG == true) then
			myprint.print("|cffff0000: "..text);
		end
	end
end

do --[[ print hooking ]]--
--[[	local old = print
	print = function(...)
		return old("The hooker says,", ...)
	end
--]]
end


do --[[ US Dollar Conversions ]]--
	mymoney = {}
	tblConv = { }
	tblConv[1] = { fname="US Dollar", symbol="USD", USD=1.0, CAD=0.9753, GBP=0.6182, EURO=0.7146, JPY=81.6485, INR=45.1514 }
	tblConv[2] = { fname="Canadian Dollar", symbol="CAD", CAD=1.0, USD=1.0253, GBP=0.6339, EURO=0.7327, JPY=83.7154, INR=45.8266 }
	tblConv[3] = { fname="European Union", symbol="EURO", USD=1.3394, CAD=1.3648, GBP=0.8651, EURO=1.0, JPY=114.2589, INR=63.3087 }
	tblConv[4] = { fname="British Pound", symbol="GBP", USD=1.6175, CAD=1.5776, GBP=1.0, EURO=1.1559, JPY=132.0705, INR=72.8676 }
	tblConv[5] = { fname="Japanese Yen", symbol="JPY", USD=0.0122, CAD=0.0119, GBP=0.0076, EURO=0.0088, JPY=1.0, INR=0.5711 }
	tblConv[6] = { fname="Indian Rupee", symbol="INR", USD=0.0221, CAD=0.02183, GBP=0.0137 , EURO=0.0158, JPY=1.7509, INR=1.0 }
	
	function mymoney.convert( ... )
--[[		for i=1, select("#",...) do
			if select(i, ...) then
				print( i .. " , is type " .. type(i) .. ". " )
			end
		end
]]--		
		currency, this, that = ... 
		local msg = "Your %.2f%s can be converted to %.2f%s"
		local bFlag = false 
		local convRate = 1
		if tonumber(currency) and not (type(this) == "nil" or type(that) == "nil" ) then
			this = string.upper(this)
			that = string.upper(that)
			for i=1, #tblConv do
				if tblConv[i].symbol == (this) then
					convRate = tblConv[i][that]
					bFlag = true
				end
			end
			if bFlag then
				outVal = ( currency * convRate) 
				return ( msg:format(currency, this, outVal,that) ) 
			end	
		elseif tonumber(currency) and ( type(this) == "nil" or type(that) == "nil" ) then
			randThis = math.random(1,#tblConv)
			randThat = math.random(1,#tblConv)
			
			this = tblConv[randThis].symbol
			that = tblConv[randThat].symbol
			
			for i=1, #tblConv do
				if tblConv[i].symbol == (this) then
					convRate = tblConv[i][that]
					bFlag = true
				end
			end
			if bFlag then
				outVal = ( currency * convRate) 
				return ( msg:format(currency, this, outVal,that) ) 
			end	
		else
			print("Usage: convert( CURRENCY, THIS, THAT )")
			for i=1,#tblConv do
				print( tblConv[i].symbol .."\t".. tblConv[i].fname ) 
			end
		end
	end
	
	function mymoney:print()
		for k,v in pairs(self) do
			print(tostring(k).."\t\t\t"..tostring(v))
		end
	end	
--[[ NO LONGER NEEDED
	mymoney.yen_to_dollar = function(yen) 
		if yen and tonumber(yen) then
			return string.format("%.2f",(yen * 0.0122))
		else
			print("Usage: yen_to_dollar( YEN )")
		end
	end
	mymoney.dollar_to_yen = function(dollar)
		if dollar and tonumber(dollar) then
			return string.format("%.2f",(dollar * 81.86))
		else
			print("Usage: dollar_to_yen( DOLLAR )")
		end
	end
--]]
end
	
do --[[ WoW Currency Conversion ]]--
	--[[ vars ]]--
	msg = "%sg %ss %sc"
	wowgold = {}
	function wowgold:print()
		for k,v in pairs(self) do
			print(tostring(k).."\t\t\t"..tostring(v))
		end
	end	

	--[[ Currency Math Methods ]]--
	
	function wowgold._g2s(gold) -- Gold down to..
		return gold * 100
	end
	function wowgold._g2c(gold) -- Gold down to..
		return gold * 10000
	end
	
	function wowgold._s2c(silver) -- Silver to..
		return silver * 100
	end
	
	function wowgold._c2c(copper) -- Copper to..
		return copper
	end
	
	function wowgold._c2m(copper) -- Copper to Money
		repeat 
			if copper >= 10000 then
				gold = string.format("%d",(copper/10000))
				copper = copper - ( gold * 10000)
			else 
				gold = 0 
			end
			if copper >= 100 then
				silver = string.format("%d",(copper/100))
				copper = copper - ( silver * 100 )
			else
				silver = 0
			end
		until ( copper < 100)
		
		--print (gold.."g", silver.."s", copper.."c")
		return tostring(gold), tostring(silver), tostring(copper)
	end

	
	function wowgold._s2m(silver) -- Silver to Money
		g,s,c = wowgold._c2m(wowgold._s2c(silver))
		return tostring(g), tostring(s), tostring(c)
	end
	
	function wowgold._g2m(gold) -- Gold to Money
		g,s,c = wowgold._c2m(wowgold._g2c(gold))
		return tostring(g), tostring(s), tostring(c)
	end

	--[[ The Money to Copper Func... it accepts Money as a table or 3 strings of values...it's flexible, but not unbreakable ]]--
	--[[ .tables passed need to be arrays with 1=gold,2=silver,3=copper or be associative and use  "gold silver copper" or "g s c" as indices ]]--
	function wowgold._m2c(...)
		if select("#",...) == 3 then
			if (type(select(1,...)) == "string") and (type(select(2,...)) == "string") and (type(select(3,...)) == "string") then
				return (wowgold._g2c((select(1,...))) + wowgold._s2c((select(2,...))) + (select(3,...)))
			elseif (type(select(1,...)) == "number") and (type(select(2,...)) == "number") and (type(select(3,...)) == "number") then
				return (wowgold._g2c( tonumber((select(1,...))) ) + wowgold._s2c( tonumber((select(2,...)))) + tonumber((select(3,...))))
			else
				return error("All values must be same type")
			end
		elseif select("#",...) == 1 then
			if (type(...) == "table")  then
				tblConver = {}
				tblConver = ...
				if (tblConver.g and tblConver.s and tblConver.c) then
					return (wowgold._g2c(tblConver.g) + wowgold._s2c(tblConver.s) + tblConver.c)
				elseif (tblConver.gold and tblConver.silver and tblConver.copper ) then
					return (wowgold._g2c(tblConver.gold) + wowgold._s2c(tblConver.silver) + tblConver.copper)
				elseif (type(tblConver[1]) == "number") and (type(tblConver[2]) == "number") (type(tblConver[3]) == "number") then
					return (wowgold._g2c(tblConver[1]) + wowgold._s2c(tblConver[2]) + tblConver[3])
				else
					return 0
				end
			else
				return 0 
			end
		else
			error("The Cheat is a fine young man")
		end
	end
end

