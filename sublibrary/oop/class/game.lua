local class = Class(GameClass)
function class:infoCenter(modify)
    return self:prop("infoCenter", modify)
end
function class:GD()
    local v = self:prop("#GD")
    if (v == nil) then
        v = {
            running = true,
            diff = 1,
            diffMax = 1,
            sliceIndex = 5,
            sliceResult = table.repeater(0, 9),
            weather = 1,
            erode = 0,
            skin = RACE_HUMAN_NAME,
            border = 0,
            fireLevel = 0,
            achievement = table.repeater(0, #TPL_ACHIEVEMENT),
            soul = table.merge(table.repeater(1, 8), table.repeater(0, #TPL_SOUL - 8)),
            abilityTail = 5,
            abilityMaxLv = 9,
            abilityLevel = table.repeater(1, #TPL_ABILITY_SOUL),
            abilityDiscount = 1,
            abilityUpgrade = 0,
            sacredMaxLv = 9,
            sacredGet = table.repeater(0, #TPL_SACRED),
            sacredForge = table.repeater(1, #TPL_SACRED),
            sacredForgeFail = 0,
            sacredDiscount = 1,
            sacredOdds = 0,
            sacredUpgrade = 0,
            upgradePoint = 0,
            upgradeStart = 0,
            upgradeAtk = 0,
            upgradeDef = 0,
            upgradeSpd = 0,
            me = nil,
            meSoul1 = 1,
            meSoul2 = 2,
            meSoul3 = 3,
            meSoul4 = 4,
            meSoul5 = 5,
            mePoint = 1,
            meAbilityFreak = 0,
            meKill = 0,
            meDead = 0,
            meDied = 0,
            meDamage = 0,
            meHurt = 0,
            lastDead = 0,
            meE = {},
        }
        v.abilityLearn = table.repeater(0, v.abilityTail)
        v.sacredUse = table.repeater(0, #self:itemHotkey()),
        self:prop("#GD", v)
    end
    return v
end
function class:meName()
    local gd = self:GD()
    local me = gd.me
    if (isClass(me, UnitClass) and me:isAlive()) then
        return me:name()
    end
    return '_'
end
function class:npc(uniqueKey, tpl, x, y, facing, call)
    local cache = self:prop("npcCache")
    if (cache == nil) then
        cache = {}
        self:prop("npcCache", cache)
    end
    if (cache[uniqueKey] ~= nil or tpl == nil) then
        return cache[uniqueKey]
    end
    local queue = self:prop("npcQueue")
    if (queue == nil) then
        queue = {}
        self:prop("npcQueue", queue)
    end
    table.insert(queue, { uniqueKey, tpl, x, y, facing, call })
    local queueTimer = self:prop("npcQueueTimer")
    if (false == isClass(queueTimer, TimerClass)) then
        self:prop("npcQueueTimer", time.setInterval(0.2, function(curTimer)
            if (#queue <= 0) then
                destroy(curTimer)
                return
            end
            local q = queue[1]
            table.remove(queue, 1)
            local k, t, x2, y2, f, c = q[1], q[2], q[3], q[4], q[5], q[6]
            local u = Unit(t, PlayerPassive, x2, y2, f)
            u:superposition("invulnerable", "+=1")
            cache[k] = u
            Pool("npcs"):insert(u)
            u:effect("eff/FantasyCircles", 1)
            u:onEvent(EVENT.Object.Destruct, "npc", function()
                Screen():remove(FrameBalloonClass, u)
                Pool("npcs"):remove(u)
                cache[k] = nil
            end)
            if (type(c) == "function") then
                c(u)
            end
        end))
    end
end
function class:npcClear()
    Pool("npcs"):backEach(function(enumObj)
        destroy(enumObj, 0)
    end)
    Pool("npcs"):removeAll()
end
function class:enemies(tpl, x, y, facing, hasErode)
    local e = Team("enemies"):unit(tpl, x, y, facing)
    if (true == hasErode) then
        e:abilitySlot():tail(6)
        e:abilitySlot():insert(TPL_ABILITY_BOSS["界泠恶化"], 6)
    end
    e:iconMap(AUIKit("ninegrids_minimap", "dot/monster", "tga"), 0.018, 0.018)
    Pool("enemies"):insert(e)
    e:onEvent(EVENT.Unit.Dead, "enemies", function()
        local me = Game():GD().me
        if (isClass(me, UnitClass)) then
            local copper = math.round(e:hp() + math.rand(-40, 150))
            me:owner():award(Game():worthL2U({ copper = math.max(1, copper) }))
        end
    end)
    e:onEvent(EVENT.Object.Destruct, "enemies", function()
        Pool("enemies"):remove(e)
    end)
    return e
end
function class:enemiesClear()
    Pool("enemies"):backEach(function(enumObj)
        destroy(enumObj, 0)
    end)
    Pool("enemies"):removeAll()
end
function class:allys(tpl, x, y, facing)
    local a = Unit(tpl, Player(2), x, y, facing)
    Pool("allys"):insert(a)
    a:onEvent(EVENT.Object.Destruct, "allys", function()
        Pool("allys"):remove(a)
    end)
    return a
end
function class:allysClear()
    Pool("allys"):backEach(function(enumObj)
        destroy(enumObj, 0)
    end)
    Pool("allys"):removeAll()
end
function class:summons(owner, tpl, x, y, facing)
    local u = Unit(tpl, owner, x, y, facing)
    Pool("summons"):insert(u)
    u:onEvent(EVENT.Object.Destruct, "summons", function()
        Pool("summons"):remove(u)
    end)
    return u
end
function class:summonsClear()
    Pool("summons"):backEach(function(enumObj)
        destroy(enumObj, 0)
    end)
    Pool("summons"):removeAll()
end
function class:autoUseItem(tpl, x, y, dur)
    local it = Item(tpl)
    it:position(x, y)
    if (type(dur) == "number" and dur > 0) then
        it:duration(dur)
    end
    Pool("autoUseItem"):insert(it)
    it:onEvent(EVENT.Object.Destruct, "autoUseItem", function()
        Pool("autoUseItem"):remove(it)
    end)
    return it
end
function class:autoUseItemClear()
    Pool("autoUseItem"):backEach(function(enumObj)
        destroy(enumObj, 0)
    end)
    Pool("autoUseItem"):removeAll()
end
function class:effects(modelAlias, x, y, zOffset, facing)
    local e = Effect(modelAlias, x, y, japi.Z(x, y) + zOffset, -1)
    e:rotateZ(facing or 270)
    Pool("effects"):insert(e)
    e:onEvent(EVENT.Object.Destruct, "effects", function(destroyData)
        Pool("effects"):remove(destroyData.triggerEffect)
    end)
    return e
end
function class:effectsClear()
    Pool("effects"):backEach(function(enumObj)
        destroy(enumObj, 0)
    end)
    Pool("effects"):removeAll()
end
function class:xTimer(isLoop, period, callFunc)
    local t
    if (isLoop) then
        t = time.setInterval(period, callFunc)
    else
        t = time.setTimeout(period, callFunc)
    end
    Pool("xTimers"):insert(t)
    t:onEvent(EVENT.Object.Destruct, "xTimers", function(destroyData)
        Pool("xTimers"):remove(destroyData.triggerTimer)
    end)
    return t
end
function class:xTimerClear()
    Pool("xTimers"):backEach(function(enumObj)
        destroy(enumObj, 0)
    end)
    Pool("xTimers"):removeAll()
end
function class:digClear()
    local digEffects = self:prop("digEffects")
    if (type(digEffects) == "table") then
        for _, e in pairx(digEffects) do
            Screen():remove(FrameBalloonClass, e)
            digEffects[e:id()] = nil
            destroy(e)
        end
    end
    self:clear("digEffects")
end
function class:dig()
    self:digClear()
    local sliceIndex = self:GD().sliceIndex
    if (type(DIG_COORDINATE[sliceIndex]) == "table") then
        if (#DIG_COORDINATE[sliceIndex] > 0) then
            local digEffects = {}
            self:prop("digEffects", digEffects)
            local coord = table.rand(DIG_COORDINATE[sliceIndex], 4)
            local grassTuft = { "GrassTuft0", "GrassTuft1", "GrassTuft2", "GrassTuft3" }
            for _, c in ipairs(coord) do
                local e = Effect(table.rand(grassTuft, 1), c[1], c[2], japi.Z(c[1], c[2]), -1):size(2)
                e:balloon({
                    x = c[1],
                    y = c[2],
                    z = 130,
                    interval = 0.01,
                    message = {
                        {
                            tips = { self:balloonKeyboardTips("挖掘") },
                            call = function(callbackData)
                                local eb = callbackData.balloonObj
                                digEffects[eb:id()] = nil
                                destroy(eb)
                                local gd = self:GD()
                                local p = callbackData.triggerUnit:owner()
                                local cv = gd.diff * 100 + 10 * math.rand(1, 200) + 2 * gd.erode
                                p:award({ copper = cv })
                                async.call(p, function()
                                    UI_NinegridsInfo:info("info", 5, "挖出 " .. colour.hex(colour.orange, cv) .. " 铜币")
                                end)
                            end
                        }
                    }
                })
                digEffects[e:id()] = e
            end
        end
    end
end
function class:explain(coordinate)
    if (type(coordinate) == "table" and #coordinate > 0) then
        for _, coo in ipairs(coordinate) do
            local c = Coordinate(coo[1], coo[2])
            c:balloon({
                x = coo[1],
                y = coo[2],
                z = 150,
                interval = 0.01,
                message = coo[3]
            })
            Pool("explain"):insert(c)
            c:onEvent(EVENT.Object.Destruct, "explain", function()
                Pool("explain"):remove(c)
            end)
        end
    end
end
function class:explainClear()
    Pool("explain"):backEach(function(enumObj)
        destroy(enumObj, 0)
    end)
    Pool("explain"):removeAll()
end
function class:creeps(options)
    must(type(options.coordinate) == "table" and #options.coordinate > 0)
    local period = options.period or 40
    local checker = {}
    local _creep
    _creep = function(x, y)
        x = math.round(x)
        y = math.round(y)
        local k = x .. '_' .. y
        local gd = self:GD()
        if (checker[k] == nil or checker[k] == 0) then
            checker[k] = 0
            if (type(options.elite) == "table") then
                options.elite.qty = options.elite.qty or 0
                if (options.elite.qty > 0 and #options.elite.tpl > 0) then
                    checker[k] = checker[k] + options.elite.qty
                    for _ = 1, options.elite.qty do
                        local tx, ty = vector2.polar(x, y, math.rand(0, 25 * options.elite.qty), math.rand(0, 359))
                        local e = self:enemies(table.rand(options.elite.tpl), tx, ty, 270, true)
                        e:hp(gd.diff * 400)
                        e:attack(gd.diff * 90)
                        e:defend(gd.diff * 5)
                        e:onEvent(EVENT.Unit.Dead, "creeps", function(deadData)
                            checker[k] = checker[k] - 1
                            local dx, dy = deadData.triggerUnit:x(), deadData.triggerUnit:y()
                            if (type(options.elite.balloonItem) == "table") then
                                if (math.rand(1, 5) == 3) then
                                    balloonItemCreate(table.rand(options.elite.balloonItem, 1), dx, dy, 30)
                                end
                            end
                            if (type(options.elite.autoItem) == "table") then
                                if (math.rand(1, 9) == 5) then
                                    autoItemCreate(table.rand(options.elite.autoItem, 1), dx, dy, 10)
                                end
                            end
                            if (checker[k] <= 0) then
                                self:xTimer(false, period, function()
                                    _creep(x, y)
                                end)
                            end
                        end)
                        if (isClass(options.elite.ai, AIClass)) then
                            options.elite.ai:link(e)
                        end
                    end
                end
            end
            if (type(options.normal) == "table") then
                options.normal.qty = options.normal.qty or 0
                if (options.normal.qty > 0 and #options.normal.tpl > 0) then
                    checker[k] = checker[k] + options.normal.qty
                    for _ = 1, options.normal.qty do
                        local tx, ty = vector2.polar(x, y, math.rand(0, 70 * options.normal.qty), math.rand(0, 359))
                        local e = self:enemies(table.rand(options.normal.tpl), tx, ty, 270, true)
                        e:hp(gd.diff * 150)
                        e:attack(gd.diff * 60)
                        e:defend(gd.diff * 1)
                        e:onEvent(EVENT.Unit.Dead, "creeps", function(deadData)
                            checker[k] = checker[k] - 1
                            local dx, dy = deadData.triggerUnit:x(), deadData.triggerUnit:y()
                            if (type(options.normal.balloonItem) == "table") then
                                if (math.rand(1, 5) <= 2) then
                                    balloonItemCreate(table.rand(options.normal.balloonItem, 1), dx, dy, 30)
                                end
                            end
                            if (type(options.normal.autoItem) == "table") then
                                if (math.rand(1, 9) == 5) then
                                    autoItemCreate(table.rand(options.normal.autoItem, 1), dx, dy, 10)
                                end
                            end
                            if (checker[k] <= 0) then
                                self:xTimer(false, period, function()
                                    _creep(x, y)
                                end)
                            end
                        end)
                        if (isClass(options.normal.ai, AIClass)) then
                            options.normal.ai:link(e)
                        end
                    end
                end
            end
        end
    end
    for _, v in ipairs(options.coordinate) do
        _creep(v[1], v[2])
    end
end
function class:scenes(options)
    must(type(options.coordinate) == "table" and #options.coordinate > 0)
    must(type(options.modelAlias) == "table" and #options.modelAlias > 0)
    must(type(options.modelScale) == "table" and #options.modelScale > 0)
    local period = options.period
    if (period == nil) then
        period = 30
    elseif (type(period) == "table") then
        period = math.rand(math.floor(period[1]), math.ceil(period[2]))
    end
    local _scene
    _scene = function(x, y)
        local scale = table.rand(options.modelScale)
        local e = Team("enemies"):unit(TPL_UNIT.SCENE, x, y, math.rand(0, 359))
        e:name(options.name)
        e:modelAlias(table.rand(options.modelAlias))
        e:modelScale(scale)
        e:scale(scale)
        if (type(options.dead) == "function") then
            local deadPeriod = options.deadPeriod
            if (deadPeriod == nil) then
                deadPeriod = 10
            elseif (type(deadPeriod) == "table") then
                deadPeriod = math.rand(math.floor(deadPeriod[1]), math.ceil(deadPeriod[2]))
            end
            e:period(deadPeriod)
        end
        Pool("enemies"):insert(e)
        e:onEvent(EVENT.Object.Destruct, "scene", function()
            Pool("enemies"):remove(e)
        end)
        e:onEvent(EVENT.Unit.Dead, "scene", function(deadUnit)
            deadUnit.x = x
            deadUnit.y = y
            if (isClass(deadUnit.sourceUnit, UnitClass)) then
                if (type(options.kill) == "function") then
                    options.kill(deadUnit)
                end
            else
                if (type(options.dead) == "function") then
                    options.dead(deadUnit)
                end
            end
            self:xTimer(false, period, function()
                _scene(x, y)
            end)
        end)
    end
    for _, v in ipairs(options.coordinate) do
        self:xTimer(false, math.min(0, period / 5), function()
            _scene(v[1], v[2])
        end)
    end
end
function class:sliceDefTo(index)
    if (index == 1) then
        return G_DOORS.c.ice.to
    elseif (index == 2) then
        return G_DOORS.c.village.to
    elseif (index == 3) then
        return G_DOORS.c.ruins.to
    elseif (index == 4) then
        return G_DOORS.c.red.to
    elseif (index == 5) then
        return G_DOOR_ME
    elseif (index == 6) then
        return G_DOORS.c.sea.to
    elseif (index == 7) then
        return G_DOORS.c.forest.to
    elseif (index == 8) then
        return G_DOORS.c.treasure.to
    elseif (index == 9) then
        return G_DOORS.c.mountain.to
    elseif (index == "fire") then
        return G_DOORS.c.fire.to
    end
end
function class:slicePosition(index, to, delayCall)
    local me = self:GD().me
    local p = me:owner()
    audio(Vcm("portal"), p, function(this) this:volume(50) end)
    UI_NinegridsMinimap.map:unlock()
    if (isClass(me, UnitClass) and me:isAlive()) then
        to = to or self:sliceDefTo(index)
        me:position(to[1], to[2])
        camera.to(to[1], to[2], 0)
        p:warehouseSlot():removeAll()
        if (type(delayCall) == "function") then
            time.setTimeout(0.05, function()
                delayCall()
            end)
        end
    end
end
function class:closeDoor()
    for key, door in pairx(G_DOORING) do
        destroy(door)
        G_DOORING[key] = nil
    end
end
function class:openDoor(index)
    self:closeDoor()
    self:enemiesClear()
    local gd = self:GD()
    local door = {}
    if (index == 1) then
        table.insert(door, G_DOORS.ice.red)
        table.insert(door, G_DOORS.ice.village)
    elseif (index == 2) then
        table.insert(door, G_DOORS.village.ice)
        table.insert(door, G_DOORS.village.ruins)
    elseif (index == 3) then
        table.insert(door, G_DOORS.ruins.village)
        table.insert(door, G_DOORS.ruins.sea)
        table.insert(door, G_DOORS.ruins.forest)
    elseif (index == 4) then
        table.insert(door, G_DOORS.red.ice)
        table.insert(door, G_DOORS.red.forest)
    elseif (index == 5) then
        local tmp = {
            [1] = G_DOORS.c.ice,
            [2] = G_DOORS.c.village,
            [3] = G_DOORS.c.ruins,
            [4] = G_DOORS.c.red,
            [5] = nil,
            [6] = G_DOORS.c.sea,
            [7] = G_DOORS.c.forest,
            [8] = G_DOORS.c.treasure,
            [9] = G_DOORS.c.mountain,
        }
        for i, v in ipairs(gd.sliceResult) do
            local d = tmp[i]
            if (v ~= 1 and d ~= nil) then
                table.insert(door, d)
            end
        end
    elseif (index == 6) then
        table.insert(door, G_DOORS.sea.ruins)
        table.insert(door, G_DOORS.sea.mountain)
    elseif (index == 7) then
        table.insert(door, G_DOORS.forest.red)
        table.insert(door, G_DOORS.forest.treasure)
    elseif (index == 8) then
        table.insert(door, G_DOORS.treasure.forest)
        table.insert(door, G_DOORS.treasure.mountain)
    elseif (index == 9) then
        table.insert(door, G_DOORS.mountain.treasure)
        table.insert(door, G_DOORS.mountain.sea)
    elseif (index == "fire") then
        table.insert(door, G_DOORS.fire.c)
    end
    local icon, eff
    local diff = math.round(gd.diff)
    if (diff == 1) then
        icon = "ability/InscriptionVantusRuneAzure"
        eff = "aura/MalevolenceAura_Blue"
    elseif (diff == 2) then
        icon = "ability/InscriptionVantusRuneTomb"
        eff = "aura/MalevolenceAura_Green"
    elseif (diff == 3) then
        icon = "ability/InscriptionVantusRuneSuramar"
        eff = "aura/MalevolenceAura_Purple"
    elseif (diff == 4) then
        icon = "ability/InscriptionVantusRuneNightmare"
        eff = "aura/MalevolenceAura_Red"
    else
        return
    end
    local _door = function(d, size)
        local key = d.from[1] .. '_' .. d.from[2]
        local name = UI_NinegridsMinimap:mapName(d.to[3]) or "未知至地"
        self:npc("door" .. key, TPL_UNIT.NPC_Token, d.from[1], d.from[2], 270, function(evtUnit)
            evtUnit:superposition("locust", 1)
            evtUnit:flyHeight(30)
            evtUnit:name(name)
            evtUnit:modelAlias(eff)
            evtUnit:icon(icon)
            evtUnit:modelScale(size)
            local iSize = size * 0.022
            evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/whirlpool", "tga"), iSize, iSize)
            evtUnit:balloon({
                z = 160,
                interval = 0.01,
                message = {
                    {
                        tips = function()
                            if (gd.sliceResult[d.to[3]] == 1) then
                                return {
                                    "前往 " .. colour.hex(colour.darkseagreen, name),
                                    self:balloonKeyboardTips("进行传送")
                                }
                            else
                                return {
                                    "前往 " .. colour.hex(colour.littlepink, name),
                                    self:balloonKeyboardTips("进行冒险")
                                }
                            end
                        end,
                        call = function()
                            if (d.to[3]) then
                                async.call(gd.me:owner(), function()
                                    UI_NinegridsAnimate:blackHole()
                                end)
                                self:slicePosition(d.to[3], d.to, function()
                                    ProcessCurrent:next("slice_diff" .. diff .. "_area" .. d.to[3])
                                end)
                                self:npcClear()
                                self:summonsClear()
                                self:enemiesClear()
                                self:allysClear()
                                self:effectsClear()
                                self:digClear()
                            end
                        end
                    },
                }
            })
            G_DOORING[key] = evtUnit
        end)
    end
    if (#door > 0) then
        for _, d in ipairs(door) do
            _door(d, 0.75)
        end
    end
    if (type(index) == "number") then
        if (gd.diff <= 4 and index >= 1 and index <= 9 and index ~= 5) then
            if (self:isPass8()) then
                if (index > 5) then
                    index = index - 1
                end
                local d = G_DOORS.middle[index]
                if (type(d) == "table") then
                    _door(d, 1.4)
                end
            end
        end
    end
end
function class:isPass8()
    local is = true
    local sliceResult = self:GD().sliceResult
    for i, res in ipairs(sliceResult) do
        if (i ~= 5) then
            if (res ~= 1) then
                is = false
            end
        end
    end
    return is
end
function class:isPassAll()
    local is = true
    local sliceResult = self:GD().sliceResult
    for _, res in ipairs(sliceResult) do
        if (res ~= 1) then
            is = false
        end
    end
    return is
end
function class:isPassLast()
    local gd = self:GD()
    return gd.diff == 5 and gd.sliceResult[5] == 1
end
function class:setWaterColor(diff)
    if (diff == 1) then
        terrain.setWaterColor(0, 255, 255, 255)
    elseif (diff == 2) then
        terrain.setWaterColor(0, 255, 0, 255)
    elseif (diff == 3) then
        terrain.setWaterColor(111, 37, 131, 255)
    elseif (diff == 4) then
        terrain.setWaterColor(255, 0, 0, 255)
    end
end
function class:save(key, data)
    sync.must()
    local gd = self:GD()
    if (data ~= nil) then
        if (key == "diff") then
            must(data >= 1 and data <= 5)
            self:setWaterColor(data)
        elseif (key == "diffMax") then
            must(data >= 1 and data <= 5)
        elseif (key == "sliceIndex") then
            must(data >= 1 and data <= 9)
            async.call(gd.me:owner(), function()
                UI_NinegridsInfo:navi(data)
            end)
        elseif (key == "sliceResult") then
            must(#data == 9)
        elseif (key == "weather") then
            must(data >= 1 and data <= #TPL_WEATHER)
        elseif (key == "erode") then
            must(data >= 0)
        elseif (key == "meSoul1" or key == "meSoul2" or key == "meSoul3" or key == "meSoul4" or key == "meSoul5") then
            must(data >= 1 and data <= #TPL_SOUL)
        elseif (key == "meAbilityFreak") then
            must(data >= 0 and data <= 6)
        elseif (key == "meKill") then
            must(data >= 0)
        elseif (key == "meDead") then
            must(data >= 0)
        elseif (key == "meDied") then
            must(data == 0 or data == 1)
        elseif (key == "meDamage") then
            must(data >= 0)
        elseif (key == "meHurt") then
            must(data >= 0)
        elseif (key == "lastDead") then
            must(data >= 0)
        elseif (key == "fireLevel") then
            must(data >= 0 and data <= 9)
        elseif (key == "soul") then
            must(#data == #TPL_SOUL)
        elseif (key == "achievement") then
            must(#data == #TPL_ACHIEVEMENT)
        elseif (key == "abilityLevel") then
            must(#data == #TPL_ABILITY_SOUL)
        elseif (key == "sacredGet") then
            must(#data == #TPL_SACRED)
        elseif (key == "sacredForge") then
            must(#data == #TPL_SACRED)
        end
        gd[key] = data
    end
    local p = Player(1)
    local sv = Server(p)
    async.call(p, function()
        UI_NinegridsAnimate:save()
    end)
    if (key == "skin" or key == "copper"
        or key == "diff" or key == "sliceIndex" or key == "sliceResult"
        or key == "weather"
        or key == "upgradePoint") then
        local skin, dia
        async.call(p, function()
            skin = p:skin()
        end)
        if (skin == nil) then
            skin = RACE_HUMAN_NAME
        end
        if (dia == nil) then
            dia = 0
        end
        local copper = self:worthU2L(p:worth()).copper or 0
        copper = math.floor(copper)
        copper = math.max(0, copper)
        local sliceResult = "000000000"
        if (#gd.sliceResult == 9) then
            sliceResult = table.concat(gd.sliceResult, '')
        end
        local merge = {
            skin, dia, copper,
            gd.diff, gd.sliceIndex, sliceResult,
            gd.weather,
            gd.upgradePoint, gd.upgradeDef, gd.upgradeAtk, gd.upgradeSpd
        }
        sv:save("GG", table.concat(merge, '|'))
        if (key == "diff" and gd.diffMax < data) then
            gd.diffMax = math.min(5, data)
            sv:save("DMX", gd.diffMax)
        end
    elseif (key == "diffMax") then
        sv:save("DMX", gd.diffMax)
    elseif (key == "meSoul1" or key == "meSoul2" or key == "meSoul3" or key == "meSoul4" or key == "meSoul5" or
        key == "meAbilityFreak" or key == "abilityLearn" or key == "sacredUse") then
        local merge = { gd.meSoul1, gd.meSoul2, gd.meSoul3, gd.meSoul4, gd.meSoul5, gd.meAbilityFreak }
        merge = table.merge(merge, gd.abilityLearn)
        merge = table.merge(merge, gd.sacredUse)
        sv:save("PPP", table.concat(merge, '|'))
    elseif (key == "meKill" or key == "meDead" or key == "meDied" or key == "meDamage" or key == "meHurt" or key == "meE") then
        local merge = { gd.meKill, gd.meDead, gd.meDied, gd.meDamage, gd.meHurt }
        merge = table.merge(merge, gd.meE)
        sv:save("OOO", table.concat(merge, '|'))
    elseif (key == "fireLevel") then
        sv:save("DFR", data)
    elseif (key == "lastDead") then
        sv:save("KN", data)
    elseif (key == "achievement") then
        sv:save("PPPP", table.concat(data, ''))
    elseif (key == "soul") then
        sv:save("SSS", table.concat(data, ''))
    elseif (key == "abilityLevel") then
        sv:save("LULU", table.concat(data, ''))
    elseif (key == "sacredGet") then
        sv:save("SCGT", table.concat(data, ''))
    elseif (key == "sacredForge") then
        sv:save("SCFG", table.concat(data, ''))
    end
end
function class:soulRune(index)
    self:npcClear()
    self:enemiesClear()
    self:summonsClear()
    self:effectsClear()
    self:digClear()
    local gd = self:GD()
    if (index <= 4) then
        gd.erode = 0
        gd.sliceResult = table.repeater(0, 9)
        gd.sacredUpgrade = 0
        gd.abilityUpgrade = 0
        gd.upgradePoint = 0
        gd.upgradeStart = 0
        gd.upgradeAtk = 0
        gd.upgradeDef = 0
        gd.upgradeSpd = 0
        gd.abilityLearn = table.repeater(0, gd.abilityTail)
        gd.sacredUse = table.repeater(0, #Game():itemHotkey())
        gd.meAbilityFreak = 0
        Game():save("meAbilityFreak", gd.meAbilityFreak)
        gd.diff = index
        self:save("diff", gd.diff)
        async.call(gd.me:owner(), function()
            UI_NinegridsAnimate:blackHole(3)
            UI_NinegridsInfo:info("great", 3, "探探区：" .. TPL_SOUL_RUNE[index]:name())
        end)
        ProcessCurrent:next("looper")
    elseif (index == 5) then
        gd.sliceResult[5] = 0
        gd.diff = index
        self:save("diff", gd.diff)
        ProcessCurrent:next("slice_diff5_area5")
        async.call(gd.me:owner(), function()
            UI_NinegridsAnimate:blackHole(3)
            UI_NinegridsInfo:info("alert", 3, "我界：" .. TPL_SOUL_RUNE[index]:name())
        end)
    end
end
function class:achievementDo(index)
    local gd = self:GD()
    local rewardDo = TPL_ACHIEVEMENT[index]:prop("rewardDo")
    if (type(rewardDo) == "function") then
        rewardDo()
    end
end
function class:achievement(index, result)
    local gd = self:GD()
    if (result == nil) then
        return 1 == gd.achievement[index]
    elseif (result == true and gd.achievement[index] ~= 1) then
        gd.achievement[index] = 1
        self:save("achievement", gd.achievement)
        async.call(gd.me:owner(), function()
            UI_NinegridsInfo:info("great", 3, "完成成就：" .. TPL_ACHIEVEMENT[index]:name())
            UI_NinegridsAnimate:crystal(FrameButton("ninegrids_essence->achievement"), -0.03, 0)
            UI_NinegridsAnimate:see(FrameButton("ninegrids_essence->achievement"), -0.02, 0.013)
            audio(Vcm("war3_GoodJob"))
        end)
        self:achievementDo(index)
    end
end
function class:meSoulC(index)
    local gd = self:GD()
    local p = gd.me:owner()
    local isBan = false
    if (gd.me:isAbilityChantCasting() or gd.me:isAbilityKeepCasting()) then
        isBan = true
    end
    if (gd.me:isInterrupt()) then
        isBan = true
    end
    local buffBans = { "狂将形态", "侠客形态", "清醒梦游荡", "恶魔化身" }
    for _, b in ipairs(buffBans) do
        if (gd.me:buffHas(b)) then
            isBan = true
            break
        end
    end
    if (isBan) then
        async.call(p, function()
            UI_NinegridsInfo:info("alert", 3, "此时无法共鸣")
        end)
        return
    end
    local tpl = TPL_SOUL[index]
    local mt = tpl:moveType()
    if (mt ~= UNIT_MOVE_TYPE.amphibious) then
        if (false == terrain.isWalkable(gd.me:x(), gd.me:y())) then
            async.call(p, function()
                UI_NinegridsInfo:info("alert", 3, "地势克制，共鸣失败")
            end)
            return
        end
    end
    local cur = 0
    for j = 2, 5 do
        if (index == gd["meSoul" .. j]) then
            cur = j
            break
        end
    end
    if (cur > 0) then
        if (1 == gd.soul[gd.meSoul1]) then
            gd["meSoul" .. cur] = gd.meSoul1
        else
            gd["meSoul" .. cur] = 0
        end
    end
    gd.meSoul1 = index
    self:save("meSoul1", gd.meSoul1)
    local tplPrev = gd.me:tpl()
    local changeData = {}
    local changeKeys = {
        "modelScale", "scale", "stature", "attackPoint", "weaponLength", "weaponHeight",
        "hp", "mp", "attack", "defend", "move", "attackSpaceBase", "attackRange", "attackRipple",
        SYMBOL_MUT .. "hp",
        SYMBOL_MUT .. "attack",
        SYMBOL_MUT .. "attackSpeed",
        SYMBOL_MUT .. "defend",
        "crit", SYMBOL_ODD .. "crit",
        "stun", SYMBOL_ODD .. "stun",
        "hpRegen", "mpRegen", "shield",
        "attackSpeed", "avoid", "aim", "sight",
        "damageIncrease", "hurtReduction"
    }
    for _, k in ipairs(ENCHANT_TYPES) do
        table.insert(changeKeys, SYMBOL_E .. k)
        table.insert(changeKeys, SYMBOL_EI .. k)
        table.insert(changeKeys, SYMBOL_RES .. SYMBOL_E .. k)
    end
    for _, k in ipairs(changeKeys) do
        changeData[k] = (tpl:prop(k) or 0) - (tplPrev:prop(k) or 0)
    end
    gd.me:prop("sp", tpl:prop("sp"))
    gd.me:name(tpl:name())
    gd.me:icon(tpl:icon())
    gd.me:modelAlias(tpl:modelAlias())
    gd.me:material(tpl:material())
    gd.me:moveType(mt)
    gd.me:weaponSoundMode(tpl:weaponSoundMode())
    if (tpl:weaponSound() == nil) then
        gd.me:clear("weaponSound")
    else
        gd.me:weaponSound(tpl:weaponSound())
    end
    if (tpl:castAnimation() == nil) then
        gd.me:clear("castAnimation")
    else
        gd.me:castAnimation(tpl:castAnimation())
    end
    if (tpl:keepAnimation() == nil) then
        gd.me:clear("keepAnimation")
    else
        gd.me:keepAnimation(tpl:keepAnimation())
    end
    local eao = gd.me:prop("enchantMaterial")
    if (eao) then
        enchant.subtract(gd.me, eao, enchant._material)
        gd.me:clear("enchantMaterial")
    end
    gd.me:enchantMaterial(tpl:enchantMaterial())
    if (isClass(tplPrev:attackMode(), AttackModeClass)) then
        gd.me:attackModeRemove(tplPrev:attackMode():id())
    end
    if (isClass(tpl:attackMode(), AttackModeClass)) then
        gd.me:attackModePush(tpl:attackMode())
    end
    for _, k in ipairs(changeKeys) do
        if (changeData[k] > 0) then
            gd.me:prop(k, "+=" .. changeData[k])
        elseif (changeData[k] < 0) then
            gd.me:prop(k, "-=" .. math.abs(changeData[k]))
        end
    end
    gd.me:prop("tpl", tpl)
    gd.me:speechAlias(tpl:speechAlias())
    async.call(p, function()
        UI_NinegridsInfo:info("great", 3, "与英泠 " .. colour.hex(colour.gold, TPL_SOUL[gd.meSoul1]:name()) .. " 共鸣了")
        audio(Vcm("war3_GoodJob"))
        UI_NinegridsInfo:updated()
        UIKit("ninegrids_detail"):stage().main:show(false)
    end)
end
function class:meSoulF(index, fn)
    local gd = self:GD()
    local p = gd.me:owner()
    local fi = "meSoul" .. fn
    local cur = 0
    local swap = gd[fi]
    if (swap > 0) then
        for j = 2, 5 do
            if (index == gd["meSoul" .. j]) then
                cur = j
                break
            end
        end
        gd["meSoul" .. cur] = swap
    end
    gd[fi] = index
    self:save(fi, gd[fi])
    async.call(p, function()
        UI_NinegridsInfo:info("great", 3, "备用英泠 " .. colour.hex(colour.gold, TPL_SOUL[gd[fi]]:name()) .. " 已设定")
        audio(Vcm("war3_GoodJob"))
        UI_NinegridsInfo:updated()
    end)
end
function class:soul(index, result)
    local gd = self:GD()
    if (result == nil) then
        return 1 == gd.soul[index]
    elseif (result == true) then
        gd.soul[index] = 1
        self:save("soul", gd.soul)
        async.call(gd.me:owner(), function()
            UI_NinegridsInfo:info("great", 3, "获得英泠：" .. TPL_SOUL[index]:name())
            UI_NinegridsAnimate:crystal(FrameButton("ninegrids_essence->soul"), -0.03, 0)
            UI_NinegridsAnimate:see(FrameButton("ninegrids_essence->soul"), -0.02, 0.013)
            audio(Vcm("war3_GoodJob"))
        end)
        if (self:achievement(11) ~= true) then
            local a = 0
            for i = 1, #TPL_SOUL do
                if (gd.soul[i] == 1) then
                    a = a + 1
                end
            end
            if (a == #TPL_SOUL) then
                self:achievement(11, true)
            end
        end
    end
end
function class:learnArrow(id, obj)
    local a = self:prop("learnArrow")
    if (a == nil) then
        a = {}
        self:prop("learnArrow", a)
    end
    if (nil == id) then
        return
    end
    if (nil == obj) then
        return a[id]
    end
    a[id] = obj
    obj:onEvent(EVENT.Object.Destruct, "arrow_", function(destructData)
        if (destructData.triggerAbility) then
            a[destructData.triggerAbility:tpl():id()] = nil
        elseif (destructData.triggerItem) then
            a[destructData.triggerItem:tpl():id()] = nil
        end
    end)
end
function class:abilityFreakPush(index, isInit)
    local gd = self:GD()
    local tpl = TPL_ABILITY_FREAK[index]
    if (isClass(tpl, AbilityTplClass)) then
        local slot = gd.me:abilitySlot()
        local s = slot:storage()[6]
        local p = gd.me:owner()
        if (s ~= nil) then
            async.call(p, function()
                UI_NinegridsInfo:info("error", 3, "无法重复学习奇异魔技")
            end)
            return
        end
        local ab = self:learnArrow(tpl:id())
        if (ab == nil) then
            ab = Ability(tpl)
            self:learnArrow(tpl:id(), ab)
        end
        ab:level(1)
        slot:insert(ab, 6)
        if (isInit ~= true) then
            async.call(p, function()
                UI_NinegridsInfo:info("info", 3, "奇异魔技 " .. colour.hex(colour.mediumpurple, tpl:name()) .. " 已学习")
                audio(Vcm("war3_Tomes"))
            end)
            self:save("meAbilityFreak", index)
        end
    end
end
function class:fireRemove(index)
    local gd = self:GD()
    local p = gd.me:owner()
    index = math.round(index / 100)
    local tpl = TPL_ABILITY_FIRE[index]
    must(nil ~= tpl)
    if (isClass(tpl, AbilityTplClass)) then
        local slot = gd.me:abilitySlot()
        local idx = slot:index(tpl)
        if (idx ~= -1) then
            slot:remove(idx)
            async.call(p, function()
                UI_NinegridsInfo:info("info", 3, "火焰山技 " .. colour.hex(colour.gold, tpl:name()) .. " 已忘记")
                audio(Vcm("war3_MouseClick2"))
            end)
            self:save("abilityLearn")
        end
    end
end
function class:firePush(index, slotIndex, isInit)
    local gd = self:GD()
    local p = gd.me:owner()
    index = math.round(index / 100)
    local tpl = TPL_ABILITY_FIRE[index]
    if (tpl ~= nil) then
        if (isClass(tpl, AbilityTplClass)) then
            local slot = gd.me:abilitySlot()
            local idx = slot:index(tpl)
            local empty = 0
            local storage = slot:storage()
            for i = 1, gd.abilityTail, 1 do
                if (false == isClass(storage[i], AbilityClass)) then
                    empty = empty + 1
                end
            end
            if (idx == -1 and empty == 0) then
                if (isInit ~= true) then
                    async.call(p, function()
                        UI_NinegridsInfo:info("error", 3, "技能栏已满，请替换技能")
                    end)
                end
                return
            end
            local ab = self:learnArrow(tpl:id())
            if (ab == nil) then
                ab = Ability(tpl)
                self:learnArrow(tpl:id(), ab)
            end
            ab:level(1)
            if (idx ~= -1) then
                slot:remove(idx)
                slot:insert(ab, idx)
            else
                if (type(slotIndex) == "number" and slot[slotIndex] ~= nil) then
                    slot:remove(slotIndex)
                end
                slot:insert(ab, slotIndex)
            end
            if (isInit ~= true) then
                async.call(p, function()
                    UI_NinegridsInfo:info("info", 3, "火焰山技 " .. colour.hex(colour.gold, tpl:name()) .. " 已学习")
                    audio(Vcm("war3_Tomes"))
                end)
                self:save("abilityLearn")
            end
        end
    end
end
function class:abilityLevelUpWorth(index, abLv)
    local gd = self:GD()
    local tpl = TPL_ABILITY_SOUL[index]
    must(isClass(tpl, AbilityTplClass))
    local wor = { copper = (4500 + (index - 1) * 2500) }
    return self:worthCale(wor, "*", (1 + (abLv - 1) * 2) * gd.abilityDiscount)
end
function class:abilityLvUp(index)
    local gd = self:GD()
    local p = gd.me:owner()
    local tpl = TPL_ABILITY_SOUL[index]
    if (isClass(tpl, AbilityTplClass)) then
        local abLv = gd.abilityLevel[index]
        if (abLv >= gd.abilityMaxLv) then
            async.call(p, function()
                UI_NinegridsInfo:info("error", 3, "泠技已无法继续升级")
            end)
            return
        end
        p:worth("-", self:abilityLevelUpWorth(index, abLv))
        async.call(p, function()
            UI_NinegridsAnimate:levelup(UIKit("ninegrids_essence"):stage().essenceConfirmB2, 0, 0.1)
            UI_NinegridsInfo:info("info", 3, "泠技 " .. colour.hex(colour.gold, tpl:name()) .. " 升级成功")
        end)
        gd.abilityLevel[index] = abLv + 1
        self:save("abilityLevel", gd.abilityLevel)
        local ab = self:learnArrow(tpl:id())
        if (isClass(ab, AbilityClass)) then
            ab:level(gd.abilityLevel[index] + gd.abilityUpgrade)
        end
    end
end
function class:abilityRemove(index)
    local gd = self:GD()
    local p = gd.me:owner()
    local tpl = TPL_ABILITY_SOUL[index]
    if (isClass(tpl, AbilityTplClass)) then
        local slot = gd.me:abilitySlot()
        local idx = slot:index(tpl)
        if (idx ~= -1) then
            slot:remove(idx)
            async.call(p, function()
                UI_NinegridsInfo:info("info", 3, "泠技 " .. colour.hex(colour.gold, tpl:name()) .. " 已忘记")
                audio(Vcm("war3_MouseClick2"))
            end)
            self:save("abilityLearn")
        end
    end
end
function class:abilityPush(index, slotIndex, isInit)
    local gd = self:GD()
    local p = gd.me:owner()
    local tpl = TPL_ABILITY_SOUL[index]
    if (isClass(tpl, AbilityTplClass)) then
        local slot = gd.me:abilitySlot()
        local idx = slot:index(tpl)
        local empty = 0
        local storage = slot:storage()
        for i = 1, gd.abilityTail, 1 do
            if (false == isClass(storage[i], AbilityClass)) then
                empty = empty + 1
            end
        end
        if (idx == -1 and empty == 0) then
            if (isInit ~= true) then
                async.call(p, function()
                    UI_NinegridsInfo:info("error", 3, "技能栏已满，请替换技能")
                end)
            end
            return
        end
        local lv = gd.abilityLevel[index] + gd.abilityUpgrade
        local ab = self:learnArrow(tpl:id())
        if (ab == nil) then
            ab = Ability(tpl)
            self:learnArrow(tpl:id(), ab)
        end
        ab:level(lv)
        if (idx ~= -1) then
            slot:remove(idx)
            slot:insert(ab, idx)
        else
            if (type(slotIndex) == "number" and slot[slotIndex] ~= nil) then
                slot:remove(slotIndex)
            end
            slot:insert(ab, slotIndex)
        end
        if (isInit ~= true) then
            async.call(p, function()
                UI_NinegridsInfo:info("info", 3, "泠技 " .. colour.hex(colour.gold, tpl:name()) .. " 已学习")
                audio(Vcm("war3_Tomes"))
            end)
            self:save("abilityLearn")
        end
    end
end
function class:sacredRemove(index)
    local gd = self:GD()
    must(nil ~= gd.sacredGet[index])
    local tpl = TPL_SACRED[index]
    if (isClass(tpl, ItemTplClass)) then
        local slot = gd.me:itemSlot()
        local idx = slot:index(tpl)
        if (idx ~= -1) then
            slot:remove(idx)
            async.call(gd.me:owner(), function()
                UI_NinegridsInfo:info("info", 3, "泠器 " .. colour.hex(colour.gold, tpl:name()) .. " 已卸下")
                audio(Vcm("war3_HeroDropItem1"))
            end)
            self:save("sacredUse")
        end
    end
end
function class:sacredPush(index, slotIndex, isInit)
    local gd = self:GD()
    local p = gd.me:owner()
    local tpl = TPL_SACRED[index]
    if (isClass(tpl, ItemTplClass)) then
        local slot = gd.me:itemSlot()
        local idx = slot:index(tpl)
        if (idx == -1 and slot:empty() == 0) then
            if (isInit ~= true) then
                async.call(p, function()
                    UI_NinegridsInfo:info("error", 3, "泠器栏已满，请先卸下其他泠器")
                end)
            end
            return
        end
        local lv = gd.sacredForge[index] + gd.sacredUpgrade
        local it = self:learnArrow(tpl:id())
        if (it == nil) then
            it = Item(tpl)
            self:learnArrow(tpl:id(), it)
        end
        it:level(lv)
        it:attributes(tpl:prop("forgeList")[lv])
        if (idx ~= -1) then
            slot:remove(idx)
            slot:insert(it, idx)
        else
            if (type(slotIndex) == "number" and slot[slotIndex] ~= nil) then
                slot:remove(slotIndex)
            end
            slot:insert(it, slotIndex)
        end
        if (isInit ~= true) then
            async.call(p, function()
                UI_NinegridsInfo:info("info", 3, "泠器 " .. colour.hex(colour.gold, tpl:name()) .. " 已装备")
                audio(Vcm("war3_PickUpItem"))
            end)
            self:save("sacredUse")
        end
    end
end
function class:sacredForgeOdds(index, fgLv)
    local m = 1 + fgLv + 3 * (fgLv - 1) + math.max(0, index / 10 - 1)
    local fail = 1 - 1 / m
    local exOdds = self:GD().sacredOdds
    if (self:achievement(12) == true) then
        exOdds = exOdds + self:GD().sacredForgeFail * 0.4
    end
    return math.min(100, 100 * (1 - fail) + exOdds)
end
function class:sacredForgeWorth(index, fgLv)
    local gd = self:GD()
    local wor = { copper = (2500 + (index - 1) * 1300) }
    return self:worthCale(wor, "*", (1 + (fgLv - 1) * 0.8) * gd.sacredDiscount)
end
function class:sacredForgeFail(value)
    if (value >= 30) then
        if (self:achievement(12) == false) then
            self:achievement(12, true)
        end
    end
    self:GD().sacredForgeFail = value
end
function class:sacredForge(index)
    local gd = self:GD()
    local p = gd.me:owner()
    local tpl = TPL_SACRED[index]
    if (isClass(tpl, ItemTplClass)) then
        local fgLv = gd.sacredForge[index]
        if (fgLv >= gd.sacredMaxLv) then
            async.call(p, function()
                UI_NinegridsInfo:info("error", 3, "泠器已无法继续精炼")
            end)
            return
        end
        p:worth("-", self:sacredForgeWorth(index, fgLv))
        local odds = 100 * self:sacredForgeOdds(index, fgLv)
        local rand = math.rand(1, 10000)
        if (odds > rand) then
            self:sacredForgeFail(0)
            async.call(p, function()
                UI_NinegridsAnimate:forge(UIKit("ninegrids_essence"):stage().essenceConfirmB2, 0, 0.1)
                UI_NinegridsInfo:info("info", 3, "泠器 " .. colour.hex(colour.gold, tpl:name()) .. " 精炼成功")
            end)
            gd.sacredForge[index] = fgLv + 1
            self:save("sacredForge", gd.sacredForge)
            local it = self:learnArrow(tpl:id())
            if (isClass(it, ItemClass)) then
                local lv = gd.sacredForge[index] + gd.sacredUpgrade
                it:level(lv)
                it:attributes(tpl:prop("forgeList")[lv])
            end
        else
            self:sacredForgeFail(gd.sacredForgeFail + 1)
            async.call(p, function()
                audio(Vcm("war3_CreepAggroWhat1"))
                UI_NinegridsInfo:info("alert", 3, "泠器 " .. colour.hex(colour.gold, tpl:name()) .. " 精炼失败")
            end)
        end
    end
end
function class:sacredForge10(index)
    local gd = self:GD()
    local p = gd.me:owner()
    local tpl = TPL_SACRED[index]
    if (isClass(tpl, ItemTplClass)) then
        local fgLv = gd.sacredForge[index]
        if (gd.sacredForge[index] >= gd.sacredMaxLv) then
            async.call(p, function()
                UI_NinegridsInfo:info("error", 3, "泠器已无法继续精炼")
            end)
            return
        end
        local j = 0
        for i = 1, 10 do
            local wor = self:sacredForgeWorth(index, gd.sacredForge[index])
            if (self:worthLess(p:worth(), wor)) then
                break
            end
            j = i
            p:worth("-", self:sacredForgeWorth(index, gd.sacredForge[index]))
            local odds = 100 * self:sacredForgeOdds(index, gd.sacredForge[index])
            local rand = math.rand(1, 10000)
            if (odds > rand) then
                self:sacredForgeFail(0)
                gd.sacredForge[index] = gd.sacredForge[index] + 1
                if (gd.sacredForge[index] >= gd.sacredMaxLv) then
                    break
                end
            else
                self:sacredForgeFail(gd.sacredForgeFail + 1)
            end
        end
        if (gd.sacredForge[index] > fgLv) then
            async.call(p, function()
                UI_NinegridsAnimate:forge(UIKit("ninegrids_essence"):stage().essenceConfirmB2, 0, 0.1)
                UI_NinegridsInfo:info("info", 3, "泠器 " .. colour.hex(colour.gold, tpl:name())
                    .. " 精炼成功：" .. colour.hex(colour.gold, "Lv " .. fgLv .. "->" .. gd.sacredForge[index]))
            end)
            self:save("sacredForge", gd.sacredForge)
            local it = self:learnArrow(tpl:id())
            if (isClass(it, ItemClass)) then
                local lv = gd.sacredForge[index] + gd.sacredUpgrade
                it:level(lv)
                it:attributes(tpl:prop("forgeList")[lv])
            end
        else
            async.call(p, function()
                audio(Vcm("war3_CreepAggroWhat1"))
                UI_NinegridsInfo:info("alert", 3, "泠器 " .. colour.hex(colour.gold, tpl:name()) .. " 精炼10连失败")
            end)
        end
    end
end
function class:sacred(index, result)
    local gd = self:GD()
    if (result == nil) then
        return 1 == gd.sacredGet[index]
    elseif (result == true and gd.sacredGet[index] ~= 1) then
        gd.sacredGet[index] = 1
        gd.sacredForge[index] = 1
        self:save("sacredGet", gd.sacredGet)
        self:save("sacredForge", gd.sacredForge)
        async.call(gd.me:owner(), function()
            UI_NinegridsInfo:info("great", 3, "获得泠器：" .. TPL_SACRED[index]:name())
            UI_NinegridsAnimate:crystal(FrameButton("ninegrids_essence->sacred"), -0.03, 0)
            UI_NinegridsAnimate:item(FrameButton("ninegrids_essence->sacred"), -0.02, 0.013)
            audio(Vcm("war3_GoodJob"))
        end)
    end
end
function class:weatherDo(index)
    sync.must()
    local gd = self:GD()
    local wt = TPL_WEATHER[index]:prop("weatherType")
    if (type(wt) == "table") then
        RegionWorld:weather(wt, true)
    end
    local t = self:prop("weatherTimer")
    if (isClass(t, TimerClass)) then
        destroy(t)
        self:clear("weatherTimer")
    end
    local wd = TPL_WEATHER[index]:prop("weatherDo")
    if (type(wd) == "function") then
        local itv = TPL_WEATHER[index]:prop("weatherInterval") * (200 - math.min(100, gd.erode)) / 200
        t = time.setInterval(itv, function(curTimer)
            if (isClass(gd.me, UnitClass) == false or isDestroy(gd.me)) then
                destroy(curTimer)
                self:clear("weatherTimer")
                return
            end
            wd(Group():rand(UnitClass, {
                circle = {
                    x = gd.me:x(),
                    y = gd.me:y(),
                    radius = 1000,
                },
                filter = function(enumUnit)
                    return enumUnit:isAlive() and enumUnit:owner():isNeutral() == false
                end
            }, 4))
        end)
        self:prop("weatherTimer", t)
    end
end
function class:weather(index)
    local gd = self:GD()
    RegionWorld:weather(nil, false)
    gd.weather = index
    self:save("weather", gd.weather)
    async.call(gd.me:owner(), function()
        UI_NinegridsInfo:info("great", 3, "气候：" .. TPL_WEATHER[index]:name())
        UI_NinegridsInfo:updated()
    end)
    self:weatherDo(index)
end
function class:isWeather(typ)
    local w = self:GD().weather
    if (typ == "sun") then
        return w == 2
    elseif (typ == "moon") then
        return w == 3
    elseif (typ == "wind") then
        return w == 4
    elseif (typ == "rain") then
        return w == 5 or w == 6
    elseif (typ == "rainStorm") then
        return w == 6
    elseif (typ == "snow") then
        return w == 7 or w == 8
    elseif (typ == "fogWhite") then
        return w == 9
    elseif (typ == "fogPoison") then
        return w == 10
    end
    return false
end
function class:erode(addLevel)
    addLevel = math.floor(addLevel)
    if (addLevel > 0) then
        local gd = self:GD()
        local nextLevel = gd.erode + addLevel
        if (nextLevel >= 150 and self:achievement(10) ~= true) then
            self:achievement(10, true)
        end
        async.call(gd.me:owner(), function()
            UI_NinegridsInfo:info("alert", 3, "侵蚀程度 " .. gd.erode .. ' -> ' .. colour.hex(colour.red, nextLevel))
        end)
        gd.erode = nextLevel
        async.call(gd.me:owner(), function()
            UI_NinegridsInfo:updated()
        end)
    end
end
function class:erodeCell()
    local d = math.min(4, self:GD().diff)
    return 7 + math.floor(d * 4)
end
function class:abilityUpLv(value)
    local gd = self:GD()
    gd.abilityUpgrade = gd.abilityUpgrade + value
    local me = gd.me
    if (isClass(me, UnitClass) and me:isAlive()) then
        local storage = me:abilitySlot():storage()
        for i = 1, gd.abilityTail, 1 do
            local ab = storage[i]
            if (isClass(ab, AbilityClass)) then
                ab:level("+=" .. value)
            end
        end
    end
end
function class:sacredUpLv(value)
    local gd = self:GD()
    gd.sacredUpgrade = gd.sacredUpgrade + value
    local me = gd.me
    if (isClass(me, UnitClass) and me:isAlive()) then
        local storage = me:itemSlot():storage()
        for i = 1, 6, 1 do
            local it = storage[i]
            if (isClass(it, ItemClass)) then
                local lv = it:level() + value
                it:level(lv):attributes(it:prop("forgeList")[lv])
            end
        end
    end
end
function class:upgradePoint(value)
    local gd = self:GD()
    if (gd.upgradeStart ~= -1) then
        if (gd.upgradePoint == 0 and gd.upgradeDef == 0 and gd.upgradeAtk == 0 and gd.upgradeSpd == 0) then
            gd.upgradeStart = gd.upgradeStart + value
        end
    elseif (gd.upgradeStart == -1) then
        gd.upgradePoint = gd.upgradePoint + value
        self:save("upgradePoint")
        async.call(gd.me:owner(), function()
            UI_NinegridsAnimate:see(FrameButton("ninegrids_info->levels"), -0.04, 0.003)
        end)
    end
end
function class:upgradeDo(typ)
    local gd = self:GD()
    local lv = 0
    if (typ == "atk") then
        lv = gd.upgradeAtk
    elseif (typ == "def") then
        lv = gd.upgradeDef
    elseif (typ == "spd") then
        lv = gd.upgradeSpd
    end
    if (lv > 0) then
        local attr = UPGRADE_ATTR(typ, lv)
        local me = gd.me
        if (isClass(me, UnitClass)) then
            local bk = "upgradeDo_" .. typ
            if (me:buffHas(bk)) then
                me:buffClear({ key = bk })
            end
            me:buff(bk)
              :duration(-1)
              :visible(false)
              :purpose(
                function(buffObj)
                    for _, a in ipairs(attr) do
                        buffObj:prop(a[1], "+=" .. a[2])
                    end
                end)
              :rollback(
                function(buffObj)
                    for _, a in ipairs(attr) do
                        buffObj:prop(a[1], "-=" .. a[2])
                    end
                end)
              :run()
        end
    end
end
function class:upgrade(typ, diff)
    must(diff > 0)
    local gd = self:GD()
    if (gd.upgradePoint < diff) then
        return
    end
    if (typ == "atk" or typ == "def" or typ == "spd") then
        gd.upgradePoint = gd.upgradePoint - diff
        if (typ == "atk") then
            gd.upgradeAtk = gd.upgradeAtk + diff
        elseif (typ == "def") then
            gd.upgradeDef = gd.upgradeDef + diff
        elseif (typ == "spd") then
            gd.upgradeSpd = gd.upgradeSpd + diff
        end
        local name = { def = "守", atk = "攻", spd = "疾" }
        local idx = { def = 1, atk = 2, spd = 3 }
        local p = gd.me:owner()
        async.call(p, function()
            UI_NinegridsAnimate:levelup(UI_NinegridsUpgrade:stage().confirmBtn[idx[typ]], 0, 0.1)
            UI_NinegridsInfo:info("info", 3, colour.hex(colour.gold, name[typ]) .. " 已加" .. diff)
        end)
        self:upgradeDo(typ)
        self:save("upgradePoint")
    end
end
function class:fireLevel()
    local gd = self:GD()
    local p = gd.me:owner()
    if (gd.fireLevel < 9) then
        local gv = gd.fireLevel + 1
        p:award({ gold = gv })
        local nextLevel = gd.fireLevel + 1
        async.call(p, function()
            UI_NinegridsInfo:info("great", 5, "焱至挑战 Lv " .. gd.fireLevel .. ' -> ' .. colour.hex(colour.red, nextLevel) .. "|n奖励 "
                .. colour.hex(colour.gold, "3点能力点")
                .. " 和 "
                .. colour.hex(colour.gold, gv) .. " 金币")
            UI_NinegridsInfo:updated()
        end)
        gd.fireLevel = nextLevel
        self:upgradePoint(3)
        self:save("fireLevel", nextLevel)
    else
        p:award({ silver = 99 })
        async.call(p, function()
            UI_NinegridsInfo:info("great", 5, "焱至挑战已满级 Lv " .. colour.gold(9) .. "|n奖励 " .. colour.hex(colour.silver, 99) .. " 银币")
        end)
        self:save("fireLevel", 9)
    end
end
function class:sliceIndex(idx)
    sync.must()
    must(idx >= 1 and idx <= 9)
    self:GD().sliceIndex = idx
    self:save("sliceIndex", idx)
end
function class:blight(modify)
    self:prop("blight", modify)
end
function class:bossSpell(ab)
    if (isClass(ab, AbilityClass)) then
        local tt = ab:targetType()
        if (tt ~= ABILITY_TARGET_TYPE.pas) then
            ab:onUnitEvent(EVENT.Unit.Attack, "bossSpell", function(atkData)
                local evtData = {}
                if (tt == ABILITY_TARGET_TYPE.tag_loc) then
                    local tx, ty = atkData.targetUnit:x(), atkData.targetUnit:y()
                    evtData.targetX = tx
                    evtData.targetY = ty
                    evtData.targetZ = japi.Z(tx, ty)
                elseif (tt == ABILITY_TARGET_TYPE.tag_unit) then
                    evtData.targetUnit = atkData.targetUnit
                else
                    evtData.targetX = atkData.targetUnit:x()
                    evtData.targetY = atkData.targetUnit:y()
                    evtData.targetZ = atkData.targetUnit:z()
                end
                atkData.triggerAbility:effective(evtData)
            end)
        end
    end
end
function class:bossSacredDrop(whichBoss)
    must(isClass(whichBoss, UnitClass))
    local x, y = whichBoss:x(), whichBoss:y()
    local slot = whichBoss:itemSlot()
    if (isClass(slot, ItemSlotClass)) then
        local ss = slot:storage()
        for i = 1, slot:volume(), 1 do
            local it = ss[i]
            if (isClass(it, ItemClass)) then
                if (math.rand(1, 100) <= 33) then
                    local idx = it:prop("idx")
                    if (idx > 40 and self:sacred(idx) == false) then
                        local px, py = vector2.polar(x, y, math.rand(0, 100), math.rand(0, 359))
                        it:position(px, py)
                        effector("eff/FantasyCircles", px, py, 1.5)
                        it:superposition("locust", "+=1")
                        time.setTimeout(1, function()
                            destroy(it)
                            self:sacred(idx, true)
                        end)
                    end
                end
            end
        end
    end
end
function class:bossBgmBattle(volume)
    self:prop("prevBgmVol", Bgm():volume())
    self:prop("prevBgmMusic", Bgm():currentMusic())
    Bgm():volume(volume):play("lik")
end
function class:bossBgmCrazy(boss, path)
    if (boss:prop("bossCrazy")) then
        return
    end
    boss:prop("bossCrazy", true)
    Bgm():volume(90):play(path)
    audio(Vcm("bossCrazy"))
    async.call(PlayerLocal(), function()
        UI_NinegridsInfo:info("alert", 2, "Boss进入狂暴状态")
    end)
    boss:superposition("invulnerable", "+=1")
    boss:superposition("pause", "+=1")
    local bi = 0
    boss:attach("eff/BloodBoneDance", "origin")
    Game():xTimer(true, 0.5, function(curTimer)
        bi = bi + 1
        boss:animate("attack")
        boss:effect("eff/Bloody2", 1)
        if (bi > 7) then
            destroy(curTimer)
            boss:superposition("invulnerable", "-=1")
            boss:superposition("pause", "-=1")
            boss:detach("eff/BloodBoneDance", "origin")
        end
    end)
end
function class:bossBgmRollback()
    local vol = self:prop("prevBgmVol")
    local music = self:prop("prevBgmMusic")
    Bgm():volume(vol):play(music)
end
function class:bossBorn()
    self:npcClear()
    self:bossBgmBattle(80)
    local gd = self:GD()
    async.call(gd.me:owner(), function()
        UI_NinegridsInfo:boss()
    end)
    local diff = math.round(gd.diff)
    local sliceIndex = gd.sliceIndex
    local x, y, facing = table.unpack(BOSS_COORDINATE[diff][sliceIndex])
    local bossIndex = 8 * diff + sliceIndex
    local itemIndex = 8 * (diff - 1) + sliceIndex
    if (sliceIndex > 5) then
        bossIndex = bossIndex - 1
        itemIndex = itemIndex - 1
    end
    local boss = self:enemies(TPL_SOUL[bossIndex], x, y, facing)
    boss:level(diff * 10 + gd.erode)
    boss:barStateMode(4)
    boss:modelScale("*=1.3")
    boss:scale("*=1.3")
    boss:weaponHeight("*=1.3")
    boss:weaponLength("*=1.3")
    boss:stature("*=2")
    boss:castChant("+=" .. (3 - diff * 0.3))
    boss:elite(true)
    boss:iconMap(AUIKit("ninegrids_minimap", "dot/boss", "tga"), 0.04, 0.04)
    boss:alerter(true)
    local tp = boss:tpl()
    local ix = tp:prop("idx")
    local lv = 3 + diff
    local ab = Ability(TPL_ABILITY_SOUL[ix])
    boss:abilitySlot():tail(6)
    boss:abilitySlot():insert(ab)
    ab:level(lv)
    ab:bossConv()
    boss:abilitySlot():insert(TPL_ABILITY_BOSS["界泠恶堕"], 6)
    local abTPLs = TPL_ABILITY_BOSS[boss:name()]
    if (type(abTPLs) == "table") then
        for _, v in ipairs(abTPLs) do
            if (isClass(v, AbilityTplClass)) then
                ab = Ability(v)
            end
            if (isClass(ab, AbilityClass)) then
                boss:abilitySlot():insert(ab)
                ab:bossConv()
            end
        end
    end
    local itTPLs = table.merge({ TPL_SACRED[ix] }, BOSS_ITEMS[itemIndex])
    for k, v in ipairs(itTPLs) do
        local it
        if (isClass(v, ItemTplClass)) then
            it = Item(v)
        end
        if (isClass(it, ItemClass)) then
            if (k == 1) then
                it:level(lv + 1):attributes(it:prop("forgeList")[lv + 1])
            else
                it:level(lv - 1):attributes(it:prop("forgeList")[lv - 1])
            end
            self:bossSpell(it:ability())
            boss:itemSlot():insert(it)
        end
    end
    AI("hate"):link(boss)
    boss:onEvent(EVENT.Unit.Dead, function(deadData)
        self:bossBgmRollback()
        local u = deadData.triggerUnit
        local dx, dy = u:x(), u:y()
        local killer = deadData.sourceUnit:owner()
        local tpl = u:tpl()
        local idx = tpl:prop("idx")
        if (idx >= 9 and idx <= 40) then
            if (gd.soul[idx] ~= 1) then
                self:soul(idx, true)
            end
            if (gd.sacredGet[idx] ~= 1) then
                self:sacred(idx, true)
            end
        end
        gd.sliceResult[sliceIndex] = 1
        if (bossIndex == 15 or bossIndex == 20 or bossIndex == 29 or bossIndex == 33) then
            if (bossIndex == 15) then
                if (self:achievement(21) ~= true) then
                    self:achievement(21, true)
                end
            elseif (bossIndex == 20) then
                if (self:achievement(22) ~= true) then
                    self:achievement(22, true)
                end
            elseif (bossIndex == 29) then
                if (self:achievement(23) ~= true) then
                    self:achievement(23, true)
                end
            elseif (bossIndex == 33) then
                if (self:achievement(24) ~= true) then
                    self:achievement(24, true)
                end
            end
        end
        self:erode(self:erodeCell())
        if (gd.diffMax <= diff) then
            self:upgradePoint(math.round(2 + diff))
        end
        async.call(killer, function()
            UI_NinegridsInfo:info("great", 7, "成功超度【" .. colour.hex(colour.red, u:name()) .. "】")
        end)
        local n = math.rand(1, 2 + diff)
        for _ = 1, n do
            autoItemCreate("小金币", dx + math.rand(-128, 128), dy + math.rand(-128, 128), 60)
        end
        self:bossSacredDrop(u)
        self:enemiesClear()
        self:allysClear()
        self:summonsClear()
        self:xTimerClear()
        self:effectsClear()
        for f = 1, 5, 1 do
            time.setTimeout(0.08 * f, function()
                local dx2, dy2 = vector2.polar(dx, dy, math.rand(0, 200), math.rand(0, 359))
                Effect("UndeadDissipate", dx2, dy2, japi.Z(dx2, dy2), 2):size(1)
            end)
        end
        ProcessCurrent:next("slice_diff" .. diff .. "_area" .. gd.sliceIndex .. "_K")
    end)
    return boss
end
function class:bigBossBorn()
    self:npcClear()
    local gd = self:GD()
    local diff = math.round(gd.diff)
    local boss = self:enemies(TPL_UNIT["BOSS_" .. diff], 0, 0, 270)
    boss:barStateMarker(1000)
    if (diff <= 4) then
        boss:level(diff * 25 + gd.erode)
    else
        boss:level(500 + 25 * gd.lastDead)
    end
    boss:barStateMode(4)
    boss:castChant("+=" .. (3 - diff * 0.4))
    boss:elite(true)
    boss:iconMap(AUIKit("ninegrids_minimap", "dot/boss", "tga"), 0.05, 0.05)
    boss:alerter(true)
    local lv = 5 + diff
    boss:abilitySlot():tail(6)
    if (diff <= 4) then
        local ab = Ability(TPL_ABILITY_SOUL[(40 + diff)])
        boss:abilitySlot():insert(ab)
        ab:level(lv)
        ab:bossConv()
        boss:abilitySlot():insert(TPL_ABILITY_BOSS["界泠深渊"], 6)
    else
        boss:abilitySlot():insert(TPL_ABILITY_BOSS["无我无妄"], 6)
    end
    local abTPLs = TPL_ABILITY_BOSS[boss:name()]
    if (type(abTPLs) == "table") then
        for _, v in ipairs(abTPLs) do
            if (isClass(v, AbilityTplClass)) then
                local ab = Ability(v)
                if (isClass(ab, AbilityClass)) then
                    boss:abilitySlot():insert(ab)
                    ab:bossConv()
                end
            end
        end
    end
    local diff5Sets = table.section(41, 48)
    if (diff >= 5) then
        local abs = table.rand(diff5Sets, 4)
        for _, v in ipairs(abs) do
            local ab = Ability(TPL_ABILITY_SOUL[v])
            if (isClass(ab, AbilityClass)) then
                local lvMax = ab:levelMax()
                ab:level(lvMax)
                boss:abilitySlot():insert(ab)
                ab:bossConv()
            end
        end
    end
    if (diff <= 4) then
        for _, v in ipairs(BOSS_BIG_ITEMS[diff]) do
            local it
            if (isClass(v, ItemTplClass)) then
                it = Item(v)
            end
            if (isClass(it, ItemClass)) then
                it:level(lv - 1):attributes(it:prop("forgeList")[lv - 1])
                self:bossSpell(it:ability())
                boss:itemSlot():insert(it)
            end
        end
    else
        local items = table.rand(diff5Sets, 6)
        for _, v in ipairs(items) do
            local it = Item(TPL_SACRED[v])
            if (isClass(it, ItemClass)) then
                local lvMax = it:levelMax()
                it:level(lvMax):attributes(it:prop("forgeList")[lvMax])
                self:bossSpell(it:ability())
                boss:itemSlot():insert(it)
            end
        end
    end
    AI("hate"):link(boss)
    local fm = FogModifier(Player(1), "BOSS视野")
    fm:position(0, 0)
    fm:radius(2000)
    fm:enable(true)
    boss:onEvent(EVENT.Unit.Dead, function(deadData)
        destroy(fm)
        self:bossBgmRollback()
        local u = deadData.triggerUnit
        local dx, dy = u:x(), u:y()
        local killer = deadData.sourceUnit:owner()
        gd.sliceResult[5] = 1
        async.call(killer, function()
            UI_NinegridsInfo:info("great", 7, "成功超度界主【" .. colour.hex(colour.red, u:name()) .. "】")
        end)
        local n = 3 + math.rand(diff, diff * 3)
        local nd = 0
        if (math.abs(dx) < 100 and math.abs(dy) < 100) then
            nd = 128
        end
        for _ = 1, n do
            local tx, ty = vector2.polar(dx, dy, nd + math.rand(0, 256), math.rand(0, 359))
            autoItemCreate("大金币", tx, ty, 60)
        end
        self:bossSacredDrop(u)
        self:achievement(diff, true)
        if (diff <= 4 and gd.diffMax <= diff) then
            gd.diffMax = diff + 1
            self:save("diffMax", gd.diffMax)
        end
        if (diff == 5) then
            gd.lastDead = gd.lastDead + 1
            self:save("lastDead", gd.lastDead)
        end
        self:enemiesClear()
        self:allysClear()
        self:summonsClear()
        self:xTimerClear()
        self:effectsClear()
        for f = 1, 7, 1 do
            time.setTimeout(0.08 * f, function()
                local dx2, dy2 = vector2.polar(dx, dy, math.rand(0, 300), math.rand(0, 359))
                Effect("UndeadDissipate", dx2, dy2, japi.Z(dx2, dy2), 2):size(1)
            end)
        end
        ProcessCurrent:next("slice_island_E")
    end)
    return boss
end