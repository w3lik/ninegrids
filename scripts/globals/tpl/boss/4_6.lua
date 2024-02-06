TPL_ABILITY_BOSS["海皇泠(鲨煌)"] = {
    AbilityTpl()
        :name("鲨鱼皮")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("item/ElementalEternalShadow")
        :description({ "充满倒刺的厚实皮肤", "能够有效反射受到的伤害" })
        :attributes(
        {
            { SYMBOL_ODD .. "hurtRebound", 30, 0 },
            { "hurtRebound", 10, 0 },
        }),
    AbilityTpl()
        :name("海皇戟")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("item/NagaWeaponUp1")
        :attributes(
        {
            { SYMBOL_ODD .. "crit", 6, 0 },
            { "crit", 15, 0 },
        })
        :description(
        function()
            local odds = 4
            local crit = 10
            return {
                "海皇至戟提供一部分触动暴击的可能",
                "且每当攻击成功时，如果是次攻击没有暴击",
                "将增加" .. colour.hex(colour.lawngreen, odds .. '%') .. "的本体暴击几率",
                "和" .. colour.hex(colour.lawngreen, crit .. '%') .. "的本体暴击加成",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            local u = attackData.triggerUnit
            if (attackData.crit == true) then
                u:buffClear({ key = "海皇戟" })
                return
            end
            local l = 1
            local b = u:buffOne("海皇戟")
            if (b) then
                l = b:prop("layer") or 1
                l = l + 1
                u:buffClear({ key = "海皇戟" })
            end
            local odds = 4 * l
            local crit = 10 * l
            u:buff("海皇戟")
             :signal(BUFF_SIGNAL.up)
             :icon("item/NagaWeaponUp1")
             :text(colour.hex(colour.gold, l))
             :prop("layer", l)
             :description({
                colour.hex(colour.red, l .. "层") .. "海皇戟",
                colour.hex(colour.lawngreen, "暴击几率：+" .. odds .. '%'),
                colour.hex(colour.lawngreen, "暴击加成：+" .. crit .. '%') })
             :duration(-1)
             :purpose(
                function(buffObj)
                    buffObj:odds("crit", "+=" .. odds)
                    buffObj:crit("+=" .. crit)
                    buffObj:attach("HeadhunterWeaponsRight", "weapon")
                    buffObj:attach("buff/DisarmRed", "overhead")
                end)
             :rollback(
                function(buffObj)
                    buffObj:odds("crit", "-=" .. odds)
                    buffObj:crit("-=" .. crit)
                    buffObj:detach("HeadhunterWeaponsRight", "weapon")
                    buffObj:detach("buff/DisarmRed", "overhead")
                end)
             :run()
        end),
    AbilityTpl()
        :name("游龙步")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/HydraWarStomp")
        :coolDownAdv(15, 0)
        :mpCostAdv(150, 0)
        :description(
        function()
            local move = 100
            local defend = 100
            local dur = 3
            return {
                "以身躯摆动急速移动，提升属性",
                colour.hex(colour.lawngreen, "移动提升：" .. move),
                colour.hex(colour.lawngreen, "防御提升：" .. defend),
                colour.hex(colour.skyblue, "持续时间：" .. dur .. "秒"),
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 40) then
                atkData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local move = 100
            local defend = 100
            local dur = 3
            u:buff("游龙步")
             :signal(BUFF_SIGNAL.up)
             :icon("ability/HydraWarStomp")
             :duration(dur)
             :description({
                colour.hex(colour.lawngreen, "移动：+" .. move),
                colour.hex(colour.lawngreen, "防御：+" .. defend),
            })
             :purpose(function(buffObj)
                buffObj:attach("buff/WindwalkBlueSoul", "origin")
                buffObj:move("+=" .. move)
                buffObj:defend("+=" .. defend)
            end)
             :rollback(function(buffObj)
                buffObj:detach("buff/WindwalkBlueSoul", "origin")
                buffObj:move("-=" .. move)
                buffObj:defend("-=" .. defend)
            end)
             :run()
        end),
    AbilityTpl()
        :name("水域僭越")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/PanLanSonic")
        :coolDownAdv(20, 0)
        :mpCostAdv(125, 0)
        :castRadiusAdv(325, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local erode = Game():GD().erode
            local dmg = math.floor(1000 + erode * 5)
            return {
                "用力践踏水面，被击中的木飙被强力的震动",
                "被震中的木飙眩晕3秒，同时受到水浪的冲击伤害",
                "冲击水伤害：" .. colour.hex(colour.indianred, dmg)
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 50) then
                atkData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local x, y = u:x(), u:y()
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local erode = Game():GD().erode
            local dmg = math.floor(1000 + erode * 5)
            effector("eff/AquaSpike", x, y, nil, 1)
            local g = Group():catch(UnitClass, {
                circle = { x = x, y = y, radius = radius },
                limit = 7,
                filter = function(enumUnit)
                    return ab:isCastTarget(enumUnit)
                end
            })
            if (#g > 0) then
                for _, eu in ipairs(g) do
                    u:effect("NagaDeath", 0.5)
                    ability.damage({
                        targetUnit = eu,
                        damage = dmg,
                        damageSrc = DAMAGE_SRC.ability,
                        damageType = DAMAGE_TYPE.water,
                        damageTypeLevel = 1
                    })
                    ability.stun({
                        name = "水域僭越眩晕",
                        icon = "ability/PanLanSonic",
                        description = "被眩晕了",
                        sourceUnit = u,
                        targetUnit = eu,
                        duration = 3,
                    })
                end
            end
        end),
}