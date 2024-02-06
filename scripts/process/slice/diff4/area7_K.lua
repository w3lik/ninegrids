local process = Process("slice_diff4_area7_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("Ent1", TPL_UNIT.NPC_Token, -4941, -3089, -50, function(evtUnit)
        evtUnit:name("无所谓的树精")
        evtUnit:modelAlias("Ent")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1.2)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "森林这次被破坏得很严重", "可能需要很长的时间才能恢复生机" } } }
        })
    end)
    Game():npc("Ent2", TPL_UNIT.NPC_Token, -3058, -5207, 160, function(evtUnit)
        evtUnit:name("悲伤的树精")
        evtUnit:modelAlias("Ent")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1.2)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "小花鹿死了，小老鼠重伤了，", "这次的毁灭是打击性的，", "森林需要孕育出新的使者。" } } }
        })
    end)
    Game():npc("Ent3", TPL_UNIT.NPC_Token, -5850, -5142, 20, function(evtUnit)
        evtUnit:name("笨笨的树精")
        evtUnit:modelAlias("Ent")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1.2)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "树精可以长得很快，", "但是妖灵却不行，现在我们树精，", "就是重建森林的领军，要振作！" } } }
        })
    end)
    Game():npc("Ent4", TPL_UNIT.NPC_Token, -2120, -4741, 180, function(evtUnit)
        evtUnit:name("新生的树精")
        evtUnit:modelAlias("Ent")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1.2)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "我是一个刚诞生的树精，", "还有很多东西我还不明白。" } } }
        })
    end)
    Game():dig()
    Game():openDoor(gd.sliceIndex)
end)