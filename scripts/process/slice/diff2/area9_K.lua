local process = Process("slice_diff2_area9_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("Kobold1", TPL_UNIT.NPC_Token, 4509, -2804, 270, function(evtUnit)
        evtUnit:name("幸灾乐祸的狗头人")
        evtUnit:modelAlias("Kobold")
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "嘿，我们被赶走后~",
                        "这牛头人就侵占我们的土地！",
                        "这下它们也不好过了",
                        Game():balloonKeyboardTips("反驳他")
                    },
                    call = function(callbackData)
                        local u = callbackData.triggerUnit
                        async.call(u:owner(), function()
                            UI_NinegridsInfo:info("info", 3, "狗头人欣喜致狂，已经听不进你的反驳了")
                        end)
                    end
                },
            }
        })
    end)
    Game():npc("Tauren", TPL_UNIT.Tauren, 5681, -5850, 120, function(evtUnit)
        evtUnit:name("幸存的牛头人")
        evtUnit:modelAlias("Tauren")
        evtUnit:modelScale(1)
        evtUnit:scale(1.2)
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "啊啊啊啊啊~",
                        "我走!我走啦！",
                        "别揍我...",
                    },
                },
            }
        })
    end)
    Game():dig()
    Game():openDoor(gd.sliceIndex)
end)