--[[ ---- Globals ---- ]]--
tblHerb = {}
tblHerb = {
  { name="Cinderbloom", xpac="cataclysm" },
  { name="Stormvine", xpac="cataclysm" },
  { name="Azshara's Veil", xpac="cataclysm" },
  { name="Heartblossom", xpac="cataclysm" },
  { name="Whiptail", xpac="cataclysm" },
  { name="Twilight Jasmine", xpac="cataclysm" },
}

tblAlchemy = {}
tblAlchemy = {
  { name="draught of war", itemnumber="93935", },
  { name="earthen potion", itemnumber="80478", },
  { name="ghost elixir", itemnumber="80477", },
  { name="deathblood venom", itemnumber="80479", },
  { name="elixir of the naga", itemnumber="80480", },
  { name="volcanic potion", itemnumber="80481", },
  { name="potion of illusion", itemnumber="80269", },
  { name="elixir of the cobra", itemnumber="80484", },
  { name="potion of concentration", itemnumber="80482", },
  { name="deepstone oil", itemnumber="80486", },
  { name="mysterious potion", itemnumber="80487", },
  { name="elixir of deep earth", itemnumber="80488", },
  { name="mighty rejuvenation potion", itemnumber="80490", },
  { name="elixir of impossible accuracy", itemnumber="80491", },
  { name="prismatic elixir", itemnumber="80492", },
  { name="mythical mana potion", itemnumber="80494", },
  { name="potion of the tol'vir", itemnumber="80495", },
  { name="transmute: living elements", itemnumber="78866", },
  { name="elixir of mighty speed", itemnumber="80493", },
  { name="golemblood potion", itemnumber="80496", },
  { name="elixir of the master", itemnumber="80497", },
  { name="mythical healing potion", itemnumber="80498", },
  { name="flask of enhancement", itemnumber="80724", },
  { name="flask of flowing water", itemnumber="94162", },
  { name="flask of steelskin", itemnumber="80719", },
  { name="lifebound alchemist stone", itemnumber="80508", },
  { name="flask of the draconic mind", itemnumber="80270", },
  { name="dream emerald", itemnumber="80251", },
  { name="flask of the winds", itemnumber="80721", },
  { name="flask of titanic strength", itemnumber="80723", },
  { name="ember topaz", itemnumber="80250", },
  { name="demonseye", itemnumber="80248", },
  { name="ocean sapphire", itemnumber="80246", },
  { name="amberjewel", itemnumber="80247", },
  { name="pyrium bar", itemnumber="80244", },
  { name="big cauldron of battle", itemnumber="92688", },
  { name="cauldron of battle", itemnumber="92643", },
  { name="potion of deepholm", itemnumber="80725", },
  { name="potion of treasure finding", itemnumber="80726", },
  { name="inferno ruby", itemnumber="80245", },
  { name="shadowspirit diamond", itemnumber="80237", },
  { name="truegold", itemnumber="80243", },
}

tblActiveListings = {}
tblListingHistory= {}
currency = {}
alertprefix = "<My Addon>"

--[[ ---- Functions ---- ]]--
-- Addon Chat Messages
function prefixChat(...)	
	print(alertprefix.." "..tostring(...))
end

-- Use the Auction Class to create an new auction object, load it with data and list the auction  --	
function add_Listing(itemname, listprice, long_listing, stack_size, other_vender_hi, other_vender_lo )
	-- locals --
	local counter = 0
	-- change case of input if needed 
	itemname = string.lower(itemname)

	if (type(itemname) or type(listprice)) == "nil" then return false end

	-- validate input match to alch dictionary 
	counter = #tblActiveListings + 1
	tblActiveListings[counter] = Auction:new()
	tblActiveListings[counter]:load(itemname,listprice,long_auction,stack_size,other_vender_hi,other_vender_lo)	
end



--[[  Auction Class  and associated methods  ]]--
Auction = {}
Auction.__index = Auction
function Auction:new()
	local self = {}
	setmetatable(self, Auction)
	self.name = "unknown"
	self.item = "unknown"
	self.quantity = 1
	self.stacksize = 1
	self.high = 0
	self.low = 0
	self.price = 0
	self.is_sold = false
	self.is_expired = false
	self.mail_collected = false
	self.time = os.time(now)
	self.expiretime = (os.time(now) + 1 * 24 * 3600)
	self.profile = "default"
	return self
end
function Auction:load(itemname,listprice,long_auction,stack_size,other_vender_hi,other_vender_lo)
	if long_auction then long_auction = 2 else long_auction = 1 end
	for i=1,#tblAlchemy do
		if string.find(tblAlchemy[i].name, itemname) then
			if ( type(stack_size) == "number" and stack_size < 20 ) then self.stacksize = stack_size end
			if other_vender_hi then self.high = other_vender_hi end
			if other_vender_lo then self.low = other_vender_lo end
			self.price = listprice
			self.name = tblAlchemy[i].name	
			self.item = tblAlchemy[i].itemnumber
			self.time = os.time(now)
			self.expiretime = (os.time(now) + long_auction * 24 * 3600)
			return true
		end
	end
	return false
end
function Auction:mailcollected()
	if self.is_expired == true then
		self.mail_collected = true
		return true
	else
		return false
	end
end
function Auction:expired()
  self.is_expired = true
end
function Auction:sold()
  self:expired()
  self.is_sold = true
end
function Auction:status()
	local endtime
	if self.is_sold == true then
		prefixChat( self.name.." has sold." ) 
	elseif self.is_expired == true and self.is_sold == false then
		prefixChat( self.name.." expired at "..os.date("%c",self.expiretime..".") )
	elseif  os.date((os.time(now))) >= os.date(self.expiretime) then
		self:expired()
		prefixChat( self.name.." expired at "..os.date("%c",self.expiretime)..", however you should check your mail to see if it sold or needs to be relisted.") 
	else 
		--[[ prefixChat( self.name.." will expire in "..(os.difftime(self.expiretime, (os.time(now))).." seconds.")) ]]--
		prefixChat( self.name.." will expire in "..string.format("%.2f",(self.expiretime - os.time(now))/3600).." hours.")
	end
end
function Auction:stats()
	local statstatement = ""
	if self.is_sold == true then
		statstatement = "Your auction of " ..self.name.." sold for "..self.price.."gold."
		if self.stacksize == 1 then statstatement = statstatement.."."
		elseif self.stacksize > 1 then statstatement = statstatement .."\nThat is "..string.format("%.2f",(self.price/self.stacksize)).."gold each."
		else 
			return prefixChat("The Cheat is very fine man")
		end	
	elseif self.is_expired == true and self.is_sold == false then
		statstatement = "Your auction of "..self.name.." was listed for "..self.price.." gold, expired and did not sell."
		if self.price > self.low and self.low ~= 0 then 
			statstatement = statstatement.."\nIt appears other auctions were selling for "..self.low..". Try undercutting them and selling for "..string.format("%.2f",(self.low*.90)).."."
		elseif self.price < self.low or (self.price > self.low and self.low == 0) then
			statstatement = statstatement.."\nTry lowering your price and selling for "..string.format("%.2f",(self.price*.90)).."."
		else	
			statstatement = statstatement
		end		
	else
		return prefixChat("Your auction was posted for "..self.price.." and is still going." )
	end
	return prefixChat(statstatement)
end