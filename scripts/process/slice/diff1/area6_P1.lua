local process = Process("slice_diff1_area6_P1")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():effects("BannerHuman0", 2643, 1665, 0, 270):size(0.1 * math.rand(9, 11))
    Game():effects("BannerHuman1", 2679, 867, 0, 300):size(0.1 * math.rand(9, 11))
    Game():effects("BannerHuman1", 3366, 160, 0, 270):size(0.1 * math.rand(9, 11))
    Game():effects("BannerHuman0", 4109, 895, 0, 270):size(0.1 * math.rand(9, 11))
    Game():effects("BannerHuman1", 4428, -1328, 0, 270):size(0.1 * math.rand(9, 11))
    Game():effects("BannerOrc0", 5481, 255, 0, 270):size(0.1 * math.rand(9, 11))
    Game():effects("BannerOrc1", 5959, -644, 0, 170):size(0.1 * math.rand(9, 11))
    Game():effects("BannerOrc0", 4681, -184, 0, 225):size(0.1 * math.rand(9, 11))
    Game():effects("BannerOrc1", 4960, -1114, 0, 225):size(0.1 * math.rand(9, 11))
    Game():creeps({
        period = 45,
        coordinate = { { 4492, 1442 }, { 4879, -1014 }, { 5242, -200 } },
        elite = {
            tpl = { TPL_UNIT.SeaSiren, TPL_UNIT.MurlocPurple, TPL_UNIT.MurlocNight, TPL_UNIT.MurlocShadow },
            qty = 2,
        },
        normal = {
            tpl = { TPL_UNIT.MurlocBlue, TPL_UNIT.MurlocDeepBlue },
            qty = 3,
        }
    })
    local coordinate = { { 5687, 1544 }, { 2819, 1253 }, { 4644, -1624 }, { 3823, -495 } }
    local allys = {
        TPL_UNIT.MurlocYellow, TPL_UNIT.MurlocOrange, TPL_UNIT.MurlocCyan,
        TPL_UNIT.Turtle, TPL_UNIT.SeaTurtleRed,
        TPL_UNIT.SeaSnapDragon, TPL_UNIT.SeaMyrmidon,
    }
    local ally = function()
        for _, c in ipairs(coordinate) do
            for _ = 1, 2 do
                local a = Game():allys(table.rand(allys), c[1], c[2], 270, true)
                a:hp(math.floor(150 + gd.erode * 2))
                 :attack(math.floor(35 + gd.erode / 3))
                a:orderAttack(5846, -200)
            end
        end
    end
    ally()
    Game():xTimer(true, 25, function()
        ally()
    end)
    Game():xTimer(false, 45, function()
        async.call(gd.me:owner(), function()
            UI_NinegridsInfo:info("alert", 5, "何人入侵海域？！")
        end)
        Game():xTimer(false, 2, function()
            Game():bossBorn()
        end)
    end)
end)