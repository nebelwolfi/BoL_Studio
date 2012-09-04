--[[
	Script: Tower Range v0.2
	Author: SurfaceS

	required libs : 		gameOver, GetDistance2D
	required sprites : 		-
	exposed variables : 	only libs variables

	Usage : Press toggle key to walk thru :
		-> 0 - Do nothing
		-> 1 - Show enemy turrets range close to your champion (Default)
		-> 2 - Show enemy turrets range
		-> 3 - Show all turrets range
		-> 4 - Show all turrets range close to your champion

	v0.1 	initial release -- thanks Shoot for idea
	V0.1b	added mode 4 -- thanks hellspan
	v0.1c	added gameOver to stop script at end
	v0.2	BoL Studio version
]]

do
	--[[         Globals        ]]
	local towerRange = {
		turrets = {},
		typeText = {"OFF", "ON (enemy close)", "ON (enemy)", "ON (all)", "ON (all close)"},
		--[[         Config         ]]
		toggleKey = 116, 					-- F5
		turretRange = 950,	 				-- 950
		fountainRange = 1050,	 			-- 1050
		allyTurretColor = 0x80FF00, 		-- Green color
		enemyTurretColor = 0xFF0000, 		-- Red color
		activeType = 1,						-- Default type (see usage)
	}

	--[[         Code           ]]
	if LIB_PATH == nil then LIB_PATH = debug.getinfo(1).source:sub(debug.getinfo(1).source:find(".*\\")):sub(2).."libs\\" end
	if player == nil then player = GetMyHero() end
	if gameOver == nil then dofile(LIB_PATH.."gameOver.lua") end
	if GetDistance2D == nil then dofile(LIB_PATH.."GetDistance2D.lua") end

	function OnDraw()
		if gameOver.gameIsOver() then return end
		if towerRange.activeType > 0 then
			for name, turret in pairs(towerRange.turrets) do
				if turret ~= nil and turret.object ~= nil and turret.object.type == "obj_AI_Turret" then
					if (towerRange.activeType == 1 and turret.team ~= player.team and player.dead == false and GetDistance2D(player, turret) < 2000)
					or (towerRange.activeType == 2 and turret.team ~= player.team)
					or (towerRange.activeType == 3)
					or (towerRange.activeType == 4 and player.dead == false and GetDistance2D(player, turret) < 2000) then
						DrawCircle(turret.x, turret.y, turret.z, turret.range, turret.color)
					end
				end
			end
		end
	end
	function OnWndMsg(msg, key)
		if key == towerRange.toggleKey and msg == KEY_UP then
			towerRange.activeType = (towerRange.activeType < 4 and towerRange.activeType + 1 or 0)
			PrintChat("Turret range display is "..towerRange.typeText[towerRange.activeType + 1])
		end
	end
	function OnDeleteObj(object)
		if object ~= nil and object.type == "obj_AI_Turret" then
			for name, turret in pairs(towerRange.turrets) do
				if name == object.name then
					towerRange.turrets[name] = nil
					return
				end
			end
        end
	end
	function OnLoad()
		gameOver.OnLoad()
		for i = 1, objManager.maxObjects do
			local object = objManager:getObject(i)
			if object ~= nil and object.type == "obj_AI_Turret" then
				towerRange.turrets[object.name] = {
					object = object,
					team = object.team,
					color = (object.team == player.team and towerRange.allyTurretColor or towerRange.enemyTurretColor),
					range = towerRange.turretRange,
					x = object.x,
					y = object.y,
					z = object.z,
				}
				if object.name == "Turret_OrderTurretShrine_A" or object.name == "Turret_ChaosTurretShrine_A" then
					towerRange.turrets[object.name].range = towerRange.fountainRange
					for j = 1, objManager.maxObjects do
						local object2 = objManager:getObject(j)
						if object2 ~= nil and object2.type == "obj_SpawnPoint" and GetDistance2D(object, object2) < 1000 then
							towerRange.turrets[object.name].x = object2.x
							towerRange.turrets[object.name].z = object2.z
						elseif object2 ~= nil and object2.type == "obj_HQ" and object2.team == object.team then
							towerRange.turrets[object.name].y = object2.y
						end
					end
				end
			end
		end
	end
end