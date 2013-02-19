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

do
	--[[         Globals       ]]
	nextUpdate = 0
	useTimer = 0
	potions = {
		elixirOfFortitude = {
			slot = nil,
			nextUse = 0,
			isBuffed = false,
			minValue = 0.25,	-- Minimum HP ratio for taking an elixir
			itemID	= 2037,		-- item ID of Elixir Of Fortitude (2037)
			compareValue = function() return (player.health / player.maxHealth) end,
			buff = "PotionOfGiantStrengt",
		},
		crystalFlask = {
			slot = nil,
			nextUse = 0,
			isBuffed = true,
			minValue = 0.25,	-- Minimum HP/Mana ratio for taking a pot
			itemID	= 2041,		-- item ID of Crystaline Flask (2041)
			compareValue = function() return math.min(player.mana / player.maxMana,player.health / player.maxHealth) end,
			buff = "ItemCrystalFlask",
		},
		biscuit = {
			slot = nil,
			nextUse = 0,
			isBuffed = false,
			minValue = 0.25,	-- Minimum HP/Mana ratio for taking a pot
			itemID	= 2009,		-- item ID of Total Biscuit of Rejuvenation (2009)
			compareValue = function() return math.min(player.mana / player.maxMana,player.health / player.maxHealth) end,
			buff = "ItemMiniRegenPotion",
		},
		healthPotion = {
			slot = nil,
			nextUse = 0,
			isBuffed = false,
			minValue = 0.25,	-- Minimum HP ratio for taking a pot
			itemID	= 2003,		-- item ID of health potion (2003)
			compareValue = function() return (player.health / player.maxHealth) end,
			buff = "RegenerationPotion",
		},
		manaPotion = {
			slot = nil,
			nextUse = 0,
			isBuffed = false,
			minValue = 0.25,	-- Minimum Mana ratio for taking a pot
			itemID	= 2004,		-- item ID of mana potion (2004)
			compareValue = function() return (player.mana / player.maxMana) end,
			buff = "FlaskOfCrystalWater",
		},
	}
	
	--[[         Code          ]]
	function castPotion(potion)
		if potion.slot ~= nil and potion.compareValue() < potion.minValue then
			-- check if respawn, or already have a pot
			if TargetHaveBuff({"Recall", potion.buff}) then return end
			if CastItem(potion.itemID) then
				potion.nextUse = GetTickCount() + 5000
				if (not potion.isBuffed or TargetHaveBuff(potion.buff)) then
					useTimer = GetTickCount() + 2000
				else
					useTimer = GetTickCount() + 100
				end
			end
		end
	end

	function OnTick()
		if player.dead == true then return end
		local tick = GetTickCount()
		local updateSlot = false
		if tick > nextUpdate then
			nextUpdate = tick + 1000
			updateSlot = true
		end
		if tick > useTimer then
			for name,potion in pairs(potions) do
				if updateSlot then potion.slot = GetInventorySlotItem(potion.itemID) end
				if tick > potion.nextUse then
					castPotion(potion)
				end
			end
		end
	end
end