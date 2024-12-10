local AssassinFirstPassive = CreatureEvent("AssassinFirstPassive")

local config = {
	chance = 100,
    text = "AssassinFirstPassive",
	vocations = {0}
}


function AssassinFirstPassive.onKill(creature, target)
	if (not creature:isPlayer() or target:isPlayer()) then return true end
	local player = Player(creature)
    local playerChance = math.random(1, 100)
    if (config.chance >= playerChance) then
        player:castSpell("Berserk")
        player:say(config.text, TALKTYPE_MONSTER_SAY, false)
    end
	return true
end

AssassinFirstPassive:register()

local AssassinFirstPassiveLogin = CreatureEvent("AssassinFirstPassiveLogin")

function AssassinFirstPassiveLogin.onLogin(player)
	if (table.contains(config.vocations, player:getVocation():getId())) then
		print(">> Registrou 1 assassin p")
		player:registerEvent("AssassinFirstPassive")
	end
	return true
end

AssassinFirstPassiveLogin:register()