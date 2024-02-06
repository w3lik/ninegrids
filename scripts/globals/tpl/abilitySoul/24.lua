TPL_ABILITY_SOUL[24] = AbilityTpl()
    :name("战吼践踏")
    :targetType(ABILITY_TARGET_TYPE.tag_nil)
    :icon("ability/Echotrample2")
    :coolDownAdv(19, 0)
    :mpCostAdv(95, 5)
    :castKeepAdv(5, 0)
    :keepAnimation("spell slam")
    :castRadiusAdv(260, 20)
    :description(
    function(obj)
        local lv = obj:level()
        local dmg = 90 + lv * 45
        local dmg2 = 240 + lv * 120
        local atk = 24 + lv * 13
        return {
            "每秒发起 1 次范围践踏，最多 5 次",
            "第4次践踏时发出怒吼，增加自身攻击" .. colour.hex(colour.gold, atk) .. "点 6 秒",
            "最后一次会使出地裂至力，极大地伤害敌人",
            "而被践踏到的敌人，都会眩晕无法行动 0.6 秒",
            colour.hex(colour.indianred, "前4次践踏岩伤害：" .. dmg),
            colour.hex(colour.red, "第5次践踏火伤害：30%攻击力+" .. dmg2),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local dmg = 90 + lv * 45
            local dmg2 = 240 + lv * 120
            local atk = 24 + lv * 13
            return {
                "当攻击击中时有10%的几率，每秒发起 1 次范围践踏，最多 5 次",
                "第4次践踏时发出怒吼，增加自身攻击" .. colour.hex(colour.gold, atk) .. "点 6 秒",
                "最后一次会使出地裂至力，极大地伤害敌人",
                "而被践踏到的敌人，都会眩晕无法行动 0.6 秒",
                colour.hex(colour.indianred, "前4次践踏岩伤害：" .. dmg),
                colour.hex(colour.red, "第5次践踏火伤害：30%攻击力+" .. dmg2),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function()
            if (math.rand(1, 10) == 5) then
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
        local x, y = u:x(), u:y()
        local dmg = 90 + lv * 45
        local dmg2 = math.floor(240 + lv * 120 + 0.3 * u:attack())
        local atk = 24 + lv * 13
        local i = 0
        time.setInterval(0.5, function(curTimer)
            i = i + 1
            if (i > 5 or u:isAbilityKeepCasting() == false) then
                destroy(curTimer)
                return
            end
            curTimer:period(1)
            effector("WarStompCaster", x, y, nil, 1)
            effector("RoarCaster", x, y, nil, 1)
            Effect("eff/RedDrum", x, y, nil, 1):size(radius / 300)
            local g = Group():catch(UnitClass, {
                filter = function(enumUnit) return ab:isCastTarget(enumUnit) end,
                circle = { x = x, y = y, radius = radius },
            })
            if (i < 4) then
                if (i == 4) then
                    u:buff("战吼践踏")
                     :signal(BUFF_SIGNAL.up)
                     :icon("ability/Echotrample2")
                     :description({ colour.hex(colour.lawngreen, "攻击：+" .. atk) })
                     :duration(6)
                     :purpose(function(buffObj) buffObj:attack("+=" .. atk) end)
                     :rollback(function(buffObj) buffObj:attack("-=" .. atk) end)
                     :run()
                end
                if (#g > 0) then
                    for _, eu in ipairs(g) do
                        ability.damage({
                            sourceUnit = u,
                            targetUnit = eu,
                            damage = dmg,
                            damageSrc = DAMAGE_SRC.ability,
                            damageType = DAMAGE_TYPE.rock,
                            damageTypeLevel = 2,
                        })
                        ability.stun({
                            sourceUnit = u,
                            targetUnit = eu,
                            duration = 0.6,
                            effect = "StasisTotemTarget"
                        })
                    end
                end
            else
                Effect("eff/LavaBurst", x, y, 10, 2):size(radius / 230)
                if (#g > 0) then
                    for _, eu in ipairs(g) do
                        ability.damage({
                            sourceUnit = u,
                            targetUnit = eu,
                            damage = dmg2,
                            damageSrc = DAMAGE_SRC.ability,
                            damageType = DAMAGE_TYPE.fire,
                            damageTypeLevel = 3,
                        })
                        ability.stun({
                            sourceUnit = u,
                            targetUnit = eu,
                            duration = 0.6,
                            effect = "StasisTotemTarget"
                        })
                    end
                end
            end
        end)
    end)