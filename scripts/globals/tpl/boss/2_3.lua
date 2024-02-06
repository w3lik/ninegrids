TPL_ABILITY_BOSS["刍泠(噩法师)"] = {
    AbilityTpl()
        :name("噩梦链接")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/Banish")
        :coolDownAdv(55, 0)
        :mpCostAdv(150, 0)
        :castRadiusAdv(600, 0)
        :castKeepAdv(10, 0)
        :castChantEffect("DrainCaster")
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            return {
                "在" .. colour.hex(colour.gold, "10秒") .. "内反复链接附近木飙",
                "每次被链接到的木飙HP的" .. colour.hex(colour.gold, "3%") .. "转移给法师",
                "一次最多链接3个木飙",
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 35) then
                hurtData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local x, y = u:x(), u:y()
            local frq = 0.7
            u:attach("DrainTarget", "origin")
            time.setInterval(frq, function(curTimer)
                if (u:isDead() or false == u:isAbilityKeepCasting()) then
                    destroy(curTimer)
                    u:detach("DrainTarget", "origin")
                    return
                end
                local g = Group():catch(UnitClass, {
                    circle = { x = x, y = y, radius = radius },
                    limit = 3,
                    filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
                })
                if (#g > 0) then
                    for _, eu in ipairs(g) do
                        lightning(LIGHTNING_TYPE.suckGreen, u:x(), u:y(), u:h(), eu:x(), eu:y(), eu:h(), 0.3)
                        local v = 0.03 * eu:hpCur()
                        eu:attach("DrainCaster", "origin", 1)
                        eu:hpCur("-=" .. v)
                        u:hpBack( v)
                    end
                end
            end)
        end),
    AbilityTpl()
        :name("魔火复生")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/Bigflamecannon2")
        :coolDownAdv(70, 0)
        :hpCostAdv(300, 0)
        :mpCostAdv(200, 0)
        :castRadiusAdv(500, 0)
        :castChantAdv(1, 0)
        :description(
        function()
            local hpRegen = 100
            local defend = 100
            return {
                "召唤3团魔火，持续30秒",
                "每团魔火不仅提供" .. colour.hex(colour.lawngreen, hpRegen) .. "点HP恢复",
                "还能为噩法师提供" .. colour.hex(colour.lawngreen, defend) .. "点防御",
                "当魔火消失时提供的增益也会随至消失",
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 50) then
                local p = hurtData.triggerUnit:hpCur() / hurtData.triggerUnit:hp()
                if (p < 0.5) then
                    hurtData.triggerAbility:effective()
                end
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local x, y, facing = u:x(), u:y(), u:facing()
            local hpRegen = 100
            local defend = 100
            local n = 3
            local hp = math.floor(500 + Game():GD().erode * 2)
            local dur = 30
            u:hpRegen("+=" .. n * hpRegen)
            u:defend("+=" .. n * defend)
            for i = 1, n do
                local tx, ty = vector2.polar(x, y, radius, facing + i * 120)
                local eu = Game():summons(effectiveData.triggerUnit:owner(), TPL_UNIT.SUMMON_BlueFire, tx, ty, 270)
                eu:period(dur):hp(hp)
                eu:animate("birth")
                local l = LightningChain(LIGHTNING_TYPE.manaChain, u, eu)
                eu:onEvent(EVENT.Object.Destruct, function()
                    destroy(l)
                    u:hpRegen("-=" .. hpRegen)
                    u:defend("-=" .. defend)
                end)
            end
        end),
    AbilityTpl()
        :name("噩运")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :icon("ability/DeathBreach")
        :coolDownAdv(15, 0)
        :mpCostAdv(125, 0)
        :castRadiusAdv(200, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local dmg = math.floor(450 + Game():GD().erode * 2.2)
            local defend = 50
            return {
                "使用厄运侵蚀范围木飙",
                "被击中的木飙将受到" .. colour.hex(colour.indianred, dmg) .. "暗伤害",
                "而且在4秒内防御减少" .. colour.hex(colour.indianred, defend) .. "点",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 40) then
                atkData.triggerAbility:effective({
                    targetX = atkData.targetUnit:x(),
                    targetY = atkData.targetUnit:y(),
                })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local x, y = effectiveData.targetX, effectiveData.targetY
            local dmg = math.floor(450 + Game():GD().erode * 2.2)
            local defend = 50
            Effect("eff/DarkNova", x, y, japi.Z(x, y), 1):size(radius / 640)
            local g = Group():catch(UnitClass, {
                circle = { x = x, y = y, radius = radius },
                limit = 6,
                filter = function(enumUnit)
                    return ab:isCastTarget(enumUnit)
                end
            })
            if (#g > 0) then
                for _, eu in ipairs(g) do
                    ability.damage({
                        sourceUnit = u,
                        targetUnit = eu,
                        damage = dmg,
                        damageSrc = DAMAGE_SRC.ability,
                        damageType = DAMAGE_TYPE.dark,
                        damageTypeLevel = 1,
                    })
                    eu:buff("噩运")
                      :signal(BUFF_SIGNAL.down)
                      :icon("ability/DeathBreach")
                      :duration(4)
                      :description({ colour.hex(colour.indianred, "防御：-" .. defend) })
                      :purpose(function(buffObj)
                        buffObj:attach("ShadowStrike", "overhead")
                        buffObj:defend("-=" .. defend)
                    end)
                      :rollback(function(buffObj)
                        buffObj:detach("ShadowStrike", "overhead")
                        buffObj:defend("+=" .. defend)
                    end)
                      :run()
                end
            end
        end),
}