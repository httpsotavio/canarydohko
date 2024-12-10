local MonkSecondPassive = CreatureEvent("MonkSecondPassive")

local config = {
	chance = 100,
	hits = 3,
	bonus = 60,
	type = COMBAT_HOLY,
	effect = CONST_ME_MAGIC_BLUE,
	vocations = {0}
}

MonkHitCount = {}

function MonkSecondPassive.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	local playerChance = math.random(1, 100)
	if (not creature or not attacker or not attacker:isPlayer() or not 
	table.contains(config.vocations, Player(attacker):getVocation():getId())) then 
		return primaryDamage, primaryType, secondaryDamage, secondaryType 
	end

	local player = Player(attacker)
	if (not MonkHitCount[player:getId()]) then
		MonkHitCount[player:getId()] = 1
	end

	local hits = MonkHitCount[player:getId()]

	if (origin == ORIGIN_MELEE and hits >= config.hits) then
		if (config.chance >= playerChance) then
			local dmg = math.floor(primaryDamage / 2)
			doTargetCombatHealth(attacker, creature, COMBAT_HOLYDAMAGE, dmg, dmg, CONST_ME_NONE)
			player:getPosition():sendMagicEffect(config.effect)
		end
		MonkHitCount[player:getId()] = 0
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	MonkHitCount[player:getId()] = MonkHitCount[player:getId()] + 1
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

MonkSecondPassive:register()