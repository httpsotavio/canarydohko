local BardSecondPassive = CreatureEvent("BardSecondPassive")

local config = {
	hits = 4,
	chance = 100,
	conditionDuration = 1,
	effect = 276,
	bonus = 20,
	vocations = {0}
}

BardHitCount = {}

function BardSecondPassive.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if (not attacker or not creature or origin == ORIGIN_SPELL or not attacker:isPlayer() or creature:isPlayer() or 
	not table.contains(config.vocations, Player(attacker):getVocation():getId())) then
		return primaryDamage, primaryType, secondaryDamage, secondaryType 
	end
	
	local player = Player(attacker)
	if (not BardHitCount[player:getId()]) then BardHitCount[player:getId()] = 0 end
	
	local hits = BardHitCount[player:getId()]
	if (hits >= config.hits) then
		local dmg = math.floor(primaryDamage / 100 * config.bonus)
		doTargetCombatHealth(attacker:getId(), creature, COMBAT_HOLYDAMAGE, -dmg, -dmg, CONST_ME_NONE)
		-- if (config.chance >= playerChance) then
		-- 	local playerChance = math.random(1, 100)
		-- 	local stun = Condition(CONDITION_STUN)
    	-- 	stun:setParameter(CONDITION_PARAM_TICKS, config.conditionDuration * 1000)
		-- 	creature:addCondition(stun)
		-- 	creature:addBuff(DEBUFF_STUN)
		-- 	creature:getPosition():sendMagicEffect(config.effect)
		-- end
		BardHitCount[player:getId()] = 0
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	BardHitCount[player:getId()] = BardHitCount[player:getId()] + 1
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

BardSecondPassive:register()
