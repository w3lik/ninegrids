local process = Process("slice_diff3_area2_P1")
process:onStart(function(this)
    this:next("interrupt")
    Game():effects("env/HaroldTheScarecrow", -1327, 5164, 0, 270)
    Game():effects("env/HaroldTheScarecrow", -748, 5609, 0, 270)
    Game():effects("env/HaroldTheScarecrow", -639, 4635, 0, 270)
    Game():effects("env/HaroldTheScarecrow", 157, 4664, 0, 270)
    Game():effects("env/HaroldTheScarecrow", 1301, 5358, 0, 270)
    Game():effects("env/HaroldTheScarecrow", 835, 3938, 0, 245)
    Game():effects("env/HaroldTheScarecrow", 1196, 2766, 0, 180)
    Game():effects("env/HaroldTheScarecrow", -567, 2668, 0, 270)
    Game():creeps({
        period = 40,
        coordinate = { { -147, 3782 }, { 124, 5228 }, { 1265, 4386 } },
        elite = {
            tpl = { TPL_UNIT.Abomination },
            qty = 1,
        },
        normal = {
            tpl = { TPL_UNIT.SpikySpriteWhite },
            qty = 2,
        }
    })
    Game():bossBorn()
end)