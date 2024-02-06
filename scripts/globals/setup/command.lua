Game():command("^-gg$", function()
    evtData.triggerPlayer:quit("GG")
end)
Game():command("^-apm$", function(evtData)
    echo("您的apm为:" .. evtData.triggerPlayer:apm(), evtData.triggerPlayer)
end)
Game():command("^-d [-+=]%d+$", function(evtData)
    local cds = string.explode(" ", string.lower(evtData.chatString))
    local first = string.sub(cds[2], 1, 1)
    if (first == "+" or first == "-" or first == "=") then
        local v = string.sub(cds[2], 2, string.len(cds[2]))
        v = math.abs(tonumber(v))
        if (v > 0) then
            local val = math.abs(v)
            async.call(evtData.triggerPlayer, function()
                local distance = camera.distance()
                if (first == "+") then
                    distance = distance + val
                elseif (first == "-") then
                    distance = distance - val
                elseif (first == "=") then
                    distance = val
                end
                echo("视距已设置为：" .. camera.distance(distance), evtData.triggerPlayer)
            end)
        end
    end
end)
if (DEBUGGING) then
    Game():command("^-proc [a-zA-Z0-9_]+$", function(evtData)
        local p = string.trim(evtData.matchedString)
        p = string.sub(p, 7, string.len(p))
        local proc
        if (p == "this") then
            proc = ProcessCurrent
        else
            proc = Process(p)
        end
        if (isClass(proc, ProcessClass)) then
            print(p .. "流程已重置")
            ProcessCurrent:over()
            proc:start()
        end
    end)
end