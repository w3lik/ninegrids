TPL_ABILITY_SOUL[39] = AbilityTpl()
    :name("乱打")
    :targetType(ABILITY_TARGET_TYPE.tag_unit)
    :icon("ability/SkyreachWindWall")
    :coolDownAdv(30, -0.5)
    :mpCostAdv(0, 0)
    :castDistanceAdv(350, 0)
    :castRadiusAdv(50, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local atkSpd = 15.25 + lv * 0.75
        local move = 16 + lv * 2
        local de = 3 + lv * 0.5
        return {
            "选定一个木飙，当对其攻击时，攻速移速会提升",
            "但是提升同时受到的伤害也将增加，先手者胜",
            "以上效果最高可叠加 7 层",
            colour.hex(colour.lawngreen, "每层攻击加速：" .. atkSpd .. '%'),
            colour.hex(colour.lawngreen, "每层移动提升：" .. move),
            colour.hex(colour.indianred, "每层受伤加深：" .. de .. '%'),
            colour.hex(colour.skyblue, "提升持续周期：3秒"),
            colour.hex(colour.skyblue, "乱打持续时间：15秒"),
            colour.hex(colour.yellow, "在狂风天气中，单次增益效果提升20%")
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local atkSpd = 15.25 + lv * 0.75
            local move = 16 + lv * 2
            local de = 3 + lv * 0.5
            return {
                "当攻击击中木飙时有4%的几率",
                "将其选为木飙，再对其攻击时，攻速移速会提升",
                "但是提升同时受到的伤害也将增加，先手者胜",
                "以上效果最高可叠加 7 层",
                colour.hex(colour.lawngreen, "每层攻击加速：" .. atkSpd .. '%'),
                colour.hex(colour.lawngreen, "每层移动提升：" .. move),
                colour.hex(colour.indianred, "每层受伤加深：" .. de .. '%'),
                colour.hex(colour.skyblue, "提升持续周期：3秒"),
                colour.hex(colour.skyblue, "乱打持续时间：10秒"),
                colour.hex(colour.yellow, "在狂风天气中，单次增益效果提升20%")
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function(attackData)
            if (math.rand(1, 100) <= 5) then
                this:effective({ targetUnit = attackData.targetUnit })
            end
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local tu = effectiveData.targetUnit
        u:prop("乱打木飙", tu)
        local lv = effectiveData.triggerAbility:level()
        u:orderAttackTargetUnit(tu)
        u:buff("乱打")
         :signal(BUFF_SIGNAL.up)
         :icon("ability/SkyreachWindWall")
         :description("已锁定木飙")
         :duration(15)
         :purpose(function(buffObj)
            buffObj:onEvent(EVENT.Unit.Attack, "乱打", function(attackData)
                local au = attackData.triggerUnit
                local tar = au:prop("乱打木飙")
                if (tar == attackData.targetUnit) then
                    local n = 0
                    if (au:buffHas("乱打上身")) then
                        n = au:prop("乱打层数")
                        au:buffClear({ key = "乱打上身" })
                    end
                    n = math.min(7, n + 1)
                    au:prop("乱打层数", n)
                    local atkSpd = n * (15.25 + lv * 0.75)
                    local move = n * (16 + lv * 2)
                    local de = n * (3 + lv * 0.5)
                    if (Game():isWeather("wind")) then
                        atkSpd = atkSpd * 1.2
                        move = move * 1.2
                    end
                    local effs = {
                        "buff/GaiaOrbs1",
                        "buff/GaiaOrbs2",
                        "buff/GaiaOrbs3",
                        "buff/GaiaOrbs4",
                        "buff/GaiaOrbs5",
                        "buff/GaiaOrbs6",
                        "buff/SwirlingEarth",
                    }
                    u:buff("乱打上身")
                     :icon("ability/SkyreachWindWall")
                     :text(tostring(n))
                     :description(
                        {
                            colour.hex(colour.gold, n .. "层"),
                            colour.hex(colour.lawngreen, "攻速提升：+" .. atkSpd .. '%'),
                            colour.hex(colour.lawngreen, "移动提升：+" .. move),
                            colour.hex(colour.indianred, "受伤加深：+" .. de .. '%'),
                        })
                     :duration(3)
                     :purpose(function(buffObj2)
                        if (n == 7) then
                            buffObj2:attach(effs[7], "origin")
                        else
                            for i = 1, 6 do
                                if (n >= i) then
                                    buffObj2:attach(effs[i], "origin")
                                else
                                    break
                                end
                            end
                        end
                        buffObj2:attackSpeed("+=" .. atkSpd)
                        buffObj2:move("+=" .. move)
                        buffObj2:hurtIncrease("+=" .. de)
                    end)
                     :rollback(function(buffObj2)
                        if (n == 7) then
                            buffObj2:detach(effs[7], "origin")
                        else
                            for i = 1, 6 do
                                if (n >= i) then
                                    buffObj2:detach(effs[i], "origin")
                                else
                                    break
                                end
                            end
                        end
                        buffObj2:attackSpeed("-=" .. atkSpd)
                        buffObj2:move("-=" .. move)
                        buffObj2:hurtIncrease("-=" .. de)
                    end)
                     :run()
                end
            end)
        end)
         :rollback(function(buffObj)
            buffObj:onEvent(EVENT.Unit.Attack, "乱打", nil)
            buffObj:clear("乱打木飙")
            buffObj:buffClear({ key = "乱打上身" })
        end)
         :run()
    end)