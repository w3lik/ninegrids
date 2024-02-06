local process = Process("slice_diff4_area8_P1")
process:onStart(function(this)
    this:next("interrupt")
    local boss = Game():bossBorn()
    Game():scenes({
        name = "祭泠塔",
        coordinate = {
            { -1210, -2938 }, { -255, -3706 }, { -1178, -3950 },
            { -1060, -4904 }, { 1030, -5530 },
        },
        modelAlias = { "DungeonObilisk", "UndergroundObilisk" },
        modelScale = { 0.9, 1.0 },
        period = { 30, 35 },
        kill = function(sceneData)
            local killer, x, y = sceneData.sourceUnit, sceneData.x, sceneData.y
            boss:orderAttack(x, y)
            boss:attackSpeed("-=10;5")
            boss:move("-=20;5")
            async.call(killer:owner(), function()
                UI_NinegridsInfo:info("info", 3, "祭泠塔令祭泠灵泠震动！速度大大减慢！")
            end)
        end,
    })
end)