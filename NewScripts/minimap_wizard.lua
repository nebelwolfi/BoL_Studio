--[[
        Script: MiniMap Wizard v3.0
]]

require "AllClass"

if not _miniMap__OnLoad() then return end

--[[      Code      ]]
function OnLoad()
	miniMap = {botLeft = {move = false, moveUnder = false}, topRight = {move = false, moveUnder = false}, saveUnder = false, pingTick = 0,}
	PrintChat(" >> MiniMap Wizard Setup: Hai! Follow the steps printed on your screen.")
	function miniMap.writeConfig()
		local file = io.open(_miniMap.configFile, "w")
		if file then
			file:write("_miniMap.offsets = {x1 = ".._miniMap.offsets.x1..", y1 = ".._miniMap.offsets.y1..", x2 = ".._miniMap.offsets.x2..", y2 = ".._miniMap.offsets.y2.." }")
			file:close()
		end
	end
	function OnTick()
		if not _miniMap.init then return end
		if not _miniMap__OnLoad() then
			PrintChat(" >> MiniMap Marks Wizard Setup: Config saved. Bye-bye! Thanks for using!")
			miniMap = nil
			return
		end
		-- walkaround OnWndMsg bug
		local shiftKeyPressed = IsKeyDown(16)
		if miniMap.botLeft.move then miniMap.botLeft.move = IsKeyDown(1) end
		if miniMap.topRight.move then miniMap.topRight.move = IsKeyDown(1) end
		local tick = GetTickCount()
		if miniMap.pingTick < tick then
			miniMap.pingTick = tick + 3000
			local map = GetMap()
			PingSignal(PING_FALLBACK,map.max.x-300,0,map.max.y-300,2)  -- top right corner
			PingSignal(PING_FALLBACK,map.min.x+300,0,map.min.y+300,2)  -- bottom left corner
		end
		if miniMap.topRight.move then
			_miniMap.offsets.x1 = GetCursorPos().x
			_miniMap.offsets.y1 = GetCursorPos().y
		elseif miniMap.botLeft.move then
			_miniMap.offsets.x2 = GetCursorPos().x
			_miniMap.offsets.y2 = GetCursorPos().y
		else
			miniMap.topRight.moveUnder = (shiftKeyPressed and CursorIsUnder(_miniMap.offsets.x1 - 5, _miniMap.offsets.y1 - 5, 10, 10))
			miniMap.botLeft.moveUnder = (shiftKeyPressed and CursorIsUnder(_miniMap.offsets.x2 - 5, _miniMap.offsets.y2 - 5, 10, 10))
			miniMap.saveUnder = (shiftKeyPressed and CursorIsUnder(550, 310, 45, 15))
		end
	end
	
	function OnWndMsg(msg,wParam)
		if msg == WM_LBUTTONDOWN then
			if miniMap.botLeft.moveUnder then miniMap.botLeft.move = true
			elseif miniMap.topRight.moveUnder then miniMap.topRight.move = true
			elseif miniMap.saveUnder then miniMap.writeConfig()
			end
		end	
	end
	
	function OnDraw()
		if not _miniMap.init then return end
		DrawText("Top Right:",14,300 - 60,200,0xFF80FF00)
		DrawText("Bottom Left:",14,300 - 85,225,0xFF80FF00)
		DrawText("Minimap Wizard Setup",17,350,170,0xFF80FF00)
		DrawText("Instructions:",17,350,200,0xFF80FF00)
		DrawText("These colored marks (t) and (b) are movable. Hold shift and left click to move it.",17,350,215,0xFF80FF00)
		DrawText("Right now two corners on your minimap are pinged with yellow circles.",17,350,230,0xFF80FF00)
		DrawText("You have to move each (t) and (b) to it's own corner:",17,350,245,0xFF80FF00)
		DrawText("Try to be as accurate as you can! Each mark must be in the center of the corner!",17,350,275,0xFF80FF00)
		DrawText("More accurate you are - more accurate marks in other scripts you'll get.",17,350,290,0xFF80FF00)
		DrawText("Hold shift and left click  >> ",17,350,310,0xFF80FF00)
		DrawText(" HERE ",17,550,310,0xFFFF0000)
		DrawText(" << when you're done!",17,600,310,0xFF80FF00)
		DrawText("o",31,_miniMap.offsets.x1-7,_miniMap.offsets.y1-13,0xFF000000)
		DrawText("t",14,_miniMap.offsets.x1-1,_miniMap.offsets.y1-4,0xFFFFFF00)
		DrawText("o",31,_miniMap.offsets.x2-7,_miniMap.offsets.y2-13,0xFF000000)
		DrawText("b",14,_miniMap.offsets.x2-2,_miniMap.offsets.y2-4,0xFFFF0000)
	end
end