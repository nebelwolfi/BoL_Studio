--[[
	Script: Auto SummonerBarrier v0.2
	Author: SurfaceS
	
	v0.1 	initial release
	v0.2	BoL Studio Version
]]

do
	--[[ 		Globals		]]
	local castDelay = 0
	local active = false
	local toggled = false
	local haveDisplay = true		-- don't display chat
	local activeKey = 32			-- Press key to use autoSummonerBarrier mode (space by default)
	local toggleKey = 114		-- Press key to toggle autoSummonerBarrier mode (F3/F4 by default based on slot)
	local minValue = 0.15		-- Minimum health ratio for using Barrier
	local slot

--[[ 		Code		]]
	local function ready()
		if slot ~= nil and castDelay < GetTickCount() and player:CanUseSpell(slot) == READY then return true end
		return false
	end
	
	function OnLoad()
		--[[            Conditional            ]]
		if string.find(player:GetSpellData(SUMMONER_1).name..player:GetSpellData(SUMMONER_2).name, "SummonerBarrier") ~= nil then
			if player:GetSpellData(SUMMONER_1).name == "SummonerBarrier" then
				slot = SUMMONER_1
			elseif player:GetSpellData(SUMMONER_2).name == "SummonerBarrier" then
				slot = SUMMONER_2
				toggleKey = toggleKey + 1
			end
			function OnWndMsg(msg,wParam)
				if msg == KEY_DOWN and wParam == toggleKey then
					toggled = not toggled
					active = toggled
					if haveDisplay == false then PrintChat(" >> Auto Barrier : "..(active and "ON" or "OFF")) end
				end
			end
			function OnTick()
				local tick = GetTickCount()
				if toggled == false then active = IsKeyDown(activeKey) end
				if active and ready() and player.health / player.maxHealth < minValue then
					CastSpell(slot)
					castDelay = tick + 300
				end
			end
		end
	end
end
