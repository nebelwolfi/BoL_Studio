--[[
	GetDistance2D Library by SurfaceS
	Version 0.1
]]--

function GetDistance2D( p1, p2 )
    if p1.z == nil or p2.z == nil then
		return math.sqrt((p1.x-p2.x)^2+(p1.y-p2.y)^2)
	else
		return math.sqrt((p1.x-p2.x)^2+(p1.z-p2.z)^2)
	end
end
