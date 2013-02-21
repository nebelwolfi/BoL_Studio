--[[
	Script: Auto Potion v0.2b
	Author: SurfaceS

	required libs : 		inventory
	required sprites : 		-
	exposed variables : 	player, LIB_PATH and libs variables
	
	v0.1 	initial release
	v0.2 	BoL Studio Version
	v0.2b 	added mana and Elixir
	v0.3 	reworked
	v0.4	added fountain
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
	
----------------------------------------------------------------------------
	--[[         should be in AllClass          ]]
	if InFountain == nil then
		function GetFountain()
			inshop, x, y, z, range = InShop()
			map = GetMap()
			if map.index == 1 then
				_radius = 1050
			else
				_radius = 750
			end
			if inshop ~= nil then
				shopPoint = Vector(x, y, z)
				for i = 1, objManager.maxObjects, 1 do
					local object = objManager:getObject(i)
					if object ~= nil and object.type == "obj_SpawnPoint" and GetDistance(shopPoint, object) < 1000 then
						return object
					end
				end
			end
		end
		function InFountain()
			return NearFountain()
		end
		function NearFountain(distance)
			assert(distance == nil or type(distance) == "number", "NearFontain: wrong argument types (<number> expected)")
			if not _fountain then
				local fountain = GetFountain()
				assert(fountain ~= nil, "InFontain: Could not get Fontain Coordinates")
				_fountain = { x = fountain.x, y = fountain.y, z = fountain.z }
			end
			if distance == nil then distance = _radius end
			return (GetDistance(_fountain) <= distance), _fountain.x, _fountain.y, _fountain.z, distance
		end
	end
----------------------------------------------------------------------------

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
	
	function OnLoad()
		map = GetMap()
		checkFountain = (map.index ~= 7) -- no heal in Proving Ground
	end
	
	function OnTick()
		if player.dead == true or (checkFountain and InFountain()) then return end
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