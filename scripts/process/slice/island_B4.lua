local process = Process("slice_island_B4")
process:onStart(function(this)
    this:next("interrupt")
    local coordinate = { { 0, 0 }, { -249, 213 }, { 550, -83 }, { -843, -282 }, { 191, -616 }, { -100, 200 }, { 349, 0 }, { 0, -400 }, { 10, 700 }, { -800, 0 } }
    local effs = { "Stake0", "Stake1", "TownBurningFireEmitterBlue" }
    for _, c in ipairs(coordinate) do
        Game():effects(table.rand(effs), c[1], c[2], 0, math.rand(0, 359)):size(0.1 * math.rand(11, 40))
    end
    Game():bigBossBorn()
end)