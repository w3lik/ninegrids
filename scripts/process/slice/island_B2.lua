local process = Process("slice_island_B2")
process:onStart(function(this)
    this:next("interrupt")
    local coordinate = { { 0, 0 }, { -249, 213 }, { 143, -83 }, { -743, -282 }, { 191, -616 } }
    local effs = { "GCracks0", "GCracks1", "GCracks2", "GCracks3" }
    for _, c in ipairs(coordinate) do
        Game():effects(table.rand(effs), c[1], c[2], 0, math.rand(0, 359)):size(0.1 * math.rand(10, 13))
    end
    Game():scenes({
        name = "邪能魔灯",
        coordinate = { { 18, 352 }, { -420, 6 }, { 392, 20 }, { 0, -350 } },
        modelAlias = { "IceTorch" },
        modelScale = { 1.0, 1.1 },
        period = { 20, 30 },
        kill = function(screenData)
            local killer = screenData.sourceUnit
            async.call(killer:owner(), function()
                UI_LikEcho:echo("邪能魔灯" .. colour.hex(colour.red, "令你HP恢复下降但移动变快"))
            end)
            killer:hpRegen("-=15;3")
            killer:move("+=35;3")
        end
    })
    Game():bigBossBorn()
end)