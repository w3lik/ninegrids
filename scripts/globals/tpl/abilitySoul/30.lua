TPL_ABILITY_SOUL[30] = AbilityTpl()
    :name("磁极环")
    :targetType(ABILITY_TARGET_TYPE.tag_nil)
    :icon("ability/DeathKnightAntiMagicZone")
    :coolDownAdv(1, 0)
    :mpCostAdv(80, 10)
    :castDistanceAdv(400, 0)
    :castChantAdv(0.5, 0)
    :castRadiusAdv(425, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local n = 2 + lv
        local thunder = 5 + lv * 2
        local d = math.trunc(0.2 + lv * 0.11, 2)
        local dmg
        local bu = obj:prop("bindUnit")
        if (isClass(bu, UnitClass)) then
            dmg = math.floor(bu:defend()) * d
        else
            dmg = "防御 x " .. d
        end
        local dmg2 = 30 + lv * 10
        return {
            "每秒对附近木飙随机进行2种电磁打击",
            "红电降低木飙雷抗3秒，蓝电造成闪雷伤害",
            "打击生效时会充能磁圈，最高充" .. colour.hex(colour.gold, n) .. "层",
            colour.hex(colour.gold, "充能后可释放所有能量进行一次雷爆伤害"),
            colour.hex(colour.indianred, "红电雷抗降低：" .. thunder .. '%'),
            colour.hex(colour.indianred, "蓝电闪雷伤害：" .. dmg),
            colour.hex(colour.indianred, "雷爆每层伤害：" .. dmg2),
            colour.hex(colour.yellow, "在雷雨天气下可多充能3层"),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local n = 2 + lv
            local thunder = 5 + lv * 2
            local d = math.trunc(0.2 + lv * 0.11, 2)
            local dmg
            local bu = obj:prop("bindUnit")
            if (isClass(bu, UnitClass)) then
                dmg = math.floor(bu:defend()) * d
            else
                dmg = "防御 x " .. d
            end
            local dmg2 = 30 + lv * 10
            return {
                "每秒对附近木飙随机进行2种电磁打击",
                "红电降低木飙雷抗3秒，蓝电造成闪雷伤害",
                "打击生效时会充能磁圈，最高充" .. colour.hex(colour.gold, n) .. "层",
                colour.hex(colour.gold, "充能后攻击会释放所有能量进行一次雷爆伤害"),
                colour.hex(colour.indianred, "红电雷抗降低：" .. thunder .. '%'),
                colour.hex(colour.indianred, "蓝电闪雷伤害：" .. dmg),
                colour.hex(colour.indianred, "雷爆每层伤害：" .. dmg2),
                colour.hex(colour.yellow, "在雷雨天气下可多充能3层"),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function()
            this:effective()
        end)
    end)
    :onEvent(EVENT.Ability.Get,
    function(abData)
        local u = abData.triggerUnit
        local ab = abData.triggerAbility
        local radius = ab:castRadius()
        local b = u:buff("磁极环")
        b:icon("ability/DeathKnightAntiMagicZone")
         :text('0')
         :prop("charge", 0)
         :duration(-1)
         :description(
            function(obj)
                if (isClass(u, UnitClass) == false) then
                    return ''
                end
                local lv = ab:level()
                local n = 2 + lv
                if (Game():isWeather("rainStorm")) then
                    n = n + 3
                end
                local cur = obj:prop("charge") or 0
                local desc = {}
                if (cur >= n) then
                    desc[#desc + 1] = "已充满"
                else
                    desc[#desc + 1] = "充能中"
                end
                desc[#desc + 1] = colour.hex(colour.gold, cur .. "层")
                return desc
            end)
         :purpose(function(buffObj)
            buffObj:attach("buff/UbershieldArcane", "chest")
            local t = time.setInterval(1, function()
                if (buffObj:isDead() or buffObj:buffHas("磁极环") == false) then
                    return
                end
                local lv = ab:level()
                local g = Group():catch(UnitClass, {
                    circle = { x = buffObj:x(), y = buffObj:y(), radius = radius },
                    limit = 5,
                    filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
                })
                if (#g > 0) then
                    local n = 2 + lv
                    if (Game():isWeather("rainStorm")) then
                        n = n + 3
                    end
                    local cur = b:prop("charge")
                    if (cur == nil) then
                        cur = 1
                    elseif (cur < n) then
                        cur = cur + 1
                    end
                    b:prop("charge", cur)
                    b:text(tostring(cur))
                    local thunder = 5 + lv * 2
                    local d = math.trunc(0.2 + lv * 0.11, 2)
                    local dmg = math.floor(u:defend()) * d
                    for _, eu in ipairs(g) do
                        if (math.rand(1, 2) == 1) then
                            lightning(LIGHTNING_TYPE.thunderRed, u:x(), u:y(), u:h(), eu:x(), eu:y(), eu:h(), 0.3)
                            eu:buff("磁极红雷")
                              :signal(BUFF_SIGNAL.down)
                              :icon("ability/DeathKnightAntiMagicZone")
                              :description({ colour.hex(colour.indianred, "雷抗：-" .. thunder .. '%') })
                              :duration(3)
                              :purpose(function(buffObj2)
                                buffObj2:enchantResistance(DAMAGE_TYPE.thunder, "-=" .. thunder)
                            end)
                              :rollback(function(buffObj2)
                                buffObj2:enchantResistance(DAMAGE_TYPE.thunder, "+=" .. thunder)
                            end)
                              :run()
                        else
                            lightning(LIGHTNING_TYPE.thunder, u:x(), u:y(), u:h(), eu:x(), eu:y(), eu:h(), 0.3)
                            ability.damage({
                                sourceUnit = u,
                                targetUnit = eu,
                                damage = dmg,
                                damageSrc = DAMAGE_SRC.ability,
                                damageType = DAMAGE_TYPE.thunder,
                                damageTypeLevel = 0,
                            })
                        end
                    end
                end
            end)
            buffObj:prop("chargeTimer", t)
        end)
         :rollback(function(buffObj)
            buffObj:detach("buff/UbershieldArcane", "chest")
            buffObj:clear("chargeTimer", true)
        end)
         :run()
    end)
    :onEvent(EVENT.Ability.Lose,
    function(abData)
        local u = abData.triggerUnit
        u:buffClear({ key = "磁极环" })
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local ab = effectiveData.triggerAbility
        local lv = ab:level()
        local radius = ab:castRadius()
        local dmg2 = 30 + lv * 10
        local b = u:buffOne("磁极环")
        if (b == nil) then
            async.call(u:owner(), function()
                UI_NinegridsInfo:info("alert", 2, "充能未完成")
            end)
            return
        end
        local n = b:prop("charge") or 0
        b:clear("charge")
        if (n <= 0) then
            async.call(u:owner(), function()
                UI_NinegridsInfo:info("alert", 2, "无磁化充能")
            end)
            return
        end
        local x, y, z = u:x(), u:y(), u:h()
        effector("eff/EmptyThunder", x, y, 30 + z, 1)
        local g = Group():catch(UnitClass, {
            circle = { x = x, y = y, radius = radius },
            limit = 10,
            filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
        })
        if (#g > 0) then
            for _, eu in ipairs(g) do
                eu:attach(":war3mapImports/ElectricMouseStand.mdl", "chest", 0.5)
                ability.damage({
                    sourceUnit = u,
                    targetUnit = eu,
                    damage = dmg2 * n,
                    damageSrc = DAMAGE_SRC.ability,
                    damageType = DAMAGE_TYPE.thunder,
                    damageTypeLevel = 1,
                })
            end
        end
    end)