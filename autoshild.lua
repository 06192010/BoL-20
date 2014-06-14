--[[
Original Scripts:			SpellShields by Barasia283, MSA by http://ps-bol.com/ 

Big Fat Nidalee Edition:	v02


Changelog:					v01		-added menu control panel and integrated MSA
							v02 fixed chat issues

]]--
if myHero.charName ~= "Sivir" 
and myHero.charName ~= "Nocturne"   
and myHero.charName ~= "Urgot" 
and myHero.charName ~= "Morgana" 
and myHero.charName ~= "Lulu" 
and myHero.charName ~= "Janna"
then return end


function vars()
	version = "0.02"
	
		Shieldz = {
		["Sivir"] = _E,
		["Nocturne"] = _W,
		["Urgot"] = _W,
		["Morgana"] = _E,
		["Lulu"] = _E,
		["Janna"] = _E
	}
	
end 
function OnLoad()
	vars()
	ASEMenu()
 
	if player.charName == "Sivir" then
		spellslot = _E
		spellshieldcharexist = true
    elseif player.charName == "Nocturne" then 
		spellslot = _W
		spellshieldcharexist = true
	elseif player.charName == "Urgot" then 
		spellslot = _W
		spellshieldcharexist = true
	elseif player.charName == "Morgana" then 
		spellslot = _E
		spellshieldcharexist = true
	elseif player.charName == "Lulu" then 
		spellslot = _E
		spellshieldcharexist = true
	elseif player.charName == "Janna" then 
		spellslot = _E
		spellshieldcharexist = true
    end
end

function ASEMenu()

AutoShildExtendedMenu = scriptConfig("Autoshild Extended", "Autoshild Extended ")
AutoShildExtendedMenu:addParam("ShildMode", "Shild Mode", SCRIPT_PARAM_LIST, 2, { "All Shit", "Dangerous Only" })
AutoShildExtendedMenu:addParam("info", "not recommended vs Leona:", SCRIPT_PARAM_INFO, "")
AutoShildExtendedMenu:addParam("evadeefailstododge", "Shild if Evadeee fails", SCRIPT_PARAM_ONOFF, true)
 PrintChat("<font color='#c9d7ff'>AutoShild Extended </font><font color='#64f879'> "..version.." </font><font color='#c9d7ff'> loaded! </font>")
 
end 

function OnTick()

if spellshieldcharexist == true then
     if AutoShildExtendedMenu.ShildMode == 1 then
 
		shieldall = true

     elseif AutoShildExtendedMenu.ShildMode == 2 then

		shieldall = false

     end
end

if AutoShildExtendedMenu.evadeefailstododge then
	if _G.Evadeee_impossibleToEvade and myHero:CanUseSpell(Shieldz[myHero.charName]) == READY then
		CastSpell(Shieldz[myHero.charName])
	end
end
	
end 

function OnProcessSpell(object,spell)
local P1 = spell.startPos
local P2 = spell.endPos
local spellName = spell.name
if spellshieldcharexist == true then	
	if object~=nil and object.team ~= player.team and player:CanUseSpell(spellslot) == READY then
		if shieldall~=nil and spellName~=nil then
			shieldflag = shieldCheck(shieldall,object,spellName,P1.x,P1.z,P2.x,P2.z)  --function returns true if skill needs to be shielded
		end
		if shieldflag==true then
			CastSpell(spellslot)
		end
	end
	--the following lines of code were used to help me find the spellnames and the average distances of the targetted spell to player
			--[[if string.find(object.name,"Minion_") == nil then
			PrintChat("Hero:'"..object.charName.."' |spellName:'"..spellName.."'  |x2:'"..P2.x.."'  |y2:'"..P2.y.."'  |z2:'"..P2.z.."'")
			PrintChat("player:'"..player.charName.."'  |x:'"..P1.x.."'  |y:'"..P1.y.."'  |z:'"..P1.z.."'")
			PrintChat("distance:'"..math.floor(math.sqrt((P2.x-P1.x)^2 + (P2.z-P1.z)^2)).."'")
			end]]
end
end

player = GetMyHero()
spellshieldcharexist = false
shieldall = true
shieldArray = {  	{name= "deathfiregrasp", range=100, flag=true}, 
					{name= "bilgewatercutlass", range=100, flag=true},
					{name= "HextechGunblade", range=100, flag=true},
					{name= "AhriTumble", range=800, flag=true,objectflag=true},
					{name= "AhriFoxFire", range=800, flag=true,objectflag=true},
					{name= "AkaliMota", range=80, flag =true},
					{name= "AkaliShadowSwipe", range=325, flag=true},
					{name= "AkaliShadowDance", range=150, flag=true},
					{name= "Pulverize", range=365, flag=false,objectflag=true},
					{name= "Headbutt", range=120, flag=true},
					{name= "Tantrum", range=200, flag=true,objectflag=true},
					{name= "CurseoftheSadMummy", range=600, flag=false,objectflag=true},
					{name= "Frostbite", range=60, flag=true},
					{name= "Disintegrate", range=120, flag=true},
					{name= "Incinerate", range=280, flag=true},
					{name= "InfernalGuardian", range=200, flag=false},
					{name= "Volley", range=400, flag=true}, -- Ashe W
					{name= "PowerFistAttack", range=80, flag=true},
					{name= "StaticField", range=600, flag=false,objectflag=true},
					{name= "BrandFissure", range=255, flag=true},
					{name= "BrandConflagration", range=200, flag=true},
					{name= "BrandWildfire", range=150, flag=true},
					{name= "CassiopeiaNoxiousBlast", range=100, flag=true},
					{name= "CassiopeiaTwinFang", range=100, flag=true},
					{name= "CassiopeiaPetrifyingGaze", range=300, flag=false},
					--{name= "Rupture", range=240, flag=false}, out cause evadeee do it already
					{name= "FeralScream", range=200, flag=true},
					{name= "Feast", range=80, flag=false},
					{name= "PhosphorusBomb", range=240, flag=true},
					--{name= "HateSpike, range=270, flag=true},
					{name= "Ravage", range=80, flag=true},
					{name= "Terrify", range=80, flag=false}, -- Fiddle Q
					--{name= "DrainChannel",range=80, flag=true},
					{name= "FiddlesticksDarkWind", range=80, flag=true},
					{name= "FioraQ", range=100, flag=true},
					{name= "FioraDance", range=100, flag=true},
					{name= "FioraDanceStrike", range=300, flag=true},
					{name= "FizzPiercingStrike", range=100,flag=true},
					{name= "GalioResoluteSmite", range=200, flag=true},
					{name= "GalioIdolOfDurand", range=620, flag=false,objectflag=true}, --different
					{name= "Parley", range=150, flag=true},
					{name= "GarenSlash2", range=150, flag=false},
					{name= "GarenJustice", range=150, flag=false},
					{name= "GragasExplosiveCast", range=400, flag=false},
					--{name= "GragasBarrelRollMissile", range=400,flag=true},
					{name= "HextechMicroRockets", range=1000,range2=400, flag=true,objectflag=true}, --different
					--[[{name= "HecarimRapidSlash", range=365, flag=false,objectflag=true},
					{name= "hecarimrampattack", range=80, flag=false},
					{name= "HecarimUlt", range=250, flag=true},]]
					{name= "IreliaGatotsu", range=100, flag=true},
					{name= "IreliaEquilibriumStrike", range=100,flag=false},
					{name= "SowTheWind",range=100,flag=false},
					{name= "ReapTheWhirlwind",range=725,flag=false,objectflag=true}, --different
					{name= "JaxLeapStrike", range=100, flag=true},
					{name= "JaxCounterStrike", range=325, flag=false,objectflag=true}, --different
					{name= "NullLance", range=100, flag=false},
					{name= "ForcePulse", range=300, flag=true},
					{name= "RiftWalk", range=150,flag=true},
					--{name= "ShadowStep", range=80, flag=true},
					{name= "BouncingBlades", range=80, flag=true},
					{name= "JudicatorReckoning", range=100, flag=true},
					{name= "KogMawCausticSpittle", range=80, flag=true},
					--{name= "KogMawLivingArtillery",range=200,flag=true},
					{name= "LeblancChaosOrb", range=100, flag=false},
					{name= "LeblancSlide", range=250, flag=true},
					{name= "leblancchaosorbm", range=100, flag=false},
					{name= "leblancslidem",range=250,flag=true},
					--{name= "blindmonkqtwo",range=80,flag=true},
					{name= "BlindMonkEOne",range=450,flag=true,objectflag=true}, --different
					{name= "blindmonketwo",range=450,flag=true,objectflag=true}, --different
					{name= "BlindMonkRKick",range=80,flag=false},
					{name= "LeonaShieldOfDaybreakAttack",range=80,flag=false},
					{name= "LeonaSolarFlare",range=700,flag=false},
					{name= "LuluWTwo",range=80,flag=false},
					{name= "LuluE", range=80,flag=false},
					{name= "SeismicShard",range=80,flag=false},
					{name= "Landslide",range=400,flag=true,objectflag=true},
					{name= "UFSlash",range=400,flag=false},
					{name= "AlZaharCalloftheVoid",range=150,flag=true},
					{name= "AlZaharMaleficVisions",range=80,flag=true},
					{name= "AlZaharNetherGrasp",range=80,flag=false},
					{name= "MaokaiUnstableGrowth",range=100,flag=false},
					{name= "AlphaStrike",range=200,flag=false},
					{name= "MissFortuneRicochetShot",range=200,flag=true},
					{name= "MordekaiserSyphonOfDestruction",range=250,flag=true},
					{name= "MordekaiserChildrenOfTheGrave",range=80,flag=false},
					{name= "SoulShackles",range=580,flag=false,objectflag=true}, --different
					{name= "Wither",range=100,flag=false},
					{name= "Swipe",range=300,flag=true,objectflag=true},
					{name= "NidaleeTakedownAttack",range=100,flag=false},
					--{name= "NocturneUnspeakableHorror",range=100,flag=false},
					--{name= "NocturneParanoia",range=2000,flag=false},
					--{name= "NocturneParanoia2",range=100,flag=false},
					{name= "IceBlast",range=100,flag=false},
					{name= "OlafRecklessStrike",range=100,flag=true},
					{name= "Pantheon_Throw",range=100,flag=true},
					{name= "Pantheon_LeapBash",range=100,flag=false},
					{name= "PoppyHeroicCharge",range=100,flag=false},
					--{name= "PoppyDevastatingBlow",range=100,flag=false},
					{name= "PoppyDiplomaticImmunity",range=100,flag=false},
					{name= "PuncturingTaunt",range=80,flag=false},
					--{name= "RivenMartyr",range=300,flag=false},
					{name= "rivenizunablade",range=300,flag=false},
					{name= "Overload",range=100,flag=true},
					{name= "RunePrison",range=100,flag=false},
					{name= "SpellFlux",range=100,flag=true},
					{name= "TwoShivPoison",range=100,flag=true},
					{name= "ShenVorpalStar",range=100,flag=true},
					{name= "Fling",range=100,flag=false},
					{name= "CrypticGaze",range=100,flag=false},
					--{name="deathscaress",range=550,flag=true},
					--{name= "SkarnerVirulentSlash",range=350,flag=false}
					{name= "SkarnerImpale",range=100,flag=false},
					{name= "SonaHymnofValor",range=700,flag=true,objectflag=true}, --different
					--{name="sonahymnofvalorattackupgrade",range=100,flag=false},
					{name= "sonaariaofperseveranceupgrade",range=100,flag=false},
					{name= "sonasongofdiscordattackupgrade",range=100,flag=false},
					--{name= "Starcall",range=675,flag=true,objectflag=true}, --different
					--{name= "Infuse",range=100,flag=false}, 
					--{name= "SwainBeam",range=100,flag=true},
					{name= "SwainShadowGrasp",range=250,flag=false},
					{name= "SwainTorment",range=100,flag=true},
					{name= "Shatter",range=400,flag=true,objectflag=true},--different
					{name= "Dazzle", range=100, flag=false},
					--{name= "TaricHammerSmash",range=400,flag=false,objectflag=true}, --different
					{name= "TalonNoxianDiplomacyAttack", range=100,flag=false},
					--{name=TalonCutthroat",range=100,flag=false},
					{name= "TalonRake",range=260,flag=false},
					{name= "BlindingDart",range=100,flag=false},
					{name= "RocketJump",range=300,flag=true},
					{name= "DetonatingShot",range=80,flag=true},
					{name= "BusterShot",range=200,flag=false},
					--{name= "TrundleQ",range=90,flag=true},
					{name= "TrundlePain",range=90,flag=false},
					{name= "MockingShout",range=795,flag=false,objectflag=true}, --different  tryndamere w xD
					{name= "bluecardpreattack",range=90,flag=true},
					{name= "redcardpreattack",range=90,flag=false},
					{name= "goldcardpreattack",range=90,flag=false},
					{name= "DebilitatingPoison",range=1200,flag=false,objectflag=true}, --different
					{name= "UrgotPlasmaGrenade",range=240,flag=false},
					{name= "UrgotHeatseekingHomeMissile",range=90,flag=true},
					{name= "VayneCondemn", range=90,flag=false},
					{name= "VeigarBalefulStrike", range=90,flag=true},
					{name= "VeigarPrimordialBurst",range=90,flag=false},
					{name= "VladimirTransfusion", range=90,flag=true},
					--{name= "VladimirHemoplague",range=350,flag=false},
					{name= "VolibearQAttack",range=90,flag=false},
					{name= "VolibearW",range=90,flag=true},
					--{name="VolibearE",range=425,flag=true,objectflag=true}, --different
					{name= "HungeringStrike",range=100,flag=true}, -- warwick q
				--	{name="InfiniteDuress",range=700,flag=false}, -- warwick ult broken
					{name= "MonkeyKingQAttack",range=100,flag=true},
					{name= "MonkeyKingNimbus",range=300,flag=true},
					{name= "xerathmagechains",range=100,flag=false},
					{name= "XerathArcaneBarrage",range=200,flag=true},
					{name= "XenZhaoSweep",range=100,flag=true},
					{name= "XenZhaoThrust3",range=100,flag=false},
					{name= "XenZhaoParry", range=375,flag=false,objectflag=true},
					{name= "TimeBomb", range=100,flag=false},
					--{name="TimeWarp",range=100,flag=false},
					{name= "RenektonExecute", range=100,flag=true},
					--{name= "RenektonCleave",range=450,flag=false,objectflag=true},
					{name= "ViktorPowerTransfer",range=100,flag=false},
					{name= "SejuaniArcticAssault",range=100,flag=false},
					{name= "SejuaniGlacialPrisonStart",range=150,flag=true},
					{name= "GravesClusterShot",range=360,flag=false},
					{name= "GravesChargeShot",range=150,flag=true},
					{name= "DariusExecute",range=100,flag=true},
					{name= "YasuoSteelTempest",range=100,flag=true},
					{name= "LuxFinalSpark",range=100,flag=true},
					{name= "ViAssaultandBattery",range=100,flag=true},
					{name= "SonaCrescendo",range=100,flag=true},
					
}

function shieldCheck(shieldall,object,spellName,x1,z1,x2,z2)
	local shieldflag=false	
	local dis=nil
	local x=player.x
	local z=player.z
	
	for i=1, #shieldArray, 1 do   --#shieldarray is length of array
				
		if spellName==shieldArray[i].name then
			if shieldall==true or (shieldall==false and shieldArray[i].flag==false) then
				if shieldArray[i].objectflag==true then
					dis=math.floor(math.sqrt((object.x-x)^2 + (object.z-z)^2))	
				else
					dis=math.floor(math.sqrt((x2-x)^2 + (z2-z)^2))
				end
				if spellName== "HextechMicroRockets" then
					if dis<shieldArray[i].range and dis>shieldArray[i].range2 then
						shieldflag=true
					else
						shieldflag=false or shieldflag --if shieldflag is ever made true, it will stay true.
					end
				else
					if dis<shieldArray[i].range then
						shieldflag=true
					else
						shieldflag=false or shieldflag  --if shieldflag is ever made true, it will stay true.
					end		
				end
			end
		end
	end
	return shieldflag --returns true if skill needs to be shielded
end
