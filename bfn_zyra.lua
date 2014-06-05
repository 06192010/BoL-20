if myHero.charName ~= "Zyra" then return end

local version = "0.04"

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

local QRange, QSpeed, QDelay, QWidth = 800, math.huge, 0.7, 85
local WRange, WSpeed, WDelay, WWidth = 825, math.huge, 0.2432, 10
local ERange, ESpeed, EDelay, EWidth = 1050, 1150, 0.16, 70
local RRange, RSpeed, RDelay, RRadius = 700, math.huge, 0.500, 500
local PRange, PSpeed, PDelay, PWidth = 1470, 1870, 0.500, 60




function OnLoad()

	require "Prodiction"

	
	ZyraMenu = scriptConfig("BFN Zyra", "BFN Zyra")
	ts = TargetSelector(TARGET_LESS_CAST, 1400, DAMAGE_MAGIC, true)

	ts.name = "ZyraMenu"
    ZyraMenu:addTS(ts)
	
	ZyraMenu:addSubMenu("[Hotkeys]", "Hotkeys")
    ZyraMenu.Hotkeys:addParam("Combo","Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	ZyraMenu.Hotkeys:addParam("Harass1", "Harass 1 Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	ZyraMenu.Hotkeys:addParam("Harass2", "Harass 2 Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("Y"))
	
	ZyraMenu:addSubMenu("[Harass]", "Harass")
	ZyraMenu.Harass:addParam("info", "~=[ Harass 1 OnKey ]=~", SCRIPT_PARAM_INFO, "")
    ZyraMenu.Harass:addParam("Harass1Mode","Harass Q Mode", SCRIPT_PARAM_LIST, 1, { "Only if W Ready", "Dont wait for W" })
	ZyraMenu.Harass:addParam("ManaSliderHarass1", "Min mana to use skills",   SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
	ZyraMenu.Harass:addParam("info", "~=[ Harass 2 OnToggle ]=~", SCRIPT_PARAM_INFO, "")
    ZyraMenu.Harass:addParam("Harass2Mode","Harass Q Mode", SCRIPT_PARAM_LIST, 1, { "Only if W Ready", "Dont wait for W" })
	ZyraMenu.Harass:addParam("ManaSliderHarass2", "Min mana to use skills",   SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
	
	ZyraMenu:addSubMenu("[Ultimate]", "Ultimate")
	ZyraMenu.Ultimate:addParam("UseAutoUlt","Use Auto Ult", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.Ultimate:addParam("UltGroupMinimum", "Ult Enemy Team Min:", SCRIPT_PARAM_SLICE, 3, 2, 5, 0)
	
	ZyraMenu:addSubMenu("[Prodiction Settings]", "ProdictionSettings")
	ZyraMenu.ProdictionSettings:addParam("UsePacketsCast","Use Packets Cast", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.ProdictionSettings:addParam("info", "~=[ Callbacks ]=~", SCRIPT_PARAM_INFO, "")
	ZyraMenu.ProdictionSettings:addParam("info", "~=[ IT DOESNT WORK NOW ]=~", SCRIPT_PARAM_INFO, "")
	ZyraMenu.ProdictionSettings:addParam("OnDash","OnDash", SCRIPT_PARAM_ONOFF, false)
	ZyraMenu.ProdictionSettings:addParam("AfterDash","AfterDash", SCRIPT_PARAM_ONOFF, false)
	ZyraMenu.ProdictionSettings:addParam("OnImmobile","OnImmobile", SCRIPT_PARAM_ONOFF, false)
	ZyraMenu.ProdictionSettings:addParam("AfterImmobile","AfterImmobile", SCRIPT_PARAM_ONOFF, false)
	
	ZyraMenu:addSubMenu("[KS Options]", "KSOptions")
	ZyraMenu.KSOptions:addParam("info", "~=[ IT DOESNT WORK NOW ]=~", SCRIPT_PARAM_INFO, "")
	ZyraMenu.KSOptions:addParam("KSwithQ","KS with Q", SCRIPT_PARAM_ONOFF, false)
	ZyraMenu.KSOptions:addParam("KSwithQ","KS with E", SCRIPT_PARAM_ONOFF, false)
	ZyraMenu.KSOptions:addParam("KSwithQ","KS with R", SCRIPT_PARAM_ONOFF, false)
--	ZyraMenu.KSOptions:addParam("KSwithPassive","KS with Passive", SCRIPT_PARAM_ONOFF, true)	
	
	ZyraMenu:addSubMenu("[Show in Game]", "ShowinGame")
	ZyraMenu.ShowinGame:addParam("info", "~=[ New Settings will be saved after Reload ]=~", SCRIPT_PARAM_INFO, "")
	ZyraMenu.ShowinGame:addParam("info", "~=[ Keys ]=~", SCRIPT_PARAM_INFO, "")
	ZyraMenu.ShowinGame:addParam("Combo","Combo", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.ShowinGame:addParam("Harass1","Harass 1", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.ShowinGame:addParam("Harass2","Harass 2", SCRIPT_PARAM_ONOFF, true)	
	ZyraMenu.ShowinGame:addParam("info", "~=[ Misc ]=~", SCRIPT_PARAM_INFO, "")
	ZyraMenu.ShowinGame:addParam("AutoUlt","Auto Ult", SCRIPT_PARAM_ONOFF, true)

	ZyraMenu:addSubMenu("[Interrupter]", "Interrupter")
	ZyraMenu.Interrupter:addParam("useinterrupter","Use Interrupter", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.Interrupter:addParam("interrupterdebug","Use Interrupter DebugMode", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.Interrupter:addParam("info", "~=[ NOT TESTED ! ]=~", SCRIPT_PARAM_INFO, "")
	ZyraMenu.Interrupter:addParam("allowR","Allow to interrupt with R", SCRIPT_PARAM_ONOFF, false)
	
		
	ZyraMenu:addSubMenu("[Draws]", "Draws")
--	ZyraMenu.Draws:addParam("DrawPassiveRange","Draw Passive Range", SCRIPT_PARAM_ONOFF, false)
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

	PrintChat("<font color='#c9d7ff'> BFN Zyra </font><font color='#64f879'> "..version.." </font><font color='#c9d7ff'> loaded! </font>")

end

function OnTick()

	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	
	ts:update()
	Target = ts.target

	-- Combo
	if ZyraMenu.Hotkeys.Combo then
	Combo()
	end
	-- Harass
	if ZyraMenu.Hotkeys.Harass1 then
	Harass1()
	end
	if ZyraMenu.Hotkeys.Harass2 then
	Harass1()
	end
	-- Auto Ult
	if ZyraMenu.Ultimate.UseAutoUlt then
	UltGroup()
	end



end

function OnProcessSpell(unit, spell)

if unit.isMe and spell.name == "ZyraSeed" then
CastSpell(_W, spell.endPos.x, spell.endPos.z)
end
if unit.isMe and spell.name == "ZyraQFissure" then
CastSpell(_W, spell.endPos.x, spell.endPos.z)
end
if unit.isMe and spell.name == "ZyraGraspingRoots" then
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
		
		if  RReady and (GetDistance(unit) < ERange) then
				if ZyraMenu.ProdictionSettings.UsePacketsCast then
                Packet("S_CAST", {spellId = _E, fromX =  unit.x, fromY =  unit.z, toX =  unit.x, toY =  unit.z}):send()
				else
				CastSpell(_E, unit.x, unit.z)
				end
				if ZyraMenu.Interrupter.interrupterdebug then PrintChat("Tried 2 interrupt " .. spell.name) end
        end
		
		if ZyraMenu.Interrupter.allowR and not EReady and RReady and (GetDistance(unit) < RRange) then
			CastSpell(_R, unit.x, unit.z)
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
-- Combo 

function Combo()
	if not Target then return end
	
	if EReady and WReady and GetDistance(Target) <= ERange then
		local wpos, winfo = Prodiction.GetPrediction(Target, WRange, WSpeed, WDelay, WWidth, myPlayer)
		local epos, einfo = Prodiction.GetPrediction(Target, ERange, ESpeed, EDelay, EWidth, myPlayer)
		
		if wpos and winfo.hitchance >= 1 then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			end
		end	
		
		if epos and einfo.hitchance >= 2 then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _E, toX = epos.x, toY = epos.z, fromX = epos.x, fromY = epos.z}):send(true)
			else 
			CastSpell(_E, epos.x, epos.z)
			end
		end	
		
		if wpos and winfo.hitchance >= 1 then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			end
		end	
	elseif EReady and not WReady and GetDistance(Target) <= ERange then
		local epos, einfo = Prodiction.GetPrediction(Target, ERange, ESpeed, EDelay, EWidth, myPlayer)
		if epos and einfo.hitchance >= 2 then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _E, toX = epos.x, toY = epos.z, fromX = epos.x, fromY = epos.z}):send(true)
			else 
			CastSpell(_E, epos.x, epos.z)
			end
		end	
	elseif not EReady and QReady and WReady and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local wpos, winfo = Prodiction.GetPrediction(Target, WRange, WSpeed, WDelay, WWidth, myPlayer)
			
		if wpos and winfo.hitchance >= 1 then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			end
			end
			
		if qpos and qinfo.hitchance >= 2 then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end 
			
		if wpos and winfo.hitchance >= 1 then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			end
		end
	elseif not WReady and not EReady and QReady and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		

		if qpos and qinfo.hitchance >= 2 then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end 
	end	

end 
				--  HITCHANCE:   BLOCKED = 0   LOW = 1  NORMAL = 2  HIGH = 3  VERY_HIGH = 4
--
-- harass
function Harass1()
	if not Target then return end
	
	if ZyraMenu.Harass.Harass1Mode == 1 then
		if QReady and WReady and not mymanaislowerthen(ZyraMenu.Harass.ManaSliderHarass1) and GetDistance(Target) <= QRange then
				local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
				local wpos, winfo = Prodiction.GetPrediction(Target, WRange, WSpeed, WDelay, WWidth, myPlayer)
			
				if wpos and winfo.hitchance >= 1 then
					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
					else 
					CastSpell(_W, wpos.x, wpos.z)
					end
				end
			
				if qpos and qinfo.hitchance >= 2 then
					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
					else
					CastSpell(_Q, qpos.x, qpos.z)
					end
				end 
			
				if wpos and winfo.hitchance >= 1 then
					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
					else 
					CastSpell(_W, wpos.x, wpos.z)
					end
				end
		end 
	elseif ZyraMenu.Harass.Harass1Mode == 2 then
		if QReady and WReady and not mymanaislowerthen(ZyraMenu.Harass.ManaSliderHarass1) and GetDistance(Target) <= QRange then
				local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
				local wpos, winfo = Prodiction.GetPrediction(Target, WRange, WSpeed, WDelay, WWidth, myPlayer)
			
				if wpos and winfo.hitchance >= 1 then
					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
					else 
					CastSpell(_W, wpos.x, wpos.z)
					end
				end
			
				if qpos and qinfo.hitchance >= 2 then
					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
					else
					CastSpell(_Q, qpos.x, qpos.z)
					end
				end 
			
				if wpos and winfo.hitchance >= 1 then
					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
					else 
					CastSpell(_W, wpos.x, wpos.z)
					end
				end
		elseif QReady and not WReady and not mymanaislowerthen(ZyraMenu.Harass.ManaSliderHarass1) and GetDistance(Target) <= QRange then
				local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
				
					if qpos and qinfo.hitchance >= 2 then
					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
					else
					CastSpell(_Q, qpos.x, qpos.z)
					end
				end
		end
	end 
	
end 

function Harass2()
	if not Target then return end
	
	if ZyraMenu.Harass.Harass2Mode == 1 then
		if QReady and WReady and not mymanaislowerthen(ZyraMenu.Harass.ManaSliderHarass2) and GetDistance(Target) <= QRange then
				local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
				local wpos, winfo = Prodiction.GetPrediction(Target, WRange, WSpeed, WDelay, WWidth, myPlayer)
			
				if wpos and winfo.hitchance >= 1 then
					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
					else 
					CastSpell(_W, wpos.x, wpos.z)
					end
				end
			
				if qpos and qinfo.hitchance >= 2 then
					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
					else
					CastSpell(_Q, qpos.x, qpos.z)
					end
				end 
			
				if wpos and winfo.hitchance >= 1 then
					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
					else 
					CastSpell(_W, wpos.x, wpos.z)
					end
				end
		end 
	elseif ZyraMenu.Harass.Harass2Mode == 2 then
		if QReady and WReady and not mymanaislowerthen(ZyraMenu.Harass.ManaSliderHarass2) and GetDistance(Target) <= QRange then
				local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
				local wpos, winfo = Prodiction.GetPrediction(Target, WRange, WSpeed, WDelay, WWidth, myPlayer)
			
				if wpos and winfo.hitchance >= 1 then
					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
					else 
					CastSpell(_W, wpos.x, wpos.z)
					end
				end
			
				if qpos and qinfo.hitchance >= 2 then
					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
					else
					CastSpell(_Q, qpos.x, qpos.z)
					end
				end 
			
				if wpos and winfo.hitchance >= 1 then
					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
					else 
					CastSpell(_W, wpos.x, wpos.z)
					end
				end
		elseif QReady and not WReady and not mymanaislowerthen(ZyraMenu.Harass.ManaSliderHarass2) and GetDistance(Target) <= QRange then
				local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
				
					if qpos and qinfo.hitchance >= 2 then
					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
					else
					CastSpell(_Q, qpos.x, qpos.z)
					end
				end
		end
	end 
	
end 
--
-- Ult stolen from Kain xD
function UltGroup(manual)
	if not ts or not ts.target then return false end

	if not manual and EnemyCount(myHero, (RRange + RRadius)) < ZyraMenu.Ultimate.UltGroupMinimum then return false end

	local spellPos = GetAoESpellPosition(RRadius, ts.target, RDelay * 1000)

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

--		if ZyraMenu.Draws.DrawPassiveRange and not myHero.dead then
--			DrawCircle(myHero.x, myHero.y, myHero.z, PRange, 0xb9c3ed)
--		end	

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
