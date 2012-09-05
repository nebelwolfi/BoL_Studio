--[[
	Script: Hidden Objects Display v0.2
	Author: SurfaceS
	
	required libs : 		gameOver, start, minimap (if used)
	required sprites : 		Hidden Objects Sprites (if used)
	exposed variables : 	file_exists
	
	UPDATES :
	v0.1				initial release
	v0.1b				change spells names for 3 champs (thx TRUS)
	v0.1c				change spells names for teemo
	v0.1d				fix the perma show
	v0.2				BoL Studio Version
	
	USAGE :
	Hold shift key to see the hidden object's range.
]]

--[[      GLOBAL      ]]
do
	if SCRIPT_PATH == nil then SCRIPT_PATH = debug.getinfo(1).source:sub(debug.getinfo(1).source:find(".*\\")):sub(2) end
	if LIB_PATH == nil then LIB_PATH = SCRIPT_PATH.."libs/" end
	if SPRITE_PATH == nil then SPRITE_PATH = SCRIPT_PATH:gsub("\\", "/"):gsub("/Scripts", "").."Sprites/" end
	if player == nil then player = GetMyHero() end
	if gameOver == nil then dofile(LIB_PATH.."gameOver.lua") end
	if start == nil then dofile(LIB_PATH.."start.lua") end

	local hiddenObjects = {
		objectsToAdd = {
			{ name = "VisionWard", objectType = "wards", spellName = "VisionWard", color = 0x00FF00FF, range = 1450, duration = 180000, sprite = "yellowPoint"},
			{ name = "SightWard", objectType = "wards", spellName = "SightWard", color = 0x0000FF00, range = 1450, duration = 180000, sprite = "greenPoint"},
			{ name = "WriggleLantern", objectType = "wards", spellName = "WriggleLantern", color = 0x0000FF00, range = 1450, duration = 180000, sprite = "greenPoint"},
			{ name = "Jack In The Box", objectType = "boxes", spellName = "JackInTheBox", color = 0x00FF0000, range = 300, duration = 60000, sprite = "redPoint"},
			{ name = "Cupcake Trap", objectType = "traps", spellName = "CaitlynYordleTrap", color = 0x00FF0000, range = 300, duration = 240000, sprite = "cyanPoint"},
			{ name = "Noxious Trap", objectType = "traps", spellName = "Bushwhack", color = 0x00FF0000, range = 300, duration = 240000, sprite = "cyanPoint"},
			{ name = "Noxious Trap", objectType = "traps", spellName = "BantamTrap", color = 0x00FF0000, range = 300, duration = 600000, sprite = "cyanPoint"},
			-- to confirm
			{ name = "MaokaiSproutling", objectType = "boxes", spellName = "MaokaiSapling2", color = 0x00FF0000, range = 300, duration = 35000, sprite = "redPoint"},
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

	--[[      CONFIG      ]]
	hiddenObjects.showOnMiniMap = true			-- show objects on minimap
	hiddenObjects.useSprites = true				-- show sprite on minimap

	--[[      CODE      ]]
	if hiddenObjects.showOnMiniMap and miniMap == nil then dofile(LIB_PATH.."minimap.lua") end
	if GetDistance2D == nil then dofile(LIB_PATH.."GetDistance2D.lua") end

	function file_exists(name)
	   local f=io.open(name,"r")
	   if f~=nil then io.close(f) return true else return false end
	end

	function hiddenObjects.returnSprite(file)
		if file_exists(SPRITE_PATH..file) == true then
			return createSprite(file)
		end
		PrintChat(file.." not found (sprites installed ?)")
		return createSprite("empty.dds")
	end

	function hiddenObjects.timerText(seconds)
		local minutes = seconds / 60
		if minutes >= 60 then
			return string.format("%i:%02i:%02i", minutes / 60, minutes, seconds % 60)
		elseif minutes >= 1 then
			return string.format("%i:%02i", minutes, seconds % 60)
		else
			return string.format(":%02i", seconds % 60)
		end
	end

	function hiddenObjects.objectExist(objectType, pos)
		for i,obj in pairs(hiddenObjects.objects) do
			if obj.object == nil and obj.objectType == objectType and GetDistance2D(obj.pos, pos) < 100 then
				return i
			end
		end	
		return nil
	end

	function hiddenObjects.addObject(objectToAdd, pos, fromSpell, object)
		-- add the object
		local objId = objectToAdd.objectType..(math.floor(pos.x) + math.floor(pos.z))
		local tick = GetTickCount()
		--check if exist
		local objectExist = hiddenObjects.objectExist(objectToAdd.objectType, {x = pos.x, z = pos.z,})
		if objectExist ~= nil then
			hiddenObjects.objects[objId] = hiddenObjects.objects[objectExist]
			hiddenObjects.objects[objectExist] = nil
		end
		if hiddenObjects.objects[objId] == nil then
			hiddenObjects.objects[objId] = {
				object = object,
				color = objectToAdd.color,
				range = objectToAdd.range,
				sprite = objectToAdd.sprite,
				objectType = objectToAdd.objectType,
				seenTick = tick,
				endTick = tick + objectToAdd.duration,
				fromSpell = fromSpell,
				visible = (object == nil),
				display = { visible = false, text = ""},
			}
		elseif hiddenObjects.objects[objId].object == nil and object ~= nil then
			hiddenObjects.objects[objId].object = object
		end
		hiddenObjects.pos = {x = pos.x, y = pos.y, z = pos.z, }
		if hiddenObjects.showOnMiniMap == true then
			hiddenObjects.objects[objId].minimap = miniMap.ToMinimapPoint(pos.x,pos.z)
		end
	end

	function OnCreateObj(object)
		if object ~= nil and object.name ~= nil and object.team ~= player.team then
			for i,objectToAdd in pairs(hiddenObjects.objectsToAdd) do
				if object.name == objectToAdd.name then
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
					hiddenObjects.addObject(objectToAdd, spell["end"], true)
				end
			end
		end
	end

	function OnDeleteObj(object)
		if object ~= nil and object.name ~= nil and object.team ~= player.team then
			for i,objectToAdd in pairs(hiddenObjects.objectsToAdd) do
				if object.name == objectToAdd.name then
					-- remove the object
					local objId = objectToAdd.objectType..(math.floor(object.x) + math.floor(object.z))
					if objId ~= nil and hiddenObjects.objects[objId] ~= nil then hiddenObjects.objects[objId] = nil end
				end
			end
		end
	end

	function OnDraw()
		if gameOver.gameIsOver() then return end
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
		if gameOver.gameIsOver() then return end
		local tick = GetTickCount()
		local cursor = GetCursorPos()
		for i,obj in pairs(hiddenObjects.objects) do
			if obj.object == nil or (obj.object ~= nil and obj.object.team == start.teamEnnemy and obj.object.dead == false) then
				obj.visible = true
			else
				obj.visible = false
			end
			-- cursor pos
			if hiddenObjects.showOnMiniMap and obj.visible and GetDistance2D(obj.minimap, cursor) < 15 then
				obj.display.color = (obj.fromSpell and 0xFF00FF00 or 0xFFFF0000)
				obj.display.text = hiddenObjects.timerText((obj.endTick-tick)/1000)
				obj.display.x = cursor.x + 10
				obj.display.y = cursor.y
				obj.display.visible = true
			else
				obj.display.visible = false
			end
			if tick > obj.endTick or (obj.object ~= nil and obj.object.team == player.team) then
				hiddenObjects.objects[i] = nil
			end
		end
	end

	function OnLoad()
		start.OnLoad()
		if hiddenObjects.showOnMiniMap then
			miniMap.OnLoad()
			if hiddenObjects.useSprites then
				for i,sprite in pairs(hiddenObjects.sprites) do	hiddenObjects.sprites[i].sprite = hiddenObjects.returnSprite("hiddenObjects/"..sprite.spriteFile..".dds") end
			end
		end
		for i = 1, objManager.maxObjects do
			local object = objManager:getObject(i)
			if object ~= nil then OnCreateObj(object) end
		end
	end
end