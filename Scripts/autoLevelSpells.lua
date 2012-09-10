--[[
	Script:		Auto Level Spells  v0.2d
	Author: 	grey
	Porter:		Mistal

	required libs : 	autoLevel
	exposed variables : -

	v0.1 	initial release
	v0.2d 	BoL Studio Version
	
	Levels the Abilities of every single Champion
	
	Dont forget to check the abilitySequence of your champion
	Thanks to Zynox who gave me some ideas and tipps. 
	the default ability sequences are from mobafire :)
]]

--[[
	in this section you can change the abilitySequence of your champion
	please contact me if you find an abilitySequence which works, that i can give this an approved seal. also contact me, if it doesnt work (give me the name of this champ written in the ingame console)
	to disable AutoLevelSpells Script for a specific champ just comment out the line like this: --elseif champ=.....
]]

function OnLoad()
	if player == nil then player = GetMyHero() end
	local champ = player.charName
	local abilitySequence = nil
	if     champ=="Ahri" then		abilitySequence={1,3,2,1,1,4,1,2,1,2,4,2,2,3,3,4,3,3,}
	elseif champ=="Akali" then 		abilitySequence={1,2,1,3,1,4,1,3,1,2,4,3,3,2,2,4,3,2,}
	elseif champ=="Alistar" then 		abilitySequence={1,3,2,1,3,4,1,3,1,3,4,1,3,2,2,4,2,2,}
	elseif champ=="Amumu" then 		abilitySequence={1,3,3,2,3,4,3,2,3,2,4,2,2,1,1,4,1,1,}
	elseif champ=="Anivia" then 		abilitySequence={1,3,3,2,3,4,3,1,3,1,4,1,1,2,2,4,2,2,}
	elseif champ=="Annie" then 		abilitySequence={1,2,1,2,1,4,1,2,1,2,4,2,3,3,3,4,3,3,}
	elseif champ=="Ashe" then 		abilitySequence={2,1,3,1,3,4,1,3,1,3,4,1,3,2,2,4,2,2,}
	elseif champ=="Blitzcrank" then 	abilitySequence={1,3,2,3,2,4,3,2,3,2,4,3,2,1,1,4,1,1,}
	elseif champ=="Brand" then 		abilitySequence={2,1,3,2,2,4,2,3,2,3,4,3,3,1,1,4,1,1,}
	elseif champ=="Caitlyn" then 		abilitySequence={2,1,1,3,1,4,1,3,1,3,4,3,3,2,2,4,2,2,}
	elseif champ=="Cassiopeia" then 	abilitySequence={1,3,1,2,1,4,1,3,1,3,4,3,3,2,2,4,2,2,}
	elseif champ=="Chogath" then 		abilitySequence={1,3,2,2,2,4,2,3,2,3,4,3,3,1,1,4,1,1,}
	elseif champ=="Corki" then 		abilitySequence={1,2,1,3,1,4,1,3,1,3,4,3,3,2,2,4,2,2,}
	elseif champ=="DrMundo" then 		abilitySequence={1,2,1,3,1,4,1,3,1,3,4,3,2,3,2,4,2,2,}
	elseif champ=="Evelynn" then 		abilitySequence={2,3,2,1,3,4,3,3,2,3,4,1,1,1,1,4,2,2,}
	elseif champ=="Ezreal" then 		abilitySequence={1,3,1,2,1,4,1,3,1,3,4,3,3,2,2,4,2,2,}
	elseif champ=="Fiddlesticks" then 	abilitySequence={2,3,2,1,3,4,2,2,2,3,4,3,3,1,4,1,1,1,}
	elseif champ=="Fizz" then 		abilitySequence={3,1,2,1,2,4,1,1,1,2,4,2,2,3,3,4,3,3,}
	elseif champ=="Galio" then 		abilitySequence={1,2,1,3,1,4,1,2,1,2,4,3,3,2,2,4,3,3,}
	elseif champ=="Gangplank" then 		abilitySequence={1,2,1,3,1,4,1,2,1,2,4,2,2,3,3,4,3,3,}
	elseif champ=="Garen" then		abilitySequence={3,1,3,2,3,4,3,1,3,1,4,1,1,2,2,4,2,2,}
	elseif champ=="Gragas" then 		abilitySequence={1,3,1,2,1,4,1,3,1,3,4,3,3,2,2,4,2,2,}
	elseif champ=="Graves" then 		abilitySequence={1,3,1,2,1,4,1,3,1,3,4,3,3,2,2,4,2,2,}
	elseif champ=="Heimerdinger" then 	abilitySequence={1,2,2,1,1,4,3,2,2,2,4,1,1,3,3,4,1,1,}
	elseif champ=="Irelia" then 		abilitySequence={1,2,3,2,2,4,2,1,2,1,4,1,1,3,3,4,3,3,}
	elseif champ=="Janna" then 		abilitySequence={3,1,3,2,3,4,3,2,3,2,2,2,4,1,1,4,1,1,}
	elseif champ=="JarvanIV" then 		abilitySequence={1,3,1,2,1,4,1,3,2,1,4,3,3,3,2,4,2,2,}
	elseif champ=="Jax" then 		abilitySequence={1,2,3,1,1,4,1,2,1,2,4,2,3,2,3,4,3,3,}
	elseif champ=="Karma" then 		abilitySequence={1,3,1,2,3,1,3,1,3,1,3,1,3,2,2,2,2,2,}
	elseif champ=="Karthus" then 		abilitySequence={1,2,1,3,1,4,1,3,1,3,4,3,2,3,2,4,2,2,}
	elseif champ=="Kassadin" then 		abilitySequence={1,2,1,3,1,4,1,3,1,3,4,3,3,2,2,4,2,2,}
	elseif champ=="Katarina" then 		abilitySequence={3,1,3,2,3,4,3,1,3,1,4,1,1,2,2,4,2,2,}
	elseif champ=="Kayle" then 		abilitySequence={3,2,3,1,3,4,3,2,3,2,4,2,2,1,1,4,1,1,}
	elseif champ=="Kennen" then 		abilitySequence={1,2,3,1,2,4,1,2,1,1,4,2,2,3,3,4,3,3,}
	elseif champ=="KogMaw" then 		abilitySequence={2,3,2,1,2,4,2,1,2,1,4,1,1,3,3,4,3,3,}
	elseif champ=="LeBlanc" then 		abilitySequence={1,2,1,3,1,4,1,2,1,2,4,2,3,2,3,4,3,3,}
	elseif champ=="LeeSin" then 		abilitySequence={3,2,1,1,1,4,1,2,1,2,4,2,3,2,3,4,3,3,}
	elseif champ=="Leona" then 		abilitySequence={1,3,2,2,2,4,2,3,2,3,4,3,3,1,1,4,1,1,}
	elseif champ=="Lux" then 		abilitySequence={3,1,3,2,3,4,3,1,3,1,4,1,1,2,2,4,2,2,} --approved
	elseif champ=="Malphite" then 		abilitySequence={1,3,1,2,1,4,1,3,1,3,4,3,2,3,2,4,2,2,}
	elseif champ=="Malzahar" then 		abilitySequence={1,3,3,2,3,4,1,3,1,3,4,2,1,2,1,4,2,2,}
	elseif champ=="Maokai" then 		abilitySequence={3,2,3,1,3,4,3,2,3,2,4,1,1,2,2,4,1,1,}
	elseif champ=="MasterYi" then 		abilitySequence={3,1,3,1,3,4,3,1,3,1,4,1,2,2,2,4,2,2,}
	elseif champ=="MissFortune" then 	abilitySequence={2,1,2,3,2,4,2,3,2,3,4,3,3,1,1,4,1,1,}
	elseif champ=="Mordekaiser" then 	abilitySequence={3,1,3,2,3,4,3,1,3,1,4,1,1,2,2,4,2,2,}
	elseif champ=="Morgana" then 		abilitySequence={1,2,2,3,2,4,2,3,2,3,4,3,3,1,1,4,1,1,}
	elseif champ=="Nasus" then 		abilitySequence={1,2,1,3,1,4,1,2,1,2,4,2,3,2,3,4,3,3,}
	elseif champ=="Nidalee" then 		abilitySequence={2,3,1,3,1,4,3,2,3,1,4,3,1,1,2,4,2,2,}
	elseif champ=="Nocturne" then 		abilitySequence={1,2,1,3,1,4,1,3,1,3,4,3,3,2,2,4,2,2,}
	elseif champ=="Nunu" then 		abilitySequence={3,1,3,2,1,4,3,1,3,1,4,1,3,2,2,4,2,2,}
	elseif champ=="Olaf" then 		abilitySequence={2,1,2,3,3,4,3,3,3,1,4,2,1,1,2,4,2,1,}
	elseif champ=="Orianna" then 		abilitySequence={1,2,1,3,1,4,1,2,1,2,4,2,2,3,3,4,3,3,}
	elseif champ=="Pantheon" then 		abilitySequence={1,2,3,1,1,4,1,3,1,3,4,3,2,3,2,4,2,2,}
	elseif champ=="Poppy" then 		abilitySequence={3,2,1,1,1,4,1,2,1,2,2,2,3,3,3,3,4,4,}
	elseif champ=="Rammus" then 		abilitySequence={1,2,3,3,3,4,3,2,3,2,4,2,2,1,1,4,1,1,}
	elseif champ=="Renekton" then 		abilitySequence={2,1,3,1,1,4,1,2,1,2,4,2,2,3,3,4,3,3,}
	elseif champ=="Riven" then 		abilitySequence={1,2,3,2,2,4,2,3,2,3,4,3,3,1,1,4,1,1,}
	elseif champ=="Rumble" then 		abilitySequence={1,3,2,1,1,4,2,1,1,3,4,2,3,2,3,4,2,3,}
	elseif champ=="Ryze" then 		abilitySequence={2,1,3,1,1,4,1,2,1,2,4,2,2,3,3,4,3,3,}
	elseif champ=="Sejuani" then 		abilitySequence={2,1,3,3,2,4,3,2,3,3,4,2,1,2,1,4,1,1,}
	elseif champ=="Shaco" then 		abilitySequence={2,3,1,3,3,4,3,2,3,2,4,2,2,1,1,4,1,1,}
	elseif champ=="Shen" then 		abilitySequence={1,2,1,3,1,4,1,3,1,3,4,3,3,2,2,4,2,2,}
	elseif champ=="Shyvana" then 		abilitySequence={2,1,2,3,2,4,2,1,2,1,4,1,1,3,3,4,3,3,}
	elseif champ=="Singed" then 		abilitySequence={3,1,2,1,1,4,1,2,1,2,4,2,2,3,3,4,3,3,}
	elseif champ=="Sion" then 		abilitySequence={1,3,3,2,3,4,3,1,3,1,4,1,1,2,2,4,2,2,}
	elseif champ=="Sivir" then 		abilitySequence={1,3,1,2,1,4,1,2,1,2,4,2,3,2,3,4,3,3,}
	elseif champ=="Skarner" then 		abilitySequence={1,2,1,3,1,4,1,2,1,2,4,2,2,3,3,4,3,3,}
	elseif champ=="Sona" then 		abilitySequence={2,1,2,3,2,4,2,1,2,1,4,1,1,3,3,4,3,3,}
	elseif champ=="Soraka" then 		abilitySequence={2,3,2,3,1,4,2,3,2,3,4,2,3,1,1,4,1,1,} -- optmized to my Soraka support.
	elseif champ=="Swain" then 		abilitySequence={2,3,3,1,3,4,3,1,3,1,4,1,1,2,2,4,2,2,}
	elseif champ=="Talon" then 		abilitySequence={2,3,1,2,2,4,2,1,2,1,4,1,1,3,3,4,3,3,}
	elseif champ=="Taric" then 		abilitySequence={3,2,1,2,2,4,1,2,2,1,4,1,1,3,3,4,3,3,}
	elseif champ=="Teemo" then 		abilitySequence={1,3,2,3,1,4,3,3,3,1,4,2,2,1,2,4,2,1,}
	elseif champ=="Tristana" then 		abilitySequence={3,2,2,3,2,4,2,1,2,1,4,1,1,1,3,4,3,3,}
	elseif champ=="Trundle" then 		abilitySequence={1,2,1,3,1,4,1,2,1,3,4,2,3,2,3,4,2,3,}
	elseif champ=="Tryndamere" then 	abilitySequence={3,1,2,1,1,4,1,2,1,2,4,2,2,3,3,4,3,3,}
	elseif champ=="TwistedFate" then 	abilitySequence={2,1,1,3,1,4,2,1,2,1,4,2,2,3,3,4,3,3,} -- for TF AP
	elseif champ=="Twitch" then 		abilitySequence={1,3,3,2,3,4,3,1,3,1,4,1,1,2,2,1,2,2,}
	elseif champ=="Udyr" then 		abilitySequence={1,2,1,3,1,3,2,1,2,1,2,3,2,4,3,3,4,4,}
	elseif champ=="Urgot" then 		abilitySequence={3,1,1,2,1,4,1,2,1,3,4,2,3,2,3,4,2,3,}
	elseif champ=="Vayne" then 		abilitySequence={1,3,2,1,1,4,1,3,1,3,4,3,3,2,2,4,2,2,}
	elseif champ=="Veigar" then 		abilitySequence={1,3,1,2,1,4,2,2,2,2,4,3,1,1,3,4,3,3,}
	elseif champ=="Viktor" then 		abilitySequence={3,2,3,1,3,4,3,1,3,1,4,1,2,1,2,4,2,2,}
	elseif champ=="Vladimir" then 		abilitySequence={1,3,1,2,1,4,1,3,1,3,4,3,2,3,2,4,2,2,}
	elseif champ=="Volibear" then 		abilitySequence={2,3,2,1,2,4,3,2,1,2,4,3,1,3,1,4,3,1,}
	elseif champ=="Warwick" then 		abilitySequence={2,1,1,2,1,4,1,3,1,3,4,3,3,3,2,4,2,2,}
	elseif champ=="MonkeyKing" then		abilitySequence={3,1,2,1,1,4,3,1,3,1,4,3,3,2,2,4,2,2,} --approved
	elseif champ=="Xerath" then 		abilitySequence={1,3,1,2,1,4,1,2,1,2,4,2,2,3,3,4,3,3,}
	elseif champ=="XinZhao" then 		abilitySequence={1,3,1,2,1,4,1,2,1,2,4,2,2,3,3,4,3,3,}
	elseif champ=="Yorick" then 		abilitySequence={2,3,1,3,3,4,3,2,3,1,4,2,1,2,1,4,2,1,}
	elseif champ=="Ziggs" then 		abilitySequence={1,3,1,2,1,4,1,3,1,3,4,3,3,2,2,4,2,2,}
	elseif champ=="Zilean" then 		abilitySequence={1,2,3,1,1,4,1,3,1,3,4,2,3,2,3,4,2,2,}
	end
	if abilitySequence ~= nil then
		require "autoLevel"
		autoLevel.levelSequence = abilitySequence
		PrintChat(" >> AutoLevelSpell Script loaded!")
		function OnTick()
			autoLevel.OnTick()
		end
	else
		PrintChat(string.format(" >> AutoLevelSpell Script disabled for %s" ,champ))
	end
end