CAST_TARGET_FILTER = {
    notNeutral = function(_, targetUnit)
        return isClass(targetUnit, UnitClass) and targetUnit:isAlive() and targetUnit:owner():isNeutral() == false
    end,
    enemyAbility = function(this, targetUnit)
        local bu = this:bindUnit()
        local owner
        if (isClass(bu, UnitClass)) then
            owner = bu:owner()
        end
        return isClass(targetUnit, UnitClass) and targetUnit:isAlive() and (isClass(owner, PlayerClass) and targetUnit:isEnemy(owner))
    end,
    enemySacred = function(this, targetUnit)
        local bi = this:bindItem()
        local owner
        if (isClass(bi, ItemClass)) then
            local bu = bi:bindUnit()
            if (isClass(bu, UnitClass)) then
                owner = bu:owner()
            end
        end
        return isClass(targetUnit, UnitClass) and targetUnit:isAlive() and (isClass(owner, PlayerClass) and targetUnit:isEnemy(owner))
    end,
    allyAbility = function(this, targetUnit)
        local bu = this:bindUnit()
        local owner
        if (isClass(bu, UnitClass)) then
            owner = bu:owner()
        end
        return isClass(targetUnit, UnitClass) and targetUnit:isAlive() and (isClass(owner, PlayerClass) and targetUnit:isAlly(owner))
    end,
}