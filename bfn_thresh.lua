if myHero.charName ~= "Thresh" then return end

local version = "0.3"
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


local function getHitBoxRadius(target)
        return GetDistance(target, target.minBBox)
end

local QREADY = false
local WREADY = false
local EREADY = false
local RREADY = false
-- 1075 1200, 0.500, 70
local QRange, QSpeed, QDelay, QWidth, QRangeCut = 1075, 1900, 0.500, 80, 1000
local WRange = 950
--local ERange, ESpeed, EDelay, EWidth = 500, 1100, 0.250, 180
local ERange, ESpeed, EDelay, EWidth, ERangeCut = 500, 500, 0.250, 180, 490
local RRange = 390




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
	
 --   ThreshMenu:addParam("fight","combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    ThreshMenu:addParam("Combo","Throw Q", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Y"))
	ThreshMenu:addParam("interrupter","Interrupter", SCRIPT_PARAM_ONOFF, true)
	ThreshMenu:addParam("interrupterdebug","Interrupter Debug", SCRIPT_PARAM_ONOFF, true)
	ThreshMenu:addParam("packets","Use Packets", SCRIPT_PARAM_ONOFF, true)
	ThreshMenu:addParam("debugmode","Debug Mode", SCRIPT_PARAM_ONOFF, false)
	
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
	ThreshMenu:addParam("showQcollision", "Show Q Collision", SCRIPT_PARAM_ONOFF, true)
	ThreshMenu:addParam("showWrange", "Show W Range", SCRIPT_PARAM_ONOFF, false)
	ThreshMenu:addParam("showErange", "Show E Range", SCRIPT_PARAM_ONOFF, true)
	ThreshMenu:addParam("showRrange", "Show R Range", SCRIPT_PARAM_ONOFF, false)

    -- Vars
    ts = TargetSelector(TARGET_LESS_CAST, 1400, true)
    
	
	-- interrupter 2.0 start

InterruptSpells = {

	["AhriTumble"]					= true, -- Ahri R
	["AhriSeduce"]					= true, -- Ahri E
	["AkaliShadowDance"]			= true, -- Akali R
	["BandageToss"]					= true, -- Amumu Q
	["BraumW"]						= true, -- Braum w
	["BraumRWrapper"]				= true, -- Braum R
	["RocketGrab"]					= true, -- Blitz Q
	["DianaTeleport"]				= true, -- Diana R
	["FioraQ"]						= true, -- Fiora Q
	["FizzPiercingStrike"]			= true, -- Fizz Q
	["DrainChannel"]				= true, -- Fiddle W
	["GragasE"]						= true, -- Gragas E
	["IreliaGatotsu"]				= true, -- Irelia Q
	["JarvanIVDemacianStandard"]	= true, -- J4 Q
	["JaxLeapStrike"]				= true, -- Jax Q
	["KhazixE"]						= true, -- Khazix E
	["LeblancSlide"]				= true, -- Leblanc W
	["blindmonkqtwo"]				= true, -- Lee Sin Q2
	["NautilusAnchorDrag"]			= true, -- Nautilus Q
	["QuinnE"]						= true, -- Quinn E
	["RenektonSliceAndDice"]		= true, -- Renek E
	["SejuaniArcticAssault"]		= true, -- Sejuani Q
	["Deceive"]						= true, -- Shaco Q
	["ShyvanaTransformCast"]		= true, -- Shyvana R
	["SkarnerImpale"]				= true, -- Skarner R
	["slashCast"]					= true, -- Trynda W
	["ViQ"]							= true, -- Vi Q
	["XerathArcanopulseChargeUp"]	= true, -- Xerath Q
	["XenZhaoSweep"]				= true, -- Xin E
	["YasuoDashWrapper"]			= true, -- Yasuo E
	["ZacE"]						= true, -- Zac E
	["LeonaZenithBlade"]			= true, -- Leona E
	["Pantheon_GrandSkyfall_Jump"]	= true, -- Panth R
	["ShenStandUnited"]				= true, -- Shen R
	["VarusQ"]						= true, -- Varus Q
	["HideInShadows"]				= true, -- Twitch Q
	["PantheonW"]					= true, -- Pantheon W
	["CarpetBomb"]					= true, -- Corki W ?
	["LucianR"]						= true, -- Lucian R
	
	
	["InfiniteDuress"]				= true, -- Warwick R
	["UrgotSwap2"]					= true, -- Urgot R
	["AbsoluteZero"]				= true, -- Nunu R
	["FallenOne"]					= true, -- Kartus R
	["KatarinaR"]					= true, -- Kata R
	["AlZaharNetherGrasp"]			= true, -- Malzahar R
	["MissFortuneBulletTime"]		= true, -- MF R
	["XerathLocusOfPower2"]			= true, -- Xerath R
	["VelkozR"]						= true, -- Velkoz R
	["GalioIdolOfDurand"]			= true, -- Galio R
	["Crowstorm"]					= true, -- Fiddle R
	["CaitlynAceintheHole"]			= true, -- Cait R
	 
		
}

--[[
InterruptSpells2 = {

	["InfiniteDuress"]				= true, -- Warwick R
	["UrgotSwap2"]					= true, -- Urgot R
	["AbsoluteZero"]				= true, -- Nunu R
	["FallenOne"]					= true, -- Kartus R
	["KatarinaR"]					= true, -- Kata R
	["AlZaharNetherGrasp"]			= true, -- Malzahar R
	["MissFortuneBulletTime"]		= true, -- MF R
	["XerathLocusOfPower2"]			= true, -- Xerath R
	["VelkozR"]						= true, -- Velkoz R
	["GalioIdolOfDurand"]			= true, -- Galio R
	["Crowstorm"]					= true, -- Fiddle R
	["CaitlynAceintheHole"]			= true, -- Cait R
	["Teleport"]					= true, -- TP not tested
	["SummonerFlash"]				= true, -- Flash
}

]]--

-- end 


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

function OnProcessSpell(unit, spell)
 if ThreshMenu.interrupter then
	if InterruptSpells[spell.name] and unit.team ~= myHero.team  then
		
		if (EREADY) and (GetDistance(unit) < ERange) then
				if ThreshMenu.packets then
                Packet("S_CAST", {spellId = _E, fromX =  unit.x, fromY =  unit.z, toX =  unit.x, toY =  unit.z}):send()
					if ThreshMenu.debugmode then
                        PrintChat("casted packets using interrupter")
					end
				else
				CastSpell(_E, unit.x, unit.z)
					if ThreshMenu.debugmode then
                        PrintChat("casted normal using interrupter")
					end
				end

				if ThreshMenu.interrupterdebug then PrintChat("I try to interrupt " .. spell.name) end

   
        end

		
	end
--[[
	if InterruptSpells2[spell.name] and unit.team ~= myHero.team  then
		
		if (EREADY) and (GetDistance(unit) < ERange) then
				if ThreshMenu.packets then
                Packet("S_CAST", {spellId = _E, fromX =  unit.x, fromY =  unit.z, toX =  unit.x, toY =  unit.z}):send()
					if ThreshMenu.debugmode then
                        PrintChat("casted packets using interrupter2")
					end
				else
				CastSpell(_E, unit.x, unit.z)
					if ThreshMenu.debugmode then
                        PrintChat("casted normal using interrupter2")
					end
				end

				if ThreshMenu.interrupterdebug then PrintChat("Tried to interrupt " .. spell.name) end
        end
		
		if not (EREADY) and (QREADY) and (GetDistance(unit) < QRangeCut) then
			local coll = Collision(QRange, QSpeed, QDelay, QWidth)
				if not coll:GetMinionCollision(unit, myHero) then
					if ThreshMenu.packets then
						Packet("S_CAST", {spellId = _Q, fromX =  unit.x, fromY =  unit.z, toX =  unit.x, toY =  unit.z}):send()
						if ThreshMenu.debugmode then
							PrintChat("casted packets using interrupter2")
						end
					else
						CastSpell(_Q, unit.x, unit.z)
						if ThreshMenu.debugmode then
							PrintChat("casted normal using interrupter2")
						end
					end
				end
			
			if ThreshMenu.interrupterdebug then PrintChat("Tried 2 interrupt with Q: " .. spell.name) end
		end
		
	end
	
]]--
end
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
		

    if ThreshMenu.Combo then
        if ValidTarget(Target) then
                    ProdQ:GetPredictionCallBack(Target, CastQ)
        end
    end
    
--[[    if ThreshMenu.fight then
        if ValidTarget(Target) then
                    ProdQ:GetPredictionCallBack(Target, fight)
        end
    end
]]--
    

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
    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRangeCut) and myHero:GetSpellData(_Q).name == "ThreshQ" then    
	   local coll = Collision(QRange, QSpeed, QDelay, QWidth)
            if not coll:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end
end
--[[
function CastQ(unit,pos)
    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRangeCut) and myHero:GetSpellData(_Q).name == "ThreshQ" then    
	   local coll = Collision(QRange, QSpeed, QDelay, QWidth)
            if not coll:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end
end
]]--

function OnDashEFunc (unit, pos, spell)
 if GetDistance(pos) < ERangeCut and myHero:CanUseSpell(spell.Name) == READY then
            CastSpell(spell.Name, pos.x, pos.z)
  end
end 

function AfterDashQFunc(unit, pos, spell)

    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRangeCut) and myHero:GetSpellData(_Q).name == "ThreshQ" then
	local coll = Collision(QRange, QSpeed, QDelay, QWidth)
            if not coll:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end

end

function AfterImmobileQFunc(unit, pos, spell)

    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRangeCut) and myHero:GetSpellData(_Q).name == "ThreshQ" then
        local coll = Collision(QRange, QSpeed, QDelay, QWidth)
            if not coll:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end
end

function OnImmobileQFunc(unit, pos, spell)

    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRangeCut) and myHero:GetSpellData(_Q).name == "ThreshQ" then
        local coll = Collision(QRange, QSpeed, QDelay, QWidth)
            if not coll:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end
end

function OnDraw()
if QREADY then 
	if Target and ThreshMenu.showQcollision and not myHero.dead then
	QCol:DrawCollision(myHero, Target)
	end	
end
if QREADY then 
	if ThreshMenu.showQrange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, QRangeCut, 0xb9c3ed)
	end	
end
if WREADY then 
	if ThreshMenu.showWrange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0x98a2cb)
	end	
end
if EREADY then 
	if ThreshMenu.showErange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, ERangeCut, 0x747ea4)
	end	
end
if RREADY then 
	if ThreshMenu.showRrange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0xFFFFFF)
	end
end	   

end

