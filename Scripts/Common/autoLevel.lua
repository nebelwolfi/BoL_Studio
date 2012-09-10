--[[
	Library :	autoLevel  v0.2
	Author: 	SurfaceS

	required libs : 	-
	exposed variables : player, autoLevel

	v0.1 	initial release
	v0.2 	BoL Studio Version
	
	Usage :
		On your script :
		Load the lib :
			require "autoLevel.lua"
		Set the levelSequence :
			autoLevel.levelSequence = {1,nil,0,1,1,4,1,nil,1,nil,4,nil,nil,nil,nil,4,nil,nil}
				The levelSequence is table of 18 fields
				1-4 = spell 1 to 4
				nil = will not auto level on this one
				0 = will use your own function (called autoLevel.onChoiceFunction()) for this one, that return a number between 1-4
			
		Set the function if you use 0, example :
			autoLevel.onChoiceFunction = function()
				if GetSpellData(SPELL_2).level < GetSpellData(SPELL_3).level then
					return 2
				else
					return 3
				end
			end
		Call the main function on your tick :
			autoLevel.OnTick()

]]

if player == nil then player = GetMyHero() end

--[[ 		Globals		]]
autoLevel = {
	spellsSlots = {SPELL_1, SPELL_2, SPELL_3, SPELL_4},
	levelSequence = {},
	nextUpdate = 0,
	tickUpdate = 500,		-- update each 0.5 sec
}

--[[ 		Code		]]
function autoLevel.realHeroLevel()
	return player:GetSpellData(SPELL_1).level + player:GetSpellData(SPELL_2).level + player:GetSpellData(SPELL_3).level + player:GetSpellData(SPELL_4).level
end

function autoLevel.OnTick()
	local tick = GetTickCount()
	if autoLevel.nextUpdate > tick then return end
	autoLevel.nextUpdate = tick + autoLevel.tickUpdate
	local realLevel = autoLevel.realHeroLevel()
	if player.level > realLevel and autoLevel.levelSequence[realLevel + 1] ~= nil then
		local spellToLearn = autoLevel.levelSequence[realLevel + 1]
		if spellToLearn == 0 then
			if autoLevel.onChoiceFunction == nil then return nil end
			spellToLearn = autoLevel.onChoiceFunction()
			if spellToLearn == nil or spellToLearn < 1 or spellToLearn > 4 then return nil end
		end
		LevelSpell(autoLevel.spellsSlots[spellToLearn])
	end
end

