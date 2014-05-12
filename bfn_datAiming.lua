local version = "0.5"
local TESTVERSION = false
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL/master/bfn_datAiming.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."bfn_datAiming.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>BFN datAiming:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL/master/versions/bfn_datAiming.version")
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
	
	Script:				datAiming
	Author:				BIG FAT NIDALEE 
	Copyright:			2014
	
	CREDITS TO KLOKJE <333333333
	
	Description: 		This is just a rewritten version of imAiming for paid Prodiction 
						Champions pool = 62
						
	FAQ:				->>>>> Download this Script and place it into "Bol\Scripts" folder !
					 
	Change-log:
						0.1		finished script completely
						0.2		added collision check
						0.3		edited all champs values 
						0.3a	changed Throw to Predict
						0.4		fixed all critical issues!
						0.5 	added auto update 

]]--
function vars() 
	QReady, WReady, EReady, RReady  = false, false, false, false
end 
	local QName
	local QRange
	local QSpeed
	local QDelay
	local QWidth
	local QUseCol
	local WName
	local WSpeed
	local WDelay
	local WWidth
	local WUseCol
	local EName
	local ERange
	local ESpeed
	local EDelay
	local EWidth
	local EUseCol
	local RName
	local RRange
	local RSpeed
	local RDelay
	local RWidth
	local RUseCol
if myHero.charName == "Aatrox" then	
	QName	= "AatroxQ"
	QRange	= 650
	QSpeed	= 450 	-- MissileMax/MinSpeed	"20.0000"
	QDelay	= 0.27	-- DelayTotalTimePercent	-0.5
	QWidth	= 280 	-- 0 
	QUseCol	= true
	EName	= "AatroxE"
	ERange	= 1000	-- CastRangeDisplayOverride	"1000.0000"
	ESpeed	= 1200 
	EDelay	= 0.27	-- -0.5
	EWidth	= 150	-- old was 80
	EUseCol	= true
elseif myHero.charName == "Ahri" then
	QName	= "AhriOrbofDeception"
	QRange	= 880	-- old 895
	QSpeed	= 1100	-- old 1670
	QDelay	= 0.24	-- -0.5
	QWidth	= 100	-- LineWidth old was 50
	QUseCol	= true
	EName	= "AhriSeduce"
	ERange	= 975	-- old 920
	ESpeed	= 1200	-- old 1550
	EDelay	= 0.24	-- -0.5
	EWidth	= 60	-- old 80
	EUseCol	= true	
elseif myHero.charName == "Amumu" then
	QName	= "BandageToss"
	QRange	= 1100
	QSpeed	= 2000	-- MissileSpeed	"2000.0000"
	QDelay	= 0.250	-- -0.5
	QWidth	= 80
	QUseCol	= true	
elseif myHero.charName == "Anivia" then
	QName	= "FlashFrost"
	QRange	= 1100
	QSpeed	= 850	-- old 860.05
	QDelay	= 0.250	-- -0.5
	QWidth	= 110
	QUseCol	= true	
--[[
	RName	= "GlacialStorm"
	RRange	= 625
	RSpeed	= math.huge	-- MissileSpeed	"20.0000"
	RDelay	= 0.100		-- DelayTotalTimePercent	-0.3333, DelayTotalTimePercent	-0.3333
	RWidth	= 350
	RUseCol	= true	
]]--
elseif myHero.charName == "Annie" then
	WName	= "Incinerate"
	WRange	= 625
	WSpeed	= math.huge	-- 0
	WDelay	= 0.25		-- DelayTotalTimePercent	-0.5
	WWidth	= 0	
	WUseCol	= false
	RName	= "InfernalGuardian"
	RRange	= 600
	RSpeed	= math.huge
	RDelay	= 0.2	-- -.5
	RWidth	= 0	
	RUseCol	= false	
elseif myHero.charName == "Ashe" then
	WName	= "Volley"
	WRange	= 600 -- check it live 
	WSpeed	= 902
	WDelay	= 0.120	-- -0.5
	WWidth	= 0	
	WUseCol	= false
	RName	= "EnchantedCrystalArrow"
	RRange	= 2000
	RSpeed	= 1600
	RDelay	= 0.5	-- -0.5
	RWidth	= 130	-- old 0		
	RUseCol	= false
elseif myHero.charName == "Blitzcrank" then
	QName	= "RocketGrab"
	QRange	= 925	-- old 1000
	QSpeed	= 1800
	QDelay	= 0.250	-- -0.5
	QWidth	= 90	-- 70 original
	QUseCol	= true
elseif myHero.charName == "Brand" then
	QName	= "BrandBlaze"
	QRange	= 1050	-- 1100 old 
	QSpeed	= 1200	-- old 1600
	QDelay	= 0.625	-- -0.5
	QWidth	= 80	-- old 90 
	QUseCol	= true
	WName	= "BrandFissure"
	WRange	= 900	-- old 1100
	WSpeed	= 900	-- 20.000 original
	WDelay	= 0.25	-- -0.5
	WWidth	= 0
	WUseCol	= false
elseif myHero.charName == "Caitlyn" then
	QName	= "CaitlynPiltoverPeacemaker"
	QRange	= 1300
	QSpeed	= 2200
	QDelay	= 0.625	-- -0.5
	QWidth	= 90
	QUseCol	= false
	EName	= "CaitlynEntrapment"
	ERange	= 950	-- old 1000
	ESpeed	= 2000
	EDelay	= 0.400	-- -0.7
	EWidth	= 80
	EUseCol	= true	
elseif myHero.charName == "Cassiopeia" then
	QName	= "CassiopeiaNoxiousBlast"
	QRange	= 850
	QSpeed	= math.huge	-- original "20.0000"
	QDelay	= 0.535	-- -0.5
	QWidth	= 0
	QUseCol	= false
	WName	= "CassiopeiaMiasma"
	WRange	= 850
	WSpeed	= math.huge
	WDelay	= 0.350
	WWidth	= 80
	WUseCol	= true	
elseif myHero.charName == "Chogath" then
	QName	= "Rupture"
	QRange	= 950
	QSpeed	= 950 -- MissileSpeed	"20.0000"
	QDelay	= 0
	QWidth	= 0 -- CastRadius	"250.0000" O.O
	QUseCol	= false
	WName	= "FeralScream"
	WRange	= 700		-- CastRange	"300.0000"
	WSpeed	= math.huge	-- 0
	WDelay	= 0.25		-- 0
	WWidth	= 0			-- 0
	WUseCol	= false	
elseif myHero.charName == "Corki" then
	QName	= "PhosphorusBomb"
	QRange	= 825	-- 840 old 
	QSpeed	= 1500	-- 0
	QDelay	= 0.350	-- -0.5
	QWidth	= 0		-- 0
	QUseCol	= false
	RName	= "MissileBarrage"
	RRange	= 1225
	RSpeed	= 828.5	-- old 2000
	RDelay	= 0.200	-- -0.5
	RWidth	= 60	-- 40 original
	RUseCol	= true	
elseif myHero.charName == "Darius" then
	EName	= "DariusAxeGrabCone"
	ERange	= 550	-- old 530 
	ESpeed	= 1500
	EDelay	= 0.550	-- -0.5
	EWidth	= 0		-- 0
	EUseCol	= false
elseif myHero.charName == "Diana" then
	QName	= "DianaArc"
	QRange	= 900	-- old 830
	QSpeed	= 2000	-- MissileSpeed	"20.0000"
	QDelay	= 0.250	-- -0.5
	QWidth	= 0	
	QUseCol	= false
elseif myHero.charName == "DrMundo" then
	QName	= "InfectedCleaverMissileCast"
	QRange	= 900	-- old 1050
	QSpeed	= 1500	-- old 2000
	QDelay	= 0.250	-- -0.5
	QWidth	= 80	-- 75 original
	QUseCol	= true
elseif myHero.charName == "Draven" then
	EName	= "DravenDoubleShot"
	ERange	= 1050	-- old 1100
	ESpeed	= 1600	-- old 1400
	EDelay	= 0.250	-- -0.5
	EWidth	= 130	-- old 0
	EUseCol	= false
	RName	= "DravenRCast"
	RRange	= 2500
	RSpeed	= 2000
	RDelay	= 0.5	-- -0.5
	RWidth	= 160	-- old 0
	RUseCol	= false	
elseif myHero.charName == "Elise" then
	EName	= "EliseHumanE"
	ERange	= 1075	-- old 975
	ESpeed	= 1450
	EDelay	= 0.250	-- -0.5
	EWidth	= 80	-- original 70
	EUseCol	= true	
elseif myHero.charName == "Ezreal" then
	QName	= "EzrealMysticShot"
	QRange	= 1150	-- old 1200
	QSpeed	= 1200	-- old 2000
	QDelay	= 0.251	-- -0.5
	QWidth	= 80
	QUseCol	= true
	WName	= "EzrealEssenceFlux"
	WRange	= 1000	-- old 1050
	WSpeed	= 1200	-- old 1600
	WDelay	= 0.25	-- -0.5
	WWidth	= 80
	WUseCol	= false
	RName	= "EzrealTrueshotBarrage"
	RRange	= 20000
	RSpeed	= 2000
	RDelay	= 1		-- -0.5
	RWidth	= 150
	RUseCol	= true
elseif myHero.charName == "Fizz" then
	RName	= "FizzMarinerDoom"
	RRange	= 1300	-- old 1150
	RSpeed	= 1200	-- old 1350
	RDelay	= 0.250	-- -0.5
	RWidth	= 80	-- old 160
	RUseCol	= false	 -- ????????????????????
elseif myHero.charName == "Galio" then
	QName	= "GalioResoluteSmite"
	QRange	= 900	-- old 940
	QSpeed	= 1300	-- old 850
	QDelay	= 0.25	-- -0.5
	QWidth	= 120		-- old 0
	QUseCol	= false	
elseif myHero.charName == "Gragas" then
	QName	= "GragasBarrelRoll"
	QRange	= 1000 -- old 1100 , CastRangeDisplayOverride	"1000.0000",CastRange	"950.0000" 
	QSpeed	= 1000
	QDelay	= 0.250	-- -0.5
	QWidth	= 110	-- old 0
	WUseCol	= false	
elseif myHero.charName == "Graves" then
	QName	= "GravesClusterShot"
	QRange	= 700	-- old 950
	QSpeed	= 902	-- old 1950
	QDelay	= 0.265	-- -0.5
	QWidth	= 85	-- 0 original
	QUseCol	= true
	WName	= "GravesSmokeGrenade"
	WRange	= 900	-- old 950
	WSpeed	= 1650
	WDelay	= 0.300	-- -0.5
	WWidth	= 0
	WUseCol	= false
	RName	= "GravesChargeShot"
	RRange	= 1000
	RSpeed	= 1400	-- old 2100
	RDelay	= 0.219	-- -0.5
	RWidth	= 100	-- old 30 
	RUseCol	= true
elseif myHero.charName == "Heimerdinger" then
	WName	= "HeimerdingerW"
	WRange	= 1525	-- old 1100
	WSpeed	= 902	-- old 1200
	WDelay	= 0.200	-- -0.5
	WWidth	= 200	-- old 70
	WUseCol	= true
	EName	= "HeimerdingerE"
	ERange	= 925
	ESpeed	= 2500	-- old 1000
	EDelay	= 0.1	-- -0.5
	EWidth	= 120	-- old 85
	EUseCol	= true
elseif myHero.charName == "Irelia" then
	RName	= "IreliaTranscendentBlades"
	RRange	= 1000
	RSpeed	= 780	-- old 1700
	RDelay	= 0.250	-- -0.5
	RWidth	= 0	
	RUseCol	= false	
elseif myHero.charName == "JarvanIV" then
	QName	= "JarvanIVDragonStrike"
	QRange	= 770	-- old 800
	QSpeed	= 1400	-- MissileSpeed	"20.0000"
	QDelay	= 0.2	-- -0.5
	QWidth	= 70	-- old 60
	QUseCol	= true
	EName	= "JarvanIVDemacianStandard"
	ERange	= 860	-- old 850
	ESpeed	= 1450	-- old 200
	EDelay	= 0.2	-- -0.5
	EWidth	= 60	-- original 0
	EUseCol	= true	
elseif myHero.charName == "Jinx" then
	WName	= "JinxW"
	WRange	= 1450	-- old 1500
	WSpeed	= 1200	-- old 3000
	WDelay	= 0.600	-- -0.5
	WWidth	= 60
	WUseCol	= true
	EName	= "JinxE"
	ERange	= 900	-- old 950
	ESpeed	= 1750	-- old 887
	EDelay	= 0.500	-- -0.25
	EWidth	= 60	-- original 0
	EUseCol	= true	
	RName	= "JinxRWrapper"
	RRange	= 2500
	RSpeed	= 1200	-- old 2500
	RDelay	= 0.600	-- -0.5
	RWidth	= 120	-- old 60
	RUseCol	= true	
elseif myHero.charName == "Karma" then
	QName	= "KarmaQ"
	QRange	= 950	-- old 1050
	QSpeed	= 902	-- old 1700
	QDelay	= 0.250	-- -0.5
	QWidth	= 90 	-- old 80	
	QUseCol	= true	
elseif myHero.charName == "Karthus" then
	QName	= "LayWaste"
	QRange	= 875
	QSpeed	= 1750	-- MissileSpeed	"20.0000"
	QDelay	= 0.25	-- -0.5
	QWidth	= 0	
	QUseCol	= false	
elseif myHero.charName == "Kennen" then
	QName	= "KennenShurikenHurlMissile1"
	QRange	= 950	-- old 1050
	QSpeed	= 1700
	QDelay	= 0.180	-- -0.7-0.65
	QWidth	= 50 	-- old 70
	QUseCol	= true
elseif myHero.charName == "Khazix" then
	WName	= "KhazixW"
	WRange	= 1000
	WSpeed	= 828.5
	WDelay	= 0.225	-- -0.5
	WWidth	= 60	-- 100 old 
	WUseCol	= true
elseif myHero.charName == "KogMaw" then
	RName	= "KogMawLivingArtillery"
	RRange	= 1700	-- old 2200 / original 1200
	RSpeed	= 1050	-- MissileSpeed	"20.0000"
	RDelay	= 0.250	-- -0.5
	RWidth	= 0	
	RUseCol	= false	
elseif myHero.charName == "Leblanc" then
	EName	= "LeblancSoulShackle"
	ERange	= 925	-- old 960
	ESpeed	= 1600
	EDelay	= 0.250		-- -0.5
	EWidth	= 70		-- old 0
	EUseCol	= false
elseif myHero.charName == "LeeSin" then
	QName	= "BlindMonkQOne"
	QRange	= 1000	-- CastRange	"1100.0000", CastRangeDisplayOverride	"1000.0000"
	QSpeed	= 1800
	QDelay	= 0.250	-- -0.5
	QWidth	= 60	-- old 100
	QUseCol	= true	
elseif myHero.charName == "Leona" then

	EName	= "LeonaZenithBlade"
	ERange	= 875	-- old 900
	ESpeed	= 1200	-- old 2000
	EDelay	= 0.250	-- -0.5
	EWidth	= 80	-- old 0 	
	EUseCol	= false
	RName	= "LeonaSolarFlare"
	RRange	= 1200
	RSpeed	= 2000	-- MissileSpeed	"20.0000"
	RDelay	= 0.250	-- -0.5
	RWidth	= 0	
	RUseCol	= false	

elseif myHero.charName == "Lucian" then -- cant proof it cause no entry in riots decoder spelldata
	WName	= "LucianW"
	WRange	= 1000
	WSpeed	= 1470
	WDelay	= 0.288
	WWidth	= 25	
	WUseCol	= true	
elseif myHero.charName == "Lulu" then
	QName	= "LuluQ"
	QRange	= 925	-- old 945
	QSpeed	= 1530	-- MissileSpeed	"1400.0000", MissileMinSpeed	"1200.0000" 
	QDelay	= 0.250	-- -0.5
	QWidth	= 80
	QUseCol	= true	
elseif myHero.charName == "Lux" then
	QName	= "LuxLightBinding"
	QRange	= 1175	-- old 1300 
	QSpeed	= 1200
	QDelay	= 0.245	-- -0.5
	QWidth	= 80	-- 50 old 
	QUseCol	= true
	EName	= "LuxLightStrikeKugel"
	ERange	= 1100
	ESpeed	= 1300	-- old 1400
	EDelay	= 0.245	-- -0.5
	EWidth	= 0		-- CastRadius	"275.0000"
	EUseCol	= false	
	RName	= "LuxMaliceCannon"
	RRange	= 3500
	RSpeed	= math.huge
	RDelay	= 0.245
	RWidth	= 150	-- old 0 original 190
	RUseCol	= false	
elseif myHero.charName == "Mordekaiser" then
	EName	= "MordekaiserSyphonOfDestruction"
	ERange	= 700
	ESpeed	= math.huge
	EDelay	= 0.25	-- -0.5
	EWidth	= 0	
	EUseCol	= false	
elseif myHero.charName == "Morgana" then
	QName	= "DarkBindingMissile"
	QRange	= 1175	-- old 1300
	QSpeed	= 1200
	QDelay	= 0.250	-- -0.5
	QWidth	= 70	-- old 80
	QUseCol	= true	
elseif myHero.charName == "Nami" then
	QName	= "NamiQ"
	QRange	= 850
	QSpeed	= math.huge
	QDelay	= 0.8	-- 0
	QWidth	= 0	
	QUseCol	= false	
elseif myHero.charName == "Nautilus" then
	QName	= "NautilusAnchorDrag"
	QRange	= 950	-- old 1080
	QSpeed	= 1200	-- old 1300
	QDelay	= 0.250	-- -0.5
	QWidth	= 80	-- old 100 
	QUseCol	= true	
elseif myHero.charName == "Nidalee" then
	QName	= "JavelinToss"
	QRange	= 1500
	QSpeed	= 1300
	QDelay	= 0.125	-- 0
	QWidth	= 60
	QUseCol	= true	
elseif myHero.charName == "Nocturne" then
	QName	= "NocturneDuskbringer"
	QRange	= 1125	-- old 1200
	QSpeed	= 1400	-- old 1600
	QDelay	= 0.250	-- -0.5
	QWidth	= 60	-- old 0
	QUseCol	= false
elseif myHero.charName == "Olaf" then
	QName	= "OlafAxePredictCast"
	QRange	= 1000
	QSpeed	= 1600
	QDelay	= 0.25		-- -0.5
	QWidth	= 90		-- old 0
	QUseCol	= false	
elseif myHero.charName == "Quinn" then
	QName	= "QuinnQ"
	QRange	= 1025	-- old 1050
	QSpeed	= 1200	-- old 1600
	QDelay	= 0.25	-- -0.5
	QWidth	= 80	-- old 100
	QUseCol	= true	
elseif myHero.charName == "Rumble" then
	EName	= "RumbleGrenade"
	ERange	= 850	-- old 950
	ESpeed	= 1200	-- old 2000
	EDelay	= 0.250	-- -0.5
	EWidth	= 90	-- old 80	
	EUseCol	= true	
elseif myHero.charName == "Sejuani" then
	RName	= "SejuaniGlacialPrisonStart"
	RRange	= 1175
	RSpeed	= 1400		-- old 1300
	RDelay	= 0.200		-- -0.5
	RWidth	= 110		-- old 0
	RUseCol	= false
elseif myHero.charName == "Sivir" then
	QName	= "SivirQ"
	QRange	= 1075
	QSpeed	= 1350		-- old 1330
	QDelay	= 0.250		-- -0.5
	QWidth	= 90		-- old 0
	QUseCol	= false	
elseif myHero.charName == "Skarner" then
	EName	= "SkarnerFracture"
	ERange	= 760
	ESpeed	= 1200
	EDelay	= 0.250	-- -0.5
	EWidth	= 90	-- old 0	
	EUseCol	= false	
elseif myHero.charName == "Swain" then
	QName	= "SwainDecrepify"
	QRange	= 625	-- old 900
	QSpeed	= math.huge	-- original 0
	QDelay	= 0.500		-- -0.5
	QWidth	= 0		
	QUseCol	= false
elseif myHero.charName == "Syndra" then
	QName	= "SyndraQ"
	QRange	= 800
	QSpeed	= 1750	-- old math.huge
	QDelay	= 0.400	-- -0.25
	QWidth	= 0	
	QUseCol	= false	
elseif myHero.charName == "Thresh" then
	QName	= "ThreshQ"
	QRange	= 1075
	QSpeed	= 1200
	QDelay	= 0.500	-- -0.5
	QWidth	= 60
	QUseCol	= true	
	EName	= "ThreshE"
	ERange	= 500
	ESpeed	= 1100
	EDelay	= 0.250
	EWidth	= 180	
	EUseCol	= false	
elseif myHero.charName == "Twitch" then
	WName	= "TwitchVenomCask"
	WRange	= 900
	WSpeed	= 1750
	WDelay	= 0.283	-- -0.5
	WWidth	= 0	
	WUseCol	= false	
elseif myHero.charName == "TwistedFate" then
	QName	= "WildCards"
	QRange	= 1450	-- check it !!!
	QSpeed	= 1450
	QDelay	= 0.200	-- -0.5
	QWidth	= 0		
	QUseCol	= false	
elseif myHero.charName == "Urgot" then
	QName	= "UrgotHeatseekingMissile"
	QRange	= 1000
	QSpeed	= 1600
	QDelay	= 0.175	-- -0.7
	QWidth	= 100	-- original 0
	QUseCol	= true
	EName	= "UrgotPlasmaGrenade"
	ERange	= 900
	ESpeed	= 1750
	EDelay	= 0.25	-- -0.5
	EWidth	= 0	
	EUseCol	= false	
elseif myHero.charName == "Varus" then
	EName	= "VarusE"
	ERange	= 925
	ESpeed	= 1750		-- old 1500
	EDelay	= 0.245		-- -0.5
	EWidth	= 0	
	EUseCol	= false	
	RName	= "VarusR"
	RRange	= 1075	-- check it !
	RSpeed	= 1200	-- old 1950
	RDelay	= 0.5	-- -0.5
	RWidth	= 450	-- old 0
	RUseCol	= false	
elseif myHero.charName == "Veigar" then -- no data
	WName	= "VeigarDarkMatter"
	WRange	= 900
	WSpeed	= 900
	WDelay	= 0.25
	WWidth	= 0		-- -0.5
	WUseCol	= false	
elseif myHero.charName == "Viktor" then
	WName	= "ViktorGravitonField"
	WRange	= 625
	WSpeed	= math.huge
	WDelay	= 0.25
	WWidth	= 150		-- old 0
	WUseCol	= false
	EName	= "ViktorDeathRay"
	ERange	= 1225
	ESpeed	= 1200
	EDelay	= 0.25
	EWidth	= 90	
	EUseCol	= false
	RName	= "ViktorChaosStorm"
	RRange	= 700
	RSpeed	= 1000
	RDelay	= 0.25
	RWidth	= 0	
	RUseCol	= false
elseif myHero.charName == "Xerath" then
	QName	= "XerathArcanopulse"
	QRange	= 1025	-- old 1100
	QSpeed	= 3000
	QDelay	= 0.6	-- 0-> 1.75
	QWidth	= 100	
	QUseCol	= false
	RName	= "XerathArcaneBarrageWrapper"
	RRange	= 1100
	RSpeed	= 2000
	RDelay	= 0.25
	RWidth	= 0	
	RUseCol	= false	
elseif myHero.charName == "Zed" then
	QName	= "ZedShuriken"
	QRange	= 900	-- old 925
	QSpeed	= 902	-- old 1700
	QDelay	= 0.2	-- -0.5
	QWidth	= 45
	QUseCol	= false	
elseif myHero.charName == "Ziggs" then
	QName	= "ZiggsQ"
	QRange	= 850
	QSpeed	= 1750	-- old 1722
	QDelay	= 0.218	-- -0.25
	QWidth	= 0	
	QUseCol	= false
	WName	= "ZiggsW"
	WRange	= 1000
	WSpeed	= 1750	-- old 1727
	WDelay	= 0.249	-- -0.5
	WWidth	= 0	
	WUseCol	= false
	EName	= "ZiggsE"
	ERange	= 900
	ESpeed	= 1750	-- old 2694
	EDelay	= 0.125	-- -0.25
	EWidth	= 0	
	EUseCol	= false
	RName	= "ZiggsR"
	RRange	= 2500
	RSpeed	= 1750		-- old 1856
	RDelay	= 0.1014	-- -0.25
	RWidth	= 0	
	RUseCol	= false
elseif myHero.charName == "Zyra" then
	QName	= "ZyraQFissure"
	QRange	= 800
	QSpeed	= math.huge
	QDelay	= 0.7		-- -0.5
	QWidth	= 85		-- old 0
	QUseCol	= false
	EName	= "ZyraGraspingRoots"
	ERange	= 1100
	ESpeed	= 1150
	EDelay	= 0.16		-- -0.5
	EWidth	= 70
	EUseCol	= false
end 
local function getHitBoxRadius(target)
        return GetDistance(target, target.minBBox)
end	
function OnLoad()
    require "Prodiction"
    require "Collision"
	vars()
	ProdictionSetup()
	PutCallbacksOn()
	datAimingMenu()
	PrintChat("<font color='#c9d7ff'> datAiming </font><font color='#64f879'> v."..version.." </font><font color='#c9d7ff'>by BIG FAT NIDALEE, loaded! </font>")
end 
function OnTick()
	ts:update()
    Target = ts.target
	SkillsReadyChecker()
	AimTarget()
	CastProdiction()
	OnOffCallbacksViaMenu()
end 
	
function OnDraw()
	if QName ~= nil then
		if QUseCol	== true then
			if Target and datAiming.Qsettings.showQcollision and not myHero.dead then
			QCol:DrawCollision(myHero, Target)
			end	
		end
	end 
	if WName ~= nil then
		if WUseCol	== true then
			if Target and datAiming.Wsettings.showWcollision and not myHero.dead then
			WCol:DrawCollision(myHero, Target)
			end	
		end
	end 
	if EName ~= nil then
		if EUseCol	== true then
			if Target and datAiming.Esettings.showEcollision and not myHero.dead then
			ECol:DrawCollision(myHero, Target)
			end	
		end
	end 
	if RName ~= nil then
		if RUseCol	== true then
			if Target and datAiming.Rsettings.showRcollision and not myHero.dead then
			RCol:DrawCollision(myHero, Target)
			end	
		end
	end 
	if QName ~= nil then
		if datAiming.Qsettings.showQrange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0xb9c3ed)
		end	
	end 
	if WName ~= nil then
		if datAiming.Wsettings.showWrange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0x98a2cb)
		end	
	end 
	if EName ~= nil then
		if datAiming.Esettings.showErange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0x747ea4)
		end	
	end 
	if RName ~= nil then
		if datAiming.Rsettings.showRrange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0x595959)
		end	
	end 
end 
function datAimingMenu()
	datAiming = scriptConfig("datAiming", "datAiming")
	datAiming:addParam("sep", "~=[ datAiming v."..version.." ]=~", SCRIPT_PARAM_INFO, "")
	if QName ~= nil then
	datAiming:addSubMenu("[Q Settings]", "Qsettings")
    datAiming.Qsettings:addParam("PredictQ","Predict Q", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Y"))

	datAiming.Qsettings:addParam("sep", "~=[ USE CALLBACKS ]=~", SCRIPT_PARAM_INFO, "")
    datAiming.Qsettings:addParam("OnDashQ","OnDash Q", SCRIPT_PARAM_ONOFF, true)
    datAiming.Qsettings:addParam("AfterDashQ","AfterDash Q", SCRIPT_PARAM_ONOFF, true)
    datAiming.Qsettings:addParam("AfterImmobileQ","AfterImmobile Q", SCRIPT_PARAM_ONOFF, true)
    datAiming.Qsettings:addParam("OnImmobileQ","OnImmobile Q", SCRIPT_PARAM_ONOFF, true)
	datAiming.Qsettings:addParam("sep", "~=[ DRAWS ]=~", SCRIPT_PARAM_INFO, "")
	datAiming.Qsettings:addParam("showQrange", "Show Q Range", SCRIPT_PARAM_ONOFF, false)
	if QUseCol	== true then
	datAiming.Qsettings:addParam("showQcollision", "Show Q Collision", SCRIPT_PARAM_ONOFF, false)
	end
	datAiming.Qsettings:addParam("sep", "~=[ NEEDS RELOAD ]=~", SCRIPT_PARAM_INFO, "")
	datAiming.Qsettings:addParam("ShowPredictQ", "Show Predict Q", SCRIPT_PARAM_ONOFF, false)
			if datAiming.Qsettings.ShowPredictQ then
			datAiming.Qsettings:permaShow("PredictQ")	
		end
	end 
	if WName ~= nil then
	datAiming:addSubMenu("[W Settings]", "Wsettings")
    datAiming.Wsettings:addParam("PredictW","Predict W", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))

	datAiming.Wsettings:addParam("sep", "~=[ USE CALLBACKS ]=~", SCRIPT_PARAM_INFO, "")
    datAiming.Wsettings:addParam("OnDashW","OnDash W", SCRIPT_PARAM_ONOFF, true)
    datAiming.Wsettings:addParam("AfterDashW","AfterDash W", SCRIPT_PARAM_ONOFF, true)
    datAiming.Wsettings:addParam("AfterImmobileW","AfterImmobile W", SCRIPT_PARAM_ONOFF, true)
    datAiming.Wsettings:addParam("OnImmobileW","OnImmobile W", SCRIPT_PARAM_ONOFF, true)
	datAiming.Wsettings:addParam("sep", "~=[ DRAWS ]=~", SCRIPT_PARAM_INFO, "")
	datAiming.Wsettings:addParam("showWrange", "Show W Range", SCRIPT_PARAM_ONOFF, false)
	if WUseCol	== true then
	datAiming.Wsettings:addParam("showWcollision", "Show W Collision", SCRIPT_PARAM_ONOFF, false)
	end	
	datAiming.Wsettings:addParam("sep", "~=[ NEEDS RELOAD ]=~", SCRIPT_PARAM_INFO, "")
	datAiming.Wsettings:addParam("ShowPredictW", "Show Predict W", SCRIPT_PARAM_ONOFF, false)
			if datAiming.Wsettings.ShowPredictW then
			datAiming.Wsettings:permaShow("PredictW")	
		end
	end 
	if EName ~= nil then
	datAiming:addSubMenu("[E Settings]", "Esettings")
    datAiming.Esettings:addParam("PredictE","Predict E", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))

	datAiming.Esettings:addParam("sep", "~=[ USE CALLBACKS ]=~", SCRIPT_PARAM_INFO, "")
    datAiming.Esettings:addParam("OnDashE","OnDash E", SCRIPT_PARAM_ONOFF, true)
    datAiming.Esettings:addParam("AfterDashE","AfterDash E", SCRIPT_PARAM_ONOFF, true)
    datAiming.Esettings:addParam("AfterImmobileE","AfterImmobile E", SCRIPT_PARAM_ONOFF, true)
    datAiming.Esettings:addParam("OnImmobileE","OnImmobile E", SCRIPT_PARAM_ONOFF, true)
	datAiming.Esettings:addParam("sep", "~=[ DRAWS ]=~", SCRIPT_PARAM_INFO, "")
	datAiming.Esettings:addParam("showErange", "Show E Range", SCRIPT_PARAM_ONOFF, false)
	if EUseCol	== true then
	datAiming.Esettings:addParam("showEcollision", "Show E Collision", SCRIPT_PARAM_ONOFF, false)
	end
	datAiming.Esettings:addParam("sep", "~=[ NEEDS RELOAD ]=~", SCRIPT_PARAM_INFO, "")
	datAiming.Esettings:addParam("ShowPredictE", "Show Predict E", SCRIPT_PARAM_ONOFF, false)
			if datAiming.Esettings.ShowPredictE then
			datAiming.Esettings:permaShow("PredictE")	
		end
	end 
	if RName ~= nil then
	datAiming:addSubMenu("[R Settings]", "Rsettings")
    datAiming.Rsettings:addParam("PredictR","Predict R", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))

	datAiming.Rsettings:addParam("sep", "~=[ USE CALLBACKS ]=~", SCRIPT_PARAM_INFO, "")
    datAiming.Rsettings:addParam("OnDashR","OnDash R", SCRIPT_PARAM_ONOFF, false)
    datAiming.Rsettings:addParam("AfterDashR","AfterDash R", SCRIPT_PARAM_ONOFF, false)
    datAiming.Rsettings:addParam("AfterImmobileR","AfterImmobile R", SCRIPT_PARAM_ONOFF, false)
    datAiming.Rsettings:addParam("OnImmobileR","OnImmobile R", SCRIPT_PARAM_ONOFF, false)
	datAiming.Rsettings:addParam("sep", "~=[ DRAWS ]=~", SCRIPT_PARAM_INFO, "")
	datAiming.Rsettings:addParam("showRrange", "Show R Range", SCRIPT_PARAM_ONOFF, false)
	if RUseCol	== true then
	datAiming.Rsettings:addParam("showRcollision", "Show R Collision", SCRIPT_PARAM_ONOFF, false)
	end
	datAiming.Rsettings:addParam("sep", "~=[ NEEDS RELOAD ]=~", SCRIPT_PARAM_INFO, "")
	datAiming.Rsettings:addParam("ShowPredictR", "Show Predict R", SCRIPT_PARAM_ONOFF, false)
			if datAiming.Rsettings.ShowPredictR then
			datAiming.Rsettings:permaShow("PredictR")	
		end
	end 
    ts = TargetSelector(TARGET_LESS_CAST, 1400, DAMAGE_MAGIC, true)
	ts.name = "datAiming"
    datAiming:addTS(ts)
end 	
function SkillsReadyChecker()
QReady = (myHero:CanUseSpell(_Q) == READY)
WReady = (myHero:CanUseSpell(_W) == READY)
EReady = (myHero:CanUseSpell(_E) == READY)
RReady = (myHero:CanUseSpell(_R) == READY)
end 
function ProdictionSetup()
	CollisionSetup()
    Prod = ProdictManager.GetInstance()
	if QName ~= nil then
	ProdQ = Prod:AddProdictionObject(_Q, QRange, QSpeed, QDelay, QWidth) 
	end 	
	if WName ~= nil then
	ProdW = Prod:AddProdictionObject(_W, WRange, WSpeed, WDelay, WWidth) 
	end 	
	if EName ~= nil then
	ProdE = Prod:AddProdictionObject(_E, ERange, ESpeed, EDelay, EWidth) 
	end 	
	if RName ~= nil then
	ProdR = Prod:AddProdictionObject(_R, RRange, RSpeed, RDelay, RWidth) 
	end
    PosSetup()
end 
function PosSetup()
	if QName ~= nil then
	qPos = nil
	end 
	if WName ~= nil then
	wPos = nil
	end 
	if EName ~= nil then
	ePos = nil
	end 
	if RName ~= nil then
	rPos = nil
	end 
end 
function CollisionSetup()
	if QName ~= nil then
		if QUseCol	== true then
		QCol = Collision(QRange, QSpeed, QDelay, QWidth)
		end
	end 	
	if WName ~= nil then
		if WUseCol	== true then
		WCol = Collision(WRange, WSpeed, WDelay, WWidth)
		end 
	end
	if EName ~= nil then
		if EUseCol	== true then
		ECol = Collision(ERange, ESpeed, EDelay, EWidth)
		end 
	end
	if RName ~= nil then
		if RUseCol	== true then
		RCol = Collision(RRange, RSpeed, RDelay, RWidth)
		end 
	end
end 
function PutCallbacksOn()
     for i = 1, heroManager.iCount do
           local hero = heroManager:GetHero(i)
           if hero.team ~= myHero.team then
				if QName ~= nil then
					ProdQ:GetPredictionOnDash(hero, OnDashFuncQ)
					ProdQ:GetPredictionAfterDash(hero, AfterDashFuncQ)
					ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileFuncQ)
					ProdQ:GetPredictionOnImmobile(hero, OnImmobileFuncQ)
				end 
				if WName ~= nil then
					ProdW:GetPredictionOnDash(hero, OnDashFuncW)
					ProdW:GetPredictionAfterDash(hero, AfterDashFuncW)
					ProdW:GetPredictionAfterImmobile(hero, AfterImmobileFuncW)
					ProdW:GetPredictionOnImmobile(hero, OnImmobileFuncW)
				end 
				if EName ~= nil then
					ProdE:GetPredictionOnDash(hero, OnDashFuncE)
					ProdE:GetPredictionAfterDash(hero, AfterDashFuncE)
					ProdE:GetPredictionAfterImmobile(hero, AfterImmobileFuncE)
					ProdE:GetPredictionOnImmobile(hero, OnImmobileFuncE)
				end 
				if RName ~= nil then
					ProdR:GetPredictionOnDash(hero, OnDashFuncR)
					ProdR:GetPredictionAfterDash(hero, AfterDashFuncR)
					ProdR:GetPredictionAfterImmobile(hero, AfterImmobileFuncR)
					ProdR:GetPredictionOnImmobile(hero, OnImmobileFuncR)
				end 
           end
       end
end 
function AimTarget()
	if QName ~= nil then
		if ValidTarget(Target) then
			ProdQ:GetPredictionCallBack(Target, GetQPos)
		else
			qPos = nil
		end
	end 
	if WName ~= nil then
		if ValidTarget(Target) then
			ProdW:GetPredictionCallBack(Target, GetWPos)
		else
			wPos = nil
		end
	end 
	if EName ~= nil then
		if ValidTarget(Target) then
			ProdE:GetPredictionCallBack(Target, GetEPos)
		else
			ePos = nil
		end
	end 
	if RName ~= nil then
		if ValidTarget(Target) then
			ProdR:GetPredictionCallBack(Target, GetRPos)
		else
			rPos = nil
		end
	end 
end 
function CastProdiction()
	if QName ~= nil then
		if datAiming.Qsettings.PredictQ then
			if ValidTarget(Target) then
                    ProdQ:GetPredictionCallBack(Target, CastQ)
			end
		end
	end
	if WName ~= nil then
		if datAiming.Wsettings.PredictW then
			if ValidTarget(Target) then
                    ProdW:GetPredictionCallBack(Target, CastW)
			end
		end
	end
	if EName ~= nil then
		if datAiming.Esettings.PredictE then
			if ValidTarget(Target) then
                    ProdE:GetPredictionCallBack(Target, CastE)
			end
		end
	end
	if RName ~= nil then
		if datAiming.Rsettings.PredictR then
			if ValidTarget(Target) then
                    ProdR:GetPredictionCallBack(Target, CastR)
			end
		end
	end
end 
function OnOffCallbacksViaMenu()
    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        if hero.team ~= myHero.team then
			if QName ~= nil then
				if datAiming.Qsettings.OnDashQ then
					ProdQ:GetPredictionOnDash(hero, OnDashFuncQ)
				else
					ProdQ:GetPredictionOnDash(hero, OnDashFuncQ, false)
				end
				if datAiming.Qsettings.AfterDashQ then
					ProdQ:GetPredictionAfterDash(hero, AfterDashFuncQ)
				else
					ProdQ:GetPredictionAfterDash(hero, AfterDashFuncQ, false)
				end
				if datAiming.Qsettings.AfterImmobileQ then
					ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileFuncQ)
				else
					ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileFuncQ, false)
				end
				if datAiming.Qsettings.OnImmobileQ then
					ProdQ:GetPredictionOnImmobile(hero, OnImmobileFuncQ)
				else
					ProdQ:GetPredictionOnImmobile(hero, OnImmobileFuncQ, false)
				end
			end
			if WName ~= nil then
				if datAiming.Wsettings.OnDashW then
					ProdW:GetPredictionOnDash(hero, OnDashFuncW)
				else
					ProdW:GetPredictionOnDash(hero, OnDashFuncW, false)
				end
				if datAiming.Wsettings.AfterDashW then
					ProdW:GetPredictionAfterDash(hero, AfterDashFuncW)
				else
					ProdW:GetPredictionAfterDash(hero, AfterDashFuncW, false)
				end
				if datAiming.Wsettings.AfterImmobileW then
					ProdW:GetPredictionAfterImmobile(hero, AfterImmobileFuncW)
				else
					ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileFuncW, false)
				end
				if datAiming.Wsettings.OnImmobileW then
					ProdW:GetPredictionOnImmobile(hero, OnImmobileFuncW)
				else
					ProdW:GetPredictionOnImmobile(hero, OnImmobileFuncW, false)
				end
			end	
			if EName ~= nil then
				if datAiming.Esettings.OnDashE then
					ProdE:GetPredictionOnDash(hero, OnDashFuncE)
				else
					ProdE:GetPredictionOnDash(hero, OnDashFuncE, false)
				end
				if datAiming.Esettings.AfterDashE then
					ProdE:GetPredictionAfterDash(hero, AfterDashFuncE)
				else
					ProdE:GetPredictionAfterDash(hero, AfterDashFuncE, false)
				end
				if datAiming.Esettings.AfterImmobileE then
					ProdE:GetPredictionAfterImmobile(hero, AfterImmobileFuncE)
				else
					ProdE:GetPredictionAfterImmobile(hero, AfterImmobileFuncE, false)
				end
				if datAiming.Esettings.OnImmobileE then
					ProdE:GetPredictionOnImmobile(hero, OnImmobileFuncE)
				else
					ProdE:GetPredictionOnImmobile(hero, OnImmobileFuncE, false)
				end
			end
			if RName ~= nil then
				if datAiming.Rsettings.OnDashR then
					ProdR:GetPredictionOnDash(hero, OnDashFuncR)
				else
					ProdR:GetPredictionOnDash(hero, OnDashFuncR, false)
				end
				if datAiming.Rsettings.AfterDashR then
					ProdR:GetPredictionAfterDash(hero, AfterDashFuncR)
				else
					ProdR:GetPredictionAfterDash(hero, AfterDashFuncR, false)
				end
				if datAiming.Rsettings.AfterImmobileR then
					ProdR:GetPredictionAfterImmobile(hero, AfterImmobileFuncR)
				else
					ProdR:GetPredictionAfterImmobile(hero, AfterImmobileFuncR, false)
				end
				if datAiming.Rsettings.OnImmobileR then
					ProdR:GetPredictionOnImmobile(hero, OnImmobileFuncR)
				else
					ProdR:GetPredictionOnImmobile(hero, OnImmobileFuncR, false)
				end
			end
        end
    end

end
function GetQPos(unit, pos)
        qPos = pos
end
function GetWPos(unit, pos)
        wPos = pos
end
function GetEPos(unit, pos)
        ePos = pos
end
function GetRPos(unit, pos)
        rPos = pos
end

function CastQ(unit,pos)
    if (QReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) and myHero:GetSpellData(_Q).name == ""..QName.."" then   
		if QUseCol	== true then
			local coll = Collision(QRange, QSpeed, QDelay, QWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_Q, pos.x, pos.z)
			end
		elseif QUseCol	== false then
			CastSpell(_Q, pos.x, pos.z)
		end
	end
end
function OnDashFuncQ(unit, pos, spell)
    if (QReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) and myHero:GetSpellData(_Q).name == ""..QName.."" then
		if QUseCol	== true then
			local coll = Collision(QRange, QSpeed, QDelay, QWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_Q, pos.x, pos.z)
			end
		elseif QUseCol	== false then
			CastSpell(_Q, pos.x, pos.z)
		end
    end
end
function AfterDashFuncQ(unit, pos, spell)
    if (QReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) and myHero:GetSpellData(_Q).name == ""..QName.."" then
		if QUseCol	== true then
			local coll = Collision(QRange, QSpeed, QDelay, QWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_Q, pos.x, pos.z)
			end
		elseif QUseCol	== false then
			CastSpell(_Q, pos.x, pos.z)
		end
    end
end
function AfterImmobileFuncQ(unit, pos, spell)
    if (QReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) and myHero:GetSpellData(_Q).name == ""..QName.."" then
		if QUseCol	== true then
			local coll = Collision(QRange, QSpeed, QDelay, QWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_Q, pos.x, pos.z)
			end
		elseif QUseCol	== false then
			CastSpell(_Q, pos.x, pos.z)
		end
    end
end
function OnImmobileFuncQ(unit, pos, spell)
    if (QReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRange) and myHero:GetSpellData(_Q).name == ""..QName.."" then
		if QUseCol	== true then
			local coll = Collision(QRange, QSpeed, QDelay, QWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_Q, pos.x, pos.z)
			end
		elseif QUseCol	== false then
			CastSpell(_Q, pos.x, pos.z)
		end
    end
end
function CastW(unit,pos)
    if (WReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < WRange) and myHero:GetSpellData(_W).name == ""..WName.."" then      
		if WUseCol	== true then
			local coll = Collision(WRange, WSpeed, WDelay, WWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_W, pos.x, pos.z)
			end
		elseif WUseCol	== false then
			CastSpell(_W, pos.x, pos.z)
		end
    end
end
function OnDashFuncW(unit, pos, spell)
    if (WReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < WRange) and myHero:GetSpellData(_W).name == ""..WName.."" then
		if WUseCol	== true then
			local coll = Collision(WRange, WSpeed, WDelay, WWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_W, pos.x, pos.z)
			end
		elseif WUseCol	== false then
			CastSpell(_W, pos.x, pos.z)
		end
    end
end
function AfterDashFuncW(unit, pos, spell)
    if (WReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < WRange) and myHero:GetSpellData(_W).name == ""..WName.."" then
		if WUseCol	== true then
			local coll = Collision(WRange, WSpeed, WDelay, WWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_W, pos.x, pos.z)
			end
		elseif WUseCol	== false then
			CastSpell(_W, pos.x, pos.z)
		end
    end
end
function AfterImmobileFuncW(unit, pos, spell)
    if (WReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < WRange) and myHero:GetSpellData(_W).name == ""..WName.."" then
		if WUseCol	== true then
			local coll = Collision(WRange, WSpeed, WDelay, WWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_W, pos.x, pos.z)
			end
		elseif WUseCol	== false then
			CastSpell(_W, pos.x, pos.z)
		end
    end
end
function OnImmobileFuncW(unit, pos, spell)
    if (WReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < WRange) and myHero:GetSpellData(_W).name == ""..WName.."" then
		if WUseCol	== true then
			local coll = Collision(WRange, WSpeed, WDelay, WWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_W, pos.x, pos.z)
			end
		elseif WUseCol	== false then
			CastSpell(_W, pos.x, pos.z)
		end
    end
end 
function CastE(unit,pos)
    if (EReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < ERange) and myHero:GetSpellData(_E).name == ""..EName.."" then      
		if EUseCol	== true then
			local coll = Collision(ERange, ESpeed, EDelay, EWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_E, pos.x, pos.z)
			end
		elseif EUseCol	== false then
			CastSpell(_E, pos.x, pos.z)
		end
    end
end
function OnDashFuncE(unit, pos, spell)
    if (EReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < ERange) and myHero:GetSpellData(_E).name == ""..EName.."" then
		if EUseCol	== true then
			local coll = Collision(ERange, ESpeed, EDelay, EWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_E, pos.x, pos.z)
			end
		elseif EUseCol	== false then
			CastSpell(_E, pos.x, pos.z)
		end
    end
end
function AfterDashFuncE(unit, pos, spell)
    if (EReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < ERange) and myHero:GetSpellData(_E).name == ""..EName.."" then
		if EUseCol	== true then
			local coll = Collision(ERange, ESpeed, EDelay, EWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_E, pos.x, pos.z)
			end
		elseif EUseCol	== false then
			CastSpell(_E, pos.x, pos.z)
		end
    end
end
function AfterImmobileFuncE(unit, pos, spell)
    if (EReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < ERange) and myHero:GetSpellData(_E).name == ""..EName.."" then
		if EUseCol	== true then
			local coll = Collision(ERange, ESpeed, EDelay, EWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_E, pos.x, pos.z)
			end
		elseif EUseCol	== false then
			CastSpell(_E, pos.x, pos.z)
		end
    end
end
function OnImmobileFuncE(unit, pos, spell)
    if (EReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < ERange) and myHero:GetSpellData(_E).name == ""..EName.."" then
		if EUseCol	== true then
			local coll = Collision(ERange, ESpeed, EDelay, EWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_E, pos.x, pos.z)
			end
		elseif EUseCol	== false then
			CastSpell(_E, pos.x, pos.z)
		end
    end
end
function CastR(unit,pos)
    if (RReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < RRange) and myHero:GetSpellData(_R).name == ""..RName.."" then      
		if RUseCol	== true then
			local coll = Collision(RRange, RSpeed, RDelay, RWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_R, pos.x, pos.z)
			end
		elseif RUseCol	== false then
			CastSpell(_R, pos.x, pos.z)
		end
    end
end
function OnDashFuncR(unit, pos, spell)
    if (RReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < RRange) and myHero:GetSpellData(_R).name == ""..RName.."" then
		if RUseCol	== true then
			local coll = Collision(RRange, RSpeed, RDelay, RWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_R, pos.x, pos.z)
			end
		elseif RUseCol	== false then
			CastSpell(_R, pos.x, pos.z)
		end
    end
end
function AfterDashFuncR(unit, pos, spell)
    if (RReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < RRange) and myHero:GetSpellData(_R).name == ""..RName.."" then
		if RUseCol	== true then
			local coll = Collision(RRange, RSpeed, RDelay, RWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_R, pos.x, pos.z)
			end
		elseif RUseCol	== false then
			CastSpell(_R, pos.x, pos.z)
		end
    end
end
function AfterImmobileFuncR(unit, pos, spell)
    if (RReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < RRange) and myHero:GetSpellData(_R).name == ""..RName.."" then
		if RUseCol	== true then
			local coll = Collision(RRange, RSpeed, RDelay, RWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_R, pos.x, pos.z)
			end
		elseif RUseCol	== false then
			CastSpell(_R, pos.x, pos.z)
		end
    end
end
function OnImmobileFuncR(unit, pos, spell)
    if (RReady) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < RRange) and myHero:GetSpellData(_R).name == ""..RName.."" then
		if RUseCol	== true then
			local coll = Collision(RRange, RSpeed, RDelay, RWidth)
			if not coll:GetMinionCollision(pos, myHero) then
				CastSpell(_R, pos.x, pos.z)
			end
		elseif RUseCol	== false then
			CastSpell(_R, pos.x, pos.z)
		end
    end
end
