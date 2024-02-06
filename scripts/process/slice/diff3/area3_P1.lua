local process = Process("slice_diff3_area3_P1")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    local it = autoItemCreate("特大熊肉", 4115, 4403, 40)
    if (isClass(it, ItemClass)) then
        it:onEvent(EVENT.Object.Destruct, "boss", function()
            async.call(gd.me:owner(), function()
                UI_NinegridsInfo:info("alert", 3, "诶？谁偷我的肉啊")
            end)
            Game():xTimer(false, 3, function()
                Game():bossBorn()
            end)
        end)
    end
    Game():scenes({
        name = "帐篷",
        coordinate = {
            { 4796, 4939 }, { 3858, 3778 }, { 5069, 3808 }, { 3790, 4972 }, { 4489, 4233 },
        },
        modelAlias = { "Tent", "Tent1" },
        modelScale = { 0.8, 0.9 },
        period = 30,
        kill = function(sceneData)
            local killer, x, y = sceneData.sourceUnit, sceneData.x, sceneData.y
            async.call(killer:owner(), function()
                UI_LikEcho:echo(colour.hex(colour.red, "打扰到了驻营的漆黑组织"))
            end)
            if (math.rand(1, 100) < 10) then
                local e = Game():enemies(TPL_UNIT.BlackMageRevenant, x, y, math.rand(0, 359), true)
                e:hp(3000)
                e:attack(400)
            else
                local tpl = { TPL_UNIT.BlackDreadRevenantAlterTC, TPL_UNIT.BlackChaplain, TPL_UNIT.BlackCrimsonCaptain }
                local e = Game():enemies(table.rand(tpl), x, y, math.rand(0, 359), true)
                e:hp(1000)
                e:attack(175)
            end
        end,
    })
end)