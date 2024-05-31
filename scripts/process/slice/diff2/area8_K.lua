local process = Process("slice_diff2_area8_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("FlowerDryad", TPL_UNIT.NPC_Token, 1085, -4066, 235, function(evtUnit)
        evtUnit:name("醉仙")
        evtUnit:icon("unit/PandaBrewmaster")
        evtUnit:modelAlias("PandarenBrewmaster")
        evtUnit:modelScale(1.4)
        evtUnit:scale(1.8)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/what", "tga"), 0.024, 0.024)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "呜咕~ 呕咕~",
                        "跟你...一战...酒醒了~",
                    },
                },
                {
                    tips = {
                        "至前有个游侠老是悄悄偷我酒喝，",
                        "我一时心急就打起来了，",
                        "不好意思撒~~抱拳道歉",
                    },
                },
            }
        })
    end)
    Game():npc("PandaEarth", TPL_UNIT.ABILITY_SOUL_PandaEarth, -490, -4611, 135, function(evtUnit)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "没想到你这么强，以我",
                        "开山破土的力量也没法击败你。",
                    },
                },
            }
        })
    end)
    Game():npc("PandaStorm", TPL_UNIT.ABILITY_SOUL_PandaStorm, -1151, -2654, 300, function(evtUnit)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "路上小心~看这天气，",
                        "可能会准备下雷暴",
                    },
                },
            }
        })
    end)
    Game():npc("PandaFire", TPL_UNIT.ABILITY_SOUL_PandaFire, 386, -3127, 300, function(evtUnit)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "我这两把烈焰大刀还未尽全力，",
                        "有机会定要和你再切磋切磋。",
                    },
                },
            }
        })
    end)
    Game():npc("PandaArcher", TPL_UNIT.ABILITY_SOUL_PandaArcher, -670, -3783, 300, function(evtUnit)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "我说什么来着，弓箭不适合我，",
                        "唉，就是二哥非要我用，",
                        "我比较喜欢使用长枪。",
                    },
                },
            }
        })
    end)
    Game():npc("PandaHarvester", TPL_UNIT.ABILITY_SOUL_PandaHarvester, -1455, -5637, 260, function(evtUnit)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "打打杀杀，万一伤到花花草草就不好了",
                    },
                },
            }
        })
    end)
    Game():npc("PandaHonorguard", TPL_UNIT.ABILITY_SOUL_PandaHonorguard, 1538, -5403, 260, function(evtUnit)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "我右侧的山洞可以前往谷底，",
                        "那是牛头人的阵营，不太好惹。",
                        "你去的话要做好防范。",
                    },
                },
                {
                    tips = {
                        "呃~~~~，",
                        "我倒是不把它们放在眼里就是了。",
                    },
                },
            }
        })
    end)
    Game():npc("PandaSage", TPL_UNIT.ABILITY_SOUL_PandaSage, -596, -5319, 130, function(evtUnit)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "欲速则不达，温故而知新，",
                        "现在的年轻一辈就是太急了，",
                        "毛毛躁躁的。",
                    },
                },
                {
                    tips = {
                        "还是跟老头子我学习修仙，",
                        "不对，是修身，还有养性，",
                        "大道者，天蔽也。",
                    },
                },
            }
        })
    end)
    Game():npc("PandaVulture", TPL_UNIT.ABILITY_SOUL_PandaVulture, -321, -5216, 210, function(evtUnit)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "爷爷~爷爷~再给我说说你以前修仙的故事呀",
                    },
                },
            }
        })
    end)
    Game():dig()
    Game():openDoor(gd.sliceIndex)
end)