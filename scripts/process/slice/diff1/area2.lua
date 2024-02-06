local process = Process("slice_diff1_area2")
process:onStart(function(this)
    Game():sliceIndex(2)
    Bgm():volume(90):play("lik")
    UI_NinegridsMinimap.map:lock(2)
    if (not Game():sacred(2)) then
        balloonItemCreate(TPL_SACRED[2]:name(), 765, 6070)
    end
    Game():dig()
    this:next("area")
end)