--[[
	Script: Auto Ignite v0.2
	Author: SurfaceS

	required libs : 		-
	required sprites : 		-
	exposed variables : 	player
	
	v0.1 	initial release
	v0.2	BoL Studio Version
]]

--[[            Conditional            ]]
if player == nil then player = GetMyHero() end
if string.find(player:GetSpellData(SUMMONER_1).name..player:GetSpellData(SUMMONER_2).name, "SummonerDot") == nil then return end

--[[ 		Globals		]]
do
	local autoIgnite = {
		range = 600,
		baseDamage = 50,
		damagePerLevel = 20,
		castDelay = 0,
		haveDisplay = false,
		activeKey = 32,			-- Press key to use autoIgnite mode (space by default)
		toggleKey = 115,		-- Press key to toggle autoIgnite mode (F4 by default)
		forceIgniteKey = 84,	-- Press key to force ignite (tTt by default)
		active = false,
		toggled = false,
		forced = false,
		forcedTick = 0,
	}
--[[ 		Code		]]
	if player:GetSpellData(SUMMONER_1).name == "SummonerDot" then
		autoIgnite.slot = SUMMONER_1
	elseif player:GetSpellData(SUMMONER_2).name == "SummonerDot" then
		autoIgnite.slot = SUMMONER_2
	end

	function autoIgnite.ready()
		if autoIgnite.slot ~= nil and autoIgnite.castDelay < GetTickCount() and player:CanUseSpell(autoIgnite.slot) == READY then return true end
		return false
	end

	function autoIgnite.autoIgniteIfKill()
		if autoIgnite.ready() then
			autoIgnite.damage = autoIgnite.baseDamage + autoIgnite.damagePerLevel * player.level
			for i = 1, heroManager.iCount, 1 do
				local hero = heroManager:getHero(i)
				if hero ~= nil and hero.team ~= player.team and not hero.dead and hero.visible and player:GetDistance(hero) < autoIgnite.range and hero.health <= autoIgnite.damage then
					return autoIgnite.igniteTarget( hero )
				end
			end
		end
		return nil
	end

	function autoIgnite.autoIgniteLowestHealth()
		if autoIgnite.ready() then
			autoIgnite.damage = autoIgnite.baseDamage + autoIgnite.damagePerLevel * player.level
			local minLifeHero = nil
			for i = 1, heroManager.iCount, 1 do
				local hero = heroManager:getHero(i)
				if hero ~= nil and hero.team ~= player.team and not hero.dead and hero.visible and player:GetDistance(hero) <= autoIgnite.range then
					if minLifeHero == nil or hero.health < minLifeHero.health then
						minLifeHero = hero
					end
				end
			end
			if minLifeHero ~= nil then
				return autoIgnite.igniteTarget( minLifeHero )
			end
		end
		return nil
	end

	function autoIgnite.igniteTarget(target)
		if autoIgnite.ready() then
			CastSpell(autoIgnite.slot, target)
			autoIgnite.castDelay = GetTickCount() + 500
			return target
		end
		return nil
	end
	
	function OnWndMsg(msg,key)
		if msg == KEY_DOWN then
			if key == autoIgnite.toggleKey then
				autoIgnite.toggled = not autoIgnite.toggled
				autoIgnite.active = autoIgnite.toggled
				if autoIgnite.haveDisplay == false then PrintChat(" >> Auto ignite : "..(autoIgnite.active and "ON" or "OFF")) end
			elseif key == autoIgnite.forceIgniteKey then
				autoIgnite.forced = true
				autoIgnite.forcedTick = GetTickCount() + 1000
				if autoIgnite.haveDisplay == false then PrintChat(" >> Auto ignite forced") end
			elseif key == autoIgnite.activeKey then
				autoIgnite.active = true
			end
		elseif key == autoIgnite.activeKey and autoIgnite.toggled == false then
			autoIgnite.active = false
		end
	end

	function OnTick()
		if autoIgnite.forced then
			if autoIgnite.forcedTick > GetTickCount() then
				if autoIgnite.autoIgniteLowestHealth() ~= nil then autoIgnite.forced = false end
			else
				autoIgnite.forced = false
			end
		elseif autoIgnite.active then
			autoIgnite.autoIgniteIfKill()
		end
	end
end
