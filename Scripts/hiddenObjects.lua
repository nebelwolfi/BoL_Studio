--[[
	Script: Hidden Objects Display v0.3
	Author: SurfaceS
	
	required libs : 		
	required sprites : 		Hidden Objects Sprites (if used)
	exposed variables : 	hiddenObjects
	
	UPDATES :
	v0.1				initial release
	v0.1b				change spells names for 3 champs (thx TRUS)
	v0.1c				change spells names for teemo
	v0.1d				fix the perma show
	v0.2				BoL Studio Version
	v0.3				Reworked
	-- todo : maybe add zira ?
	
	USAGE :
	Hold shift key to see the hidden object's range.
]]

do
		--[[      CONFIG      ]]
		showOnMiniMap = true			-- show objects on minimap
		useSprites = false				-- show sprite on minimap
		--[[      GLOBAL      ]]
		objectsToAdd = {
			{ name = "VisionWard", objectType = "wards", spellName = "VisionWard", charName = "VisionWard", color = 0x00FF00FF, range = 1450, duration = 180000, sprite = "yellowPoint"},
			{ name = "SightWard", objectType = "wards", spellName = "SightWard", charName = "SightWard", color = 0x0000FF00, range = 1450, duration = 180000, sprite = "greenPoint"},
			{ name = "ItemGhostWard", objectType = "wards", spellName = "VisionWard", charName = "SightWard", color = 0x0000FF00, range = 1450, duration = 180000, sprite = "greenPoint"},
			{ name = "ItemMiniWard", objectType = "wards", spellName = "VisionWard", charName = "SightWard", color = 0x00FF00FF, range = 1450, duration = 60000, sprite = "greenPoint"},
			{ name = "WriggleLantern", objectType = "wards", spellName = "WriggleLantern", charName = "WriggleLantern", color = 0x0000FF00, range = 1450, duration = 180000, sprite = "greenPoint"},
			{ name = "Jack In The Box", objectType = "boxes", spellName = "JackInTheBox", charName = "ShacoBox", color = 0x00FF0000, range = 300, duration = 60000, sprite = "redPoint"},
			{ name = "Cupcake Trap", objectType = "traps", spellName = "CaitlynYordleTrap", charName = "CaitlynTrap", color = 0x00FF0000, range = 300, duration = 240000, sprite = "cyanPoint"},
			{ name = "Noxious Trap", objectType = "traps", spellName = "Bushwhack", charName = "Nidalee_Spear", color = 0x00FF0000, range = 300, duration = 240000, sprite = "cyanPoint"},
			{ name = "Noxious Trap", objectType = "traps", spellName = "BantamTrap", charName = "TeemoMushroom", color = 0x00FF0000, range = 300, duration = 600000, sprite = "cyanPoint"},
			{ name = "Seed", objectType = "traps", spellName = "ZyraSeed", charName = "ZyraSeed", color = 0x00FF0000, range = 300, duration = 30000, sprite = "cyanPoint"},
			-- to confirm spell
			{ name = "DoABarrelRoll", objectType = "boxes", spellName = "MaokaiSapling2", charName = "MaokaiSproutling", color = 0x00FF0000, range = 300, duration = 35000, sprite = "redPoint"},
		}
		tmpObjects = {}
		sprites = {
			cyanPoint = { spriteFile = "PingMarkerCyan_8", }, 
			redPoint = { spriteFile = "PingMarkerRed_8", }, 
			greenPoint = { spriteFile = "PingMarkerGreen_8", }, 
			yellowPoint = { spriteFile = "PingMarkerYellow_8", },
			greyPoint = { spriteFile = "PingMarkerGrey_8", },
		}
		objects = {}

	--[[      CODE      ]]
	function objectExist(spellName, pos, tick)
		for i,obj in pairs(objects) do
			if obj.object == nil and obj.spellName == spellName and GetDistance(obj.pos, pos) < 200 and tick < obj.seenTick then
				return i
			end
		end	
		return nil
	end
	
	function removeObjectCasted(object, name)
		for i,obj in pairs(objects) do
			if obj.charName == name and GetDistance(obj.pos, object) < 200 then
				objects[i] = nil
			end
		end	
	end
	
	function addObject(objectToAdd, pos, fromSpell, object)
		-- add the object
		local tick = GetTickCount()
		local objId = objectToAdd.spellName..(math.floor(pos.x) + math.floor(pos.z))
		--check if exist
		local objectExist = objectExist(objectToAdd.spellName, {x = pos.x, z = pos.z,}, tick - 2000)
		if objectExist ~= nil then
			objId = objectExist
		end
		if objects[objId] == nil then
			objects[objId] = {
				object = object,
				color = objectToAdd.color,
				range = objectToAdd.range,
				sprite = objectToAdd.sprite,
				spellName = objectToAdd.spellName,
				seenTick = tick,
				endTick = tick + objectToAdd.duration,
				fromSpell = fromSpell,
				visible = (object == nil),
				display = { visible = false, text = ""},
			}
			if (object ~= nil and object.mana ~= 0) then
				objects[objId].endTick = tick + object.mana
			end
		elseif objects[objId].object == nil and object ~= nil and object.valid then
			objects[objId].object = object
			objects[objId].fromSpell = false
		end
		objects[objId].pos = {x = pos.x, y = pos.y, z = pos.z, }
		if showOnMiniMap == true then objects[objId].minimap = GetMinimap(pos) end
	end

	function OnCreateObj(object)
		if object ~= nil and object.valid then
			if object.type == "obj_AI_Minion" then
				for i,objectToAdd in pairs(objectsToAdd) do
					if object.name == objectToAdd.name and object.charName == objectToAdd.charName then
						local tick = GetTickCount()
						table.insert(tmpObjects, {tick = tick, object = object})
					end
				end
			elseif object.name == "ShroomMine.troy" then
				removeObjectCasted(object, "TeemoMushroom")
				--removeObjectCasted(object, "MaokaiSproutling")
				--removeObjectCasted(object, "Nidalee_Spear")
				--removeObjectCasted(object, "CaitlynTrap")
				--removeObjectCasted(object, "ShacoBox")
				--removeObjectCasted(object, "ZyraSeed")
			end
		end
	end

	function OnProcessSpell(object,spell)
		if object ~= nil and object.valid and object.team == TEAM_ENEMY then
			for i,objectToAdd in pairs(objectsToAdd) do
				if spell.name == objectToAdd.spellName then
					ticked = GetTickCount()
					addObject(objectToAdd, spell.endPos, true)
				end
			end
		end
	end

	function OnDeleteObj(object)
		if object ~= nil and object.valid and object.name ~= nil and object.type == "obj_AI_Minion" then
			for i,objectToAdd in pairs(objectsToAdd) do
				if object.charName == objectToAdd.charName then
					-- remove the object
					for j,obj in pairs(objects) do
						if obj.object ~= nil and obj.object.valid and obj.object.networkID ~= nil and obj.object.networkID == object.networkID then
							objects[j] = nil
							return
						end
					end
				end
			end
		end
	end

	function OnDraw()
		if gameState:gameIsOver() then return end
		local shiftKeyPressed = IsKeyDown(16)
		for i,obj in pairs(objects) do
			if obj.visible == true then
				DrawCircle(obj.pos.x, obj.pos.y, obj.pos.z, 100, obj.color)
				DrawCircle(obj.pos.x, obj.pos.y, obj.pos.z, (shiftKeyPressed and obj.range or 200), obj.color)
				--minimap
				if showOnMiniMap == true then
					if useSprites then
						sprites[obj.sprite].sprite:Draw(obj.minimap.x, obj.minimap.y, 0xFF)
					else
						DrawText("o",31,obj.minimap.x-7,obj.minimap.y-13,obj.color)
					end
					if obj.display.visible then
						DrawText(obj.display.text,14,obj.display.x,obj.display.y,obj.display.color)
					end
				end
			end
		end
	end

	function OnTick()
		if gameState:gameIsOver() then return end
		local tick = GetTickCount()
		for i,obj in pairs(tmpObjects) do
			if tick > obj.tick + 1000 or obj.object == nil or not obj.object.valid or obj.object.team == player.team then
				tmpObjects[i] = nil
			else
				for j,objectToAdd in pairs(objectsToAdd) do
					if obj.object ~= nil and obj.object.valid and obj.object.charName == objectToAdd.charName and obj.object.team == TEAM_ENEMY then
						addObject(objectToAdd, obj.object, false, obj.object)
						tmpObjects[i] = nil
						break
					end
				end
			end
		end
		for i,obj in pairs(objects) do
			if tick > obj.endTick or (obj.object ~= nil and obj.object.valid and obj.object.team == player.team) then
				objects[i] = nil
			else
				if obj.object == nil or obj.object.valid == false or (obj.object ~= nil and obj.object.valid and obj.object.dead ~= nil and obj.object.dead == false) then
				--if obj.object == nil
					obj.visible = true
				else
					obj.visible = false
				end
				-- cursor pos
				if obj.visible and GetDistanceFromMouse(obj.pos) < 150 then
					local cursor = GetCursorPos()
					obj.display.color = (obj.fromSpell and 0xFFFF0000 or 0xFF00FF00)
					obj.display.text = timerText((obj.endTick-tick)/1000)
					obj.display.x = cursor.x - 50
					obj.display.y = cursor.y - 50
					obj.display.visible = true
				else
					obj.display.visible = false
				end
			end
		end
	end

	function OnLoad()
		gameState = GameState()
		if showOnMiniMap and useSprites then
			for i,sprite in pairs(sprites) do	sprites[i].sprite = GetSprite("hiddenObjects/"..sprite.spriteFile..".dds") end
		end
		for i = 1, objManager.maxObjects do
			local object = objManager:getObject(i)
			if object ~= nil then OnCreateObj(object) end
		end
	end
end