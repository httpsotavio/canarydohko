local DruidSecondPassive = CreatureEvent("DruidSecondPassive")

local config = {
	duration = 1.5, -- duração em segundos
	chance = 100,
	effect = CONST_ME_MAGIC_BLUE,
	vocations = {0}
}

function DruidSecondPassive.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	local playerChance = math.random(1, 100)
	if (not attacker or not attacker:isPlayer() or not table.contains(config.vocations, Player(attacker):getVocation():getId())) then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	
	if (config.chance >= playerChance) then
		if (not creature:getCondition(CONDITION_ROOTED)) then
			local condition = Condition(CONDITION_ROOTED)
			if (condition) then
				condition:setParameter(CONDITION_PARAM_TICKS, config.duration*1000)
				creature:addCondition(condition)
				-- creature:addBuff(DEBUFF_ROOTED)
				creature:getPosition():sendMagicEffect(config.effect)
			end
		end
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

DruidSecondPassive:register()