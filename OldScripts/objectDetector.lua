--[[
	Script: objectDetector v0.2
	Author: ...

	required libs : 		common
	required sprites : 		-
	exposed variables : 	only libs variables
	
	v0.1 	initial release
	v0.2	BoL Studio Edition
]]
do
	require "common"
	--[[         Config        ]]
	local objectDetector = {
		radius = 100, 			-- set your radius
		addKey = 0x6B,			-- "+ keypad" by default
		subKey = 0x6D,			-- "- keypad" by default
	}
	function OnDraw()
		local detected = 1
		DrawCircle(mousePos.x, mousePos.y, mousePos.z, objectDetector.radius, 0xFFFF0000)
		--DrawText("Tick = "..GetTickCount(), 14, 100, 700, 0xFFFF0000)
		DrawText("x = "..mousePos.x.." y = "..mousePos.y.." z = "..mousePos.z, 14, 100, 100, 0xFFFF0000)
		for i = 0, objManager.maxObjects do
			local obj = objManager:getObject(i)
			if obj ~= nil and GetDistance2D(obj, mousePos) < objectDetector.radius then
				DrawText(obj.type.." - "..obj.name, 14, 100, 100+(detected*10), 0xFFFF0000)
				detected = detected + 1
			end
		end
	end
	function OnTick()
		if IsKeyPressed(objectDetector.addKey) then objectDetector.radius = objectDetector.radius + 100 end
		if IsKeyPressed(objectDetector.subKey) then objectDetector.radius = math.max(0,objectDetector.radius - 100) end
	end
end