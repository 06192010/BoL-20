if myHero.charName ~= "Janna" then return end

local version = "0.02"
local TESTVERSION = false
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL/master/bfn_janna.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."bfn_janna.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>BFN Janna:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL/master/versions/bfn_janna.version")
if ServerData then
ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
if ServerVersion then
if tonumber(version) < ServerVersion then
AutoupdaterMsg("New version available"..ServerVersion)
AutoupdaterMsg("Updating, please don't press F9")
DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
else
AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
end
end
else
AutoupdaterMsg("Error downloading version info")
end
end


local QRangeMin, QSpeed, QDelay, QWidth = 1075, 980, 0, 200 
local onHowlingGale = false 


function OnLoad ()

	require "Prodiction"
	Prod = ProdictManager.GetInstance()
	ProdQmin = Prod:AddProdictionObject(_Q, QRangeMin, QSpeed, QDelay, QWidth) 

	
	-- menu
	JannaMenu = scriptConfig("Janna Helper", "Janna Helper")
	
	JannaMenu:addParam("testq","Cast Q", SCRIPT_PARAM_ONOFF, false)
	JannaMenu:addParam("debug","Debug Mode", SCRIPT_PARAM_ONOFF, false)
	JannaMenu:addParam("interrupter","Interrupter", SCRIPT_PARAM_ONOFF, true)
	JannaMenu:addParam("interrupterdebug","Interrupter Debug", SCRIPT_PARAM_ONOFF, true)
	
	JannaMenu:addParam("info", "~=[ USE CALLBACKS ]=~", SCRIPT_PARAM_INFO, "")
    JannaMenu:addParam("AfterDash","AfterDash", SCRIPT_PARAM_ONOFF, false)
    JannaMenu:addParam("OnDash","OnDash", SCRIPT_PARAM_ONOFF, false)
    JannaMenu:addParam("AfterImmobile","AfterImmobile", SCRIPT_PARAM_ONOFF, false)
    JannaMenu:addParam("OnImmobile","OnImmobile", SCRIPT_PARAM_ONOFF, false)
	
	JannaMenu:addParam("info", "~=[ DRAWS ]=~", SCRIPT_PARAM_INFO, "")
	JannaMenu:addParam("showQrange", "Show Q Range", SCRIPT_PARAM_ONOFF, true)
	
	ts = TargetSelector(TARGET_LESS_CAST, 1400, true)
	ts.name = "JannaMenu"
    JannaMenu:addTS(ts)
	
	
		-- interrupter start
	enemyHeroes = nil
	ToInterrupt = {}
	InterruptList = {
		{ charName = "Ahri", spellName = "AhriTumble"}, -- R
		{ charName = "Ahri", spellName = "AhriSeduce"}, -- E
		{ charName = "Akali", spellName = "AkaliShadowDance"}, -- R
		{ charName = "Alistar", spellName = "Headbutt"}, -- W ne o4enj
		{ charName = "Amumu", spellName = "BandageToss"}, -- Q
		{ charName = "Braum", spellName = "BraumW"}, -- W
		{ charName = "Braum", spellName = "BraumRWrapper"}, -- R
		{ charName = "Blitzcrank", spellName = "RocketGrab"}, -- Q
		{ charName = "Caitlyn", spellName = "CaitlynAceintheHole"},
		{ charName = "Diana", spellName = "DianaTeleport"}, -- R
		{ charName = "Fiora", spellName = "FioraQ"}, -- Q	
		{ charName = "Fizz", spellName = "FizzPiercingStrike"}, -- Q	
--		{ charName = "Fizz", spellName = "fizzjumptwo"}, -- E	
		{ charName = "FiddleSticks", spellName = "Crowstorm"},
		{ charName = "FiddleSticks", spellName = "DrainChannel"},
		{ charName = "Galio", spellName = "GalioIdolOfDurand"},
		{ charName = "Gragas", spellName = "GragasE"}, -- E
--		{ charName = "Graves", spellName = "GravesMove"}, -- E
--		{ charName = "Hecarim", spellName = "HecarimRamp"}, -- E
--		{ charName = "Hecarim", spellName = "HecarimUlt"}, -- R
		{ charName = "Irelia", spellName = "IreliaGatotsu"}, -- Q
		{ charName = "JarvanIV", spellName = "JarvanIVDemacianStandard"}, -- Q
		{ charName = "Jax", spellName = "JaxLeapStrike"}, -- Q
		{ charName = "Khazix", spellName = "KhazixE"}, -- E
		{ charName = "Leblanc", spellName = "LeblancSlide"}, -- W
		
		{ charName = "LeeSin", spellName = "blindmonkqtwo"}, -- Q
-- not tested yet
		{ charName = "Lux", spellName = "LuxMaliceCannon"}, -- R
		{ charName = "Malphite", spellName = "UFSlash"}, -- R
		{ charName = "Maokai", spellName = "MaokaiUnstableGrowth"}, -- W
		{ charName = "Nautilus", spellName = "NautilusAnchorDrag"}, -- Q
		{ charName = "Nocturne", spellName = "NocturneParanoia"}, -- R
		{ charName = "Quinn", spellName = "QuinnE"}, -- E
		{ charName = "Renekton", spellName = "RenektonSliceAndDice"}, -- E
		{ charName = "Rengar", spellName = "RengarNewPassive"}, -- Passive
		{ charName = "Riven", spellName = "RivenTriCleave"}, -- Q
		{ charName = "Riven", spellName = "RivenFeint "}, -- E
		{ charName = "Sejuani", spellName = "SejuaniArcticAssault "}, -- Q
		{ charName = "Shaco", spellName = "Deceive"}, -- Q
		{ charName = "Shyvana", spellName = "ShyvanaTransformCast"}, -- R
		{ charName = "Skarner", spellName = "SkarnerImpale"}, -- R
		{ charName = "Thresh", spellName = "ThreshQPullMissile"}, -- Q
		{ charName = "Tryndamere", spellName = "slashCast"}, -- E
		{ charName = "Velkoz", spellName = "VelkozR"}, -- R
		{ charName = "Vi", spellName = "ViR"}, -- R
		{ charName = "Vi", spellName = "ViQ"}, -- Q
		{ charName = "Wukong", spellName = "MonkeyKingNimbus"}, -- E
		{ charName = "Xerath", spellName = "XerathArcanopulse"}, -- Q
		{ charName = "Xerath", spellName = "XerathArcaneBarrageWrapper"}, -- R
		{ charName = "XinZhao", spellName = "XenZhaoSweep"}, -- E
		{ charName = "Yasuo", spellName = "YasuoDashWrapper"}, -- E
		{ charName = "Zac", spellName = "ZacE"}, -- E
		{ charName = "Zed", spellName = "ZedShadowDashMissile"}, -- W
		
		{ charName = "Leona", spellName = "LeonaZenithBlade"},
		{ charName = "Karthus", spellName = "FallenOne"},
		{ charName = "Katarina", spellName = "KatarinaR"},
		{ charName = "Malzahar", spellName = "AlZaharNetherGrasp"},
		{ charName = "MissFortune", spellName = "MissFortuneBulletTime"},
		{ charName = "Nunu", spellName = "AbsoluteZero"},
		{ charName = "Pantheon", spellName = "Pantheon_GrandSkyfall_Jump"},
		{ charName = "Shen", spellName = "ShenStandUnited"},
		{ charName = "Urgot", spellName = "UrgotSwap2"},
		{ charName = "Varus", spellName = "VarusQ"},
		{ charName = "Warwick", spellName = "InfiniteDuress"}
	}
	enemyHeroes = GetEnemyHeroes()
		for _, enemy in pairs(enemyHeroes) do
		for _, champ in pairs(InterruptList) do
			if enemy.charName == champ.charName then
				table.insert(ToInterrupt, champ.spellName)
			end
		end
	end
-- interrupter end


     for i = 1, heroManager.iCount do
           local hero = heroManager:GetHero(i)
           if hero.team ~= myHero.team then
              ProdQmin:GetPredictionAfterDash(hero, AfterDashFunc)
              ProdQmin:GetPredictionOnDash(hero, OnDashFunc)
              ProdQmin:GetPredictionAfterImmobile(hero, AfterImmobileFunc)	  
              ProdQmin:GetPredictionOnImmobile(hero, OnImmobileFunc)
           end
       end

	PrintChat("<font color='#c9d7ff'> BIG FAT NIDALEE Janna Helper </font><font color='#64f879'> v. "..version.." </font><font color='#c9d7ff'> loaded! </font>")

end 


function OnTick()
 if onHowlingGale == true then CastSpell(_Q)
 end
	ts:update()
	Target = ts.target
	
		QREADY = (myHero:CanUseSpell(_Q) == READY)
		WREADY = (myHero:CanUseSpell(_W) == READY)
		EREADY = (myHero:CanUseSpell(_E) == READY)
		RREADY = (myHero:CanUseSpell(_R) == READY)

	if ValidTarget(Target) then
		ProdQmin:GetPredictionCallBack(Target, GetQPos)
	else
	qPos = nil
	end
		
		if JannaMenu.testq then
		if ValidTarget(Target) then
			ProdQmin:GetPredictionCallBack(Target, CastQMin)
		end
	end		


    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        if hero.team ~= myHero.team then
		 
			
            if JannaMenu.AfterDash then
                ProdQmin:GetPredictionAfterDash(hero, AfterDashFunc)
            else
                ProdQmin:GetPredictionAfterDash(hero, AfterDashFunc, false)
            end	
			
            if JannaMenu.OnDash then
                ProdQmin:GetPredictionOnDash(hero, OnDashFunc)
            else
                ProdQmin:GetPredictionOnDash(hero, OnDashFunc, false)
            end
            
            if JannaMenu.AfterImmobile then
                ProdQmin:GetPredictionAfterImmobile(hero, AfterImmobileFunc)
            else
                ProdQmin:GetPredictionAfterImmobile(hero, AfterImmobileFunc, false)
            end
            
            
            if JannaMenu.OnImmobile then
                ProdQmin:GetPredictionOnImmobile(hero, OnImmobileFunc)
            else
                ProdQmin:GetPredictionOnImmobile(hero, OnImmobileFunc, false)
            end
            


        end
    end
	

		
    AfterDashPos = nil			
    OnDashPos = nil	
    AfterImmobilePos = nil	
    OnImmobilePos = nil	

end 

-- interrupter start
function OnProcessSpell(unit, spell)
	if #ToInterrupt > 0 and JannaMenu.interrupter and QREADY then
		for _, ability in pairs(ToInterrupt) do
			if spell.name == ability and unit.team ~= myHero.team then
			

             
if (QREADY) and (GetDistance(unit) < QRangeMin) then    

                CastSpell(_Q, unit.x, unit.z)
				
				
				if JannaMenu.interrupterdebug then PrintChat("Tried to interrupt " .. spell.name) end

   
        end
			end
		end
	end
end

				
-- interrupter end

local function getHitBoxRadius(target)
		return GetDistance(target, target.minBBox)
end

function GetQPos(unit, pos)
	qPos = pos
end


function CastQMin(unit,pos)

if QREADY and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRangeMin) then
			CastSpell(_Q, pos.x, pos.z)
			if QREADY then CastSpell(_Q) end
			if JannaMenu.debugmode then
			PrintChat("casting Q using CastQMin function!")
			end
		end
		

end 

function AfterDashFunc(unit,pos)

if QREADY and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRangeMin) then
			CastSpell(_Q, pos.x, pos.z)
			if QREADY then CastSpell(_Q) end
			
			if JannaMenu.debugmode then
			PrintChat("casting Q using AfterDashFunc function!")
			end
		end
		

end 

function OnDashFunc(unit,pos)

if QREADY and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRangeMin) then
			CastSpell(_Q, pos.x, pos.z)
			if QREADY then CastSpell(_Q) end
			if JannaMenu.debugmode then
			PrintChat("casting Q using OnDashFunc function!")
			end
		end
		

end 

function AfterImmobileFunc(unit,pos)

if QREADY and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRangeMin) then
			CastSpell(_Q, pos.x, pos.z)
			if QREADY then CastSpell(_Q) end
			if JannaMenu.debugmode then
			PrintChat("casting Q using  AfterImmobileFunc function!")
			end
		end
		

end 

function OnImmobileFunc(unit,pos)

if QREADY and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRangeMin) then
			CastSpell(_Q, pos.x, pos.z)
			if QREADY then CastSpell(_Q) end
			if JannaMenu.debugmode then
			PrintChat("casting Q using OnImmobileFunc function!")
			end
		end
		

end 


function OnDraw()

	if JannaMenu.showQrange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, QRangeMin, 0xb9c3ed)
	end	
	

end 


function OnGainBuff(unit, buff)
        if unit == nil or buff == nil then return end
        if unit.isMe and buff then
                PrintChat("GAINED: " .. buff.name)
if buff.name == "HowlingGale" then
                        PrintChat("TRUE")
                        onHowlingGale = true
                end 
end
end

function OnLoseBuff(unit, buff)
        if unit == nil or buff == nil then return end
        if unit.isMe and buff then
                --PrintChat("LOST: " .. buff.name)
                if buff.name == "HowlingGale" then
                        onHowlingGale = false
                end
        end
end 


