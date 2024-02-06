local process = Process("slice_diff1_area9")
process:onStart(function(this)
    Game():sliceIndex(9)
    Bgm():volume(80):play("lik")
    UI_NinegridsMinimap.map:lock(9)
    if (not Game():sacred(8)) then
        balloonItemCreate(TPL_SACRED[8]:name(), 2439, -5451)
    end
    this:next("area")
end)