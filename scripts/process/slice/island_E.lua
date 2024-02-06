local process = Process("slice_island_E")
process:onStart(function(this)
    local gd = Game():GD()
    if (gd.meAbilityFreak > 0) then
        Game():achievement(9, true)
    end
    this:next("slice_island_ENext")
end)