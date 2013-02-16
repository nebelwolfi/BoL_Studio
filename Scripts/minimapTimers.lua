--[[
        Script: minimapTimers v0.1
		Author: SurfaceS
		
		In replacement of my Jungle Display v0.2
		
		UPDATES :
		v0.1					initial release
]]
require "AllClass"
do
	--[[      GLOBAL      ]]
	monsters = {
		summonerRift = {
			{	-- baron
				name = "baron",
				respawn = 420,
				advise = true,
				camps = {
					{
						name = "monsterCamp_12",
						creeps = { { { name = "Worm12.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
				},
			},
			{	-- dragon
				name = "dragon",
				respawn = 360,
				advise = true,
				camps = {
					{
						name = "monsterCamp_6",
						creeps = { { { name = "Dragon6.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
				},
			},
			{	-- blue
				name = "blue",
				respawn = 300,
				advise = true,
				camps = {
					{
						name = "monsterCamp_1",
						creeps = { { { name = "AncientGolem1.1.1" }, { name = "YoungLizard1.1.2" }, { name = "YoungLizard1.1.3" }, }, },
						team = TEAM_BLUE,
					},
					{
						name = "monsterCamp_7",
						creeps = { { { name = "AncientGolem7.1.1" }, { name = "YoungLizard7.1.2" }, { name = "YoungLizard7.1.3" }, }, },
						team = TEAM_RED,
					},
				},
			},
			{	-- red
				name = "red",
				respawn = 300,
				advise = true,
				camps = {
					{
						name = "monsterCamp_4",
						creeps = { { { name = "LizardElder4.1.1" }, { name = "YoungLizard4.1.2" }, { name = "YoungLizard4.1.3" }, }, },
						team = TEAM_BLUE,
					},
					{
						name = "monsterCamp_10",
						creeps = { { { name = "LizardElder10.1.1" }, { name = "YoungLizard10.1.2" }, { name = "YoungLizard10.1.3" }, }, },
						team = TEAM_RED,
					},
				},
			},
			{	-- wolves
				name = "wolves",
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
				respawn = 50,
				advise = false,
				camps = {
					{
						name = "monsterCamp_1",
						creeps = {
							{ { name = "TT_NWraith1.1.1" }, { name = "TT_NWraith21.1.2" }, { name = "TT_NWraith21.1.3" }, },
						},
						team = TEAM_BLUE,
					},
					{
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
				advise = false,
				camps = {
					{
						name = "monsterCamp_2",
						creeps = {
							{ { name = "TT_NGolem2.1.1" }, { name = "TT_NGolem22.1.2" } },
						},
						team = TEAM_BLUE,
					},
					{
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
				advise = false,
				camps = {
					{
						name = "monsterCamp_3",
						creeps = { { { name = "TT_NWolf3.1.1" }, { name = "TT_NWolf23.1.2" }, { name = "TT_NWolf23.1.3" } }, },
						team = TEAM_BLUE,
					},
					{
						name = "monsterCamp_6",
						creeps = { { { name = "TT_NWolf6.1.1" }, { name = "TT_NWolf26.1.2" }, { name = "TT_NWolf26.1.3" } }, },
						team = TEAM_RED,
					},
				},
			},
			{	-- Heal
				name = "Heal",
				respawn = 90,
				advise = true,
				camps = {
					{
						name = "monsterCamp_7",
						creeps = { { { name = "TT_Relic7.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
				},
			},
			{	-- Vilemaw
				name = "Vilemaw",
				respawn = 300,
				advise = true,
				camps = {
					{
						name = "monsterCamp_8",
						creeps = { { { name = "TT_Spiderboss8.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
				},
			},
		},
	}
	
	function addCampAndCreep(object)
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
			addCampAndCreep = nil
			removeCreep = nil
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
					addCampAndCreep(object)
				end
			end
			AddCreateObjCallback(addCampAndCreep)
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
									camp.deathTime = GameTime
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
										if MMTConfig.textOnRespawn then PrintChat("<font color='#00FFCC'>"..(camp.enemyTeam and "Enemy " or "")..monster.name.."</font> has respawned") end
										if MMTConfig.pingOnRespawn then PingSignal(PING_FALLBACK,camp.object.x,camp.object.y,camp.object.z,2) end
									elseif secondLeft <= MMTConfig.adviceBefore and camp.advisedBefore == false then
										camp.advisedBefore = true
										if MMTConfig.textOnRespawnBefore then PrintChat("<font color='#00FFCC'>"..(camp.enemyTeam and "Enemy " or "")..monster.name.."</font> will respawn in "..secondLeft.." sec") end
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
				end
			end
		
		end
	end
end