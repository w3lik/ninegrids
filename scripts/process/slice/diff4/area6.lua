local process = Process("slice_diff4_area6")
process:onStart(function(this)
    Game():sliceIndex(6)
    Bgm():volume(85):play("lik")
    UI_NinegridsMinimap.map:lock(6)
    this:next("area")
end)