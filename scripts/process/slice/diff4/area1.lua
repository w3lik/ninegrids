local process = Process("slice_diff4_area1")
process:onStart(function(this)
    Game():sliceIndex(1)
    Bgm():volume(80):play("lik")
    UI_NinegridsMinimap.map:lock(1)
    this:next("area")
end)