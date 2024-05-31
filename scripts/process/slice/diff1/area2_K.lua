local process = Process("slice_diff1_area2_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("VillagerMan1-1", TPL_UNIT.NPC_Token, -951, 2775, 80, function(evtUnit)
        evtUnit:name("兴奋的男村民")
        evtUnit:modelAlias("VillagerMan1")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "终于赶走了盗贼们", "听说首领也被捉了" } } }
        })
    end)
    Game():npc("VillagerMan1-2", TPL_UNIT.NPC_Token, 145, 5769, 270, function(evtUnit)
        evtUnit:name("失泠落嚯的男村民")
        evtUnit:modelAlias("VillagerMan1")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "还好我一直机智躲在墙角", "不然就凉了呀~" } } }
        })
    end)
    Game():npc("VillagerMan2-1", TPL_UNIT.NPC_Token, -950, 5621, -45, function(evtUnit)
        evtUnit:name("紧张的男村民")
        evtUnit:modelAlias("VillagerMan2")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                { tips = { "听说盗贼再找宝物", "也不知道从哪里听说的~" } },
                { tips = { "按我说哪有什么宝物~", "教堂旁那把破弓也算吗？" } },
            }
        })
    end)
    Game():npc("VillagerMan2-2", TPL_UNIT.NPC_Token, 1200, 2905, 180, function(evtUnit)
        evtUnit:name("抱怨的男村民")
        evtUnit:modelAlias("VillagerMan2")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                { tips = { "这村庄也真是多灾多难", "我得考虑离开了~" } },
                { tips = { "什么你不知道？我跟你说", "这村子以前就闹鬼" } },
                { tips = { "闹得可大了，人都跑光了", "后来鬼没了又来盗贼", "诶，受不了，受不了！" } },
            }
        })
    end)
    Game():npc("VillagerKid1-1", TPL_UNIT.NPC_Token, 1183, 5505, 220, function(evtUnit)
        AI("loiter"):link(evtUnit)
        evtUnit:name("着急的小孩")
        evtUnit:modelAlias("VillagerKid1")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 200,
            interval = 0.01,
            message = {
                { tips = { "哈~哈~急~", "哇~哇~忙~" } },
                { tips = { "老爹说要去别的村子", "我得把藏在土里的币币挖出来" } },
                { tips = { "只因忘了埋在哪里了~急~急~急~" } },
            }
        })
    end)
    Game():npc("VillagerKid2-1", TPL_UNIT.NPC_Token, -1065, 3742, 0, function(evtUnit)
        evtUnit:name("捕鱼的小屁孩")
        evtUnit:modelAlias("VillagerKid2")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 200,
            interval = 0.01,
            message = { { tips = { "没东西吃了来抓鱼", "结果一条都没有哦" } } }
        })
    end)
    Game():npc("VillagerWoman", TPL_UNIT.NPC_Token, 54, 4580, 90, function(evtUnit)
        evtUnit:name("惊泠未定的女村民")
        evtUnit:modelAlias("VillagerWoman1")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/what", "tga"), 0.024, 0.024)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "差点就没命了啊", "还好逃出来了", "感恩感恩" } } }
        })
    end)
    Game():npc("EasterChicken1", TPL_UNIT.NPC_Token, 1061, 5568, 270, function(evtUnit)
        evtUnit:name("小鸡")
        evtUnit:modelAlias("EasterChicken")
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        AI("loiter"):link(evtUnit)
    end)
    Game():npc("EasterChicken2", TPL_UNIT.NPC_Token, 23, 5809, 0, function(evtUnit)
        evtUnit:name("小鸡")
        evtUnit:modelAlias("EasterChicken")
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        AI("loiter"):link(evtUnit)
    end)
    Game():openDoor(gd.sliceIndex)
end)