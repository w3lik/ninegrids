local process = Process("slice_diff4_area3_P1")
process:onStart(function(this)
    this:next("interrupt")
    Game():npc("KuMoMan", TPL_UNIT.NPC_Token, 4469, 4226, 220, function(evtUnit)
        evtUnit:name("认真的研究员")
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
                        "其他人都已经放弃了，",
                        "我永不放弃！终于有了结果！",
                        "我发现遗迹奇怪的符号是分两种的。",
                    },
                },
                {
                    tips = {
                        "我将它们分为" .. colour.hex(colour.yellow, "咒文与符文") .. "两种。",
                        "咒文形状如同" .. colour.hex(colour.yellow, "一张符箓") .. "，",
                        "它应该是用来召唤死界的魔物，",
                        "你可以去试试看。",
                    },
                },
            }
        })
    end)
    local count = 0
    local countCall = function(callbackData)
        destroy(callbackData.balloonObj)
        local p = callbackData.triggerUnit:owner()
        count = count + 1
        if (count >= 3) then
            Game():explainClear()
            async.call(p, function()
                audio(Vcm("monster"))
                UI_NinegridsInfo:info("alert", 3, "WHO IS BOTHERING!")
            end)
            Game():xTimer(false, 2, function()
                this:next("slice_diff4_area3_P2")
            end)
        else
            async.call(p, function()
                UI_NinegridsInfo:info("info", 3, "咒文响应：" .. colour.hex(colour.red, count .. "/3"))
            end)
        end
    end
    Game():explain({
        { 4904, 3389, {
            {
                tips = {
                    "异样的咒文",
                    Game():balloonKeyboardTips("触摸一下")
                },
                call = countCall
            }
        } },
        { 4166, 5792, {
            {
                tips = {
                    "异样的咒文",
                    Game():balloonKeyboardTips("触摸一下")
                },
                call = countCall
            }
        } },
        { 2617, 3901, {
            {
                tips = {
                    "异样的咒文",
                    Game():balloonKeyboardTips("触摸一下")
                },
                call = countCall
            }
        } },
    })
end)