local process = Process("slice_diff2_area8_P1")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():scenes({
        name = "葡萄藤",
        coordinate = {
            { -514, -2709 }, { -66, -4363 },
            { 547, -5807 },
            { 657, -2401 }, { -1279, -4610 },
        },
        modelAlias = { "VinyPlant0", "VinyPlant1", "VinyPlant2", "VinyPlant3" },
        modelScale = { 0.9, 1.0, 1.1 },
        period = { 10, 20 },
        deadPeriod = 6,
        kill = function(sceneData)
            local killer = sceneData.sourceUnit
            async.call(killer:owner(), function()
                UI_LikEcho:echo("藏在藤中" .. colour.hex(colour.green, "隐身5秒"))
            end)
            ability.invisible({
                whichUnit = killer,
                duration = 5,
            })
        end,
    })
    local it = autoItemCreate("醉天璇液美酒", -981, -3278, 40)
    if (isClass(it, ItemClass)) then
        it:onEvent(EVENT.Object.Destruct, "ztxy", function()
            async.call(gd.me:owner(), function()
                UI_NinegridsInfo:info("alert", 3, "大胆！！我熊猫的酒也敢偷！！")
            end)
            Game():xTimer(false, 3, function()
                Game():bossBorn()
            end)
        end)
    end
end)