if myHero.charName ~= "Zyra" then return end

local version = "0.17"

local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL/master/bfn_zyra.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."bfn_zyra.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>BFN Zyra:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL/master/versions/bfn_zyra.version")
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


local QReady, WReady, EReady, RReady = false, false, false, false

local QRange, QSpeed, QDelay, QWidth = 800, 1430, 0.25, 85
local WRange, WSpeed, WDelay, WWidth = 825, math.huge, 0.2432, 10
local ERange, ESpeed, EDelay, EWidth = 1050, 1040, 0.24, 70
local RRange, RSpeed, RDelay, RRadius = 700, math.huge, 0.500, 500
local PRange, PSpeed, PDelay, PWidth = 1470, 1870, 0.500, 60

local KSWithPassive = false


local function getHitBoxRadius(target)
		return GetDistance(target, target.minBBox)
end

function OnLoad()

	require "Prodiction"

	Prod = ProdictManager.GetInstance()
	ProdQ = Prod:AddProdictionObject(_Q, QRange, QSpeed, QDelay, QWidth)
	ProdW = Prod:AddProdictionObject(_W, WRange, WSpeed, WDelay, WWidth)
	ProdE = Prod:AddProdictionObject(_E, ERange, ESpeed, EDelay, EWidth)
	ProdP = Prod:AddProdictionObject(_E, PRange, PSpeed, PDelay, PWidth)
	qPos = nil
	wPos = nil
	ePos = nil
	pPos = nil
	
	ZyraMenu = scriptConfig("BFN Zyra", "BFN Zyra")
	ts = TargetSelector(TARGET_LESS_CAST, 1400, DAMAGE_MAGIC, true)

	ts.name = "ZyraMenu"
    ZyraMenu:addTS(ts)
	
	ZyraMenu:addSubMenu("[Hotkeys]", "Hotkeys")
    ZyraMenu.Hotkeys:addParam("Combo","Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	ZyraMenu.Hotkeys:addParam("Harass1", "Harass 1 Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	ZyraMenu.Hotkeys:addParam("Harass2", "Harass 2 Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("Y"))
	ZyraMenu.Hotkeys:addParam("Farm", "Q Farm Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	
	ZyraMenu:addSubMenu("[Harass]", "Harass")
	ZyraMenu.Harass:addParam("info", "~=[ Harass 1 OnKey ]=~", SCRIPT_PARAM_INFO, "")
    ZyraMenu.Harass:addParam("Harass1Mode","Harass Q Mode", SCRIPT_PARAM_LIST, 1, { "Only if W Ready", "Dont wait for W" })
	ZyraMenu.Harass:addParam("ManaSliderHarass1", "Min mana to use skills",   SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
	ZyraMenu.Harass:addParam("info", "~=[ Harass 2 OnToggle ]=~", SCRIPT_PARAM_INFO, "")
    ZyraMenu.Harass:addParam("Harass2Mode","Harass Q Mode", SCRIPT_PARAM_LIST, 1, { "Only if W Ready", "Dont wait for W" })
	ZyraMenu.Harass:addParam("ManaSliderHarass2", "Min mana to use skills",   SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
	 
	ZyraMenu:addSubMenu("[Farm]", "Farm")
    ZyraMenu.Farm:addParam("UseQ","Use Q", SCRIPT_PARAM_ONOFF, true)
    ZyraMenu.Farm:addParam("UseW","Use W", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.Farm:addParam("ManaSliderFarm", "Min mana to use skills",   SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
	
	ZyraMenu:addSubMenu("[Ultimate]", "Ultimate")
	ZyraMenu.Ultimate:addParam("UseAutoUlt","Use Auto Ult", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.Ultimate:addParam("UltGroupMinimum", "Ult Enemy Team Min:", SCRIPT_PARAM_SLICE, 3, 2, 5, 0)
	
	ZyraMenu:addSubMenu("[Prodiction Settings]", "ProdictionSettings")
	ZyraMenu.ProdictionSettings:addParam("UsePacketsCast","Use Packets Cast", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.ProdictionSettings:addParam("info", "~=[ Callbacks ]=~", SCRIPT_PARAM_INFO, "")
	ZyraMenu.ProdictionSettings:addParam("OnDash","OnDash E", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.ProdictionSettings:addParam("AfterDash","AfterDash E / WQW", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.ProdictionSettings:addParam("OnImmobile","OnImmobile WQW", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.ProdictionSettings:addParam("AfterImmobile","AfterImmobile WQW / E", SCRIPT_PARAM_ONOFF, true)
	
	ZyraMenu:addSubMenu("[KS Options]", "KSOptions")
	ZyraMenu.KSOptions:addParam("KSwithQ","KS with Q", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.KSOptions:addParam("KSwithE","KS with E", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.KSOptions:addParam("AutoPassive","Auto Passive", SCRIPT_PARAM_ONOFF, true)	
	
	ZyraMenu:addSubMenu("[Jungle Steal Soon...]", "KSJungle")
	ZyraMenu.KSJungle:addParam("info", "~=[ not ready :P ]=~", SCRIPT_PARAM_INFO, "")
	ZyraMenu.KSJungle:addParam("KSBlue","Steal Blue", SCRIPT_PARAM_ONOFF, false)
	ZyraMenu.KSJungle:addParam("KSRed","Steal Red", SCRIPT_PARAM_ONOFF, false)
	ZyraMenu.KSJungle:addParam("KSDrake","Steal Drake", SCRIPT_PARAM_ONOFF, false)	
	ZyraMenu.KSJungle:addParam("KSNashor","Steal Nashor", SCRIPT_PARAM_ONOFF, false)	
	
	
	ZyraMenu:addSubMenu("[Show in Game]", "ShowinGame")
	ZyraMenu.ShowinGame:addParam("info", "~=[ New Settings will be saved after Reload ]=~", SCRIPT_PARAM_INFO, "")
	ZyraMenu.ShowinGame:addParam("info", "~=[ Keys ]=~", SCRIPT_PARAM_INFO, "")
	ZyraMenu.ShowinGame:addParam("Combo","Combo", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.ShowinGame:addParam("Harass1","Harass 1", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.ShowinGame:addParam("Harass2","Harass 2", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.ShowinGame:addParam("Farm","Q Farm", SCRIPT_PARAM_ONOFF, true)	
	ZyraMenu.ShowinGame:addParam("info", "~=[ Misc ]=~", SCRIPT_PARAM_INFO, "")
	ZyraMenu.ShowinGame:addParam("AutoUlt","Auto Ult", SCRIPT_PARAM_ONOFF, true)

	ZyraMenu:addSubMenu("[Interrupter]", "Interrupter")
	ZyraMenu.Interrupter:addParam("useinterrupter","Use Interrupter", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.Interrupter:addParam("interrupterdebug","Use Interrupter DebugMode", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.Interrupter:addParam("allowR","Allow to interrupt with R", SCRIPT_PARAM_ONOFF, true)
	
		
	ZyraMenu:addSubMenu("[Draws]", "Draws")
	ZyraMenu.Draws:addParam("DrawPassiveRange","Draw Passive Range", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.Draws:addParam("DrawQRange","Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.Draws:addParam("DrawWRange","Draw W Range", SCRIPT_PARAM_ONOFF, false)
	ZyraMenu.Draws:addParam("DrawERange","Draw E Range", SCRIPT_PARAM_ONOFF, false)
	ZyraMenu.Draws:addParam("DrawRRange","Draw R Range", SCRIPT_PARAM_ONOFF, false)
	
	if ZyraMenu.ShowinGame.Combo then
	ZyraMenu.Hotkeys:permaShow("Combo")
	end	
	if ZyraMenu.ShowinGame.Harass1 then
	ZyraMenu.Hotkeys:permaShow("Harass1")
	end	
	if ZyraMenu.ShowinGame.Harass2 then
	ZyraMenu.Hotkeys:permaShow("Harass2")
	end
	if ZyraMenu.ShowinGame.Farm then
	ZyraMenu.Hotkeys:permaShow("Farm")
	end
	if ZyraMenu.ShowinGame.AutoUlt then
	ZyraMenu.Ultimate:permaShow("UseAutoUlt")
	end
	
	-- interrupter 2.0 start
InterruptSpells = {
	["Teleport"]					= true, -- TP not tested
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
--	["DrainChannel"]				= true, -- Fiddle W
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
--	["VarusQ"]						= true, -- Varus Q
	["HideInShadows"]				= true, -- Twitch Q
	["PantheonW"]					= true, -- Pantheon W
	["CarpetBomb"]					= true, -- Corki W ?
	["LucianR"]						= true, -- Lucian R
	["OdinRecall"]					= true, -- Recall dominion
	
		
}


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
--	["CaitlynAceintheHole"]			= true, -- Cait R
}

-- end 

	for i = 1, heroManager.iCount do
			local hero = heroManager:GetHero(i)
			if hero.team ~= myHero.team then

				ProdE:GetPredictionAfterDash(hero, AfterDashFunc)
				ProdE:GetPredictionOnDash(hero, OnDashFunc)
				ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileFunc)
				ProdQ:GetPredictionOnImmobile(hero, OnImmobileFunc)
			end
	end
	
	PrintChat("<font color='#c9d7ff'> BFN Zyra </font><font color='#64f879'> "..version.." </font><font color='#c9d7ff'> loaded, happy elo boosting! </font>")

end

function OnTick()

	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	PReady = (myHero:GetSpellData(_Q).name == myHero:GetSpellData(_W).name or myHero:GetSpellData(_W).name == myHero:GetSpellData(_E).name)
	
	ts:update()
	Target = ts.target
	enemyMinions = {}
	enemyMinions = minionManager(MINION_ENEMY, QRange, myHero, MINION_SORT_HEALTH_ASC)

	if not PReady and ValidTarget(Target) then
	ProdQ:GetPredictionCallBack(Target, GetQPos)
	else
	qPos = nil
	end
	
	if not PReady and ValidTarget(Target) then
	ProdW:GetPredictionCallBack(Target, GetWPos)
	else
	wPos = nil
	end
	
	if not PReady and ValidTarget(Target) then
	ProdE:GetPredictionCallBack(Target, GetEPos)
	else
	ePos = nil
	end	
	
	if PReady and ValidTarget(Target) then
	ProdP:GetPredictionCallBack(Target, GetPPos)
	else
	pPos = nil
	end
	
	
	
	-- Passive 
	if PReady and ZyraMenu.KSOptions.AutoPassive then
	Passive()
		if KSWithPassive == false and ValidTarget(Target) then
		ProdP:GetPredictionCallBack(Target, CastP)
		end 
	end
	
	
	-- Combo
	if not PReady and ZyraMenu.Hotkeys.Combo then
	if ValidTarget(Target) then
	
	if EReady and WReady and QReady then
	ProdE:GetPredictionCallBack(Target, CastE)
	ProdQ:GetPredictionCallBack(Target, CastWQW)
	end 
	
	if EReady and WReady and not QReady then
	ProdE:GetPredictionCallBack(Target, CastWEW)
	end 
	
	if EReady and not WReady and QReady then
	ProdE:GetPredictionCallBack(Target, CastE)
	ProdQ:GetPredictionCallBack(Target, CastQ)
	end 
	
	if not EReady and WReady and QReady then
	ProdQ:GetPredictionCallBack(Target, CastWQW)
	end 
	
	if EReady and not WReady and not QReady then
	ProdE:GetPredictionCallBack(Target, CastE)
	end 
	
	if not EReady and not WReady and QReady then
	ProdQ:GetPredictionCallBack(Target, CastQ)
	end 
	
	end
	end
	--KS
	
	if ZyraMenu.KSOptions.KSwithQ then
	if not PReady and QReady then
	KSQ()
	end 
	end	
	
	if ZyraMenu.KSOptions.KSwithE then
	if not PReady and EReady and not QReady then
	KSE()
	end 
	end
	

	-- Harass
	if not PReady and ZyraMenu.Hotkeys.Harass1 and not ZyraMenu.Hotkeys.Combo then
	if ValidTarget(Target) then
	ProdQ:GetPredictionCallBack(Target, Harass1)
	end
	end
	if not PReady and ZyraMenu.Hotkeys.Harass2 and not ZyraMenu.Hotkeys.Combo then
	if ValidTarget(Target) then
	ProdQ:GetPredictionCallBack(Target, Harass2)
	end
	end
	-- Farm
	if not PReady and QReady and ZyraMenu.Hotkeys.Farm and not ZyraMenu.Hotkeys.Combo then
	Farm()
	end
	-- Auto Ult
	if not PReady and ZyraMenu.Ultimate.UseAutoUlt then
	UltGroup()
	end


	for i = 1, heroManager.iCount do
	local hero = heroManager:GetHero(i)
	if hero.team ~= myHero.team then

		if ZyraMenu.ProdictionSettings.AfterDash then
			ProdE:GetPredictionAfterDash(hero, AfterDashFunc)
		else
			ProdE:GetPredictionAfterDash(hero, AfterDashFunc, false)
		end
		if ZyraMenu.ProdictionSettings.OnDash then
			ProdE:GetPredictionOnDash(hero, OnDashFunc)
		else
			ProdE:GetPredictionOnImmobile(hero, OnDashFunc, false)
		end
		if ZyraMenu.ProdictionSettings.AfterImmobile then
			ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileFunc)
		else
			ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileFunc, false)
		end
		if ZyraMenu.ProdictionSettings.OnImmobile then
			ProdQ:GetPredictionOnImmobile(hero, OnImmobileFunc)
		else
			ProdQ:GetPredictionOnImmobile(hero, OnImmobileFunc, false)
		end
		
	end
	end

	OnDashPos = nil	
    AfterDashPos = nil	
    AfterImmobilePos = nil	
    OnImmobilePos = nil	
end

function OnProcessSpell(unit, spell)


if unit.isMe and spell.name == "ZyraQFissure" then
CastSpell(_W, spell.endPos.x, spell.endPos.z)


end


 if ZyraMenu.Interrupter.useinterrupter then
	if InterruptSpells[spell.name] and unit.team ~= myHero.team  then
		
		if EReady and (GetDistance(unit) < ERange) then
				if ZyraMenu.ProdictionSettings.UsePacketsCast then
                Packet("S_CAST", {spellId = _E, fromX =  unit.x, fromY =  unit.z, toX =  unit.x, toY =  unit.z}):send()
				else
				CastSpell(_E, unit.x, unit.z)
				end
				if ZyraMenu.Interrupter.interrupterdebug then PrintChat("Tried to interrupt " .. spell.name) end
        end

	end
	
	if InterruptSpells2[spell.name] and unit.team ~= myHero.team  then
				
		if ZyraMenu.Interrupter.allowR and RReady and (GetDistance(unit) < RRange) then
			Packet("S_CAST", {spellId = _R, fromX =  unit.x, fromY =  unit.z, toX =  unit.x, toY =  unit.z}):send()
			if ZyraMenu.Interrupter.interrupterdebug then PrintChat("Tried 2 interrupt with R: " .. spell.name) end
		end
		


end
end
end



function mymanaislowerthen(percent)
    if myHero.mana < (myHero.maxMana * ( percent / 100)) then
        return true
    else
        return false
    end
end

function GetQPos(unit, pos)
	qPos = pos
end


function GetWPos(unit, pos)
	wPos = pos
end


function GetEPos(unit, pos)
	ePos = pos
end

function GetPPos(unit, pos)
	pPos = pos
end


function CastWQW(unit,pos)

	if QReady and WReady and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then

			if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _W, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else 
			CastSpell(_W, pos.x, pos.z)
			end
			
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else
			CastSpell(_Q, pos.x, pos.z)
			end	
	end 
	
end 


function CastWEW(unit,pos)

	if EReady and WReady and (GetDistance(pos) - getHitBoxRadius(unit)/2 < ERange) then

			if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _E, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else
			CastSpell(_E, pos.x, pos.z)
			end
			
		if (GetDistance(pos) - getHitBoxRadius(unit)/2 < WRange) then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _W, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else 
			CastSpell(_W, pos.x, pos.z)
			end
		end
	
	end 
	
end 

function CastQ(unit,pos)

	if QReady and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then
	
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else
			CastSpell(_Q, pos.x, pos.z)
			end

	end 
	
end 
function CastE(unit,pos)

	if EReady and (GetDistance(pos) - getHitBoxRadius(unit)/2 < ERange) then
	
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _E, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else
			CastSpell(_E, pos.x, pos.z)
			end

	end 
	
end

function CastP(unit,pos)

	if PReady and (GetDistance(pos) - getHitBoxRadius(unit)/2 < PRange) then
		if EReady then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _E, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else
			CastSpell(_E, pos.x, pos.z)
			end
		elseif not EReady and QReady then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else
			CastSpell(_Q, pos.x, pos.z)
			end
		elseif not EReady and not QReady and RReady then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _R, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else
			CastSpell(_R, pos.x, pos.z)
			end
		elseif not EReady and not QReady and not RReady and WReady then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _W, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else
			CastSpell(_W, pos.x, pos.z)
			end
		end
		 
	end 
	
end 

--
-- harass
function Harass1(unit,pos)
	
	
	if ZyraMenu.Harass.Harass1Mode == 1 then
		if QReady and WReady and not mymanaislowerthen(ZyraMenu.Harass.ManaSliderHarass1) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then

					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _W, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
					else 
					CastSpell(_W, pos.x, pos.z)
					end


					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
					else
					CastSpell(_Q, pos.x, pos.z)
					end

		end 
	end
	
	if ZyraMenu.Harass.Harass1Mode == 2 then
		if QReady and WReady and not mymanaislowerthen(ZyraMenu.Harass.ManaSliderHarass1) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then

					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _W, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
					else 
					CastSpell(_W, pos.x, pos.z)
					end

					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
					else
					CastSpell(_Q, pos.x, pos.z)
					end

		end
		if QReady and not WReady and not mymanaislowerthen(ZyraMenu.Harass.ManaSliderHarass1) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then
				
					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
					else
					CastSpell(_Q, pos.x, pos.z)
					end
		end
	end 
end
	
function Harass2(unit,pos)
	
	if ZyraMenu.Harass.Harass2Mode == 1 then
		if QReady and WReady and not mymanaislowerthen(ZyraMenu.Harass.ManaSliderHarass2) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then

					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _W, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
					else 
					CastSpell(_W, pos.x, pos.z)
					end


					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
					else
					CastSpell(_Q, pos.x, pos.z)
					end


		end 
	end
	
	if ZyraMenu.Harass.Harass2Mode == 2 then
		if QReady and WReady and not mymanaislowerthen(ZyraMenu.Harass.ManaSliderHarass2) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then

					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _W, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
					else 
					CastSpell(_W, pos.x, pos.z)
					end

					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
					else
					CastSpell(_Q, pos.x, pos.z)
					end

		end
		if QReady and not WReady and not mymanaislowerthen(ZyraMenu.Harass.ManaSliderHarass2) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then
				
					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
					else
					CastSpell(_Q, pos.x, pos.z)
					end
		end
	end 
end
-- Farm

function Farm()
	enemyMinions:update()
	for _, minion in ipairs(enemyMinions.objects) do
		if ValidTarget(minion) then
	--		if getDmg("AD", minion, myHero) * 1.1 > minion.health then
	--			myHero:Attack(minion)
	
		if ZyraMenu.Farm.UseQ and not ZyraMenu.Farm.UseW and not mymanaislowerthen(ZyraMenu.Farm.ManaSliderFarm) then
			if getDmg("Q", minion, myHero) > minion.health then
			
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = minion.x, toY = minion.z, fromX = minion.x, fromY = minion.z}):send(true)
			else
				CastSpell(_Q, minion.x, minion.z)
			end
			end
			
		end 
		
		if ZyraMenu.Farm.UseQ and ZyraMenu.Farm.UseW and not mymanaislowerthen(ZyraMenu.Farm.ManaSliderFarm) then
			if getDmg("Q", minion, myHero) > minion.health then

			if ZyraMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _W, toX = minion.x, toY = minion.z, fromX = minion.x, fromY = minion.z}):send(true)
			else
				CastSpell(_W, minion.x, minion.z)
			end

			if ZyraMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = minion.x, toY = minion.z, fromX = minion.x, fromY = minion.z}):send(true)
			else
				CastSpell(_Q, minion.x, minion.z)
			end

			end
		end 
		
	
		end
	end
end
		
-- Callbacks
function AfterDashFunc (unit,pos)
	if EReady  and (GetDistance(pos) - getHitBoxRadius(unit)/2 < ERange) then
	
		if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet("S_CAST", {spellId = _E, fromX =  pos.x, fromY =  pos.z, toX =  pos.x, toY =  pos.z}):send()
		else
			CastSpell(_E, pos.x, pos.z)
		end

	end

		if QReady and WReady and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then

		if ZyraMenu.ProdictionSettings.UsePacketsCast then
		Packet('S_CAST', {spellId = _W, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
		else 
		CastSpell(_W, pos.x, pos.z)
		end

		if ZyraMenu.ProdictionSettings.UsePacketsCast then
		Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
		else
		CastSpell(_Q, pos.x, pos.z)
		end

		end

end 

function OnDashFunc (unit,pos)
	if EReady  and (GetDistance(pos) - getHitBoxRadius(unit)/2 < ERange) then
	
		if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet("S_CAST", {spellId = _E, fromX =  pos.x, fromY =  pos.z, toX =  pos.x, toY =  pos.z}):send()
		else
			CastSpell(_E, pos.x, pos.z)
		end

	end

end 

function AfterImmobileFunc (unit,pos)

		if EReady  and (GetDistance(pos) - getHitBoxRadius(unit)/2 < ERange) then
	
		if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet("S_CAST", {spellId = _E, fromX =  pos.x, fromY =  pos.z, toX =  pos.x, toY =  pos.z}):send()
		else
			CastSpell(_E, pos.x, pos.z)
		end

		end
	
if QReady and WReady and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then

		if ZyraMenu.ProdictionSettings.UsePacketsCast then
		Packet('S_CAST', {spellId = _W, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
		else 
		CastSpell(_W, pos.x, pos.z)
		end

		if ZyraMenu.ProdictionSettings.UsePacketsCast then
		Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
		else
		CastSpell(_Q, pos.x, pos.z)
		end

end

end 


function OnImmobileFunc (unit,pos)
	if QReady and WReady and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then

		if ZyraMenu.ProdictionSettings.UsePacketsCast then
		Packet('S_CAST', {spellId = _W, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
		else 
		CastSpell(_W, pos.x, pos.z)
		end

		if ZyraMenu.ProdictionSettings.UsePacketsCast then
		Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
		else
		CastSpell(_Q, pos.x, pos.z)
		end

		if EReady  and (GetDistance(pos) - getHitBoxRadius(unit)/2 < ERange) then
	
		if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet("S_CAST", {spellId = _E, fromX =  pos.x, fromY =  pos.z, toX =  pos.x, toY =  pos.z}):send()
		else
			CastSpell(_E, pos.x, pos.z)
		end

		end

end

end 

function KSQ()

	for _, enemy in pairs(GetEnemyHeroes()) do
		if enemy and not enemy.dead and enemy.health < getDmg("Q", enemy, myHero) then
		if GetDistance(enemy) <= QRange then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = enemy.x, toY = enemy.z, fromX = enemy.x, fromY = enemy.z}):send(true)
			else
				CastSpell(_Q, enemy.x, enemy.z)
			end
	 end
			return true
		end
	end
	
	return false
	
end

function KSE()


	for _, enemy in pairs(GetEnemyHeroes()) do
		if enemy and not enemy.dead and enemy.health < getDmg("E", enemy, myHero) then
			if GetDistance(enemy) <= ERange then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _E, toX = enemy.x, toY = enemy.z, fromX = enemy.x, fromY = enemy.z}):send(true)
			else
				CastSpell(_E, enemy.x, enemy.z)
			end
			end
			return true
		end
	end

	return false
end

function Passive()
	-- Hit any killable enemy.
	for _, enemy in pairs(GetEnemyHeroes()) do
		if enemy and not enemy.dead and enemy.health < getDmg("P", enemy, myHero) then
			if GetDistance(enemy) <= PRange then
			KSWithPassive = true
			
			if EReady then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _E, toX = enemy.x, toY = enemy.z, fromX = enemy.x, fromY = enemy.z}):send(true)
			else
				CastSpell(_E, enemy.x, enemy.z)
			end
			end
						
			if not EReady and QReady then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = enemy.x, toY = enemy.z, fromX = enemy.x, fromY = enemy.z}):send(true)
			else
				CastSpell(_Q, enemy.x, enemy.z)
			end
			end
						
			if not EReady and not QReady and WReady then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _W, toX = enemy.x, toY = enemy.z, fromX = enemy.x, fromY = enemy.z}):send(true)
			else
				CastSpell(_W, enemy.x, enemy.z)
			end
			end
						
			if not EReady and not QReady and not WReady and RReady then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _R, toX = enemy.x, toY = enemy.z, fromX = enemy.x, fromY = enemy.z}):send(true)
			else
				CastSpell(_R, enemy.x, enemy.z)
			end
			end
			
			return true

			
		end
		

	return false

end
end
end


-- Ult
function UltGroup(manual)
	if not ts or not ts.target then return false end

	if not manual and EnemyCount(myHero, (RRange + RRadius)) < ZyraMenu.Ultimate.UltGroupMinimum then return false end

	local spellPos = GetAoESpellPosition(RRadius, ts.target, RDelay * 1000)
	CastSpell(_R, spellPos.x, spellPos.z)
	
	if spellPos and GetDistance(spellPos) <= RRange then
		if manual or EnemyCount(spellPos, RRadius) >= ZyraMenu.Ultimate.UltGroupMinimum then

			CastSpell(_R, spellPos.x, spellPos.z)
			return true
		end
	end

	return false
end

function EnemyCount(point, range)
	local count = 0

	for _, enemy in pairs(GetEnemyHeroes()) do
		if enemy and not enemy.dead and GetDistance(point, enemy) <= range then
			count = count + 1
		end
	end            

	return count
end

function GetAoESpellPosition(radius, main_target, delay)
	local targets = delay and GetPredictedInitialTargets(radius, main_target, delay) or GetInitialTargets(radius, main_target)
	local position = GetCenter(targets)
	local best_pos_found = true
	local circle = Circle(position, radius)
	circle.center = position
	
	if #targets > 2 then best_pos_found = ContainsThemAll(circle, targets) end
	
	while not best_pos_found do
		targets = RemoveWorst(targets, position)
		position = GetCenter(targets)
		circle.center = position
		best_pos_found = ContainsThemAll(circle, targets)
	end
	
	return position
end

function GetPredictedInitialTargets(radius, main_target, delay)
	if VIP_USER and not vip_target_predictor then vip_target_predictor = TargetPredictionVIP(nil, nil, delay/1000) end
	local predicted_main_target = VIP_USER and vip_target_predictor:GetPrediction(main_target) or GetPredictionPos(main_target, delay)
	local predicted_targets = {predicted_main_target}
	local diameter_sqr = 4 * radius * radius
	
	for i=1, heroManager.iCount do
		target = heroManager:GetHero(i)
		if ValidTarget(target) then
			predicted_target = VIP_USER and vip_target_predictor:GetPrediction(target) or GetPredictionPos(target, delay)
			if target.networkID ~= main_target.networkID and GetDistanceSqr(predicted_main_target, predicted_target) < diameter_sqr then table.insert(predicted_targets, predicted_target) end
		end
	end
	
	return predicted_targets
end


function GetCenter(points)
	local sum_x = 0
	local sum_z = 0
	
	for i = 1, #points do
		sum_x = sum_x + points[i].x
		sum_z = sum_z + points[i].z
	end
	
	local center = {x = sum_x / #points, y = 0, z = sum_z / #points}
	
	return center
end
function ContainsThemAll(circle, points)
	local radius_sqr = circle.radius*circle.radius
	local contains_them_all = true
	local i = 1
	
	while contains_them_all and i <= #points do
		contains_them_all = GetDistanceSqr(points[i], circle.center) <= radius_sqr
		i = i + 1
	end
	
	return contains_them_all
end

function RemoveWorst(targets, position)
	local worst_target = FarthestFromPositionIndex(targets, position)
	
	table.remove(targets, worst_target)
	
	return targets
end

function FarthestFromPositionIndex(points, position)
	local index = 2
	local actual_dist_sqr
	local max_dist_sqr = GetDistanceSqr(points[index], position)
	
	for i = 3, #points do
		actual_dist_sqr = GetDistanceSqr(points[i], position)
		if actual_dist_sqr > max_dist_sqr then
			index = i
			max_dist_sqr = actual_dist_sqr
		end
	end
	
	return index
end

function OnDraw()
	if PReady then
		if ZyraMenu.Draws.DrawPassiveRange and not myHero.dead then
			DrawCircle(myHero.x, myHero.y, myHero.z, PRange, 0xb9c3ed)
		end	
	end
	if QReady then 
		if ZyraMenu.Draws.DrawQRange and not myHero.dead then
			DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0xb9c3ed)
		end	
	end
	if WReady then 
		if ZyraMenu.Draws.DrawWRange and not myHero.dead then
			DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0xb9c3ed)
		end	
	end
	if EReady then 
		if ZyraMenu.Draws.DrawERange and not myHero.dead then
			DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0xb9c3ed)
		end	
	end
	if RReady then 
		if ZyraMenu.Draws.DrawRRange and not myHero.dead then
			DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0xb9c3ed)
		end	
	end

end 
