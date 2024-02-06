TPL_ITEM_BALLOON = TPL_ITEM_BALLOON or {}
function balloonItemCreate(name, x, y, dur)
    if (isClass(TPL_ITEM_BALLOON[name], UnitTplClass)) then
        Game():npc("BALLOON_ITEM_" .. name, TPL_ITEM_BALLOON[name], x, y, 270, function(evtUnit)
            if (type(dur) == "number" and dur > 0) then
                evtUnit:duration(dur)
            end
        end)
    end
end
function balloonItemConf(options, call)
    TPL_ITEM_BALLOON[options.name] = UnitTpl()
        :name(options.name)
        :modelAlias(options.modelAlias)
        :icon(options.icon)
        :modelScale(options.modelScale or 1)
        :scale(options.scale or 1)
        :itemSlot(false)
        :superposition("noAttack", 1)
        :superposition("invulnerable", 1)
        :hp(1)
        :mp(0)
        :move(0)
        :balloon(
        {
            z = options.z or 180,
            interval = 0.01,
            message = { { tips = options.tips, call = call } },
        })
end
Game():onEvent(EVENT.Game.Start, "balloonItemSacred", function()
    for i = 2, 8, 1 do
        local tpl = TPL_SACRED[i]
        local tips = {}
        local desc = tpl:description()
        if (type(desc) == "string") then
            table.insert(tips, desc)
        elseif (type(desc) == "table") then
            tips = table.merge(tips, desc)
        end
        table.insert(tips, Game():balloonKeyboardTips("拾取此器"))
        balloonItemConf({
            name = tpl:name(), modelAlias = tpl:modelAlias(), icon = tpl:icon(), modelScale = tpl:modelScale(), scale = tpl:scale(), z = 160,
            tips = tips },
            function(callbackData)
                destroy(callbackData.balloonObj)
                if (Game():sacred(i) == false) then
                    Game():sacred(i, true)
                end
            end)
    end
end)
balloonItemConf({
    name = "大空陨石", modelAlias = "item/FrostcraftCrystal", icon = "item/DataCrystal08", modelScale = 0.6, scale = 1.1, z = 160,
    tips = { "奇怪的石头", Game():balloonKeyboardTips("捡取石头") } },
    function(callbackData)
        if (callbackData.triggerUnit:owner():pickMissionItem(TPL_ITEM.Mission_SoraStone)) then
            destroy(callbackData.balloonObj)
        end
    end)
balloonItemConf({
    name = "雪蓝核心", modelAlias = "item/FrostShard", icon = "item/MiscGemAzureDraenite02", modelScale = 1.0, scale = 1.0,
    tips = { "雪蓝的石头", Game():balloonKeyboardTips("捡取核心") } },
    function(callbackData)
        if (callbackData.triggerUnit:owner():pickMissionItem(TPL_ITEM.Mission_SnowCore)) then
            destroy(callbackData.balloonObj)
        end
    end)