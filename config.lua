Config = {}

-- do you want to enable debugging?
Config.Debug = true

-- what framework do you use?
Config.Framework = 'qb' -- 'qb', 'esx'

-- what inventory do you use?
Config.Inventory = 'ox' -- 'qb', 'ps', 'ox'

-- what target do you use?
Config.Target = 'ox' -- 'qb', 'ox' (false: DrawText3D)

-- what radial menu do you use?
Config.Radial = 'qb' -- 'qb', 'ox'

-- what dispatch to use for police alerts?
Config.Dispatch = 'qb' -- 'qb', 'ps', 'moz', 'cd', 'custom'

-- what menu you want to use?
Config.OxMenu = true -- true: Ox Menu, false: Ox Context Menu

-- Minimum cops required to sell drugs
Config.MinimumCops = 0

-- Give bonus on selling drugs when no of cops are online
Config.GiveBonusOnPolice = false

-- Allow selling to peds sitting in vehicle
Config.SellPedOnVehicle = false

-- Chance to sell drug
Config.ChanceSell = 70 -- (in %) 

-- Random sell amount
Config.RandomSell = { min = 1, max = 20 } -- range: min, max

-- Selling timeout so that the menu doesnt stay forever
Config.SellTimeout = 200 -- (secs) Max time you get to choose your option
Config.WaitTime = 50000

-- The below option decides whether the person has to toggle selling in a zone (radialmenu/command) (Recommended: false)
Config.ShouldToggleSelling = true

Config.PedModels = {
    'a_m_y_stwhi_02',
}
Config.VehicleModel = "adder"

-- Spawn settings
Config.npcModel = {
    "g_m_m_mexboss_01",
    "g_m_y_famdnf_01",
    "g_m_y_famca_01",
} -- Example NPC model, change this to your desired NPC model

-- Follow distance
Config.followDistance = 20.0 -- Adjust the distance as needed

-- Check interval
Config.checkInterval = 30000 -- Adjust the interval as needed

Config.npcBlipSprite = 514
Config.npcBlipColor = 5
Config.npcBlipScale = 1.0
Config.npcBlipLabel = "Drug Dealer"

-- Ped models that you dont want to be sold to
Config.BlacklistPeds = {
    "mp_m_shopkeep_01",
    "s_m_y_ammucity_01",
    "s_m_m_lathandy_01",
    "s_f_y_clubbar_01",
    "ig_talcc",
    "g_f_y_vagos_01",
    "hc_hacker",
    "s_m_m_migrant_01",
}

Config.RewardItem = "rolled_cash" -- Price item

Config.SellZones = { -- Sell zones and their drugs
    -- Zone 1
    ["groove"] = {
        coords = vector3(124.38084, -1827.703, 26.629476),  
        size = vector3(80.0, 80.0, 80.0),

        -- Npc spawnzones
        pedZones = {
            {coords = vector3(167.03713, -1820.395, 28.43357)},
            {coords = vector3(84.924583, -1731.025, 29.511089)},
            {coords = vector3(104.06146, -1885.334, 24.318778)},
            {coords = vector3(101.21609, -1912.296, 21.407424)},
            {coords = vector3(40.232833, -1921.198, 21.65085)},
            {coords = vector3(49.353496, -1879.784, 22.138011)},
        },

        items = {
            { item = 'cokebaggy',    price = math.random(50, 5000), needed = math.random(1, 10)},
            { item = 'meth',    price = math.random(50, 5000), needed = math.random(1, 10)},
            { item = 'joint',    price = math.random(50, 5000), needed = math.random(1, 10)},
            { item = 'weed_skunk',    price = math.random(50, 5000), needed = math.random(1, 10)},
        }
    }
}
