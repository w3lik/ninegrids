local process = Process("slice_diff2_area6_P1")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    async.call(gd.me:owner(), function()
        UI_NinegridsInfo:info("alert", 5, "海域正守卫森严！")
    end)
    local mons = {
        TPL_UNIT.SeaRoyalGuard, TPL_UNIT.SeaSnapDragon,
        TPL_UNIT.MurlocYellow, TPL_UNIT.MurlocOrange, TPL_UNIT.MurlocCyan, TPL_UNIT.MurlocGreen,
        TPL_UNIT.Turtle, TPL_UNIT.SeaTurtleRed,
    }
    local coordinate = { { 4363, 143 }, { 4832, -964 }, { 5618, -201 } }
    local count = 0
    for _, c in ipairs(coordinate) do
        for _ = 1, 4 do
            count = count + 1
            local x, y = vector2.polar(c[1], c[2], math.rand(50, 200), math.rand(0, 359))
            local e = Game():enemies(table.rand(mons), x, y, math.rand(0, 359), true)
            e:hp(400)
            e:attack(125)
            e:onEvent(EVENT.Unit.Dead, function()
                count = count - 1
                if (count <= 0) then
                    Game():enemiesClear()
                    async.call(gd.me:owner(), function()
                        UI_NinegridsInfo:info("alert", 3, "谁在闹事！")
                    end)
                    Game():xTimer(false, 3, function()
                        Game():bossBorn()
                    end)
                end
            end)
        end
    end
end)