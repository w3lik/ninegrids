local process = Process("slice_diff2_area8")
process:onStart(function(this)
    Game():sliceIndex(8)
    Bgm():volume(85):play("lik")
    UI_NinegridsMinimap.map:lock(8)
    this:next("area")
end)