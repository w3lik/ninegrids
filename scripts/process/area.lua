local process = Process("area")
process:onStart(function(this)
    local gd = Game():GD()
    local diff = math.round(gd.diff)
    local sliceIndex = math.round(gd.sliceIndex)
    if (gd.sliceResult[sliceIndex] == 1) then
        this:next("slice_diff" .. diff .. "_area" .. sliceIndex .. "_K")
    else
        this:next("slice_diff" .. diff .. "_area" .. sliceIndex .. "_P1")
    end
end)
