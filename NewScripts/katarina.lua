--[[
		Katarina Combo v2.4 by eXtragoZ
			   
				It requires the Target Selector Library and Spell Damage Library
 
		-full combo: DFG -> Q -> E -> DFG -> Q -> W -> items -> R
		-Supports Deathfire Grasp, Bilgewater Cutlass, Hextech Gunblade, Sheen, Trinity, Lich Bane and Ignite
		-Harass mode: Q
		-Mark killable target with a combo
		-Target configuration
		-Press shift to configure
		-Maximum range for W and R
	   
		Explanation of the marks:
 
		Green circle:  Marks the current target to which you will do the combo
		Blue circle:  Mark a target that can be killed with a combo, if all the skills were available
		Red circle:  Mark a target that can be killed using items + 1 hits + Q x2 + Qmark x2 + W x2 + E x2 + R (full duration) + ignite
		2 Red circles:  Mark a target that can be killed using items + 1 hits + Q + Qmark + W + E + R (7/10 duration) + ignite
		3 Red circles:  Mark a target that can be killed using items (without Sheen, Trinity and Lich Bane) + Q + Qmark(if e is not on cd) + W(if e is not on cd) + E + R (3/10 duration)(if e is not on cd) + ignite
	   
]]
if GetMyHero().charName ~= "Katarina" then return end
require "AllClass"
--require "spellDmg"

--[[            Config          ]]
local HK=32 --spacebar
local QH = 84 --T to harass with Q
local useult = true
local tablex = 5
local tabley = 300
 
--[[            Code            ]]
local range = 700
local ULTK=82 --R (security method)
local tick = nil
-- Active
local scriptActive = false
local harass = false
local ulti = false
local delayult = 300
local delayult2 = 1200
local timeulti = 0
local timeulti2 = 0
-- draw
local drawcircles = true
local drawtext = true
local waittxt = {}
local ordertxt = 1
local floattext = {"Skills are not available","Able to fight","Killable","Murder him!"}
local killable = {}
-- ts
local nenemys = 0
local newpriority = true
local charorder = 1
local charpriority = {}
local charname = {}
local ts
--
local ignite = nil
local DFGSlot, HXGSlot, BWCSlot, SheenSlot, TrinitySlot, LichBaneSlot = nil, nil, nil, false, false, false

function OnLoad()
	ts = TargetSelector(TARGET_LOW_HP, range, DAMAGE_MAGIC, false)
	if player:GetSpellData(SUMMONER_1).name:find("SummonerDot") then ignite = SUMMONER_1
	elseif player:GetSpellData(SUMMONER_2).name:find("SummonerDot") then ignite = SUMMONER_2
	else ignite = nil
	end
	for i=1, heroManager.iCount do
		local hero = heroManager:GetHero(i)
		if hero.team ~= player.team then nenemys = nenemys + 1 end
		waittxt[i] = i
	end
end
function OnTick()
	ts:update()
	KCInventory()
	if tick == nil or GetTickCount() - tick >= 500 then
		tick = GetTickCount()
		KCDmgCalculation()
	end
	ulti = false
	if TargetHaveBuff("katarinarsound") then
		ulti = true
		timeulti = GetTickCount()
	end
	if GetTickCount()-timeulti < delayult or GetTickCount()-timeulti2 < delayult2 then ulti = true end
	if harass and ts.target ~= nil and ulti == false then
		if player:CanUseSpell(_Q) == READY then
			CastSpell(_Q, ts.target)
		end
	end
	if scriptActive and ts.target ~= nil and ulti == false then
		if DFGSlot ~= nil and player:CanUseSpell(DFGSlot) == READY then CastSpell(DFGSlot, ts.target) end
		if player:CanUseSpell(_Q) == READY then CastSpell(_Q, ts.target) end
		if player:CanUseSpell(_E) == READY then CastSpell(_E,ts.target) end
		if DFGSlot ~= nil and player:CanUseSpell(DFGSlot) == READY then CastSpell(DFGSlot, ts.target) end
		if player:CanUseSpell(_Q) == READY then CastSpell(_Q, ts.target) end
		if player:CanUseSpell(_W) == READY and GetDistance(ts.target)<375 then CastSpell(_W) end
		if HXGSlot ~= nil and player:CanUseSpell(HXGSlot) == READY then CastSpell(HXGSlot, ts.target) end
		if BWCSlot ~= nil and player:CanUseSpell(BWCSlot) == READY then CastSpell(BWCSlot, ts.target) end
		if player:CanUseSpell(_R) == READY and useult and player:CanUseSpell(_Q) == COOLDOWN and player:CanUseSpell(_W) == COOLDOWN and player:CanUseSpell(_E) == COOLDOWN and player:GetDistance(ts.target)<275 then
			timeulti = GetTickCount()
			timeulti2 = GetTickCount()
			CastSpell(_R)
		end
	end
end

function KCInventory()
	DFGSlot, HXGSlot, BWCSlot, SheenSlot, TrinitySlot, LichBaneSlot = GetInventorySlotItem(3128), GetInventorySlotItem(3146), GetInventorySlotItem(3144), GetInventoryHaveItem(3057), GetInventoryHaveItem(3078), GetInventoryHaveItem(3100)
end

function KCDmgCalculation()
	for i=1, heroManager.iCount do
		local enemy = heroManager:GetHero(i)
		if ValidTarget(enemy) then
			local dfgdamage, hxgdamage, bwcdamage, ignitedamage, Sheendamage, Trinitydamage, LichBanedamage  = 0, 0, 0, 0, 0, 0, 0
			local qdamage = getDmg("Q",enemy,player)
			local qdamage2 = getDmg("Q",enemy,player,2)
			local wdamage = getDmg("W",enemy,player)
			local edamage = getDmg("E",enemy,player)
			local rdamage = getDmg("R",enemy,player) --xdagger (champion can be hit by a maximum of 10 daggers (2 sec))
			local hitdamage = getDmg("AD",enemy,player)
			local dfgdamage = (DFGSlot and getDmg("DFG",enemy,player) or 0)
			local hxgdamage = (HXGSlot and getDmg("HXG",enemy,player) or 0)
			local bwcdamage = (BWCSlot and getDmg("BWC",enemy,player) or 0)
			local ignitedamage = (ignite and getDmg("IGNITE",enemy,player) or 0)
			local Sheendamage = (SheenSlot and hitdamage or 0)
			local Trinitydamage = (TrinitySlot and hitdamagee*1.5 or 0)
			local LichBanedamage = (LichBaneSlot and getDmg("LICHBANE",enemy,player) or 0)
			local combo1 = hitdamage + qdamage*2 + qdamage2*2 + wdamage*2 + edamage*2 + rdamage*10 + Sheendamage + Trinitydamage + LichBanedamage --0 cd
			local combo2 = hitdamage + Sheendamage + Trinitydamage + LichBanedamage
			local combo3 = hitdamage + Sheendamage + Trinitydamage + LichBanedamage
			local combo4 = 0
			if player:CanUseSpell(_Q) == READY then
				combo2 = combo2 + qdamage*2 + qdamage2*2
				combo3 = combo3 + qdamage + qdamage2
				combo4 = combo4 + qdamage
				if player:CanUseSpell(_E) == READY then
					combo4 = combo4 + qdamage2
				end
			end
			if player:CanUseSpell(_W) == READY then
				combo2 = combo2 + wdamage*2
				combo3 = combo3 + wdamage
				if player:CanUseSpell(_E) == READY then
					combo4 = combo4 + wdamage
				end
			end
			if player:CanUseSpell(_E) == READY then
				combo2 = combo2 + edamage*2
				combo3 = combo3 + edamage
				combo4 = combo4 + edamage
			end
			if player:CanUseSpell(_R) ~= COOLDOWN and not player.dead then
				combo2 = combo2 + rdamage*10
				combo3 = combo3 + rdamage*7
				if player:CanUseSpell(_E) == READY then
					combo4 = combo4 + rdamage*3
				end
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

function OnDraw()
	if drawcircles and not player.dead then
		DrawCircle(player.x, player.y, player.z, range, 0x19A712)
		if ts.target ~= nil then
			for j=0, 15 do
				DrawCircle(ts.target.x, ts.target.y, ts.target.z, 40 + j*1.5, 0x00FF00)
			end
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
		DrawText("Use Ult: "..(useult and "ON" or "OFF"), 20, tablex, newY+21*3, (useult and 0xFF00FF33 or 0xFFFF0000))
	end
end
 
function OnWndMsg(msg,key)
	if key == HK then scriptActive = (msg == KEY_DOWN) return end
	if key == QH then harass = (msg == KEY_DOWN) return end
	if key == ULTK and msg == KEY_DOWN then
		timeulti = GetTickCount()
		timeulti2 = GetTickCount()
		return
	end
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
			useult = not useult
			PrintChat("Use Ult: "..(useult and "ON" or "OFF"))
		end
	end
end

function OnSendChat(msg)
	TargetSelector__OnSendChat(msg)
	ts:OnSendChat(msg, "pri")
end
PrintChat(" >> Katarina Combo v2.4 loaded!")