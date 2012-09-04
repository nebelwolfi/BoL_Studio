--[[
	Library: minionArray v0.2
	Author: SurfaceS

	required libs : 		map, GetDistance2D
	required sprites : 		-
	exposed variables : 	minionArray, player, LIB_PATH
	
	USAGE :
	Load the libray from your script
	Add minionArray.OnLoad() to your script/library OnLoad() function
	Add minionArray.OnCreateObj() to your script/library OnCreateObj() function
	Add minionArray.OnDeleteObj() to your script/library OnDeleteObj() function
	
	v0.1 		initial release
	v0.2		BoL Studio Version
]]

if LIB_PATH == nil then LIB_PATH = debug.getinfo(1).source:sub(debug.getinfo(1).source:find(".*\\")):sub(2).."Libs\\" end
if player == nil then player = GetMyHero() end
if GetDistance2D == nil then dofile(LIB_PATH.."GetDistance2D.lua") end
if map == nil then dofile(LIB_PATH.."map.lua") end

minionArray = {}

function minionArray.OnLoad()
	map.OnLoad()
	minionArray.jungleCreeps = {}
	minionArray.ennemyMinion = {}
	minionArray.allyMinion = {}
	for i = 1, objManager.maxObjects do
		local object = objManager:getObject(i)
		minionArray.OnCreateObj(object)
	end
	if map.index ~= 4 then
		minionArray.team_ally = "Minion_T"..player.team
		minionArray.team_ennemy = "Minion_T"..(player.team == TEAM_BLUE and TEAM_RED or TEAM_BLUE)
	else
		minionArray.team_ally = (player.team == TEAM_BLUE and "Blue" or "Red")
		minionArray.team_ennemy = (player.team == TEAM_BLUE and "Red" or "Blue")
	end

end

function minionArray.OnCreateObj(object)
	if object ~= nil and object.type == "obj_AI_Minion" and not object.dead then
		if minionArray.allyMinion[object.name] ~= nil or minionArray.ennemyMinion[object.name] ~= nil or minionArray.allyMinion[object.name] ~= nil then return end
		if string.find(object.name,minionArray.team_ally) then minionArray.allyMinion[object.name] = object
		elseif string.find(object.name,minionArray.team_ennemy) then minionArray.ennemyMinion[object.name] = object
		else minionArray.jungleCreeps[object.name] = object
		end
	end
end

function minionArray.OnDeleteObj(object)
	if object ~= nil and object.type == "obj_AI_Minion" and object.name ~= nil then
		if minionArray.jungleCreeps[object.name] ~= nil then minionArray.jungleCreeps[object.name] = nil
		elseif minionArray.ennemyMinion[object.name] ~= nil then minionArray.ennemyMinion[object.name] = nil
		elseif minionArray.allyMinion[object.name] ~= nil then minionArray.allyMinion[object.name] = nil
		end
	end
end

function minionArray.objectInRange(objectTable, fromPos, range)
	local objectRanged = {}
	for name,objectTableObject in pairs(minionArray[objectTable]) do
		if objectTableObject ~= nil and objectTableObject.dead == false and objectTableObject.visible and GetDistance2D(fromPos,objectTableObject) <= range then
			table.insert(objectRanged, objectTableObject)
		end
	end
	return #objectRanged, objectRanged
end

function minionArray.jungleCreepsInRange(fromPos, range)
	return minionArray.objectInRange("jungleCreeps", fromPos, range)
end

function minionArray.ennemyMinionInRange(fromPos, range)
	return minionArray.objectInRange("ennemyMinion", fromPos, range)
end

function minionArray.allyMinionInRange(fromPos, range)
	return minionArray.objectInRange("allyMinion", fromPos, range)
end