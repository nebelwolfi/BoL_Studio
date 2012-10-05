--[[
	Script: Auto Potion v0.2b
	Author: SurfaceS

	required libs : 		inventory
	required sprites : 		-
	exposed variables : 	player, LIB_PATH and libs variables
	
	v0.1 	initial release
	v0.2 	BoL Studio Version
	v0.2b 	added mana and Elixir
	Automatically take an health potion if your champ health drop under configurated percent
]]
if player == nil then player = GetMyHero() end
require "inventory"

do
	--[[         Globals       ]]
	local autoPotion = {
		tickUpdate = 1000,		-- update potion slot each 1 sec
		nextUpdate = 0,
		useTimer = 0,
		potions = {
			elixirOfFortitude = {
				slot = nil,
				minValue = 0.25,	-- Minimum HP ratio for taking an elixir
				itemID	= 2037,		-- item ID of Elixir Of Fortitude (2037)
				compareValue = function() return (player.health / player.maxHealth) end,
				buff = "PotionOfGiantStrength",
			},
			healthPotion = {
				slot = nil,
				minValue = 0.25,	-- Minimum HP ratio for taking a pot
				itemID	= 2003,		-- item ID of health potion (2003)
				compareValue = function() return (player.health / player.maxHealth) end,
				buff = "RegenerationPotion",
			},
			manaPotion = {
				slot = nil,
				minValue = 0.25,	-- Minimum Mana ratio for taking a pot
				itemID	= 2004,		-- item ID of mana potion (2004)
				compareValue = function() return (player.mana / player.maxMana) end,
				buff = "FlaskOfCrystalWater",
			},
		},
	}

	--[[         Code          ]]
	function autoPotion.castPotion(potion)
		if potion.slot ~= nil and potion.compareValue() < potion.minValue then
			-- check if respawn, or already have a pot
			for i = 1, player.buffCount do
				local buff = player:getBuff(i)
				if buff == "Recall" then
					return
				else
					if buff == potion.buff then
						return
					end
				end
			end
			if inventory.castItem(potion.itemID) then
				autoPotion.useTimer = GetTickCount() + autoPotion.tickUpdate
			end
		end
	end
	
	function OnTick()
		if player.dead == true then return end
		local tick = GetTickCount()
		local updateSlot = false
		if tick > autoPotion.nextUpdate then
			autoPotion.nextUpdate = tick + autoPotion.tickUpdate
			updateSlot = true
		end
		if tick > autoPotion.useTimer then
			for name,potion in pairs(autoPotion.potions) do
				if updateSlot then potion.slot = inventory.slotItem(potion.itemID) end
				autoPotion.castPotion(potion)
			end
		end
	end
end