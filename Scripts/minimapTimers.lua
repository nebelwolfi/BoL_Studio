--[[
        Script: minimapTimers v0.1
		Author: SurfaceS
		
		In replacement of my Jungle Display v0.2
		
		UPDATES :
		v0.1					initial release
]]
--require "AllClass"

do
	--[[      GLOBAL      ]]
	monsters = {
		summonerRift = {
			{	-- baron
				name = "baron",
				spawn = 900,
				respawn = 420,
				advise = true,
				camps = {
					{
						pos = { x = 4600, y = 60, z = 10250 },
						name = "monsterCamp_12",
						creeps = { { { name = "Worm12.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
				},
			},
			{	-- dragon
				name = "dragon",
				spawn = 150,
				respawn = 360,
				advise = true,
				camps = {
					{
						pos = { x = 9459, y = 60, z = 4193 },
						name = "monsterCamp_6",
						creeps = { { { name = "Dragon6.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
				},
			},
			{	-- blue
				name = "blue",
				spawn = 115,
				respawn = 300,
				advise = true,
				camps = {
					{
						pos = { x = 3632, y = 60, z = 7600 },
						name = "monsterCamp_1",
						creeps = { { { name = "AncientGolem1.1.1" }, { name = "YoungLizard1.1.2" }, { name = "YoungLizard1.1.3" }, }, },
						team = TEAM_BLUE,
					},
					{
						pos = { x = 10386, y = 60, z = 6811 },
						name = "monsterCamp_7",
						creeps = { { { name = "AncientGolem7.1.1" }, { name = "YoungLizard7.1.2" }, { name = "YoungLizard7.1.3" }, }, },
						team = TEAM_RED,
					},
				},
			},
			{	-- red
				name = "red",
				spawn = 115,
				respawn = 300,
				advise = true,
				camps = {
					{
						pos = { x = 7455, y = 60, z = 3890 },
						name = "monsterCamp_4",
						creeps = { { { name = "LizardElder4.1.1" }, { name = "YoungLizard4.1.2" }, { name = "YoungLizard4.1.3" }, }, },
						team = TEAM_BLUE,
					},
					{
						pos = { x = 6504, y = 60, z = 10584 },
						name = "monsterCamp_10",
						creeps = { { { name = "LizardElder10.1.1" }, { name = "YoungLizard10.1.2" }, { name = "YoungLizard10.1.3" }, }, },
						team = TEAM_RED,
					},
				},
			},
			{	-- wolves
				name = "wolves",
				spawn = 100,
				respawn = 60,
				advise = false,
				camps = {
					{
						name = "monsterCamp_2",
						creeps = { { { name = "GiantWolf2.1.3" }, { name = "wolf2.1.1" }, { name = "wolf2.1.2" }, }, },
						team = TEAM_BLUE,
					},
					{
						name = "monsterCamp_8",
						creeps = { { { name = "GiantWolf8.1.3" }, { name = "wolf8.1.1" }, { name = "wolf8.1.2" }, }, },
						team = TEAM_RED,
					},
				},
			},
			{	-- wraiths
				name = "wraiths",
				spawn = 100,
				respawn = 50,
				advise = false,
				camps = {
					{
						name = "monsterCamp_3",
						creeps = { { { name = "Wraith3.1.3" }, { name = "LesserWraith3.1.1" }, { name = "LesserWraith3.1.2" }, { name = "LesserWraith3.1.4" }, }, },
						team = TEAM_BLUE,
					},
					{
						name = "monsterCamp_9",
						creeps = { { { name = "Wraith9.1.3" }, { name = "LesserWraith9.1.1" }, { name = "LesserWraith9.1.2" }, { name = "LesserWraith9.1.4" }, }, },
						team = TEAM_RED,
					},
				},
			},
			{	-- Golems
				name = "Golems",
				spawn = 100,
				respawn = 60,
				advise = false,
				camps = {
					{
						name = "monsterCamp_5",
						creeps = { { { name = "Golem5.1.2" }, { name = "SmallGolem5.1.1" }, }, },
						team = TEAM_BLUE,
					},
					{
						name = "monsterCamp_11",
						creeps = { { { name = "Golem11.1.2" }, { name = "SmallGolem11.1.1" }, }, },
						team = TEAM_RED,
					},
				},
			},
		},
		twistedTreeline = {
			{	-- Wraith
				name = "Wraith",
				spawn = 100,
				respawn = 50,
				advise = false,
				camps = {
					{
						--pos = { x = 4414, y = 60, z = 5774 },
						name = "monsterCamp_1",
						creeps = {
							{ { name = "TT_NWraith1.1.1" }, { name = "TT_NWraith21.1.2" }, { name = "TT_NWraith21.1.3" }, },
						},
						team = TEAM_BLUE,
					},
					{
						--pos = { x = 11008, y = 60, z = 5775 },
						name = "monsterCamp_4",
						creeps = {
							{ { name = "TT_NWraith4.1.1" }, { name = "TT_NWraith24.1.2" }, { name = "TT_NWraith24.1.3" }, },
						},
						team = TEAM_RED,
					},
				},
			},
			{	-- Golems
				name = "Golems",
				respawn = 50,
				spawn = 100,
				advise = false,
				camps = {
					{
						--pos = { x = 5088, y = 60, z = 8065 },
						name = "monsterCamp_2",
						creeps = {
							{ { name = "TT_NGolem2.1.1" }, { name = "TT_NGolem22.1.2" } },
						},
						team = TEAM_BLUE,
					},
					{
						--pos = { x = 10341, y = 60, z = 8084 },
						name = "monsterCamp_5",
						creeps = {
							{ { name = "TT_NGolem5.1.1" }, { name = "TT_NGolem25.1.2" } },
						},
						team = TEAM_RED,
					},
				},
			},
			{	-- Wolves
				name = "Wolves",
				respawn = 50,
				spawn = 100,
				advise = false,
				camps = {
					{
						--pos = { x = 6148, y = 60, z = 5993 },
						name = "monsterCamp_3",
						creeps = { { { name = "TT_NWolf3.1.1" }, { name = "TT_NWolf23.1.2" }, { name = "TT_NWolf23.1.3" } }, },
						team = TEAM_BLUE,
					},
					{
						--pos = { x = 9239, y = 60, z = 6022 },
						name = "monsterCamp_6",
						creeps = { { { name = "TT_NWolf6.1.1" }, { name = "TT_NWolf26.1.2" }, { name = "TT_NWolf26.1.3" } }, },
						team = TEAM_RED,
					},
				},
			},
			{	-- Heal
				name = "Heal",
				spawn = 115,
				respawn = 90,
				advise = true,
				camps = {
					{
						pos = { x = 7711, y = 60, z = 6722 },
						name = "monsterCamp_7",
						creeps = { { { name = "TT_Relic7.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
				},
			},
			{	-- Vilemaw
				name = "Vilemaw",
				spawn = 600,
				respawn = 300,
				advise = true,
				camps = {
					{
						pos = { x = 7711, y = 60, z = 10080 },
						name = "monsterCamp_8",
						creeps = { { { name = "TT_Spiderboss8.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
				},
			},
		},
		crystalScar = {},
		provingGrounds = {
			{	-- Heal
				name = "Heal",
				spawn = 190,
				respawn = 40,
				advise = false,
				camps = {
					{
						pos = { x = 8922, y = 60, z = 7868 },
						name = "monsterCamp_1",
						creeps = { { { name = "OdinShieldRelic1.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
					{
						pos = { x = 7473, y = 60, z = 6617 },
						name = "monsterCamp_2",
						creeps = { { { name = "OdinShieldRelic2.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
					{
						pos = { x = 5929, y = 60, z = 5190 },
						name = "monsterCamp_3",
						creeps = { { { name = "OdinShieldRelic3.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
					{
						pos = { x = 4751, y = 60, z = 3901 },
						name = "monsterCamp_4",
						creeps = { { { name = "OdinShieldRelic4.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
				},
			},
		}
	}
	
	altars = {
		summonerRift = {},
		twistedTreeline = {
			{
				name = "Left Altar",
				spawn = 180,
				respawn = 90,
				advise = true,
				objectName = "TT_Buffplat_L",
				locked = false,
				lockNames = {"TT_Lock_Blue_L.troy", "TT_Lock_Red_L.troy", "TT_Lock_Neutral_L.troy", },
				unlockNames = {"TT_Unlock_Blue_L.troy", "TT_Unlock_Red_L.troy", "TT_Unlock_Neutral_L.troy", },
			},
			{
				name = "Right Altar",
				spawn = 180,
				respawn = 90,
				advise = true,
				objectName = "TT_Buffplat_R",
				locked = false,
				lockNames = {"TT_Lock_Blue_R.troy", "TT_Lock_Red_R.troy", "TT_Lock_Neutral_R.troy", },
				unlockNames = {"TT_Unlock_Blue_R.troy", "TT_Unlock_Red_R.troy", "TT_Unlock_Neutral_R.troy", },
			},
		},
		crystalScar = {},
		provingGrounds = {},
	}
	
	relics = {
		summonerRift = {},
		twistedTreeline = {},
		crystalScar = {
			{
				pos = { x = 5500, y = 60, z = 6500 },
				name = "Relic",
				team = TEAM_BLUE,
				spawn = 180,
				respawn = 180,
				advise = true,
				locked = false,
				precenceObject = (player.team == TEAM_BLUE and "Odin_Prism_Green.troy" or "Odin_Prism_Red.troy"),
			},
			{
				pos = { x = 7550, y = 60, z = 6500 },
				name = "Relic",
				team = TEAM_RED,
				spawn = 180,
				respawn = 180,
				advise = true,
				locked = false,
				precenceObject = (player.team == TEAM_RED and "Odin_Prism_Green.troy" or "Odin_Prism_Red.troy"),
			},
		},
		provingGrounds = {},
	}

	heals = {
		summonerRift = {},
		twistedTreeline = {},
		provingGrounds = {},
		crystalScar = {
			{
				name = "Heal",
				objectName = "OdinShieldRelic",
				respawn = 30,
				objects = {},
			},
		},
	}
	
	function addCampCreepAltar(object)
		if object ~= nil and object.name ~= nil then
			for i,monster in pairs(monsters[mapName]) do
				for j,camp in pairs(monster.camps) do
					if camp.name == object.name then
						camp.object = object
						return
					end
					if object.type == "obj_AI_Minion" then
						for k,creepPack in ipairs(camp.creeps) do
							for l,creep in ipairs(creepPack) do
								if object.name == creep.name then
									creep.object = object
									return
								end
							end
						end
					end
				end
			end
			for i,altar in pairs(altars[mapName]) do
				if altar.objectName == object.name then
					altar.object = object
					altar.minimap = GetMinimap(object)
				end
				if altar.locked then
					for j,lockName in pairs(altar.unlockNames) do
						if lockName == object.name then
							altar.locked = false
							return
						end
					end
				else
					for j,lockName in pairs(altar.lockNames) do
						if lockName == object.name then
							altar.drawColor = 0
							altar.drawText = ""
							altar.locked = true
							altar.advised = false
							altar.advisedBefore = false
							return
						end
					end
				end
			end
			for i,relic in pairs(relics[mapName]) do
				if relic.precenceObject == object.name then
					relic.object = object
					relic.locked = false
					return
				end
			end
			for i,heal in pairs(heals[mapName]) do
				if heal.objectName == object.name then
					for j,healObject in pairs(heal.objects) do
						if (GetDistance(healObject, object) < 50) then
							healObject.object = object
							healObject.found = true
							healObject.locked = false
							return
						end
					end
					local k = #heal.objects + 1
					heals[mapName][i].objects[k] = {found = true, locked = false, object = object, x = object.x, y = object.y, z = object.z, minimap = GetMinimap(object), }
					return
				end
			end
		end
	end

	function removeCreep(object)
		if object ~= nil and object.type == "obj_AI_Minion" and object.name ~= nil then
			for i,monster in pairs(monsters[mapName]) do
				for j,camp in pairs(monster.camps) do
					for k,creepPack in ipairs(camp.creeps) do
						for l,creep in ipairs(creepPack) do
							if object.name == creep.name then
								creep.object = nil
								return
							end
						end
					end
				end
			end
		end
	end

	function OnLoad()
		mapName = GetMap().shortName
		if monsters[mapName] == nil then
			mapName = nil
			monsters = nil
			addCampCreepAltar = nil
			removeCreep = nil
			addAltarObject = nil
			return
		else
			startTick = GetStart().tick
			gameState = GameState()
			-- CONFIG
			MMTConfig = scriptConfig("Timers 0.2", "minimapTimers")
			MMTConfig:addParam("pingOnRespawn", "Ping on respawn", SCRIPT_PARAM_ONOFF, true) -- ping location on respawn
			MMTConfig:addParam("pingOnRespawnBefore", "Ping before respawn", SCRIPT_PARAM_ONOFF, true) -- ping location before respawn
			MMTConfig:addParam("textOnRespawn", "Chat on respawn", SCRIPT_PARAM_ONOFF, true) -- print chat text on respawn
			MMTConfig:addParam("textOnRespawnBefore", "Chat before respawn", SCRIPT_PARAM_ONOFF, true) -- print chat text before respawn
			MMTConfig:addParam("adviceEnemyMonsters", "Advice enemy monster", SCRIPT_PARAM_ONOFF, true) -- advice enemy monster, or just our monsters
			MMTConfig:addParam("adviceBefore", "Advice Time", SCRIPT_PARAM_SLICE, 20, 1, 40, 0) -- time in second to advice before monster respawn
			for i,monster in pairs(monsters[mapName]) do
				monster.isSeen = false
				for j,camp in pairs(monster.camps) do
					camp.enemyTeam = (camp.team == TEAM_ENEMY)
					camp.status = 0
					camp.drawText = ""
					camp.drawColor = 0xFF00FF00
				end
			end
			for i = 1, objManager.maxObjects do
				local object = objManager:getObject(i)
				if object ~= nil then 
					addCampCreepAltar(object)
				end
			end
			AddCreateObjCallback(addCampCreepAltar)
			AddDeleteObjCallback(removeCreep)
			
			function OnTick()
				if gameState:gameIsOver() then return end
				local GameTime = (GetTickCount()-startTick) / 1000
				local monsterCount = 0
				for i,monster in pairs(monsters[mapName]) do
					for j,camp in pairs(monster.camps) do
						local campStatus = 0
						for k,creepPack in ipairs(camp.creeps) do
							for l,creep in ipairs(creepPack) do
								if creep.object ~= nil and creep.object.valid and creep.object.dead == false then
									if l == 1 then
										campStatus = 1
									elseif campStatus ~= 1 then
										campStatus = 2
									end
								end
							end
						end
						--[[  Not used until camp.showOnMinimap work
						if (camp.object and camp.object.showOnMinimap == 1) then
							-- camp is here
							if campStatus == 0 then campStatus = 3 end
						elseif camp.status == 3 then 						-- empty not seen when killed
							campStatus = 5
						elseif campStatus == 0 and (camp.status == 1 or camp.status == 2) then
							campStatus = 4
							camp.deathTick = tick
						end
						]]
						-- temp fix until camp.showOnMinimap work
						-- not so good
						if camp.object ~= nil and camp.object.valid then 
							camp.minimap = GetMinimap(camp.object)
							if campStatus == 0 then
								if (camp.status == 1 or camp.status == 2) then
									campStatus = 4
									camp.advisedBefore = false
									camp.advised = false
									camp.respawnTime = math.ceil(GameTime) + monster.respawn
									camp.respawnText = (camp.enemyTeam and "Enemy " or "")..monster.name.." respawn at "..TimerText(camp.respawnTime)
								elseif (camp.status == 4) then
									campStatus = 4
								else
									campStatus = 3
								end
							end
						elseif camp.pos ~= nil then
							camp.minimap = GetMinimap(camp.pos)
							if (GameTime < monster.spawn) then
								campStatus = 4
								camp.advisedBefore = true
								camp.advised = true
								camp.respawnTime = monster.spawn
								camp.respawnText = (camp.enemyTeam and "Enemy " or "")..monster.name.." spawn at "..TimerText(camp.respawnTime)
							end
						end
						if camp.status ~= campStatus or campStatus == 4 then
							if campStatus ~= 0 then
								if monster.isSeen == false then monster.isSeen = true end
								camp.status = campStatus
							end
							if camp.status == 1 then				-- ready
								camp.drawText = "ready"
								camp.drawColor = 0xFF00FF00
							elseif camp.status == 2 then			-- ready, master creeps dead
								camp.drawText = "stolen"
								camp.drawColor = 0xFFFF0000
							elseif camp.status == 3 then			-- ready, not creeps shown
								camp.drawText = "   ?"
								camp.drawColor = 0xFF00FF00
							elseif camp.status == 4 then			-- empty from creeps kill
								local secondLeft = math.ceil(math.max(0, camp.respawnTime - GameTime))
								if monster.advise == true and (MMTConfig.adviceEnemyMonsters == true or camp.enemyTeam == false) then
									if secondLeft == 0 and camp.advised == false then
										camp.advised = true
										if MMTConfig.textOnRespawn then PrintChat("<font color='#00FFCC'>"..(camp.enemyTeam and "Enemy " or "")..monster.name.."</font><font color='#FFAA00'> has respawned</font>") end
										if MMTConfig.pingOnRespawn then PingSignal(PING_FALLBACK,camp.object.x,camp.object.y,camp.object.z,2) end
									elseif secondLeft <= MMTConfig.adviceBefore and camp.advisedBefore == false then
										camp.advisedBefore = true
										if MMTConfig.textOnRespawnBefore then PrintChat("<font color='#00FFCC'>"..(camp.enemyTeam and "Enemy " or "")..monster.name.."</font><font color='#FFAA00'> will respawn in </font><font color='#00FFCC'>"..secondLeft.." sec</font>") end
										if MMTConfig.pingOnRespawnBefore then PingSignal(PING_FALLBACK,camp.object.x,camp.object.y,camp.object.z,2) end
									end
								end
								-- temp fix until camp.showOnMinimap work
								if secondLeft == 0 then
									camp.status = 0
								end
								camp.drawText = " "..TimerText(secondLeft)
								camp.drawColor = 0xFFFFFF00
							elseif camp.status == 5 then			-- camp found empty (not using yet)
								camp.drawText = "   -"
								camp.drawColor = 0xFFFF0000
							end
						end
						-- shift click
						if IsKeyDown(16) and camp.status == 4 then
							camp.drawText = " "..(camp.respawnTime ~= nil and TimerText(camp.respawnTime) or "")
							camp.textUnder = (CursorIsUnder(camp.minimap.x - 9, camp.minimap.y - 5, 20, 8))
						else
							camp.textUnder = false
						end
					end
				end
			
				-- altars
				for i,altar in pairs(altars[mapName]) do
					if altar.object and altar.object.valid then
						if altar.locked then
							local tmpTime = ((altar.object.maxMana - altar.object.mana) / 20100)
							if GameTime < altar.spawn then
								altar.secondLeft = math.ceil(math.max(0, altar.spawn - GameTime))
							else
								altar.secondLeft = math.ceil(math.max(0, altar.respawn - (tmpTime * altar.respawn)))
							end
							altar.unlockTime = math.ceil(GameTime + altar.secondLeft)
							altar.unlockText = altar.name.." unlock at "..TimerText(altar.unlockTime)
							altar.drawColor = 0xFFFFFF00
							if altar.advise == true then
								if altar.secondLeft == 0 and altar.advised == false then
									altar.advised = true
									if MMTConfig.textOnRespawn then PrintChat("<font color='#00FFCC'>"..altar.name.."</font><font color='#FFAA00'> is unlocked</font>") end
									if MMTConfig.pingOnRespawn then PingSignal(PING_FALLBACK,altar.object.x,altar.object.y,altar.object.z,2) end
								elseif altar.secondLeft <= MMTConfig.adviceBefore and altar.advisedBefore == false then
									altar.advisedBefore = true
									if MMTConfig.textOnRespawnBefore then PrintChat("<font color='#00FFCC'>"..altar.name.."</font><font color='#FFAA00'> will unlock in </font><font color='#00FFCC'>"..altar.secondLeft.." sec</font>") end
									if MMTConfig.pingOnRespawnBefore then PingSignal(PING_FALLBACK,altar.object.x,altar.object.y,altar.object.z,2) end
								end
							end
							-- shift click
							if IsKeyDown(16) then
								altar.drawText = " "..(altar.unlockTime ~= nil and TimerText(altar.unlockTime) or "")
								altar.textUnder = (CursorIsUnder(altar.minimap.x - 9, altar.minimap.y - 5, 20, 8))
							else
								altar.drawText = " "..(altar.secondLeft ~= nil and TimerText(altar.secondLeft) or "")
								altar.textUnder = false
							end
						end
					end
				end
			
				-- relics
				for i,relic in pairs(relics[mapName]) do
					if (not relic.locked and (not relic.object or not relic.object.valid or relic.dead)) then
						if GameTime < relic.spawn then
							relic.unlockTime = relic.spawn - GameTime
						else
							relic.unlockTime = math.ceil(GameTime + relic.respawn)
						end
						relic.advised = false
						relic.advisedBefore = false
						relic.drawText = ""
						relic.unlockText = relic.name.." respawn at "..TimerText(relic.unlockTime)							
						relic.drawColor = 4288610048
						--FF9EFF00
						relic.minimap = GetMinimap(relic.pos)
						relic.locked = true
					end
					if relic.locked then
						relic.secondLeft = math.ceil(math.max(0, relic.unlockTime - GameTime))
						if relic.advise == true then
							if relic.secondLeft == 0 and relic.advised == false then
								relic.advised = true
								if MMTConfig.textOnRespawn then PrintChat("<font color='#00FFCC'>"..relic.name.."</font><font color='#FFAA00'> has respawned</font>") end
								if MMTConfig.pingOnRespawn then PingSignal(PING_FALLBACK,relic.pos.x,relic.pos.y,relic.pos.z,2) end
							elseif relic.secondLeft <= MMTConfig.adviceBefore and relic.advisedBefore == false then
								relic.advisedBefore = true
								if MMTConfig.textOnRespawnBefore then PrintChat("<font color='#00FFCC'>"..relic.name.."</font><font color='#FFAA00'> will respawn in </font><font color='#00FFCC'>"..relic.secondLeft.." sec</font>") end
								if MMTConfig.pingOnRespawnBefore then PingSignal(PING_FALLBACK,relic.pos.x,relic.pos.y,relic.pos.z,2) end
							end
						end
						-- shift click
						if IsKeyDown(16) then
							relic.drawText = " "..(relic.unlockTime ~= nil and TimerText(relic.unlockTime) or "")
							relic.textUnder = (CursorIsUnder(relic.minimap.x - 9, relic.minimap.y - 5, 20, 8))
						else
							relic.drawText = " "..(relic.secondLeft ~= nil and TimerText(relic.secondLeft) or "")
							relic.textUnder = false
						end
					end
				end
			
				for i,heal in pairs(heals[mapName]) do
					for j,healObject in pairs(heal.objects) do
						if (not healObject.locked and healObject.found and (not healObject.object or not healObject.object.valid or healObject.object.dead)) then
							healObject.drawColor = 0xFF00FF04
							healObject.unlockTime = math.ceil(GameTime + heal.respawn)
							healObject.drawText = ""
							healObject.found = false
							healObject.locked = true
						end
						if healObject.locked then
							-- shift click
							local secondLeft = math.ceil(math.max(0, healObject.unlockTime - GameTime))
							if IsKeyDown(16) then
								healObject.drawText = " "..(healObject.unlockTime ~= nil and TimerText(healObject.unlockTime) or "")
								healObject.textUnder = (CursorIsUnder(healObject.minimap.x - 9, healObject.minimap.y - 5, 20, 8))
							else
								healObject.drawText = " "..(secondLeft ~= nil and TimerText(secondLeft) or "")
								healObject.textUnder = false
							end
							if secondLeft == 0 then healObject.locked = false end
						end
					end
				end
			end

			function OnDraw()
				if gameState:gameIsOver() then return end
				for i,monster in pairs(monsters[mapName]) do
					if monster.isSeen == true then
						for j,camp in pairs(monster.camps) do
							if camp.status == 2 then
								DrawText("X",16,camp.minimap.x - 4, camp.minimap.y - 5, camp.drawColor)
							elseif camp.status == 4 then
								DrawText(camp.drawText,16,camp.minimap.x - 9, camp.minimap.y - 5, camp.drawColor)
							end
						end
					end
				end
				for i,altar in pairs(altars[mapName]) do
					if altar.locked then
						DrawText(altar.drawText,16,altar.minimap.x - 9, altar.minimap.y - 5, altar.drawColor)
					end
				end
				for i,relic in pairs(relics[mapName]) do
					if relic.locked then
						DrawText(relic.drawText,16,relic.minimap.x - 9, relic.minimap.y - 5, relic.drawColor)
					end
				end
				for i,heal in pairs(heals[mapName]) do
					for j,healObject in pairs(heal.objects) do
						if healObject.locked then
							DrawText(healObject.drawText,16,healObject.minimap.x - 9, healObject.minimap.y - 5, healObject.drawColor)
						end
					end
				end
			end

			function OnWndMsg(msg,key)
				if msg == WM_LBUTTONDOWN and IsKeyDown(16) then
					for i,monster in pairs(monsters[mapName]) do
						if monster.isSeen == true then
							if monster.iconUnder then
								monster.advise = not monster.advise
								break
							else
								for j,camp in pairs(monster.camps) do
									if camp.textUnder then
										if camp.respawnText ~= nil then SendChat(""..camp.respawnText) end
										break
									end
								end
							end
						end
					end
					for i,altar in pairs(altars[mapName]) do
						if altar.locked and altar.textUnder then
							if altar.unlockText ~= nil then SendChat(""..altar.unlockText) end
							break
						end
					end
				end
			end
		
		end
	end
end