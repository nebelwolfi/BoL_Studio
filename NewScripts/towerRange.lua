--[[
	Script: Tower Range v0.2
	Author: SurfaceS

	required libs : 		
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
	require "AllClass"
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
		tickUpdate = 1000,
		nextUpdate = 0,
	}

	--[[         Code           ]]
	function towerRange.checkTurretState()
		if towerRange.activeType > 0 then
			for name, turret in pairs(towerRange.turrets) do
				turret.active = false
			end
			for i = 1, objManager.maxObjects do
				local object = objManager:getObject(i)
				if object ~= nil and object.type == "obj_AI_Turret" then
					local name = object.name
					if towerRange.turrets[name] ~= nil then towerRange.turrets[name].active = true end
				end
			end
			for name, turret in pairs(towerRange.turrets) do
				if turret.active == false then towerRange.turrets[name] = nil end
			end
		end
	end
	
	function OnDraw()
		if gameState:gameIsOver() then return end
		if towerRange.activeType > 0 then
			for name, turret in pairs(towerRange.turrets) do
				if turret ~= nil then
					if (towerRange.activeType == 1 and turret.team ~= player.team and player.dead == false and GetDistance(turret) < 2000)
					or (towerRange.activeType == 2 and turret.team ~= player.team)
					or (towerRange.activeType == 3)
					or (towerRange.activeType == 4 and player.dead == false and GetDistance(turret) < 2000) then
						DrawCircle(turret.x, turret.y, turret.z, turret.range, turret.color)
					end
				end
			end
		end
	end
	function OnTick()
		if IsKeyPressed(towerRange.toggleKey) then
			towerRange.activeType = (towerRange.activeType < 4 and towerRange.activeType + 1 or 0)
			PrintChat("Turret range display is "..towerRange.typeText[towerRange.activeType + 1])
		end
		local tick = GetTickCount()
		if tick > towerRange.nextUpdate then
			towerRange.nextUpdate = tick + towerRange.tickUpdate
			towerRange.checkTurretState()
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
		gameState = GameState()
		for i = 1, objManager.maxObjects do
			local object = objManager:getObject(i)
			if object ~= nil and object.type == "obj_AI_Turret" then
				local turretName = object.name
				towerRange.turrets[turretName] = {
					object = object,
					team = object.team,
					color = (object.team == player.team and towerRange.allyTurretColor or towerRange.enemyTurretColor),
					range = towerRange.turretRange,
					x = object.x,
					y = object.y,
					z = object.z,
					active = false,
				}
				if turretName == "Turret_OrderTurretShrine_A" or turretName == "Turret_ChaosTurretShrine_A" then
					towerRange.turrets[turretName].range = towerRange.fountainRange
					for j = 1, objManager.maxObjects do
						local object2 = objManager:getObject(j)
						if object2 ~= nil and object2.type == "obj_SpawnPoint" and GetDistance(object, object2) < 1000 then
							towerRange.turrets[turretName].x = object2.x
							towerRange.turrets[turretName].z = object2.z
						elseif object2 ~= nil and object2.type == "obj_HQ" and object2.team == object.team then
							towerRange.turrets[turretName].y = object2.y
						end
					end
				end
			end
		end
	end
end