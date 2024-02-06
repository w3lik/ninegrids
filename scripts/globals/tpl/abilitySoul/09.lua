TPL_ABILITY_SOUL[9] = AbilityTpl()
    :name("霜寒回音")
    :targetType(ABILITY_TARGET_TYPE.pas)
    :coolDownAdv(1.5, 0)
    :mpCostAdv(0, 0)
    :icon("ability/HolyRighteousnessAura")
    :description(
    function(obj)
        local lv = obj:level()
        local radius = 225
        local de = 5.0 + lv * 0.8
        local dur = 3
        return {
            "造成攻击伤害时对木飙及周边" .. colour.hex(colour.gold, radius) .. "半径范围",
            "的木飙减慢" .. colour.hex(colour.indianred, de .. '%') .. "攻击速度",
            colour.hex(colour.skyblue, "效果持续：" .. dur .. "秒"),
            colour.hex(colour.yellow, "在雪天天气下，持续时间增加1秒"),
            colour.hex(colour.darkgray, "减速特效效果唯一"),
        }
    end)
    :onEvent(EVENT.Ability.Get, function(getData) getData.triggerUnit:attach("buff/Musicnote", "origin") end)
    :onEvent(EVENT.Ability.Lose, function(loseData) loseData.triggerUnit:detach("buff/Musicnote", "origin") end)
    :onUnitEvent(EVENT.Unit.Attack, function(attackData) attackData.triggerAbility:effective({ targetUnit = attackData.targetUnit }) end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local ab = effectiveData.triggerAbility
        local tu = effectiveData.targetUnit
        local lv = ab:level()
        local radius = 225
        local de = 5.0 + lv * 0.8
        local dur = 3
        if (Game():isWeather("snow")) then
            dur = dur + 1
        end
        local g = Group():catch(UnitClass, {
            limit = 3,
            circle = { x = tu:x(), y = tu:y(), radius = radius },
            filter = function(enumUnit)
                return ab:isCastTarget(enumUnit) and true ~= enumUnit:buffHas("霜寒回音")
            end
        })
        if (#g > 0) then
            for _, eu in ipairs(g) do
                eu:effect("FrostDamage", dur)
                eu:buff("霜寒回音")
                  :signal(BUFF_SIGNAL.down)
                  :icon("ability/HolyRighteousnessAura")
                  :description({ "回音减速", colour.hex(colour.indianred, "攻速：-" .. de .. '%') })
                  :duration(dur)
                  :purpose(function(buffObj) buffObj:attackSpeed("-=" .. de) end)
                  :rollback(function(buffObj) buffObj:attackSpeed("+=" .. de) end)
                  :run()
            end
        end
    end)