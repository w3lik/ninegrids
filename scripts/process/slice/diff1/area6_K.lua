local process = Process("slice_diff1_area6_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("NagaRoyalGuard", TPL_UNIT.SeaRoyalGuard, 5887, -200, 180, function(evtUnit)
        evtUnit:name("海族皇家卫兵")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/what", "tga"), 0.024, 0.024)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "感谢你的帮忙路过的勇士，",
                        "这群海妖谋害族王，谋朝篡位，",
                        "这一战把谋逆者都祛除了，感谢你",
                        Game():balloonKeyboardTips("拿赠礼")
                    },
                    call = function(callbackData)
                        callbackData.balloonObj:balloon(false)
                        autoItemCreate("海族赠礼", callbackData.triggerUnit:x(), callbackData.triggerUnit:y(), 60)
                        async.call(callbackData.triggerUnit:owner(), function()
                            UI_NinegridsInfo:info("info", 3, "获得了海族赠礼")
                        end)
                    end
                },
            }
        })
    end)
    Game():npc("Murloc1", TPL_UNIT.MurlocYellow, 4465, 346, 180, function(evtUnit)
        evtUnit:name("巡逻的小鱼人")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        AI("loiter"):link(evtUnit)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "警惕！警惕！",
                        "不容有失！！",
                    },
                },
            }
        })
    end)
    Game():npc("Murloc2", TPL_UNIT.MurlocOrange, 4638, -1086, 90, function(evtUnit)
        evtUnit:name("巡逻的小鱼人")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        AI("loiter"):link(evtUnit)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "绝不能再让无耻至辈，",
                        "占领海蛇族的海域",
                    },
                },
            }
        })
    end)
    Game():npc("Murloc3", TPL_UNIT.MurlocCyan, 3620, 1414, 180, function(evtUnit)
        evtUnit:name("巡逻的小鱼人")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        AI("loiter"):link(evtUnit)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "是什么人？谋逆者吗！",
                        "原来是好的勇士大人。",
                    },
                },
            }
        })
    end)
    Game():npc("Murloc4", TPL_UNIT.MurlocGreen, 5591, -596, 160, function(evtUnit)
        evtUnit:name("坚守的小鱼人")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "我是正义的小鱼人，",
                        "永久捍卫海蛇族为王，",
                        "跟海妖叛逆至徒不一样！",
                    },
                    tips = {
                        "只是想不到还有同族的小鱼人，",
                        "背着族人谋逆，不可饶恕！",
                    },
                },
            }
        })
    end)
    Game():npc("Turtle1", TPL_UNIT.Turtle, 5588, 1688, 200)
    Game():npc("Turtle2", TPL_UNIT.Turtle, 5840, 1455, 180)
    Game():openDoor(gd.sliceIndex)
end)