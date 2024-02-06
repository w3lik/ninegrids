TPL_ABILITY_SOUL[15] = AbilityTpl()
    :name("迅风缠")
    :targetType(ABILITY_TARGET_TYPE.tag_unit)
    :icon("ability/IronmaidensBladerush")
    :coolDownAdv(7, 0)
    :mpCostAdv(220, 20)
    :castDistanceAdv(350, 5)
    :castRadiusAdv(50, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local n = 4 + lv
        local dmg = 45 + lv * 17
        return {
            "以缠击成风卷将敌人升起，陷入迷茫无法行动",
            "施以凌风至剑技连续对木飙缠出" .. colour.hex(colour.gold, n) .. "剑",
            colour.hex(colour.indianred, "每次缠击风伤害：" .. dmg),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local n = 4 + lv
            local dmg = 45 + lv * 17
            return {
                "当击中木飙后，有50%几率再以缠击成风卷",
                "木飙会被升起并在期间陷入迷茫无法行动",
                "施以凌风至剑技连续对木飙缠出" .. colour.hex(colour.gold, n) .. "剑",
                colour.hex(colour.indianred, "每次缠击风伤害：" .. dmg),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function(attackData)
            if (math.rand(1, 10) <= 5) then
                this:effective({ targetUnit = attackData.targetUnit })
            end
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local tu = effectiveData.targetUnit
        local ab = effectiveData.triggerAbility
        local lv = ab:level()
        local n = 6 + lv
        local dmg = 45 + lv * 17
        u:buff("迅风缠")
         :icon("ability/IronmaidensBladerush")
         :description("发动缠击中")
         :duration(-1)
         :purpose(
            function(buffObj)
                buffObj:effect("eff/WindWeak", 2)
                buffObj:effect("eff/WindWeak2", 2)
                buffObj:superposition("invulnerable", "+=1")
                buffObj:superposition("pause", "+=1")
                buffObj:rgba(nil, nil, nil, 50)
            end)
         :rollback(
            function(buffObj)
                buffObj:rgba(nil, nil, nil, 255)
                buffObj:superposition("invulnerable", "-=1")
                buffObj:superposition("pause", "-=1")
            end)
         :run()
        ability.missile({
            modelAlias = "CycloneTarget",
            sourceUnit = u,
            targetUnit = tu,
            speed = 1200,
            scale = 0.5,
            onEnd = function(options)
                local tar = options.targetUnit
                tar:buff("迅风缠迷茫")
                   :icon("ability/IronmaidensBladerush")
                   :signal(BUFF_SIGNAL.down)
                   :description("身处迷茫至中无法行动")
                   :duration(-1)
                   :purpose(
                    function(buffObj)
                        buffObj:effect("eff/WindWeakThicker", 2)
                        buffObj:superposition("pause", "+=1")
                        buffObj:attach("Tornado_Target", "foot")
                        buffObj:attach("buff/FlyingSword", "chest")
                        local i = 0
                        time.setInterval(0.05, function(curTimer)
                            i = i + 1
                            if (i > 40 or isDestroy(buffObj)) then
                                destroy(curTimer)
                                return
                            end
                            buffObj:flyHeight("+=5")
                        end)
                    end)
                   :rollback(
                    function(buffObj)
                        local i = 0
                        time.setInterval(0.05, function(curTimer)
                            i = i + 1
                            if (i > 40 or isDestroy(buffObj)) then
                                destroy(curTimer)
                                buffObj:detach("Tornado_Target", "foot")
                                buffObj:detach("buff/FlyingSword", "chest")
                                buffObj:superposition("pause", "-=1")
                                return
                            end
                            buffObj:flyHeight("-=5")
                        end)
                    end)
                   :run()
            end
        })
        local _end = function()
            tu:buffClear({ key = "迅风缠迷茫", limit = 1 })
            u:buffClear({ key = "迅风缠", limit = 1 })
        end
        local _slash
        _slash = function(m)
            local x1, y1, x2, y2 = u:x(), u:y(), tu:x(), tu:y()
            local h1, h2 = u:h(), tu:h()
            local fac = vector2.angle(x1, y1, x2, y2)
            local x, y = vector2.polar(x2, y2, math.rand(100, 200), fac + 15)
            local z = 0
            if (h1 > h2) then
                z = h2 - (h1 - h2)
            elseif (h1 < h2) then
                z = h2 + (h2 - h1)
            else
                z = h2 + 250
            end
            effector("slash/Round_dance3", x2, y2, h2, 0.6)
            local sw = math.rand(1, 4)
            audio(V3d("sword" .. sw), nil, function(this) this:xyz(x2, y2, h2) end)
            ability.leap({
                sourceUnit = u,
                targetUnit = tu,
                targetVec = { x, y, z },
                modelAlias = "buff/WindwalkNecroSoul",
                speed = 1600,
                height = 0,
                onEnd = function(options)
                    if (options.sourceUnit:isDead() or options.targetUnit:isDead()) then
                        _end()
                        return
                    end
                    ability.damage({
                        sourceUnit = options.sourceUnit,
                        targetUnit = options.targetUnit,
                        damage = dmg,
                        damageSrc = DAMAGE_SRC.attack,
                        damageType = DAMAGE_TYPE.wind,
                        damageTypeLevel = 1,
                    })
                    m = m + 1
                    if (m >= n or options.sourceUnit:isDead() or options.targetUnit:isDead()) then
                        _end()
                        return
                    end
                    _slash(m)
                end
            })
        end
        _slash(0)
    end)