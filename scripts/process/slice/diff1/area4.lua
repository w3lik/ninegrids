local process = Process("slice_diff1_area4")
process:onStart(function(this)
    Game():sliceIndex(4)
    Bgm():volume(75):play("lik")
    UI_NinegridsMinimap.map:lock(4)
    if (not Game():sacred(4)) then
        balloonItemCreate(TPL_SACRED[4]:name(), -5914, 562)
    end
    this:next("area")
end)