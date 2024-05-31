local process = Process("slice_diff4_area9_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("YJMan1", TPL_UNIT.NPC_Token, 3435, -5408, 120, function(evtUnit)
        evtUnit:name("疯狂沉迷的研究员")
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
                        "铁处女已经研究得差不多了。",
                        "至前另一组人挖出了法老，打扰了我的进度，",
                        "现在继续来研究这个刀山桌。",
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
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "这些白沙似乎隐藏着神奇的力量，",
                        "不过法老已经被重新封印了，",
                        "现在的我实在是提不起劲。",
                    },
                },
            }
        })
    end)
    Game():npc("YJMan3", TPL_UNIT.NPC_Token, 4056, -4519, 250, function(evtUnit)
        evtUnit:name("很想挖掘的研究员")
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
                        "挖呀挖呀挖~我是快乐的挖掘人。",
                        "上次挖出法老宝物我发财了，",
                        "我要继续挖，肯定还有更多的宝物。",
                    },
                },
            }
        })
    end)
    Game():npc("YJMan4", TPL_UNIT.NPC_Token, 4509, -2846, 270, function(evtUnit)
        evtUnit:name("充满期待的研究员")
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
                        "这里已经是我们研究组织的领地了，",
                        "申请？不需要的。至前还有些异族在生活。",
                        "简直就是打扰我们的研究发明，不能忍！",
                        "直接武力将它们全部赶走了。",
                    },
                },
            }
        })
    end)
    Game():dig()
    Game():openDoor(gd.sliceIndex)
end)