local AssassinSecondPassive = CreatureEvent("AssassinSecondPassive")

local config = {
	hits = 5,
	bonus = 50, -- porcentagem de dano extra
	arrow = 1,
	type = COMBAT_PHYSICDAMAGE,
	effect = 17,
	vocations = {0}
}

AssassinHitCount = {}

function AssassinSecondPassive.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if (not creature or not attacker or not attacker:isPlayer() or not table.contains(config.vocations, Player(attacker):getVocation():getId())) then 
		return primaryDamage, primaryType, secondaryDamage, secondaryType 
	end
	
	local player = Player(attacker)
	if (not AssassinHitCount[player:getId()]) then
		AssassinHitCount[player:getId()] = 0
	end

	local hits = AssassinHitCount[player:getId()]

	if (hits >= config.hits) then
		attacker:getPosition():sendDistanceEffect(creature:getPosition(), config.arrow)
		attacker:getPosition():sendMagicEffect(config.effect)
		local damage = (primaryDamage / 100) * config.bonus
		doTargetCombatHealth(attacker, creature, config.type, damage, damage, CONST_ME_NONE)
		AssassinHitCount[player:getId()] = 0
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	AssassinHitCount[player:getId()] = AssassinHitCount[player:getId()] + 1
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

AssassinSecondPassive:register()

local AssassinSecondPassiveLogin = CreatureEvent("AssassinSecondPassiveLogin")

function AssassinSecondPassiveLogin.onLogin(player)
	player:registerEvent("AssassinSecondPassive")
	return true
end

AssassinSecondPassiveLogin:register()