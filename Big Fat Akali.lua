if myHero.charName ~= "Akali" then return end

local version = "0.01"

local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL/master/Big Fat Akali.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."Big Fat Akali.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>BFN Zyra:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL/master/versions/bfn_akali.version")
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



local AARange = 190
local QRange, QSpeed, QDelay, QWidth = 600, 1000, 0.65, 0
local WRange, WSpeed, WDelay, WWidth = 700, 0, 0.5, 420
local ERange, ESpeed, EDelay, EWidth = 325, 0, 0.5, 0
local RRange, RSpeed, RDelay, RWidth = 800, 2200, 0, 0
local Marked = nil
local QMarked = false

--[SOW Block]--
local starttick = 0
local checkedMMASAC = false
local is_MMA = false
local is_REVAMP = false
local is_REBORN = false
local is_SAC = false
local itsme = false
--[/SOW Block]--

local showLocationsInRange = 1000

function OnLoad()
	require 'VPrediction'
	require 'SOW'
	VPred = VPrediction()
	iSOW = SOW(VPred)
	
	gameState = GetGame()
	if gameState.map.shortName == "summonerRift" then
	SRift = true
	else
	SRift = false
	end
	if SRift == true then
	_get_coordinates()
	end
	
	BigFatAkali = scriptConfig("Big Fat Akali", "Big Fat Akali")
	BigFatAkali:addSubMenu("[ Farm & Harass ]", "FarmHarass")
		BigFatAkali.FarmHarass:addSubMenu("[ Last Hit ]", "LastHit")
			BigFatAkali.FarmHarass.LastHit:addParam("info2", "", SCRIPT_PARAM_INFO, "")
			BigFatAkali.FarmHarass.LastHit:addParam("UseQ","Farm: Use Q", SCRIPT_PARAM_ONOFF, true)
			BigFatAkali.FarmHarass.LastHit:addParam("UseE","Farm: Use E", SCRIPT_PARAM_ONOFF, true)
			BigFatAkali.FarmHarass.LastHit:addParam("UseskillsonlyoutofAttackRange","Use skills out of Attack Range", SCRIPT_PARAM_ONOFF, true)
			BigFatAkali.FarmHarass.LastHit:addParam("info2", "", SCRIPT_PARAM_INFO, "")
			BigFatAkali.FarmHarass.LastHit:addParam("HarassQ","Harass Enemys with Q", SCRIPT_PARAM_ONOFF, true)
		BigFatAkali.FarmHarass:addSubMenu("[ Mixed Mode ]", "MixedMode")
			BigFatAkali.FarmHarass.MixedMode:addParam("info2", "", SCRIPT_PARAM_INFO, "")
			BigFatAkali.FarmHarass.MixedMode:addParam("UseQ","Farm: Use Q", SCRIPT_PARAM_ONOFF, true)
			BigFatAkali.FarmHarass.MixedMode:addParam("UseE","Farm: Use E", SCRIPT_PARAM_ONOFF, true)
			BigFatAkali.FarmHarass.MixedMode:addParam("UseskillsonlyoutofAttackRange","Use skills out of Attack Range", SCRIPT_PARAM_ONOFF, true)
			BigFatAkali.FarmHarass.MixedMode:addParam("info2", "", SCRIPT_PARAM_INFO, "")
			BigFatAkali.FarmHarass.MixedMode:addParam("HarassQ","Harass Enemys with Q", SCRIPT_PARAM_ONOFF, true)
		BigFatAkali.FarmHarass:addSubMenu("[ Lane Clear ]", "LaneClear")
			BigFatAkali.FarmHarass.LaneClear:addParam("info2", "", SCRIPT_PARAM_INFO, "")
			BigFatAkali.FarmHarass.LaneClear:addParam("UseQ","Farm: Use Q", SCRIPT_PARAM_ONOFF, true)
			BigFatAkali.FarmHarass.LaneClear:addParam("UseE","Farm: Use E", SCRIPT_PARAM_ONOFF, true)
			BigFatAkali.FarmHarass.LaneClear:addParam("UseskillsonlyoutofAttackRange","Use skills out of Attack Range", SCRIPT_PARAM_ONOFF, true)
			BigFatAkali.FarmHarass.LaneClear:addParam("info2", "", SCRIPT_PARAM_INFO, "")
			BigFatAkali.FarmHarass.LaneClear:addParam("HarassQ","Harass Enemys with Q", SCRIPT_PARAM_ONOFF, true)
			
	BigFatAkali:addSubMenu("[ Orbwalker ]", "Orbwalk")
		BigFatAkali.Orbwalk:addParam("standartts", "Use Standart TargetSelector", SCRIPT_PARAM_ONOFF, true)
		
	BigFatAkali:addSubMenu("[ Kill Steal ]", "KillSteal")
		BigFatAkali.KillSteal:addParam("UseQ","Use Q", SCRIPT_PARAM_ONOFF, true)
		BigFatAkali.KillSteal:addParam("UseE","Use E", SCRIPT_PARAM_ONOFF, true)
		BigFatAkali.KillSteal:addParam("UseR","Use R", SCRIPT_PARAM_ONOFF, true)
		

		
	BigFatAkali:addSubMenu("[ Draws ]", "Draws")
		BigFatAkali.Draws:addSubMenu("[ Q Settings ]", "QSettings")
			BigFatAkali.Draws.QSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
			BigFatAkali.Draws.QSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
			BigFatAkali.Draws.QSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)	
		BigFatAkali.Draws:addSubMenu("[ W Settings ]", "WSettings")
			BigFatAkali.Draws.WSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
			BigFatAkali.Draws.WSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
			BigFatAkali.Draws.WSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)	
		BigFatAkali.Draws:addSubMenu("[ E Settings ]", "ESettings")
			BigFatAkali.Draws.ESettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
			BigFatAkali.Draws.ESettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
			BigFatAkali.Draws.ESettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)	
		BigFatAkali.Draws:addSubMenu("[ R Settings ]", "RSettings")
			BigFatAkali.Draws.RSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
			BigFatAkali.Draws.RSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
			BigFatAkali.Draws.RSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)
		BigFatAkali.Draws:addParam("UselowfpsDraws","Use low fps Draws", SCRIPT_PARAM_ONOFF, true)
		BigFatAkali.Draws:addParam("DrawQRange","Draw Q Range", SCRIPT_PARAM_ONOFF, true)
		BigFatAkali.Draws:addParam("DrawWRange","Draw W Range", SCRIPT_PARAM_ONOFF, false)
		BigFatAkali.Draws:addParam("DrawERange","Draw E Range", SCRIPT_PARAM_ONOFF, false)
		BigFatAkali.Draws:addParam("DrawRRange","Draw R Range", SCRIPT_PARAM_ONOFF, false)
		
	BigFatAkali:addSubMenu("[ Other Settings ]", "Other")
		BigFatAkali.Other:addParam("UsePacketsCast","Use Packets Cast", SCRIPT_PARAM_ONOFF, true)
		BigFatAkali.Other:addParam("debugmode","Debug Mode", SCRIPT_PARAM_ONOFF, false)
		BigFatAkali.Other:addParam("Joke","Send Joke while KS", SCRIPT_PARAM_ONOFF, true)


	BigFatAkali:addParam("info", " ", SCRIPT_PARAM_INFO, "")
	BigFatAkali:addParam("info", "[ Keys ]", SCRIPT_PARAM_INFO, "")
	BigFatAkali:addParam("Combo","< Combo >", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	BigFatAkali:addParam("LastHit","< Last Hit >", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("A"))
	BigFatAkali:addParam("MixedMode","< Mixed Mode >", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	BigFatAkali:addParam("LaneClear","< Lane Clear >", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	
	ts = TargetSelector(TARGET_LESS_CAST, 1400, true)
	ts.name = "BigFatAkali"
    BigFatAkali:addTS(ts)
	
	PrintChat("<font color='#66cc00'>Big Fat Akali</font><font color='#ffffff'> v. "..version.." </font><font color='#99ff99'>by Big Fat Nidalee,</font><font color='#66cc00'> loaded !</font>")
end 

function OnTick()

	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	
	orbwalkcheck()
	Target = getTarget()
	ts:update()
	
	if ValidTarget(Target) then
	KS()
	end 
	
	enemyMinions = {}
	enemyMinions = minionManager(MINION_ENEMY, QRange, myHero, MINION_SORT_HEALTH_ASC)
	
	if BigFatAkali.LastHit then
	LastHit_Farm()
		if BigFatAkali.FarmHarass.LastHit.HarassQ then
		Q_Harass()
		end 
	end 
	
	if BigFatAkali.LaneClear then
	LaneClear_Farm()
		if BigFatAkali.FarmHarass.LaneClear.HarassQ then
		Q_Harass()
		end 
	end 
	
	if BigFatAkali.MixedMode then
	MixedMode_Farm()
		if BigFatAkali.FarmHarass.MixedMode.HarassQ then
		Q_Harass()
		end 
	end 
	
	if ValidTarget(Target) then
	Marked = QMarked(Target)
	end 
	
	if BigFatAkali.Combo and ValidTarget(Target) then
	Combo()
	end 
	

	
end 

function LastHit_Farm()
	enemyMinions:update()
	for _, minion in ipairs(enemyMinions.objects) do
		if ValidTarget(minion) then
	--		if getDmg("AD", minion, myHero) * 1.1 > minion.health then
	--			myHero:Attack(minion)
	
			if BigFatAkali.FarmHarass.LastHit.UseQ and BigFatAkali.FarmHarass.LastHit.UseskillsonlyoutofAttackRange and not minion.dead and GetDistance(minion) <= QRange and AARange <= GetDistance(minion) and getDmg("Q", minion, myHero) > minion.health then
				if BigFatAkali.Other.debugmode then
				PrintChat("LastHit_Farm: Q")
				end
				if BigFatAkali.Other.UsePacketsCast then
				Packet("S_CAST", {spellId = _Q, targetNetworkId = minion.networkID}):send()
				else
				CastSpell(_Q, minion)
				end						
			elseif BigFatAkali.FarmHarass.LastHit.UseQ and not BigFatAkali.FarmHarass.LastHit.UseskillsonlyoutofAttackRange and not minion.dead and GetDistance(minion) <= QRange and getDmg("Q", minion, myHero) > minion.health then
				if BigFatAkali.Other.debugmode then
				PrintChat("LastHit_Farm: Q")
				end
				if BigFatAkali.Other.UsePacketsCast then
				Packet("S_CAST", {spellId = _Q, targetNetworkId = minion.networkID}):send()
				else
				CastSpell(_Q, minion)
				end						
			end 	
			if BigFatAkali.FarmHarass.LastHit.UseE and not QReady and not minion.dead and GetDistance(minion) <= ERange and getDmg("E", minion, myHero) > minion.health then
				if BigFatAkali.Other.debugmode then
				PrintChat("LastHit_Farm: E")
				end
				if BigFatAkali.Other.UsePacketsCast then
				Packet("S_CAST", {spellId = _E, targetNetworkId = minion.networkID}):send()
				else
				CastSpell(_E, minion)
				end						
			elseif BigFatAkali.FarmHarass.LastHit.UseE and QReady and not minion.dead and AARange <= GetDistance(minion) and GetDistance(minion) <= ERange and getDmg("E", minion, myHero) > minion.health then
				if BigFatAkali.Other.debugmode then
				PrintChat("LastHit_Farm: E")
				end
				if BigFatAkali.Other.UsePacketsCast then
				Packet("S_CAST", {spellId = _E, targetNetworkId = minion.networkID}):send()
				else
				CastSpell(_E, minion)
				end	
			end
			
			
		end
end 
end

function MixedMode_Farm()
	enemyMinions:update()
	for _, minion in ipairs(enemyMinions.objects) do
		if ValidTarget(minion) then
	--		if getDmg("AD", minion, myHero) * 1.1 > minion.health then
	--			myHero:Attack(minion)
	
			if BigFatAkali.FarmHarass.MixedMode.UseQ and BigFatAkali.FarmHarass.MixedMode.UseskillsonlyoutofAttackRange and not minion.dead and GetDistance(minion) <= QRange and AARange <= GetDistance(minion) and getDmg("Q", minion, myHero) > minion.health then
				if BigFatAkali.Other.debugmode then
				PrintChat("MixedMode_Farm: Q")
				end
				if BigFatAkali.Other.UsePacketsCast then
				Packet("S_CAST", {spellId = _Q, targetNetworkId = minion.networkID}):send()
				else
				CastSpell(_Q, minion)
				end						
			elseif BigFatAkali.FarmHarass.MixedMode.UseQ and not BigFatAkali.FarmHarass.MixedMode.UseskillsonlyoutofAttackRange and not minion.dead and GetDistance(minion) <= QRange and getDmg("Q", minion, myHero) > minion.health then
				if BigFatAkali.Other.debugmode then
				PrintChat("MixedMode_Farm: Q")
				end
				if BigFatAkali.Other.UsePacketsCast then
				Packet("S_CAST", {spellId = _Q, targetNetworkId = minion.networkID}):send()
				else
				CastSpell(_Q, minion)
				end						
			end 	
			if BigFatAkali.FarmHarass.MixedMode.UseE and not QReady and not minion.dead and GetDistance(minion) <= ERange and getDmg("E", minion, myHero) > minion.health then
				if BigFatAkali.Other.debugmode then
				PrintChat("MixedMode_Farm: E")
				end
				if BigFatAkali.Other.UsePacketsCast then
				Packet("S_CAST", {spellId = _E, targetNetworkId = minion.networkID}):send()
				else
				CastSpell(_E, minion)
				end						
			elseif BigFatAkali.FarmHarass.MixedMode.UseE and QReady and not minion.dead and AARange <= GetDistance(minion) and GetDistance(minion) <= ERange and getDmg("E", minion, myHero) > minion.health then
				if BigFatAkali.Other.debugmode then
				PrintChat("MixedMode_Farm: E")
				end
				if BigFatAkali.Other.UsePacketsCast then
				Packet("S_CAST", {spellId = _E, targetNetworkId = minion.networkID}):send()
				else
				CastSpell(_E, minion)
				end	
			end
			
			
		end
end 
end

function LaneClear_Farm()
	enemyMinions:update()
	for _, minion in ipairs(enemyMinions.objects) do
		if ValidTarget(minion) then
	--		if getDmg("AD", minion, myHero) * 1.1 > minion.health then
	--			myHero:Attack(minion)
	
			if BigFatAkali.FarmHarass.LaneClear.UseQ and BigFatAkali.FarmHarass.LaneClear.UseskillsonlyoutofAttackRange and not minion.dead and GetDistance(minion) <= QRange and AARange <= GetDistance(minion) and getDmg("Q", minion, myHero) > minion.health then
				if BigFatAkali.Other.debugmode then
				PrintChat("LaneClear_Farm: Q")
				end
				if BigFatAkali.Other.UsePacketsCast then
				Packet("S_CAST", {spellId = _Q, targetNetworkId = minion.networkID}):send()
				else
				CastSpell(_Q, minion)
				end						
			elseif BigFatAkali.FarmHarass.LaneClear.UseQ and not BigFatAkali.FarmHarass.LaneClear.UseskillsonlyoutofAttackRange and not minion.dead and GetDistance(minion) <= QRange and getDmg("Q", minion, myHero) > minion.health then
				if BigFatAkali.Other.debugmode then
				PrintChat("LaneClear_Farm: Q")
				end
				if BigFatAkali.Other.UsePacketsCast then
				Packet("S_CAST", {spellId = _Q, targetNetworkId = minion.networkID}):send()
				else
				CastSpell(_Q, minion)
				end						
			end 	
			if BigFatAkali.FarmHarass.LaneClear.UseE and not QReady and not minion.dead and GetDistance(minion) <= ERange and getDmg("E", minion, myHero) > minion.health then
				if BigFatAkali.Other.debugmode then
				PrintChat("LaneClear_Farm: E")
				end
				if BigFatAkali.Other.UsePacketsCast then
				Packet("S_CAST", {spellId = _E, targetNetworkId = minion.networkID}):send()
				else
				CastSpell(_E, minion)
				end						
			elseif BigFatAkali.FarmHarass.LaneClear.UseE and QReady and not minion.dead and AARange <= GetDistance(minion) and GetDistance(minion) <= ERange and getDmg("E", minion, myHero) > minion.health then
				if BigFatAkali.Other.debugmode then
				PrintChat("LaneClear_Farm: E")
				end
				if BigFatAkali.Other.UsePacketsCast then
				Packet("S_CAST", {spellId = _E, targetNetworkId = minion.networkID}):send()
				else
				CastSpell(_E, minion)
				end	
			end
			
			
		end
end 
end

function Q_Harass()
	
	if QReady and ValidTarget(Target) and GetDistance(Target) <= QRange and myHero.mana >= ManaCost(Q) then 
		if BigFatAkali.Other.debugmode then
		PrintChat("CastQ")
		end
		if BigFatAkali.Other.UsePacketsCast then
		Packet("S_CAST", {spellId = _Q, targetNetworkId = Target.networkID}):send()
		else
		CastSpell(_Q, Target)
		end					
	end
	
end 

function Combo()
	-- with ult

	if QReady and EReady and RReady then
		if GetDistance(Target) <= QRange and myHero.mana >= ManaCost(QE) then 

			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _Q, targetNetworkId = Target.networkID}):send()
			else
			CastSpell(_Q, Target)
			end	
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _R, targetNetworkId = Target.networkID}):send()
			else
			CastSpell(_R, Target)
			end
			
			if Marked then
				if BigFatAkali.Other.UsePacketsCast then
				Packet("S_CAST", {spellId = _E, targetNetworkId = Target.networkID}):send()
				else
				CastSpell(_E, Target)
				end
			end 
			
		elseif GetDistance(Target) >= QRange and GetDistance(Target) <= RRange and myHero.mana >= ManaCost(QE) then

			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _R, targetNetworkId = Target.networkID}):send()
			else
			CastSpell(_R, Target)
			end
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _Q, targetNetworkId = Target.networkID}):send()
			else
			CastSpell(_Q, Target)
			end	
			
			if Marked then
				if BigFatAkali.Other.UsePacketsCast then
				Packet("S_CAST", {spellId = _E, targetNetworkId = Target.networkID}):send()
				else
				CastSpell(_E, Target)
				end
			end 
		end
	elseif QReady and not EReady and RReady then
		if GetDistance(Target) <= QRange and myHero.mana >= ManaCost(Q) then 

			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _Q, targetNetworkId = Target.networkID}):send()
			else
			CastSpell(_Q, Target)
			end	
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _R, targetNetworkId = Target.networkID}):send()
			else
			CastSpell(_R, Target)
			end
			
			
		elseif GetDistance(Target) >= QRange and GetDistance(Target) <= RRange and myHero.mana >= ManaCost(Q) then
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _R, targetNetworkId = Target.networkID}):send()
			else
			CastSpell(_R, Target)
			end
			
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _Q, targetNetworkId = Target.networkID}):send()
			else
			CastSpell(_Q, Target)
			end	
			
		end
	elseif not QReady and EReady and RReady then
		if GetDistance(Target) <= ERange and myHero.mana >= ManaCost(E) then 
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _E, targetNetworkId = Target.networkID}):send()
			else
			CastSpell(_E, Target)
			end	
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _R, targetNetworkId = Target.networkID}):send()
			else
			CastSpell(_R, Target)
			end
			
		elseif GetDistance(Target) >= ERange and GetDistance(Target) <= RRange and myHero.mana >= ManaCost(E) then
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _R, targetNetworkId = Target.networkID}):send()
			else
			CastSpell(_R, Target)
			end
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _E, targetNetworkId = Target.networkID}):send()
			else
			CastSpell(_E, Target)
			end	
			
		end
	elseif QReady and EReady and not RReady then
		if GetDistance(Target) <= ERange and myHero.mana >= ManaCost(QE) then
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _Q, targetNetworkId = Target.networkID}):send()
			else
			CastSpell(_Q, Target)
			end	
			
			if Marked then
				if BigFatAkali.Other.UsePacketsCast then
				Packet("S_CAST", {spellId = _E, targetNetworkId = Target.networkID}):send()
				else
				CastSpell(_E, Target)
				end
			end 
			
		elseif GetDistance(Target) >= ERange and GetDistance(Target) <= QRange and myHero.mana >= ManaCost(QE) then
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _Q, targetNetworkId = Target.networkID}):send()
			else
			CastSpell(_Q, Target)
			end	
			
		end
	elseif QReady and not EReady and not RReady then
		if GetDistance(Target) <= QRange and myHero.mana >= ManaCost(Q) then
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _Q, targetNetworkId = Target.networkID}):send()
			else
			CastSpell(_Q, Target)
			end	
			
		end
	elseif RReady and not EReady and not QReady then
		if GetDistance(Target) <= RRange then
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _R, targetNetworkId = Target.networkID}):send()
			else
			CastSpell(_R, Target)
			end	
			
		end
	elseif EReady and not RReady and not QReady then
		if GetDistance(Target) <= ERange and myHero.mana >= ManaCost(E) then
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _E, targetNetworkId = Target.networkID}):send()
			else
			CastSpell(_E, Target)
			end	
		end
	end
end 

function ManaCost(spell)
	if spell == Q then
	return 60
	elseif spell == W then
	return 85 - (5 * myHero:GetSpellData(_W).level)
	elseif spell == E then
	return 65 - (5 * myHero:GetSpellData(_E).level)
	elseif spell == QE then
	return 60 + 65 - (5 * myHero:GetSpellData(_E).level)
	elseif spell == QW then
	return 60 + 85 - (5 * myHero:GetSpellData(_W).level)
	elseif spell == EW then
	return 65 - (5 * myHero:GetSpellData(_E).level) + 85 - (5 * myHero:GetSpellData(_W).level)
	end 
end		

function KS()
	
	for _, enemy in pairs(GetEnemyHeroes()) do
		if enemy and not enemy.dead then
	if QReady and EReady and RReady and BigFatAkali.KillSteal.UseQ and BigFatAkali.KillSteal.UseE and BigFatAkali.KillSteal.UseR and enemy.health < getDmg("Q", enemy, myHero) + getDmg("E", enemy, myHero) + getDmg("R", enemy, myHero) then
		if GetDistance(enemy) <= QRange and myHero.mana >= ManaCost(QE) then 

			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _Q, targetNetworkId = enemy.networkID}):send()
			else
			CastSpell(_Q, enemy)
			end	
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _R, targetNetworkId = enemy.networkID}):send()
			else
			CastSpell(_R, enemy)
			end
			
			if Marked then
				if BigFatAkali.Other.UsePacketsCast then
				Packet("S_CAST", {spellId = _E, targetNetworkId = enemy.networkID}):send()
				else
				CastSpell(_E, enemy)
				end
			end 
		if BigFatAkali.Other.Joke then SendChat("/j") end
		elseif GetDistance(enemy) >= QRange and GetDistance(enemy) <= RRange and myHero.mana >= ManaCost(QE) then

			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _R, targetNetworkId = enemy.networkID}):send()
			else
			CastSpell(_R, enemy)
			end
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _Q, targetNetworkId = enemy.networkID}):send()
			else
			CastSpell(_Q, enemy)
			end	
			
			if Marked then
				if BigFatAkali.Other.UsePacketsCast then
				Packet("S_CAST", {spellId = _E, targetNetworkId = enemy.networkID}):send()
				else
				CastSpell(_E, enemy)
				end
			end 
		if BigFatAkali.Other.Joke then SendChat("/j") end
		end
	elseif QReady and not EReady and RReady and BigFatAkali.KillSteal.UseQ and BigFatAkali.KillSteal.UseR and enemy.health < getDmg("Q", enemy, myHero) + getDmg("R", enemy, myHero) then
		if GetDistance(enemy) <= QRange and myHero.mana >= ManaCost(Q) then 

			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _Q, targetNetworkId = enemy.networkID}):send()
			else
			CastSpell(_Q, enemy)
			end	
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _R, targetNetworkId = enemy.networkID}):send()
			else
			CastSpell(_R, enemy)
			end
			
		if BigFatAkali.Other.Joke then SendChat("/j") end
		elseif GetDistance(enemy) >= QRange and GetDistance(enemy) <= RRange and myHero.mana >= ManaCost(Q) then
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _R, targetNetworkId = enemy.networkID}):send()
			else
			CastSpell(_R, enemy)
			end
			
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _Q, targetNetworkId = enemy.networkID}):send()
			else
			CastSpell(_Q, enemy)
			end	
		if BigFatAkali.Other.Joke then SendChat("/j") end
		end
	elseif not QReady and EReady and RReady and BigFatAkali.KillSteal.UseE and BigFatAkali.KillSteal.UseR and enemy.health < getDmg("E", enemy, myHero) + getDmg("R", enemy, myHero) then
		if GetDistance(enemy) <= ERange and myHero.mana >= ManaCost(E) then 
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _E, targetNetworkId = enemy.networkID}):send()
			else
			CastSpell(_E, enemy)
			end	
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _R, targetNetworkId = enemy.networkID}):send()
			else
			CastSpell(_R, enemy)
			end
		if BigFatAkali.Other.Joke then SendChat("/j") end
		elseif GetDistance(enemy) >= ERange and GetDistance(enemy) <= RRange and myHero.mana >= ManaCost(E) then
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _R, targetNetworkId = enemy.networkID}):send()
			else
			CastSpell(_R, enemy)
			end
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _E, targetNetworkId = enemy.networkID}):send()
			else
			CastSpell(_E, enemy)
			end	
		if BigFatAkali.Other.Joke then SendChat("/j") end
		end
	elseif QReady and EReady and not RReady and BigFatAkali.KillSteal.UseQ and BigFatAkali.KillSteal.UseE and enemy.health < getDmg("Q", enemy, myHero) + getDmg("E", enemy, myHero) then
		if GetDistance(enemy) <= ERange and myHero.mana >= ManaCost(QE) then
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _Q, targetNetworkId = enemy.networkID}):send()
			else
			CastSpell(_Q, enemy)
			end	
			
			if Marked then
				if BigFatAkali.Other.UsePacketsCast then
				Packet("S_CAST", {spellId = _E, targetNetworkId = enemy.networkID}):send()
				else
				CastSpell(_E, enemy)
				end
			end 
		if BigFatAkali.Other.Joke then SendChat("/j") end
		elseif GetDistance(enemy) >= ERange and GetDistance(enemy) <= QRange and myHero.mana >= ManaCost(QE) then
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _Q, targetNetworkId = enemy.networkID}):send()
			else
			CastSpell(_Q, enemy)
			end	
		if BigFatAkali.Other.Joke then SendChat("/j") end
		end
	elseif QReady and not EReady and not RReady and BigFatAkali.KillSteal.UseQ and enemy.health < getDmg("Q", enemy, myHero) then
		if GetDistance(enemy) <= QRange and myHero.mana >= ManaCost(Q) then
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _Q, targetNetworkId = enemy.networkID}):send()
			else
			CastSpell(_Q, enemy)
			end	
		if BigFatAkali.Other.Joke then SendChat("/j") end
		end
	elseif RReady and not EReady and not QReady and BigFatAkali.KillSteal.UseR and enemy.health < getDmg("R", enemy, myHero) then
		if GetDistance(enemy) <= RRange then
		
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _R, targetNetworkId = enemy.networkID}):send()
			else
			CastSpell(_R, enemy)
			end	
		if BigFatAkali.Other.Joke then SendChat("/j") end
		end
	elseif EReady and not RReady and not QReady and BigFatAkali.KillSteal.UseE and enemy.health < getDmg("E", enemy, myHero) then
		if GetDistance(enemy) <= ERange and myHero.mana >= ManaCost(E) then
			if BigFatAkali.Other.UsePacketsCast then
			Packet("S_CAST", {spellId = _E, targetNetworkId = enemy.networkID}):send()
			else
			CastSpell(_E, enemy)
			end
		if BigFatAkali.Other.Joke then SendChat("/j") end
		end
	end
		
		
		
		end
	end 
	
end 

	

function QMarked(Target)
	for i = 1, Target.buffCount, 1 do
		if Target:getBuff(i).name == "AkaliMota" and not myHero.dead then
			return true
		end
	end
	return false
end

function GTFO()


end 

--[SOW Block]--
function orbwalkcheck()
	if checkedMMASAC then return end
	if not (starttick + 5000 < GetTickCount()) then return end
	checkedMMASAC = true
    if _G.MMA_Loaded then
     	print(' >>Big Fat Jannas Assistant: MMA found. MMA support loaded.')
		is_MMA = true
	end	
	if _G.AutoCarry then
		print(' >>Big Fat Jannas Assistant: SAC found. SAC support loaded.')
		is_SAC = true
	end	
	if is_MMA then
		BigFatAkali.Orbwalk:addSubMenu("Marksman's Mighty Assistant", "mma")
		BigFatAkali.Orbwalk.mma:addParam("mmastatus", "Use MMA Target Selector", SCRIPT_PARAM_ONOFF, false)			
	end
	if is_SAC then
		BigFatAkali.Orbwalk:addSubMenu("Sida's Auto Carry", "sac")
		BigFatAkali.Orbwalk.sac:addParam("sacstatus", "Use SAC Target Selector", SCRIPT_PARAM_ONOFF, false)
	end
	if not is_SAC then
		BigFatAkali.Orbwalk:addParam("line", "----------------------------------------------------", SCRIPT_PARAM_INFO, "")
		BigFatAkali.Orbwalk:addParam("line", "", SCRIPT_PARAM_INFO, "")
		iSOW:LoadToMenu(BigFatAkali.Orbwalk)
	end
end
function getTarget()
	if not checkedMMASAC then return end
	if is_MMA and is_SAC then
		if JannaMen.BigFatAkali.Orbwalk.mma.mmastatus then
			BigFatAkali.Orbwalk.sac.sacstatus = false
			BigFatAkali.Orbwalk.standartts = false
		elseif BigFatAkali.Orbwalk.sac.sacstatus then
			BigFatAkali.Orbwalk.mma.mmastatus = false
			BigFatAkali.Orbwalk.standartts = false
		elseif	BigFatAkali.Orbwalk.standartts then
			BigFatAkali.Orbwalk.mma.mmastatus = false
			BigFatAkali.Orbwalk.sac.sacstatus = false
		end
	end	
	if not is_MMA and is_SAC then
		if BigFatAkali.Orbwalk.sac.sacstatus then
			BigFatAkali.Orbwalk.standartts = false
		else
			BigFatAkali.Orbwalk.standartts = true
		end	
	end
	if is_MMA and not is_SAC then
		if BigFatAkali.Orbwalk.mma.mmastatus then
			BigFatAkali.Orbwalk.standartts = false
		else
			BigFatAkali.Orbwalk.standartts = true
		end	
	end
	if not is_MMA and not is_SAC then
		BigFatAkali.Orbwalk.standartts = true	
	end	
	if _G.MMA_Target and _G.MMA_Target.type == myHero.type then
		return _G.MMA_Target 
	end
    if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then
		return _G.AutoCarry.Attack_Crosshair.target		
	end
    return ts.target	
end
--[/SOW Block]--

function _get_coordinates()

Spots = {

		worksWell = { 

						Locations = {

										{ x = 6513.39, 	y = 57.98, z = 5262.02},  -- Wraiths bottom
										{ x = 3450.85, 	y = 55.60, z = 6343.11},  -- Wolfes bottom
										{ x = 1712.00, 	y = 54.92, z = 8210.20},  -- one big wraith bottom
										{ x = 3709.18, 	y = 53.72, z = 7638.72},  -- Blue Buff bottom
										{ x = 7377.97, 	y = 57.02, z = 3878.71},  -- Red Buff bottom
										{ x = 7993.30, 	y = 54.27, z = 2626.95},  -- Golems bottom
										
										{ x = 7478.00, 	y = 55.50, z = 9222.91},  -- Wraiths top
										{ x = 4866.44, 	y = -62.97, z = 10330.44},  -- Nashor top
										{ x = 6513.58, 	y = 54.63, z = 10648.35},  -- Red Buff top
										{ x = 6010.06, 	y = 39.59, z = 11958.08},  -- Golems top
										{ x = 10439.40, y = 54.86, z = 6842.13},  -- Blue Buff top
										{ x = 10510.04, y = 65.72, z = 8070.11},  -- Wolfes top
										{ x = 12287.71, y = 54.82, z = 6318.46},  -- one big wraith top
									
									},

						color = green,

					}
					
}

end 

function OnDraw()

	if BigFatAkali.Draws.UselowfpsDraws then
		if QReady and BigFatAkali.Draws.DrawQRange and not myHero.dead then
		DrawCircleQ(myHero.x, myHero.y, myHero.z, QRange, ARGB(BigFatAkali.Draws.QSettings.colorAA[1],BigFatAkali.Draws.QSettings.colorAA[2],BigFatAkali.Draws.QSettings.colorAA[3],BigFatAkali.Draws.QSettings.colorAA[4]))
		end	
		if WReady and BigFatAkali.Draws.DrawWRange and not myHero.dead then
		DrawCircleW(myHero.x, myHero.y, myHero.z, WRange, ARGB(BigFatAkali.Draws.WSettings.colorAA[1],BigFatAkali.Draws.WSettings.colorAA[2],BigFatAkali.Draws.WSettings.colorAA[3],BigFatAkali.Draws.WSettings.colorAA[4]))
		end		
		if EReady and BigFatAkali.Draws.DrawERange and not myHero.dead then
		DrawCircleE(myHero.x, myHero.y, myHero.z, ERange, ARGB(BigFatAkali.Draws.ESettings.colorAA[1],BigFatAkali.Draws.ESettings.colorAA[2],BigFatAkali.Draws.ESettings.colorAA[3],BigFatAkali.Draws.ESettings.colorAA[4]))
		end		
		if RReady and BigFatAkali.Draws.DrawRRange and not myHero.dead then
		DrawCircleR(myHero.x, myHero.y, myHero.z, RRange, ARGB(BigFatAkali.Draws.RSettings.colorAA[1],BigFatAkali.Draws.RSettings.colorAA[2],BigFatAkali.Draws.RSettings.colorAA[3],BigFatAkali.Draws.RSettings.colorAA[4]))
		end	
	end
	
	if not BigFatAkali.Draws.UselowfpsDraws then
	if QReady then 
		if BigFatAkali.Draws.DrawQRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0x24ED24)
		end	
	end
	if WReady then 
		if BigFatAkali.Draws.DrawWRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0x24ED24)
		end
	end
	if EReady then 
		if BigFatAkali.Draws.DrawWRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0x24ED24)
		end
	end
	if RReady then 
		if BigFatAkali.Draws.DrawWRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0x24ED24)
		end
	end
	end
	

	-- spots
	
			-- nashor spots:
	if SRift == true then
		DrawCircle(5373.77, 55.15, 10218.25, 50, 0x24ED24)

		DrawCircle(5331.61, 54.62, 10509.46, 50, 0x24ED24)



	for i,group in pairs(Spots) do



				for x, Spot in pairs(group.Locations) do

					if GetDistance(Spot) < showLocationsInRange then

						if GetDistance(Spot, mousePos) <= 100 then

							pouncecolor = 0xFFFFFF

						else

							pouncecolor = group.color

						end

						--drawCircles(Spot.x, Spot.y, Spot.z,pouncecolor)
						DrawCircle(Spot.x, Spot.y, Spot.z, 400, 0x24ED24)
					end

				end


		
	end	
	end 
	
	
end 



--Q Range Circle QUality
function DrawCircleNextLvlQ(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(BigFatAkali.Draws.QSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
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
		DrawCircleNextLvlQ(x, y, z, radius, BigFatAkali.Draws.QSettings.width, color, 75)	
	end
end 	

--W Range Circle QUality
function DrawCircleNextLvlW(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(BigFatAkali.Draws.WSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
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
		DrawCircleNextLvlW(x, y, z, radius, BigFatAkali.Draws.WSettings.width, color, 75)	
	end
end 	
	

--E Range Circle QUality
function DrawCircleNextLvlE(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(BigFatAkali.Draws.ESettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end


--E Range Circle Width
function DrawCircleE(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlW(x, y, z, radius, BigFatAkali.Draws.ESettings.width, color, 75)	
	end
end 	
	

--R Range Circle QUality
function DrawCircleNextLvlR(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(BigFatAkali.Draws.RSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end


--R Range Circle Width
function DrawCircleR(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlW(x, y, z, radius, BigFatAkali.Draws.RSettings.width, color, 75)	
	end
end 	
