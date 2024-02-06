local process = Process("slice_diff3_area1_P1")
process:onStart(function(this)
    this:next("interrupt")
    local e = Game():enemies(TPL_UNIT.IceDragonBuildingBlue, -5410, 5410, 270, true)
    e:onEvent(EVENT.Unit.Dead, function(deadData)
        Game():npcClear()
        async.call(deadData.sourceUnit:owner(), function()
            UI_NinegridsInfo:info("alert", 3, "触犯龙鳞！")
        end)
        Game():xTimer(false, 2, function()
            Game():bossBorn()
        end)
    end)
    Game():npc("KuMoMan1", TPL_UNIT.NPC_Token, -5000, 4322, -60, function(evtUnit)
        evtUnit:name("逃走的研究员")
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
                        "有一座可怕的龙型要塞，",
                        "此地已经不适合继续作研究了。",
                        "快跑！",
                    },
                },
            }
        })
    end)
    Game():npc("KuMoMan2", TPL_UNIT.NPC_Token, -4516, 3493, 120, function(evtUnit)
        evtUnit:name("悲愤的研究员")
        evtUnit:modelAlias("HumanMage")
        evtUnit:modelScale(1)
        evtUnit:scale(1.1)
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.03,
            message = {
                {
                    tips = {
                        "我命不久矣，雕像的秘密要有人知道...",
                        "记得要按西南、东北、西北、东北的顺序",
                        "宝藏就在眼前！",
                    },
                },
                {
                    tips = {
                        "（话毕，重伤的研究员",
                        "又继续躺下休息了...）",
                    },
                },
            }
        })
    end)
end)