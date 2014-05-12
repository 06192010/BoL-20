local version = "0.6"
local TESTVERSION = false
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL/master/bfn_sona.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."bfn_sona.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>BFN sona:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL/master/versions/bfn_sona.version")
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


--[[
Original Script:			SonaHarass 1.2 by eXtragoZ
Changelog:					v01		-added menu control panel
							v02		-added prodiction ult
							v03		-added show in game 
							v04 	-added items 
							v05 	-added auto ult with min enemys
							v06 added autoupdate

]]--

if myHero.charName ~= "Sona" then return end

	local QRange = 650
	local WRange = 1000
	local ERange = 1000
	local RRange, RSpeed, RDelay, RWidth = 900, 2400, 0.250, 140

function OnLoad()
   require "Prodiction"
   require "AoE_Skillshot_Position"

    Prod = ProdictManager.GetInstance()
									-- range, speed, delay, width
    ProdR = Prod:AddProdictionObject(_R, RRange, RSpeed, RDelay, RWidth) 
    rPos = nil
	
	
	     for i = 1, heroManager.iCount do
           local hero = heroManager:GetHero(i)
           if hero.team ~= myHero.team then
           end
       end
	vars()
	LoadItems()
	SonaMenu()
	PrintChat("<font color='#c9d7ff'> SonaHarass 1.2 by eXtragoZ </font><font color='#64f879'> v."..version.." </font><font color='#c9d7ff'>Big Fat Nidalee Edition, loaded! </font>")
	
end

function OnTick()
	RREADY = (myHero:CanUseSpell(_R) == READY)
		
    if ValidTarget(Target) then
     ProdR:GetPredictionCallBack(Target, GetrPos)
    else
        rPos = nil
    end
		


    

    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        if hero.team ~= myHero.team then
		

        end
    end
	
    ts:update()
    Target = ts.target

	ItemsReadyCheck()

UltEnemys()
	
	
	
		if SonaMenu.Combo and SonaMenu.SpamQ and myHero:CanUseSpell(_Q) == READY then

		for i=1, heroManager.iCount do

			local enemy = heroManager:GetHero(i)

			if enemy.team ~= myHero.team and enemy.visible and enemy.dead == false and myHero:GetDistance(enemy) < QRange then

				CastSpell(_Q)
				UseItems(ts.target)

			end

		end

	end

	if SonaMenu.Combo and SonaMenu.SpamW and myHero:CanUseSpell(_W) == READY then

		for i=1, heroManager.iCount do

			local teammate = heroManager:GetHero(i)

			if teammate.team == myHero.team and teammate.visible and teammate.dead == false and teammate.health/teammate.maxHealth<=0.9 and myHero:GetDistance(teammate) < WRange then

				CastSpell(_W)

			end

		end

	end

	if SonaMenu.Combo and SonaMenu.SpamE and myHero:CanUseSpell(_E) == READY then
	

		for i=1, heroManager.iCount do

			local teammate = heroManager:GetHero(i)

			if teammate.team == myHero.team and teammate.visible and teammate.dead == false and myHero:GetDistance(teammate) < ERange then

				CastSpell(_E)

			end

		end

	end
end

function OnDraw()

	if SonaMenu.DrawQRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0xb9c3ed)
	end	
	
	if SonaMenu.DrawWERange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0x98a2cb)
	end	
	
	if SonaMenu.DrawRRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0x747ea4)
	end
	
end

function vars() 


	QReady, WReady, EReady, RReady  = false, false, false, false
	
	
end

function SonaMenu()
	SonaMenu = scriptConfig("BFN Sona", "BFN Sona")
	SonaMenu:addParam("sep", "~=[ BFN Sona v."..version.." ]=~", SCRIPT_PARAM_INFO, "")
	
	SonaMenu:addParam("Combo","Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	SonaMenu:addParam("SpamQ","Spam Q", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("Y"))
	SonaMenu:addParam("SpamW","Spam W", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("X"))
	SonaMenu:addParam("SpamE","Spam E", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("C"))
	
	SonaMenu:addParam("sep", "~=[ Ult Settings ]=~", SCRIPT_PARAM_INFO, "")
	SonaMenu:addParam("PredictUlt","Predict Ult", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("A"))
	
	SonaMenu:addParam("useult","Use Auto Ult", SCRIPT_PARAM_ONOFF, true)
	SonaMenu:addParam("ultenemys", "Auto Ult if X enemys in range", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)

	
	SonaMenu:addParam("sep", "~=[ Draws ]=~", SCRIPT_PARAM_INFO, "")
	SonaMenu:addParam("DrawQRange","Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	SonaMenu:addParam("DrawWERange","Draw W and E Range", SCRIPT_PARAM_ONOFF, false)
	SonaMenu:addParam("DrawRRange","Draw R Range", SCRIPT_PARAM_ONOFF, true)
	
	SonaMenu:addParam("sep", "~=[ NEEDS RELOAD ]=~", SCRIPT_PARAM_INFO, "")
	SonaMenu:addParam("ShowCombo", "Show Combo", SCRIPT_PARAM_ONOFF, true)
	if SonaMenu.ShowCombo then
	SonaMenu:permaShow("Combo")	
	end
	SonaMenu:addParam("ShowPredictUlt", "Show Predict Ult", SCRIPT_PARAM_ONOFF, true)
	if SonaMenu.ShowPredictUlt then
	SonaMenu:permaShow("PredictUlt")	
	end
	SonaMenu:addParam("ShowSpamQ", "Show Spam Q", SCRIPT_PARAM_ONOFF, true)
	if SonaMenu.ShowSpamQ then
	SonaMenu:permaShow("SpamQ")	
	end
	SonaMenu:addParam("ShowSpamW", "Show Spam W", SCRIPT_PARAM_ONOFF, true)
	if SonaMenu.ShowSpamW then
	SonaMenu:permaShow("SpamW")	
	end
	SonaMenu:addParam("ShowSpamE", "Show Spam E", SCRIPT_PARAM_ONOFF, true)
	if SonaMenu.ShowSpamE then
	SonaMenu:permaShow("SpamE")	
	end

	
    ts = TargetSelector(TARGET_LESS_CAST, 1400, true)
	ts.name = "SonaMenu"
    SonaMenu:addTS(ts)

end

-- prodiction
local function getHitBoxRadius(target)
        return GetDistance(target, target.minBBox)
end





function GetrPos(unit, pos)
        rPos = pos
end
function CastR(unit,pos)
    if (RREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < RRange) and myHero:GetSpellData(_R).name == "SonaCrescendo" then    

                CastSpell(_R, pos.x, pos.z)
    end
end

-- items
function LoadItems()
	
	BOTRKitem, DFGitem, Hextechitem, Bilgewateritem, Randuinsitem, FrostQueenitem, TwinShadowsitem = nil, nil, nil, nil, nil, nil, nil
	BRKREADY, DFGREADY, HXGREADY, BWCREADY, RNDREADY, FrostQueenREADY, TwinShadowsREADY, IREADY = false, false, false, false, false, false, false
	
end


function ItemsReadyCheck()

	
BOTRKitem, DFGitem, Hextechitem, Bilgewateritem, Randuinsitem, FrostQueenitem, TwinShadowsitem = 
GetInventorySlotItem(3153), GetInventorySlotItem(3128), GetInventorySlotItem(3146), 
GetInventorySlotItem(3144), GetInventorySlotItem(3143), GetInventorySlotItem(3092), GetInventorySlotItem(3023)

	DFGREADY = (DFGitem ~= nil and myHero:CanUseSpell(DFGitem) == READY)
	HXGREADY = (Hextechitem ~= nil and myHero:CanUseSpell(Hextechitem) == READY)
	BWCREADY = (Bilgewateritem ~= nil and myHero:CanUseSpell(Bilgewateritem) == READY)
	BRKREADY = (BOTRKitem ~= nil and myHero:CanUseSpell(BOTRKitem) == READY)
	FrostQueenREADY = (FrostQueenitem ~= nil and myHero:CanUseSpell(FrostQueenitem) == READY)
	TwinShadowsREADY = (TwinShadowsitem ~= nil and myHero:CanUseSpell(TwinShadowsitem) == READY)
	RNDREADY = (Randuinsitem ~= nil and myHero:CanUseSpell(Randuinsitem) == READY)

	
	
end

function UseItems(target)
	if GetDistance(target) < 550 then
		if DFGREADY then CastSpell(DFGitem, target) end
		if HXGREADY then CastSpell(Hextechitem, target) end
		if BWCREADY then CastSpell(Bilgewateritem, target) end
		if BRKREADY then CastSpell(BOTRKitem, target) end
		if FrostQueenREADY then CastSpell(FrostQueenitem, target) end
		if TwinShadowsREADY and GetDistance(target) < 1800 then CastSpell(TwinShadowsitem) end
		if RNDREADY and GetDistance(target) < 275 then CastSpell(Randuinsitem) end
	end
end


-- ult 

function UltEnemys()
		if RREADY and SonaMenu.useult then
		local tPos = GetAoESpellPosition(350, target)
		if tPos and GetDistance(tPos) <= 650 then
			if getenemysinrange(tPos, 400, 1150) >= SonaMenu.ultenemys then
				CastSpell(_R, tPos.x, tPos.z)
			end
		end
	end
end 

 function getenemysinrange(coord, range, circ)

        local ChampCount = 0
        for j = 1, heroManager.iCount, 1 do
                local enemyhero = heroManager:getHero(j)
                if myHero.team ~= enemyhero.team and ValidTarget(enemyhero, circ) then
                        if GetDistance(enemyhero, coord) <= range then
                                ChampCount = ChampCount + 1
                        end
                end
        end            
        return ChampCount
end

