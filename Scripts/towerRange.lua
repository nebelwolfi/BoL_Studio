--[[
	Script: Tower Range v0.3
	Author: SurfaceS

	v0.1 	initial release -- thanks Shoot for idea
	V0.1b	added mode 4 -- thanks hellspan
	v0.1c	added gameOver to stop script at end
	v0.2	BoL Studio version
	v0.3	use the scriptConfig
]]

do
	--[[         Globals        ]]
	turrets = {}
	--[[         Config         ]]
	turretRange = 950	 				-- 950
	fountainRange = 1050	 			-- 1050
	visibilityRange = 1300	 			-- 1095
	allyTurretColor = 0x064700	 		-- Green color
	enemyTurretColor = 0xFF0000 		-- Red color
	visibilityTurretColor = 0x470000 	-- Dark Red color

	--[[         Code           ]]
	function checkTurretState()
		for name, turret in pairs(turrets) do
			if turret.object.valid == false then
				turrets[name] = nil
			end
		end
	end
	
	function OnDraw()
		if gameState:gameIsOver() then return end
		for name, turret in pairs(turrets) do
			if turret ~= nil then
				if (TRConfig.showAlly or turret.team ~= player.team)
				and (TRConfig.onlyClose == false or GetDistance(turret) < 2000) then
					DrawCircle(turret.x, turret.y, turret.z, turret.range, turret.color)
					if TRConfig.showVisibility then
						DrawCircle(turret.x, turret.y, turret.z, visibilityRange, visibilityTurretColor)
					end
				end
			end
		end
	end
	function OnTick()
		if gameState:gameIsOver() then return end
		checkTurretState()
	end
	function OnDeleteObj(object)
		if object ~= nil and object.type == "obj_AI_Turret" then
			for name, turret in pairs(turrets) do
				if name == object.name then
					turrets[name] = nil
					return
				end
			end
        end
	end
	function OnLoad()
		gameState = GameState()
		TRConfig = scriptConfig("Tower range 0.3", "towerRange")
		TRConfig:addParam("onlyClose", "Show only close", SCRIPT_PARAM_ONOFF, true)
		TRConfig:addParam("showAlly", "Show ally turrets", SCRIPT_PARAM_ONOFF, false)
		TRConfig:addParam("showVisibility", "Show turret view", SCRIPT_PARAM_ONOFF, true)
		for i = 1, objManager.maxObjects do
			local object = objManager:getObject(i)
			if object ~= nil and object.type == "obj_AI_Turret" then
				local turretName = object.name
				turrets[turretName] = {
					object = object,
					team = object.team,
					color = (object.team == player.team and allyTurretColor or enemyTurretColor),
					range = turretRange,
					x = object.x,
					y = object.y,
					z = object.z,
					active = false,
				}
				if turretName == "Turret_OrderTurretShrine_A" or turretName == "Turret_ChaosTurretShrine_A" then
					turrets[turretName].range = fountainRange
					for j = 1, objManager.maxObjects do
						local object2 = objManager:getObject(j)
						if object2 ~= nil and object2.type == "obj_SpawnPoint" and GetDistance(object, object2) < 1000 then
							turrets[turretName].x = object2.x
							turrets[turretName].z = object2.z
						elseif object2 ~= nil and object2.type == "obj_HQ" and object2.team == object.team then
							turrets[turretName].y = object2.y
						end
					end
				end
			end
		end
	end
end