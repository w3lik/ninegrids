local process = Process("slice_diff1_area6")
process:onStart(function(this)
    Game():sliceIndex(6)
    Bgm():volume(85):play("lik")
    UI_NinegridsMinimap.map:lock(6)
    if (not Game():sacred(5)) then
        balloonItemCreate(TPL_SACRED[5]:name(), 5660, -1808)
    end
    this:next("area")
end)