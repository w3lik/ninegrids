local process = Process("slice_diff4_area4_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("HeroFlameLord", TPL_UNIT.NPC_Token, -4421, -453, 270, function(evtUnit)
        evtUnit:name("鬼火")
        evtUnit:icon("unit/HellstoneGolem")
        evtUnit:modelAlias("HeroFlameLord")
        evtUnit:modelScale(1.3)
        evtUnit:scale(1.4)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 280,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "呲~呲~呲~",
                    },
                },
            }
        })
    end)
    Game():npc("VillagerMan1", TPL_UNIT.NPC_Token, -5004, 3459, 100, function(evtUnit)
        evtUnit:name("很安心的男村民")
        evtUnit:modelAlias("VillagerMan1")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "有了鬼火在守护我们，这里更安心了。" } } }
        })
    end)
    Game():npc("VillagerMan1-2", TPL_UNIT.NPC_Token, -3830, 1089, 300, function(evtUnit)
        evtUnit:name("欣喜的男村民")
        evtUnit:modelAlias("VillagerMan1")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "我要永远居住在这里，", "不离不弃。~" } } }
        })
    end)
    Game():npc("VillagerMan2-1", TPL_UNIT.NPC_Token, -4128, -656, 110, function(evtUnit)
        evtUnit:name("不再抱怨的男村民")
        evtUnit:modelAlias("VillagerMan2")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                { tips = { "这鬼火可以变热变冷，调节气温。", "这里的生活条件越来越好了。" } },
            }
        })
    end)
    Game():npc("VillagerKid1-1", TPL_UNIT.NPC_Token, -5803, 563, 180, function(evtUnit)
        AI("loiter"):link(evtUnit)
        evtUnit:name("苦逼的小孩")
        evtUnit:modelAlias("VillagerKid1")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        AI("loiter"):link(evtUnit)
        evtUnit:balloon({
            z = 200,
            interval = 0.01,
            message = {
                { tips = { "我上次辛苦埋好的币，", "全被大火烧融流走了。" } },
                { tips = { "以后有一个铜板我就用一个", "再也不存不埋钱了。" } },
            }
        })
    end)
    Game():npc("VillagerKid2-1", TPL_UNIT.NPC_Token, -4906, -1300, 90, function(evtUnit)
        evtUnit:name("就会捕鱼的小孩")
        evtUnit:modelAlias("VillagerKid2")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        AI("loiter"):link(evtUnit)
        evtUnit:balloon({
            z = 200,
            interval = 0.01,
            message = { { tips = { "小河流里抓鱼鱼" } } }
        })
    end)
    Game():npc("VillagerWoman", TPL_UNIT.NPC_Token, -2800, -144, 180, function(evtUnit)
        evtUnit:name("幸福的女村民")
        evtUnit:modelAlias("VillagerWoman1")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
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
    Game():npc("EasterChicken3", TPL_UNIT.NPC_Token, -4989, -1433, 0, function(evtUnit)
        evtUnit:name("小鸡")
        evtUnit:modelAlias("EasterChicken")
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        AI("loiter"):link(evtUnit)
    end)
    Game():npc("EasterChicken4", TPL_UNIT.NPC_Token, -5906, -773, 0, function(evtUnit)
        evtUnit:name("大鸡")
        evtUnit:modelAlias("EasterChicken")
        evtUnit:modelScale(1.3)
        evtUnit:scale(1.3)
        AI("loiter"):link(evtUnit)
    end)
    Game():dig()
    Game():openDoor(gd.sliceIndex)
end)