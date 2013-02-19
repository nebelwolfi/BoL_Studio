--[[
	Script: Auto SummonerDot v0.3
	Author: SurfaceS
	v0.1 	initial release
	v0.2	BoL Studio Version
	v0.3	Reworked
]]

--[[ 		Globals		]]
do
	function OnLoad()
		if string.find(player:GetSpellData(SUMMONER_1).name..player:GetSpellData(SUMMONER_2).name, "SummonerDot") ~= nil then
			local key = 114
			if player:GetSpellData(SUMMONER_1).name == "SummonerDot" then
				slot = SUMMONER_1
			elseif player:GetSpellData(SUMMONER_2).name == "SummonerDot" then
				slot = SUMMONER_2
				key = 115
			end
			myConfig = scriptConfig("Summoner Heal", "summonerHeal")
			myConfig:addParam("ADotOnKey", "Auto Ignite key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			myConfig:addParam("ADot", "Perma Auto Ignite", SCRIPT_PARAM_ONKEYTOGGLE, true, key)
			myConfig:addParam("forcedDot", "Forced Ignite", SCRIPT_PARAM_ONKEYDOWN, false, 84)  --(tTt by default)
			castDelay = 0
			damagePerLevel = 20
			baseDamage = 50
			range = 600
			forced = false
			forcedTick = 0
			
			function autoIgniteIfKill()
				if slot ~= nil and castDelay < GetTickCount() and player:CanUseSpell(slot) == READY then
					local damage = baseDamage + damagePerLevel * player.level
					for i = 1, heroManager.iCount, 1 do
						local hero = heroManager:getHero(i)
						if ValidTarget(hero, range) and hero.health <= damage then
							return igniteTarget( hero )
						end
					end
				end
			end
			function autoIgniteLowestHealth()
				if slot ~= nil and castDelay < GetTickCount() and player:CanUseSpell(slot) == READY then
					local minLifeHero = nil
					for i = 1, heroManager.iCount, 1 do
						local hero = heroManager:getHero(i)
						if ValidTarget(hero, range) then
							if minLifeHero == nil or hero.health < minLifeHero.health then
								minLifeHero = hero
							end
						end
					end
					if minLifeHero ~= nil then
						return igniteTarget( minLifeHero )
					end
				end
			end
			function igniteTarget(target)
				if slot ~= nil and castDelay < GetTickCount() and player:CanUseSpell(slot) == READY then
					CastSpell(slot, target)
					castDelay = GetTickCount() + 500
					return target
				end
			end
			function OnTick()
				local tick = GetTickCount()
				if myConfig.forcedDot and (slot ~= nil and player:CanUseSpell(slot) == READY) then
					forced = true
					forcedTick = GetTickCount() + 2000
				end
				if forced then
					PrintFloatText(player,0,"Auto ignite forced")
					if autoIgniteLowestHealth() ~= nil or forcedTick < tick then
						forced = false
					end
				elseif myConfig.ADot or myConfig.ADotOnKey then
					autoIgniteIfKill()
				end
			end
		end
	end
end
