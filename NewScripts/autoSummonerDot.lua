--[[
	Script: Auto SummonerDot v0.2
	Author: SurfaceS

	required libs : 		-
	required sprites : 		-
	exposed variables : 	player
	
	v0.1 	initial release
	v0.2	BoL Studio Version
]]

--[[ 		Globals		]]
require "AllClass"
do
	local autoSummonerDot = {
		range = 600,
		baseDamage = 50,
		damagePerLevel = 20,
		castDelay = 0,
		haveDisplay = false,
		activeKey = 32,			-- Press key to use autoSummonerDot mode (space by default)
		toggleKey = 114,		-- Press key to toggle autoSummonerDot mode (F3/F4 by default -> slot)
		forceIgniteKey = 84,	-- Press key to force ignite (tTt by default)
		active = false,
		toggled = false,
		forced = false,
		forcedTick = 0,
	}
--[[ 		Code		]]
	function OnLoad()
		--[[            Conditional            ]]
		if player == nil then player = GetMyHero() end
		if string.find(player:GetSpellData(SUMMONER_1).name..player:GetSpellData(SUMMONER_2).name, "SummonerDot") ~= nil then
			if player:GetSpellData(SUMMONER_1).name == "SummonerDot" then
				autoSummonerDot.slot = SUMMONER_1
			elseif player:GetSpellData(SUMMONER_2).name == "SummonerDot" then
				autoSummonerDot.slot = SUMMONER_2
				autoSummonerDot.toggleKey = autoSummonerDot.toggleKey + 1
			end
			function autoSummonerDot.ready()
				if autoSummonerDot.slot ~= nil and autoSummonerDot.castDelay < GetTickCount() and player:CanUseSpell(autoSummonerDot.slot) == READY then return true end
				return false
			end
			function autoSummonerDot.autoIgniteIfKill()
				if autoSummonerDot.ready() then
					local damage = autoSummonerDot.baseDamage + autoSummonerDot.damagePerLevel * player.level
					for i = 1, heroManager.iCount, 1 do
						local hero = heroManager:getHero(i)
						if hero ~= nil and hero.team ~= player.team and not hero.dead and hero.visible and player:GetDistance(hero) < autoSummonerDot.range and hero.health <= damage then
							return autoSummonerDot.igniteTarget( hero )
						end
					end
				end
				return nil
			end
			function autoSummonerDot.autoIgniteLowestHealth()
				if autoSummonerDot.ready() then
					local minLifeHero = nil
					for i = 1, heroManager.iCount, 1 do
						local hero = heroManager:getHero(i)
						if hero ~= nil and hero.team ~= player.team and not hero.dead and hero.visible and player:GetDistance(hero) <= autoSummonerDot.range then
							if minLifeHero == nil or hero.health < minLifeHero.health then
								minLifeHero = hero
							end
						end
					end
					if minLifeHero ~= nil then
						return autoSummonerDot.igniteTarget( minLifeHero )
					end
				end
				return nil
			end
			function autoSummonerDot.igniteTarget(target)
				if autoSummonerDot.ready() then
					CastSpell(autoSummonerDot.slot, target)
					autoSummonerDot.castDelay = GetTickCount() + 500
					return target
				end
				return nil
			end
			function OnWndMsg(msg,wParam)
				if msg == KEY_DOWN then
					if wParam == autoSummonerDot.forceIgniteKey and autoSummonerDot.ready() then
						if autoSummonerDot.forced == false and autoSummonerDot.haveDisplay == false then PrintChat(" >> Auto ignite forced") end
						autoSummonerDot.forced = true
						autoSummonerDot.forcedTick = GetTickCount() + 1000
					elseif wParam == autoSummonerDot.toggleKey then
						autoSummonerDot.toggled = not autoSummonerDot.toggled
						autoSummonerDot.active = autoSummonerDot.toggled
						if autoSummonerDot.haveDisplay == false then PrintChat(" >> Auto ignite : "..(autoSummonerDot.active and "ON" or "OFF")) end
					end
				end
			end
			function OnTick()
				local tick = GetTickCount()
				if autoSummonerDot.toggled == false then autoSummonerDot.active = IsKeyDown(autoSummonerDot.activeKey) end
				if autoSummonerDot.forced then
					if autoSummonerDot.forcedTick > tick then
						if autoSummonerDot.autoIgniteLowestHealth() ~= nil then autoSummonerDot.forced = false end
					else
						autoSummonerDot.forced = false
					end
				elseif autoSummonerDot.active then
					autoSummonerDot.autoIgniteIfKill()
				end
			end
		else
			autoSummonerDot = nil
		end
	end
end
