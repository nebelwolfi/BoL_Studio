--[[
	Script: Auto SummonerHeal v0.3
	Author: SurfaceS

	v0.1 	initial release
	v0.2	BoL Studio Version
	v0.3	Added Menu
]]

do
	function OnLoad()
		--[[            Conditional            ]]
		if string.find(player:GetSpellData(SUMMONER_1).name..player:GetSpellData(SUMMONER_2).name, "SummonerHeal") ~= nil then
			local key = 114
			if player:GetSpellData(SUMMONER_1).name == "SummonerHeal" then
				HL_slot = SUMMONER_1
			elseif player:GetSpellData(SUMMONER_2).name == "SummonerHeal" then
				HL_slot = SUMMONER_2
				key = 115
			end
			myConfig = scriptConfig("Summoner Heal", "summonerHeal")
			myConfig:addParam("forcedAH", "Forced Auto Heal", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			myConfig:addParam("AH", "Perma Auto Heal", SCRIPT_PARAM_ONKEYTOGGLE, true, key)
			myConfig:addParam("AHLifeRatio", "Heal Life ratio", SCRIPT_PARAM_SLICE, 0.15, 0, 1, 2)
			function OnTick()
				if (myConfig.AH or myConfig.forcedAH) and player:CanUseSpell(HL_slot) == READY and (player.health / player.maxHealth < myConfig.AHLifeRatio) then
					CastSpell(HL_slot)
				end
			end
		end
	end
end
