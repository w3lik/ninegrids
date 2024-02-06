local process = Process("slice_diff1_area7")
process:onStart(function(this)
    Game():sliceIndex(7)
    Bgm():volume(85):play("lik")
    UI_NinegridsMinimap.map:lock(7)
    if (not Game():sacred(6)) then
        balloonItemCreate(TPL_SACRED[6]:name(), -2779, -5882)
    end
    this:next("area")
end)