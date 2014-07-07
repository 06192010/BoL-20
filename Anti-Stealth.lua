
local version = "0.004"

local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL/master/Anti-Stealth.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."Anti-Stealth.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Anti-Stealth:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL/master/versions/Anti-Stealth.version")
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


local SCRIPT_NAME = "Anti-Stealth"
local OracleRange = 570

function OnLoad()

	_Menu()
	PrintChat("<font color='#c9d7ff'> Anti-Stealth by si7ziTV and Big Fat Nidalee </font><font color='#64f879'> "..version.." </font><font color='#c9d7ff'> loaded, happy elo boosting! </font>")
	Loaded = true
	
	StealthSpells = {

	["TwitchHideInShadows"]				= true, -- Twitch Q
	["KhazixR"]							= true, -- Khazix R
	["RengarR"]							= true, -- Rengar R
	["TalonShadowAssault"]				= true, -- Talon R
	["Deceive"]							= true, -- Shaco Q
		
	}
	

end 



function OnTick() 
	
	OracleCastRange = menu.setrange
	ReadyCheck()
	ts:update()
	Target = ts.target
	--and GetDistance(target) <= 400
		
end 

function OnGainBuff(unit, buff)
 
	if buff.name == "twitchhideinshadowsbuff" and GetDistance(unit) <= menu.setrange and unit.team ~= myHero.team then
		twitchinvisible = true
	end  
	if buff.name == "akaliwbuff" and GetDistance(unit) <= menu.setrange and unit.team ~= myHero.team then
		akaliinvisible = true
	end 
	if buff.name == "camouflagestealth" and GetDistance(unit) <= menu.setrange and unit.team ~= myHero.team then
		teemoinvisible = true
	end 
	if buff.name == "vaynetumblefade" and GetDistance(unit) <= menu.setrange and unit.team ~= myHero.team then
		vayneinvisible = true
	end	
	
	if twitchinvisible == true then 
		if OraclesLensReady and GetDistance(unit) <= menu.setrange then CastSpell(OraclesLens) end 
		if RengarOracleReady and GetDistance(unit) <= menu.setrange then CastSpell(RengarOracle) end 

	end
	
	if akaliinvisible == true then 
		if OraclesLensReady and GetDistance(unit) <= menu.setrange then CastSpell(OraclesLens) end 
		if RengarOracleReady and GetDistance(unit) <= menu.setrange  then CastSpell(RengarOracle) end 

	end	
	
	if teemoinvisible == true then 
		if OraclesLensReady and GetDistance(unit) <= menu.setrange then CastSpell(OraclesLens) end 
		if RengarOracleReady and GetDistance(unit) <= menu.setrange then CastSpell(RengarOracle) end 

	end
	if vayneinvisible == true then 
		if OraclesLensReady and GetDistance(unit) <= menu.setrange then CastSpell(OraclesLens) end 
		if RengarOracleReady and GetDistance(unit) <= menu.setrange then CastSpell(RengarOracle) end 

	end
end


function OnLoseBuff(unit, buff)

	if buff.name == "twitchhideinshadowsbuff" and GetDistance(unit) <= menu.setrange and unit.team ~= myHero.team then
		twitchinvisible = false
	end 
	if buff.name == "akaliwbuff" and GetDistance(unit) <= menu.setrange and unit.team ~= myHero.team then
		akaliinvisible = false
	end 
	if buff.name == "camouflagestealth" and GetDistance(unit) <= menu.setrange and unit.team ~= myHero.team then
	teemoinvisible = false
	end 
	if buff.name == "vaynetumblefade" and GetDistance(unit) <= menu.setrange and unit.team ~= myHero.team then
	vayneinvisible = false
	end 
end 

--[[
function OnProcessSpell(unit, spell)
	if "AkaliSmokeBomb" and unit.team ~= myHero.team  then 
		AkaliWStart = true
	end 
end 
]]--


function OnProcessSpell(unit, spell)
	if StealthSpells[spell.name] and unit.team ~= myHero.team  then 
	
	if OraclesLensReady and GetDistance(unit) <= menu.setrange then CastSpell(OraclesLens) end 
	if RengarOracleReady and GetDistance(unit) <= menu.setrange then CastSpell(RengarOracle) end 
	end

end


function ReadyCheck()
																																					--3364
	VisionWard, GreaterVisionTotem, OraclesLens, TwinShadows, TwinShadows2, RengarOracle = GetInventorySlotItem(2043), GetInventorySlotItem(3362), GetInventorySlotItem(3364), GetInventorySlotItem(3023), GetInventorySlotItem(3290), GetInventorySlotItem(3409)

	VisionWardReady = (VisionWard ~= nil and myHero:CanUseSpell(VisionWard) == READY)
	GreaterVisionTotemReady = (GreaterVisionTotem ~= nil and myHero:CanUseSpell(GreaterVisionTotem) == READY)
	OraclesLensReady = (OraclesLens ~= nil and myHero:CanUseSpell(OraclesLens) == READY)
	TwinShadowsReady = (TwinShadows ~= nil and myHero:CanUseSpell(TwinShadows) == READY)
	TwinShadows2Ready = (TwinShadows2 ~= nil and myHero:CanUseSpell(TwinShadows2) == READY)
	RengarOracleReady = (RengarOracle ~= nil and myHero:CanUseSpell(RengarOracle) == READY)
	
	

end


function printMessage(msg)
	print("<font color=\"#FE2E2E\"><b>"..SCRIPT_NAME..":</b></font> <font color=\"#FBEFEF\">"..msg..".</font>")
end

function _Menu()
	menu = scriptConfig("Anti-Stealth", "Anti-Stealth")
	menu:addParam("draworacle", "Draw Oracle Original Range", SCRIPT_PARAM_ONOFF, false)
	menu:addParam("draworaclecast", "Draw Oracle Cast Range", SCRIPT_PARAM_ONOFF, false)
	menu:addParam("setrange", "Set Oracle Cast Range", SCRIPT_PARAM_SLICE, 570, 570, 1000)
	
	ts = TargetSelector(TARGET_LESS_CAST, 1400, true)
	ts.name = "Antistealth"


end


function OnDraw ()

 if menu.draworaclecast then
DrawCircle(myHero.x, myHero.y, myHero.z, menu.setrange, 0xb9c3ed)
end 

 if menu.draworacle then
DrawCircle(myHero.x, myHero.y, myHero.z, 570, 0xb9c3ed)
end 

end 
