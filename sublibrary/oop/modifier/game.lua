local expander = ClassExpander(CLASS_EXPANDS_MOD, GameClass)
expander["blight"] = function(obj)
    local data = obj:propData("blight")
    if (data == true) then
        terrain.setBlightRegion(Player(1), true, RegionWorld)
    else
        terrain.setBlightRegion(Player(1), false, RegionWorld)
    end
end