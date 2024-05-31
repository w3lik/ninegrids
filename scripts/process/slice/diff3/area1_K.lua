local process = Process("slice_diff3_area1_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("KuMoMan", TPL_UNIT.NPC_Token, -4201, 4034, 220, function(evtUnit)
        evtUnit:name("落嚯的研究员")
        evtUnit:modelAlias("HumanMage")
        evtUnit:modelScale(1)
        evtUnit:scale(1.1)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "传闻这里有大宝藏，",
                        "但是现在已经没有人愿意过来探索了，",
                        "不知道宝藏还在不在呢。",
                    },
                },
            }
        })
    end)
    if (Game():achievement(14) ~= true) then
        local idx = 1
        Game():explain({
            { -5772, 3400, {
                {
                    tips = {
                        "一个蜘蛛雕像",
                        Game():balloonKeyboardTips("敲一敲")
                    },
                    call = function(callbackData)
                        local p = callbackData.triggerUnit:owner()
                        if (idx == 1) then
                            idx = 2
                            async.call(p, function()
                                UI_NinegridsInfo:info("info", 3, "其他蜘蛛雕像好像有动静")
                            end)
                        else
                            idx = 1
                            async.call(p, function()
                                UI_NinegridsInfo:info("info", 3, "好像敲错了")
                            end)
                        end
                    end
                }
            } },
            { -3050, 5300, {
                {
                    tips = {
                        "一个蜘蛛雕像",
                        Game():balloonKeyboardTips("敲一敲")
                    },
                    call = function(callbackData)
                        local p = callbackData.triggerUnit:owner()
                        if (idx == 4) then
                            Game():explainClear()
                            p:award({ gold = 100 })
                            Game():achievement(14, true)
                        elseif (idx == 2) then
                            idx = 3
                            async.call(p, function()
                                UI_NinegridsInfo:info("info", 3, "其他蜘蛛雕像好像有动静")
                            end)
                        else
                            idx = 1
                            async.call(p, function()
                                UI_NinegridsInfo:info("info", 3, "好像敲错了")
                            end)
                        end
                    end
                }
            } },
            { -5825, 5657, {
                {
                    tips = {
                        "一个蜘蛛雕像",
                        Game():balloonKeyboardTips("敲一敲")
                    },
                    call = function(callbackData)
                        local p = callbackData.triggerUnit:owner()
                        if (idx == 3) then
                            idx = 4
                            async.call(p, function()
                                UI_NinegridsInfo:info("info", 3, "其他蜘蛛雕像好像有动静")
                            end)
                        else
                            idx = 1
                            async.call(p, function()
                                UI_NinegridsInfo:info("info", 3, "好像敲错了")
                            end)
                        end
                    end
                }
            } },
        })
    end
    Game():openDoor(gd.sliceIndex)
end)