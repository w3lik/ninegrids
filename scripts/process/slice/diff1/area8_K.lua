local process = Process("slice_diff1_area8_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("HeroBladeMaster", TPL_UNIT.NPC_Token, 316, -3116, 180, function(evtUnit)
        evtUnit:name("疾风")
        evtUnit:modelAlias("HeroBladeMaster")
        evtUnit:modelScale(1.3)
        evtUnit:scale(1.3)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 280,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "你的招式十分灵动，",
                        "而我的剑技还有欠缺至处，",
                        "在下甘拜下风。",
                    },
                },
            }
        })
    end)
    Game():npc("HumanMage", TPL_UNIT.NPC_Token, -1323, -4335, 200, function(evtUnit)
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
                        "这些神秘的符号肯定有什么奥妙！",
                        "虽然现在还一点反应没有，",
                        "但只要经过我的努力，",
                        "肯定能够将它的谜团解出来的。",
                    },
                },
                {
                    tips = {
                        "你问我为什么别人都在雪地？",
                        "他们那是魔怔了，为了寻找蜘蛛雕像的宝藏，",
                        "我是个一心求学的人，跟他们不一样，",
                        "我来寻找这南边的宝藏，",
                        "嘿嘿~都是我一个人的。",
                    },
                },
            }
        })
    end)
    Game():npc("DarkRanger", TPL_UNIT.NPC_Token, -355, -5217, 110, function(evtUnit)
        evtUnit:name("奇怪的游侠")
        evtUnit:modelAlias("hero/TheBansheeQueen")
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "嗯？走开！",
                    },
                },
            }
        })
    end)
    Game():npc("Kobold", TPL_UNIT.NPC_Token, 1056, -4371, 0, function(evtUnit)
        evtUnit:name("喝水的狗头人")
        evtUnit:modelAlias("Kobold")
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "唉，我的家乡被一个凶狠的家伙侵占了。",
                        "我天生胆小，不敢与至一战，但我的族人不会。",
                        "他们还在谷地与他交战呢，也不知道怎样了。",
                        "反正我是不会再回去了，就在这里生活好了。",
                    },
                },
                {
                    tips = {
                        "这里环境还是很好的，山清水秀。",
                        "我前几天还发现了把神奇的斧....",
                        "哦~没什么，破烂一个而已，",
                        "就不跟你多说了...",
                    },
                },
            }
        })
    end)
    Game():dig()
    Game():openDoor(gd.sliceIndex)
end)