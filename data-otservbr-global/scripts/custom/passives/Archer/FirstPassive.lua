local ArcherFirstPassive = CreatureEvent("ArcherFirstPassive")

local config = {
	effect = CONST_ANI_BURSTARROW,
	dmg = 70, -- porcentagem do dano da 1 flecha
	maxRangeX = 4, -- maximo de sqms no eixo x distante para ricochetear,
	maxRangeY = 4, -- maximo de sqms no eixo y distante para ricochetear,
	chance = 50, -- chance de ativar

	vocations = {0}
}
function ArcherFirstPassive.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	local playerChance = math.random(1, 100)
	if (not creature or not attacker or not attacker:isPlayer() or creature:isPlayer() or not table.contains(config.vocations, Player(attacker):getVocation():getId())) then return primaryDamage, primaryType, secondaryDamage, secondaryType end

	if (origin == ORIGIN_RANGED) then
		if (config.chance >= playerChance) then
			local nearbyCreatures = Game.getSpectators(creature:getPosition(), false, false, config.maxRangeX, config.maxRangeX, config.maxRangeY, config.maxRangeY)
			if (#nearbyCreatures >= 2) then
				for i = 1, #nearbyCreatures do
					if (nearbyCreatures[i]:isMonster() and nearbyCreatures[i] ~= creature) then
						local choice = nearbyCreatures[i]
						creature:getPosition():sendDistanceEffect(choice:getPosition(), config.effect)
						local damage = (primaryDamage / 100) * config.dmg
						doTargetCombatHealth(attacker, choice, primaryType, damage, damage, CONST_ME_NONE)
						break
					end
				end
			end
		end
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

ArcherFirstPassive:register()