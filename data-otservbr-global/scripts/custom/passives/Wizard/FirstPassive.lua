local WizardFirstPassive = CreatureEvent("WizardFirstPassive")

local config = {
    damagePerLevel = 10,
    chance = 100,
    effect = CONST_ME_POFF,
    type = COMBAT_FIREDAMAGE,
    vocations = {3},
    count = 3,
}

local area = createCombatArea(AREA_SQUARE1X1)

function explode(playerId, pos)
    local player = Player(playerId)
    if (not player) then return true end    
    local playerLvl = player:getLevel()
    doAreaCombatHealth(playerId, config.type, pos, area, config.damagePerLevel * playerLvl, config.damagePerLevel * playerLvl * 1.2, config.effect)
end

function count(n, position, playerId)
    if (n == 0) then
        explode(playerId, position)
        return true
    end
    -- player:sendColorTextInstant(n, position, 22)
    position:sendMagicEffect(CONST_ME_MAGIC_GREEN)
    addEvent(count, 1000, n - 1, position, playerId)
end

function WizardFirstPassive.onKill(creature, target)
    local playerChance = math.random(1, 100)
    if (not creature:isPlayer() or target:isPlayer()) then return true end
    if (config.chance >= playerChance) then
        count(config.count, target:getPosition(), creature:getId())
    end
    return true
end

WizardFirstPassive:register()

local WizardFirstPassiveLogin = CreatureEvent("WizardFirstPassiveLogin")

function WizardFirstPassiveLogin.onLogin(player)
	if (table.contains(config.vocations, player:getVocation():getId())) then
		player:registerEvent("WizardFirstPassive")
	end
	return true
end

WizardFirstPassiveLogin:register()