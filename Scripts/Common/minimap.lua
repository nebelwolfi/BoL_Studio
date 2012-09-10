--[[
	Libray: MiniMap Lib v2.0
	Author: Weee
	Porter: Kilua
	
	required libs : 		map, minimap_wizard
	exposed variables : 	miniMap, file_exists, convertToMinimap (depreciated, use miniMap.convertToMinimap), initMarks (depreciated)
	
	UPDATES :
	v1.0				initial release / port by Kilua
	v1.1				added support for all maps / reworked
	v1.1b				reworked wizard handle
	v2.0				BoL Studio Version
	
	USAGE :
	Load the libray from your script
]]

-- don't load multiple time
if miniMap ~= nil then return end
require "common"
require "map"

miniMap = {
	shift = {x=0,y=0},
	step = {x=0,y=0},
	offsets = {x1=300,y1=200,x2=300,y2=225},
	configFile = LIB_PATH.."minimap.cfg",
	configScript = LIB_PATH.."minimap_wizard.lua",
	state = 0,
}

function miniMap.ToMinimapX(x)
	if miniMap.state == 1 then return miniMap.offsets.x2 - miniMap.shift.x + miniMap.step.x * x else return -100 end
end

function miniMap.ToMinimapY(y)
	if miniMap.state == 1 then return miniMap.offsets.y2 - miniMap.shift.y + miniMap.step.y * y else return -100 end
end

function miniMap.ToMinimapPoint(x,y)
	return { x = miniMap.ToMinimapX(x), y = miniMap.ToMinimapY(y) }
end

function miniMap.OnLoad()
	if miniMap.state == 1 then return 1 end
	map.OnLoad()
    if file_exists(miniMap.configFile) then
        dofile(miniMap.configFile)
        miniMap.step.x = ( miniMap.offsets.x1 - miniMap.offsets.x2 ) / map.x
        miniMap.step.y = ( miniMap.offsets.y1 - miniMap.offsets.y2 ) / map.y
		miniMap.shift.x = miniMap.step.x * map.min.x
		miniMap.shift.y = miniMap.step.y * map.min.y
        miniMap.state = 1
    else
        PrintChat(" >> miniMap Lib: Config not found. Starting wizard to make a new one")
        if file_exists(miniMap.configScript) then
        	if miniMap.state ~= 2 then
				miniMap.state = 2
				dofile(miniMap.configScript)
			end
        else
            miniMap.state = 3
            PrintChat(" >> miniMap Lib: [ERROR] Wizard not found. You have to download it and put to libs folder!")
        end
    end
	return miniMap.state
end

--[[ depreciated, will be removed some day ]]
-- use miniMap.state if you want the state, miniMap.load() if you want loading
function initMarks()
	return miniMap.OnLoad()
end

-- miniMap.convertToMinimap(ingameX,ingameZ) to avoid conficts
function convertToMinimap(x,y)
    return miniMap.ToMinimapX(x), miniMap.ToMinimapY(y)
end