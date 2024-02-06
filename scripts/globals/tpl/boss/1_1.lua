TPL_ABILITY_BOSS["亡泠(死骑)"] = {
    AbilityTpl()
        :name("亡泠速战")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/Avigorouschop")
        :coolDownAdv(15, 0)
        :mpCostAdv(50, 0)
        :description(
        function()
            local attackSpeed = 50
            local move = 50
            return {
                "汇聚亡泠触动战斗的感觉",
                colour.format("%s内攻速增加%s，移速增加%s", nil, {
                    { colour.gold, "6秒" },
                    { colour.lawngreen, attackSpeed .. '%' },
                    { colour.lawngreen, move },
                }),
                colour.hex(colour.yellow, "在雪天天气下，效果提升100%")
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
            local attackSpeed = 50
            local move = 50
            if (Game():isWeather("snow")) then
                attackSpeed = attackSpeed * 2
            end
            u:buff("亡泠速战")
             :signal(BUFF_SIGNAL.up)
             :icon("ability/Avigorouschop")
             :duration(6)
             :description({
                colour.hex(colour.lawngreen, "攻速：+" .. attackSpeed .. '%'),
                colour.hex(colour.lawngreen, "移动：+" .. move),
            })
             :purpose(function(buffObj)
                buffObj:attach("buff/Mirage", "origin")
                buffObj:attackSpeed("+=" .. attackSpeed)
                buffObj:move("+=" .. move)
            end)
             :rollback(function(buffObj)
                buffObj:detach("buff/Mirage", "origin")
                buffObj:attackSpeed("-=" .. attackSpeed)
                buffObj:move("-=" .. move)
            end)
             :run()
        end),
    AbilityTpl()
        :name("死灵冰甲")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/FrostArmor")
        :coolDownAdv(40, 0)
        :mpCostAdv(100, 0)
        :description(
        function()
            local defend = 40
            return {
                "在身边召唤5具骷髅战士" .. colour.hex(colour.gold, "20秒"),
                "期间自身增加" .. colour.hex(colour.lawngreen, defend) .. "点防御",
                colour.hex(colour.yellow, "在雪天天气下，骷髅战士数量+5")
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 30) then
                hurtData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local defend = 40
            local dur = 20
            local num = 5
            if (Game():isWeather("snow")) then
                num = num + 5
            end
            local skeleton = { TPL_UNIT.Skeleton, TPL_UNIT.SkeletonArcher, TPL_UNIT.SkeletonMage }
            local x, y, fac = u:x(), u:y(), u:facing()
            local angle = 360 / num
            for i = 1, num, 1 do
                local tx, ty = vector2.polar(x, y, 250, angle * i)
                local e = Game():enemies(table.rand(skeleton), tx, ty, fac, true):period(dur)
                e:hp(300)
                e:attack(120)
            end
            u:buff("死灵冰甲")
             :signal(BUFF_SIGNAL.up)
             :icon("ability/FrostArmor")
             :description({
                colour.hex(colour.lawngreen, "防御：+" .. defend),
            })
             :duration(dur)
             :purpose(function(buffObj)
                buffObj:attach("FrostArmorTarget", "origin")
                buffObj:defend("+=" .. defend)
            end)
             :rollback(function(buffObj)
                buffObj:detach("FrostArmorTarget", "origin")
                buffObj:defend("-=" .. defend)
            end)
             :run()
        end),
}