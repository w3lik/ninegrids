TPL_ABILITY_SOUL[16] = AbilityTpl()
    :name("顺势反击")
    :targetType(ABILITY_TARGET_TYPE.tag_nil)
    :icon("ability/ShadowlessBoxing")
    :coolDownAdv(8, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local dur = 0.4 + lv * 0.1
        local reduce = 40 + lv * 4
        return {
            "架起多个大盾形成盾牌持续 " .. colour.hex(colour.gold, dur) .. " 秒",
            "守护期间受到的所有伤害都会减少 " .. colour.hex(colour.gold, reduce .. '%'),
            colour.hex(colour.indianred, "而且会完全反弹一切受到的伤害"),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.BeforeHurt, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local dur = 0.4 + lv * 0.1
            local reduce = 40 + lv * 4
            return {
                "当受到伤害前，架起多个大盾防御并反弹伤害",
                "护盾持续 " .. colour.hex(colour.gold, dur) .. " 秒",
                "守护期间受到的所有伤害都会减少 " .. colour.hex(colour.gold, reduce .. '%'),
                colour.hex(colour.indianred, "而且会完全反弹一切受到的伤害"),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.BeforeHurt, this:id(), function()
            this:effective()
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local ab = effectiveData.triggerAbility
        local lv = ab:level()
        local dur = 0.4 + lv * 0.1
        local reduce = 40 + lv * 4
        u:buff("顺势反击")
         :icon("ability/ShadowlessBoxing")
         :description(
            {
                colour.hex(colour.lawngreen, "减伤：+" .. reduce .. '%'),
                colour.hex(colour.lawngreen, "反伤：100%")
            })
         :duration(dur)
         :purpose(
            function(buffObj)
                buffObj:attach("buff/InfernalBulwark", "origin")
                buffObj:hurtReduction("+=" .. reduce)
                buffObj:hurtRebound("+=" .. 100):odds("hurtRebound", "+=100")
            end)
         :rollback(
            function(buffObj)
                buffObj:detach("buff/InfernalBulwark", "origin")
                buffObj:hurtReduction("-=" .. reduce)
                buffObj:hurtRebound("-=" .. 100):odds("hurtRebound", "-=100")
            end)
         :run()
    end)