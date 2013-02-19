--[[
	Script: Auto SummonerExhaust v0.3
	Author: SurfaceS

	v0.1 	initial release
	v0.2	BoL Studio Version
	v0.3	added menu
]]

do
	function OnLoad()
		if string.find(player:GetSpellData(SUMMONER_1).name..player:GetSpellData(SUMMONER_2).name, "SummonerExhaust") ~= nil then
			active = false
			activeTick = 0
			range = 550
			myConfig = scriptConfig("Exhaust Config", "summonerExhaust")
			myConfig:addParam("activeKey", "Activate key", SCRIPT_PARAM_ONKEYDOWN, false, 84) --(tTt by default)
			if player:GetSpellData(SUMMONER_1).name == "SummonerExhaust" then
				slot = SUMMONER_1
			elseif player:GetSpellData(SUMMONER_2).name == "SummonerExhaust" then
				slot = SUMMONER_2
			end
			function OnTick()
				if myConfig.activeKey and (slot ~= nil and player:CanUseSpell(slot) == READY) then
					if active == false then
						active = true
					end
					activeTick = GetTickCount() + 2000
				end
				if active then
					PrintFloatText(player,0,"Auto exhaust forced")
					if (slot ~= nil and player:CanUseSpell(slot) == READY) then
						local maxDPShero = nil
						local maxDPS = 0
						for i = 1, heroManager.iCount, 1 do
							local hero = heroManager:getHero(i)
							if ValidTarget(hero,range + 200) then
								local dps = hero.totalDamage * hero.attackSpeed
								if maxDPShero == nil or maxDPS < dps then maxDPS, maxDPShero = dps, hero end
							end
						end
						if maxDPShero ~= nil then
							active = false
							CastSpell(slot, maxDPShero)
						end
					end
					if activeTick < GetTickCount() then active = false end
				end
			end
		end
	end
end