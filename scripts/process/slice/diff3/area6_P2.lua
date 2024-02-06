local process = Process("slice_diff3_area6_P2")
process:onStart(function(this)
    this:next("interrupt")
    local boss = Game():bossBorn()
    local coordinate = { { 4718, 1594 }, { 2837, -104 }, { 4614, -1895 } }
    local allys = { TPL_UNIT.SeaSnapDragon, TPL_UNIT.SeaMyrmidon, TPL_UNIT.SeaRoyalGuard, TPL_UNIT.SeaTurtleRed }
    local ally = function()
        for _, c in ipairs(coordinate) do
            for _ = 1, 2 do
                local a = Game():allys(table.rand(allys), c[1], c[2], 270, true)
                a:hp(400)
                a:attack(80)
                a:orderAttackTargetUnit(boss)
            end
        end
    end
    ally()
    Game():xTimer(true, 30, function()
        ally()
    end)
end)