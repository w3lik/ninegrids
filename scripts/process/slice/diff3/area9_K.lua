local process = Process("slice_diff3_area9_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("Kobold1", TPL_UNIT.NPC_Token, 3834, -3598, 0, function(evtUnit)
        evtUnit:name("知性的狗头人")
        evtUnit:modelAlias("Kobold")
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 230,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "我的族人已经离开这片界域了，",
                        "但我认为凡事不能简单的分对错。",
                        "其他族里也有好人，要理性交往。",
                    },
                },
            }
        })
    end)
    Game():npc("Tauren", TPL_UNIT.Tauren, 4643, -3587, 180, function(evtUnit)
        evtUnit:name("友爱的牛头人")
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
                        "酋长死后，族人们就分崩离析了。",
                        "我不认为我们应该离开这里，这里是我族的故土，",
                        "虽然现在有别的族群，但大家应该有好相处。",
                    },
                },
            }
        })
    end)
    Game():npc("YJMan1", TPL_UNIT.NPC_Token, 5804, -4977, 35, function(evtUnit)
        evtUnit:name("沉迷的研究员")
        evtUnit:modelAlias("HumanMage")
        evtUnit:modelScale(1)
        evtUnit:scale(1.1)
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "这具铁处女保存得相当的完好。",
                        "这片不毛谷地肯定是经历过文明的，",
                        "但是遗迹到底是藏在哪里呢？难道在地下",
                    },
                },
            }
        })
    end)
    Game():npc("YJMan2", TPL_UNIT.NPC_Token, 4445, -5448, 190, function(evtUnit)
        evtUnit:name("挖掘的研究员")
        evtUnit:modelAlias("HumanMage")
        evtUnit:modelScale(1)
        evtUnit:scale(1.1)
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "这片区域特别多掩埋的龙骨，",
                        "我觉得这不是偶然的，还有这里的地形，",
                        "跟其他地方不一样，竟然是精细的白沙。",
                    },
                },
                {
                    tips = {
                        "我不知道这代表着什么，",
                        "我只知道我要将它掘开，才能发现",
                        "里面的秘密。",
                    },
                },
            }
        })
    end)
    Game():npc("YJMan3", TPL_UNIT.NPC_Token, 3947, -4288, 280, function(evtUnit)
        evtUnit:name("不想挖掘的研究员")
        evtUnit:modelAlias("HumanMage")
        evtUnit:modelScale(1)
        evtUnit:scale(1.1)
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "挖了几天了，他就不累吗？",
                        "早知道我就去研究谷边的刑拘用具，",
                        "跟着他挖地跟个傻子一样。",
                    },
                },
            }
        })
    end)
    Game():openDoor(gd.sliceIndex)
end)