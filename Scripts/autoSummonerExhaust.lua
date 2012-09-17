--[[
	Script: Auto SummonerExhaust v0.2
	Author: SurfaceS

	required libs : 		-
	required sprites : 		-
	exposed variables : 	player
	
	v0.1 	initial release
	v0.2	BoL Studio Version
]]

do
	--[[ 		Globals		]]
	local autoSummonerExhaust = {
		castDelay = 0,
		active = false,
		activeTick = 0,
		range = 550,
		haveDisplay = true,		-- don't display chat
		activeKey = 84,			-- Press key to use autoSummonerExhaust mode (tTt by default)
	}
--[[ 		Code		]]
	function OnLoad()
		--[[            Conditional            ]]
		if player == nil then player = GetMyHero() end
		if string.find(player:GetSpellData(SUMMONER_1).name..player:GetSpellData(SUMMONER_2).name, "SummonerExhaust") ~= nil then
			if player:GetSpellData(SUMMONER_1).name == "SummonerExhaust" then
				autoSummonerExhaust.slot = SUMMONER_1
			elseif player:GetSpellData(SUMMONER_2).name == "SummonerExhaust" then
				autoSummonerExhaust.slot = SUMMONER_2
			end
			function autoSummonerExhaust.ready()
				if autoSummonerExhaust.slot ~= nil and autoSummonerExhaust.castDelay < GetTickCount() and player:CanUseSpell(autoSummonerExhaust.slot) == READY then return true end
				return false
			end
			function OnTick()
				local tick = GetTickCount()
				if IsKeyPressed(autoSummonerExhaust.activeKey) then
					if active == false and autoSummonerExhaust.haveDisplay == false then PrintChat(" >> Auto exhaust forced") end
					autoSummonerExhaust.active = true
					autoSummonerExhaust.activeTick = tick + 1000
				end
				if autoSummonerExhaust.active then
					if autoSummonerExhaust.ready() then
						local maxDPShero = nil
						local maxDPS = 0
						for i = 1, heroManager.iCount, 1 do
							local hero = heroManager:getHero(i)
							if hero ~= nil and hero.team ~= player.team and not hero.dead and hero.visible and player:GetDistance(hero) <= autoSummonerExhaust.range + 100 then
								local dps = hero.totalDamage * hero.attackSpeed
								if maxDPShero == nil or maxDPS < dps then
									maxDPS = dps
									maxDPShero = hero
								end
							end
						end
						if maxDPShero ~= nil then
							autoSummonerExhaust.active = false
							exhaust.castDelay = GetTickCount() + 500
							CastSpell(autoSummonerExhaust.slot, maxDPShero)
						end
					end
					if autoSummonerExhaust.activeTick < tick then autoSummonerExhaust.active = false end
				end
			end
		else
			autoSummonerExhaust = nil
		end
	end
end