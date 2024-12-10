local ArcherSecondPassive = CreatureEvent("ArcherSecondPassive")

local config = {
	enemyHp = 40, -- porcentagem de hp que o inimigo precisa estar para o dano ser buffado
	bonus = 70,
	effect = 308,
	vocations = {0}
}

function ArcherSecondPassive.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if (not creature or not attacker or not attacker:isPlayer() or not table.contains(config.vocations, Player(attacker):getVocation():getId())) then return primaryDamage, primaryType, secondaryDamage, secondaryType end
	local hpPercentage = creature:getMaxHealth() / 100
	if (creature:getHealth() <= hpPercentage * config.enemyHp) then
		creature:getPosition():sendMagicEffect(config.effect)
		return primaryDamage + math.floor((primaryDamage / 100 * config.bonus)), primaryType, secondaryDamage, secondaryType
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

ArcherSecondPassive:register()