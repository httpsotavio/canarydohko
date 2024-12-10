local MonkFirstPassive = CreatureEvent("MonkFirstPassive")

local config = {
	chance = 100,
	duration = 5, -- total de tempo
	dmg = 50, -- dano do bleed
	vocations = {0}
}

function MonkFirstPassive.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	local playerChance = math.random(1, 100)
	if (not creature or not attacker or not creature:isPlayer() or not attacker:isPlayer() or not 
	table.contains(config.vocations, Player(attacker):getVocation():getId())) then 
		return primaryDamage, primaryType, secondaryDamage, secondaryType 
	end

	if (origin == ORIGIN_MELEE) then
		if (not creature:getCondition(CONDITION_BLEEDING)) then
			if (config.chance >= playerChance) then
				local condition = Condition(CONDITION_BLEEDING)
				condition:setParameter(CONDITION_PARAM_OWNER, attacker:getId())
				condition:addDamage(config.duration, config.duration, -config.dmg)
				creature:addCondition(condition)
				-- creature:addBuff(DEBUFF_BLEEDING)
			end
		end
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

MonkFirstPassive:register()