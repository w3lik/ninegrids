local process = Process("slice_island_B")
process:onStart(function(this)
    local gd = Game():GD()
    local diff = math.round(gd.diff)
    if (diff == 5) then
        async.call(gd.me:owner(), function()
            UI_NinegridsInfo:bossMe()
        end)
    else
        async.call(gd.me:owner(), function()
            UI_NinegridsInfo:boss()
        end)
    end
    local effs = {}
    for i = 1, 6 do
        local x, y = vector2.polar(0, 0, 400, 120 - 60 * i)
        effs[i] = Game():effects("env/PaperLanternS1", x, y, 30, 270)
    end
    Game():npc("MovingPortal", TPL_UNIT.NPC_Token, 0, 700, 270, function(evtUnit)
        evtUnit:modelAlias("env/MovingPortal")
        evtUnit:modelScale(1.2)
        evtUnit:animateScale(0)
        evtUnit:superposition("pause", "+=1")
        evtUnit:superposition("locust", "+=1")
    end)
    local key = "BOSS_" .. diff
    local tpl = TPL_UNIT[key]
    Game():npc(key, tpl, 0, 0, 270, function(evtUnit)
        evtUnit:animateScale(4)
        evtUnit:animate("attack")
        evtUnit:rgba(100, 100, 100, 255)
        evtUnit:superposition("invulnerable", "+=1")
        time.setTimeout(0.2, function()
            evtUnit:superposition("pause", "+=1")
            evtUnit:animateScale(0)
        end)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/what", "tga"), 0.027, 0.027)
        local lv = 5 + diff
        evtUnit:abilitySlot():tail(6)
        if (diff <= 4) then
            evtUnit:level(diff * 25 + gd.erode)
            local ab = Ability(TPL_ABILITY_SOUL[(40 + diff)])
            ab:level(lv)
            evtUnit:abilitySlot():insert(ab)
            evtUnit:abilitySlot():insert(TPL_ABILITY_BOSS["界泠深渊"], 6)
        else
            evtUnit:level(500 + 25 * gd.lastDead)
            Game():erode(235 - gd.erode)
            evtUnit:abilitySlot():insert(TPL_ABILITY_BOSS["无我无妄"], 6)
        end
        local abTPLs = TPL_ABILITY_BOSS[evtUnit:name()]
        if (type(abTPLs) == "table") then
            for _, v in ipairs(abTPLs) do
                if (isClass(v, AbilityTplClass)) then
                    local ab = Ability(v)
                    if (isClass(ab, AbilityClass)) then
                        evtUnit:abilitySlot():insert(ab)
                    end
                end
            end
        end
        if (diff <= 4) then
            for _, v in ipairs(BOSS_BIG_ITEMS[diff]) do
                local it
                if (isClass(v, ItemTplClass)) then
                    it = Item(v)
                end
                if (isClass(it, ItemClass)) then
                    it:level(lv - 2):attributes(it:prop("forgeList")[lv - 2])
                    evtUnit:itemSlot():insert(it)
                end
            end
        end
        evtUnit:balloon({
            z = 260,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "被封印的" .. colour.hex(colour.red, "【探秘区核元】") .. colour.hex(colour.violet, evtUnit:name()),
                        Game():balloonKeyboardTips("唤醒战斗")
                    },
                    call = function(callbackData)
                        destroy(callbackData.balloonObj)
                        local explore
                        if (diff == 1) then
                            explore = "eff/FlamestrikeMysticI"
                        elseif (diff == 2) then
                            explore = "eff/FlamestrikeFelI"
                        elseif (diff == 3) then
                            explore = "eff/FlamestrikeDarkVoidI"
                        elseif (diff == 4) then
                            explore = "eff/FlamestrikeBloodI"
                        elseif (diff == 5) then
                            explore = "eff/FlamestrikeII"
                        end
                        local pls = Game():npc("MovingPortal")
                        effector(explore, pls:x(), pls:y(), nil, 1)
                        effector(explore, 0, 0, nil, 1)
                        destroy(pls)
                        Game():bossBgmBattle(90)
                        local i = 1
                        time.setInterval(0.4, function(curTimer)
                            local e = effs[i]
                            effector(explore, e:x(), e:y(), nil, 1)
                            destroy(e)
                            effs[i] = nil
                            i = i + 1
                            if (i >= 7) then
                                destroy(curTimer)
                                time.setTimeout(0.5, function()
                                    Game():npcClear()
                                    Game():effectsClear()
                                    local modelAlias
                                    if (diff == 1) then
                                        modelAlias = "missile/PsionicShotTeal"
                                    elseif (diff == 2) then
                                        modelAlias = "missile/PsionicShotGreen"
                                    elseif (diff == 3) then
                                        modelAlias = "missile/PsionicShotPurple"
                                    elseif (diff == 4) then
                                        modelAlias = "missile/PsionicShotRed"
                                    elseif (diff == 5) then
                                        modelAlias = "missile/PsionicShotYellow"
                                    end
                                    local k = 9
                                    for j = 1, k do
                                        local angle = j * 40
                                        local sx, sy = vector2.polar(0, 0, 500, angle)
                                        ability.missile({
                                            modelAlias = modelAlias,
                                            sourceVec = { sx, sy, 100 },
                                            targetVec = { 0, 0, 300 },
                                            speed = 500,
                                            onEnd = function(_, vec)
                                                if (j == 9) then
                                                    effector("eff/Ultimateaura", vec[1], vec[2], nil, 7)
                                                    time.setTimeout(5, function()
                                                        audio(Vcm("bossCrazy"))
                                                        this:next("slice_island_B" .. diff)
                                                    end)
                                                end
                                            end
                                        })
                                    end
                                end)
                            end
                        end)
                    end
                }
            }
        })
    end)
end)