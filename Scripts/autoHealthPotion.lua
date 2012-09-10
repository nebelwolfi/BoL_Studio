--[[
	Script: Auto Health Potion v0.1
	Author: SurfaceS

	required libs : 		inventory
	required sprites : 		-
	exposed variables : 	player, LIB_PATH and libs variables
	
	v0.1 	initial release
	v0.2 	BoL Studio Version
	Automatically take an health potion if your champ health drop under configurated percent
]]
if player == nil then player = GetMyHero() end

do
	--[[         Globals       ]]
	local healthPotion = {
		useTimer = 0,
		nextUpdate = 0,
		slot = nil,
		tickUpdate = 1000,		-- update potion slot each 1 sec
		minHpPercent = 0.25,	-- Minimum HP ratio for taking a pot
		itemID	= 2003,			-- item ID of health potion (2003)
	}
	
	--[[         Code          ]]
	-- Load inventory lib if needed
	if LIB_PATH == nil then LIB_PATH = debug.getinfo(1).source:sub(debug.getinfo(1).source:find(".*\\")):sub(2).."Libs\\" end
	if inventory == nil then dofile(LIB_PATH.."inventory.lua") end
	function healthPotion.checkHealthPotion()
		-- check Health Potion precence each seconds
		healthPotion.slot = inventory.slotItem(healthPotion.itemID)
	end
	function healthPotion.heroNeedPotion()
		if (player.health / player.maxHealth) > healthPotion.minHpPercent then return false end
		-- check if respawn, or already have a pot
		for i = 1, player.buffCount do
			local buff = player:getBuff(i)
			if buff == "Recall" then
				return false
			elseif buff == "RegenerationPotion" then
				healthPotion.useTimer = GetTickCount() + healthPotion.tickUpdate
				return false
			end
		end
		return true
	end
	function OnTick()
		if player.dead == true then return end
		local tick = GetTickCount()
		if tick > healthPotion.nextUpdate then
			healthPotion.nextUpdate = tick + healthPotion.tickUpdate
			healthPotion.checkHealthPotion()
		end
		if healthPotion.slot ~= nil and healthPotion.useTimer <= tick then
			if healthPotion.heroNeedPotion() and inventory.castItem(healthPotion.itemID) then
				healthPotion.useTimer = tick + healthPotion.tickUpdate
			end
		end
	end
end