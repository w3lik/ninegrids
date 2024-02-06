local process = Process("slice_diff2_area7_P1")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():creeps({
        period = 40,
        coordinate = { { -4911, -3153 }, { -4454, -5595 }, { -3249, -4396 } },
        elite = {
            tpl = { TPL_UNIT.AncientProtector },
            qty = 1,
        },
        normal = {
            tpl = { TPL_UNIT.Ent },
            qty = 3,
        }
    })
    Game():xTimer(false, 30, function()
        async.call(gd.me:owner(), function()
            UI_NinegridsInfo:info("alert", 3, "竟有人毁坏森林！")
        end)
        Game():xTimer(false, 2, function()
            Game():bossBorn()
        end)
    end)
end)