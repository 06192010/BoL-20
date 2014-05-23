if myHero.charName ~= "Janna" then return end

local version = "0.04"
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
	
	JannaMenu:addParam("testq","Cast Q", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("A"))
	JannaMenu:addParam("debugmode","Debug Mode", SCRIPT_PARAM_ONOFF, false)
	JannaMenu:addParam("interrupter","Interrupter", SCRIPT_PARAM_ONOFF, true)
	JannaMenu:addParam("interrupterdebug","Interrupter Debug", SCRIPT_PARAM_ONOFF, true)
	JannaMenu:addParam("packets","Use Packets", SCRIPT_PARAM_ONOFF, true)
	
	JannaMenu:addParam("info", "~=[ USE CALLBACKS ]=~", SCRIPT_PARAM_INFO, "")
    JannaMenu:addParam("AfterDash","AfterDash", SCRIPT_PARAM_ONOFF, true)
    JannaMenu:addParam("OnDash","OnDash", SCRIPT_PARAM_ONOFF, true)
    JannaMenu:addParam("AfterImmobile","AfterImmobile", SCRIPT_PARAM_ONOFF, true)
    JannaMenu:addParam("OnImmobile","OnImmobile", SCRIPT_PARAM_ONOFF, true)
	
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
		{ charName = "FiddleSticks", spellName = "Crowstorm"},
		{ charName = "FiddleSticks", spellName = "DrainChannel"},
		{ charName = "Galio", spellName = "GalioIdolOfDurand"},
		{ charName = "Gragas", spellName = "GragasE"}, -- E
		{ charName = "Irelia", spellName = "IreliaGatotsu"}, -- Q
		{ charName = "JarvanIV", spellName = "JarvanIVDemacianStandard"}, -- Q
		{ charName = "Jax", spellName = "JaxLeapStrike"}, -- Q
		{ charName = "Khazix", spellName = "KhazixE"}, -- E
		{ charName = "Leblanc", spellName = "LeblancSlide"}, -- W
		{ charName = "LeeSin", spellName = "blindmonkqtwo"}, -- Q
		{ charName = "Nautilus", spellName = "NautilusAnchorDrag"}, -- Q
		{ charName = "Quinn", spellName = "QuinnE"}, -- E
		{ charName = "Renekton", spellName = "RenektonSliceAndDice"}, -- E    nur erste e
		{ charName = "Sejuani", spellName = "SejuaniArcticAssault"}, -- Q
		{ charName = "Shaco", spellName = "Deceive"}, -- Q
		{ charName = "Shyvana", spellName = "ShyvanaTransformCast"}, -- R
		{ charName = "Skarner", spellName = "SkarnerImpale"}, -- R  ult hz otmenjaetsa li
		{ charName = "Tryndamere", spellName = "slashCast"}, -- E
		{ charName = "Velkoz", spellName = "VelkozR"}, -- R
		{ charName = "Vi", spellName = "ViQ"}, -- Q
		{ charName = "Xerath", spellName = "XerathArcanopulseChargeUp"}, -- Q
		{ charName = "Xerath", spellName = "XerathLocusOfPower2"}, -- R
		{ charName = "XinZhao", spellName = "XenZhaoSweep"}, -- E
		{ charName = "Yasuo", spellName = "YasuoDashWrapper"}, -- E
		{ charName = "Zac", spellName = "ZacE"}, -- E
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
              ProdQmin:GetPredictionAfterDash(hero, CastQMin)
              ProdQmin:GetPredictionOnDash(hero, CastQMin)
              ProdQmin:GetPredictionAfterImmobile(hero, CastQMin)	  
              ProdQmin:GetPredictionOnImmobile(hero, CastQMin)
           end
       end

	PrintChat("<font color='#c9d7ff'> BIG FAT NIDALEE Janna Helper </font><font color='#64f879'> v. "..version.." </font><font color='#c9d7ff'> loaded! </font>")

end 


function OnTick()

	if onHowlingGale == true then
				if JannaMenu.packets then
					Packet("S_CAST", {spellId = _Q}):send()
					if JannaMenu.debugmode then
                        PrintChat("casted packets nHowlingGale")
					end
				else
					CastSpell(_Q)
					if JannaMenu.debugmode then
                        PrintChat("casted normal nHowlingGale")
					end
				end
	end --interrupter
	

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
                ProdQmin:GetPredictionAfterDash(hero, CastQMin)
            else
                ProdQmin:GetPredictionAfterDash(hero, CastQMin, false)
            end	
			
            if JannaMenu.OnDash then
                ProdQmin:GetPredictionOnDash(hero, CastQMin)
            else
                ProdQmin:GetPredictionOnDash(hero, CastQMin, false)
            end
            
            if JannaMenu.AfterImmobile then
                ProdQmin:GetPredictionAfterImmobile(hero, CastQMin)
            else
                ProdQmin:GetPredictionAfterImmobile(hero, CastQMin, false)
            end
            
            
            if JannaMenu.OnImmobile then
                ProdQmin:GetPredictionOnImmobile(hero, CastQMin)
            else
                ProdQmin:GetPredictionOnImmobile(hero, CastQMin, false)
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
				if JannaMenu.packets then
                Packet("S_CAST", {spellId = _Q, fromX =  unit.x, fromY =  unit.z, toX =  unit.x, toY =  unit.z}):send()
					if JannaMenu.debugmode then
                        PrintChat("casted packets using interrupter")
					end
				else
				CastSpell(_Q, unit.x, unit.z)
					if JannaMenu.debugmode then
                        PrintChat("casted normal using interrupter")
					end
				end
				
				
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
				if JannaMenu.packets then
					Packet("S_CAST", {spellId = _Q, fromX =  pos.x, fromY =  pos.z, toX =  pos.x, toY =  pos.z}):send()
					if JannaMenu.debugmode then
                        PrintChat("casted packets CastQMin")
					end
				else
					CastSpell(_Q, pos.x, pos.z)
					if JannaMenu.debugmode then
                        PrintChat("casted normal CastQMin")
					end
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
		if JannaMenu.debugmode then
                PrintChat("GAINED: " .. buff.name)
		end
if buff.name == "HowlingGale" then
if JannaMenu.debugmode then
                        PrintChat("TRUE")
end
                        onHowlingGale = true
                end 
end
end

function OnLoseBuff(unit, buff)
        if unit == nil or buff == nil then return end
        if unit.isMe and buff then
		if JannaMenu.debugmode then
                PrintChat("LOST: " .. buff.name)
		end
                if buff.name == "HowlingGale" then
                        onHowlingGale = false
                end
        end
end 
