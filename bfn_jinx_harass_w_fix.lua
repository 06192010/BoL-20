if myHero.charName ~= "Jinx" then return end
local version = "0.001"

local AUTOUPDATE = true

local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL/master/bfn_jinx_harass_w_fix.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."bfn_jinx_harass_w_fix.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>BFN Jinx Harass W Fix:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL/master/versions/bfn_jinx_harass_w_fix.version")
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

local WReady = false
local WRange, WSpeed, WDelay, WWidth, WRangeCut = 1450, 3280, 0.580, 65, 1400

local function getHitBoxRadius(target)
		return GetDistance(target, target.minBBox)
end

function OnLoad()


	require "Prodiction"
	require "Collision"
	WCol = Collision(WRange, WSpeed, WDelay, WWidth)
	Prod = ProdictManager.GetInstance()
	ProdW = Prod:AddProdictionObject(_W, WRange, WSpeed, WDelay, WWidth)
	wPos = nil

	
	JinxHarassMenu = scriptConfig("BFN Jinx Harass", "Jinx Harass")
	ts = TargetSelector(TARGET_LESS_CAST, 1400, true)
	ts.name = "JinxHarassMenu"
    JinxHarassMenu:addTS(ts)
	
	JinxHarassMenu:addParam("harass1","Harass Mixed", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	JinxHarassMenu:addParam("harass2","Harass Lane Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	JinxHarassMenu:addParam("manaslider", "ManaSlider",   SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

	JinxHarassMenu:addParam("debugmode","Debug Mode", SCRIPT_PARAM_ONOFF, false)
	JinxHarassMenu:addParam("packets","Use Packets", SCRIPT_PARAM_ONOFF, true)


	JinxHarassMenu:addParam("info", "~=[ USE CALLBACKS ]=~", SCRIPT_PARAM_INFO, "")

	JinxHarassMenu:addParam("OnImmobile","OnImmobile", SCRIPT_PARAM_ONOFF, true)

	
	JinxHarassMenu:addParam("info", "~=[ Draws ]=~", SCRIPT_PARAM_INFO, "")
	JinxHarassMenu:addParam("showWrange","Draw W Range", SCRIPT_PARAM_ONOFF, false)
	

	JinxHarassMenu:addParam("sep", "~=[ NEEDS RELOAD ]=~", SCRIPT_PARAM_INFO, "")
	JinxHarassMenu:addParam("ShowMix", "Show Harass Mixed", SCRIPT_PARAM_ONOFF, true)
	if JinxHarassMenu.ShowMix then
	JinxHarassMenu:permaShow("harass1")	
	end
	JinxHarassMenu:addParam("ShowClear", "Show Harass Lane Clear", SCRIPT_PARAM_ONOFF, true)
	if JinxHarassMenu.ShowClear then
	JinxHarassMenu:permaShow("harass2")	
	end

	

	
	for i = 1, heroManager.iCount do
			local hero = heroManager:GetHero(i)
			if hero.team ~= myHero.team then

				ProdW:GetPredictionOnImmobile(hero, OnImmobileFunc)
			end
	end
	PrintChat("<font color='#c9d7ff'> BFN Jinx Harass </font><font color='#64f879'> "..version.." </font><font color='#c9d7ff'> loaded! </font>")


end


function OnTick()

	WReady = (myHero:CanUseSpell(_W) == READY)
	
	ts:update()
	Target = ts.target

	if ValidTarget(Target) then
	ProdW:GetPredictionCallBack(Target, GetWPos)
	else
	wPos = nil
	end
	
	if JinxHarassMenu.harass1 then
		if ValidTarget(Target) then
			ProdW:GetPredictionCallBack(Target, CastW)
		end
	end		
	if JinxHarassMenu.harass2 then
		if ValidTarget(Target) then
			ProdW:GetPredictionCallBack(Target, CastW)
		end
	end	
	
	
	for i = 1, heroManager.iCount do
	local hero = heroManager:GetHero(i)
		if hero.team ~= myHero.team then

			if KarmaMenu.OnImmobile then
				ProdW:GetPredictionOnImmobile(hero, OnImmobileFunc)
			else
				ProdW:GetPredictionOnImmobile(hero, OnImmobileFunc, false)
			end

		end
	end

	OnImmobilePos = nil
	
	
end

function OnDraw()

	if JinxHarassMenu.showWrange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0x98a2cb)
	end	

end 



function GetWPos(unit, pos)
	wPos = pos
end


function mynamaislowerthen(percent)
    if myHero.mana < (myHero.maxMana * ( percent / 100)) then
        return true
    else
        return false
    end
end


function CastW(unit,pos)

	if WReady and not mynamaislowerthen(JinxHarassMenu.manaslider) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < WRangeCut) then 
			local coll = Collision(WRange, WSpeed, WDelay, WWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				if JinxHarassMenu.packets then
					Packet("S_CAST", {spellId = _W, fromX =  pos.x, fromY =  pos.z, toX =  pos.x, toY =  pos.z}):send()
					if JinxHarassMenu.debugmode then
                        PrintChat("casted packets")
					end
				else
					CastSpell(_W, pos.x, pos.z)
					if JinxHarassMenu.debugmode then
                        PrintChat("casted normal")
					end
				end
			end
	end
end

function OnImmobileFunc(unit,pos)

	if WReady and not mynamaislowerthen(JinxHarassMenu.manaslider) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < WRangeCut) then  
			local coll = Collision(WRange, WSpeed, WDelay, WWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				if JinxHarassMenu.packets then
					Packet("S_CAST", {spellId = _W, fromX =  pos.x, fromY =  pos.z, toX =  pos.x, toY =  pos.z}):send()
					if JinxHarassMenu.debugmode then
                        PrintChat("OnImmobile: casted packets")
					end
				else
					CastSpell(_W, pos.x, pos.z)
					if JinxHarassMenu.debugmode then
                        PrintChat("OnImmobile: casted normal")
					end
				end
			end
	end
end

