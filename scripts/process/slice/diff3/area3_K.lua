local process = Process("slice_diff3_area3_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("KuMoMan1", TPL_UNIT.NPC_Token, 3382, 4548, 45, function(evtUnit)
        evtUnit:name("疑惑的研究员")
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
                        "这边的符文是三个一组的，",
                        "到底意味着什么呢？",
                    },
                },
            }
        })
    end)
    Game():npc("KuMoMan2", TPL_UNIT.NPC_Token, 4911, 3516, 260, function(evtUnit)
        evtUnit:name("专注的研究员")
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
                        "这就是和符文不同的咒文，",
                        "根据我手上的古籍记载，",
                        "这是用来召唤恶灵的仪式。",
                    },
                },
            }
        })
    end)
    Game():npc("KuMoMan3", TPL_UNIT.NPC_Token, 5645, 4792, 210, function(evtUnit)
        evtUnit:name("新人研究员")
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
                        "我们现在在研究这种奇怪的咒文，",
                        "哦，这里这个是符文，咒文长得像个符咒，",
                        "到底有什么秘密，现在还没研究出来呢。",
                    },
                },
            }
        })
    end)
    Game():npc("KuMoMan4", TPL_UNIT.NPC_Token, 4641, 4928, 180, function(evtUnit)
        evtUnit:name("开窍的研究员")
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
                        "这边是四个，四个，",
                        "哈，我懂了！",
                    },
                },
            }
        })
    end)
    Game():dig()
    Game():openDoor(gd.sliceIndex)
end)