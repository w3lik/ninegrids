TPL_ABILITY_SOUL[47] = AbilityTpl()
    :name("泠音舞域")
    :targetType(ABILITY_TARGET_TYPE.tag_circle)
    :icon("ability/ChaoticMusic")
    :condition(function() return Game():achievement(11) == true end)
    :conditionTips("响彻大泠音")
    :coolDownAdv(40, 0)
    :mpCostAdv(200, 10)
    :castChantAdv(1, 0)
    :castChantEffect("buff/Musicnote")
    :castRadiusAdv(400, 0)
    :castDistanceAdv(800, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local radius = obj:castRadius()
        local stun = math.trunc(0.1 + lv * 0.02, 2)
        local fly = math.trunc(0.3 + lv * 0.05, 2)
        local hurtIncrease = 10 + lv * 5
        return {
            "在位置形成 " .. radius .. " 半径的泠音舞域9秒",
            colour.hex(colour.violet, "敌我双方在里面都会受到影响"),
            "木飙有几率会进入眩晕或升天",
            "异样快乐的同时将会承受更大的伤害",
            colour.hex(colour.indianred, "受伤加深：" .. hurtIncrease .. '%'),
            colour.hex(colour.indianred, "眩晕时间：" .. stun .. "秒"),
            colour.hex(colour.indianred, "升天时间：" .. fly .. "秒"),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local radius = obj:castRadius()
            local stun = math.trunc(0.1 + lv * 0.02, 2)
            local fly = math.trunc(0.3 + lv * 0.05, 2)
            local hurtIncrease = 10 + lv * 5
            return {
                "当攻击击中木飙时有5%的几率",
                "在后撤位置形成 " .. radius .. " 半径的泠音舞域11秒",
                colour.hex(colour.violet, "敌我双方在里面都会受到影响"),
                "木飙有几率会进入眩晕或升天",
                "异样快乐的同时将会承受更大的伤害",
                colour.hex(colour.indianred, "受伤加深：" .. hurtIncrease .. '%'),
                colour.hex(colour.indianred, "眩晕时间：" .. stun .. "秒"),
                colour.hex(colour.indianred, "升天时间：" .. fly .. "秒"),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function(attackData)
            if (math.rand(1, 100) <= 5) then
                local u = attackData.triggerUnit
                local tu = attackData.targetUnit
                local ux, uy = u:x(), u:y()
                local tx, ty = tu:x(), tu:y()
                local ang = vector2.angle(ux, uy, tx, ty)
                local x, y = vector2.polar(tx, ty, 250, ang)
                this:effective({
                    targetX = x,
                    targetY = y,
                })
            end
        end)
    end)
    :castTargetFilter(CAST_TARGET_FILTER.notNeutral)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local ab = effectiveData.triggerAbility
        local lv = ab:level()
        local radius = ab:castRadius()
        local duration = 9
        local hurtIncrease = 10 + lv * 5
        local x, y, z = effectiveData.targetX, effectiveData.targetY, effectiveData.targetZ
        AuraAttach()
            :radius(radius)
            :duration(duration)
            :centerPosition({ x, y, z })
            :centerEffect("aura/Drop_The_Beat", nil, radius / 256)
            :filter(
            function(enumUnit)
                return enumUnit:isAlive() and enumUnit:owner():isNeutral() == false
            end)
            :onEvent(EVENT.Aura.Enter,
            function(auraData)
                local eu = auraData.triggerUnit
                eu:buff("泠音舞域狂热")
                  :icon("ability/ChaoticMusic")
                  :description(colour.hex(colour.indianred, "受伤加深：+" .. hurtIncrease .. '%'))
                  :duration(-1)
                  :purpose(function(buffObj)
                    buffObj:attach("buff/Musicnote", "chest")
                    buffObj:hurtIncrease("+=" .. hurtIncrease)
                end)
                  :rollback(function(buffObj)
                    buffObj:detach("buff/Musicnote", "chest")
                    buffObj:hurtIncrease("-=" .. hurtIncrease)
                end)
                  :run()
            end)
            :onEvent(EVENT.Aura.Leave,
            function(auraData)
                auraData.triggerUnit:buffClear({ key = "泠音舞域狂热" })
            end)
        audio(V3d("soulMusic"), nil, function(this)
            this:xyz(x, y, z)
            this:volume(100)
        end)
        local e = Effect("aura/Drop_The_Beat_White", x, y, z, duration):size(radius * 0.73 / 256)
        local ti = 0
        local frq = 0.65
        time.setInterval(frq, function(curTimer)
            ti = ti + frq
            if (ti >= duration) then
                destroy(curTimer)
                destroy(e)
                return
            end
            local g = Group():catch(UnitClass, {
                limit = 5,
                circle = { x = x, y = y, radius = radius },
                filter = function(enumUnit)
                    return ab:isCastTarget(enumUnit)
                end
            })
            if (#g > 0) then
                local stun = math.trunc(0.1 + lv * 0.02, 2)
                local fly = math.trunc(0.3 + lv * 0.05, 2)
                for _, eu in ipairs(g) do
                    local typ = math.rand(1, 2)
                    if (typ == 1) then
                        effector("eff/ArcaneNova", eu:x(), eu:y(), nil, 1.2)
                        ability.crackFly({
                            name = "泠音舞域音轰",
                            icon = "ability/ChaoticMusic",
                            description = "被声音轰上天了",
                            sourceUnit = u,
                            targetUnit = eu,
                            height = math.rand(100, 200),
                            duration = fly,
                        })
                    else
                        effector("eff/ArcaneNova", eu:x(), eu:y(), nil, 1.2)
                        ability.stun({
                            name = "泠音舞域音震",
                            icon = "ability/ChaoticMusic",
                            description = "被声音震晕了",
                            sourceUnit = u,
                            targetUnit = eu,
                            duration = stun,
                        })
                    end
                end
            end
        end)
    end)