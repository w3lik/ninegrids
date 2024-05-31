local process = Process("slice_diff1_area1_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("Pedlar", TPL_UNIT.NPC_Token, -4629, 4766, 0, function(evtUnit)
        evtUnit:name("古怪的行商")
        evtUnit:modelAlias("Acolyte")
        evtUnit:icon("unit/Acolyte")
        evtUnit:modelScale(1)
        evtUnit:scale(1.0)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/what", "tga"), 0.024, 0.024)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "呼~好冷啊，我是天穹降临的使者",
                        "你有" .. colour.hex(colour.gold, "【雪蓝核心】") .. "可以送我吗？",
                        "只需要 " .. colour.hex(colour.gold, 5) .. " 个核心而已",
                        "我可以给你 1 个" .. colour.hex(colour.gold, "【天穹至礼】"),
                        Game():balloonKeyboardTips("赠送")
                    },
                    call = function(callbackData)
                        local p1 = callbackData.triggerUnit:owner()
                        local tpl = TPL_ITEM.Mission_SnowCore
                        local w = p1:warehouseSlot()
                        if (w:quantity(tpl) < 5) then
                            async.call(p1, function()
                                UI_NinegridsInfo:info("error", 3, "数量不够呢")
                            end)
                            return
                        else
                            autoItemCreate("天穹至礼", callbackData.triggerUnit:x(), callbackData.triggerUnit:y(), 60)
                            destroy(callbackData.balloonObj)
                            async.call(callbackData.triggerUnit:owner(), function()
                                audio(Vcm("war3_SellItem"))
                                UI_NinegridsInfo:info("info", 3, "祝福你")
                            end)
                        end
                        w:removeTpl(tpl, 5)
                    end
                }
            }
        })
    end)
    Game():npc("Adventurer_KnightFarstrider", TPL_UNIT.NPC_Token, -3378, 3630, 110, function(evtUnit)
        evtUnit:name("冒险者骑首部")
        evtUnit:modelAlias("unit/HawkstriderKnightFarstrider")
        evtUnit:icon("unit/TheCaptain")
        evtUnit:modelScale(1)
        evtUnit:scale(1.3)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "怎么会有人来这冰天雪地",
                        "你一点吃的都没有熬不下去的",
                        "带着【加工冷冻肉】就是我们的底气",
                        "每个只卖" .. colour.hex(colour.gold, "1金币") .. "哦~",
                        Game():balloonKeyboardTips("交易")
                    },
                    call = function(callbackData)
                        local p1 = callbackData.triggerUnit:owner()
                        local price = { gold = 1 }
                        if (Game():worthLess(p1:worth(), price)) then
                            async.call(p1, function()
                                UI_NinegridsInfo:info("error", 3, "金币不够呢")
                            end)
                            return
                        else
                            p1:worth("-", price)
                            autoItemCreate("加工冷冻肉", callbackData.triggerUnit:x(), callbackData.triggerUnit:y(), 60)
                            async.call(callbackData.triggerUnit:owner(), function()
                                audio(Vcm("war3_SellItem"))
                                UI_NinegridsInfo:info("info", 3, "成交")
                            end)
                        end
                    end
                },
            }
        })
    end)
    Game():npc("KuMoMan1", TPL_UNIT.NPC_Token, -5569, 5435, 135, function(evtUnit)
        evtUnit:name("拼搏的研究员")
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
                        "野兽们终于散去了，我是来自",
                        "东边的研究人员，一直对这雪山",
                        "上面的蜘蛛雕像很感兴趣。",
                    },
                },
                {
                    tips = {
                        "传说中这蜘蛛雕像隐藏着秘密",
                        "我总有一天会研究出来的",
                    },
                },
            }
        })
    end)
    Game():npc("KuMoMan2", TPL_UNIT.NPC_Token, -2944, 4988, 180, function(evtUnit)
        evtUnit:name("怨气冲天的研究员")
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
                        "搞不懂这破雕像有什么好研究的，",
                        "呼~冰天雪地的，我只想回去被窝里",
                    },
                },
            }
        })
    end)
    Game():npc("KuMoMan3", TPL_UNIT.NPC_Token, -3321, 5212, 30, function(evtUnit)
        evtUnit:name("做梦的研究员")
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
                        "只要我研究出这座雕像的秘密，",
                        "我就可以成为研究所里面，",
                        "最 靓 的 仔！",
                    },
                },
            }
        })
    end)
    Game():npc("KuMoMan4", TPL_UNIT.NPC_Token, -5486, 3384, 210, function(evtUnit)
        evtUnit:name("正常的研究员")
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
                        "这具蜘蛛雕像非常的精致，",
                        "看起来栩栩如生，值得研究",
                    },
                },
            }
        })
    end)
    Game():npc("BlackStagMale", TPL_UNIT.NPC_Token, -5384, 4540, 45, function(evtUnit)
        evtUnit:name("麋鹿")
        evtUnit:modelAlias("BlackStagMale")
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        AI("loiter"):link(evtUnit)
    end)
    Game():npc("Penguin1", TPL_UNIT.NPC_Token, -5743, 2968, 0, function(evtUnit)
        evtUnit:name("企鹅")
        evtUnit:modelAlias("Penguin")
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        AI("loiter"):link(evtUnit)
    end)
    Game():npc("Penguin2", TPL_UNIT.NPC_Token, -5478, 2921, 0, function(evtUnit)
        evtUnit:name("肥企鹅")
        evtUnit:modelAlias("Penguin")
        evtUnit:modelScale(1.2)
        evtUnit:scale(1.2)
        AI("loiter"):link(evtUnit)
    end)
    Game():explain({
        { -5772, 3400, { { tips = { "一个蜘蛛雕像" } } } },
        { -5825, 5657, { { tips = { "一个蜘蛛雕像" } } } },
        { -3050, 5300, { { tips = { "一个蜘蛛雕像" } } } },
    })
    Game():openDoor(gd.sliceIndex)
end)