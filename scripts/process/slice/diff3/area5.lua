local process = Process("slice_diff3_area5")
process:onStart(function(this)
    Game():sliceIndex(5)
    Bgm():volume(90):play("lik")
    UI_NinegridsMinimap.map:lock(5)
    if (Game():isPass8()) then
        if (Game():isPassAll()) then
            this:next("slice_island_E")
        else
            this:next("slice_island_B")
        end
    else
        this:next("slice_island_K")
    end
    Game():openDoor(5)
end)