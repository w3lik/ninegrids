local process = Process("slice_diff2_area4")
process:onStart(function(this)
    Game():sliceIndex(4)
    Bgm():volume(80):play("lik")
    UI_NinegridsMinimap.map:lock(4)
    this:next("area")
end)