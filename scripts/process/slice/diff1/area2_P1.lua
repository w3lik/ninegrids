local process = Process("slice_diff1_area2_P1")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    async.call(gd.me:owner(), function()
        UI_NinegridsInfo:info("alert", 5, "村庄正受到盗贼攻击！")
    end)
    local militia = { TPL_UNIT.Militia, TPL_UNIT.MilitiaUp }
    local bandit = { TPL_UNIT.Bandit, TPL_UNIT.BanditSpearThrower }
    local coordinate = { { -270, 2711 }, { 10, 5123 }, { 1288, 4395 } }
    local count = 0
    for _, c in ipairs(coordinate) do
        for _ = 1, 3 do
            local a = Game():allys(table.rand(militia), c[1], c[2], 270, true)
            a:hp(130)
            a:attack(20)
        end
        for _ = 1, 6 do
            count = count + 1
            local x, y = vector2.polar(c[1], c[2], math.rand(50, 300), math.rand(0, 359))
            local e = Game():enemies(table.rand(bandit), x, y, math.rand(0, 359), true)
            e:hp(225)
            e:attack(75)
            e:onEvent(EVENT.Unit.Dead, function()
                count = count - 1
                if (count <= 0) then
                    Game():enemiesClear()
                    this:next("slice_diff1_area2_P2")
                end
            end)
        end
    end
end)