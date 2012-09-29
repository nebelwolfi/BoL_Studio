--[[
		Diana Combo v1.7 by eXtragoZ
			   
				It requires the Target Selector Library, TimingLib and Spell Damage Library
 
		-full combo: items -> Q -> R -> items -> W -> E
		-Supports Deathfire Grasp, Bilgewater Cutlass, Hextech Gunblade, Sheen, Trinity, Lich Bane and Ignite
		-Harass mode: Q
		-Mark killable target with a combo
		-Target configuration
		-Press shift to configure
		-The ultimate only will be used if it will reset
		-Maximum and minimum range for E
		-Maximum range for W
		-You can press T or Q -> spacebar
		-Informs where will use Q / default off
	   
		Explanation of the marks:
 
		Green circle:  Marks the current target to which you will do the combo
		Blue circle:  Mark a target that can be killed with a combo, if all the skills were available
		Red circle:  Mark a target that can be killed using items + pasive + 2 hits + Q x2 + W (3 orbs) + R x2 + ignite
		2 Red circles:  Mark a target that can be killed using items + 1 hits + Q + W (2 orbs) + R + R (if q is not on cd) + ignite
		3 Red circles:  Mark a target that can be killed using items (without Sheen, Trinity and Lich Bane) + Q + W (1 orb) + R + ignite
	   
]]
if GetMyHero().charName ~= "Diana" then return end
require "AllClass"
--require "spellDmg"

--[[            Config          ]]  
local HK=32 --spacebar
local QH = 84 --T to harass with Q
local useE = true
local tablex = 5
local tabley = 300
--[[            Code            ]]
 
local range = 900
local qcastspeed = 0.6
local tick = nil
-- Active
local scriptActive = false
local harass = false
local timeq = 0
local targetNextMove
local targetMoveq
local moonlightenemy = {}
local moonlightts = 0
local moonlightdone = false
-- draw
local drawcircles = true
local drawtext = true
local drawprediction = false
local waittxt = {}
local floattext = {"Skills are not available","Able to fight","Killable","Murder him!"}
local killable = {}
local shiftKeyPressed = false
-- ts
local ts
--
local ignite = nil
local DFGSlot, HXGSlot, BWCSlot, SheenSlot, TrinitySlot, LichBaneSlot = nil, nil, nil, false, false, false
 
function OnLoad()
	ts = TargetSelector(TARGET_LOW_HP,range,DAMAGE_MAGIC,false)
	if player:GetSpellData(SUMMONER_1).name:find("SummonerDot") then
		ignite = SUMMONER_1
	elseif player:GetSpellData(SUMMONER_2).name:find("SummonerDot") then
		ignite = SUMMONER_2
	else
		ignite = nil
	end
	for i=1, heroManager.iCount do
		local hero = heroManager:GetHero(i)
		waittxt[i] = i
		moonlightenemy[i] = 0
	end
end

function OnTick()
	ts:update()
	Prediction__OnTick()
	DCInventory()
	if tick == nil or GetTickCount() - tick >= 500 then
		tick = GetTickCount()
		DCDmgCalculation()
	end
	if ts.index ~= nil then
		targetNextMove = GetPredictionPos(ts.index, qcastspeed)
		moonlightts = moonlightenemy[ts.index]
	end
	if harass and ts.target and targetNextMove then
		if player:CanUseSpell(_Q) == READY and GetDistance(ts.target)<1100 then
			CastSpell(_Q, targetNextMove.x ,targetNextMove.z)
			targetMoveq = targetNextMove:clone()
		end
	end
	if scriptActive and ts.target then
		if DFGSlot ~= nil and player:CanUseSpell(DFGSlot) == READY then CastSpell(DFGSlot, ts.target) end
		if HXGSlot ~= nil and player:CanUseSpell(HXGSlot) == READY then CastSpell(HXGSlot, ts.target) end
		if BWCSlot ~= nil and player:CanUseSpell(BWCSlot) == READY then CastSpell(BWCSlot, ts.target) end
		if player:CanUseSpell(_Q) == READY and GetDistance(ts.target)<1100 and targetNextMove then                         
			targetMoveq = targetNextMove:clone()
			CastSpell(_Q, targetNextMove.x ,targetNextMove.z)
		end
		if player:CanUseSpell(_R) == READY and GetTickCount()-moonlightts < 3000 and not moonlightdone then
			moonlightdone = true
			CastSpell(_R,ts.target)
		end
		if DFGSlot ~= nil and player:CanUseSpell(DFGSlot) == READY then CastSpell(DFGSlot, ts.target) end
		if HXGSlot ~= nil and player:CanUseSpell(HXGSlot) == READY then CastSpell(HXGSlot, ts.target) end
		if BWCSlot ~= nil and player:CanUseSpell(BWCSlot) == READY then CastSpell(BWCSlot, ts.target) end
		if player:CanUseSpell(_W) == READY and GetDistance(ts.target)<240 then CastSpell(_W,ts.target) end
		if player:CanUseSpell(_E) == READY and GetDistance(ts.target)>300 and GetDistance(ts.target)<410 and useE then CastSpell(_E,ts.target) end
	end
end
function DCInventory()
	DFGSlot, HXGSlot, BWCSlot, SheenSlot, TrinitySlot, LichBaneSlot = GetInventorySlotItem(3128), GetInventorySlotItem(3146), GetInventorySlotItem(3144), GetInventoryHaveItem(3057), GetInventoryHaveItem(3078), GetInventoryHaveItem(3100)
end
function DCDmgCalculation()
	for i=1, heroManager.iCount do
		local enemy = heroManager:GetHero(i)
		if ValidTarget(enemy) then
			local dfgdamage, hxgdamage, bwcdamage, ignitedamage, Sheendamage, Trinitydamage, LichBanedamage  = 0, 0, 0, 0, 0, 0, 0
			local pdamage = getDmg("P",enemy,player) --Every third strike
			local qdamage = getDmg("Q",enemy,player)
			local wdamage = getDmg("W",enemy,player) --xOrb (3 orbs)
			local edamage = 0
			local rdamage = getDmg("R",enemy,player)
			local hitdamage = getDmg("AD",enemy,player)
			if DFGSlot ~= nil then dfgdamage = getDmg("DFG",enemy,player) end
			if HXGSlot ~= nil then hxgdamage = getDmg("HXG",enemy,player) end
			if BWCSlot ~= nil then bwcdamage = getDmg("BWC",enemy,player) end
			if ignite ~= nil then ignitedamage = getDmg("IGNITE",enemy,player) end
			if SheenSlot then Sheendamage = hitdamage end
			if TrinitySlot then Trinitydamage = hitdamage*1.5 end  
			if LichBaneSlot then LichBanedamage = getDmg("LICHBANE",enemy,player) end
			local combo1 = hitdamage*2 + pdamage + qdamage*2 + wdamage*3 + rdamage*2 + Sheendamage + Trinitydamage + LichBanedamage --0 cd
			local combo2 = hitdamage*2 + pdamage + Sheendamage + Trinitydamage + LichBanedamage
			local combo3 = hitdamage + Sheendamage + Trinitydamage + LichBanedamage
			local combo4 = 0
   			if player:CanUseSpell(_Q) == READY then
				combo2 = combo2 + qdamage*2
				combo3 = combo3 + qdamage
				combo4 = combo4 + qdamage
			end
			if player:CanUseSpell(_W) == READY then
				combo2 = combo2 + wdamage*3
				combo3 = combo3 + wdamage*2
				combo4 = combo4 + wdamage
			end
			if player:CanUseSpell(_R) == READY then
				combo2 = combo2 + rdamage*2
				if player:CanUseSpell(_Q) == READY then
					combo3 = combo3 + rdamage*2
				else
					combo3 = combo3 + rdamage
				end
				combo4 = combo4 + rdamage
			end
			if DFGSlot ~= nil and player:CanUseSpell(DFGSlot) == READY then        
				combo1 = combo1 + dfgdamage            
				combo2 = combo2 + dfgdamage
				combo3 = combo3 + dfgdamage
				combo4 = combo4 + dfgdamage
			end
			if HXGSlot ~= nil and  player:CanUseSpell(HXGSlot) == READY then               
				combo1 = combo1 + hxgdamage    
				combo2 = combo2 + hxgdamage
				combo3 = combo3 + hxgdamage
				combo4 = combo4 + hxgdamage
			end
			if BWCSlot ~= nil and  player:CanUseSpell(BWCSlot) == READY then
				combo1 = combo1 + bwcdamage
				combo2 = combo2 + bwcdamage
				combo3 = combo3 + bwcdamage
				combo4 = combo4 + bwcdamage
			end
			if ignite ~= nil and  player:CanUseSpell(ignite) == READY then
				combo1 = combo1 + ignitedamage 
				combo2 = combo2 + ignitedamage
				combo3 = combo3 + ignitedamage
				combo4 = combo4 + ignitedamage
			end
			if combo4 >= enemy.health then
				killable[i] = 4
			elseif combo3 >= enemy.health then
				killable[i] = 3
			elseif combo2 >= enemy.health then
				killable[i] = 2
			elseif combo1 >= enemy.health then
				killable[i] = 1
			else
				killable[i] = 0
			end    
		end
	end
end
function OnProcessSpell(unit, spell)
	if unit.isMe and spell.name == "DianaArc" then
		moonlightdone, timeq = false, GetTickCount()
	end
end

function OnCreateObj(moonlight)
	if moonlight.name:find("Diana_Q_moonlight_champ.troy") then
		for i=1, heroManager.iCount do
			local enemy = heroManager:GetHero(i)
			if enemy.team ~= player.team then
				if GetDistance(moonlight, enemy) < 80 then
					moonlightenemy[i] = GetTickCount()
				end
			end
		end
	end
end

function OnDraw()
	if drawcircles and not player.dead then
		DrawCircle(player.x, player.y, player.z, range, 0x19A712)
		if ts.target ~= nil then
			for j=0, 15 do
				DrawCircle(ts.target.x, ts.target.y, ts.target.z, 40 + j*1.5, 0x00FF00)
			end
		end
	end
	if ts.target and drawprediction then
		if targetMoveq and GetTickCount()-timeq < 1000 then
			DrawCircle(targetMoveq.x, ts.target.y, targetMoveq.z, 200, 0x0000FF)
		elseif targetNextMove then
			DrawCircle(targetNextMove.x, ts.target.y, targetNextMove.z, 200, 0x0000FF)
		end
	end
	for i=1, heroManager.iCount do
		local enemydraw = heroManager:GetHero(i)
		if ValidTarget(enemydraw) then
			if drawcircles then
				if killable[i] == 1 then
					for j=0, 25 do
						DrawCircle(enemydraw.x, enemydraw.y, enemydraw.z, 80 + j*1.5, 0x0000FF)
					end
				elseif killable[i] == 2 then
					for j=0, 15 do
						DrawCircle(enemydraw.x, enemydraw.y, enemydraw.z, 80 + j*1.5, 0xFF0000)
					end
				elseif killable[i] == 3 then
					for j=0, 15 do
						DrawCircle(enemydraw.x, enemydraw.y, enemydraw.z, 80 + j*1.5, 0xFF0000)
						DrawCircle(enemydraw.x, enemydraw.y, enemydraw.z, 120 + j*1.5, 0xFF0000)
					end
				elseif killable[i] == 4 then
					for j=0, 15 do
						DrawCircle(enemydraw.x, enemydraw.y, enemydraw.z, 80 + j*1.5, 0xFF0000)
						DrawCircle(enemydraw.x, enemydraw.y, enemydraw.z, 120 + j*1.5, 0xFF0000)
						DrawCircle(enemydraw.x, enemydraw.y, enemydraw.z, 160 + j*1.5, 0xFF0000)
					end
				end
			end
			if drawtext then
				if waittxt[i] == 1 then
					if killable[i] ~= 0 then
						PrintFloatText(enemydraw,0,floattext[killable[i]])
					end
					waittxt[i] = 20
				else
					waittxt[i] = waittxt[i]-1
				end
			end
		end
	end
	if IsKeyDown(16) then
		local newY = TS__DrawMenu(tablex, tabley)
		newY = ts:DrawMenu(tablex, newY, "pri")
		DrawText("Draw Circles: "..(drawcircles and "ON" or "OFF"), 20, tablex, newY+21, (drawcircles and 0xFF00FF33 or 0xFFFF0000))
		DrawText("Draw Text: "..(drawtext and "ON" or "OFF"), 20, tablex, newY+21*2, (drawtext and 0xFF00FF33 or 0xFFFF0000))
		DrawText("Draw Prediction: "..(drawprediction and "ON" or "OFF"), 20, tablex, newY+21*3, (drawprediction and 0xFF00FF33 or 0xFFFF0000))
		DrawText("Use E: "..(useE and "ON" or "OFF"), 20, tablex, newY+21*4, (useE and 0xFF00FF33 or 0xFFFF0000))
	end
end

function OnWndMsg(msg,key)
	if key == HK then scriptActive = (msg == KEY_DOWN) return end
	if key == QH then harass = (msg == KEY_DOWN) return end
	if msg == WM_LBUTTONDOWN and IsKeyDown(16) then
		local newY = TS_ClickMenu(tablex, tabley)
		newY = ts:ClickMenu(tablex, newY)
		if CursorIsUnder(tablex, newY+21, 200, 18) then
			drawcircles = not drawcircles
			PrintChat("Draw Circles: "..(drawcircles and "ON" or "OFF"))
		end
		if CursorIsUnder(tablex, newY+21*2, 200, 18) then
			drawtext = not drawtext
			PrintChat("Draw Text: "..(drawtext and "ON" or "OFF"))
		end
		if CursorIsUnder(tablex, newY+21*3, 200, 18) then
			drawprediction = not drawprediction
			PrintChat("Draw Prediction: "..(drawprediction and "ON" or "OFF"))
		end
		if CursorIsUnder(tablex, newY+21*4, 200, 18) then
			drawprediction = not drawprediction
			PrintChat("Draw Prediction: "..(drawprediction and "ON" or "OFF"))
		end
		if CursorIsUnder(tablex, newY+21*5, 200, 18) then
			useE = not useE
			PrintChat("Use E: "..(useE and "ON" or "OFF"))
		end
	end
end

function OnSendChat(msg)
	TargetSelector__OnSendChat(msg)
	ts:OnSendChat(msg, "pri")
end
PrintChat(" >> Diana Combo 1.7 loaded!")
