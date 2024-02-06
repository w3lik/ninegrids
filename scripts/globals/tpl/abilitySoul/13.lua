TPL_ABILITY_SOUL[13] = AbilityTpl()
    :name("凝化毒视")
    :targetType(ABILITY_TARGET_TYPE.tag_nil)
    :icon("ability/Petrifiedgaze")
    :coolDownAdv(25, 0)
    :mpCostAdv(70, 10)
    :castChantAdv(1, 0)
    :castKeepAdv(5, 0)
    :castRadiusAdv(500, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local atkSpd = 12 + lv * 3
        local move = 15 + lv * 5
        local def = 2 + lv
        local dur = 5
        local d = math.trunc(0.5 + lv * 0.1, 1)
        local dmg
        local bu = obj:prop("bindUnit")
        if (isClass(bu, UnitClass)) then
            dmg = math.floor(bu:defend()) * d
        else
            dmg = "防御x" .. d
        end
        return {
            "毒视前方大面积木飙，使其攻速移动速度逐渐变慢",
            "效果无视木飙的无敌，且还持续降低其防御",
            colour.hex(colour.indianred, "攻速/移动/防御降低：" .. atkSpd .. '%/' .. move .. '/' .. def),
            colour.hex(colour.indianred, "持续毒伤害：" .. dmg),
            colour.hex(colour.skyblue, "持续时间：" .. dur .. "秒"),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local atkSpd = 12 + lv * 3
            local move = 15 + lv * 5
            local def = 2 + lv
            local dur = 5
            local d = math.trunc(0.5 + lv * 0.1, 1)
            local dmg
            local bu = obj:prop("bindUnit")
            if (isClass(bu, UnitClass)) then
                dmg = math.floor(bu:defend()) * d
            else
                dmg = "防御x" .. d
            end
            return {
                "当击中近距离木飙时，毒视前方大面积木飙",
                "使范围内木飙移动速度逐渐变慢",
                "效果无视木飙的无敌，且还持续降低其防御",
                colour.hex(colour.indianred, "攻速/移动/防御降低：" .. atkSpd .. '%/' .. move .. '/' .. def),
                colour.hex(colour.indianred, "持续毒伤害：" .. dmg),
                colour.hex(colour.skyblue, "持续时间：" .. dur .. "秒"),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function(attackData)
            local d = vector2.distance(attackData.triggerUnit:x(), attackData.triggerUnit:y(), attackData.targetUnit:x(), attackData.targetUnit:y())
            if (d < 400) then
                this:effective()
            end
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local ab = effectiveData.triggerAbility
        local lv = ab:level()
        local radius = ab:castRadius()
        local t = u:prop("凝化毒视T")
        if (isClass(t, TimerClass)) then
            destroy(t)
            u:buffClear({ "凝化毒视" })
        end
        u:clear("凝化毒视T")
        u:buff("凝化毒视")
         :icon("ability/Petrifiedgaze")
         :description("凝化毒视中", "降低前方木飙速度")
         :duration(-1)
         :purpose(function(buffObj)
            buffObj:attach("buff/WaterArmor", "chest", -1)
            buffObj:attach("aura/ArcaneSeal", "chest", -1)
        end)
         :rollback(function(buffObj)
            buffObj:detach("buff/WaterArmor", "chest")
            buffObj:detach("aura/ArcaneSeal", "chest")
        end)
         :run()
        local dur = 5
        local frq = 0.5
        local fi = 0
        local d = math.trunc(0.5 + lv * 0.1, 1)
        local dmg = math.floor(u:defend()) * d
        t = time.setInterval(frq, function(curTimer)
            fi = fi + frq
            if (fi >= dur or u:isDead() or false == u:isAbilityKeepCasting()) then
                destroy(curTimer)
                u:clear("凝化毒视T")
                u:buffClear({ "凝化毒视" })
                return
            end
            local g = Group():catch(UnitClass, {
                circle = { x = u:x(), y = u:y(), radius = radius },
                filter = function(enumUnit)
                    local a = vector2.angle(u:x(), u:y(), enumUnit:x(), enumUnit:y())
                    local isFrontAngle = math.abs(a - u:facing()) < 90
                    return isFrontAngle and ab:isCastTarget(enumUnit)
                end
            })
            if (#g > 0) then
                local atkSpd = fi * (12 + lv * 3)
                local move = fi * (15 + lv * 5)
                local def = fi * (2 + lv)
                for _, eu in ipairs(g) do
                    eu:effect("DeathandDecayTarget", 1)
                    if (eu:buffHas("凝化状态")) then
                        eu:buffClear({ key = "凝化状态" })
                    end
                    ability.damage({
                        sourceUnit = u,
                        targetUnit = eu,
                        damage = dmg,
                        damageSrc = DAMAGE_SRC.ability,
                        damageType = DAMAGE_TYPE.poison,
                        damageTypeLevel = 1,
                        breakArmor = { BREAK_ARMOR.invincible }
                    })
                    eu:buff("凝化状态")
                      :signal(BUFF_SIGNAL.down)
                      :icon("ability/Petrifiedgaze")
                      :description(
                        {
                            colour.hex(colour.indianred, "攻速：-" .. atkSpd .. '%'),
                            colour.hex(colour.indianred, "移动：-" .. move),
                            colour.hex(colour.indianred, "防御：-" .. def)
                        })
                      :duration(3)
                      :purpose(
                        function(buffObj)
                            buffObj:attach("buff/BondagePurpleHD", "chest")
                            buffObj:attackSpeed("-=" .. atkSpd)
                            buffObj:move("-=" .. move)
                            buffObj:defend("-=" .. def)
                        end)
                      :rollback(
                        function(buffObj)
                            buffObj:detach("buff/BondagePurpleHD", "chest")
                            buffObj:attackSpeed("+=" .. atkSpd)
                            buffObj:move("+=" .. move)
                            buffObj:defend("+=" .. def)
                        end)
                      :run()
                end
            end
        end)
        u:prop("凝化毒视T", t)
    end)