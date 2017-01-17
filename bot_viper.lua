-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

require( GetScriptDirectory().."/constants" )
local utils = require( GetScriptDirectory().."/utility" )
local dt = require( GetScriptDirectory().."/decision_tree" )

local SKILL_Q = "viper_poison_attack";
local SKILL_W = "viper_nethertoxin";
local SKILL_E = "viper_corrosive_skin";
local SKILL_R = "viper_viper_strike"; 

local ABILITY1 = "special_bonus_attack_damage_15"
local ABILITY2 = "special_bonus_hp_125"
local ABILITY3 = "special_bonus_strength_7"
local ABILITY4 = "special_bonus_agility_14"
local ABILITY5 = "special_bonus_armor_7"
local ABILITY6 = "special_bonus_attack_range_75"
local ABILITY7 = "special_bonus_unique_viper_1"
local ABILITY8 = "special_bonus_unique_viper_2"

local ViperAbilityPriority = {
	SKILL_Q,    SKILL_W,    SKILL_W,    SKILL_E,    SKILL_W,
    SKILL_R,    SKILL_W,    SKILL_Q,    SKILL_Q,    ABILITY2,
    SKILL_Q,    SKILL_R,    SKILL_E,    SKILL_E,    ABILITY4,
    SKILL_E,    SKILL_R,    ABILITY6, 	ABILITY8
};

local viperActionQueue = { [1] = constants.ACTION_NONE }

ViperBot = dt:new()

function ViperBot:new(o)
	o = o or dt:new(o)
	setmetatable(o, self)
	self.__index = self
	return o
end

viperBot = ViperBot:new{prevTime = -998.0, actionQueue = viperActionQueue, abilityPriority = ViperAbilityPriority}
--viperBot:printInfo();

viperBot.Init = false;

local LaningState = 0
local CurLane = nil
local MoveThreshold = 1.0
local DamageThreshold = 1.0
local ShouldPush = false
local IsCore = nil
local Role = nil
local IsRetreating = false
local IsInLane = false
local BackTimerGen = -1000
local LastCourierThink = -1000.0
local TargetOfRunAwayFromCreepOrTower = nil

function LoadUpdates(npcBot)
	npcBot.LaningState = LaningState
	npcBot.CurLane = CurLane
	npcBot.MoveThreshold = MoveThreshold
	npcBot.DamageThreshold = DamageThreshold
	npcBot.ShouldPush = ShouldPush
	npcBot.IsCore = IsCore
	npcBot.Role = Role
	npcBot.IsRetreating = IsRetreating
	npcBot.IsInLane = IsInLane
	npcBot.BackTimerGen = BackTimerGen
	npcBot.LastCourierThink = LastCourierThink
	npcBot.TargetOfRunAwayFromCreepOrTower = TargetOfRunAwayFromCreepOrTower
end

function SaveUpdates(npcBot)
	LaningState = npcBot.LaningState
	CurLane = npcBot.CurLane
	MoveThreshold = npcBot.MoveThreshold
	DamageThreshold = npcBot.DamageThreshold
	ShouldPush = npcBot.ShouldPush
	IsCore = npcBot.IsCore
	Role = npcBot.Role
	IsRetreating = npcBot.IsRetreating
	IsInLane = npcBot.IsInLane
	BackTimerGen = npcBot.BackTimerGen
	LastCourierThink = npcBot.LastCourierThink
	TargetOfRunAwayFromCreepOrTower = npcBot.TargetOfRunAwayFromCreepOrTower
end

function Think()
    local npcBot = GetBot()
	LoadUpdates(npcBot)
	
	viperBot:Think(npcBot)
	
	SaveUpdates(npcBot)
end
