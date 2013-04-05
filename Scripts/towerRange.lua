--[[
	Script: Tower Range v0.4
	Author: SurfaceS

	v0.1 	initial release -- thanks Shoot for idea
	V0.1b	added mode 4 -- thanks hellspan
	v0.1c	added gameOver to stop script at end
	v0.2	BoL Studio version
	v0.3	use the scriptConfig
	v0.4	use Allscript turrets
]]

do
	--[[         Config         ]]
	allyTurretColor = 0x064700	 		-- Green color
	enemyTurretColor = 0xFF0000 		-- Red color
	visibilityTurretColor = 0x470000 	-- Dark Red color
	drawTurrets = {}
	--[[         Code           ]]
	function OnDraw()
		if GameIsOver() then return end
		for i, turret in pairs(drawTurrets) do
			DrawCircle(turret.x, turret.y, turret.z, turret.range, turret.color)
			if TRConfig.showVisibility then
				DrawCircle(turret.x, turret.y, turret.z, turret.visibilityRange, visibilityTurretColor)
			end
		end
	end

	function OnTick()
		drawTurrets = {}
		for name, turret in pairs(GetTurrets()) do
			if turret ~= nil then
				local enemyTurret = turret.team ~= player.team
				if (TRConfig.showAlly or enemyTurret)
				and (TRConfig.onlyClose == false or GetDistance(turret) < 2000) then
					table.insert(drawTurrets, {x = turret.x, y = turret.y, z = turret.z, range = turret.range, color = (enemyTurret and enemyTurretColor or allyTurretColor), visibilityRange = turret.visibilityRange})
				end
			end
		end
	end
	
	function OnLoad()
		TRConfig = scriptConfig("Tower range 0.4", "towerRange")
		TRConfig:addParam("onlyClose", "Show only close", SCRIPT_PARAM_ONOFF, true)
		TRConfig:addParam("showAlly", "Show ally turrets", SCRIPT_PARAM_ONOFF, false)
		TRConfig:addParam("showVisibility", "Show turret view", SCRIPT_PARAM_ONOFF, true)
	end
end