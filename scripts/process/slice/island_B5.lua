local process = Process("slice_island_B5")
process:onStart(function(this)
    this:next("interrupt")
    local coordinate = {
        { 0, 0 }, { -249, 213 }, { 143, -83 }, { -743, -282 }, { 191, -616 },
        { -100, 200 }, { 349, 0 }, { 0, -300 }, { 10, 500 }, { -800, 0 },
        { 74, 605 }, { -743, -60 }, { 69, -774 }, { 677, 46 },
    }
    local effs = {
        "RuneArt1", "RuneArt2", "RuneArt3", "RuneArt5",
        "LavaCracks1", "LavaCracks2", "LavaCracks3",
        "Stake0", "Stake1"
    }
    for _, c in ipairs(coordinate) do
        Game():effects(table.rand(effs), c[1], c[2], 0, math.rand(0, 359)):size(0.1 * math.rand(10, 30))
    end
    Game():bigBossBorn()
end)