--[[ get player time and save it and toon name to global table ]]--

Shift_CTPlayerTime = {}

do -- Save time to table
	function recordTime(character_name, t_time)
		tbl_entry = { toon = character_name, total_time = t_time }
	end
end
