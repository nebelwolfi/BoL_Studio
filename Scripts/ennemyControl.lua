--[[
	Script: ennemyControl v0.2
	Author: SurfaceS

	Based on mixed ideas from :
	Kilua -> Kilia UI
	Manciuszz -> Low Awareness SCRIPT

	exposed variables : 	-

	UPDATES :
	v0.1				initial release
	v0.2				BoL Studio Version
]]

do
	local ennemyControl = {}
	ennemyControl.alert = {}

	--[[      CONFIG      ]]
	ennemyControl.alert.active = true					-- Draw cricle on approching enemy champions hidden for defined time.
	ennemyControl.alert.range = 2500 					-- Distance that the script will consider worthy of alerting you of incoming enemy champions.
	ennemyControl.alert.missTime = 10000 				-- How long, in ms, enemy champion has to be missing in order for the script to alert of his arrival. (10s)
	ennemyControl.alert.circleSize = 1250 				-- Circle radius that surrounds incoming enemy champion.
	ennemyControl.alert.time = 5000 					-- How long, in ms, the circle will remain there. (5s)

	--[[      GLOBAL      ]]
	ennemyControl.configFile = LIB_PATH.."ennemyControl.cfg"
	ennemyControl.ennemyHeros = {}
	ennemyControl.herosSprite = {}
	ennemyControl.summonerSprite = {}
	ennemyControl.shiftKeyPressed = false
	ennemyControl.spells = {SPELL_1, SPELL_2, SPELL_3, SPELL_4}
	ennemyControl.summoners = {SUMMONER_1, SUMMONER_2}
	ennemyControl.display = {x = 300, y = 200, rotation = 0, move = false}
	ennemyControl.case_gap = 86 --70

	--[[      CODE      ]]
	function ennemyControl.writeConfigs()
		local file = io.open(ennemyControl.configFile, "w")
		if file then
			local offset1 = ennemyControl.display.x
			local offset2 = ennemyControl.display.y
			file:write("return { x = "..ennemyControl.display.x..", y = "..ennemyControl.display.y..", rotation = "..ennemyControl.display.rotation..", move = false }")
			file:close()
		end
	end

	function ennemyControl.refreshDrawPositions(ennemyIndex)
		local ennemyHero = ennemyControl.ennemyHeros[ennemyIndex]
		-- refresh ennemyControl display
		ennemyHero.display.teamFrame = {name = (ennemyControl.display.rotation == 1 and "R" or ""), x = ennemyControl.display.x +(ennemyIndex-1)*65 ,y = ennemyControl.display.y }
		ennemyHero.display.icon = {x = ennemyHero.display.teamFrame.x + (ennemyControl.display.rotation == 1 and 19 or 4) ,y = ennemyHero.display.teamFrame.y + 9 }
		ennemyHero.display.level = {x = ennemyHero.display.teamFrame.x + (ennemyControl.display.rotation == 1 and 15 or 34) + (ennemyHero.hero.level < 10 and 4 or 0), y = ennemyHero.display.teamFrame.y + 37}
		ennemyHero.display.ulti = {x = ennemyHero.display.teamFrame.x + (ennemyControl.display.rotation == 1 and 9 or 43) ,y = ennemyHero.display.teamFrame.y + 2}
		ennemyHero.display.timerMask = {x = ennemyHero.display.teamFrame.x + (ennemyControl.display.rotation == 1 and 32 or 6), y = ennemyHero.display.teamFrame.y + 44}
		ennemyHero.display.timer = {x = ennemyHero.display.teamFrame.x + (ennemyControl.display.rotation == 1 and 33 or 7), y = ennemyHero.display.teamFrame.y + 37}
		ennemyHero.display.health = {x = ennemyHero.display.teamFrame.x + (ennemyControl.display.rotation == 1 and 16 or 6), y = ennemyHero.display.teamFrame.y + 58}
		ennemyHero.display.mana = {x = ennemyHero.display.teamFrame.x + (ennemyControl.display.rotation == 1 and 16 or 6), y = ennemyHero.display.teamFrame.y + 67}
		-- extended
		ennemyHero.display.spell1 = {x = ennemyHero.display.teamFrame.x + 2, y = ennemyHero.display.teamFrame.y - 20}
		ennemyHero.display.spell2 = {x = ennemyHero.display.teamFrame.x + 30, y = ennemyHero.display.teamFrame.y - 20}
		ennemyHero.display.spell3 = {x = ennemyHero.display.teamFrame.x + 2, y = ennemyHero.display.teamFrame.y - 45}
		ennemyHero.display.spell4 = {x = ennemyHero.display.teamFrame.x + 30, y = ennemyHero.display.teamFrame.y - 45}
		ennemyHero.display.spellSum1 = {x = ennemyHero.display.teamFrame.x + 2, y = ennemyHero.display.teamFrame.y - 70}
		ennemyHero.display.spellSum2 = {x = ennemyHero.display.teamFrame.x + 30, y = ennemyHero.display.teamFrame.y - 70}
		-- champ infos
		ennemyHero.display.champInfos = {x = ennemyHero.display.teamFrame.x, y = ennemyHero.display.teamFrame.y - 120}
		ennemyHero.display.totalDamage = {x = ennemyHero.display.teamFrame.x + 22, y = ennemyHero.display.teamFrame.y - 115}
		ennemyHero.display.ap = {x = ennemyHero.display.teamFrame.x + 22, y = ennemyHero.display.teamFrame.y - 96}
		ennemyHero.display.attackSpeed = {x = ennemyHero.display.teamFrame.x + 22, y = ennemyHero.display.teamFrame.y - 77}
		ennemyHero.display.ms = {x = ennemyHero.display.teamFrame.x + 22, y = ennemyHero.display.teamFrame.y - 60}
		ennemyHero.display.armor = {x = ennemyHero.display.teamFrame.x + 22, y = ennemyHero.display.teamFrame.y - 40}
		ennemyHero.display.magicArmor = {x = ennemyHero.display.teamFrame.x + 22, y = ennemyHero.display.teamFrame.y - 22}
		ennemyControl.display.spellSize = 20
	end

	function ennemyControl.updateEnnemyData(ennemyIndex)
		local tick = GetTickCount()
		local ennemyHero = ennemyControl.ennemyHeros[ennemyIndex]
		if ennemyHero.hero.dead then
			ennemyHero.dead = true
			if ennemyHero.deathStart == nil then
				ennemyHero.deathStart = tick
			end
			ennemyHero.deathTimer = math.ceil(ennemyHero.hero.deathTimer - ((tick - ennemyHero.deathStart) / 1000))
			ennemyHero.deathTimerText = timerText(ennemyHero.deathTimer, 4)
			ennemyHero.missTimer = nil
			ennemyHero.missStart = nil
			ennemyHero.drawAlertCircle = false
		else
			ennemyHero.dead = false
			ennemyHero.deathStart = nil
			if ennemyHero.hero.visible == false then
				ennemyHero.missing = true
				if ennemyHero.missStart == nil then
					ennemyHero.missStart = tick
				end
				ennemyHero.missTimer = tick - ennemyHero.missStart
				if ennemyControl.alert.active and ennemyHero.missTimer > ennemyControl.alert.missTime then
					ennemyHero.alertActive = true
				end
				ennemyHero.missTimerText = timerText(ennemyHero.missTimer / 1000, 4)
			else
				ennemyHero.missing = false
				ennemyHero.missStart = nil
				if ennemyControl.alert.active and ennemyHero.alertActive and ennemyHero.drawAlertCircle == false and GetDistance(ennemyHero.hero) < ennemyControl.alert.range then
					ennemyHero.alertTick = tick
					ennemyHero.drawAlertCircle = true
				end
			end
			-- reset the ennemyControl.alert
			local drawAlertCircle = false
			if ennemyControl.alert.active and ennemyHero.alertActive then
				if ennemyHero.alertTick ~= nil then
					if ennemyHero.alertTick > tick - ennemyControl.alert.time then
						drawAlertCircle = true
					else
						ennemyHero.alertActive = false
					end
				end
			end
			ennemyHero.drawAlertCircle = drawAlertCircle
		end
		-- CHAMP INFOS
		if ennemyControl.shiftKeyPressed then
			ennemyHero.totalDamage = ""..math.ceil(ennemyHero.hero.totalDamage)
			ennemyHero.ap = ""..math.ceil(ennemyHero.hero.ap)
			ennemyHero.attackSpeed = ""..ennemyHero.hero.attackSpeed
			ennemyHero.ms = ""..math.ceil(ennemyHero.hero.ms)
			ennemyHero.armor = ""..math.ceil(ennemyHero.hero.armor)
			ennemyHero.magicArmor = ""..math.ceil(ennemyHero.hero.magicArmor)
		end
		-- SPELL STATE
		if ennemyHero.extended then
			for i = 1, 4 do
				ennemyHero.spellState[i] = ennemyHero.hero:CanUseSpell(ennemyControl.spells[i])
				if ennemyHero.hero.isAI then
					if ennemyHero.spellLearned[i] == false and ennemyHero.spellState[i] == COOLDOWN then ennemyHero.spellLearned[i] = true end
					if ennemyHero.spellState[i] == NOTLEARNED and (ennemyHero.spellLearned[i] or ennemyHero.hero.level >= (i == 4 and 6 or 13)) then ennemyHero.spellState[i] = READY end
				end
				-- calculate cd
				if ennemyHero.lastSpellState[i] == nil then ennemyHero.lastSpellState[i] = ennemyHero.spellState[i] end
				if ennemyHero.spellState[i] == READY and ennemyHero.lastSpellState[i] == COOLDOWN and ennemyHero.lastSpellCd[i] ~= nil then
					ennemyHero.spellCd[i] = tick - ennemyHero.lastSpellCd[i]
				end
				if ennemyHero.spellState[i] == COOLDOWN then
					if ennemyHero.lastSpellState[i] == READY then
						ennemyHero.lastSpellCd[i] = tick
					end
					if ennemyHero.spellCd[i] ~= nil then
						ennemyHero.spellCurrentCd[i] = ennemyHero.lastSpellCd[i] - tick + ennemyHero.spellCd[i]
						ennemyHero.spellCurrentCdDraw[i] = math.max(0,math.floor((ennemyHero.spellCurrentCd[i] / ennemyHero.spellCd[i])*ennemyControl.display.spellSize))
					end
				else
					ennemyHero.spellCurrentCd[i] = nil
				end
				ennemyHero.lastSpellState[i] = ennemyHero.spellState[i]
			end
			ennemyHero.spellSum1 = ennemyHero.hero:CanUseSpell(SUMMONER_1)
			ennemyHero.spellSum2 = ennemyHero.hero:CanUseSpell(SUMMONER_2)
		else
			ennemyHero.spell4 = ennemyHero.hero:CanUseSpell(_R)
			if ennemyHero.spell4 == NOTLEARNED and ennemyHero.hero.isAI and ennemyHero.hero.level >= 6 then ennemyHero.spell4 = READY end
			ennemyHero.spell1 = NOTLEARNED
			ennemyHero.spell2 = NOTLEARNED
			ennemyHero.spell3 = NOTLEARNED
			ennemyHero.spellSum1 = NOTLEARNED
			ennemyHero.spellSum2 = NOTLEARNED
		end
		if ennemyHero.hero.maxHealth > 0 then
			ennemyHero.healthPart = (ennemyHero.hero.health/ennemyHero.hero.maxHealth)*42
		else
			ennemyHero.healthPart = 0
		end
		if ennemyHero.hero.maxMana > 0 then
			ennemyHero.manaPart = (ennemyHero.hero.mana/ennemyHero.hero.maxMana)*42
		else
			ennemyHero.manaPart = 0
		end
	end

	function OnDraw()
		if gameState:gameIsOver() then return end
		for i,ennemyHero in pairs(ennemyControl.ennemyHeros) do
			if ennemyHero.hero ~= nil then
				--ennemyControl["teamFrameBG"..ennemyHero.teamFrame.name]:Draw(ennemyHero.teamFrame.x,ennemyHero.teamFrame.y,0xFF)	-- CASE BG
				ennemyControl.herosSprite[ennemyHero.hero.charName]:Draw(ennemyHero.display.icon.x, ennemyHero.display.icon.y,0xFF)				-- ICON CHAMPION
				ennemyControl["teamFrame"..ennemyHero.display.teamFrame.name]:Draw(ennemyHero.display.teamFrame.x,ennemyHero.display.teamFrame.y,0xFF)		-- CASE
				DrawText(""..ennemyHero.hero.level,15,ennemyHero.display.level.x,ennemyHero.display.level.y,0xFFFFD700)					-- LVL TXT
				-- ULTI READY
				if ennemyHero.spell4 == READY then
					ennemyControl.spriteultiready:Draw(ennemyHero.display.ulti.x,ennemyHero.display.ulti.y,0xFF)
				end
				-- DEAD TIMER
				if ennemyHero.dead == true then
					DrawLine(ennemyHero.display.timerMask.x, ennemyHero.display.timerMask.y, ennemyHero.display.timerMask.x + 25, ennemyHero.display.timerMask.y, 11, 4287299584)
					DrawText(ennemyHero.deathTimerText,15,ennemyHero.display.timer.x,ennemyHero.display.timer.y,4294967295)
				-- MISS TIMER
				elseif ennemyHero.missing == true then
					DrawLine(ennemyHero.display.timerMask.x, ennemyHero.display.timerMask.y, ennemyHero.display.timerMask.x + 25, ennemyHero.display.timerMask.y, 11, 4281221816)
					DrawText(ennemyHero.missTimerText,15,ennemyHero.display.timer.x,ennemyHero.display.timer.y,4294967295)
				end
				
				if ennemyHero.healthPart >= 1 then
					DrawLine(ennemyHero.display.health.x, ennemyHero.display.health.y, ennemyHero.display.health.x + ennemyHero.healthPart, ennemyHero.display.health.y, 6, 4278884959)
				end
				if ennemyHero.manaPart >= 1 then
					DrawLine(ennemyHero.display.mana.x, ennemyHero.display.mana.y, ennemyHero.display.mana.x + ennemyHero.manaPart, ennemyHero.display.mana.y, 3, 4281221816)
				end
				if ennemyControl.shiftKeyPressed then
					ennemyControl.champInfos:Draw(ennemyHero.display.champInfos.x, ennemyHero.display.champInfos.y,0xFF)
					DrawText(ennemyHero.totalDamage,15,ennemyHero.display.totalDamage.x,ennemyHero.display.totalDamage.y,4294967295)
					DrawText(ennemyHero.ap,15,ennemyHero.display.ap.x,ennemyHero.display.ap.y,4294967295)
					DrawText(ennemyHero.attackSpeed,15,ennemyHero.display.attackSpeed.x,ennemyHero.display.attackSpeed.y,4294967295)
					DrawText(ennemyHero.ms,15,ennemyHero.display.ms.x,ennemyHero.display.ms.y,4294967295)
					DrawText(ennemyHero.armor,15,ennemyHero.display.armor.x,ennemyHero.display.armor.y,4294967295)
					DrawText(ennemyHero.magicArmor,15,ennemyHero.display.magicArmor.x,ennemyHero.display.magicArmor.y,4294967295)
				elseif ennemyHero.extended then
					for i = 1, 4 do
						if ennemyHero.spellState[i] == READY then
							DrawLine(ennemyHero.display["spell"..i].x, ennemyHero.display["spell"..i].y, ennemyHero.display["spell"..i].x + ennemyControl.display.spellSize, ennemyHero.display["spell"..i].y, ennemyControl.display.spellSize, 4278225733) -- dark green
						elseif ennemyHero.spellState[i] == COOLDOWN then
							DrawLine(ennemyHero.display["spell"..i].x, ennemyHero.display["spell"..i].y, ennemyHero.display["spell"..i].x + ennemyControl.display.spellSize, ennemyHero.display["spell"..i].y, ennemyControl.display.spellSize, 4287299584) -- dark red
							if ennemyHero.spellCurrentCdDraw[i] ~= nil then
								DrawLine(ennemyHero.display["spell"..i].x, ennemyHero.display["spell"..i].y, ennemyHero.display["spell"..i].x + ennemyControl.display.spellSize - ennemyHero.spellCurrentCdDraw[i], ennemyHero.display["spell"..i].y, ennemyControl.display.spellSize, 4278198886) -- dark blue
							end
						else
							DrawLine(ennemyHero.display["spell"..i].x, ennemyHero.display["spell"..i].y, ennemyHero.display["spell"..i].x + ennemyControl.display.spellSize, ennemyHero.display["spell"..i].y, ennemyControl.display.spellSize, 4285098345) -- dim grey
						end
					end
					DrawText("Q",14,ennemyHero.display.spell1.x+5,ennemyHero.display.spell1.y-6,4294967295)
					DrawText("W",14,ennemyHero.display.spell2.x+5,ennemyHero.display.spell2.y-6,4294967295)
					DrawText("E",14,ennemyHero.display.spell3.x+6,ennemyHero.display.spell3.y-6,4294967295)
					DrawText("R",14,ennemyHero.display.spell4.x+6,ennemyHero.display.spell4.y-6,4294967295)
					for i = 1, 2 do
						ennemyControl.summonerSprite[ennemyHero.summonerSpellName[i]]:Draw(ennemyHero.display["spellSum"..i].x, ennemyHero.display["spellSum"..i].y - 10,0xFF)
						if ennemyHero["spellSum"..i] == COOLDOWN then
							DrawLine(ennemyHero.display["spellSum"..i].x, ennemyHero.display["spellSum"..i].y, ennemyHero.display["spellSum"..i].x + 20, ennemyHero.display["spellSum"..i].y, 20, 2298478591)
						end
					end
				end
				if ennemyHero.drawAlertCircle then
					DrawCircle(ennemyHero.hero.x, ennemyHero.hero.y, ennemyHero.hero.z, ennemyControl.alert.circleSize, 0xFFFF0000)
				end
			end
		end
	end

	function OnTick()
		if gameState:gameIsOver() then return end
		-- walkaround OnWndMsg bug
		ennemyControl.shiftKeyPressed = IsKeyDown(16)
		if ennemyControl.shiftKeyPressed and IsKeyDown(1) then
			if CursorIsUnder(ennemyControl.display.x + 10, ennemyControl.display.y, 50, 10) then
				ennemyControl.display.move = true
			elseif CursorIsUnder(ennemyControl.display.x, ennemyControl.display.y + 10, 10, ennemyControl.case_gap - 10) then
				ennemyControl.display.rotation = ennemyControl.display.rotation + 1
				if ennemyControl.display.rotation > 3 then ennemyControl.display.rotation = 0 end
				ennemyControl.writeConfigs()
			else
				for i,ennemyHero in pairs(ennemyControl.ennemyHeros) do
					if CursorIsUnder(ennemyHero.display.icon.x, ennemyHero.display.icon.y, 40, 40) then
						ennemyHero.extended = (ennemyHero.extended == false)
						break
					end
				end
			end
		elseif ennemyControl.display.move and IsKeyDown(1) == false then
			ennemyControl.display.move = false
			ennemyControl.writeConfigs()
			ennemyControl.display.cursorShift = nil
		end
		
		-- move display
		if ennemyControl.display.move == true then
			if ennemyControl.display.cursorShift == nil or ennemyControl.display.cursorShift.x == nil or ennemyControl.display.cursorShift.y == nil then
				ennemyControl.display.cursorShift = { x = GetCursorPos().x - ennemyControl.display.x, y = GetCursorPos().y - ennemyControl.display.y, }
			else
				ennemyControl.display.x = GetCursorPos().x - ennemyControl.display.cursorShift.x
				ennemyControl.display.y = GetCursorPos().y - ennemyControl.display.cursorShift.y
			end
		end
		--update ennemy
		for i,ennemyHero in pairs(ennemyControl.ennemyHeros) do
			if ennemyControl.display.move then ennemyControl.refreshDrawPositions(i) end
			ennemyControl.updateEnnemyData(i)
		end
	end
	
	function OnLoad()
		gameState = GameState()
		if file_exists(ennemyControl.configFile) then ennemyControl.display = assert(loadfile(ennemyControl.configFile))() end
		local ennemyHerosCount = 0
		for i = 1, heroManager.iCount, 1 do
			local hero = heroManager:getHero(i) 
			if hero ~= nil and hero.team ~= player.team then 
				ennemyHerosCount = ennemyHerosCount + 1
				ennemyControl.ennemyHeros[ennemyHerosCount] = {}
				ennemyControl.ennemyHeros[ennemyHerosCount].hero = hero
				ennemyControl.ennemyHeros[ennemyHerosCount].charName = hero.charName
				ennemyControl.ennemyHeros[ennemyHerosCount].extended = false
				ennemyControl.ennemyHeros[ennemyHerosCount].display = {}
				ennemyControl.ennemyHeros[ennemyHerosCount].spellState = {}
				ennemyControl.ennemyHeros[ennemyHerosCount].lastSpellState = {}
				ennemyControl.ennemyHeros[ennemyHerosCount].spellCd = {}
				ennemyControl.ennemyHeros[ennemyHerosCount].lastSpellCd = {}
				ennemyControl.ennemyHeros[ennemyHerosCount].spellCurrentCd = {}
				ennemyControl.ennemyHeros[ennemyHerosCount].spellCurrentCdDraw = {}
				if hero.isAI then
					ennemyControl.ennemyHeros[ennemyHerosCount].spellLearned = {false, false, false, false}
				end
				ennemyControl.herosSprite[hero.charName] = GetSprite("Characters/"..hero.charName.."_Square_40.dds", "empty_Square_40.dds")
				-- SPELL SUMMONERS SPRITES
				ennemyControl.ennemyHeros[ennemyHerosCount].summonerSpellName = {}
				for j = 1, 2 do
					local summonerSpellName = hero:GetSpellData(ennemyControl.summoners[j]).name
					ennemyControl.ennemyHeros[ennemyHerosCount].summonerSpellName[j] = summonerSpellName
					if ennemyControl.summonerSprite[summonerSpellName] == nil then
						ennemyControl.summonerSprite[summonerSpellName] = GetSprite("Spells/"..summonerSpellName.."_20.dds", "empty_Square_20.dds")
					end
				end
				ennemyControl.refreshDrawPositions(ennemyHerosCount)
				ennemyControl.updateEnnemyData(ennemyHerosCount)
			end
		end
		ennemyControl.teamFrame = GetSprite("ennemyControl/TeamFrame_80.dds")
		ennemyControl.teamFrameR = GetSprite("ennemyControl/TeamFrame_80_R.dds")
		ennemyControl.champInfos = GetSprite("ennemyControl/Champ_Infos_50.dds")
		ennemyControl.spriteultiready = GetSprite("ennemyControl/UltiReady_12.dds")
	end
end
