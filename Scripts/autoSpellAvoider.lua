--[[
	Script: autoSpellAvoider v0.1
	Author: SurfaceS Modified - Barasia script based
	
	required libs : 		spellList,  common
	required sprites : 		-
	exposed variables : 	-
	
	v0.1		initial release
	v0.2		BoL Studio Version
]]

require "AllClass"
require "spellList"

--COLOR_BLUE
--COLOR_RED
--COLOR_GREEN
--COLOR_PURPLE


do
	local spellArray = {}
	local spellArrayCount = 0
	local moveTo = {}
	
	local colors = {0xFFFFFF, 0xFFFFFF, 0xFFFF00, 0xFFFFFF, 0xFF00FF}		-- color for skill type (indexed)
	
	
	
	--[[         Code          ]]
	function OnLoad()
		for i = 1, heroManager.iCount, 1 do 
			local hero = heroManager:getHero(i)
			if hero ~= nil and hero.team ~= player.team then
				for i, spell in pairs(spellList) do
					if string.lower(spell.charName) == string.lower(hero.charName) or (spell.charName == "" and (string.find(hero:GetSpellData(SUMMONER_1).name..hero:GetSpellData(SUMMONER_2).name, i))) then
						spellArrayCount = spellArrayCount + 1
						spellArray[i] = spellList[i]
						spellArray[i].color = colors[spellArray[i].spellType]
						spellArray[i].shot = false
						spellArray[i].lastshot = 0
						spellArray[i].skillshotpoint = {}
					end
				end
			end
		end
		-- unload spellList Lib as it's not needed anymore
		spellList = nil
		-- unload spellAvoider if no spell founded
		if spellArrayCount == 0 then
			
			--spellAvoider = nil
			
		else
			myConfig = scriptConfig("Spell Avoider Config", "spellAvoider")
			myConfig:addParam("drawSkillShot", "Draw Skills", SCRIPT_PARAM_ONOFF, true)
			myConfig:addParam("dodgeSkillShot", "Dodge Skills", SCRIPT_PARAM_ONKEYTOGGLE, false, 74)
			
			
			myConfig:addParam("dodgeSpace", "Dodge Spacing", SCRIPT_PARAM_SLICE, 150, 50, 500)
		
			-- skill that have constant length
			function calculateLinepass(pos1, pos2, maxDist)
				local spellVector = Vector(pos2) - pos1
				spellVector = spellVector / spellVector:len() * maxDist
				return {Vector(pos1), spellVector + pos1}
			end
			-- skill that have variable length
			function calculateLinepoint(pos1, pos2, maxDist)
				local spellVector = Vector(pos2) - pos1
				if spellVector:len() > maxDist then
					spellVector = spellVector / spellVector:len() * maxDist
				end
				return {Vector(pos1), spellVector + pos1}
			end
			-- skill that cannot be casted > maxDist
			function calculateLineaoe(pos1, pos2, maxDist)
				return {Vector(pos2)}
			end
			-- skill that can be casted > maxDist
			function calculateLineaoe2(pos1, pos2, maxDist)
				local spellVector = Vector(pos2) - pos1
				if spellVector:len() > maxDist then
					spellVector = spellVector / spellVector:len() * maxDist
				end
				return {Vector(pos1) + spellVector}
			end

			function dodgeAOE(pos1, pos2, radius)
				local distancePos2 = GetDistance2D(player, pos2) 
				if distancePos2 < radius then
					moveTo.x = pos2.x + ((radius+50)/distancePos2)*(player.x-pos2.x)
					moveTo.z = pos2.z + ((radius+50)/distancePos2)*(player.z-pos2.z)
					player:MoveTo(moveTo.x,moveTo.z)
				end
			end

			function dodgeLinePoint(pos1, pos2, radius)
				local distancePos1 = GetDistance2D(player, pos1)
				local distancePos2 = GetDistance2D(player, pos2)
				local distancePos1Pos2 = GetDistance2D(pos1, pos2)
				local perpendicular = (math.floor((math.abs((pos2.x-pos1.x)*(pos1.z-player.z)-(pos1.x-player.x)*(pos2.z-pos1.z)))/distancePos1Pos2))
				if perpendicular < radius and distancePos2 < distancePos1Pos2 and distancePos1 < distancePos1Pos2 then
					local k = ((pos2.z-pos1.z)*(player.x-pos1.x) - (pos2.x-pos1.x)*(player.z-pos1.z)) / distancePos1Pos2
					local pos3 = {}
					pos3.x = player.x - k * (pos2.z-pos1.z)
					pos3.z = player.z + k * (pos2.x-pos1.x)
					local distancePos3 = GetDistance2D(player, pos3)
					moveTo.x = pos3.x + ((radius+50)/distancePos3)*(player.x-pos3.x)
					moveTo.z = pos3.z + ((radius+50)/distancePos3)*(player.z-pos3.z)
					player:MoveTo(moveTo.x,moveTo.z)
				end
			end

			function dodgeLinePass(pos1, pos2, radius, maxDist)
				local distancePos1 = GetDistance2D(player, pos1)
				local distancePos1Pos2 = GetDistance2D(pos1, pos2)
				local pos3 = {}
				pos3.x = pos1.x + (maxDist)/distancePos1Pos2*(pos2.x-pos1.x)
				pos3.z = pos1.z + (maxDist)/distancePos1Pos2*(pos2.z-pos1.z)
				local distancePos3 = GetDistance2D(player, pos3)
				local distancePos1Pos3 = GetDistance2D(pos1, pos3)
				local perpendicular = (math.floor((math.abs((pos3.x-pos1.x)*(pos1.z-player.z)-(pos1.x-player.x)*(pos3.z-pos1.z)))/distancePos1Pos3))
				if perpendicular < radius and distancePos3 < distancePos1Pos3 and distancePos1 < distancePos1Pos3 then
					local k = ((pos3.z-pos1.z)*(player.x-pos1.x) - (pos3.x-pos1.x)*(player.z-pos1.z)) / ((pos3.z-pos1.z)^2 + (pos3.x-pos1.x)^2)
					local pos4 = {}
					pos4.x = player.x - k * (pos3.z-pos1.z)
					pos4.z = player.z + k * (pos3.x-pos1.x)
					local distancePos4 = GetDistance2D(player, pos4)
					moveTo.x = pos4.x + ((radius+50)/distancePos4)*(player.x-pos4.x)
					moveTo.z = pos4.z + ((radius+50)/distancePos4)*(player.z-pos4.z)
					player:MoveTo(moveTo.x,moveTo.z)
				end
			end
			
			function OnProcessSpell(object,spell)
				if player.dead == true then return end
				if object~=nil and object.team~=player.team and spellArray[spell.name] ~= nil and GetDistance2D(player, object) < spellArray[spell.name].range + spellArray[spell.name].size + 500 then
					spellArray[spell.name].shot = true
					spellArray[spell.name].lastshot = GetTickCount()
					if spellArray[spell.name].spellType == 1 then
						spellArray[spell.name].skillshotpoint = calculateLinepass(object.pos, spell.endPos, spellArray[spell.name].range)
						if myConfig.dodgeSkillShot then
							dodgeLinePass(spell.startPos, spell.endPos, spellArray[spell.name].size, spellArray[spell.name].range)
						end
					elseif spellArray[spell.name].spellType == 2 then
						spellArray[spell.name].skillshotpoint = calculateLinepoint(spell.startPos, spell.endPos, spellArray[spell.name].range)
						if myConfig.dodgeSkillShot then
							dodgeLinePoint(spell.startPos, spell.endPos, spellArray[spell.name].size)
						end
					elseif spellArray[spell.name].spellType == 3 then
						spellArray[spell.name].skillshotpoint = calculateLineaoe(spell.startPos, spell.endPos, spellArray[spell.name].range)
						if myConfig.dodgeSkillShot and spell.name ~= "SummonerClairvoyance" then
							dodgeAOE(spell.startPos, spell.endPos, spellArray[spell.name].size)
						end
					elseif spellArray[spell.name].spellType == 4 then
						spellArray[spell.name].skillshotpoint = calculateLinepass(spell.startPos, spell.endPos, 5000)
						if myConfig.dodgeSkillShot then
							dodgeLinePass(spell.startPos, spell.endPos, spellArray[spell.name].size, spellArray[spell.name].range)
						end
					elseif spellArray[spell.name].spellType == 5 then
						spellArray[spell.name].skillshotpoint = calculateLineaoe2(spell.startPos, spell.endPos, spellArray[spell.name].range)
						if myConfig.dodgeSkillShot then
							dodgeAOE(spell.startPos, spell.endPos, spellArray[spell.name].size)
						end
					end
				end
			end
			
			function OnDraw()
				SC__OnDraw()
				if myConfig.drawSkillShot then
					for i, spell in pairs(spellArray) do
						if spell.shot then
							if #spell.skillshotpoint == 1 then
								DrawCircle(spell.skillshotpoint[1].x, spell.skillshotpoint[1].y, spell.skillshotpoint[1].z, spell.size, spell.color)
							else
								DrawArrows(spell.skillshotpoint[1], spell.skillshotpoint[2], spell.size, spell.color, 1000)
							end
							if #spell.skillshotpoint == 3 then
								DrawCircle(spell.skillshotpoint[3].x, spell.skillshotpoint[3].y, spell.skillshotpoint[3].z, spell.size, spell.color)
							end
						end
					end
				end
			end
			
			function OnTick()
				local tick = GetTickCount()
				for i, spell in pairs(spellArray) do
					if spell.shot and spell.lastshot < tick - spell.duration then
						spell.shot = false
						spell.skillshotpoint = {}
						moveTo = {}
					end
				end
			end
			
			function OnWndMsg(msg,key)
				SC__OnWndMsg(msg,key)
			end
	
		end
	end
end