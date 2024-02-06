TPL_ABILITY_SOUL[21] = AbilityTpl()
    :name("扩散波纹")
    :targetType(ABILITY_TARGET_TYPE.tag_nil)
    :icon("ability/Rapids")
    :coolDownAdv(30, 0)
    :mpCostAdv(100, 5)
    :params(function(obj) return 27 + obj:level() * 6, 275, 18 end)
    :description(
    function(obj)
        local spilt, radius, dur = obj:params()
        return {
            "使自身攻击附带275半径范围水波扩散",
            colour.hex(colour.deepskyblue, "扩散伤害：" .. spilt .. '%'),
            colour.hex(colour.deepskyblue, "扩散半径：" .. radius),
            colour.hex(colour.skyblue, "持续时间：" .. dur .. "秒"),
            colour.hex(colour.yellow, "在雨天天气下，持续时间增加4秒")
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local spilt, radius, dur = obj:params()
            return {
                "当攻击击中后，有30%几率",
                "使自身攻击附带275半径范围水波扩散",
                colour.hex(colour.deepskyblue, "扩散伤害：" .. spilt .. '%'),
                colour.hex(colour.deepskyblue, "扩散半径：" .. radius),
                colour.hex(colour.skyblue, "持续时间：" .. dur .. "秒"),
                colour.hex(colour.yellow, "在雨天天气下，持续时间增加4秒")
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function()
            if (math.rand(1, 10) <= 3) then
                this:effective()
            end
        end)
    end)
    :onUnitEvent(EVENT.Unit.Attack,
    function(attackData)
        local u = attackData.triggerUnit
        if (u:buffHas("扩散波纹")) then
            local spilt, radius, _ = attackData.triggerAbility:params()
            local tu = attackData.targetUnit
            local dmg = spilt * 0.01 * attackData.damage
            ability.split({
                containSelf = true,
                sourceUnit = u,
                targetUnit = tu,
                damage = dmg,
                damageSrc = DAMAGE_SRC.ability,
                damageType = DAMAGE_TYPE.water,
                radius = radius,
                effect = "eff/WaterElementalImpactBase",
            })
        end
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local spilt, _, dur = effectiveData.triggerAbility:params()
        if (Game():isWeather("rain")) then
            dur = dur + 4
        end
        u:effect("buff/Rapids", 2)
        u:buff("扩散波纹")
         :signal(BUFF_SIGNAL.up)
         :icon("ability/Rapids")
         :description({ colour.hex(colour.lawngreen, "扩散：+" .. spilt .. '%') })
         :duration(dur)
         :purpose(function(buffObj)
            buffObj:attach("buff/BlackTide", "chest")
        end)
         :rollback(function(buffObj)
            buffObj:detach("buff/BlackTide", "chest")
        end)
         :run()
    end)