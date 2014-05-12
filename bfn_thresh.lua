local version = "0.1"
local TESTVERSION = false
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL/master/bfn_thresh.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."bfn_thresh.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>BFN Thresh:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL/master/versions/bfn_thresh.version")
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


if myHero.charName ~= "Thresh" then return end


local function getHitBoxRadius(target)
        return GetDistance(target, target.minBBox)
end

local QREADY = false
local RREADY = false

local QRange, QSpeed, QDelay, QWidth = 1075, 1200, 0.500, 70
local WRange = 950
local ERange, ESpeed, EDelay, EWidth = 500, 1100, 0.250, 180
local RRange = 400



function OnLoad()
    require "Prodiction"
    require "Collision"
	QCol = Collision(QRange, QSpeed, QDelay, QWidth)
    Prod = ProdictManager.GetInstance()
									-- range, speed, delay, width
    ProdQ = Prod:AddProdictionObject(_Q, QRange, QSpeed, QDelay, QWidth) 
	posE = Prod:AddProdictionObject(_E, ERange, ESpeed, EDelay, EWidth)	
    qPos = nil
    --Menu
    ThreshMenu = scriptConfig("BFN Thresh Helper", "Thresh Helper")
	
    ThreshMenu:addParam("Combo","Throw Q", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Y"))
	
	ThreshMenu:addParam("info", "~=[ Ult Settings ]=~", SCRIPT_PARAM_INFO, "")	
	ThreshMenu:addParam("useult","Use Auto Ult", SCRIPT_PARAM_ONOFF, true)
	ThreshMenu:addParam("ultenemys", "Auto Ult if X enemys in range", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
	
	ThreshMenu:addParam("info", "~=[ USE CALLBACKS ]=~", SCRIPT_PARAM_INFO, "")
    ThreshMenu:addParam("AfterDash","AfterDash Q", SCRIPT_PARAM_ONOFF, true)
    ThreshMenu:addParam("AfterImmobile","AfterImmobile Q", SCRIPT_PARAM_ONOFF, true)
    ThreshMenu:addParam("OnImmobile","OnImmobile Q", SCRIPT_PARAM_ONOFF, true)
    ThreshMenu:addParam("OnDashE","OnDash E", SCRIPT_PARAM_ONOFF, true)
	
	ThreshMenu:addParam("info", "~=[ DRAWS ]=~", SCRIPT_PARAM_INFO, "")
	ThreshMenu:addParam("showQrange", "Show Q Range", SCRIPT_PARAM_ONOFF, false)
	ThreshMenu:addParam("showQcollision", "Show Q Collision", SCRIPT_PARAM_ONOFF, false)
	ThreshMenu:addParam("showWrange", "Show W Range", SCRIPT_PARAM_ONOFF, false)
	ThreshMenu:addParam("showErange", "Show E Range", SCRIPT_PARAM_ONOFF, false)
	ThreshMenu:addParam("showRrange", "Show R Range", SCRIPT_PARAM_ONOFF, false)

    -- Vars
    ts = TargetSelector(TARGET_LESS_CAST, 1400, true)
    
     for i = 1, heroManager.iCount do
           local hero = heroManager:GetHero(i)
           if hero.team ~= myHero.team then
              ProdQ:GetPredictionAfterDash(hero, AfterDashQFunc)
              ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileQFunc)
              ProdQ:GetPredictionOnImmobile(hero, OnImmobileQFunc)
			  posE:GetPredictionOnDash(hero, OnDashEFunc)
           end
       end
           PrintChat("<font color='#c9d7ff'> BIG FAT NIDALEE Thresh Helper </font><font color='#64f879'> "..version.." </font><font color='#c9d7ff'> loaded! </font>")
end

function OnTick()
    ts:update()
    Target = ts.target
		
		QREADY = (myHero:CanUseSpell(_Q) == READY)		
		RREADY = (myHero:CanUseSpell(_R) == READY)
		
		UltEnemys()
    if ValidTarget(Target) then
        ProdQ:GetPredictionCallBack(Target, GetQPos)
    else
        qPos = nil
    end
		

    if ThreshMenu.Combo then
        if ValidTarget(Target) then
                    ProdQ:GetPredictionCallBack(Target, CastQ)
        end
    end
    
    

    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        if hero.team ~= myHero.team then
		
        
            if ThreshMenu.OnDashE then
                posE:GetPredictionOnDash(hero, OnDashEFunc)
            else
                posE:GetPredictionOnDash(hero, OnDashEFunc, false)
            end    
			
            if ThreshMenu.AfterDash then
                ProdQ:GetPredictionAfterDash(hero, AfterDashQFunc)
            else
                ProdQ:GetPredictionAfterDash(hero, AfterDashQFunc, false)
            end
            
            if ThreshMenu.AfterImmobile then
                ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileQFunc)
            else
                ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileQFunc, false)
            end
            
            
            if ThreshMenu.OnImmobile then
                ProdQ:GetPredictionOnImmobile(hero, OnImmobileQFunc)
            else
                ProdQ:GetPredictionOnImmobile(hero, OnImmobileQFunc, false)
            end

        end
    end
	

	OnDashEPos = nil	
    AfterDashPos = nil	
    AfterImmobilePos = nil	
    OnImmobilePos = nil	
 
end

function UltEnemys()
		if RREADY and ThreshMenu.useult then
		if CountEnemyHeroInRange(RRange) >= ThreshMenu.ultenemys then
			CastSpell(_R)
		end
	end
end 
function GetQPos(unit, pos)
        qPos = pos
end
function CastQ(unit,pos)
    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) and myHero:GetSpellData(_Q).name == "ThreshQ" then    
	   local coll = Collision(QRange, QSpeed, QDelay, QWidth)
            if not coll:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end
end



function OnDashEFunc (unit, pos, spell)
 if GetDistance(pos) < spell.range and myHero:CanUseSpell(spell.Name) == READY then
            CastSpell(spell.Name, pos.x, pos.z)
  end
end 

function AfterDashQFunc(unit, pos, spell)

    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) and myHero:GetSpellData(_Q).name == "ThreshQ" then
	local coll = Collision(QRange, QSpeed, QDelay, QWidth)
            if not coll:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end

end

function AfterImmobileQFunc(unit, pos, spell)

    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) and myHero:GetSpellData(_Q).name == "ThreshQ" then
        local coll = Collision(QRange, QSpeed, QDelay, QWidth)
            if not coll:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end
end

function OnImmobileQFunc(unit, pos, spell)

    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) and myHero:GetSpellData(_Q).name == "ThreshQ" then
        local coll = Collision(QRange, QSpeed, QDelay, QWidth)
            if not coll:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end
end

function OnDraw()

	if Target and ThreshMenu.showQcollision and not myHero.dead then
	QCol:DrawCollision(myHero, Target)
	end	
	
	if ThreshMenu.showQrange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0xb9c3ed)
	end	
	
	if ThreshMenu.showWrange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0x98a2cb)
	end	
	
	if ThreshMenu.showErange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0x747ea4)
	end	
	
	if ThreshMenu.showRrange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0xFFFFFF)
	end
		   

end
