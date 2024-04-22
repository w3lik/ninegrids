TPL_ABILITY_FREAK = {
    AbilityTpl()
        :name("地狱洗礼")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/WarlockImprovedSoulLeech")
        :description(
        {
            "在地狱至火中洗礼",
            "施加伤害增强的同时",
            "也承受同样的伤害痛苦",
        })
        :attributes(
        {
            { "hurtIncrease", 125, 0 },
            { "damageIncrease", 75, 0 },
        })
        :onEvent(EVENT.Ability.Lose, function(loseData) loseData.triggerUnit:detach("buff/NetherInferno", "foot") end)
        :onEvent(EVENT.Ability.Get, function(getData) getData.triggerUnit:attach("buff/NetherInferno", "foot") end),
    AbilityTpl()
        :name("破灭视煞")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/ShadowCurseOfAchimonde")
        :description(
        {
            "失去部分视野能力，回避也被降低",
            "换取高速的攻击速度和破灭木飙的精准度",
        })
        :attributes(
        {
            { "sight", -250, 0 },
            { "avoid", -66, 0 },
            { "attackSpace", -0.2, 0 },
            { "attackSpeed", 75, 0 },
            { "aim", 60, 0 },
        })
        :onEvent(EVENT.Ability.Lose, function(loseData) loseData.triggerUnit:detach("buff/ProvidenceAuraBlue", "origin") end)
        :onEvent(EVENT.Ability.Get, function(getData) getData.triggerUnit:attach("buff/ProvidenceAuraBlue", "origin") end),
    AbilityTpl()
        :name("负罪反击")
        :coolDownAdv(20, 0)
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/EcouragingRed")
        :description(
        {
            "使用后在 " .. colour.hex(colour.skyblue, "6秒") .. " 内",
            "移动速度会" .. colour.hex(colour.indianred, "急剧持续降低"),
            "同时开始分析伤害并进行反击",
            "",
            colour.hex(colour.indianred, "移动：每0.25秒 -20"),
            colour.hex(colour.lawngreen, "反击伤害：+25%"),
            colour.hex(colour.lawngreen, "反击几率：+40%"),
        })
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local dur = 6
            local ti = 0
            time.setInterval(0.25, function(curTimer)
                ti = ti + 1
                if (ti >= 16) then
                    destroy(curTimer)
                    u:move("+=300")
                    return
                else
                    u:move("-=20")
                end
            end)
            local de = {
                hurtRebound = 25,
                hurtReboundOdds = 40,
            }
            local eff = u:attach("buff/BloodRitual", "origin", -1)
            u:buff("负罪反击")
             :signal(BUFF_SIGNAL.up)
             :icon("ability/EcouragingRed")
             :description({
                "罪恶的反击",
                colour.hex(colour.green, "反击伤害：+" .. de.hurtRebound .. "%"),
                colour.hex(colour.green, "反击几率：+" .. de.hurtReboundOdds .. "%") })
             :duration(dur)
             :purpose(
                function(buffObj)
                    buffObj:hurtRebound("+=" .. de.hurtRebound)
                    buffObj:odds("hurtRebound", "+=" .. de.hurtReboundOdds)
                end)
             :rollback(
                function(buffObj)
                    destroy(eff)
                    buffObj:hurtRebound("-=" .. de.hurtRebound)
                    buffObj:odds("hurtRebound", "-=" .. de.hurtReboundOdds)
                end)
             :run()
        end),
    AbilityTpl()
        :name("鬼影无踪")
        :coolDownAdv(13, 0)
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/EvilSpirit")
        :description(
        {
            "攻击降低，且在移动过程中",
            "可得到进入隐身状态3秒的效果",
            "隐身后移动速度会大大增加",
            "但隐身期间防御、减伤会极大降低",
            "",
            colour.hex(colour.lawngreen, "移动：+175"),
            colour.hex(colour.indianred, "防御：-50"),
            colour.hex(colour.indianred, "减伤：-25%"),
        })
        :attributes({ { SYMBOL_MUT .. "attack", -10, 0 } })
        :onUnitEvent(EVENT.Unit.Moving, function(evtData) evtData.triggerAbility:effective() end)
        :onEvent(EVENT.Ability.Lose, function(loseData) loseData.triggerUnit:detach("buff/ShadowAssault", "origin") end)
        :onEvent(EVENT.Ability.Get, function(getData) getData.triggerUnit:attach("buff/ShadowAssault", "origin") end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            u:move("+=175;3")
            u:defend("-=50;3")
            u:hurtReduction("-=25;3")
            ability.invisible({
                whichUnit = u,
                duration = 3,
                name = "鬼影无踪",
                icon = "ability/EvilSpirit",
                effect = "InvisibilityTarget",
                description = {
                    colour.hex(colour.indianred, "防御：-50"),
                    colour.hex(colour.indianred, "减伤：-25%"),
                }
            })
        end),
    AbilityTpl()
        :name("邪神至握")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/Apostle2")
        :attributes(
        {
            { "attack", 225, 0 },
            { "move", 225, 0 },
            { SYMBOL_E .. DAMAGE_TYPE.dark.value, 100, 0 },
            { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.dark.value, 50, 0 },
        })
        :description(
        {
            "大大增强攻击、移动和暗属性伤害、抗性",
            "但当受到伤害时，部分属性会叠加下降",
            "",
            colour.hex(colour.violet, "下降效果将会持续：6.66秒"),
            colour.hex(colour.indianred, "每层移动：-10"),
            colour.hex(colour.indianred, "每层生命恢复：-2"),
            colour.hex(colour.indianred, "每层防御：-5"),
        })
        :onEvent(EVENT.Ability.Lose, function(loseData) loseData.triggerUnit:detach("buff/Omen", "overhead") end)
        :onEvent(EVENT.Ability.Get, function(getData) getData.triggerUnit:attach("buff/Omen", "overhead") end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            local u = hurtData.triggerUnit
            local n = 1
            local b = u:buffOne("邪神至握")
            if (b) then
                n = b:prop("layer") or 1
                n = n + 1
                u:buffClear({ key = "邪神至握" })
            end
            local dur = 6.66
            local move = 10 * n
            local hpRegen = 2 * n
            local defend = 5 * n
            u:buff("邪神至握")
             :signal(BUFF_SIGNAL.down)
             :icon("ability/Apostle2")
             :text(colour.hex(colour.red, n))
             :prop("layer", n)
             :description({
                colour.hex(colour.red, n .. "层") .. "邪神的诅咒",
                colour.hex(colour.indianred, "HP恢复：-" .. hpRegen),
                colour.hex(colour.indianred, "移动：-" .. move),
                colour.hex(colour.indianred, "防御：-" .. defend) })
             :duration(dur)
             :purpose(
                function(buffObj)
                    buffObj:move("-=" .. move)
                    buffObj:hpRegen("-=" .. hpRegen)
                    buffObj:defend("-=" .. defend)
                    buffObj:attach("buff/Stranglehold", "origin")
                end)
             :rollback(
                function(buffObj)
                    buffObj:move("+=" .. move)
                    buffObj:hpRegen("+=" .. hpRegen)
                    buffObj:defend("+=" .. defend)
                    buffObj:detach("buff/Stranglehold", "origin")
                end)
             :run()
        end),
    AbilityTpl()
        :name("假死仪式")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/RebirthShadow2")
        :description(
        function(this)
            local re = -1
            local bu = this:prop("bindUnit")
            if (isClass(bu, UnitClass)) then
                re = bu:reborn()
            end
            if (re >= 0) then
                return {
                    colour.hex(colour.indianred, "得到资源时需要上交给仪式"),
                    colour.hex(colour.indianred, "减少75%的资源获得率"), "",
                    colour.hex(colour.violet, "在生死关头有恃无恐1次"),
                    colour.hex(colour.violet, "强行进入假死状态"), "",
                    colour.hex(colour.lawngreen, re .. "秒会再次复活"),
                }
            else
                return {
                    colour.hex(colour.indianred, "得到资源时需要上交给仪式"),
                    colour.hex(colour.indianred, "减少75%的资源获得率"), "",
                    colour.hex(colour.violet, "仪式已失效，但依然需要上交资源"), "",
                    colour.hex(colour.indianred, "在生死关头，也还是会死亡"),
                }
            end
        end)
        :onEvent(EVENT.Ability.Get,
        function(getData)
            local u = getData.triggerUnit
            if (Game():GD().meDied == 0) then
                u:attach("buff/SereneLightLack", "origin")
                u:reborn(5)
            else
                getData.triggerAbility:ban("失效")
            end
            u:owner():worthRatio("-=75")
        end)
        :onEvent(EVENT.Ability.Lose,
        function(loseData)
            local u = loseData.triggerUnit
            u:owner():worthRatio("+=75")
            u:reborn(-999)
            u:detach("buff/SereneLightLack", "origin")
        end)
        :onUnitEvent(EVENT.Unit.FeignDead,
        function(feignDeadData)
            local u = feignDeadData.triggerUnit
            u:detach("buff/SereneLightLack", "origin")
            u:reborn(-999)
            feignDeadData.triggerAbility:ban("失效")
            Game():GD().meDied = 1
            Game():save("meDied", Game():GD().meDied)
        end),
}
local s = Store("abilityFreak")
s:name("奇异魔技")
s:description("奇异魔技")
local c = s:salesGoods():count()
for i = 1, #TPL_ABILITY_FREAK, 1 do
    local v = TPL_ABILITY_FREAK[i]
    v:prop("idx", i)
    if (i > c) then
        s:insert(v)
    end
end