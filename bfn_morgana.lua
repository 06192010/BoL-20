local version = "0.2"
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

local QRange, QSpeed, QDelay, QWidth = 1300, 1200, 0.250, 80 -- morgana
local WRange, WSpeed, WDelay, WWidth, WRadius = 900, 3.0, 280, 105, 175	-- morgana
local RRange = 625 --morgana
local ERange = 725


function OnLoad()
    require "Prodiction"
    require "Collision"
	QCol = Collision(QRange, QSpeed, QDelay, QWidth)
    Prod = ProdictManager.GetInstance()
									-- range, speed, delay, width
    ProdQ = Prod:AddProdictionObject(_Q, QRange, QSpeed, QDelay, QWidth) 
	ProdW = Prod:AddProdictionObject(_W, WRange, WSpeed, WDelay, WWidth)	
    qPos = nil	
    wPos = nil
    --Menu
    MorganaMenu = scriptConfig("BFN Morgana Helper", "Morgana Helper")
	
    MorganaMenu:addParam("Combo","Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	
	MorganaMenu:addParam("info", "~=[ Ult Settings ]=~", SCRIPT_PARAM_INFO, "")	
	MorganaMenu:addParam("useult","Use Auto Ult", SCRIPT_PARAM_ONOFF, true)
	MorganaMenu:addParam("ultenemys", "Auto Ult if X enemys in range", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
	
	MorganaMenu:addParam("info", "~=[ USE CALLBACKS ]=~", SCRIPT_PARAM_INFO, "")
    MorganaMenu:addParam("AfterDash","AfterDash Q", SCRIPT_PARAM_ONOFF, true)
    MorganaMenu:addParam("OnDash","OnDash Q", SCRIPT_PARAM_ONOFF, false)
    MorganaMenu:addParam("AfterImmobile","AfterImmobile Q", SCRIPT_PARAM_ONOFF, true)
    MorganaMenu:addParam("OnImmobile","OnImmobile Q", SCRIPT_PARAM_ONOFF, true)
    MorganaMenu:addParam("OnImmobileW","OnImmobile W", SCRIPT_PARAM_ONOFF, true)

	
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
              ProdQ:GetPredictionAfterDash(hero, AfterDashQFunc)
              ProdQ:GetPredictionOnDash(hero, OnDashQFunc)
              ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileQFunc)	  
              ProdQ:GetPredictionOnImmobile(hero, OnImmobileQFunc)
              ProdW:GetPredictionOnImmobile(hero, OnImmobileWFunc)
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
        wPos = nil
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
                ProdQ:GetPredictionAfterDash(hero, AfterDashQFunc)
            else
                ProdQ:GetPredictionAfterDash(hero, AfterDashQFunc, false)
            end	
			
            if MorganaMenu.OnDash then
                ProdQ:GetPredictionOnDash(hero, OnDashQFunc)
            else
                ProdQ:GetPredictionOnDash(hero, OnDashQFunc, false)
            end
            
            if MorganaMenu.AfterImmobile then
                ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileQFunc)
            else
                ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileQFunc, false)
            end
            
            
            if MorganaMenu.OnImmobile then
                ProdQ:GetPredictionOnImmobile(hero, OnImmobileQFunc)
            else
                ProdQ:GetPredictionOnImmobile(hero, OnImmobileQFunc, false)
            end
            
            if MorganaMenu.OnImmobileW then
                ProdW:GetPredictionOnImmobile(hero, OnImmobileWFunc)
            else
                ProdW:GetPredictionOnImmobile(hero, OnImmobileWFunc, false)
            end

        end
    end
	

		
    AfterDashPos = nil			
    OnDashPos = nil	
    AfterImmobilePos = nil	
    OnImmobilePos = nil	
 
end

function UltEnemys()
		if RREADY and MorganaMenu.useult then
		if CountEnemyHeroInRange(RRange) >= MorganaMenu.ultenemys then
			CastSpell(_R)
		end
	end
end 
function GetQPos(unit, pos)
        qPos = pos
end
function GetWPos(unit, pos)
        wPos = pos
end
function CastQ(unit,pos)
    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then    
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


function OnDashQFunc(unit, pos)

    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then
	local coll = Collision(QRange, QSpeed, QDelay, QWidth)
            if not coll:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end

end
function AfterDashQFunc(unit, pos)

    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then
	local coll = Collision(QRange, QSpeed, QDelay, QWidth)
            if not coll:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end

end

function AfterImmobileQFunc(unit, pos)

    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then
        local coll = Collision(QRange, QSpeed, QDelay, QWidth)
            if not coll:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end
end

function OnImmobileQFunc(unit, pos)

    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then
        local coll = Collision(QRange, QSpeed, QDelay, QWidth)
            if not coll:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end
end
function OnImmobileWFunc(unit, pos)

    if (WREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < WRange) then
                CastSpell(_W, pos.x, pos.z)
    end
end

function OnDraw()

	if Target and MorganaMenu.showQcollision and not myHero.dead then
	QCol:DrawCollision(myHero, Target)
	end	
	
	if MorganaMenu.showQrange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0xb9c3ed)
	end	
	
	if MorganaMenu.showWrange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0x98a2cb)
	end	
	
	if MorganaMenu.showErange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0x747ea4)
	end	
	
	if MorganaMenu.showRrange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0xFFFFFF)
	end
		   

end
