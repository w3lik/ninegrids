TPL_ABILITY_BOSS["魔泠(恶魔猎手)"] = {
    AbilityTpl()
        :name("猎杀")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/DemonhunterSoulcleave4")
        :description(
        function()
            local atkSpeed = 10
            local lay = 4
            return {
                "每当攻击成功都会增加一层自身猎杀度",
                "每一层都将增加" .. colour.hex(colour.lawngreen, atkSpeed) .. "%攻击速度",
                "每一层最多持续 4 秒，获得新层时刷新时间",
                "最多可叠加至 " .. lay .. " 层",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            local u = attackData.triggerUnit
            local atkSpeed = 10
            local lay = 4
            local n = 1
            local b = u:buffOne("猎杀")
            if (b) then
                n = b:prop("layer") or 1
                n = n + 1
                u:buffClear({ key = "猎杀" })
            end
            n = math.min(n, lay)
            local attackSpeed = n * atkSpeed
            u:buff("猎杀")
             :signal(BUFF_SIGNAL.up)
             :icon("ability/DemonhunterSoulcleave4")
             :text(colour.hex(colour.gold, n))
             :prop("layer", n)
             :description({
                colour.hex(colour.gold, n .. "层") .. "猎杀",
                colour.hex(colour.lawngreen, "攻速：+" .. attackSpeed .. '%')
            })
             :duration(4)
             :purpose(
                function(buffObj)
                    buffObj:attackSpeed("+=" .. attackSpeed)
                    buffObj:attach("buff/BurningRageTeal", "overhead")
                end)
             :rollback(
                function(buffObj)
                    buffObj:detach("buff/BurningRageTeal", "overhead")
                    buffObj:attackSpeed("-=" .. attackSpeed)
                end)
             :run()
        end),
    AbilityTpl()
        :name("堕落")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :icon("ability/DemonDance")
        :coolDownAdv(15, 0)
        :mpCostAdv(150, 0)
        :castRadiusAdv(200, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local dmg = math.floor(750 + Game():GD().erode * 4)
            local defend = 66
            return {
                "令范围木飙堕落至深渊",
                "被击中的木飙将受到" .. colour.hex(colour.indianred, dmg) .. "毒伤害",
                "而且在3秒内防御减少" .. colour.hex(colour.indianred, defend) .. "点",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 30) then
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
            local dmg = math.floor(750 + Game():GD().erode * 4)
            local defend = 66
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
                        damageType = DAMAGE_TYPE.poison,
                        damageTypeLevel = 0,
                    })
                    eu:buff("堕落")
                      :signal(BUFF_SIGNAL.down)
                      :icon("ability/DemonDance")
                      :duration(4)
                      :description({ colour.hex(colour.indianred, "防御：-" .. defend) })
                      :purpose(function(buffObj)
                        buffObj:attach("buff/ArmorPenetrationPurple", "overhead")
                        buffObj:defend("-=" .. defend)
                    end)
                      :rollback(function(buffObj)
                        buffObj:detach("buff/ArmorPenetrationPurple", "overhead")
                        buffObj:defend("+=" .. defend)
                    end)
                      :run()
                end
            end
        end),
    AbilityTpl()
        :name("凶神恶煞")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/OImprison")
        :coolDownAdv(45, 0)
        :mpCostAdv(250, 0)
        :castChantAdv(2, 0)
        :castKeepAdv(3, 0)
        :castRadiusAdv(600, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local gd = Game():GD()
            local dmg = math.floor(1000 + gd.erode * 4)
            return {
                "使用凶刀对周本木飙进行凶狠缠击",
                "每次缠击造成暗伤害的同时，木飙HP恢复将会" .. colour.hex(colour.red, "长期减少10点"),
                colour.hex(colour.indianred, "缠击伤害：" .. dmg),
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 15) then
                hurtData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local gd = Game():GD()
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local dmg = math.floor(1000 + gd.erode * 4)
            local x, y = u:x(), u:y()
            local frq = 0.3
            time.setInterval(frq, function(curTimer)
                curTimer:period(1)
                if (u:isAbilityKeepCasting() == false) then
                    destroy(curTimer)
                    return
                end
                Effect("slash/Round_dance4", x, y, nil, 1.1):size(radius / 150)
                local g = Group():catch(UnitClass, {
                    circle = { x = x, y = y, radius = radius },
                    filter = function(enumUnit) return ab:isCastTarget(enumUnit) end,
                    limit = 7,
                })
                if (#g > 0) then
                    for _, eu in ipairs(g) do
                        eu:hpRegen("-=10")
                        ability.damage({
                            sourceUnit = u,
                            targetUnit = eu,
                            damage = dmg,
                            damageSrc = DAMAGE_SRC.ability,
                            damageType = DAMAGE_TYPE.dark,
                            damageTypeLevel = 1
                        })
                    end
                end
            end)
        end),
}