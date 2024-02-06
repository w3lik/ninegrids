TPL_ABILITY_SOUL[22] = AbilityTpl()
    :name("跳跳花种")
    :targetType(ABILITY_TARGET_TYPE.tag_unit)
    :icon("ability/Forestseed")
    :coolDownAdv(23, 0)
    :mpCostAdv(80, 5)
    :castRadiusAdv(50, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local n = 2 + math.ceil(lv / 2)
        local move = 16 + lv * 2
        local d = math.trunc(0.05 + lv * 0.01, 2)
        local dmg
        local bu = obj:prop("bindUnit")
        if (isClass(bu, UnitClass)) then
            dmg = math.floor(bu:attack()) * d
        else
            dmg = "攻击 x " .. d
        end
        return {
            colour.hex(colour.lawngreen, "投掷出" .. n .. "个调皮的花种子抨击木飙"),
            colour.hex(colour.lawngreen, "花种子击中木飙后还会环绕弹跳 1 次"),
            colour.hex(colour.lawngreen, "而且每次都有30%几率使木飙被纠缠减速 5 秒"),
            colour.hex(colour.indianred, "抨击草伤害：" .. dmg),
            colour.hex(colour.indianred, "纠缠减移速：" .. move),
            colour.hex(colour.yellow, "在烈日天气下，弹跳次数+1")
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local n = 2 + math.ceil(lv / 2)
            local move = 16 + lv * 2
            local d = math.trunc(0.05 + lv * 0.01, 2)
            local dmg
            local bu = obj:prop("bindUnit")
            if (isClass(bu, UnitClass)) then
                dmg = math.floor(bu:attack()) * d
            else
                dmg = "攻击 x " .. d
            end
            return {
                "当攻击击中后，有40%几率",
                colour.hex(colour.lawngreen, "投掷出" .. n .. "个调皮的花种子抨击木飙"),
                colour.hex(colour.lawngreen, "花种子击中木飙后还会环绕弹跳 1 次"),
                colour.hex(colour.lawngreen, "而且每次都有30%几率使木飙被纠缠减速 5 秒"),
                colour.hex(colour.indianred, "抨击草伤害：" .. dmg),
                colour.hex(colour.indianred, "纠缠减移速：" .. move),
                colour.hex(colour.yellow, "在烈日天气下，弹跳次数+1")
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function(attackData)
            if (math.rand(1, 10) <= 4) then
                this:effective({ targetUnit = attackData.targetUnit })
            end
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local tu = effectiveData.targetUnit
        local lv = effectiveData.triggerAbility:level()
        local n = 2 + math.ceil(lv / 2)
        local move = 16 + lv * 2
        local d = math.trunc(0.05 + lv * 0.01, 2)
        local dmg = math.floor(u:attack()) * d
        local reflex = 1
        if (Game():isWeather("sun")) then
            reflex = reflex + 1
        end
        for _ = 1, n do
            ability.missile({
                modelAlias = "missile/Seed_Shot",
                sourceUnit = u,
                targetUnit = tu,
                weaponLength = 100,
                weaponHeight = 150,
                reflex = reflex,
                height = math.rand(300, 400),
                speed = math.rand(500, 600),
                shake = "rand",
                onEnd = function(opt)
                    local eu = opt.targetUnit
                    eu:effect("eff/Seed_Squirt", 1)
                    ability.damage({
                        sourceUnit = opt.sourceUnit,
                        targetUnit = eu,
                        damage = dmg,
                        damageSrc = DAMAGE_SRC.ability,
                        damageType = DAMAGE_TYPE.grass,
                        damageTypeLevel = 1,
                    })
                    if (math.rand(1, 100) <= 30) then
                        eu:buff("跳跳花种纠缠")
                          :signal(BUFF_SIGNAL.down)
                          :icon("ability/Forestseed")
                          :description({ colour.hex(colour.indianred, "移动：-" .. move) })
                          :duration(5)
                          :purpose(function(buffObj)
                            buffObj:attach("buff/Seed_Inside", "origin")
                            buffObj:move("-=" .. move)
                        end)
                          :rollback(function(buffObj)
                            buffObj:detach("buff/Seed_Inside", "origin")
                            buffObj:move("+=" .. move)
                        end)
                          :run()
                    end
                    return true
                end
            })
        end
    end)