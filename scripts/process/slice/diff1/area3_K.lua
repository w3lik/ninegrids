local process = Process("slice_diff1_area3_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("VillagerKid1", TPL_UNIT.NPC_Token, 3162, 4788, 0, function(evtUnit)
        AI("loiter"):link(evtUnit)
        evtUnit:name("乱逛的小屁孩")
        evtUnit:modelAlias("VillagerKid2")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 200,
            interval = 0.01,
            message = { { tips = { "墙里有个小洞~", "我就从那里钻过来了" } } }
        })
    end)
    Game():npc("VillagerMan1-1", TPL_UNIT.NPC_Token, 2813, 5628, 120, function(evtUnit)
        AI("loiter"):link(evtUnit)
        evtUnit:name("傻乎乎的男村民")
        evtUnit:modelAlias("VillagerMan1")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "原来这里面有这么神奇的符文", "怕不是还会有宝藏吧！" } } }
        })
    end)
    Game():npc("VillagerMan1-2", TPL_UNIT.NPC_Token, 3778, 5514, 90, function(evtUnit)
        AI("loiter"):link(evtUnit)
        evtUnit:name("自豪的男村民")
        evtUnit:modelAlias("VillagerMan2")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "其他人并不太敢进来", "按我说他们还是太胆小了。" } } }
        })
    end)
    Game():npc("YJMan1", TPL_UNIT.NPC_Token, 5570, 5379, 90, function(evtUnit)
        evtUnit:name("奇怪的研究员")
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
                        "这遗迹肯定还隐藏着很多秘密，",
                        "可惜现在已经没有什么人研究了，",
                        "毕竟过去研究了许久都没有结果。",
                    },
                },
                {
                    tips = {
                        "现在他们都去雪山研究什么雕像去了，",
                        "反正我不感兴趣，也没路费过去，",
                        "古老的遗迹与固执的我最般配。",
                    },
                },
            }
        })
    end)
    Game():dig()
    Game():openDoor(gd.sliceIndex)
end)