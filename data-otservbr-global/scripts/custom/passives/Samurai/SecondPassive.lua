local SamuraiSecondPassive = CreatureEvent("SamuraiSecondPassive")

local config = {
	hits = 5,
	bonus = 80, -- porcentagem de dano extra
	vocations = {0}
}

SamuraiHitCount = {}

function SamuraiSecondPassive.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if (not creature or not attacker or not attacker:isPlayer() or not table.contains(config.vocations, Player(attacker):getVocation():getId())) then 
		return primaryDamage, primaryType, secondaryDamage, secondaryType	
	end

	local player = Player(attacker)
	if (not SamuraiHitCount[player:getId()]) then
		SamuraiHitCount[player:getId()] = 1
	end

	local hits = SamuraiHitCount[player:getId()]

	if (hits >= config.hits) then
		local extraDamage = math.abs(math.floor(primaryDamage / 100 * config.bonus))
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		player:addHealth(extraDamage)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		SamuraiHitCount[player:getId()] = 0
		return primaryDamage + extraDamage, primaryType, secondaryDamage, secondaryType
	end
	SamuraiHitCount[player:getId()] = SamuraiHitCount[player:getId()] + 1
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

SamuraiSecondPassive:register()