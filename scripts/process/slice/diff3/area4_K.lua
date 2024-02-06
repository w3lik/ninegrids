local process = Process("slice_diff3_area4_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("VillagerMan1", TPL_UNIT.NPC_Token, -5004, 3459, 100, function(evtUnit)
        evtUnit:name("安心的男村民")
        evtUnit:modelAlias("VillagerMan1")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "我们获得了新的土地！" } } }
        })
    end)
    Game():npc("VillagerMan1-2", TPL_UNIT.NPC_Token, -3830, 1089, 300, function(evtUnit)
        evtUnit:name("真香的男村民")
        evtUnit:modelAlias("VillagerMan1")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "这里的空气是那么的香甜~", "我决定要永远居住在这里~" } } }
        })
    end)
    Game():npc("VillagerMan2-1", TPL_UNIT.NPC_Token, -4128, -656, 110, function(evtUnit)
        evtUnit:name("抱怨的男村民")
        evtUnit:modelAlias("VillagerMan2")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                { tips = { "感觉不太好种田啊", "其他人都太乐观了" } },
            }
        })
    end)
    Game():npc("VillagerMan2-2", TPL_UNIT.NPC_Token, -5142, 1314, 230, function(evtUnit)
        evtUnit:name("要强的男村民")
        evtUnit:modelAlias("VillagerMan2")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                { tips = { "困在一个地方不是好事，", "说不得哪天又会有天灾人祸~" } },
                { tips = { "我觉得我要去学艺学武，", "对，就是学武！自己强才是真的强！" } },
                { tips = { "听闻北边的雪山上有位剑术的高手", "过些时候就去拜访一下。" } },
            }
        })
    end)
    Game():npc("VillagerKid1-1", TPL_UNIT.NPC_Token, -5803, 563, 180, function(evtUnit)
        AI("loiter"):link(evtUnit)
        evtUnit:name("机灵的小孩")
        evtUnit:modelAlias("VillagerKid1")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        AI("loiter"):link(evtUnit)
        evtUnit:balloon({
            z = 200,
            interval = 0.01,
            message = {
                { tips = { "我得找个新的隐匿点", "埋好我的私藏金币" } },
                { tips = { "你跟着我干什么？", "快走开啦~" } },
            }
        })
    end)
    Game():npc("VillagerKid2-1", TPL_UNIT.NPC_Token, -4906, -1300, 90, function(evtUnit)
        evtUnit:name("整天捕鱼的小孩")
        evtUnit:modelAlias("VillagerKid2")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        AI("loiter"):link(evtUnit)
        evtUnit:balloon({
            z = 200,
            interval = 0.01,
            message = { { tips = { "这里也有小河流", "应该也可以抓鱼吧" } } }
        })
    end)
    Game():npc("VillagerWoman", TPL_UNIT.NPC_Token, -2800, -144, 180, function(evtUnit)
        evtUnit:name("幸福的女村民")
        evtUnit:modelAlias("VillagerWoman1")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                { tips = { "没有什么比拥有一块肥沃的土地", "更快乐的事了。" } },
                { tips = { "你不觉得幸福吗？" } },
            }
        })
    end)
    Game():npc("EasterChicken1", TPL_UNIT.NPC_Token, -5709, -1546, 270, function(evtUnit)
        evtUnit:name("小鸡")
        evtUnit:modelAlias("EasterChicken")
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        AI("loiter"):link(evtUnit)
    end)
    Game():npc("EasterChicken2", TPL_UNIT.NPC_Token, -5570, -1647, 0, function(evtUnit)
        evtUnit:name("小鸡")
        evtUnit:modelAlias("EasterChicken")
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        AI("loiter"):link(evtUnit)
    end)
    Game():dig()
    Game():openDoor(gd.sliceIndex)
end)