if myHero.charName ~= "Karma" then return end
local version = "0.006"
local TESTVERSION = false

local AUTOUPDATE = true

local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL/master/bfn_karma.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."bfn_karma.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>BFN karma:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL/master/versions/bfn_karma.version")
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


-- main stuff

local QReady, WReady, EReady, RReady = false, false, false, false
local QRange, QSpeed, QDelay, QWidth = 950, 975, 0.250, 90
local WRange = 675

local function getHitBoxRadius(target)
		return GetDistance(target, target.minBBox)
end

function OnLoad()
	require "Prodiction"
	require "Collision"
	QCol = Collision(QRange, QSpeed, QDelay, QWidth)
	Prod = ProdictManager.GetInstance()
	ProdQ = Prod:AddProdictionObject(_Q, QRange, QSpeed, QDelay, QWidth)
	qPos = nil
	--menu
	
	KarmaMenu = scriptConfig("BFN Karma Helper", "Karma Helper")
	ts = TargetSelector(TARGET_LESS_CAST, 1400, true)
	ts.name = "KarmaMenu"
    KarmaMenu:addTS(ts)
	
	KarmaMenu:addParam("castq","RQ Cast", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	KarmaMenu:addParam("castrq","RQ/Q Spam ", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("Y"))
	KarmaMenu:addParam("castw","Auto W", SCRIPT_PARAM_ONOFF, true)
	KarmaMenu:addParam("gtfo", "GTFO - casts RE ASAP!", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("A"))

	KarmaMenu:addParam("info", "~=[ USE CALLBACKS ]=~", SCRIPT_PARAM_INFO, "")
	KarmaMenu:addParam("OnDash","OnDash", SCRIPT_PARAM_ONOFF, true)
	KarmaMenu:addParam("AfterDash","AfterDash", SCRIPT_PARAM_ONOFF, true)
	KarmaMenu:addParam("OnImmobile","OnImmobile", SCRIPT_PARAM_ONOFF, true)
	
	KarmaMenu:addParam("info", "~=[ Draws ]=~", SCRIPT_PARAM_INFO, "")
	KarmaMenu:addParam("showQrange","Draw Q Range", SCRIPT_PARAM_ONOFF, false)
	KarmaMenu:addParam("showWrange","Draw W Range", SCRIPT_PARAM_ONOFF, false)
	KarmaMenu:addParam("showQcollision","Draw Q Collision", SCRIPT_PARAM_ONOFF, false)
	
	
	KarmaMenu:addParam("info", "~=[ SETTINGS ]=~", SCRIPT_PARAM_INFO, "")
	KarmaMenu:addParam("debugmode","debug mode", SCRIPT_PARAM_ONOFF, false)
	
	KarmaMenu:addParam("sep", "~=[ NEEDS RELOAD ]=~", SCRIPT_PARAM_INFO, "")
	KarmaMenu:addParam("ShowRQCast", "Show RQ Cast", SCRIPT_PARAM_ONOFF, true)
	if KarmaMenu.ShowRQCast then
	KarmaMenu:permaShow("castq")	
	end
	KarmaMenu:addParam("ShowRQSpam", "Show RQ Spam", SCRIPT_PARAM_ONOFF, true)
	if KarmaMenu.ShowRQSpam then
	KarmaMenu:permaShow("castrq")	
	end
	KarmaMenu:addParam("Showautow", "Show Auto W", SCRIPT_PARAM_ONOFF, true)
	if KarmaMenu.Showautow then
	KarmaMenu:permaShow("castw")
	end
	
	KarmaConfig:addParam("showgtfo", "Show GTFO", SCRIPT_PARAM_ONOFF, true)
	if KarmaConfig.showgtfo then
	KarmaConfig:permaShow("gtfo")	
	end
	

	
	for i = 1, heroManager.iCount do
			local hero = heroManager:GetHero(i)
			if hero.team ~= myHero.team then
				ProdQ:GetPredictionOnDash(hero, OnDashFunc)
				ProdQ:GetPredictionAfterDash(hero, AfterDashFunc)
				ProdQ:GetPredictionOnImmobile(hero, OnImmobileFunc)
			end
	end
	PrintChat("<font color='#c9d7ff'> BIG FAT NIDALEE Karma Helper </font><font color='#64f879'> "..version.." </font><font color='#c9d7ff'> loaded! </font>")
end

function OnTick()
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	
	ts:update()
	Target = ts.target
	
	if ValidTarget(Target) then
		ProdQ:GetPredictionCallBack(Target, GetQPos)
	else
	qPos = nil
	end
	
	if KarmaMenu.castq then
		if ValidTarget(Target) then
			ProdQ:GetPredictionCallBack(Target, CastQ)
		end
	end	
	
	if KarmaMenu.castrq then
		if ValidTarget(Target) then
			ProdQ:GetPredictionCallBack(Target, CastRQ)
		end
	end
	
	if KarmaMenu.castw then
		CastW()
	end
	
if KarmaConfig.gtfo then
if myHero:CanUseSpell(_R) == READY and myHero:CanUseSpell(_E) == READY then
		CastSpell(_R)
		CastSpell(_E, myHero)
end
end

	for i = 1, heroManager.iCount do
		local hero = heroManager:GetHero(i)
		if hero.team ~= myHero.team then

			if KarmaMenu.OnDash then
				ProdQ:GetPredictionOnDash(hero, OnDashFunc)
			else
				ProdQ:GetPredictionOnDash(hero, OnDashFunc, false)
			end
			if KarmaMenu.AfterDash then
				ProdQ:GetPredictionAfterDash(hero, AfterDashFunc)
			else
				ProdQ:GetPredictionAfterDash(hero, AfterDashFunc, false)
			end
			if KarmaMenu.OnImmobile then
				ProdQ:GetPredictionOnImmobile(hero, OnImmobileFunc)
			else
				ProdQ:GetPredictionOnImmobile(hero, OnImmobileFunc, false)
			end

		end
	end
	AfterDashPos = nil	
	OnDashPos = nil

end

function OnDraw()

	if KarmaMenu.showQrange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0xb9c3ed)
	end	
	
	if KarmaMenu.showWrange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0x98a2cb)
	end	
	
	if Target and KarmaMenu.showQcollision and not myHero.dead then
	QCol:DrawCollision(myHero, Target)
	end
	
end

function GetQPos(unit, pos)
	qPos = pos
end
--[[
function CastQ(unit,pos)
	if (QReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then
		local coll = Collision(QRange, QSpeed, QDelay, QWidth)
		if not coll:GetMinionCollision(pos, myHero) then
			CastSpell(_Q, pos.x, pos.z)
			if KarmaMenu.debugmode then
			PrintChat("casting Q spell using CastQ function!")
			end
		end
	end
end
]]--

function CastW()
	if ValidTarget(Target) and WReady and GetDistance(Target) <= WRange then
	CastSpell(_W, Target)
	if KarmaMenu.debugmode then
		PrintChat("casting W spell using CastW function!")
	end
	end
end

function CastRQ(unit,pos)
	if (QReady)  and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then
		local coll = Collision(QRange, QSpeed, QDelay, QWidth)
		if not coll:GetMinionCollision(pos, myHero) then
			if RReady then
			CastSpell(_R)
			end 
			CastSpell(_Q, pos.x, pos.z)
			if KarmaMenu.debugmode then
			PrintChat("casting RQ spam using CastRQ function!")
			end
		end
	end
end

function CastQ(unit,pos)
	if (QReady) and (RReady)  and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then
		local coll = Collision(QRange, QSpeed, QDelay, QWidth)
		if not coll:GetMinionCollision(pos, myHero) then
			CastSpell(_R) 
			CastSpell(_Q, pos.x, pos.z)
			if KarmaMenu.debugmode then
			PrintChat("casting RQ combo using RQ Cast!")
			end
		end
	end
end


function OnImmobileFunc(unit,pos)
	if (QReady)  and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then
		local coll = Collision(QRange, QSpeed, QDelay, QWidth)
		if not coll:GetMinionCollision(pos, myHero) then
			if RReady then
			CastSpell(_R)
			end
			CastSpell(_Q, pos.x, pos.z)

--			if KarmaMenu.debugmode then
--			PrintChat("casting RQ using OnImmobile function!")
--			end
end

end 
end

function OnDashFunc(unit, pos, spell)

	if (WReady)  and (GetDistance(pos)  < WRange) then
--	local coll = Collision(QRange, QSpeed, QDelay, QWidth)
 --           if not coll:GetMinionCollision(pos, myHero) then
 --           CastSpell(_Q, pos.x, pos.z)
 	CastSpell(_W, Target)
			if KarmaMenu.debugmode then
			PrintChat("casting W using OnDashQFunc!")
			end
	end		


end

function AfterDashFunc(unit, pos, spell)

	if (WReady)  and (GetDistance(pos)  < WRange) then
--	local coll = Collision(QRange, QSpeed, QDelay, QWidth)
 --           if not coll:GetMinionCollision(pos, myHero) then
 --           CastSpell(_Q, pos.x, pos.z)
 	CastSpell(_W, Target)
			if KarmaMenu.debugmode then
			PrintChat("casting W using  AfterDashQFunc!")
			end
	end		

end



--[[
	QName	= "KarmaQ"
	QRange	= 950	-- old 1050
	QSpeed	= 902	-- old 1700
	QDelay	= 0.250	-- -0.5
	QWidth	= 90 	-- old 80	
	QUseCol	= true	
	
	
	
	
	range 950
	speed 902
	delay -0.5
	width 90
	
	]]--
