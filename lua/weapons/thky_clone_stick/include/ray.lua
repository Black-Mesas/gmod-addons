local Extra = util

local function RayFilter(Hit)
	if Hit:IsPlayer() then
		return false
	end
	if Hit:IsConstraint() then
		return false
	end
	if Hit:IsConstrained() then
		return false
	end
	return true
end

return function(Origin,Direction)
	local Data =
	{
		start = Origin,
		endpos = Origin + (Origin + Direction),
		filter = RayFilter
	}
	
	return Extra.TraceLine(Data)
end
