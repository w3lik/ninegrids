Game():defineDescription("achievement", function(this, _)
    local desc = {}
    local reward = this:prop("reward")
    table.insert(desc, colour.hex(colour.mediumpurple, "· 奖励 ·"))
    table.insert(desc, "")
    if (type(reward) == "string") then
        table.insert(desc, reward)
    elseif (type(reward) == "table") then
        desc = table.merge(desc, reward)
    end
    table.insert(desc, "")
    table.insert(desc, colour.hex(colour.darkgray, "· 指引 ·"))
    table.insert(desc, "")
    local d2 = this:description()
    if (type(d2) == "string") then
        table.insert(desc, d2)
    elseif (type(d2) == "table") then
        desc = table.merge(desc, d2)
    end
    return desc
end)