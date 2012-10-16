--[[
	Script: Auto SummonerHeal v0.2
	Author: SurfaceS

	required libs : 		-
	required sprites : 		-
	exposed variables : 	player
	
	v0.1 	initial release
	v0.2	BoL Studio Version
]]
require "AllClass"
--[[ 		Globals		]]
do
	local autoSummonerHeal = {
		castDelay = 0,
		haveDisplay = true,
		activeKey = 32,			-- Press key to use autoSummonerHeal mode (space by default)
		toggleKey = 114,		-- Press key to toggle autoSummonerHeal mode (F3/F4 by default based on slot)
		minValue = 0.15,		-- Minimum health ratio for using SummonerHeal
		active = false,
		toggled = false,
	}
--[[ 		Code		]]
	function OnLoad()
		--[[            Conditional            ]]
		if player == nil then player = GetMyHero() end
		if string.find(player:GetSpellData(SUMMONER_1).name..player:GetSpellData(SUMMONER_2).name, "SummonerHeal") ~= nil then
			if player:GetSpellData(SUMMONER_1).name == "SummonerHeal" then
				autoSummonerHeal.slot = SUMMONER_1
			elseif player:GetSpellData(SUMMONER_2).name == "SummonerHeal" then
				autoSummonerHeal.slot = SUMMONER_2
				autoSummonerHeal.toggleKey = autoSummonerHeal.toggleKey + 1
			end
			function autoSummonerHeal.ready()
				if autoSummonerHeal.slot ~= nil and autoSummonerHeal.castDelay < GetTickCount() and player:CanUseSpell(autoSummonerHeal.slot) == READY then return true end
				return false
			end
			function OnWndMsg(msg,wParam)
				if msg == KEY_DOWN and wParam == autoSummonerHeal.toggleKey then
					autoSummonerHeal.toggled = not autoSummonerHeal.toggled
					autoSummonerHeal.active = autoSummonerHeal.toggled
					if autoSummonerHeal.haveDisplay == false then PrintChat(" >> Auto heal : "..(autoSummonerHeal.active and "ON" or "OFF")) end
				end
			end
			function OnTick()
				local tick = GetTickCount()
				if autoSummonerHeal.toggled == false then autoSummonerHeal.active = IsKeyDown(autoSummonerHeal.activeKey) end
				if autoSummonerHeal.active and autoSummonerHeal.ready() and player.health / player.maxHealth < autoSummonerHeal.minValue then
					CastSpell(autoSummonerHeal.slot)
					autoSummonerHeal.castDelay = tick + 300
				end
			end
		else
			autoSummonerHeal = nil
		end
	end
end
