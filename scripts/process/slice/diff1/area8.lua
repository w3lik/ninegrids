local process = Process("slice_diff1_area8")
process:onStart(function(this)
    Game():sliceIndex(8)
    Bgm():volume(85):play("lik")
    UI_NinegridsMinimap.map:lock(8)
    if (not Game():sacred(7)) then
        balloonItemCreate(TPL_SACRED[7]:name(), 1739, -2506)
    end
    this:next("area")
end)