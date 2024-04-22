if (false == DEBUGGING) then
    Game():onEvent(EVENT.Game.Start, "negativeHangUp", function()
        sync.receive("negativeHangUp", function(syncData)
            local idx = tonumber(syncData.transferData[1])
            Player(idx):quit("消极挂机")
        end)
        async.call(PlayerLocal(), function()
            local cx, cy = camera.x(), camera.y()
            local click = false
            local clickResume = function()
                click = true
            end
            mouse.onLeftClick("negativeHangUp", clickResume)
            mouse.onRightClick("negativeHangUp", clickResume)
            local i = 0
            async.setInterval(3000, function(curTimer)
                i = i + 1
                if (i > 3) then
                    destroy(curTimer)
                    return
                end
                local cx2, cy2 = camera.x(), camera.y()
                if (click ~= true and cx == cx2 and cy == cy2) then
                    destroy(curTimer)
                    sync.send("negativeHangUp", { PlayerLocal():index() })
                    return
                end
                cx, cy = cx2, cy2
                click = false
            end)
        end)
    end)
end