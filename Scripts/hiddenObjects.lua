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
	v0.3				AllClass use
	
	USAGE :
	Hold shift key to see the hidden object's range.
]]

do
	local hiddenObjects = {
		--[[      CONFIG      ]]
		showOnMiniMap = true,			-- show objects on minimap
		useSprites = true,				-- show sprite on minimap
		--[[      GLOBAL      ]]
		objectsToAdd = {
			{ name = "VisionWard", objectType = "wards", spellName = "VisionWard", charName = "VisionWard", color = 0x00FF00FF, range = 1450, duration = 180000, sprite = "yellowPoint"},
			{ name = "SightWard", objectType = "wards", spellName = "SightWard", charName = "SightWard", color = 0x0000FF00, range = 1450, duration = 180000, sprite = "greenPoint"},
			{ name = "WriggleLantern", objectType = "wards", spellName = "WriggleLantern", charName = "WriggleLantern", color = 0x0000FF00, range = 1450, duration = 180000, sprite = "greenPoint"},
			{ name = "Jack In The Box", objectType = "boxes", spellName = "JackInTheBox", charName = "ShacoBox", color = 0x00FF0000, range = 300, duration = 60000, sprite = "redPoint"},
			{ name = "Cupcake Trap", objectType = "traps", spellName = "CaitlynYordleTrap", charName = "CaitlynTrap", color = 0x00FF0000, range = 300, duration = 240000, sprite = "cyanPoint"},
			{ name = "Noxious Trap", objectType = "traps", spellName = "Bushwhack", charName = "Nidalee_Spear", color = 0x00FF0000, range = 300, duration = 240000, sprite = "cyanPoint"},
			{ name = "Noxious Trap", objectType = "traps", spellName = "BantamTrap", charName = "TeemoMushroom", color = 0x00FF0000, range = 300, duration = 600000, sprite = "cyanPoint"},
			-- to confirm spell
			{ name = "DoABarrelRoll", objectType = "boxes", spellName = "MaokaiSapling2", charName = "MaokaiSproutling", color = 0x00FF0000, range = 300, duration = 35000, sprite = "redPoint"},
		},
		sprites = {
			cyanPoint = { spriteFile = "PingMarkerCyan_8", }, 
			redPoint = { spriteFile = "PingMarkerRed_8", }, 
			greenPoint = { spriteFile = "PingMarkerGreen_8", }, 
			yellowPoint = { spriteFile = "PingMarkerYellow_8", },
			greyPoint = { spriteFile = "PingMarkerGrey_8", },
		},
		objects = {},
	}

	--[[      CODE      ]]
	function hiddenObjects.objectExist(spellName, pos, tick)
		for i,obj in pairs(hiddenObjects.objects) do
			if obj.object == nil and obj.spellName == spellName and GetDistance(obj.pos, pos) < 200 and tick < obj.seenTick then
				return i
			end
		end	
		return nil
	end

	function hiddenObjects.addObject(objectToAdd, pos, fromSpell, object)
		-- add the object
		local tick = GetTickCount()
		local objId = objectToAdd.spellName..(math.floor(pos.x) + math.floor(pos.z))
		--check if exist
		local objectExist = hiddenObjects.objectExist(objectToAdd.spellName, {x = pos.x, z = pos.z,}, tick - 500)
		if objectExist ~= nil then
			objId = objectExist
		end
		if hiddenObjects.objects[objId] == nil then
			hiddenObjects.objects[objId] = {
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
		elseif hiddenObjects.objects[objId].object == nil and object ~= nil then
			hiddenObjects.objects[objId].object = object
		end
		hiddenObjects.objects[objId].pos = {x = pos.x, y = pos.y, z = pos.z, }
		if hiddenObjects.showOnMiniMap == true then hiddenObjects.objects[objId].minimap = GetMinimap(pos) end
	end

	function OnCreateObj(object)
		if object ~= nil and object.type == "obj_AI_Minion" and object.team ~= player.team then
			for i,objectToAdd in pairs(hiddenObjects.objectsToAdd) do
				if object.charName == objectToAdd.charName then
					-- add the object
					hiddenObjects.addObject(objectToAdd, object, false, object)
				end
			end
		end
	end

	function OnProcessSpell(object,spell)
		if object ~= nil and object.team ~= player.team then
			for i,objectToAdd in pairs(hiddenObjects.objectsToAdd) do
				if spell.name == objectToAdd.spellName then
					-- add the object
					hiddenObjects.addObject(objectToAdd, spell.endPos, true)
				end
			end
		end
	end

	function OnDeleteObj(object)
		if object ~= nil and object.name ~= nil and object.team ~= player.team then
			for i,objectToAdd in pairs(hiddenObjects.objectsToAdd) do
				if object.charName == objectToAdd.charName then
					-- remove the object
					for j,obj in pairs(hiddenObjects.objects) do
						if obj.object ~= nil and obj.object.networkID == object.networkID then
							hiddenObjects.objects[j] = nil
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
		for i,obj in pairs(hiddenObjects.objects) do
			if obj.visible == true then
				DrawCircle(obj.pos.x, obj.pos.y, obj.pos.z, 100, obj.color)
				DrawCircle(obj.pos.x, obj.pos.y, obj.pos.z, (shiftKeyPressed and obj.range or 200), obj.color)
				--minimap
				if hiddenObjects.showOnMiniMap == true then
					if hiddenObjects.useSprites then
						hiddenObjects.sprites[obj.sprite].sprite:Draw(obj.minimap.x, obj.minimap.y, 0xFF)
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
		for i,obj in pairs(hiddenObjects.objects) do
			if tick > obj.endTick or (obj.object ~= nil and obj.object.team == player.team) then
				hiddenObjects.objects[i] = nil
			else
				if obj.object == nil or (obj.object ~= nil and obj.object.team == TEAM_ENEMY and obj.object.dead == false) then
					obj.visible = true
				else
					obj.visible = false
				end
				-- cursor pos
				if obj.visible and GetDistanceFromMouse(obj.pos) < 150 then
					local cursor = GetCursorPos()
					obj.display.color = (obj.fromSpell and 0xFF00FF00 or 0xFFFF0000)
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
		if hiddenObjects.showOnMiniMap and hiddenObjects.useSprites then
			for i,sprite in pairs(hiddenObjects.sprites) do	hiddenObjects.sprites[i].sprite = GetSprite("hiddenObjects/"..sprite.spriteFile..".dds") end
		end
		for i = 1, objManager.maxObjects do
			local object = objManager:getObject(i)
			if object ~= nil then OnCreateObj(object) end
		end
	end
end