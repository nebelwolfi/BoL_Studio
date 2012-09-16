--[[
	Script: Auto SummonerBarrier v0.2
	Author: SurfaceS

	required libs : 		-
	required sprites : 		-
	exposed variables : 	player
	
	v0.1 	initial release
	v0.2	BoL Studio Version
]]

--[[            Conditional            ]]
if player == nil then player = GetMyHero() end
if string.find(player:GetSpellData(SUMMONER_1).name..player:GetSpellData(SUMMONER_2).name, "SummonerBarrier") == nil then return end

--[[ 		Globals		]]
do
	local autoSummonerBarrier = {
		castDelay = 0,
		haveDisplay = true,
		activeKey = 32,			-- Press key to use autoSummonerBarrier mode (space by default)
		toggleKey = 114,		-- Press key to toggle autoSummonerBarrier mode (F3/F4 by default based on slot)
		minValue = 0.15,		-- Minimum health ratio for using Barrier
		active = false,
		toggled = false,
	}
--[[ 		Code		]]
	function autoSummonerBarrier.ready()
		if autoSummonerBarrier.slot ~= nil and autoSummonerBarrier.castDelay < GetTickCount() and player:CanUseSpell(autoSummonerBarrier.slot) == READY then return true end
		return false
	end

	function OnTick()
		local tick = GetTickCount()
		-- walkaround OnWndMsg error
		if IsKeyPressed(autoSummonerBarrier.toggleKey) then
			autoSummonerBarrier.toggled = not autoSummonerBarrier.toggled
			autoSummonerBarrier.active = autoSummonerBarrier.toggled
			if autoSummonerBarrier.haveDisplay == false then PrintChat(" >> Auto Barrier : "..(autoSummonerBarrier.active and "ON" or "OFF")) end
		end
		if autoSummonerBarrier.toggled == false then autoSummonerBarrier.active = IsKeyDown(autoSummonerBarrier.activeKey) end
		if autoSummonerBarrier.active and autoSummonerBarrier.ready() and player.health < autoSummonerBarrier.minValue then
			CastSpell(autoSummonerBarrier.slot)
			autoSummonerBarrier.castDelay = tick + 500
		end
	end
	
	function OnLoad()
		if player:GetSpellData(SUMMONER_1).name == "SummonerBarrier" then
			autoSummonerBarrier.slot = SUMMONER_1
		elseif player:GetSpellData(SUMMONER_2).name == "SummonerBarrier" then
			autoSummonerBarrier.slot = SUMMONER_2
			autoSummonerBarrier.toggleKey = autoSummonerBarrier.toggleKey + 1
		end
	end
end
