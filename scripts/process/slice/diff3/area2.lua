local process = Process("slice_diff3_area2")
process:onStart(function(this)
    Game():sliceIndex(2)
    Bgm():volume(90):play("lik")
    UI_NinegridsMinimap.map:lock(2)
    this:next("area")
end)