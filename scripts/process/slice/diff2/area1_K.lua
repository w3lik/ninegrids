local process = Process("slice_diff2_area1_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("KuMoMan1", TPL_UNIT.NPC_Token, -5569, 5435, 135, function(evtUnit)
        evtUnit:name("疯子似的研究员")
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
                        "这里难道是？卧槽？卧槽？",
                        "难道竟然是这样吗？？？",
                        "真相竟然就是这样吗！",
                    },
                },
                {
                    tips = {
                        "这么简单的东西都搞不明白！",
                        "我们特么就是些大傻逼啊",
                    },
                },
            }
        })
    end)
    Game():npc("KuMoMan2", TPL_UNIT.NPC_Token, -3321, 5212, 30, function(evtUnit)
        evtUnit:name("病态的研究员")
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
                        "我的助手已经被恶魔吃掉了，",
                        "还好我逃过一劫，我要继续努力研究",
                        "争取破解这个蜘蛛雕像的秘密！",
                    },
                },
            }
        })
    end)
    Game():npc("KuMoMan3", TPL_UNIT.NPC_Token, -5486, 3384, 210, function(evtUnit)
        evtUnit:name("失落的研究员")
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
                        "为了这具蜘蛛雕像我们逝去了多少的研究员，",
                        "现在在我看来，这具根本就不是雕像而是坟碑。",
                    },
                },
            }
        })
    end)
    Game():explain({
        { -5772, 3400, { { tips = { "还是一个蜘蛛雕像" } } } },
        { -5825, 5657, { { tips = { "还是一个蜘蛛雕像" } } } },
        { -3050, 5300, { { tips = { "还是一个蜘蛛雕像" } } } },
    })
    Game():openDoor(gd.sliceIndex)
end)