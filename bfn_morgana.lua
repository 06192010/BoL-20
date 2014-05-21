local version = "0.3"
local TESTVERSION = false
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL/master/bfn_morgana.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."bfn_morgana.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>BFN morgana:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL/master/versions/bfn_morgana.version")
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

if myHero.charName ~= "Morgana" then return end


local function getHitBoxRadius(target)
        return GetDistance(target, target.minBBox)
end

local QREADY = false
local WREADY = false
local EREADY = false
local RREADY = false
-- delay 233 speed 1200
local QRange, QSpeed, QDelay, QWidth = 1300, 1200, 0.240, 80 -- morgana
local WRange, WSpeed, WDelay, WWidth, WRadius = 900, 3.0, 280, 105, 175	-- morgana
local RRange, RRangeCut = 625, 585 --morgana
local ERange = 725
local QRangeCut = 1200


function OnLoad()
    require "Prodiction"
    require "Collision"
	QCol = Collision(QRange, QSpeed, QDelay, QWidth)
    Prod = ProdictManager.GetInstance()
									-- range, speed, delay, width
    ProdQ = Prod:AddProdictionObject(_Q, QRange, QSpeed, QDelay, QWidth) 
    qPos = nil	

	-- interrupter start
	enemyHeroes = nil
	ToInterrupt = {}
	InterruptList = {
		{ charName = "Caitlyn", spellName = "CaitlynAceintheHole"},
		{ charName = "FiddleSticks", spellName = "Crowstorm"},
--		{ charName = "FiddleSticks", spellName = "DrainChannel"},
		{ charName = "Galio", spellName = "GalioIdolOfDurand"},
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
	
	
    --Menu
    MorganaMenu = scriptConfig("BFN Morgana Helper", "Morgana Helper")
	
    MorganaMenu:addParam("Combo","Cast Q Self", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    MorganaMenu:addParam("Combo","Auto Spam Q ON/OFF", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("Y"))
	MorganaMenu:addParam("interrupter","Interrupter", SCRIPT_PARAM_ONOFF, true)
	MorganaMenu:addParam("interrupterdebug","Interrupter Debug", SCRIPT_PARAM_ONOFF, true)
	
	MorganaMenu:addParam("info", "~=[ Ult Settings ]=~", SCRIPT_PARAM_INFO, "")	
	MorganaMenu:addParam("useult","Use Auto Ult", SCRIPT_PARAM_ONOFF, true)
	MorganaMenu:addParam("ultenemys", "Auto Ult if X enemys in range", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
	
	MorganaMenu:addParam("info", "~=[ USE CALLBACKS ]=~", SCRIPT_PARAM_INFO, "")
    MorganaMenu:addParam("AfterDash","AfterDash", SCRIPT_PARAM_ONOFF, true)
    MorganaMenu:addParam("OnDash","OnDash", SCRIPT_PARAM_ONOFF, false)
    MorganaMenu:addParam("AfterImmobile","AfterImmobile", SCRIPT_PARAM_ONOFF, true)
    MorganaMenu:addParam("OnImmobile","OnImmobile", SCRIPT_PARAM_ONOFF, true)

	
	MorganaMenu:addParam("info", "~=[ DRAWS ]=~", SCRIPT_PARAM_INFO, "")
	MorganaMenu:addParam("showQrange", "Show Q Range", SCRIPT_PARAM_ONOFF, false)
	MorganaMenu:addParam("showQcollision", "Show Q Collision", SCRIPT_PARAM_ONOFF, true)
	MorganaMenu:addParam("showWrange", "Show W Range", SCRIPT_PARAM_ONOFF, false)
	MorganaMenu:addParam("showErange", "Show E Range", SCRIPT_PARAM_ONOFF, false)
	MorganaMenu:addParam("showRrange", "Show R Range", SCRIPT_PARAM_ONOFF, false)

    -- Vars
    ts = TargetSelector(TARGET_LESS_CAST, 1400, true)
    
     for i = 1, heroManager.iCount do
           local hero = heroManager:GetHero(i)
           if hero.team ~= myHero.team then
              ProdQ:GetPredictionAfterDash(hero, AfterDashFunc)
              ProdQ:GetPredictionOnDash(hero, OnDashFunc)
              ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileFunc)	  
              ProdQ:GetPredictionOnImmobile(hero, OnImmobileFunc)
           end
       end
           PrintChat("<font color='#c9d7ff'> BIG FAT NIDALEE Morgana Helper </font><font color='#64f879'> v. "..version.." </font><font color='#c9d7ff'> loaded! </font>")
end

function OnTick()
    ts:update()
    Target = ts.target
		
		QREADY = (myHero:CanUseSpell(_Q) == READY)
		WREADY = (myHero:CanUseSpell(_W) == READY)
		EREADY = (myHero:CanUseSpell(_E) == READY)		
		RREADY = (myHero:CanUseSpell(_R) == READY)
		
		UltEnemys()
    if ValidTarget(Target) then
        ProdQ:GetPredictionCallBack(Target, GetQPos)
    else
        qPos = nil

    end
		

    if MorganaMenu.Combo then
        if ValidTarget(Target) then
                    ProdQ:GetPredictionCallBack(Target, CastQ)

        end
    end
    
    

    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        if hero.team ~= myHero.team then
		 
			
            if MorganaMenu.AfterDash then
                ProdQ:GetPredictionAfterDash(hero, AfterDashFunc)
            else
                ProdQ:GetPredictionAfterDash(hero, AfterDashFunc, false)
            end	
			
            if MorganaMenu.OnDash then
                ProdQ:GetPredictionOnDash(hero, OnDashFunc)
            else
                ProdQ:GetPredictionOnDash(hero, OnDashFunc, false)
            end
            
            if MorganaMenu.AfterImmobile then
                ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileFunc)
            else
                ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileFunc, false)
            end
            
            
            if MorganaMenu.OnImmobile then
                ProdQ:GetPredictionOnImmobile(hero, OnImmobileFunc)
            else
                ProdQ:GetPredictionOnImmobile(hero, OnImmobileFunc, false)
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
	if #ToInterrupt > 0 and MorganaMenu.interrupter and QREADY then
		for _, ability in pairs(ToInterrupt) do
			if spell.name == ability and unit.team ~= myHero.team then
			

             
if (QREADY) and (GetDistance(unit) < QRangeCut) then    
	   local coll = Collision(QRange, QSpeed, QDelay, QWidth)
            if not coll:GetMinionCollision(unit, myHero) then
                CastSpell(_Q, unit.x, unit.z)
				if MorganaMenu.interrupterdebug then print("Tried to interrupt " .. spell.name) end
            end
   
        end
			end
		end
	end
end

				
-- interrupter end
function UltEnemys()
		if RREADY and MorganaMenu.useult then
		if CountEnemyHeroInRange(RRangeCut) >= MorganaMenu.ultenemys then
			CastSpell(_R)
		end
	end
end 
function GetQPos(unit, pos)
        qPos = pos
end

function CastQ(unit,pos)
    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRangeCut) then    
	   local coll = Collision(QRange, QSpeed, QDelay, QWidth)
            if not coll:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end
end

function CastW(unit,pos)
    if (WREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < WRange) then    
                CastSpell(_W, pos.x, pos.z)
    end
end


function OnDashFunc(unit, pos)

    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRangeCut) then
	local coll = Collision(QRange, QSpeed, QDelay, QWidth)
            if not coll:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end

end
function AfterDashFunc(unit, pos)

    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRangeCut) then
	local coll = Collision(QRange, QSpeed, QDelay, QWidth)
            if not coll:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end

end

function AfterImmobileFunc(unit, pos)

    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRangeCut) then
        local coll = Collision(QRange, QSpeed, QDelay, QWidth)
            if not coll:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end
end

function OnImmobileFunc(unit, pos)

    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRangeCut) then
        local coll = Collision(QRange, QSpeed, QDelay, QWidth)
            if not coll:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end
	
	if (WREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < WRange) then    
                CastSpell(_W, unit.x, unit.z)
    end
end


function OnDraw()

	if Target and MorganaMenu.showQcollision and not myHero.dead then
	QCol:DrawCollision(myHero, Target)
	end	
	
	if MorganaMenu.showQrange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, QRangeCut, 0xb9c3ed)
	end	
	
	if MorganaMenu.showWrange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0x98a2cb)
	end	
	
	if MorganaMenu.showErange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0x747ea4)
	end	
	
	if MorganaMenu.showRrange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, RRangeCut, 0xFFFFFF)
	end
		   

end
