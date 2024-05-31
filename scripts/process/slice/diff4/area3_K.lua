local process = Process("slice_diff4_area3_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("KuMoMan", TPL_UNIT.NPC_Token, 4469, 4226, 220, function(evtUnit)
        evtUnit:name("认真的研究员")
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
                        "其他人都已经放弃了，",
                        "我永不放弃！终于有了结果！",
                        "我发现遗迹奇怪的符号是" .. colour.hex(colour.yellow, "分两种") .. "的。",
                    },
                },
                {
                    tips = {
                        "我将它们分为" .. colour.hex(colour.yellow, "咒文与符文") .. "两种。",
                        "触动全部咒文用来召唤深渊的魔物，",
                        "而符文就不知道有什么用了，",
                        "应该要找出规律触摸才能生效。",
                    },
                },
            }
        })
    end)
    if (Game():achievement(15) ~= true) then
        local idx = 1
        Game():explain({
            { 5588, 4719, {
                {
                    tips = {
                        "奇怪的符文",
                        Game():balloonKeyboardTips("触摸一下")
                    },
                    call = function(callbackData)
                        local p = callbackData.triggerUnit:owner()
                        if (idx == 1) then
                            idx = 2
                            async.call(p, function()
                                UI_NinegridsInfo:info("info", 3, "其他符文好像产生了共鸣")
                            end)
                        else
                            idx = 1
                            async.call(p, function()
                                UI_NinegridsInfo:info("info", 3, "好像不对")
                            end)
                        end
                    end
                }
            } },
            { 2638, 3196, {
                {
                    tips = {
                        "奇怪的符文",
                        Game():balloonKeyboardTips("触摸一下")
                    },
                    call = function(callbackData)
                        local p = callbackData.triggerUnit:owner()
                        if (idx == 2) then
                            idx = 3
                            async.call(p, function()
                                UI_NinegridsInfo:info("info", 3, "其他符文好像产生了共鸣")
                            end)
                        else
                            idx = 1
                            async.call(p, function()
                                UI_NinegridsInfo:info("info", 3, "好像不对")
                            end)
                        end
                    end
                }
            } },
            { 3403, 4542, {
                {
                    tips = {
                        "奇怪的符文",
                        Game():balloonKeyboardTips("触摸一下")
                    },
                    call = function(callbackData)
                        local p = callbackData.triggerUnit:owner()
                        if (idx == 3) then
                            idx = 4
                            async.call(p, function()
                                UI_NinegridsInfo:info("info", 3, "其他符文好像产生了共鸣")
                            end)
                        else
                            idx = 1
                            async.call(p, function()
                                UI_NinegridsInfo:info("info", 3, "好像不对")
                            end)
                        end
                    end
                }
            } },
            { 4536, 4951, {
                {
                    tips = {
                        "奇怪的符文",
                        Game():balloonKeyboardTips("触摸一下")
                    },
                    call = function(callbackData)
                        local p = callbackData.triggerUnit:owner()
                        if (idx == 4) then
                            idx = 5
                            async.call(p, function()
                                UI_NinegridsInfo:info("info", 3, "其他符文好像产生了共鸣")
                            end)
                        else
                            idx = 1
                            async.call(p, function()
                                UI_NinegridsInfo:info("info", 3, "好像不对")
                            end)
                        end
                    end
                }
            } },
            { 2650, 5807, {
                {
                    tips = {
                        "奇怪的符文",
                        Game():balloonKeyboardTips("触摸一下")
                    },
                    call = function(callbackData)
                        local p = callbackData.triggerUnit:owner()
                        if (idx == 5) then
                            Game():explainClear()
                            p:award({ gold = 300 })
                            Game():achievement(15, true)
                        else
                            idx = 1
                            async.call(p, function()
                                UI_NinegridsInfo:info("info", 3, "好像不对")
                            end)
                        end
                    end
                }
            } },
        })
    end
    Game():openDoor(gd.sliceIndex)
end)