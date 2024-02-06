TPL_ABILITY_SOUL[2] = AbilityTpl()
    :name("追风步")
    :targetType(ABILITY_TARGET_TYPE.tag_nil)
    :icon("ability/Greenrun")
    :coolDownAdv(18, 0)
    :mpCostAdv(130, 5)
    :description(
    function(obj)
        local lv = obj:level()
        local move = 120 + lv * 5
        local avoid = 25 + lv * 3
        return {
            "追逐风的轨迹，提升移动速度的同时回避伤害",
            colour.format("%s内移动增加%s，回避增加%s", nil, {
                { colour.gold, "6秒" },
                { colour.lawngreen, move },
                { colour.lawngreen, avoid .. '%' },
            }),
            colour.hex(colour.yellow, "在狂风天气中，效果提升30%")
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Moving, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local move = 120 + lv * 5
            local avoid = 25 + lv * 3
            return {
                "当移动时会追逐风的轨迹",
                "提升移动速度的同时回避伤害",
                colour.format("%s内移动增加%s，回避增加%s", nil, {
                    { colour.gold, "6秒" },
                    { colour.lawngreen, move },
                    { colour.lawngreen, avoid .. '%' },
                }),
                colour.hex(colour.yellow, "在狂风天气中，效果提升30%")
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Moving, this:id(), function()
            this:effective()
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local lv = effectiveData.triggerAbility:level()
        local move = 120 + lv * 5
        local avoid = 25 + lv * 3
        if (Game():isWeather("wind")) then
            move = math.floor(move * 1.3)
            avoid = math.floor(avoid * 1.3)
        end
        u:buff("追风步")
         :signal(BUFF_SIGNAL.up)
         :icon("ability/Greenrun")
         :description({
            "快速移动",
            colour.hex(colour.lawngreen, "移动：+" .. move),
            colour.hex(colour.lawngreen, "回避：+" .. avoid .. '%'),
        })
         :duration(6)
         :purpose(function(buffObj)
            buffObj:attach("buff/Windwalk", "origin")
            buffObj:move("+=" .. move)
            buffObj:avoid("+=" .. avoid)
        end)
         :rollback(function(buffObj)
            buffObj:detach("buff/Windwalk", "origin")
            buffObj:avoid("-=" .. avoid)
            buffObj:move("-=" .. move)
        end)
         :run()
    end)