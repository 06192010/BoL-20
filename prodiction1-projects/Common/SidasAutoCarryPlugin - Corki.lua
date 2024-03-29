if myHero.charName ~= "Corki" then return end

local version = "0.09"

local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL/master/prodiction1-projects/Common/SidasAutoCarryPlugin - Corki.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."/Common/SidasAutoCarryPlugin - Corki.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>BFN Corki:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL/master/versions/corki.version")
if ServerData then
ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
if ServerVersion then
if tonumber(version) < ServerVersion then
AutoupdaterMsg("New version available" ..ServerVersion)
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

local Target = AutoCarry.GetAttackTarget()
local QReady, WReady, EReady, RReady = false, false, false, false
local QRange, QSpeed, QDelay, QWidth = 825, 1500, 0.350, 240
local WRange = 800
local ERange, ESpeed, EDelay, EWidth = 720, 902, 0.5, 100
local RRange, RSpeed, RDelay, RWidth = 1225, 2000, 0.165, 80
local ksfilter = false


function PluginOnLoad()


	require "Collision"
	require "Prodiction"

	
	AutoCarry.PluginMenu:addSubMenu("[Combo]", "Combo")
	AutoCarry.PluginMenu.Combo:addParam("UseQ","Use Q", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.Combo:addParam("UseE","Use E", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.Combo:addParam("UseR","Use R", SCRIPT_PARAM_ONOFF, true)
	
	AutoCarry.PluginMenu:addSubMenu("[Harass]", "Harass")
	AutoCarry.PluginMenu.Harass:addParam("info", "~=[ Harass Mixed Mode ]=~", SCRIPT_PARAM_INFO, "")
    AutoCarry.PluginMenu.Harass:addParam("Harass1UseQ","Use Q", SCRIPT_PARAM_ONOFF, true)
    AutoCarry.PluginMenu.Harass:addParam("Harass1UseE","Use E", SCRIPT_PARAM_ONOFF, false)
    AutoCarry.PluginMenu.Harass:addParam("Harass1UseR","Use R", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.Harass:addParam("ManaSliderHarass1", "Min mana to use skills",   SCRIPT_PARAM_SLICE, 55, 0, 100, 0)
	
	AutoCarry.PluginMenu.Harass:addParam("info", "~=[ Harass Lane Clear ]=~", SCRIPT_PARAM_INFO, "")
    AutoCarry.PluginMenu.Harass:addParam("Harass2UseQ","Use Q", SCRIPT_PARAM_ONOFF, true)
    AutoCarry.PluginMenu.Harass:addParam("Harass2UseE","Use E", SCRIPT_PARAM_ONOFF, false)
    AutoCarry.PluginMenu.Harass:addParam("Harass2UseR","Use R", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.Harass:addParam("ManaSliderHarass2", "Min mana to use skills",   SCRIPT_PARAM_SLICE, 55, 0, 100, 0)
	
	
	AutoCarry.PluginMenu:addSubMenu("[Prodiction Settings]", "ProdictionSettings")
	AutoCarry.PluginMenu.ProdictionSettings:addParam("UsePacketsCast","Use Packets Cast", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.ProdictionSettings:addParam("info0", "", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu.ProdictionSettings:addParam("QHitchance", "Q Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
	AutoCarry.PluginMenu.ProdictionSettings:addParam("EHitchance", "E Hitchance", SCRIPT_PARAM_SLICE, 1, 1, 3, 0)
	AutoCarry.PluginMenu.ProdictionSettings:addParam("RHitchance", "R Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
	AutoCarry.PluginMenu.ProdictionSettings:addParam("info", "", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu.ProdictionSettings:addParam("info2", "HITCHANCE:", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu.ProdictionSettings:addParam("info3", "LOW = 1  NORMAL = 2  HIGH = 3", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addSubMenu("[KS Options]", "KSOptions")

	AutoCarry.PluginMenu.KSOptions:addParam("KSwithQ","KS with Q", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.KSOptions:addParam("KSwithR","KS with R", SCRIPT_PARAM_ONOFF, true)
	
	
	AutoCarry.PluginMenu:addParam("info", "~=[ BFN Corki v"..version.." ]=~", SCRIPT_PARAM_INFO, "")

	

	if AutoCarry.Skills then IsSACReborn = true else IsSACReborn = false end

	-- Disable SAC Reborn's skills. Ours are better.
	if IsSACReborn then
		AutoCarry.Skills:DisableAll()
		AutoCarry.Plugins:RegisterBonusLastHitDamage(PassiveFarm)
	end
	
	
	
	PrintChat("<font color='#c9d7ff'> BigFatNidalee's Corki: </font><font color='#64f879'> "..version.." </font><font color='#c9d7ff'> loaded, happy elo boosting! </font>")



end 

function PluginOnTick()

	Target = AutoCarry.GetAttackTarget()
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	KS()
	if Target and AutoCarry.MainMenu.AutoCarry and not ksfilter == true then Combo() end
	if Target and AutoCarry.MainMenu.MixedMode and not ksfilter == true then Harass1() end
	if Target and AutoCarry.MainMenu.LaneClear and not ksfilter == true then Harass2() end
	

	


end 

 -- << --  -- << --  -- << --  -- << -- [KS]  -- >> --  -- >> --  -- >> --  -- >> --
 
function KS()
	for i = 1, heroManager.iCount do
	local enemy = heroManager:getHero(i)
--	
		if QReady and AutoCarry.PluginMenu.KSOptions.KSwithQ and ValidTarget(enemy, QRange) and not enemy.dead and enemy.health < getDmg("Q",enemy,myHero) and myHero.mana >= ManaCost(Q) then
		local qpos, qinfo = Prodiction.GetPrediction(enemy, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if qpos and qinfo.hitchance >= 2 then
			
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
			
		ksfilter = true 
		
		end	
		else ksfilter = false
		end
		

--
		if RReady and AutoCarry.PluginMenu.KSOptions.KSwithR and ValidTarget(enemy, RRange) and not enemy.dead and enemy.health < getDmg("R",enemy,myHero) and myHero.mana >= ManaCost(R) then
		local rpos, rinfo = Prodiction.GetPrediction(enemy, RRange, RSpeed, RDelay, RWidth, myPlayer)
		local coll = Collision(RRange, RSpeed, RDelay, RWidth)
		
		if rpos and rinfo.hitchance >= 2 and not coll:GetMinionCollision(rpos, myHero) then

			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
			else 
			CastSpell(_R, rpos.x, rpos.z)
			end
			
		ksfilter = true 
		
		end	
		else ksfilter = false
		end
--
--
		if RReady and QReady and AutoCarry.PluginMenu.KSOptions.KSwithR and AutoCarry.PluginMenu.KSOptions.KSwithQ and ValidTarget(enemy, QRange) and not enemy.dead and enemy.health < getDmg("R",enemy,myHero) + getDmg("Q",enemy,myHero) and myHero.mana >= ManaCost(R) then
		local rpos, rinfo = Prodiction.GetPrediction(enemy, RRange, RSpeed, RDelay, RWidth, myPlayer)
		local qpos, qinfo = Prodiction.GetPrediction(enemy, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local coll = Collision(RRange, RSpeed, RDelay, RWidth)
		
		if rpos and qpos and qinfo.hitchance >= 2 and not coll:GetMinionCollision(rpos, myHero) then

			
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
			
			
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
			else 
			CastSpell(_R, rpos.x, rpos.z)
			end
			
		ksfilter = true 
		
		end	
		else ksfilter = false
		end
--

	end

end

 -- << --  -- << --  -- << --  -- << -- [Passive]  -- >> --  -- >> --  -- >> --  -- >> --

function PassiveFarm(minion)
	return getDmg("P", minion, myHero)
end
 -- << --  -- << --  -- << --  -- << -- [COMBO]  -- >> --  -- >> --  -- >> --  -- >> --

function Combo()
	if not Target then return end
	
	if AutoCarry.PluginMenu.Combo.UseQ and QReady and myHero.mana >= ManaCost(Q) and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if qpos and qinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.QHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end			
	end 	
	if AutoCarry.PluginMenu.Combo.UseE and EReady and myHero.mana >= ManaCost(E) and GetDistance(Target) <= ERange then
		local epos, einfo = Prodiction.GetPrediction(Target, ERange, ESpeed, EDelay, EWidth, myPlayer)
		
		if epos and einfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.EHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _E, toX = epos.x, toY = epos.z, fromX = epos.x, fromY = epos.z}):send(true)
			else 
			CastSpell(_E, epos.x, epos.z)
			end
		end		
	end  	
	if AutoCarry.PluginMenu.Combo.UseR and RReady and myHero.mana >= ManaCost(R) and GetDistance(Target) <= RRange then
		local rpos, rinfo = Prodiction.GetPrediction(Target, RRange, RSpeed, RDelay, RWidth, myPlayer)
		local coll = Collision(RRange, RSpeed, RDelay, RWidth)
		
		if rpos and rinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.RHitchance and not coll:GetMinionCollision(rpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
			else 
			CastSpell(_R, rpos.x, rpos.z)
			end
		end		
	end 

end 

 -- << --  -- << --  -- << --  -- << -- [HARASS]  -- >> --  -- >> --  -- >> --  -- >> --
 
function Harass1()
	if not Target then return end
	
	if AutoCarry.PluginMenu.Harass.Harass1UseQ and QReady and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass1) and myHero.mana >= ManaCost(Q) and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if qpos and qinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.QHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end			
	end 	
	if AutoCarry.PluginMenu.Harass.Harass1UseE and EReady and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass1)  and GetDistance(Target) <= ERange then
		local epos, einfo = Prodiction.GetPrediction(Target, ERange, ESpeed, EDelay, EWidth, myPlayer)
		
		if epos and einfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.EHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _E, toX = epos.x, toY = epos.z, fromX = epos.x, fromY = epos.z}):send(true)
			else 
			CastSpell(_E, epos.x, epos.z)
			end
		end		
	end  	
	if AutoCarry.PluginMenu.Harass.Harass1UseR and RReady and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass1) and myHero.mana >= ManaCost(R) and GetDistance(Target) <= RRange then
		local rpos, rinfo = Prodiction.GetPrediction(Target, RRange, RSpeed, RDelay, RWidth, myPlayer)
		local coll = Collision(RRange, RSpeed, RDelay, RWidth)
		
		if rpos and rinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.RHitchance and not coll:GetMinionCollision(rpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
			else 
			CastSpell(_R, rpos.x, rpos.z)
			end
		end		
	end 

end 

function Harass2()
	if not Target then return end
	
	if AutoCarry.PluginMenu.Harass.Harass2UseQ and QReady and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass2) and myHero.mana >= ManaCost(Q) and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if qpos and qinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.QHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end			
	end 	
	if AutoCarry.PluginMenu.Harass.Harass2UseE and EReady and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass2)  and GetDistance(Target) <= ERange then
		local epos, einfo = Prodiction.GetPrediction(Target, ERange, ESpeed, EDelay, EWidth, myPlayer)
		
		if epos and einfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.EHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _E, toX = epos.x, toY = epos.z, fromX = epos.x, fromY = epos.z}):send(true)
			else 
			CastSpell(_E, epos.x, epos.z)
			end
		end		
	end  	
	if AutoCarry.PluginMenu.Harass.Harass2UseR and RReady and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass2) and myHero.mana >= ManaCost(R) and GetDistance(Target) <= RRange then
		local rpos, rinfo = Prodiction.GetPrediction(Target, RRange, RSpeed, RDelay, RWidth, myPlayer)
		local coll = Collision(RRange, RSpeed, RDelay, RWidth)
		
		if rpos and rinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.RHitchance and not coll:GetMinionCollision(rpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
			else 
			CastSpell(_R, rpos.x, rpos.z)
			end
		end		
	end 

end 


-- << --  -- << --  -- << --  -- << -- [MANA]  -- >> --  -- >> --  -- >> --  -- >> --
 
function mymanaislowerthen(percent)
    if myHero.mana < (myHero.maxMana * ( percent / 100)) then
        return true
    else
        return false
    end
end

function ManaCost(spell)
	if spell == Q then
		return 50 + (10 * myHero:GetSpellData(_Q).level)
	elseif spell == E then
		return 50
	elseif spell == QR then
		return 50 + (10 * myHero:GetSpellData(_Q).level) + 20
	elseif spell == R then
		return 20
	end
end			


