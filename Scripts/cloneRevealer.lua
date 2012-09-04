--[[
	Script: cloneRevealer v0.1
	Author: Mistal

	required libs : 		gameOver
	required sprites : 		-
	exposed variables : 	player, LIB_PATH and lib ones
	
	v0.1 	initial release
	v0.2	BoL Studio Version
	
	Displays the original enemy with a circle for enemies who can clone
]]

--[[            Globals         ]]
if player == nil then player = GetMyHero() end

--[[            Code            ]]
do
	local cloneRevealer = {
		heros = {},
		charNameToShow = {"Shaco", "LeBlanc", "MonkeyKing", "Yorick"}
	}
	function OnLoad()
		for index,charName in pairs(cloneRevealer.charNameToShow) do
			for i = 1, heroManager.iCount do 
				local hero = heroManager:getHero(i)
				if hero ~= nil and hero.team ~= player.team and hero.charName == charName then
					table.insert(cloneRevealer.heros, hero)
				end
			end
		end
		if #cloneRevealer.heros > 0 then
			if LIB_PATH == nil then LIB_PATH = debug.getinfo(1).source:sub(debug.getinfo(1).source:find(".*\\")):sub(2).."libs\\" end
			if gameOver == nil then dofile(LIB_PATH.."gameOver.lua") end
			gameOver.OnLoad()
			function OnDraw()
				if gameOver.gameIsOver() == true then return end
				for index,hero in pairs(cloneRevealer.heros) do
					if hero.dead == false and hero.visible then DrawCircle(hero.x, hero.y, hero.z, 100, 0xFFFFFF) end
				end
			end
		else
			cloneRevealer = nil
		end
	end
end