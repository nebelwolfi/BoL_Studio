--[[
    Script: missChat Script v0.1
    Author: SurfaceS
	Goal : send SS to chat on your lane by pressing "0"
	
	Required libs : 		common, championLane
	Exposed variables : 	-

	v0.1				initial release
	v0.2				BoL Studio Version
]]

require "AllClass"

do
	local missChat = {
		HK = 96,			-- key 0 on keypad
		miss = {top = 0, mid = 0, bot = 0}
	}
	function missChat.sendLaneState()
		local myLane = CL:GetMyLane()
		if myLane ~= "unknow" then
			local heroArray = CL:GetHeroArray(myLane)
			local heroCount = #heroArray
			local heroInLane = 0
			local point = CL:GetPoint(myLane)
			for i, hero in pairs(heroArray) do
				if hero.visible and GetDistance(hero, point) < 3000 then heroInLane = heroInLane + 1
				elseif hero.dead then heroCount = heroCount - 1
				end
			end
			if heroCount > heroInLane then
				local miss = heroCount - heroInLane
				if missChat.miss[myLane] > miss then
					SendChat("re"..(heroCount > 1 and heroInLane or "").." "..myLane)
				elseif missChat.miss[myLane] < miss then
					SendChat("ss"..(heroCount > 1 and miss or "").." "..myLane)
				else
					SendChat("still under ss"..(heroCount > 1 and miss or "").." "..myLane)
				end
				missChat.miss[myLane] = miss
			elseif missChat.miss[myLane] > 0 then
				missChat.miss[myLane] = 0
				if heroCount > 0 then SendChat("re "..myLane) end
			end
		end
	end
	function OnTick()
		if IsKeyPressed(missChat.HK) then missChat.sendLaneState() end
		ChampionLane__OnTick()
	end
	function OnLoad()
		CL = ChampionLane()
	end
end