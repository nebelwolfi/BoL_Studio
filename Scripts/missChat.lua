--[[
    Script: missChat Script v0.1
    Author: SurfaceS
	Goal : send SS to chat on your lane by pressing "0"
	
	Required libs : 		championLane, GetDistance2D
	Exposed variables : 	-

	v0.1				initial release
	v0.2				BoL Studio Version
]]

do
	local missChat = {
		HK = 96,			-- key 0 on keypad
	}
	if LIB_PATH == nil then LIB_PATH = debug.getinfo(1).source:sub(debug.getinfo(1).source:find(".*\\")):sub(2).."libs\\" end
	if championLane == nil then dofile(LIB_PATH.."championLane.lua") end
	if GetDistance2D == nil then dofile(LIB_PATH.."GetDistance2D.lua") end
	function missChat.sendLaneState()
		if championLane.myLane ~= "unknow" then
			local heroCount = #championLane.ennemy[championLane.myLane]
			local heroInLane = 0
			for i, hero in pairs(championLane.ennemy[championLane.myLane]) do
				if hero.visible and GetDistance2D(hero, championLane[championLane.myLane].point) < 3000 then heroInLane = heroInLane + 1
				elseif hero.dead then heroCount = heroCount - 1
				end
			end
			if heroCount ~= heroInLane then
				championLane[championLane.myLane].underSS = true
				SendChat("ss"..(heroCount > 1 and heroCount - heroInLane or "").." "..championLane.myLane)
			elseif championLane[championLane.myLane].underSS then
				championLane[championLane.myLane].underSS = false
				if heroCount > 0 then
					SendChat("re "..championLane.myLane)
				end
			end
		end
	end
	function OnTick()
		if IsKeyPressed(missChat.HK) then missChat.sendLaneState() end
	end
end