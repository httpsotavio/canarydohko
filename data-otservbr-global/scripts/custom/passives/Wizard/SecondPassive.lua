local WarriorSecondPassive = CreatureEvent("WarriorSecondPassive")

local config = {
	damage = 20, -- porcentagem de dano aplicada
	thunderEffect = 38,
	fireEffect = 37,
	chance = 25,

	vocations = {0},
}

function WarriorSecondPassive.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if (not attacker or not attacker:isPlayer() or not attacker:isPlayer() or not 
	table.contains(config.vocations, Player(attacker):getVocation():getId())) then 
		return primaryDamage, primaryType, secondaryDamage, secondaryType 
	end

	if (not origin == ORIGIN_RANGED) then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	
	local playerChance = math.random(1, 100) 
	if (config.chance >= playerChance) then
		local dmg = math.floor(primaryDamage / 100 * config.damage)
		local chances = {
			[1] = {cbt = COMBAT_FIREDAMAGE, eff = config.fireEffect},
			[2] = {cbt = COMBAT_ENERGYDAMAGE, eff = config.thunderEffect},
		}
		local effect = math.random(1,2)
		doTargetCombatHealth(attacker:getId(), creature, chances[effect].cbt, dmg, dmg, CONST_ME_NONE)
		creature:getPosition():sendMagicEffect(chances[mat].eff)
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

WarriorSecondPassive:register()