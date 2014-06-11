if myHero.charName ~= "Graves" then return end

local version = "0.01"

local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL/master/prodiction1-projects/Common/SidasAutoCarryPlugin - Graves.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."/Common/SidasAutoCarryPlugin - Graves.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>BFN Graves:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL/master/versions/Graves.version")
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
local AArange = 610
local QRange, QSpeed, QDelay, QWidth = 950, 1950, 0.265, 85
local WRange, WSpeed, WDelay, WWidth = 950, 1650, 0.300, 250
local RRange, RSpeed, RDelay, RWidth, RWidth2 = 1000, 2100, 0.219, 55, 100

--local QRange, QSpeed, QDelay, QWidth = 920, 902, 0.250, 110
--local WRange, WSpeed, WDelay, WWidth = 900, 1650, 0.250, 250
--local RRange, RSpeed, RDelay, RWidth, RWidth2 = 1000, 1200, 0.250, 55, 100


--  HITCHANCE:   BLOCKED = 0   LOW = 1  NORMAL = 2  HIGH = 3  VERY_HIGH = 4
--	AutoCarry.MainMenu.MixedMode
--	AutoCarry.MainMenu.LastHit
--	AutoCarry.MainMenu.LaneClear


function PluginOnLoad()


	require "Collision"
	require "Prodiction1"

	
	AutoCarry.PluginMenu:addSubMenu("[Harass]", "Harass")
	AutoCarry.PluginMenu.Harass:addParam("info", "~=[ Harass Mixed Mode ]=~", SCRIPT_PARAM_INFO, "")
    AutoCarry.PluginMenu.Harass:addParam("Harass1UseQ","Use Q", SCRIPT_PARAM_ONOFF, true)
    AutoCarry.PluginMenu.Harass:addParam("Harass1UseW","Use W", SCRIPT_PARAM_ONOFF, false)
	AutoCarry.PluginMenu.Harass:addParam("ManaSliderHarass1", "Min mana to use skills",   SCRIPT_PARAM_SLICE, 55, 0, 100, 0)
	
	AutoCarry.PluginMenu.Harass:addParam("info", "~=[ Harass Lane Clear ]=~", SCRIPT_PARAM_INFO, "")
    AutoCarry.PluginMenu.Harass:addParam("Harass2UseQ","Use Q", SCRIPT_PARAM_ONOFF, true)
    AutoCarry.PluginMenu.Harass:addParam("Harass2UseW","Use W", SCRIPT_PARAM_ONOFF, false)
	AutoCarry.PluginMenu.Harass:addParam("ManaSliderHarass2", "Min mana to use skills",   SCRIPT_PARAM_SLICE, 55, 0, 100, 0)
	
	
	AutoCarry.PluginMenu:addSubMenu("[Prodiction Settings]", "ProdictionSettings")
	AutoCarry.PluginMenu.ProdictionSettings:addParam("UsePacketsCast","Use Packets Cast", SCRIPT_PARAM_ONOFF, true)
--	AutoCarry.PluginMenu.ProdictionSettings:addParam("info", "~=[ Callbacks ]=~", SCRIPT_PARAM_INFO, "")
--	AutoCarry.PluginMenu.ProdictionSettings:addParam("info", "~=[ IT DOESNT WORK NOW ]=~", SCRIPT_PARAM_INFO, "")
--	AutoCarry.PluginMenu.ProdictionSettings:addParam("OnDash","OnDash", SCRIPT_PARAM_ONOFF, false)
--	AutoCarry.PluginMenu.ProdictionSettings:addParam("AfterDash","AfterDash", SCRIPT_PARAM_ONOFF, false)
--	AutoCarry.PluginMenu.ProdictionSettings:addParam("OnImmobile","OnImmobile", SCRIPT_PARAM_ONOFF, false)
--	AutoCarry.PluginMenu.ProdictionSettings:addParam("AfterImmobile","AfterImmobile", SCRIPT_PARAM_ONOFF, false)
	
	AutoCarry.PluginMenu:addSubMenu("[KS Options]", "KSOptions")

	AutoCarry.PluginMenu.KSOptions:addParam("KSwithQ","KS with Q", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.KSOptions:addParam("KSwithW","KS with W", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.KSOptions:addParam("KSwithR","KS with R", SCRIPT_PARAM_ONOFF, true)
	
	AutoCarry.PluginMenu:addSubMenu("[Draws]", "Draws")
	AutoCarry.PluginMenu.Draws:addSubMenu("[AA Settings]", "AASettings")
	AutoCarry.PluginMenu.Draws.AASettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	AutoCarry.PluginMenu.Draws.AASettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	AutoCarry.PluginMenu.Draws.AASettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 0, 0, 360)
	AutoCarry.PluginMenu.Draws:addSubMenu("[Q Settings]", "QSettings")
	AutoCarry.PluginMenu.Draws.QSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	AutoCarry.PluginMenu.Draws.QSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	AutoCarry.PluginMenu.Draws.QSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 0, 0, 360)
	AutoCarry.PluginMenu.Draws:addSubMenu("[W Settings]", "WSettings")
	AutoCarry.PluginMenu.Draws.WSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	AutoCarry.PluginMenu.Draws.WSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	AutoCarry.PluginMenu.Draws.WSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 0, 0, 360)
	AutoCarry.PluginMenu.Draws:addSubMenu("[E Settings]", "ESettings")
	AutoCarry.PluginMenu.Draws.ESettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	AutoCarry.PluginMenu.Draws.ESettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	AutoCarry.PluginMenu.Draws.ESettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 0, 0, 360)
	AutoCarry.PluginMenu.Draws:addSubMenu("[R Settings]", "RSettings")
	AutoCarry.PluginMenu.Draws.RSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	AutoCarry.PluginMenu.Draws.RSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	AutoCarry.PluginMenu.Draws.RSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 0, 0, 360)
	AutoCarry.PluginMenu.Draws:addParam("DrawAARange","Draw AA Range", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.Draws:addParam("DrawQRange","Draw Q Range", SCRIPT_PARAM_ONOFF, false)
	AutoCarry.PluginMenu.Draws:addParam("DrawWRange","Draw W Range", SCRIPT_PARAM_ONOFF, false)
	AutoCarry.PluginMenu.Draws:addParam("DrawERange","Draw E Range", SCRIPT_PARAM_ONOFF, false)
	AutoCarry.PluginMenu.Draws:addParam("DrawRRange","Draw R Range", SCRIPT_PARAM_ONOFF, false)
	AutoCarry.PluginMenu.Draws:addParam("UselowfpsDraws","Use low fps Draws", SCRIPT_PARAM_ONOFF, true)
	
	AutoCarry.PluginMenu:addParam("info", "~=[ BFN Graves v"..version.." ]=~", SCRIPT_PARAM_INFO, "")


	if AutoCarry.Skills then IsSACReborn = true else IsSACReborn = false end

	-- Disable SAC Reborn's skills. Ours are better.
	if IsSACReborn then
		AutoCarry.Skills:DisableAll()
	end

	PrintChat("<font color='#c9d7ff'> BFN Graves </font><font color='#64f879'> "..version.." </font><font color='#c9d7ff'> loaded, happy elo boosting! </font>")



end 

function PluginOnTick()

	Target = AutoCarry.GetAttackTarget()
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)

	if Target and AutoCarry.MainMenu.AutoCarry then WQ() end
	if Target and AutoCarry.MainMenu.MixedMode then WQHarass1() end
	if Target and AutoCarry.MainMenu.LaneClear then WQHarass2() end
	KS()
	


end 

		
function KS()
	for i = 1, heroManager.iCount do
	local enemy = heroManager:getHero(i)
--	
		if QReady and AutoCarry.PluginMenu.KSOptions.KSwithQ and ValidTarget(enemy, QRange) and enemy.health < getDmg("Q",enemy,myHero) and myHero.mana >= ManaCost(Q) then
		local qpos, qinfo = Prodiction.GetPrediction(enemy, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local Qcoll = Collision(QRange, QSpeed, QDelay, QWidth)
		
		if qpos and qinfo.hitchance >= 2 and not Qcoll:GetMinionCollision(qpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
		end
--
		if WReady and AutoCarry.PluginMenu.KSOptions.KSwithW and ValidTarget(enemy, WRange) and enemy.health < getDmg("W",enemy,myHero)  then
		local wpos, winfo = Prodiction.GetPrediction(enemy, WRange, WSpeed, WDelay, WWidth, myPlayer)
		if wpos and winfo.hitchance >= 1 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, epos.x, epos.z)
			end
		end	
		end
--	
		if RReady and AutoCarry.PluginMenu.KSOptions.KSwithR and ValidTarget(enemy, RRange) and enemy.health < getDmg("R",enemy,myHero) and myHero.mana >= ManaCost(R) then
		local rpos, rinfo = Prodiction.GetPrediction(enemy, RRange, RSpeed, RDelay, RWidth, myPlayer)
		local coll = Collision(RRange, RSpeed, RDelay, RWidth2)
		
		if rpos and rinfo.hitchance >= 3 and not Rcoll:GetMinionCollision(rpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
			else 
			CastSpell(_R, rpos.x, rpos.z)
			end
		end	
		end
--
	end

end

function WQ ()
	if QReady and WReady and myHero.mana >= ManaCost(WQ) and GetDistance(Target) <= WRange then 
		local wpos, winfo = Prodiction.GetPrediction(Target, WRange, WSpeed, WDelay, WWidth, myPlayer)
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local Qcoll = Collision(QRange, QSpeed, QDelay, QWidth)
		
		
		if wpos and winfo.hitchance >= 2 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			end
		end	
		
		if qpos and qinfo.hitchance >= 2 and not Qcoll:GetMinionCollision(qpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
		
		
	elseif QReady and WReady and myHero.mana <= ManaCost(WQ) then 
		if myHero.mana >= ManaCost(Q) and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local Qcoll = Collision(QRange, QSpeed, QDelay, QWidth)
		
		if qpos and qinfo.hitchance >= 2 and not Qcoll:GetMinionCollision(qpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
		
		end 
	elseif QReady and not WReady and myHero.mana >= ManaCost(Q) and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local Qcoll = Collision(QRange, QSpeed, QDelay, QWidth)
		
		if qpos and qinfo.hitchance >= 2 and not Qcoll:GetMinionCollision(qpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
	end	
end



function WQHarass1 ()
	if AutoCarry.PluginMenu.Harass.Harass1UseQ and AutoCarry.PluginMenu.Harass.Harass1UseW and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass1) and QReady and WReady and myHero.mana >= ManaCost(WQ) and GetDistance(Target) <= WRange then 
		local wpos, winfo = Prodiction.GetPrediction(Target, WRange, WSpeed, WDelay, WWidth, myPlayer)
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local Qcoll = Collision(QRange, QSpeed, QDelay, QWidth)
		
		if wpos and winfo.hitchance >= 2 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			end
		end	
		
		
		if qpos and qinfo.hitchance >= 2 and not Qcoll:GetMinionCollision(qpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
		
	elseif AutoCarry.PluginMenu.Harass.Harass1UseQ and AutoCarry.PluginMenu.Harass.Harass1UseW and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass1) and QReady and WReady and myHero.mana <= ManaCost(WQ) then 
		if myHero.mana >= ManaCost(Q) and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local Qcoll = Collision(QRange, QSpeed, QDelay, QWidth)
		
		if qpos and qinfo.hitchance >= 2 and not Qcoll:GetMinionCollision(qpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
		
		end 
	elseif AutoCarry.PluginMenu.Harass.Harass1UseQ and AutoCarry.PluginMenu.Harass.Harass1UseW and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass1) and QReady and not WReady and myHero.mana >= ManaCost(Q) and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local Qcoll = Collision(QRange, QSpeed, QDelay, QWidth)
		
		if qpos and qinfo.hitchance >= 2 and not Qcoll:GetMinionCollision(qpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
	elseif AutoCarry.PluginMenu.Harass.Harass1UseQ and not AutoCarry.PluginMenu.Harass.Harass1UseW and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass1) and QReady and myHero.mana >= ManaCost(Q) and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local Qcoll = Collision(QRange, QSpeed, QDelay, QWidth)
		
		if qpos and qinfo.hitchance >= 2 and not Qcoll:GetMinionCollision(qpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
	elseif AutoCarry.PluginMenu.Harass.Harass1UseW and not AutoCarry.PluginMenu.Harass.Harass1UseQ and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass1) and WReady and myHero.mana >= ManaCost(W) and GetDistance(Target) <= WRange then
		local wpos, winfo = Prodiction.GetPrediction(Target, WRange, WSpeed, WDelay, WWidth, myPlayer)
		
		if wpos and winfo.hitchance >= 2 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			end
		end	
	end	
end  



function WQHarass2 ()
	if AutoCarry.PluginMenu.Harass.Harass2UseQ and AutoCarry.PluginMenu.Harass.Harass2UseW and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass2) and QReady and WReady and myHero.mana >= ManaCost(WQ) and GetDistance(Target) <= WRange then 
		local wpos, winfo = Prodiction.GetPrediction(Target, WRange, WSpeed, WDelay, WWidth, myPlayer)
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local Qcoll = Collision(QRange, QSpeed, QDelay, QWidth)
		
		if wpos and winfo.hitchance >= 2 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			end
		end	
		
		if qpos and qinfo.hitchance >= 2 and not Qcoll:GetMinionCollision(qpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
		
		
	elseif AutoCarry.PluginMenu.Harass.Harass2UseQ and AutoCarry.PluginMenu.Harass.Harass2UseW and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass2) and QReady and WReady and myHero.mana <= ManaCost(WQ) then 
		if myHero.mana >= ManaCost(Q) and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local Qcoll = Collision(QRange, QSpeed, QDelay, QWidth)
		
		if qpos and qinfo.hitchance >= 2 and not Qcoll:GetMinionCollision(qpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
		
		end 
	elseif AutoCarry.PluginMenu.Harass.Harass2UseQ and AutoCarry.PluginMenu.Harass.Harass2UseW and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass2) and QReady and not WReady and myHero.mana >= ManaCost(Q) and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local Qcoll = Collision(QRange, QSpeed, QDelay, QWidth)
		
		if qpos and qinfo.hitchance >= 2 and not Qcoll:GetMinionCollision(qpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
	elseif AutoCarry.PluginMenu.Harass.Harass2UseQ and not AutoCarry.PluginMenu.Harass.Harass2UseW and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass2) and QReady and myHero.mana >= ManaCost(Q) and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local Qcoll = Collision(QRange, QSpeed, QDelay, QWidth)
		
		if qpos and qinfo.hitchance >= 2 and not Qcoll:GetMinionCollision(qpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
	elseif AutoCarry.PluginMenu.Harass.Harass2UseW and not AutoCarry.PluginMenu.Harass.Harass2UseQ and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass2) and WReady and myHero.mana >= ManaCost(W) and GetDistance(Target) <= WRange then
		local wpos, winfo = Prodiction.GetPrediction(Target, WRange, WSpeed, WDelay, WWidth, myPlayer)
		
		if wpos and winfo.hitchance >= 2 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
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

function ManaCost(spell)
	if spell == Q then
		return 50 + (10 * myHero:GetSpellData(_Q).level)
	elseif spell == W then
		return 65 + (5 * myHero:GetSpellData(_W).level)
	elseif spell == R then
		return 100
	elseif spell == WQ then
		return 65 + (5 * myHero:GetSpellData(_W).level) + 50 + (10 * myHero:GetSpellData(_Q).level)
	end 
end			


function PluginOnDraw()

	if Target then
	TEST:DrawCollision(myHero, Target)
	end	

	if AutoCarry.PluginMenu.Draws.UselowfpsDraws and not myHero.dead then
		lowfpsdraws()
	end
	
	if not AutoCarry.PluginMenu.Draws.UselowfpsDraws then
	if AutoCarry.PluginMenu.Draws.DrawAARange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, AArange, 0xb9c3ed)
	end
	if QReady and AutoCarry.PluginMenu.Draws.DrawQRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0xb9c3ed)
	end 
	if WReady and AutoCarry.PluginMenu.Draws.DrawWRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0xb9c3ed)
	end 
	if EReady and AutoCarry.PluginMenu.Draws.DrawERange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0xb9c3ed)
	end 
	if RReady and AutoCarry.PluginMenu.Draws.DrawRRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0xb9c3ed)
	end 
	end 
end 



function lowfpsdraws()

	if AutoCarry.PluginMenu.Draws.DrawAARange then
		DrawCircleAA(myHero.x, myHero.y, myHero.z, AArange, ARGB(AutoCarry.PluginMenu.Draws.AASettings.colorAA[1],AutoCarry.PluginMenu.Draws.AASettings.colorAA[2],AutoCarry.PluginMenu.Draws.AASettings.colorAA[3],AutoCarry.PluginMenu.Draws.AASettings.colorAA[4]))
	end
	
	if QReady and AutoCarry.PluginMenu.Draws.DrawQRange then
		DrawCircleAA(myHero.x, myHero.y, myHero.z, QRange, ARGB(AutoCarry.PluginMenu.Draws.QSettings.colorAA[1],AutoCarry.PluginMenu.Draws.QSettings.colorAA[2],AutoCarry.PluginMenu.Draws.QSettings.colorAA[3],AutoCarry.PluginMenu.Draws.QSettings.colorAA[4]))
	end	
	if WReady and AutoCarry.PluginMenu.Draws.DrawWRange then
		DrawCircleAA(myHero.x, myHero.y, myHero.z, WRange, ARGB(AutoCarry.PluginMenu.Draws.WSettings.colorAA[1],AutoCarry.PluginMenu.Draws.WSettings.colorAA[2],AutoCarry.PluginMenu.Draws.WSettings.colorAA[3],AutoCarry.PluginMenu.Draws.WSettings.colorAA[4]))
	end	
	if EReady and AutoCarry.PluginMenu.Draws.DrawERange then
		DrawCircleAA(myHero.x, myHero.y, myHero.z, ERange, ARGB(AutoCarry.PluginMenu.Draws.ESettings.colorAA[1],AutoCarry.PluginMenu.Draws.ESettings.colorAA[2],AutoCarry.PluginMenu.Draws.ESettings.colorAA[3],AutoCarry.PluginMenu.Draws.ESettings.colorAA[4]))
	end	
	if RReady and AutoCarry.PluginMenu.Draws.DrawRRange then
		DrawCircleAA(myHero.x, myHero.y, myHero.z, RRange, ARGB(AutoCarry.PluginMenu.Draws.RSettings.colorAA[1],AutoCarry.PluginMenu.Draws.RSettings.colorAA[2],AutoCarry.PluginMenu.Draws.RSettings.colorAA[3],AutoCarry.PluginMenu.Draws.RSettings.colorAA[4]))
	end


end


--AA Range Circle QUality
function DrawCircleNextLvlAA(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(AutoCarry.PluginMenu.Draws.AASettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end


--AA Range Circle Width
function DrawCircleAA(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlAA(x, y, z, radius, AutoCarry.PluginMenu.Draws.AASettings.width, color, 75)	
	end
end 

--Q Range Circle QUality
function DrawCircleNextLvlAA(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(AutoCarry.PluginMenu.Draws.QSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
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
function DrawCircleAA(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlAA(x, y, z, radius, AutoCarry.PluginMenu.Draws.QSettings.width, color, 75)	
	end
end 	

--W Range Circle QUality
function DrawCircleNextLvlAA(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(AutoCarry.PluginMenu.Draws.WSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
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
function DrawCircleAA(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlAA(x, y, z, radius, AutoCarry.PluginMenu.Draws.WSettings.width, color, 75)	
	end
end 	
--E Range Circle QUality
function DrawCircleNextLvlAA(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(AutoCarry.PluginMenu.Draws.ESettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
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
function DrawCircleAA(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlAA(x, y, z, radius, AutoCarry.PluginMenu.Draws.ESettings.width, color, 75)	
	end
end 	
--R Range Circle QUality
function DrawCircleNextLvlAA(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(AutoCarry.PluginMenu.Draws.RSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
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
function DrawCircleAA(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlAA(x, y, z, radius, AutoCarry.PluginMenu.Draws.RSettings.width, color, 75)	
	end
end 		
