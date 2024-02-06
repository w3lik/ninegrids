local process = Process("slice_diff4_area7_P1")
process:onStart(function(this)
    this:next("interrupt")
    local g = Group():catch(DestructableClass, {
        circle = { x = -4096, y = -4096, radius = 1000, }
    })
    if (#g > 0) then
        for _, d in ipairs(g) do
            destructable.kill(d)
            local rd = 30 + math.rand(1, 30)
            Game():xTimer(false, rd, function()
                destructable.reborn(d, true)
            end)
        end
    end
    Game():enemies(TPL_UNIT.EldritchCovenant503, -4096, -4096, 270, true)
    Game():xTimer(false, 20, function()
        async.call(PlayerLocal(), function()
            UI_NinegridsInfo:info("alert", 3, "深渊恐怖降临！")
        end)
        Game():xTimer(false, 2, function()
            this:next("slice_diff4_area7_P2")
        end)
    end)
end)