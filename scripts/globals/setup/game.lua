Game():hideInterface(true)
Game():enableScreen(FrameBarStateClass, true)
Game():enableScreen(FrameBalloonClass, true)
Game():enableScreen(FrameToastClass, true)
Game():balloonKeyboard('H')
Game():balloonVoicePop(nil, 85)
Game():balloonVoiceFlip("war3_MouseClick2", 75)
Game():onEvent(EVENT.Game.Start, "info", function()
    async.setInterval(1, function()
        local timeOfDay = time.ofDay()
        local tit = ""
        if (timeOfDay >= 0.00 and timeOfDay < 6.00) then
            tit = "凌晨"
        elseif (timeOfDay >= 6.00 and timeOfDay < 8.00) then
            tit = "清晨"
        elseif (timeOfDay >= 8.00 and timeOfDay < 12.00) then
            tit = "上午"
        elseif (timeOfDay >= 12.00 and timeOfDay < 13.00) then
            tit = "中午"
        elseif (timeOfDay >= 13.00 and timeOfDay < 18.00) then
            tit = "下午"
        elseif (timeOfDay >= 18.00 and timeOfDay < 22.00) then
            tit = "夜晚"
        else
            tit = "深夜"
        end
        local i, f = math.modf(timeOfDay)
        f = math.floor(59 * f)
        Game():infoCenter({
            tit,
            string.fill(i, 2, '0') .. ':' .. string.fill(f, 2, '0')
        })
    end)
end)