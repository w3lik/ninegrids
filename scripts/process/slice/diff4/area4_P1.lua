local process = Process("slice_diff4_area4_P1")
process:onStart(function(this)
    this:next("interrupt")
    Game():npc("UjimasaHojoV1", TPL_UNIT.NPC_Token, -4421, -453, 270, function(evtUnit)
        evtUnit:name("鬼火")
        evtUnit:icon("unit/HellstoneGolem")
        evtUnit:modelAlias("HeroFlameLord")
        evtUnit:modelScale(1.3)
        evtUnit:scale(1.4)
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/what", "tga"), 0.024, 0.024)
        evtUnit:balloon({
            z = 280,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "呲~呲~呲~",
                        Game():balloonKeyboardTips("打它")
                    },
                    call = function(callbackData)
                        effector("DoomDeath", callbackData.balloonObj:x(), callbackData.balloonObj:y(), nil, 1)
                        destroy(callbackData.balloonObj)
                        async.call(callbackData.triggerUnit:owner(), function()
                            UI_NinegridsInfo:info("alert", 3, "你有3秒的准备时间")
                        end)
                        Game():xTimer(false, 3, function()
                            Game():bossBorn()
                        end)
                    end
                },
            }
        })
    end)
    Game():npc("VillagerMan1-2", TPL_UNIT.NPC_Token, -5075, 334, -50, function(evtUnit)
        evtUnit:name("惶恐的男村民")
        evtUnit:modelAlias("VillagerMan1")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "不知道从哪里来的火魔，", "太可怕了！！！" } } }
        })
    end)
    Game():npc("VillagerMan2-1", TPL_UNIT.NPC_Token, -3499, -590, 180, function(evtUnit)
        evtUnit:name("畏惧的男村民")
        evtUnit:modelAlias("VillagerMan2")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                { tips = { "帮帮我们村子吧！", "妖魔鬼怪太可怕了。" } },
            }
        })
    end)
    Game():npc("VillagerWoman", TPL_UNIT.NPC_Token, -5906, -773, 270, function(evtUnit)
        evtUnit:name("失泠的女村民")
        evtUnit:modelAlias("VillagerWoman1")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                { tips = { "噢~我的上帝", "这该怎么办？" } },
            }
        })
    end)
end)