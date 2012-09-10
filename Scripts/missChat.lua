--[[
    Script: missChat Script v0.1
    Author: SurfaceS
	Goal : send SS to chat on your lane by pressing "0"
	
	Required libs : 		common, championLane
	Exposed variables : 	-

	v0.1				initial release
	v0.2				BoL Studio Version
]]

do
	require "common"
	require "championLane"
	local missChat = {
		HK = 96,			-- key 0 on keypad
	}
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
		championLane.OnTick()
	end
	function OnLoad()
		championLane.OnLoad()
	end
end