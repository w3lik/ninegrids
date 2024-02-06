local process = Process("slice_diff1_area9_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("Kobold1", TPL_UNIT.NPC_Token, 3486, -5397, 290, function(evtUnit)
        evtUnit:name("悲观的狗头人")
        evtUnit:modelAlias("Kobold")
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "虽然大个子被打跑了，但是",
                        "所有的一切都被毁了，唉。",
                        "这样下去可如何是好...",
                    },
                },
            }
        })
    end)
    Game():npc("Kobold2", TPL_UNIT.NPC_Token, 3323, -2919, 250, function(evtUnit)
        evtUnit:name("乐观的狗头人")
        evtUnit:modelAlias("Kobold")
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "今朝有酒今朝醉，架起炉子烧野味。",
                        "看我这野猪烤得怎样，香喷喷的。",
                        "还有很多族人等我的食物呢",
                    },
                },
                {
                    tips = {
                        "趁着我还有力气，再去北边捕点鱼。",
                        "总会好起来的，越来越甜。",
                    },
                },
            }
        })
    end)
    Game():npc("Kobold3", TPL_UNIT.NPC_Token, 5542, -2712, 270, function(evtUnit)
        evtUnit:name("苟延残喘的狗头法师")
        evtUnit:modelAlias("KoboldGeomancer")
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "啊~啊~痛!",
                    },
                },
            }
        })
    end)
    Game():npc("Kobold4", TPL_UNIT.NPC_Token, 5044, -4223, 270, function(evtUnit)
        evtUnit:name("灾建的狗头法师")
        evtUnit:modelAlias("KoboldGeomancer")
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "这个放到这边来，",
                        "那个先拿到这边来。",
                        "还有今晚的防御建设先搞好。",
                    },
                    tips = {
                        "动起来，动起来。",
                        "大家快努力，生活还得继续。",
                    },
                },
            }
        })
    end)
    Game():dig()
    Game():openDoor(gd.sliceIndex)
end)