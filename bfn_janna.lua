if myHero.charName ~= "Janna" then return end

local version = "0.08"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL/master/bfn_janna.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."bfn_janna.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Big Fat Janna:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
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

local QRangeMin, QSpeed, QDelay, QWidth = 1075, 910, 0, 200 
local RRange = 700
local WRange = 600
local onHowlingGale = false 

local	ToShildSpells = {}
local	ShildSpellsDB = 
{

	{charName = "FiddleSticks", spellName = "Drain", useult = "no", cap = 0, spellSlot = "W", range = 575, width = 0, speed = math.huge, delay = .5},
	{charName = "FiddleSticks", spellName = "Crowstorm", useult = "yes", cap = 0, spellSlot = "R", range = 800, width = 600, speed = math.huge, delay = .5},
    {charName = "MissFortune", spellName = "MissFortuneBulletTime", useult = "yes", cap = 0, spellSlot = "R", range = 1400, width = 100, speed = 775, delay = .5},
	{charName = "Caitlyn", spellName = "CaitlynAceintheHole", useult = "no", cap = 0, spellSlot = "R", range = 2500, width = 0, speed = 1500, delay = 0},
    {charName = "Katarina", spellName = "KatarinaR", useult = "yes", cap = 0, spellSlot = "R", range = 550, width = 550, speed = 1450, delay = .5},
	{charName = "Karthus", spellName = "FallenOne", useult = "yes", cap = 0, spellSlot = "R", range = 20000 , width = 0 , speed = math.huge, delay = 0},
	{charName = "Malzahar", spellName = "AlZaharNetherGrasp", useult = "yes", cap = 0, spellSlot = "R", range = 700, width = 0, speed = math.huge, delay = .5},
	{charName = "Galio", spellName = "GalioIdolOfDurand", useult = "yes", cap = 0, spellSlot = "R", range = 560 , width = 560 , speed = math.huge, delay = .5},
	{charName = "Lucian", spellName = "LucianR", useult = "no", cap = 0, spellSlot = "R", range = 1400, width = 60, speed = math.huge, delay = .5},	
	{charName = "Shen",  spellName = "ShenStandUnited", useult = "no", cap = 0, spellSlot = "R", range = 25000, width = 0, speed = math.huge, delay = .5},
	{charName = "Urgot",  spellName = "UrgotSwap2", useult = "no", cap = 0, spellSlot = "R", range = 850, width = 0, speed = 1800, delay = .5},
	{charName = "Pantheon",  spellName = "PantheonRJump", useult = "no", cap = 0, spellSlot = "R", range = 5500, width = 1000, speed = 3000, delay = 1.0},
	{charName = "Warwick",  spellName = "InfiniteDuress", useult = "yes", cap = 0, spellSlot = "R", range = 700, width = 0, speed = math.huge, delay = .5},
	{charName = "Xerath",  spellName = "XerathLocusOfPower2", useult = "yes", cap = 0, spellSlot = "R", range = 5600, width = 200, speed = 500, delay = .75},
	{charName = "Velkoz",  spellName = "VelkozR", useult = "no", cap = 0, spellSlot = "R", range = 1575, width = 0, speed = 1500},
	{charName = "Zac",  spellName = "ZacE", useult = "no", cap = 0, spellSlot = "E", range = 1550, width = 250, speed = 1500, delay = .5},
	{charName = "Twich",  spellName = "HideInShadows", useult = "no", cap = 0, spellSlot = "Q", range = 0, width = 0, speed = math.huge, delay = .5},
	{charName = "Xerath",  spellName = "XerathArcanopulseChargeUp", useult = "no", cap = 0, spellSlot = "Q", range = 750, width = 100, speed = 500, delay = .75},
	{charName = "Aatrox", spellName = "AatroxQ", useult = "no", cap = 1, spellSlot = "Q", range = 650, width = 0, speed = 20,  delay = .5},
	{charName = "Corki", spellName = "CarpetBomb", useult = "no", cap = 1, spellSlot = "W", range = 875, width = 160, speed = 700, delay = 0},
	{charName = "Diana", spellName = "DianaTeleport", useult = "no", cap = 1, spellSlot = "R", range = 800, width = 0, speed = 1500, delay = .5},
	{charName = "LeeSin", spellName = "blindmonkqtwo", useult = "no", cap = 1, spellSlot = "Q", range = 0, width = 0, speed = math.huge, delay = .5},
	{charName = "JarvanIV", spellName = "JarvanIVDragonStrike", useult = "no", cap = 1, spellSlot = "Q", range = 700, width = 70, speed = math.huge, delay = .5},
	{charName = "Fiora", spellName = "FioraQ", useult = "no", cap = 1, spellSlot = "Q", range = 300 , width = 0, speed = 2200, delay = .5},
	{charName = "Leblanc", spellName = "LeblancSlide", useult = "no", cap = 1, spellSlot = "W", range = 600, width = 220, speed = math.huge, delay = .5},
	{charName = "Leblanc", spellName = "leblacslidereturn", useult = "no", cap = 1, spellSlot = "W", range = 0, width = 0, speed = math.huge, delay = .5},
	{charName = "Fizz", spellName = "FizzPiercingStrike", useult = "no", cap = 1, spellSlot = "Q", range = 550 , width = 0 , speed = math.huge, delay = .5},
	{charName = "Gragas", spellName = "GragasE", useult = "no", cap = 1, spellSlot = "E", range = 1100 , width = 50 , speed = 1000, delay = .3},
	{charName = "Irelia", spellName = "IreliaGatotsu", useult = "no", cap = 1, spellSlot = "Q", range = 650 , width = 0 , speed =2200, delay = 0},
	{charName = "Jax", spellName = "JaxLeapStrike", useult = "no", cap = 1, spellSlot = "Q", range = 210, width = 0, speed = 0, delay = .5},
    {charName = "Khazix", spellName = "KhazixE", useult = "no", cap = 1, spellSlot = "E", range = 600, width = 300, speed = math.huge, delay = .5},
    {charName = "Khazix", spellName = "khazixelong", useult = "no", cap = 1, spellSlot = "E", range = 900, width = 300, speed = math.huge, delay = .5},
	{charName = "Braum", spellName = "BraumW", useult = "no", cap = 1, spellSlot = "W", range = 650, width = 0, speed = 1500, delay = .5},
    {charName = "Ahri", spellName = "AhriTumble", useult = "no", cap = 1, spellSlot = "R", range = 450, width = 0, speed = 2200, delay = .5},
	{charName = "Akali", spellName = "AkaliShadowDance", useult = "no", cap = 1, spellSlot = "R", range = 800, width = 0, speed = 2200, delay = 0},
	{charName = "Caitlyn", spellName = "CaitlynEntrapment", useult = "no", cap = 1, spellSlot = "E", range = 950, width = 80, speed = 2000, delay = .25},
	{charName = "Pantheon",  spellName = "PantheonW", useult = "no", cap = 1, spellSlot = "W", range = 600, width = 0, speed = math.huge, delay = .5},
	{charName = "Quinn",  spellName = "QuinnE", useult = "no", cap = 1, spellSlot = "E", range = 700, width = 0, speed = 775, delay = .5},
	{charName = "Renekton",  spellName = "RenektonSliceAndDice", useult = "no", cap = 1, spellSlot = "E", range = 450, width = 50, speed = 1400, delay = .5},
	{charName = "Sejuani",  spellName = "SejuaniArcticAssault", useult = "no", cap = 1, spellSlot = "Q", range = 650, width = 75, speed = 1450, delay = .5},
	{charName = "Shaco",  spellName = "Deceive", useult = "no", cap = 1, spellSlot = "Q", range = 400, width = 0, speed = math.huge, delay = .5},
	{charName = "Shyvana",  spellName = "ShyvanaTransformCast", useult = "no", cap = 1, spellSlot = "R", range = 1000, width = 160, speed = 700, delay = .5},
	{charName = "Tryndamere",  spellName = "slashCast", useult = "no", cap = 1, spellSlot = "E", range = 660, width = 225, speed = 700, delay = .5},
	{charName = "Vi",  spellName = "ViQ", useult = "no", cap = 1, spellSlot = "Q", range = 800, width = 55, speed = 1500, delay = .5},
	{charName = "XinZhao",  spellName = "XenZhaoSweep", useult = "no", cap = 1, spellSlot = "E", range = 600, width = 120, speed = 1750, delay = .5},
	{charName = "Yasuo",  spellName = "YasuoDashWrapper", useult = "no", cap = 1, spellSlot = "E", range = 475, width = 0, speed = 20, delay = .5}



	}

function OnLoad()

	require "Prodiction"
	Prod = ProdictManager.GetInstance()
	ProdQmin = Prod:AddProdictionObject(_Q, QRangeMin, QSpeed, QDelay, QWidth) 

	JannaMenu = scriptConfig("Big Fat Janna", "Big Fat Janna")

	JannaMenu:addSubMenu("[Prodiction Settings]", "ProdictionSettings")
	JannaMenu.ProdictionSettings:addParam("UsePacketsCast","Use Packets Cast", SCRIPT_PARAM_ONOFF, true)
	JannaMenu.ProdictionSettings:addParam("info", "~=[ Callbacks ]=~", SCRIPT_PARAM_INFO, "")
	JannaMenu.ProdictionSettings:addParam("OnDash","OnDash", SCRIPT_PARAM_ONOFF, true)
	JannaMenu.ProdictionSettings:addParam("AfterDash","AfterDash", SCRIPT_PARAM_ONOFF, true)
	JannaMenu.ProdictionSettings:addParam("OnImmobile","OnImmobile", SCRIPT_PARAM_ONOFF, true)
	JannaMenu.ProdictionSettings:addParam("AfterImmobile","AfterImmobile", SCRIPT_PARAM_ONOFF, true)
	
	JannaMenu:addSubMenu("[KS Options]", "KSOptions")
	JannaMenu.KSOptions:addParam("KSwithW","KS with W", SCRIPT_PARAM_ONOFF, true)
	
	JannaMenu:addSubMenu("[Show in Game]", "Show")
	JannaMenu.Show:addParam("info", "~=[ New Settings will be saved after Reload ]=~", SCRIPT_PARAM_INFO, "")
	JannaMenu.Show:addParam("showcombo","Combo Key", SCRIPT_PARAM_ONOFF, false)
	JannaMenu.Show:addParam("showspamq","Spam Q Toggle", SCRIPT_PARAM_ONOFF, true)
	
	JannaMenu:addSubMenu("[Draws]", "Draws")
	JannaMenu.Draws:addSubMenu("[Q Settings]", "QSettings")
	JannaMenu.Draws.QSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	JannaMenu.Draws.QSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	JannaMenu.Draws.QSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 0, 0, 360)
	
	JannaMenu.Draws:addSubMenu("[W Settings]", "WSettings")
	JannaMenu.Draws.WSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	JannaMenu.Draws.WSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	JannaMenu.Draws.WSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 0, 0, 360)
	
	JannaMenu.Draws:addParam("UselowfpsDraws","Use low fps Draws", SCRIPT_PARAM_ONOFF, true)
	JannaMenu.Draws:addParam("DrawQRange","Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	JannaMenu.Draws:addParam("DrawWRange","Draw W Range", SCRIPT_PARAM_ONOFF, false)


	JannaMenu:addSubMenu("[Interrupter]", "Int")
	JannaMenu.Int:addParam("interrupterdebug","Interrupter Debug", SCRIPT_PARAM_ONOFF, true)
	JannaMenu.Int:addParam("info", " ", SCRIPT_PARAM_INFO, "")
	
	JannaMenu:addSubMenu("[Anticapcloser]", "Anticapcloser")
	JannaMenu.Anticapcloser:addParam("Anticapcloserdebug","Anticapcloser Debug", SCRIPT_PARAM_ONOFF, true)
	JannaMenu.Anticapcloser:addParam("info", " ", SCRIPT_PARAM_INFO, "")
	
	JannaMenu:addParam("debugmode","debugmode", SCRIPT_PARAM_ONOFF, false)
	JannaMenu:addParam("info", " ", SCRIPT_PARAM_INFO, "")
	JannaMenu:addParam("evadee","Evadee Intergration", SCRIPT_PARAM_ONOFF, true)
	JannaMenu:addParam("combo","Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	JannaMenu:addParam("castq","Spam Q Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("A"))

	
	for i, enemy in ipairs(GetEnemyHeroes()) do
		for _, champ in pairs(ShildSpellsDB) do
			if enemy.charName == champ.charName then
			table.insert(ToShildSpells, {charName = champ.charName, spellSlot = champ.spellSlot, spellName = champ.spellName, useult = champ.useult, cap = champ.cap, spellType = champ.spellType})
			end
		end
	end

	if #ToShildSpells > 0 then
		for _, Inter in pairs(ToShildSpells) do
				if Inter.cap == 0 then
				JannaMenu.Int:addParam(Inter.spellName, ""..Inter.charName.. " | " ..Inter.spellSlot.. " - " ..Inter.spellName, SCRIPT_PARAM_ONOFF, true)
				if Inter.useult == "no" then
				JannaMenu.Int:addParam(Inter.spellName..2, "allow to use ult", SCRIPT_PARAM_ONOFF, false)
				elseif Inter.useult == "yes" then
				JannaMenu.Int:addParam(Inter.spellName..2, "allow to use ult", SCRIPT_PARAM_ONOFF, true)
				end
				JannaMenu.Int:addParam("info", " ", SCRIPT_PARAM_INFO, "")
				
				elseif Inter.cap == 1 then
				JannaMenu.Anticapcloser:addParam(Inter.spellName, ""..Inter.charName.. " | " ..Inter.spellSlot.. " - " ..Inter.spellName, SCRIPT_PARAM_ONOFF, true)
				if Inter.useult == "no" then
				JannaMenu.Anticapcloser:addParam(Inter.spellName..2, "allow to use ult", SCRIPT_PARAM_ONOFF, false)
				elseif Inter.useult == "yes" then
				JannaMenu.Anticapcloser:addParam(Inter.spellName..2, "allow to use ult", SCRIPT_PARAM_ONOFF, true)
				end
				JannaMenu.Anticapcloser:addParam("info", " ", SCRIPT_PARAM_INFO, "")
				end
		end

	end		
	
	ts = TargetSelector(TARGET_LESS_CAST, 1400, true)
	ts.name = "JannaMenu"
    JannaMenu:addTS(ts)
	
	if JannaMenu.Show.showcombo then
	JannaMenu:permaShow("combo")
	end	
	if JannaMenu.Show.showspamq then
	JannaMenu:permaShow("castq")
	end
	
	
	     for i = 1, heroManager.iCount do
           local hero = heroManager:GetHero(i)
           if hero.team ~= myHero.team then
              ProdQmin:GetPredictionAfterDash(hero, CastQMin)
              ProdQmin:GetPredictionOnDash(hero, CastQMin)
              ProdQmin:GetPredictionAfterImmobile(hero, CastQMin)	  
              ProdQmin:GetPredictionOnImmobile(hero, CastQMin)
           end
       end

	PrintChat("<font color='#c9d7ff'> Big Fat Janna </font><font color='#64f879'> v. "..version.." by Big Fat Nidalee</font><font color='#c9d7ff'> loaded! </font>")
end



function OnTick()

	if onHowlingGale == true then
				if JannaMenu.ProdictionSettings.UsePacketsCast then
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
		
		if JannaMenu.castq then
		if ValidTarget(Target) then
			ProdQmin:GetPredictionCallBack(Target, CastQMin)
		end
	end	
	if JannaMenu.combo then
		if ValidTarget(Target) then
			ProdQmin:GetPredictionCallBack(Target, sbtw)
		end
	end		
	
	if JannaMenu.KSOptions.KSwithW and QREADY then	
	KSW()
	end 

if JannaMenu.evadee then
	if _G.Evadeee_impossibleToEvade and EREADY then
		CastSpell(_E[myHero.charName])
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

function KSW()

	for _, enemy in pairs(GetEnemyHeroes()) do
		if enemy and not enemy.dead and enemy.health < getDmg("W", enemy, myHero) then
		if GetDistance(enemy) <= WRange then
			if JannaMenu.ProdictionSettings.UsePacketsCast then
				Packet("S_CAST", {spellId = _W, targetNetworkId = enemy.networkID}):send()
			else
				CastSpell(_W, enemy)
			end
	 end
			return true
		end
	end
	
	return false
	
end

function OnProcessSpell(unit, spell)

		if #ToShildSpells > 0 then
			for _, Inter in pairs(ToShildSpells) do
				if spell.name == Inter.spellName and unit.team ~= myHero.team then
				-- interupter
					if JannaMenu.Int[Inter.spellName] and QREADY and ValidTarget(unit, QRangeMin) then
					if JannaMenu.Int.interrupterdebug then PrintChat("Tried to interrupt: " ..Inter.spellName) end
						if JannaMenu.ProdictionSettings.UsePacketsCast then
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

					elseif JannaMenu.Int[Inter.spellName..2] and JannaMenu.Int[Inter.spellName] and not QREADY and RREADY and ValidTarget(unit, RRange) then
					if JannaMenu.Int.interrupterdebug then PrintChat("Tried to interrupt with R: " ..Inter.spellName) end
						CastSpell(_R)
						
					end 	


					-- capcloser
					if JannaMenu.Anticapcloser[Inter.spellName] and QREADY and ValidTarget(unit, QRangeMin) then
					if JannaMenu.Anticapcloser.Anticapcloserdebug then PrintChat("Anticapcloser: " ..Inter.spellName) end
						if JannaMenu.ProdictionSettings.UsePacketsCast then
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

					elseif JannaMenu.Anticapcloser[Inter.spellName..2] and JannaMenu.Anticapcloser[Inter.spellName] and not QREADY and RREADY and ValidTarget(unit, RRange) then
					if JannaMenu.Anticapcloser.Anticapcloserdebug then PrintChat("Anticapcloser with R: " ..Inter.spellName) end
						CastSpell(_R)
						
					end 
					--
					

				end
			end
		end
		
	
end



local function getHitBoxRadius(target)
		return GetDistance(target, target.minBBox)
end

function GetQPos(unit, pos)
	qPos = pos
end


function CastQMin(unit,pos)

	if QREADY and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRangeMin) then 
				if JannaMenu.ProdictionSettings.UsePacketsCast then
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

function sbtw(unit,pos)
	if QREADY and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRangeMin) then 
				if JannaMenu.ProdictionSettings.UsePacketsCast then
					Packet("S_CAST", {spellId = _Q, fromX =  pos.x, fromY =  pos.z, toX =  pos.x, toY =  pos.z}):send()
					if JannaMenu.debugmode then
                        PrintChat("casted q packets sbtw")
					end
				else
					CastSpell(_Q, pos.x, pos.z)
					if JannaMenu.debugmode then
                        PrintChat("casted q normal sbtw")
					end
				end
	end
	if WREADY and (GetDistance(pos) - getHitBoxRadius(unit)/2 < WRange) then 
					CastSpell(_W, Target)
					if JannaMenu.debugmode then
                        PrintChat("casted normal W sbtw")
					end
	end
end 



function OnDraw()

	if JannaMenu.Draws.UselowfpsDraws then
		if QREADY and JannaMenu.Draws.DrawQRange and not myHero.dead then
		DrawCircleQ(myHero.x, myHero.y, myHero.z, QRangeMin, ARGB(JannaMenu.Draws.QSettings.colorAA[1],JannaMenu.Draws.QSettings.colorAA[2],JannaMenu.Draws.QSettings.colorAA[3],JannaMenu.Draws.QSettings.colorAA[4]))
		end	
		if WREADY and JannaMenu.Draws.DrawWRange and not myHero.dead then
		DrawCircleW(myHero.x, myHero.y, myHero.z, WRange, ARGB(JannaMenu.Draws.WSettings.colorAA[1],JannaMenu.Draws.WSettings.colorAA[2],JannaMenu.Draws.WSettings.colorAA[3],JannaMenu.Draws.WSettings.colorAA[4]))
		end	
	end
	
	if not JannaMenu.Draws.UselowfpsDraws then
	if QREADY then 
		if JannaMenu.Draws.DrawQRange and not myHero.dead then
			DrawCircle(myHero.x, myHero.y, myHero.z, QRangeMin, 0xb9c3ed)
		end	
	end
	if WREADY then 
		if JannaMenu.Draws.DrawWRange and not myHero.dead then
			DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0xb9c3ed)
		end
	end
	end
	

end 



--Q Range Circle QUality
function DrawCircleNextLvlQ(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(JannaMenu.Draws.QSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end


--Q Range Circle Width
function DrawCircleQ(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlQ(x, y, z, radius, JannaMenu.Draws.QSettings.width, color, 75)	
	end
end 	

--W Range Circle QUality
function DrawCircleNextLvlW(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(JannaMenu.Draws.WSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end


--W Range Circle Width
function DrawCircleW(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlW(x, y, z, radius, JannaMenu.Draws.WSettings.width, color, 75)	
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
