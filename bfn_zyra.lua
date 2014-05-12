-- Auto Update by Honda

local version = "0.01"
local TESTVERSION = false
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





if myHero.charName ~= "Zyra" then return end

-- skills ready
local QReady, WReady, EReady, RReady = false, false, false, false
-- skills self
local QRange, QSpeed, QDelay, QWidth = 800, math.huge, 0.7, 85
local WRange, WSpeed, WDelay, WWidth = 825, math.huge, 0.2432, 10
local ERange, ESpeed, EDelay, EWidth = 1050, 1150, 0.16, 70
local RRange, RSpeed, RDelay, RRadius = 700, math.huge, 0.500, 500
local PRange, PSpeed, PDelay, PWidth = 1470, 1870, 0.500, 60

local function getHitBoxRadius(target)
        return GetDistance(target, target.minBBox)
end

function OnLoad()
   require "Prodiction"
   Prod = ProdictManager.GetInstance()
   ProdQ = Prod:AddProdictionObject(_Q, QRange, QSpeed, QDelay, QWidth)
   ProdW = Prod:AddProdictionObject(_W, WRange, WSpeed, WDelay, WWidth) 
   ProdE = Prod:AddProdictionObject(_E, ERange, ESpeed, EDelay, EWidth) 
   pos = nil
   Menu()
   	PrintChat("<font color='#c9d7ff'> Zyra </font><font color='#64f879'> v."..version.." </font><font color='#c9d7ff'>Big Fat Nidalee Edition, loaded! </font>")
       for i = 1, heroManager.iCount do
           local hero = heroManager:GetHero(i)
           if hero.team ~= myHero.team then
			  ProdE:GetPredictionOnDash(hero, DashEFunc)
			  ProdE:GetPredictionAfterDash(hero, DashEFunc)
			  
           end
       end
end

function OnTick()
	ts:update()
    Target = ts.target
	SpellsReadyCheck()

	CastQW ()
	CastEW()
	Combo()
	UltGroup()

			
	    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        if hero.team ~= myHero.team then
		
        
            if ZyraMenu.OnDashE then
                ProdE:GetPredictionOnDash(hero, DashEFunc)
            else
                ProdE:GetPredictionOnDash(hero, DashEFunc, false)
            end           
            if ZyraMenu.AfterDashE then
                ProdE:GetPredictionAfterDash(hero, DashEFunc)
            else
                ProdE:GetPredictionAfterDash(hero, DashEFunc, false)
            end    

        end
    end

	                    
end 
function OnDraw()

	if ZyraMenu.DrawQWRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0xb9c3ed)
	end	
	
	if ZyraMenu.DrawERange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0x98a2cb)
	end	
	
	if ZyraMenu.DrawRRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0x747ea4)
	end
	
end
-- spellsreadycheck
function SpellsReadyCheck()

	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	
end


function Menu()

	ZyraMenu = scriptConfig("BFN Zyra", "BFN Zyra")
	ZyraMenu:addParam("sep", "~=[ BFN Zyra v."..version.." ]=~", SCRIPT_PARAM_INFO, "")
    ZyraMenu:addParam("Combo","Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)	
    ZyraMenu:addParam("QWCombo","Cast QW", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Y"))	
    ZyraMenu:addParam("EWCombo","Cast EW", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
    ZyraMenu:addParam("EWoverQW","EW over QW", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu:addParam("info", "~=[ Ult Setup ]=~", SCRIPT_PARAM_INFO, "")
	ZyraMenu:addParam("useult","Use Auto Ult", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu:addParam("UltGroupMinimum", "Ult Enemy Team Min.", SCRIPT_PARAM_SLICE, 3, 2, 5, 0)
	ZyraMenu:addParam("info", "~=[ USE CALLBACKS ]=~", SCRIPT_PARAM_INFO, "")
    ZyraMenu:addParam("AfterDashE","AfterDash E", SCRIPT_PARAM_ONOFF, true)
    ZyraMenu:addParam("OnDashE","OnDash E", SCRIPT_PARAM_ONOFF, false)
	ZyraMenu:addParam("info", "~=[ Draws ]=~", SCRIPT_PARAM_INFO, "")
	ZyraMenu:addParam("DrawQWRange","Draw Q and W Range", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu:addParam("DrawERange","Draw E Range", SCRIPT_PARAM_ONOFF, false)
	ZyraMenu:addParam("DrawRRange","Draw R Range", SCRIPT_PARAM_ONOFF, false)
	

	ts = TargetSelector(TARGET_LESS_CAST, 1400, DAMAGE_MAGIC, true)
	ts.name = "ZyraMenu"
    ZyraMenu:addTS(ts)

end

function CastQ(unit,pos)
    if (QReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) then    
                CastSpell(_Q, pos.x, pos.z)
    end
end
function CastW(unit,pos)
    if (WReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < WRange) then    
                CastSpell(_W, pos.x, pos.z)
    end
end
function CastE(unit,pos)
    if (EReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < ERange) then    
                CastSpell(_E, pos.x, pos.z)
    end
end

function CastQW()

	if ZyraMenu.QWCombo	and WReady and QReady and ValidTarget(Target) then
	
	ProdQ:GetPredictionCallBack(Target, CastQ)
	ProdW:GetPredictionCallBack(Target, CastW)
	end
	

end

function CastEW()

	if ZyraMenu.EWCombo	and WReady and EReady and ValidTarget(Target) then
	
	ProdE:GetPredictionCallBack(Target, CastE)
	ProdW:GetPredictionCallBack(Target, CastW)
	end
	

end

function Combo()

	if ZyraMenu.Combo and ZyraMenu.EWoverQW and WReady and EReady and ValidTarget(Target) then
	ProdE:GetPredictionCallBack(Target, CastE)
	ProdW:GetPredictionCallBack(Target, CastW)
	
	elseif ZyraMenu.Combo and ZyraMenu.EWoverQW and EReady and (myHero:CanUseSpell(_W) ~= READY) and ValidTarget(Target) then
	ProdE:GetPredictionCallBack(Target, CastE)
	
	elseif ZyraMenu.Combo and WReady and QReady  and ValidTarget(Target) then	
	ProdQ:GetPredictionCallBack(Target, CastQ)
	ProdW:GetPredictionCallBack(Target, CastW)
	
	elseif ZyraMenu.Combo and WReady and EReady and ValidTarget(Target) then	
	ProdE:GetPredictionCallBack(Target, CastE)
	ProdW:GetPredictionCallBack(Target, CastW)
	
	elseif ZyraMenu.Combo and EReady and (myHero:CanUseSpell(_W) ~= READY) and ValidTarget(Target) then	
	ProdE:GetPredictionCallBack(Target, CastE)
	
	elseif ZyraMenu.Combo and QReady and (myHero:CanUseSpell(_W) ~= READY) and ValidTarget(Target) then
	ProdQ:GetPredictionCallBack(Target, CastQ)
	end
	
	
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
function UltGroup(manual)
	if not ts or not ts.target then return false end

	if not manual and EnemyCount(myHero, (RRange + RRadius)) < ZyraMenu.UltGroupMinimum then return false end

	local spellPos = GetAoESpellPosition(RRadius, ts.target, RDelay * 1000)

	if spellPos and GetDistance(spellPos) <= RRange then
		if manual or EnemyCount(spellPos, RRadius) >= ZyraMenu.UltGroupMinimum then

			CastSpell(_R, spellPos.x, spellPos.z)
			return true
		end
	end

	return false
end

function DashEFunc(unit, pos, spell)

    if (EReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < ERange) then
                CastSpell(_E, pos.x, pos.z)
    end

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
