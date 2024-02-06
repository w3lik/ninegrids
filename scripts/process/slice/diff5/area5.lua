local process = Process("slice_diff5_area5")
process:onStart(function(this)
    Game():sliceIndex(5)
    Bgm():volume(80):play("lik")
    UI_NinegridsMinimap.map:lock(5)
    if (Game():isPassLast()) then
        this:next("slice_island_ELast")
    else
        this:next("slice_island_B")
    end
end)