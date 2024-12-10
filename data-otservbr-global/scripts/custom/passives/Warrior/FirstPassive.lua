local WarriorFirstPassive = CreatureEvent("WarriorFirstPassive")

local config = {
	chance = 100,
	bonus = 30,
	duration = 10, -- duração em segundos
	effect = 4,-- efeito da ataque
	loopEffect = CONST_ME_MAGIC_BLUE, -- efeito que vai ficar saindo
	loopInterval = 1200, -- intervalo entre cada efeito
	vocations = {0}
}

local area = {
	{1, 1, 1},
	{1, 1, 1},
	{1, 1, 1},
	{1, 2, 1},
}

local arr = createCombatArea(area)

WarriorTiming = {}

function loopEffect(playerId)
	local time = WarriorTiming[playerId] - os.time()
	if (time > 0) then
		local player = Player(playerId)
		player:getPosition():sendMagicEffect(config.loopEffect)
		addEvent(loopEffect, config.loopInterval, playerId)
		return true
	end
end

function WarriorFirstPassive.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if (not creature or not attacker or creature:isPlayer() or not attacker:isPlayer() or not 
	table.contains(config.vocations, Player(attacker):getVocation():getId())) then 
		return primaryDamage, primaryType, secondaryDamage, secondaryType 
	end
	local player = Player(attacker)

	if (not WarriorTiming[player:getId()]) then
		WarriorTiming[player:getId()] = 0
	end

	local time = WarriorTiming[player:getId()] - os.time()
	print(time)
	
	if (origin == ORIGIN_MELEE) then
		if (time > 0) then
			local damage = ((primaryDamage / 100) * config.bonus) + primaryDamage
			-- local arr = attacker:getPosition():getDirectionTo(creature:getPosition()) -- todo
			doAreaCombatHealth(attacker:getId(), COMBAT_PHYSICALDAMAGE, attacker:getPosition(), arr, damage / 0.25, damage, config.effect)
			return primaryDamage, primaryType, secondaryDamage, secondaryType
		end

		local playerChance = math.random(1, 100)
		if (config.chance >= playerChance) then
			WarriorTiming[player:getId()] = os.time() + 10
			loopEffect(player:getId())
		end
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

WarriorFirstPassive:register()