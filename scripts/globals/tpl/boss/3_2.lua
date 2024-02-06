TPL_ABILITY_BOSS["死泠(镰刀)"] = {
    AbilityTpl()
        :name("致死量")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :icon("ability/MiscHellifrePVPCombatMorale")
        :coolDownAdv(25, 0)
        :mpCostAdv(75, 0)
        :castRadiusAdv(666, 0)
        :castChantAdv(2, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            return {
                "呼唤范围内的木飙，当木飙HP低于40%时",
                "令其" .. colour.hex(colour.indianred, "直接死亡"),
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 15) then
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
            effector("slash/Swing_knife", x, y, japi.Z(x, y) + 100, 1)
            Effect("eff/HandOfDeath", x, y, nil, 1):size(1.5)
            for i = 1, 3 do
                local x2, y2 = vector2.polar(x, y, radius * 0.75, 120 * i)
                Effect("eff/HandOfDeath", x2, y2, nil, 1):size(1.2)
            end
            local g = Group():catch(UnitClass, {
                circle = { x = x, y = y, radius = radius },
                limit = 10,
                filter = function(enumUnit)
                    return ab:isCastTarget(enumUnit)
                end
            })
            if (#g > 0) then
                for _, eu in ipairs(g) do
                    local ep = eu:hpCur() / eu:hp()
                    if (ep < 0.4) then
                        eu:effect("eff/BloodExplosion", 0.5)
                        eu:lastHurtSource(u)
                        eu:kill()
                    end
                end
            end
        end),
    AbilityTpl()
        :name("秽土气息")
        :description(
        {
            "每当减少 25% 的HP，死亡至力越盛，",
            "产生力量叠层，增幅自身的伤害 12%",
            "效果最多叠加3层，达到 36% 的伤害增幅",
        })
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/RogueEnvelopingShadows")
        :onEvent(EVENT.Ability.Get,
        function(abData)
            local ak = abData.triggerAbility:id()
            abData.triggerUnit:onEvent(EVENT.Prop.Change, ak, function(changeData)
                if (changeData.key == "hpCur") then
                    local u = changeData.triggerUnit
                    u:buffClear({ key = "秽土气息" .. ak })
                    local cur = changeData.new
                    if (cur > 0) then
                        local hp = u:hp()
                        local n = math.floor((hp - cur) / hp * 25)
                        n = math.min(3, n)
                        if (n > 0) then
                            local dmgInc = 12 * n
                            u:buff("秽土气息" .. ak)
                             :name("秽土气息")
                             :signal(BUFF_SIGNAL.up)
                             :icon("ability/RogueEnvelopingShadows")
                             :text(colour.hex(colour.gold, n))
                             :description({
                                colour.hex(colour.gold, n .. "层") .. "秽土气息",
                                colour.hex(colour.lawngreen, "伤害：+" .. dmgInc .. '%'),
                            })
                             :duration(-1)
                             :purpose(function(buffObj)
                                buffObj:damageIncrease("+=" .. dmgInc)
                                buffObj:attach("CurseTarget", "overhead")
                            end)
                             :rollback(function(buffObj)
                                buffObj:damageIncrease("-=" .. dmgInc)
                                buffObj:detach("CurseTarget", "overhead")
                            end)
                             :run()
                        end
                    end
                end
            end)
        end)
        :onEvent(EVENT.Ability.Lose,
        function(abData)
            local ak = abData.triggerAbility:id()
            abData.triggerUnit:onEvent(EVENT.Prop.Change, ak, nil)
            abData.triggerUnit:buffClear({ key = "秽土气息" .. ak })
        end),
    AbilityTpl()
        :name("亡泠三角锁链")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/NatureGroundingTotem")
        :description(
        function(this)
            local re = -1
            local bu = this:bindUnit()
            if (isClass(bu, UnitClass)) then
                re = bu:reborn()
            end
            if (re >= 0) then
                return {
                    "锁住灵泠，在死亡后可复活1次",
                    colour.hex(colour.lawngreen, re .. "秒会再次复活"),
                }
            else
                return {
                    "三角锁链已失效",
                }
            end
        end)
        :onEvent(EVENT.Ability.Get,
        function(getData)
            local u = getData.triggerUnit
            u:buff("亡泠三角锁链")
             :name("亡泠三角锁链")
             :icon("ability/NatureGroundingTotem")
             :description({ "被三角锁链锁住的亡泠不会死亡" })
             :duration(-1)
             :purpose(function(buffObj)
                u:reborn(10)
                buffObj:attach("buff/BondagePurpleSD", "origin")
            end)
             :rollback(function(buffObj)
                u:reborn(-999)
                buffObj:detach("buff/BondagePurpleSD", "origin")
            end)
             :run()
        end)
        :onEvent(EVENT.Ability.Lose,
        function(loseData)
            local u = loseData.triggerUnit
            u:buffClear({ key = "亡泠三角锁链" })
        end)
        :onUnitEvent(EVENT.Unit.FeignDead,
        function(feignDeadData)
            local u = feignDeadData.triggerUnit
            Effect("buff/BondagePurpleSD", u:x(), u:y(), 200, u:reborn()):size(4)
            u:buffClear({ key = "亡泠三角锁链" })
            feignDeadData.triggerAbility:ban("失效")
        end),
}