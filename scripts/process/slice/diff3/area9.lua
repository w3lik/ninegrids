local process = Process("slice_diff3_area9")
process:onStart(function(this)
    Game():sliceIndex(9)
    Bgm():volume(80):play("lik")
    UI_NinegridsMinimap.map:lock(9)
    this:next("area")
end)