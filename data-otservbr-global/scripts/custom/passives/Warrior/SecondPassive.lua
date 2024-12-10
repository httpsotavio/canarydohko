local WarriorSecondPassive = CreatureEvent("WarriorSecondPassive")

local config = {
	shieldRem = 40,
	bonus = 40,
	duration = 5,
	chance = 100,
	effect = CONST_ME_MAGIC_BLUE,
	vocations = {0}
}

function WarriorSecondPassive.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	local playerChance = math.random(1, 100)
	if (not attacker or not attacker:isPlayer() or not table.contains(config.vocations, Player(attacker):getVocation():getId())) then
		return primaryDamage, primaryType, secondaryDamage, secondaryType 
	end


	if (config.chance >= playerChance) then
		if (creature:isPlayer()) then
			if (not creature:getCondition(CONDITION_ATTRIBUTES, CONDITIONID_DEFAULT, 147) and config.chance >= playerChance) then
				local condition = Condition(CONDITION_ATTRIBUTES)
				condition:setParameter(CONDITION_PARAM_TICKS, config.duration * 1000)
				condition:setParameter(CONDITION_PARAM_SKILL_SHIELD, -config.shieldRem)
				condition:setParameter(CONDITION_PARAM_SUBID, 147)
				creature:addCondition(condition)
				creature:getPosition():sendMagicEffect(config.effect)
				-- creature:addBuff(DEBUFF_TRUEDAMAGE)
			end
		else
			if (config.chance >= playerChance) then	
				local dmg = math.floor((primaryDamage / 100 * config.bonus))
				creature:getPosition():sendMagicEffect(config.effect)
				return primaryDamage + dmg, primaryType, secondaryDamage, secondaryType
			end
		end

	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

WarriorSecondPassive:register()