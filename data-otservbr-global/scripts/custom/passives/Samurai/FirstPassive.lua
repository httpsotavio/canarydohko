local SamuraiFirstPassive = CreatureEvent("SamuraiFirstPassive")

local config = {
	chance = 100,
	bonus = 60,
	effect = CONST_ME_MAGIC_BLUE,
	vocations = {0}
}

function SamuraiFirstPassive.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	local playerChance = math.random(1, 100)
	if (not attacker or not attacker:isPlayer() or creature:isPlayer() or not table.contains(config.vocations, Player(attacker):getVocation():getId())) then return primaryDamage, primaryType, secondaryDamage, secondaryType end
	if (origin == ORIGIN_MELEE) then
		if (config.chance >= playerChance) then
			local damage = ((primaryDamage / 100) * config.bonus)
			creature:getPosition():sendMagicEffect(config.effect)
			return primaryDamage + damage, primaryType, secondaryDamage, secondaryType
		end
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

SamuraiFirstPassive:register()