local class = Class(PlayerClass)
function class:pickMissionItem(tpl)
    local ws = self:warehouseSlot()
    if (ws:empty() == 0) then
        self:alert(colour.hex(colour.red, "材料背包已满"), true)
        return false
    end
    ws:insert(tpl)
    async.call(self, function()
        UI_LikEcho:echo("获得材料" .. colour.hex(colour.gold, '[' .. tpl:name() .. ']'))
        UI_NinegridsAnimate:treasure(FrameButton("ninegrids_essence->warehouse"), -0.05, 0.02)
        audio(Vcm("war3_PickUpItem"))
    end)
    return true
end
function class:award(data)
    self:worth("+", data)
    async.call(self, function()
        if (type(data.copper) == "number" and data.copper > 0) then
            UI_LikEcho:echo("获得铜币 " .. colour.hex(colour.orange, data.copper))
        end
        if (type(data.silver) == "number" and data.silver > 0) then
            UI_LikEcho:echo("获得银币 " .. colour.hex(colour.skyblue, data.silver))
        end
        if (type(data.gold) == "number" and data.gold > 0) then
            UI_LikEcho:echo("获得金币 " .. colour.hex(colour.gold, data.gold))
        end
        UI_NinegridsAnimate:treasure(FrameButton("ninegrids_essence->warehouse"), -0.05, 0.02)
        audio(Vcm("war3_ReceiveGold"))
    end)
    if (Game():achievement(13) ~= true) then
        local wor = self:worth()
        local g = wor.gold or 0
        if (g >= 233) then
            Game():achievement(13, true)
        end
    end
end