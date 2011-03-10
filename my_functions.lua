do --[[ Math Functions ]]--
	mymath = {}
	function mymath:print()
		for k,v in pairs(self) do
			print(tostring(k).."\t\t"..tostring(v))
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
		return (string.format("%.2f",(base + (base * (perc/100)))))
	end
	mymath.percDec = function(base, perc)
		return (string.format("%.2f",(base - (base * (perc/100)))))
	end
		

	mymath.perc = function(perc, val, result)
		local msg = "%.2f%% of %.2f is %.2f"
		-- same as WHAT perc OF val IS result
		if (perc) and (val) and not result then -- calc result
			result = tonumber((string.format("%.2f",((perc/100) * val))))
			return msg:format(perc, val, result)
			
		elseif (perc) and (result) and not (val) then -- calc Val
			val = string.format((result / (perc/100)))
			return msg:format(perc, val, result) 
			
		elseif (val) and (result) and not perc then -- calc %
			perc = string.format("%.2f",(result / (val)*100))
			return msg:format(perc, val, result)
		else
			return "usage: perc( PERCENTAGE, VALUE, RESULT ) \nEnter at least (2) values. Use \"nil\" for unknown values."
		end
	end
end

do --[[ US Dollar Conversions ]]--
	mymoney = {}
	mymoney.yen_to_dollar = function(yen) 
		return string.format("%.2f",(yen * 0.0122))
	end
end
	
do --[[ WoW Currency Conversion ]]--
	--[[ vars ]]--
	local currency = {}
	local money = {}


	--[[ Currency Math Methods ]]--
	-- Gold down to..
	function _g2s(gold)
		return gold * 100
	end
	function _g2c(gold)
		return gold * 10000
	end
	-- Silver to..
	function _s2c(silver)
		return silver * 100
	end
	-- Copper to..
	function _c2c(copper)
		return copper
	end



	-- Copper to Money
	function _c2m(copper)
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

	-- Silver to Money
	function _s2m(silver)
		g,s,c = _c2m(_s2c(silver))
		return tostring(g), tostring(s), tostring(c)
	end
	-- Gold to Money
	function _g2m(gold)
		g,s,c = _c2m(_g2c(gold))
		return tostring(g), tostring(s), tostring(c)
	end

	--[[ The Money to Copper Func... it accepts Money as a table or 3 strings of values...it's flexible, but not unbreakable ]]--
	--[[ .tables passed need to be arrays with 1=gold,2=silver,3=copper or be associative and use  "gold silver copper" or "g s c" as indices ]]--
	function _m2c(...)
		if select("#",...) == 3 then
			if (type(select(1,...)) == "string") and (type(select(2,...)) == "string") and (type(select(3,...)) == "string") then
				return (_g2c((select(1,...))) + _s2c((select(2,...))) + (select(3,...)))
			else
				return error("All values must be same type")
			end
		elseif select("#",...) == 1 then
			if (type(...) == "table")  then
				tblConver = {}
				tblConver = ...
				if (tblConver.g and tblConver.s and tblConver.c) then
					return (_g2c(tblConver.g) + _s2c(tblConver.s) + tblConver.c)
				elseif (tblConver.gold and tblConver.silver and tblConver.copper ) then
					return (_g2c(tblConver.gold) + _s2c(tblConver.silver) + tblConver.copper)
				elseif (type(tblConver[1]) == "number") and (type(tblConver[2]) == "number") (type(tblConver[3]) == "number") then
					return (_g2c(tblConver[1]) + _s2c(tblConver[2]) + tblConver[3])
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

do --[[ Printing Functions ]]--
	myprint = {}
	myprint.printlines = function(...)
		for i=1, select("#", ...) do
			print((select(i, ...)))
		end
	end
end