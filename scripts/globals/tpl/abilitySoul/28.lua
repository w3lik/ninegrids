TPL_ABILITY_SOUL[28] = AbilityTpl()
    :name("光耀")
    :targetType(ABILITY_TARGET_TYPE.tag_nil)
    :icon("ability/PaladinJudgementofthePure")
    :coolDownAdv(30, 0)
    :mpCostAdv(135, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local hpRegen = 50 + lv * 15
        local dark = 22 + lv * 4
        local dur = 5
        return {
            "移除自身所有负面持续效果",
            "并在一段时间提升HP恢复和暗抗性",
            colour.hex(colour.lawngreen, "HP恢复加成：" .. hpRegen),
            colour.hex(colour.lawngreen, "暗抗加成：" .. dark .. '%'),
            colour.hex(colour.skyblue, "持续时间：" .. dur .. "秒"),
            colour.hex(colour.yellow, "在烈日天气下暗抗加成50%"),
            colour.hex(colour.yellow, "在幽月天气下持续时间加3秒"),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Hurt, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local hpRegen = 50 + lv * 15
            local dark = 22 + lv * 4
            local dur = 5
            return {
                "当受到伤害时有7%的几率",
                "移除自身所有负面持续效果",
                "并在一段时间提升HP恢复和暗抗性",
                colour.hex(colour.lawngreen, "HP恢复加成：" .. hpRegen),
                colour.hex(colour.lawngreen, "暗抗加成：" .. dark .. '%'),
                colour.hex(colour.skyblue, "持续时间：" .. dur .. "秒"),
                colour.hex(colour.yellow, "在烈日天气下暗抗加成50%"),
                colour.hex(colour.yellow, "在幽月天气下持续时间加3秒"),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Hurt, this:id(), function()
            if (math.rand(1, 100) <= 7) then
                this:effective()
            end
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local lv = effectiveData.triggerAbility:level()
        local hpRegen = 50 + lv * 15
        local dark = 22 + lv * 4
        local dur = 5
        if (Game():isWeather("sun")) then
            dark = dark * 1.5
        elseif (Game():isWeather("moon")) then
            dur = dur + 3
        end
        u:effect("eff/HolyLight2", 2)
        local bs = u:buffCatch({
            signal = BUFF_SIGNAL.down,
            filter = function(enumBuff) return enumBuff:duration() > 0 end,
        })
        if (#bs > 0) then
            for _, b in ipairs(bs) do
                b:back()
            end
        end
        u:buff("光耀")
         :signal(BUFF_SIGNAL.up)
         :icon("ability/PaladinJudgementofthePure")
         :description({ colour.hex(colour.lawngreen, "HP恢复：+" .. hpRegen), colour.hex(colour.lawngreen, "暗抗：+" .. dark .. '%') })
         :duration(dur)
         :purpose(function(buffObj)
            buffObj:attach("buff/RadianceOrange", "origin")
            buffObj:hpRegen("+=" .. hpRegen)
            buffObj:enchantResistance(DAMAGE_TYPE.dark, "+=" .. dark)
        end)
         :rollback(function(buffObj)
            buffObj:detach("buff/RadianceOrange", "origin")
            buffObj:hpRegen("-=" .. hpRegen)
            buffObj:enchantResistance(DAMAGE_TYPE.dark, "-=" .. dark)
        end)
         :run()
    end)