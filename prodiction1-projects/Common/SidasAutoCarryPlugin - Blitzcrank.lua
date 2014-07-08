
if myHero.charName ~= "Blitzcrank" or not VIP_USER then return end

local version = "1.1"

local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL/master/prodiction1-projects/Common/SidasAutoCarryPlugin - Blitzcrank.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."/Common/SidasAutoCarryPlugin - Corki.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Blitzcrank:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL/master/versions/Blitzcrank.version")
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

--[[ updated by Big Fat Nidale:
								- Removed old Prediction added Prodiction 1.3
								- updated Interrupt List
-- Original by pqmailer. Converted by Kain and updated.
]]--

function Vars()


	if AutoCarry.Skills then IsSACReborn = true else IsSACReborn = false end

	-- Disable SAC Reborn's skills. Ours are better.
	if IsSACReborn then
		AutoCarry.Skills:DisableAll()
	end

	KeyQ = string.byte("Q")
	KeyW = string.byte("W")
	KeyE = string.byte("E")
	KeyR = string.byte("R")

	QReady, WReady, EReady, RReady, IGNITEReady = nil, nil, nil, nil, nil
	IGNITESlot = nil
	enemyHeroes = nil

	ToInterrupt = {}
	InterruptList = {
		{ charName = "Caitlyn", spellName = "CaitlynAceintheHole"},
		{ charName = "FiddleSticks", spellName = "Crowstorm"},
		{ charName = "FiddleSticks", spellName = "DrainChannel"},
		{ charName = "Galio", spellName = "GalioIdolOfDurand"},
		{ charName = "Karthus", spellName = "FallenOne"},
		{ charName = "Katarina", spellName = "KatarinaR"},
		{ charName = "Malzahar", spellName = "AlZaharNetherGrasp"},
		{ charName = "MissFortune", spellName = "MissFortuneBulletTime"},
		{ charName = "Nunu", spellName = "AbsoluteZero"},
		{ charName = "Pantheon", spellName = "Pantheon_GrandSkyfall_Jump"},
		{ charName = "Pantheon", spellName = "PantheonRJump"},
		{ charName = "Shen", spellName = "ShenStandUnited"},
		{ charName = "Urgot", spellName = "UrgotSwap2"},
		{ charName = "Varus", spellName = "VarusQ"},
		{ charName = "Warwick", spellName = "InfiniteDuress"},
		{ charName = "Lucian", spellName = "LucianR"},
		{ charName = "Xerath", spellName = "XerathLocusOfPower2"},
		{ charName = "Xerath", spellName = "XerathArcanopulseChargeUp"},
		{ charName = "Velkoz", spellName = "VelkozR"},
		{ charName = "Zac", spellName = "ZacE"}
	}



	WRange, ERange, RRange = 200, 200, 600
	QRange, QSpeed, QDelay, QWidth, QWidth2 = 1050, 1800, 0.250, 60, 90
	RangeAD = 175


	IGNITESlot = ((myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") and SUMMONER_1) or (myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") and SUMMONER_2) or nil)

	enemyHeroes = GetEnemyHeroes()


	for _, enemy in pairs(enemyHeroes) do
		for _, champ in pairs(InterruptList) do
			if enemy.charName == champ.charName then
				table.insert(ToInterrupt, champ.spellName)
			end
		end
	end

	tick = nil

	Target = nil

	debugMode = false
end

function Menu()
	AutoCarry.PluginMenu:addParam("info0000", "", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("sep", "     Original Script by Kain: v 1.0 ", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("sep0", "     Updated by Big Fat Nidalee: v "..version.."", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("info000", "", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("ksR", "KS with R", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("interrupt", "Interrupt with R", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("printInterrupt", "Print Interrupts", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("autoIGN", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("drawCol", "Draw Collision", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("DrawQRange", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)

	AutoCarry.PluginMenu:addParam("info00", "----------------------------------", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("UsePacketsCast","Use Packets Cast", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("info0", "", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("QHitchance", "Q Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
	AutoCarry.PluginMenu:addParam("info2", "HITCHANCE:", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("info3", "LOW = 1  NORMAL = 2  HIGH = 3", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)

	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, QRange, DAMAGE_MAGIC or DAMAGE_PHYSICAL)
	ts.name = "Blitzcrank"
	AutoCarry.PluginMenu:addTS(ts)
end

function PluginOnLoad()

	require "Collision"
	require "Prodiction"

	AutoCarry.SkillsCrosshair.Range = 1100

	Vars()
	Menu()
	PrintChat("<font color='#c9d7ff'>BigFatNidalee's Blitz Edition: </font><font color='#64f879'> "..version.." </font><font color='#c9d7ff'> loaded, happy elo boosting! </font>")
end

function PluginOnTick()
	ts:update()
	if ts ~= nil and ts.target ~= nil then Target = ts.target else Target = nil end

	SpellCheck()

	if AutoCarry.PluginMenu.autoIGN then AutoIgnite() end
	if AutoCarry.PluginMenu.ksR then KSR() end
	if AutoCarry.MainMenu.AutoCarry then Combo() end
end



function PluginOnProcessSpell(unit, spell)
	if #ToInterrupt > 0 and AutoCarry.PluginMenu.interrupt and RReady then
		for _, ability in pairs(ToInterrupt) do
			if spell.name == ability and unit.team ~= myHero.team then
				if RRange >= GetDistance(unit) then
					CastSpell(_R)
					if AutoCarry.PluginMenu.printInterrupt then print("Tried to interrupt " .. spell.name) end
				end
			end
		end
	end
end

function SpellCheck()
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	IGNITEReady = (IGNITESlot ~= nil and myHero:CanUseSpell(IGNITESlot) == READY)
end

function AutoIgnite()
	if not IGNITEReady then return end

	for _, enemy in pairs(enemyHeroes) do
		if ValidTarget(enemy, 600) then
			if getDmg("IGNITE", enemy, myHero) >= enemy.health then
				CastSpell(IGNITESlot, enemy)
			end
		end
	end
end

function KSR()
	if not RReady then return end

	for _, enemy in pairs(enemyHeroes) do
		if ValidTarget(enemy, RRange) then
			if getDmg("R", enemy, myHero) >= enemy.health then
				CastSpell(_R)
			end
		end
	end
end

function Combo()
	if not Target then return end

	local Distance = GetDistance(Target)

	if Distance <= QRange and Distance > RangeAD then
		CastQ()
	end

	if Distance <= RangeAD then
		if EReady and AutoCarry.PluginMenu.useE then CastSpell(_E, Target) end
		if WReady and AutoCarry.PluginMenu.useW then CastSpell(_W) end
		myHero:Attack(Target)
	end
end

function CastQ()

	if QReady and GetDistance(Target) <= QRange then 
	
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local coll = Collision(QRange, QSpeed, QDelay, QWidth)
		--  HITCHANCE:   BLOCKED = 0   LOW = 1  NORMAL = 2  HIGH = 3  VERY_HIGH = 4
		if qpos and qinfo.hitchance >= AutoCarry.PluginMenu.QHitchance and not coll:GetMinionCollision(qpos, myHero) then		

			if AutoCarry.PluginMenu.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
		
		
	end	

end 

function PluginOnDraw()

		if QReady and AutoCarry.PluginMenu.DrawQRange and not myHero.dead then
		DrawCircleQ(myHero.x, myHero.y, myHero.z, QRange, ARGB(50,0,255,0))
		end	

	if QReady and AutoCarry.PluginMenu.drawCol then 
		if Target and not myHero.dead then
		local coll = Collision(QRange, QSpeed, QDelay, QWidth)
			if not coll:GetMinionCollision(Target, myHero) then
			DrawLine3D(myHero.x, myHero.y, myHero.z, Target.x, Target.y, Target.z, 60, ARGB(50,0,255,0))
			elseif coll:GetMinionCollision(Target, myHero) then
			DrawLine3D(myHero.x, myHero.y, myHero.z, Target.x, Target.y, Target.z, 60, ARGB(50,255,0,0))
			end
		end	
	end

end

--Q Range Circle QUality
function DrawCircleNextLvlQ(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(90/math.deg((math.asin((chordlength/(2*radius)))))))
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
		DrawCircleNextLvlQ(x, y, z, radius, 1, color, 75)	
	end
end 
	
function IsValid(enemy, dist)
	if enemy and enemy.valid and not enemy.dead and enemy.bTargetable and ValidTarget(enemy, dist) then
		return true
	else
		return false
	end
end

function IsNearRangeLimit(obj, range)
	if GetDistance(obj) >= (range * .95) then
		return true
	else
		return false
	end
end

function IsEnemyRetreating(target, predic)
	if GetDistance(predic) > GetDistance(target) then
		return true
	else
		return false
	end
end
