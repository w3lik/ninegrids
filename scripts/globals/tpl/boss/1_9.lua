TPL_ABILITY_BOSS["狂泠(战)"] = {
    AbilityTpl()
        :name("蓄力")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/WarriorShieldBash")
        :description(
        function()
            local erode = Game():GD().erode
            local defend = math.floor(5 + erode * 0.07)
            local lay = 30
            return {
                "每当受到伤害后都会增加一层自身防御力",
                "每一层都将增加" .. colour.hex(colour.lawngreen, defend) .. "防御",
                "每一层最多持续 5 秒，获得新层时刷新时间",
                "最多可叠加至 " .. lay .. " 层",
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            local u = hurtData.triggerUnit
            local erode = Game():GD().erode
            local def0 = math.floor(5 + erode * 0.07)
            local lay = 30
            local n = 1
            local b = u:buffOne("蓄力")
            if (b) then
                n = b:prop("layer") or 1
                n = n + 1
                u:buffClear({ key = "蓄力" })
            end
            n = math.min(n, lay)
            local defend = n * def0
            u:buff("蓄力")
             :signal(BUFF_SIGNAL.up)
             :icon("ability/WarriorShieldBash")
             :text(colour.hex(colour.gold, n))
             :prop("layer", n)
             :description({
                colour.hex(colour.gold, n .. "层") .. "蓄力",
                colour.hex(colour.lawngreen, "防御：+" .. defend)
            })
             :duration(5)
             :purpose(
                function(buffObj)
                    buffObj:defend("+=" .. defend)
                    buffObj:attach("buff/UbershieldCinder", "origin")
                end)
             :rollback(
                function(buffObj)
                    buffObj:detach("buff/UbershieldCinder", "origin")
                    buffObj:defend("-=" .. defend)
                end)
             :run()
        end),
    AbilityTpl()
        :name("震地")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/WarriorBloodNova")
        :coolDownAdv(30, 0)
        :mpCostAdv(150, 10)
        :castChantAdv(3, 0)
        :castRadiusAdv(700)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function(obj)
            local erode = Game():GD().erode
            local dmg = math.floor(500 + erode * 2)
            return {
                "用尽力气震击周边场地，以自身防御力抨击敌人",
                "范围半径内的敌人会被眩晕 5 秒，",
                "并受到" .. colour.hex(colour.indianred, dmg) .. "岩伤害",
                "狂战震地后会受到反噬，在10秒内防御降低" .. colour.hex(colour.indianred, 100) .. "点",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack, function(attackData) if (math.rand(1, 10) <= 4) then attackData.triggerAbility:effective() end end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local erode = Game():GD().erode
            local dmg = math.floor(500 + erode * 2)
            local x, y = u:x(), u:y()
            local defend = 100
            u:effect("WarStompCaster", 1)
            u:effect("eff/ShockExplosion", 2):size(radius / 500)
            u:buff("震地反噬")
             :signal(BUFF_SIGNAL.down)
             :icon("ability/WarriorBloodNova")
             :description({ colour.hex(colour.indianred, "防御：-" .. defend) })
             :duration(10)
             :purpose(
                function(buffObj)
                    buffObj:defend("-=" .. defend)
                    buffObj:attach("buff/ArmorPenetrationRed", "overhead")
                end)
             :rollback(
                function(buffObj)
                    buffObj:detach("buff/ArmorPenetrationRed", "overhead")
                    buffObj:defend("+=" .. defend)
                end)
             :run()
            local g = Group():catch(UnitClass, {
                circle = { x = x, y = y, radius = radius },
                limit = 10,
                filter = function(enumUnit)
                    return ab:isCastTarget(enumUnit)
                end
            })
            if (#g > 0) then
                for _, eu in ipairs(g) do
                    ability.stun({
                        name = "震地",
                        icon = "ability/WarriorBloodNova",
                        description = "被震晕了",
                        sourceUnit = u,
                        targetUnit = eu,
                        effect = "StasisTotemTarget",
                        duration = 5,
                    })
                    ability.damage({
                        sourceUnit = u,
                        targetUnit = eu,
                        damage = dmg,
                        damageSrc = DAMAGE_SRC.ability,
                        damageType = DAMAGE_TYPE.rock,
                        damageTypeLevel = 2,
                    })
                end
            end
        end),
}