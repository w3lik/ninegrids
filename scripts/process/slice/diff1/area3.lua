local process = Process("slice_diff1_area3")
process:onStart(function(this)
    Game():sliceIndex(3)
    Bgm():volume(80):play("lik")
    UI_NinegridsMinimap.map:lock(3)
    if (not Game():sacred(3)) then
        balloonItemCreate(TPL_SACRED[3]:name(), 4388, 5596)
    end
    this:next("area")
end)