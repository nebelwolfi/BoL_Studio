--[[
	Script: Auto SummonerBarrier v0.3
	Author: SurfaceS
	
	v0.1 	initial release
	v0.2	BoL Studio Version
	v0.3	Added Menu
]]

do
	function OnLoad()
		--[[            Conditional            ]]
		if string.find(player:GetSpellData(SUMMONER_1).name..player:GetSpellData(SUMMONER_2).name, "SummonerBarrier") ~= nil then
			local key = 114
			if player:GetSpellData(SUMMONER_1).name == "SummonerBarrier" then
				HL_slot = SUMMONER_1
			elseif player:GetSpellData(SUMMONER_2).name == "SummonerBarrier" then
				HL_slot = SUMMONER_2
				key = 115
			end
			myConfig = scriptConfig("Summoner Barrier", "SummonerBarrier")
			myConfig:addParam("forcedAB", "Forced Auto Barrier", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			myConfig:addParam("AB", "Perma Auto Barrier", SCRIPT_PARAM_ONKEYTOGGLE, false, key)
			myConfig:addParam("ABLifeRatio", "Barrier Life ratio", SCRIPT_PARAM_SLICE, 0.15, 0, 1, 2)
			function OnTick()
				if (myConfig.AB or myConfig.forcedAB) and player:CanUseSpell(HL_slot) == READY and (player.health / player.maxHealth < myConfig.ABLifeRatio) then
					CastSpell(HL_slot)
				end
			end
		end
	end
end