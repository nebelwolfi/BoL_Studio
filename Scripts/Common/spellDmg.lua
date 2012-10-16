--[[
	Spell Damage Library v1.9.4 by eXtragoZ
		If there is a mistake, error, value has changed, incompatibility, bug, or you have an idea
		for improvement, please let me know ;D
		Is designed to calculate the damage of the skills to champions, although most of the calculations
		work for creeps
	Bugs:
		If looking for the skill level of the enemy this always give you one
-------------------------------------------------------
	Usage:
		require "spellDmg"
		local player = GetMyHero()
		local target = heroManager:getHero(i) -- i = ?
		local damage = getDmg("R",target,player,3)
-------------------------------------------------------
		getDmg("SKILL",SDLtarget,SDLplayer,stagedmg,spelllvl)
		Skill:			(in capitals!)
			"P"			-Passive
			"Q"
			"W"
			"E"
			"R"
			"QM"		-Q in melee form (Jayce and Nidalee only)
			"WM"		-W in melee form (Jayce and Nidalee only)
			"EM"		-E in melee form (Jayce and Nidalee only)
			"AD"		-Attack damage
			"IGNITE"	-Ignite
			"DFG"		-Deathfire Grasp
			"HXG"		-Hextech Gunblade
			"BWC"		-Bilgewater Cutlass
			"ECALLING"
			"ISPARK"
			"KITAES"
			"MADREDS"
			"MALADY"
			"WITSEND"
			"LICHBANE"
		Stagedmg:
			nil	Active or first instance of dmg
			1	Active or first instance of dmg
			2	Passive or second instance of dmg
			3	Max damage or third instance of dmg
		-Returns the damage they will do "SDLplayer" to "SDLtarget" with the "skill"
		-With some skills returns a percentage of increased damage
		-Many skills are shown per second, hit and other
		-Use spelllvl only if you want to specify the level of skill
]]
do

	spellDmg = {
		Ahri = {
			QDmgM = "25*Qlvl+15+.33*ap",
			QDmgT = "25*Qlvl+15+.33*ap",
			WDmgM = "math.max(25*Wlvl+15+.4*ap,(25*Wlvl+15+.4*ap)*2*stagedmg3)", -- xfox-fires , Additional fox-fires that hit the same target will deal 50% damage. stage3: Max damage
			EDmgM = "30*Elvl+30+.35*ap",
			RDmgM = "math.max(40*Rlvl+45+.35*ap)", -- xbolt (3 bolts)
		},
		Akali = {
			PDmgM = "(ap/6+14/3)*ad/100",
			QDmgM = "math.max(25*Qlvl+20+.4*ap,(25*Qlvl+20+.4*ap)*2*stagedmg3)", -- x2 if it triggers. stage3: Max damage
			EDmgP = "25*Elvl+5+.3*ap+.6*ad",
			RDmgM = "75*Rlvl+25+.5*ap",
		},
		Alistar = {
			PDmgM = "math.max(6+lvl+.1*ap,(6+lvl+.1*ap)*3*stagedmg3)",  -- xsec (3sec). stage3: Max damage
			QDmgM = "45*Qlvl+15+.5*ap",
			WDmgM = "55*Wlvl+.7*ap",
		},
		Amumu = {
			QDmgM = "60*Qlvl+25+.7*ap",
			WDmgM = "((.3*Wlvl+1.2+.01*ap)*tmhp/100)+4*Wlvl+4", --xsec
			EDmgM = "25*Elvl+50+.5*ap",
			RDmgM = "100*Rlvl+50+.8*ap",
		},
		Anivia = {
			QDmgM = "math.max(30*Qlvl+30+.5*ap,(30*Qlvl+30+.5*ap)*2*stagedmg3)", -- x2 if it detonates. stage3: Max damage
			EDmgM = "math.max(30*Elvl+25+.5*ap,(30*Elvl+25+.5*ap)*2*stagedmg3)", -- x2  If the target has been chilled. stage3: Max damage
			RDmgM = "40*Rlvl+40+.25*ap", --xsec
		},
		Annie = {
			QDmgM = "40*Qlvl+45+.7*ap",
			WDmgM = "50*Wlvl+30+.75*ap",
			EDmgM = "10*Elvl+10+.2*ap", --x each attack suffered
			RDmgM = "math.max((125*Rlvl+75+.7*ap)*stagedmg1,(35+.2*ap)*stagedmg2,(125*Rlvl+75+.7*ap)*stagedmg3)", --stage1:Summon Tibbers . stage2:Aura AoE xsec + 1 Tibbers Attack. stage3:Summon Tibbers
			RDmgP = "(25*Rlvl+55)*stagedmg2",
		},
		Ashe = {
			WDmgP = "10*Wlvl+30+ad",
			RDmgM = "175*Rlvl+75+ap",
		},
		Blitzcrank = {
			QDmgM = "55*Qlvl+25+ap",
			EDmgP = "2*ad",
			RDmgM = "math.max((125*Rlvl+125+ap)*stagedmg1,(100*Rlvl+.2*ap)*stagedmg2,(125*Rlvl+125+ap)*stagedmg3)", --stage1:the active. stage2:the passive. stage3:the active
		},
		Brand = {
			PDmgM = "math.max(2*tmhp/100,(2*tmhp/100)*4*stagedmg3)", --xsec (4sec). stage3: Max damage
			QDmgM = "40*Qlvl+40+.65*ap",
			WDmgM = "math.max(45*Wlvl+30+.6*ap,(45*Wlvl+30+.6*ap)*1.25*stagedmg3)", --125% for units that are ablaze. stage3: Max damage
			EDmgM = "35*Elvl+35+.55*ap",
			RDmgM = "math.max(100*Rlvl+50+.5*ap,(100*Rlvl+50+.5*ap)*3*stagedmg3)", --xbounce (can hit the same enemy up to three times). stage3: Max damage
		},
		Caitlyn = {
			PDmgP = ".5*ad", --xheadshot (bonus)
			QDmgP = "40*Qlvl-20+1.3*ad", --deal 10% less damage for each subsequent target hit, down to a minimum of 50%
			WDmgM = "50*Wlvl+30+.6*ap",
			EDmgM = "50*Elvl+30+.8*ap",
			RDmgP = "225*Rlvl+25+2*ad",
		},
		Cassiopeia = {
			QDmgM = "40*Qlvl+35+.8*ap",
			WDmgM = "10*Wlvl+15+.15*ap", --xsec
			EDmgM = "35*Elvl+15+.55*ap",
			RDmgM = "125*Rlvl+75+.6*ap",
		},
		Chogath = {
			QDmgM = "56.25*Qlvl+23.75+ap",
			WDmgM = "50*Wlvl+25+.7*ap",
			EDmgM = "15*Elvl+5+.3*ap", --xhit
			RDmgT = "175*Rlvl+125+.7*ap"
		},
		Corki = {
			PDmgT = ".1*ad", --xhit
			QDmgM = "50*Qlvl+30+.5*ap",
			WDmgM = "30*Wlvl+30+.4*ap", --xsec (2.5 sec)
			EDmgP = "12*Elvl+8+.4*bad", --xsec (4 sec)
			RDmgM = "math.max(70*Rlvl+50+.3*ap+.2*ad,(70*Rlvl+50+.3*ap+.2*ad)*1.5*stagedmg3)", --150% the big one. stage3: Max damage
		},
		Darius = {
			PDmgM = "(-.75)*((-1)^lvl-2*lvl-13)+.3*bad", --xstack
			QDmgP = "math.max(35*Qlvl+35+.7*bad,(35*Qlvl+35+.7*bad)*1.5*stagedmg3)", --150% Champions in the outer half. stage3: Max damage
			WDmgP = ".2*Wlvl*ad", --(bonus)
			RDmgT = "math.max(90*Rlvl+70+.75*bad,(90*Rlvl+70+.75*bad)*2*stagedmg3)" --xstack of Hemorrhage deals an additional 20% damage. stage3: Max damage
		},
		Diana = {
			PDmgM = "math.max(5*lvl+15,10*lvl,15*lvl-25,20*lvl-85,25*lvl-160)+.6*ap", -- (bonus)
			QDmgM = "40*Qlvl+30+.7*ap",
			WDmgM = "math.max(14*Wlvl+6+.2*ap,(14*Wlvl+6+.2*ap)*3*stagedmg3)", --xOrb (3 orbs). stage3: Max damage
			RDmgM = "60*Rlvl+40+.6*ap",
		},
		DrMundo = {
			QDmgM = "math.max((2.5*Qlvl+12.5)*thp/100,50*Qlvl+30)",
			WDmgM = "15*Wlvl+20+.2*ap", --xsec
		},
		Draven = {
			PDmgP = "4*lvl+30", --xhit (bonus)
			QDmgP = "(.1*Qlvl+.35)*ad", --xhit (bonus)
			EDmgP = "35*Elvl+35+.5*bad",
			RDmgP = "100*Rlvl+75+1.1*bad", --xhit (max 2 hits), deals 8% less damage for each unit hit, down to a minimum of 40%
		},
		Evelynn = {
			QDmgM = "20*Qlvl+20+.45*ap+.4*bad",
			EDmgM = "50*Elvl+20+ap+.8*bad", --total
			RDmgM = "(5*Rlvl+10+.02*ap)*tmhp/100",
		},
		Ezreal = {
			QDmgP = "20*Qlvl+15+.2*ap+ad", --without counting on-hit effects
			WDmgM = "45*Wlvl+25+.7*ap",
			EDmgM = "50*Elvl+25+.75*ap",
			RDmgM = "150*Rlvl+200+.9*ap+bad", --deal 8% less damage for each subsequent target hit, down to a minimum of 30%
		},
		FiddleSticks = {
			WDmgM = "math.max(30*Wlvl+30+.45*ap,(30*Wlvl+30+.45*ap)*5*stagedmg3)", --xsec (5 sec). stage3: Max damage
			EDmgM = "math.max(20*Elvl+45+.45*ap,(20*Elvl+45+.45*ap)*3*stagedmg3)", --xbounce. stage3: Max damage
			RDmgM = "math.max(100*Rlvl+25+.45*ap,(100*Rlvl+25+.45*ap)*5*stagedmg3)", --xsec (5 sec). stage3: Max damage
		},
		Fiora = {
			QDmgP = "25*Qlvl+15+.6*bad", --xstrike
			WDmgM = "50*Wlvl+10+ap",
			RDmgP = "math.max(170*Rlvl-10+1.2*bad,(170*Rlvl-10+1.2*bad)*2*stagedmg3)", --xstrike , without counting on-hit effects, Successive hits against the same target deal 25% damage. stage3: Max damage
		},
		Fizz = {
			QDmgM = "30*Qlvl-20+.6*ap", --without counting on-hit effects
			QDmgP = "ad",
			WDmgM = "math.max(((15*Wlvl+25+.7*ap)+(Wlvl+3)*(tmhp-thp)/100)*stagedmg1,((10*Wlvl+20+.35*ap)+(Wlvl+3)*(tmhp-thp)/100)*stagedmg2,((15*Wlvl+25+.7*ap)+(Wlvl+3)*(tmhp-thp)/100)*stagedmg3)", --stage1:when its active. stage2:Passive. stage3:when its active
			EDmgM = "50*Elvl+20+.75*ap",
			RDmgM = "125*Rlvl+75+ap",
		},
		Galio = {
			QDmgM = "55*Qlvl+25+.6*ap",
			EDmgM = "45*Elvl+15+.5*ap",
			RDmgM = "math.max(110*Rlvl+110+.6*ap,(110*Rlvl+110+.6*ap)*1.4*stagedmg3)", --additional 5% damage for each attack suffered while channeling and capping at 40%. stage3: Max damage
		},
		Gangplank = {
			PDmgM = "3+lvl", --xstack
			QDmgP = "25*Qlvl-5+ad", --without counting on-hit effects
			RDmgM = "45*Rlvl+30+.2*ap", --xCannonball (25 cannonballs)
		},
		Garen = {
			QDmgP = "25*Qlvl+5+1.4*ad",
			EDmgP = "math.max(25*Elvl-5+(.1*Elvl+.6)*ad,(25*Elvl-5+(.1*Elvl+.6)*ad)*2.5*stagedmg3)", --xsec (2.5 sec). stage3: Max damage
			RDmgM = "175*Rlvl+(tmhp-thp)/((8-Rlvl)/2)",
		},
		Gragas = {
			QDmgM = "50*Qlvl+35+.9*ap",
			EDmgM = "40*Elvl+40+.5*ap+.66*ad", --Damage is split amongst targets hit, "25*Elvl+25+.5*ap" Minimal Damage
			RDmgM = "125*Rlvl+75+ap",
		},
		Graves = {
			QDmgP = "math.max(35*Qlvl+25+.8*bad,(35*Qlvl+25+.8*bad)*1.7*stagedmg3)", --xbullet , each bullet beyond the first will deal only 35% damage. stage3: Max damage
			WDmgM = "50*Wlvl+10+.6*ap",
			RDmgP = "100*Rlvl+150+1.4*bad", -- Initial , "110*Rlvl+30+1.2*bad" Explosion
		},
		Hecarim = {
			QDmgP = "35*Qlvl+15+.6*bad",
			WDmgM = "math.max(11.25*Wlvl+8.75+.2*ap,(11.25*Wlvl+8.75+.2*ap)*4*stagedmg3)", --xsec (4 sec). stage3: Max damage
			EDmgP = "math.max(35*Elvl+5+.5*bad,(35*Elvl+5+.5*bad)*2*stagedmg3)", --Minimum , 200% Maximum (bonus). stage3: Max damage
			RDmgM = "math.max((100*Rlvl+.8*ap)*stagedmg1,(75*Rlvl-25+.4*ap)*stagedmg2,(175*Rlvl-25+1.2*ap)*stagedmg3", --stage1:Initial. stage2:Shockwave. stage3: Max damage
		},
		Heimerdinger = {
			QDmgM = "8*Qlvl+22+.2*ap", --x Turrets attack
			WDmgM = "50*Wlvl+35+.55*ap",
			EDmgM = "55*Elvl+25+.6*ap",
		},
		Irelia = {
			QDmgP = "30*Qlvl-10+ad",
			WDmgT = "15*Wlvl", --xhit (bonus)
			EDmgM = "50*Elvl+30+.5*ap",
			RDmgP = "40*Rlvl+40+.5*ap+.6*bad", --xblade
		},
		Janna = {
			QDmgM = "(25*Qlvl+35+.75*ap)+(math.max(25,10*Qlvl+10))*3*stagedmg3", -- + 25/30/40/50/60 per second charging (3 sec). stage3: Max damage
			WDmgM = "55*Wlvl+5+.6*ap",
		},
		JarvanIV = {
			PDmgP = "math.min((2*(math.floor((lvl-1)/6)+1)+4)*tmhp/100,400)",
			QDmgP = "45*Qlvl+25+1.2*bad",
			EDmgM = "45*Elvl+15+.8*ap",
			RDmgP = "125*Rlvl+75+1.5*bad",
		},
		Jax = {
			QDmgP = "40*Qlvl+30+.6*ap+bad",
			WDmgM = "35*Wlvl+5+.6*ap",
			EDmgP = "math.max(25*Elvl+25+.5*bad,(25*Elvl+25+.5*bad)*2*stagedmg3)", --deals 20% additional damage for each attack dodged to a maximum of 100%. stage3: Max damage
			RDmgM = "60*Rlvl+40+.7*ap", --every third basic attack
		},
		Jayce = {
			QDmgP = "math.max(55*Qlvl+5+1.2*bad,(55*Qlvl+5+1.2*bad)*1.4*stagedmg3)", --If its fired through an Acceleration Gate damage will increase by 40%. stage3: Max damage
			WDmgT = "15*Wlvl+55", --% damage
			QMDmgP = "45*Qlvl-25+bad",
			WMDmgM = "math.max(17.5*Wlvl+7.5+.25*ap,(17.5*Wlvl+7.5+.25*ap)*4*stagedmg3)", --xsec (4 sec). stage3: Max damage
			EMDmgM = "30*Elvl+10+bad+((3*Elvl+5)*tmhp/100)",
			RDmgM = "40*Rlvl-20",
		},
		Karma = {
			QDmgM = "40*Qlvl+30+.6*ap",
			WDmgM = "45*Wlvl+35+.7*ap",
			EDmgM = "40*Elvl+40+.8*ap",
		},
		Karthus = {
			QDmgM = "40*Qlvl+40+.6*ap", --50% damage if it hits multiple units
			EDmgM = "20*Elvl+10+.25*ap", --xsec
			RDmgM = "150*Rlvl+100+.6*ap",
		},
		Kassadin = {
			QDmgM = "50*Qlvl+30+.7*ap",
			WDmgM = "15*Wlvl+15+.15*ap",
			EDmgM = "50*Elvl+30+.6*ap",
			RDmgM = "10*Rlvl+50+.8*ap+(10*Rlvl+50)*10*stagedmg3", -- "10*Rlvl+50" additional damage per stack. stage3: Max damage
		},
		Katarina = {
			QDmgM = "math.max((25*Qlvl+35+.45*ap)*stagedmg1,(15*Qlvl+.15*ap)*stagedmg2,(40*Qlvl+35+.6*ap)*stagedmg3)", --stage1:Dagger, Each subsequent hit deals 10% less damage. stage2:On-hit. stage3: Max damage
			WDmgM = "40*Wlvl+.25*ap+.5*bad",
			EDmgM = "25*Elvl+35+.5*ap",
			RDmgM = "math.max(10*Rlvl+30+.175*ap+.3*bad,(10*Rlvl+30+.175*ap+.3*bad)*10*stagedmg3)", --xdagger (champion can be hit by a maximum of 10 daggers (2 sec)). stage3: Max damage
		},
		Kayle = {
			QDmgM = "50*Qlvl+10+ap+bad",
			EDmgM = "10*Elvl+10+.4*ap", --xhit (bonus)
		},
		Kennen = {
			QDmgM = "40*Qlvl+35+.75*ap",
			WDmgM = "30*Wlvl+35+.55*ap",
			EDmgM = "40*Elvl+45+.6*ap",
			RDmgM = "math.max(65*Rlvl+15+.4*ap,(65*Rlvl+15+.4*ap)*3*stagedmg3)", --xbolt (max 3 bolts). stage3: Max damage
		},
		Khazix = {
			PDmgM = "math.max(5*lvl+10,10*lvl-5,15*lvl-55,20*lvl-140)+.5*ap", -- (bonus)
			QDmgP = "math.max((30*Qlvl+40+1.6*bad)*stagedmg1,(12*(tmhp-thp)/100)*stagedmg2,(45*Qlvl+55+2.4*bad)*stagedmg3)", --stage1:Normal. stage2:Evolved Enlarged Claws (Bonus). stage3: to Isolated Target
			WDmgP = "40*Wlvl+35+.9*bad",
			EDmgP = "35*Elvl+30+.8*bad",
		},
		KogMaw = {
			PDmgT = "100+25*lvl",
			QDmgM = "50*Qlvl+10+.7*ap",
			WDmgM = "(Wlvl+1+.01*ap)*tmhp/100", --xhit (bonus)
			EDmgM = "50*Elvl+10+.7*ap",
			RDmgM = "90*Rlvl+90+.3*ap+.5*bad",
		},
		Leblanc = {
			QDmgM = "math.max((40*Qlvl+30+.6*ap)*stagedmg1,(20*Qlvl+.3*ap)*stagedmg2,(60*Qlvl+30+.9*ap)*stagedmg3)", --stage1:Initial. stage2:mark. stage3: Max damage
			WDmgM = "40*Wlvl+45+.6*ap",
			EDmgM = "math.max(25*Qlvl+15+.5*ap,(25*Qlvl+15+.5*ap)*2*stagedmg3)", --Initial or Delayed. stage3: Max damage
			RDmgT = "15*Rlvl-5" --% damage increase
		},
		LeeSin = {
			QDmgP = "math.max((30*Qlvl+20+.9*bad)*stagedmg1,(30*Qlvl+20+.9*bad+8*(tmhp-thp)/100)*stagedmg2,(60*Qlvl+40+1.8*bad+8*(tmhp-thp)/100)*stagedmg3)", --stage1:Sonic Wave. stage2:Resonating Strike. stage3: Max damage
			EDmgM = "35*Qlvl+25+bad",
			RDmgP = "200*Rlvl+2*bad",
		},
		Leona = {
			PDmgM = "(-1.25)*(3*(-1)^lvl-6*lvl-7)",
			QDmgM = "30*Qlvl+10+.3*ap", -- (bonus)
			WDmgM = "50*Wlvl+10+.4*ap",
			EDmgM = "40*Elvl+20+.4*ap",
			RDmgM = "100*Rlvl+50+.8*ap",
		},
		Lulu = {
			PDmgM = "math.max(0.25*(11-3*(-1)^lvl+6*lvl),(0.25*(11-3*(-1)^lvl+6*lvl))*3*stagedmg3)", --xbolt (3 bolts). stage3: Max damage
			QDmgM = "45*Qlvl+35+.5*ap",
			EDmgM = "50*Elvl+30+.6*ap",
		},
		Lux = {
			PDmgM = "10+10*lvl",
			QDmgM = "50*Qlvl+10+.7*ap",
			EDmgM = "45*Elvl+15+.6*ap",
			RDmgM = "100*Rlvl+200+.75*ap",
		},
		Malphite = {
			QDmgM = "50*Qlvl+20+.6*ap",
			EDmgM = "40*Elvl+20+.2*ap+.3*ar",
			RDmgM = "100*Rlvl+100+ap",
		},
		Malzahar = {
			PDmgP = "20+5*lvl+bad", --xhit
			QDmgM = "55*Qlvl+25+.8*ap",
			WDmgM = "(Wlvl+3+.01*ap)*tmhp/100",
			EDmgM = "60*Elvl+20+.8*ap",
			RDmgM = "150*Rlvl+100+1.3*ap",
		},
		Maokai = {
			QDmgM = "45*Qlvl+25+.4*ap",
			WDmgM = "35*Wlvl+45+.8*ap",
			EDmgM = "math.max((35*Elvl+5+.4*ap)*stagedmg1,(50*Elvl+30+.6*ap)*stagedmg2,(85*Elvl+35+ap)*stagedmg3)", --stage1:Impact. stage2:Explosion. stage3: Max damage
			RDmgM = "50*Rlvl+50+.5*ap+(50*Rlvl+150)*stagedmg3", -- +2 per point of damage absorbed (max 200/250/300). stage3: Max damage
		},
		MasterYi = {
			QDmgM = "50*Qlvl+50+ap",
		},
		MissFortune = {
			QDmgP = "35*Qlvl-10+.75*ad", --120% damage to target behind the first
			WDmgM = "math.max(2*Wlvl+4+.05*ap,(2*Wlvl+4+.05*ap)*4*stagedmg3)", --xstack. stage3: Max damage
			EDmgM = "55*Elvl+35+.8*ap", --over 2 seconds
			RDmgP = "math.max(30*Rlvl+35+.2*ap+.45*bad,(30*Rlvl+35+.2*ap+.45*bad)*8*stagedmg3)", --xwave (8 waves). stage3: Max damage
		},
		Mordekaiser = {
			QDmgM = "math.max(30*Qlvl+50+.4*ap+bad,(30*Qlvl+50+.4*ap+bad)*1.65*stagedmg3)", --If the target is alone, the ability deals 65% more damage. stage3: Max damage
			WDmgM = "math.max(14*Wlvl+10+.2*ap,(14*Wlvl+10+.2*ap)*6*stagedmg3)", --xsec (6 sec). stage3: Max damage
			EDmgM = "45*Elvl+25+.6*ap",
			RDmgM = "(5*Rlvl+19+.04*ap)*tmhp/100",
		},
		Morgana = {
			QDmgM = "55*Qlvl+25+.6*ap",
			WDmgM = "math.max(15*Wlvl+10+.2*ap,(15*Wlvl+10+.2*ap)*5*stagedmg3)", --xsec (5 sec). stage3: Max damage
			RDmgM = "math.max(75*Rlvl+100+.7*ap,(75*Rlvl+100+.7*ap)*2*stagedmg3)", --x2 If the target stay in range for the full duration. stage3: Max damage
		},
		Nasus = {
			QDmgP = "20*Qlvl+10+ad", --+3 per enemy killed by Siphoning Strike
			EDmgM = "math.max((80*Elvl+30+1.2*ap)/5,(80*Elvl+30+1.2*ap)*stagedmg3)", --xsec (5 sec). stage3: Max damage
			RDmgM = "(Rlvl+2+.01*ap)*tmhp/100", --xsec (15 sec)
		},
		Nautilus = {
			PDmgP = "2+6*lvl",
			QDmgM = "45*Qlvl+15+.75*ap",
			WDmgM = "25*Wlvl+5+.4*ap", --xhit
			EDmgM = "math.max(40*Elvl+20+.5*ap,(40*Elvl+20+.5*ap)*2*stagedmg3)", --xexplosions , 50% less damage from additional explosions. stage3: Max damage
			RDmgM = "125*Rlvl+75+.8*ap",
		},
		Nidalee = {
			QDmgM = "math.max(43.75*Qlvl+11.25+.65*ap,(43.75*Qlvl+11.25+.65*ap)*2.5*stagedmg3)", --deals up to 250% damage the further away the target is. stage3: Max damage
			WDmgM = "45*Wlvl+35+.4*ap",
			QMDmgP = "(30*Rlvl+10+ad)*(1+2*(tmhp-thp)/tmhp)", --(total attack damage + 40/70/100) * (1 + ( 2 * %missing health / 100 ))
			WMDmgM = "50*Rlvl+75+.4*ap",
			EMDmgM = "75*Rlvl+75+.4*ap",
		},
		Nocturne = {
			PDmgP = ".2*ad", --(bonus)
			QDmgP = "45*Qlvl+15+.75*bad",
			EDmgM = "50*Elvl+ap",
			RDmgP = "100*Rlvl+50+1.2*bad",
		},
		Nunu = {
			EDmgM = "37.5*Elvl+47.5+ap",
			RDmgM = "250*Rlvl+375+2.5*ap",
		},
		Olaf  = {
			QDmgP = "45*Qlvl+35+bad",
			EDmgT = "60*Elvl+40",
		},
		Orianna = {
			PDmgM = "8*(math.floor((lvl-1)/3)+1)+2+0.15*ap", --xhit
			QDmgM = "30*Qlvl+30+.5*ap", --10% less damage for each subsequent target hit down to a minimum of 40%
			WDmgM = "45*Wlvl+25+.7*ap",
			EDmgM = "30*Elvl+30+.3*ap",
			RDmgM = "75*Rlvl+75+.7*ap",
		},
		Pantheon = {
			QDmgP = "(40*Qlvl+25+1.4*bad)+(40*Qlvl+25+1.4*bad)*0.5*math.floor((tmhp-thp)/85)",
			WDmgM = "25*Wlvl+25+ap",
			EDmgP = "math.max(20*Elvl+6+1.2*bad,(20*Elvl+6+1.2*bad)*3*stagedmg3)", --xStrike (3 strikes). stage3: Max damage
			RDmgM = "300*Rlvl+100+ap",
		},
		Poppy = {
			QDmgM = "25*Qlvl+.6*ap+math.min(0.08*tmhp,75*Qlvl)", --(bonus)
			EDmgM = "math.max((25*Elvl+25+.4*ap)*stagedmg1,(50*Elvl+25+.4*ap)*stagedmg2,(75*Elvl+50+.8*ap)*stagedmg3)", --stage1:initial. stage2:Collision. stage3: Max damage
			RDmgT = "10*Rlvl+10" --% Increased Damage
		},
		Rammus = {
			QDmgM = "50*Qlvl+50+ap",
			WDmgM = "10*Wlvl+5+.1*ar", --x each attack suffered
			RDmgM = "65*Rlvl+.3*ap",
		},
		Renekton = {
			QDmgP = "math.max(30*Qlvl+30+.8*bad,(30*Qlvl+30+.8*bad)*1.5*stagedmg3)", --stage1:with 50 fury deals 50% additional damage. stage3: Max damage
			WDmgP = "math.max(20*Wlvl-10+1.5*ad,(20*Wlvl-10+1.5*ad)*1.5*stagedmg3)", --stage1:with 50 fury deals 50% additional damage. stage3: Max damage
			EDmgP = "math.max(30*Elvl+.9*bad,(30*Elvl+.9*bad)*1.5*stagedmg3)", --stage1:Slice or Dice , with 50 fury Dice deals 50% additional damage. stage3: Max damage of Dice
			RDmgM = "30*Rlvl+10+.1*ap", --xsec (15 sec)
		},
		Rengar = {
			PDmgP = "ad",
			QDmgP = "math.max((30*Qlvl+ad)*stagedmg1,(30*Qlvl+2.5*ad)*stagedmg2,(30*Qlvl+2.5*ad)*stagedmg3)", --stage1:Savagery. stage2:Empowered Savagery . stage3: Empowered Savagery
			WDmgM = "40*Wlvl+20+.8*ap",
			EDmgP = "45*Elvl+15+.7*bad",
		},
		Riven = {
			PDmgP = "math.max(2*(math.floor((lvl-1)/3)+1)+3+0.5*bad,(2*(math.floor((lvl-1)/3)+1)+3+0.5*bad)*3*stagedmg3)", --xcharge (max 3 charges). stage3: Max damage
			QDmgP = "25*Qlvl+5+.7*bad", --xstrike (3 strikes)
			WDmgP = "30*Wlvl+20+bad",
			RDmgP = "math.min((40*Rlvl+40+.6*bad)*(1+(100-25)/100*8/3),120*Rlvl+120+1.8*bad)",
		},
		Rumble = {
			PDmgM = "20+5*lvl+.25*ap", --xhit
			QDmgM = "math.max(70/3*Qlvl+20/3+.45*ap,(70/3*Qlvl+20/3+.45*ap)*3*stagedmg3)", --xsec (3 sec) , with 50 heat deals 25% additional damage. stage3: Max damage , with 50 heat deals 25% additional damage
			EDmgM = "30*Elvl+25+.5*ap", --xshoot (2 shoots) , with 50 heat deals 25% additional damage
			RDmgM = "math.max((75*Rlvl+75+.5*ap)*stagedmg1,(40*Rlvl+60+.2*ap)*stagedmg2,(75*Rlvl+75+.5*ap+(40*Rlvl+60+.2*ap)*5)*stagedmg3)", --stage1:Initial. stage2: xsec (5 sec). stage3: Max damage
		},
		Ryze = {
			QDmgM = "25*Qlvl+35+.4*ap+.065*mana",
			WDmgM = "35*Wlvl+25+.6*ap+.045*mana",
			EDmgM = "math.max(20*Elvl+30+.35*ap+.01*mana,(20*Elvl+30+.35*ap+.01*mana)*3*stagedmg3)", --xbounce. stage3: Max damage
		},
		Sejuani = {
			QDmgM = "37.5*Qlvl+22.5+.4*ap",
			WDmgM = "math.max(8*Wlvl+4+.1*ap+(.0025*Wlvl+.0075)*mhp,(8*Wlvl+4+.1*ap+(.0025*Wlvl+.0075)*mhp)*1.5*stagedmg3)", --xsec (5 sec) Damage is increased by 50% against enemies affected by Frost or Permafrost. stage3: Max damage
			EDmgM = "50*Elvl+10+.5*ap",
			RDmgM = "100*Rlvl+50+.8*ap",
		},
		Shaco = {
			QDmgP = "(.2*Qlvl+.2)*ad", --(bonus)
			WDmgM = "15*Wlvl+20+.2*ap", --xhit
			EDmgM = "40*Elvl+10+ap+bad",
			RDmgM = "150*Rlvl+150+ap", --The clone deals 75% of Shaco's damage
		},
		Shen = {
			PDmgM = "4+4*lvl+(mhp-(428+85*lvl))*.1", --(bonus)
			QDmgM = "40*Qlvl+20+.6*ap",
			EDmgM = "35*Elvl+15+.5*ap",
		},
		Shyvana = {
			QDmgP = "(.05*Qlvl+.75)*ad", --Second Strike
			WDmgM = "math.max(15*Wlvl+10+.2*bad,(15*Wlvl+10+.2*bad)*7*stagedmg3)", --xsec (3 sec + 4 extra sec). stage3: Max damage
			EDmgM = "45*Elvl+35+.6*ap", --Each autoattack that hits debuffed targets will deal 15% of the ability's damage
			RDmgM = "100*Rlvl+100+.7*ap",
		},
		Singed = {
			QDmgM = "12*Qlvl+10+.3*ap", --xsec
			EDmgM = "50*Elvl+50+ap",
		},
		Sion = {
			QDmgM = "57.5*Qlvl+12.5+.9*ap",
			WDmgM = "50*Wlvl+50+.9*ap",
		},
		Sivir = {
			QDmgP = "45*Qlvl+15+.5*ap+1.1*bad", --x2 , 20% reduced damage to each subsequent target
			WDmgP = "15*Wlvl+5+ad", --20% less damage with each bounce
		},
		Skarner = {
			QDmgM = "12*Qlvl+12+.4*ap",
			QDmgP = "15*Qlvl+10+.8*bad",
			EDmgM = "40*Elvl+40+.7*ap",
			RDmgM = "100*Rlvl+100+ap",
		},
		Sona = {
			PDmgM = "math.max(8+10*lvl,(8+10*lvl)*2*stagedmg3)", --x2 with Staccato. stage3: Max damage
			QDmgM = "50*Qlvl+.7*ap",
			RDmgM = "100*Rlvl+50+.8*ap",
		},
		Soraka = {
			QDmgM = "25*Qlvl+35+.4*ap",
			EDmgM = "50*Elvl+.75*ap",
		},
		Swain = {
			QDmgM = "math.max(15*Qlvl+10+.3*ap,(15*Qlvl+10+.3*ap)*3*stagedmg3)", --xsec (3 sec). stage3: Max damage
			WDmgM = "40*Wlvl+40+.7*ap",
			EDmgM = "math.max((40*Elvl+35+.8*ap)*stagedmg1,(40*Elvl+35+.8*ap)*stagedmg3)", --stage1:Active.  stage2:% Extra Damage.  stage3:Active
			EDmgT = "(3*Elvl+5)*stagedmg2",
			RDmgM = "20*Rlvl+30+.2*ap", --xstrike (1 strike x sec)
		},
		Syndra = {
			QDmgM = "math.max(40*Qlvl+30+.6*ap,(40*Qlvl+30+.6*ap)*1.15*(Qlvl-4))",
			WDmgM = "40*Wlvl+40+.7*ap",
			EDmgM = "45*Elvl+25+.4*ap",
			RDmgM = "math.max(45*Rlvl+45+.2*ap,(45*Rlvl+45+.2*ap)*7*stagedmg3)", --stage1:xSphere (Minimum 3). stage3:7 Spheres
		},
		Talon = {
			QDmgP = "48*Qlvl+1.5*bad", --(bonus)
			WDmgP = "math.max(25*Wlvl+5+.6*bad,(25*Wlvl+5+.6*bad)*2*stagedmg3)", --x2 if the target is hit twice. stage3: Max damage
			EDmgT = "3*Elvl", --% Damage Amplification
			RDmgP = "math.max(70*Rlvl+50+.9*bad,(70*Rlvl+50+.9*bad)*2*stagedmg3)", --x2 if the target is hit twice. stage3: Max damage
		},
		Taric = {
			WDmgM = "45*Wlvl+15+.6*ap",
			EDmgM = "math.max(30*Elvl+10+.4*ap,(30*Elvl+10+.4*ap)*2*stagedmg3)", --min (lower damage the farther the target is)  up to 200%
			RDmgM = "100*Rlvl+50+.7*ap",
		},
		Teemo = {
			QDmgM = "45*Qlvl+35+.8*ap",
			EDmgM = "34*Elvl+.8*ap", --Hit+poison for 4 seconds (bonus)
			RDmgM = "200*Rlvl+.8*ap",
		},
		Tristana = {
			WDmgM = "45*Wlvl+25+.8*ap",
			EDmgM = "math.max((30*Elvl+80+ap)*stagedmg1,(25*Elvl+25+.25*ap)*stagedmg2,(30*Elvl+80+ap)*stagedmg3)", --stage1:Active.  stage2:Passive.  stage3:Active
			RDmgM = "100*Rlvl+200+1.5*ap",
		},
		Trundle = {
			QDmgP = "(.1*Qlvl+.7)*ad", --(bonus)
			RDmgM = "75*Rlvl+25+.6*ap",
		},
		Tryndamere = {
			EDmgP = "30*Elvl+40+ap+1.2*bad",
		},
		TwistedFate = {
			QDmgM = "50*Qlvl+10+.65*ap",
			WDmgM = "math.max((7.5*Wlvl+7.5+.4*ap+ad)*stagedmg1,(15*Wlvl+15+.4*ap+ad)*stagedmg2,(20*Wlvl+20+.4*ap+ad)*stagedmg3)", --stage1:Gold Card.  stage2:Red Card.  stage3:Blue Card
			EDmgM = "25*Elvl+30+.4*ap",
		},
		Twitch = {
			PDmgT = "2*((lvl-1)/4.5+1)", --xstack
			EDmgP = "math.max((5*Elvl+10+.2*ap+.25*bad)*stagedmg1,(10*Elvl+30)*stagedmg2,((5*Elvl+10+.2*ap+.25*bad)*6+10*Elvl+30)*stagedmg3)", --stage1:xstack (6 stack). stage2:Base. stage3: Max damage
		},
		Udyr = {
			QDmgM = "50*Qlvl-20+1.5*ad", --(bonus)
			RDmgM = "math.max((10*Rlvl+5+.25*ap)*stagedmg1,(40*Rlvl+.25*ap)*stagedmg2,(10*Rlvl+5+.25*ap)*5*stagedmg3)", --stage1:x wave (5 waves). stage2:xThird Attack. stage3:5 waves
		},
		Urgot = {
			QDmgP = "30*Qlvl-20+.85*ad",
			EDmgP = "55*Elvl+20+.6*bad",
		},
		Varus = {
			QDmgP = "50*Qlvl-35+1.6*ad", --max , 62.5% min , reduced by 15% per enemy hit (minimum 33%)
			WDmgM = "math.max((4*Wlvl+6+.25*ap)*stagedmg1,((.0075*Wlvl+.0125+.02*ap)*tmhp/100)*stagedmg2,((.0075*Wlvl+.0125+.02*ap)*tmhp/100)*3*stagedmg3)", --stage1:xhit. stage2:xstack (3 stacks). stage3: 3 stacks
			EDmgP = "40*Elvl+25+.6*ap",
			RDmgM = "100*Rlvl+50+ap",
		},
		Vayne = {
			QDmgP = "(.05*Qlvl+.25)*ad", --(bonus)
			WDmgT = "10*Wlvl+10+((.01*Wlvl+.03)*tmhp/100)",
			EDmgP = "math.max(35*Elvl+10+.5*bad,(35*Elvl+10+.5*bad)*2*stagedmg3)", --x2 If they collide with terrain. stage3: Max damage
		},
		Veigar = {
			QDmgM = "45*Qlvl+35+.6*ap",
			WDmgM = "50*Wlvl+70+ap",
			RDmgM = "125*Rlvl+125+1.2*ap+.8*tap",
		},
		Viktor = {
			QDmgM = "45*Qlvl+35+.65*ap",
			EDmgM = "math.max(45*Elvl+25+.7*ap,(45*Elvl+25+.7*ap)*1.3*stagedmg3)", --Augment Death deal 30% additional damage. stage3: Max damage
			RDmgM = "math.max((100*Rlvl+50+.55*ap)*stagedmg1,(20*Rlvl+20+.25*ap)*stagedmg2,(100*Rlvl+50+.55*ap+(20*Rlvl+20+.25*ap)*7)*stagedmg3)", --stage1:initial. stage2: xsec (7 sec). stage3: Max damage
		},
		Vladimir = {
			QDmgM = "35*Qlvl+55+.6*ap",
			WDmgM = "55*Wlvl+25+(mhp-(400+85*lvl))*.15", --(2 sec)
			EDmgM = "math.max((25*Elvl+35+.45*ap)*stagedmg1,((25*Elvl+35)*0.25)*stagedmg2,((25*Elvl+35)*2+.45*ap)*stagedmg3)", --stage1:25% more base damage x stack. stage2:+x stack. stage3: Max damage
			RDmgM = "100*Rlvl+50+.7*ap",
		},
		Volibear = {
			QDmgP = "30*Qlvl", --(bonus)
			WDmgP = "((Wlvl-1)*45+80+(mhp-(440+lvl*86))*.15)*(1+(tmhp-thp)/tmhp)",
			EDmgM = "45*Elvl+15+.6*ap",
			RDmgM = "80*Rlvl-5+.3*ap", --xhit
		},
		Warwick = {
			PDmgM = "math.max(.5*lvl+2.5,(.5*lvl+2.5)*3*stagedmg3)", --xstack (3 stacks). stage3: Max damage
			QDmgM = "50*Qlvl+25+ap+((2*Qlvl+6)*tmhp/100)",
			RDmgM = "math.max(17*Rlvl+33+.4*bad,(17*Rlvl+33+.4*bad)*5*stagedmg3)", --xstrike (5 strikes) , without counting on-hit effects. stage3: Max damage
		},
		MonkeyKing = {
			QDmgP = "30*Qlvl+.1*ad", --(bonus)
			WDmgM = "45*Wlvl+25+.6*ap",
			EDmgP = "45*Elvl+15+.8*bad",
			RDmgP = "math.max(90*Rlvl-70+1.2*ad,(90*Rlvl-70+1.2*ad)*4*stagedmg3)", --xsec (4 sec). stage3: Max damage
		},
		Xerath = {
			QDmgM = "40*Qlvl+35+.6*ap",
			EDmgM = "50*Elvl+20+.8*ap",
			RDmgM = "75*Rlvl+50+.6*ap", --xcast (3 cast)
		},
		XinZhao = {
			QDmgP = "15*Qlvl+.2*ad", --(bonus x hit)
			EDmgM = "45*Elvl+25+.6*ap",
			RDmgP = "100*Rlvl+25+bad+15*thp/100",
		},
		Yorick = {
			PDmgP = ".35*ad", --xhit of ghouls
			QDmgP = "30*Qlvl+.2*ad", --(bonus)
			WDmgM = "35*Wlvl+25+ap",
			EDmgM = "30*Elvl+25+bad",
		},
		Ziggs = {
			PDmgM = "13+7*lvl+.35*ap",
			QDmgM = "45*Qlvl+30+.65*ap",
			WDmgM = "35*Wlvl+35+.35*ap",
			EDmgM = "25*Elvl+15+.3*ap", --xmine , 40% damage from additional mines
			RDmgM = "125*Rlvl+125+.9*ap", --enemies away from the primary blast zone will take 80% damage
			RDmgM = "125*Rlvl+125+.9*ap", --enemies away from the primary blast zone will take 80% damage
		},
		Zilean = {
			QDmgM = "57.5*Qlvl+32.5+.9*ap",
		},
		Zyra = {
			PDmgT = "99+25*lvl",
			QDmgM = "40*Qlvl+35+.6*ap",
			WDmgM = "26+6*lvl+.2*ap", --xstrike Extra plants striking the same target deal 50% less damage
			EDmgM = "35*Elvl+25+.5*ap",
			RDmgM = "85*Rlvl+95+.7*ap",
		},
	}
	
	function getDmg(spellname,SDLtarget,SDLplayer,stagedmg,spelllvl)
		local name = SDLplayer.charName
		lvl = SDLplayer.level
		ap = SDLplayer.ap
		ad = SDLplayer.totalDamage
		bad = SDLplayer.addDamage
		ar = SDLplayer.armor
		mana = SDLplayer.maxMana
		mhp = SDLplayer.maxHealth
		tap = SDLtarget.ap
		thp = SDLtarget.health
		tmhp = SDLtarget.maxHealth
		if spelllvl ~= nil then
			Qlvl,Wlvl,Elvl,Rlvl = spelllvl,spelllvl,spelllvl,spelllvl
		else
			Qlvl = SDLplayer:GetSpellData(_Q).level
			Wlvl = SDLplayer:GetSpellData(_W).level
			Elvl = SDLplayer:GetSpellData(_E).level
			Rlvl = SDLplayer:GetSpellData(_R).level
		end
		if stagedmg ~= nil and stagedmg == 2 then
			stagedmg1,stagedmg2,stagedmg3 = 0,1,0
		elseif stagedmg ~= nil and stagedmg == 3 then
			stagedmg1,stagedmg2,stagedmg3 = 0,0,1
		else
			stagedmg1,stagedmg2,stagedmg3 = 1,0,0
		end
		local TrueDmg = 0
		local XM = false
		if name == Jayce or name == Nidalee then XM = true end
		if (spellname == "Q" and Qlvl == 0) or (spellname == "W" and Wlvl == 0) or (spellname == "E" and Elvl == 0) or (Rlvl == 0 and (spellname == "R" or spellname == "QM" or spellname == "WM" or spellname == "EM")) then
			return 0
		elseif spellname == "Q" or spellname == "W" or spellname == "E" or spellname == "R" or spellname == "P" or (XM and (spellname == "QM" or spellname == "WM" or spellname == "EM")) then
			local dmgtxtm = spellDmg[name][spellname.."DmgM"]
			local dmgtxtp = spellDmg[name][spellname.."DmgP"]
			local dmgtxtt = spellDmg[name][spellname.."DmgT"]
			local dmgm = dmgtxtm and load("return "..dmgtxtm)() or 0
			if dmgm > 0 then dmgm = SDLplayer:CalcMagicDamage(SDLtarget,dmgm) end
			local dmgp = dmgtxtp and load("return "..dmgtxtp)() or 0
			if dmgp > 0 then dmgp = SDLplayer:CalcDamage(SDLtarget,dmgp) end
			local dmgt = dmgtxtt and load("return "..dmgtxtt)() or 0
			TrueDmg = dmgm+dmgp+dmgt
			return TrueDmg
		elseif (spellname == "AD") then
			TrueDmg = SDLplayer:CalcDamage(SDLtarget,ad)
			return TrueDmg
		elseif (spellname == "IGNITE") then
			TrueDmg = 50+lvl*20
			return TrueDmg
		elseif (spellname == "DFG") then
			TrueDmg = SDLplayer:CalcMagicDamage(SDLtarget,math.max((25+0.04*ap)*thp/100,200))
			return TrueDmg
		elseif (spellname == "HXG") then
			TrueDmg = SDLplayer:CalcMagicDamage(SDLtarget,300)
			return TrueDmg
		elseif (spellname == "BWC") then
			TrueDmg = SDLplayer:CalcMagicDamage(SDLtarget,150)
			return TrueDmg
		elseif (spellname == "ECALLING") then
			TrueDmg = SDLplayer:CalcMagicDamage(SDLtarget,32) --over 8 sec
			return TrueDmg
		elseif (spellname == "ISPARK") then
			TrueDmg = SDLplayer:CalcMagicDamage(SDLtarget,125)
			return TrueDmg
		elseif (spellname == "KITAES") then
			TrueDmg = SDLplayer:CalcMagicDamage(SDLtarget,tmhp*0.025)
			return TrueDmg
		elseif (spellname == "MADREDS") then
			TrueDmg = SDLplayer:CalcMagicDamage(SDLtarget,tmhp*0.04)
			return TrueDmg
		elseif (spellname == "MALADY") then
			TrueDmg = SDLplayer:CalcMagicDamage(SDLtarget,20)
			return TrueDmg
		elseif (spellname == "WITSEND") then
			TrueDmg = SDLplayer:CalcMagicDamage(SDLtarget,42)
			return TrueDmg
		elseif (spellname == "LICHBANE") then
			TrueDmg = SDLplayer:CalcDamage(SDLtarget,ap)
			return TrueDmg
		else
			return (-100000000)
		end
	end

end