TPL_ABILITY_BOSS["耀泠(阿卡玛)"] = {
    AbilityTpl()
        :name("圣廷庇佑")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/HolyAuraMastery")
        :description({ "受到阿卡圣殿的庇护", "多种元素抗性都得到极大的提升" })
        :attributes(
        {
            { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.steel.value, 50, 0 },
            { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.grass.value, 50, 0 },
            { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.water.value, 50, 0 },
            { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, 50, 0 },
            { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.rock.value, 50, 0 },
        }),
    AbilityTpl()
        :name("光耀圣队")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/HolyArdentDefender")
        :coolDownAdv(70, 0)
        :castChantAdv(2, 0)
        :mpCostAdv(175, 0)
        :description(
        function()
            return {
                "在身边召唤3个黄金战士" .. colour.hex(colour.gold, "40秒"),
                "黄金战士拥有强劲的体质和作战能力",
                "并自带钢攻击和常驻附着光元素",
                colour.hex(colour.yellow, "在烈日天气下战士防御+30")
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 25) then
                hurtData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local dur = 40
            local num = 3
            local hp = 1250
            local defend = 10
            if (Game():isWeather("sun")) then
                defend = defend + 30
            end
            local x, y, fac = u:x(), u:y(), u:facing()
            local angle = 360 / num
            for i = 1, num, 1 do
                local tx, ty = vector2.polar(x, y, 250, angle * i)
                local e = Game():enemies(TPL_UNIT.SUMMON_GoldWarrior, tx, ty, fac, true):period(dur)
                e:hp(hp)
                e:attack(250)
                e:defend(defend)
            end
        end),
    AbilityTpl()
        :name("圣上")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/HolyCross")
        :coolDownAdv(35, 0)
        :hpCostAdv(500, 0)
        :castRadiusAdv(600, 0)
        :castTargetFilter(CAST_TARGET_FILTER.allyAbility)
        :description(
        function()
            return {
                "发出呐喊，阿卡圣上与君同在。",
                "在" .. colour.hex(colour.gold, "10秒内") .. "自己周边包括自己所有友军",
                "移动提升" .. colour.hex(colour.lawngreen, "100"),
                "HP恢复提升" .. colour.hex(colour.lawngreen, "35点"),
                "MP恢复提升" .. colour.hex(colour.lawngreen, "25点"),
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 25) then
                atkData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local x, y = u:x(), u:y()
            local radius = ab:castRadius()
            local dur = 10
            local move = 100
            local hpRegen = 35
            local mpRegen = 25
            effector("eff/RoarCasterScarlet", x, y)
            local g = Group():catch(UnitClass, {
                circle = { x = x, y = y, radius = radius },
                limit = 10,
                filter = function(enumUnit)
                    return ab:isCastTarget(enumUnit)
                end
            })
            if (#g > 0) then
                for _, eu in ipairs(g) do
                    eu:buff("圣上")
                      :signal(BUFF_SIGNAL.up)
                      :icon("ability/HolyCross")
                      :duration(dur)
                      :description({
                        colour.hex(colour.lawngreen, "移动：+" .. move),
                        colour.hex(colour.lawngreen, "命中：+" .. hpRegen),
                        colour.hex(colour.lawngreen, "视野：+" .. mpRegen),
                    })
                      :purpose(function(buffObj)
                        buffObj:attach("buff/RoarTargetScarlet", "overhead")
                        buffObj:move("+=" .. move)
                        buffObj:hpRegen("+=" .. hpRegen)
                        buffObj:mpRegen("+=" .. mpRegen)
                    end)
                      :rollback(function(buffObj)
                        buffObj:detach("buff/RoarTargetScarlet", "overhead")
                        buffObj:move("-=" .. move)
                        buffObj:hpRegen("-=" .. hpRegen)
                        buffObj:mpRegen("-=" .. mpRegen)
                    end)
                      :run()
                end
            end
        end),
}