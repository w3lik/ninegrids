local process = Process("slice_diff1_area4_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("MaikoMan1", TPL_UNIT.NPC_Token, -5481, 1402, 100, function(evtUnit)
        evtUnit:name("迷路的研究员")
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
                        "终于等到那群可怕的蜘蛛消失，",
                        "拉了个肚子结果外面一堆蜘蛛，",
                        "不知道哪里来的那么多蜘蛛，",
                        "吓死宝宝了~~~~~",
                    },
                },
                {
                    tips = {
                        "等了这么久先行队伍早就不见啦，",
                        "不知道是不是进到前面山洞里了。",
                        "我好怕啊~ 再等等其他人吧。",
                    },
                },
            }
        })
    end)
    local i = 0
    Game():npc("HanKuMo", TPL_UNIT.NPC_Token, -2754, 316, 180, function(evtUnit)
        evtUnit:name("漏网至鱼？")
        evtUnit:modelAlias("Nerubian")
        evtUnit:modelScale(1)
        evtUnit:scale(1.3)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/what", "tga"), 0.024, 0.024)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "诶诶诶~别打我，我跟它们不是一路的，",
                        "它们都是邪恶的蜘蛛，霸占这里好久了，",
                        "我是善良的蜘蛛，不信？我给你好处。",
                        Game():balloonKeyboardTips("拿好处")
                    },
                    call = function(callbackData)
                        i = i + 1
                        if (i > 3) then
                            destroy(callbackData.balloonObj)
                            async.call(callbackData.triggerUnit:owner(), function()
                                UI_NinegridsInfo:info("info", 3, "还来？厚颜无耻！")
                            end)
                            return
                        end
                        autoItemCreate("古怪蜘蛛卵", callbackData.triggerUnit:x(), callbackData.triggerUnit:y(), 60)
                        async.call(callbackData.triggerUnit:owner(), function()
                            UI_NinegridsInfo:info("info", 3, "古怪的蜘蛛奉上了一个蜘蛛卵")
                        end)
                    end
                },
            }
        })
    end)
    Game():npc("Wolf1", TPL_UNIT.NPC_Token, -5520, 781, 270, function(evtUnit)
        evtUnit:name("黑狼")
        evtUnit:modelAlias("BrownWolf")
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        AI("loiter"):link(evtUnit)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "嚎~",
                    },
                },
            }
        })
    end)
    Game():npc("Wolf2", TPL_UNIT.NPC_Token, -2941, -1696, 75, function(evtUnit)
        evtUnit:name("黑狼")
        evtUnit:modelAlias("BrownWolf")
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        AI("loiter"):link(evtUnit)
    end)
    Game():npc("Wolf3", TPL_UNIT.NPC_Token, -5096, -1266, 180, function(evtUnit)
        evtUnit:name("大黑狼")
        evtUnit:modelAlias("BrownWolf")
        evtUnit:modelScale(1.4)
        evtUnit:scale(1.4)
        AI("loiter"):link(evtUnit)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "嗷呜~~嗷呜呜~~",
                    },
                },
            }
        })
    end)
    Game():npc("FirePitPig", TPL_UNIT.NPC_Token, -4535, -664, 270, function(evtUnit)
        evtUnit:name("香喷喷的烤猪")
        evtUnit:modelAlias("Doodads\\Northrend\\Props\\FirePitPig\\FirePitPig.mdl")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1.2)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "香喷喷的烤猪", "旁白还有一把巨剑", "好像有剑士在这里居住一样" } } }
        })
    end)
    Game():npc("Dryad", TPL_UNIT.NPC_Token, -4050, -1381, 300, function(evtUnit)
        evtUnit:name("逃过一劫的树妖")
        evtUnit:modelAlias("Dryad")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1.2)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = function()
                        local sliceResult7 = Game():GD().sliceResult[7]
                        if (sliceResult7 == true) then
                            return { "森林恢复常态了", "不过还有灾情，再过些时候", "我再回去森林里~" }
                        else
                            return { "森林长老疯狂了，我逃出来了", "还有很多族人被催眠了", "变得邪恶又可怕!" }
                        end
                    end
                }
            }
        })
    end)
    Game():dig()
    Game():openDoor(gd.sliceIndex)
end)