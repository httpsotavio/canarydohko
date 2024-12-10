local BardFirstPassive = CreatureEvent("BardFirstPassive")

local config = {
	chance = 100,
	bonus = 1,
	vocations = {0}
}

function BardFirstPassive.onKill(creature, target)
	local playerChance = math.random(1, 100)
	if (not creature:isPlayer()) then return true end
	local player = Player(creature)
	local manaPercentage = player:getMaxMana() / 100
	if (config.chance >= playerChance) then
		local mana = math.floor(manaPercentage * config.bonus)
		player:addMana(mana, true)
		-- player:sendColorTextInstant("+"..mana, player:getPosition(), 22)
	end
	return true
end

BardFirstPassive:register()

local BardFirstPassiveLogin = CreatureEvent("BardFirstPassiveLogin")

function BardFirstPassiveLogin.onLogin(player)
	if (table.contains(config.vocations, player:getVocation():getId())) then
		player:registerEvent("BardFirstPassive")
	end
	return true
end

BardFirstPassiveLogin:register()