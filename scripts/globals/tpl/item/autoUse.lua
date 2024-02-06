TPL_AUTOUSE_ITEM = TPL_AUTOUSE_ITEM or {}
function autoItemCreate(name, x, y, dur)
    local tpl = TPL_AUTOUSE_ITEM[name]
    local it
    if (isClass(tpl, ItemTplClass)) then
        it = Game():autoUseItem(tpl, x, y, dur)
    end
    return it
end
function autoItemConf(options, call)
    TPL_AUTOUSE_ITEM[options.name] = ItemTpl()
        :autoUse(true)
        :name(options.name)
        :description(options.description)
        :icon(options.icon)
        :modelAlias(options.modelAlias)
        :modelScale(options.modelScale or 1)
        :scale(options.scale or 1)
        :dropable(false)
        :pawnable(false)
        :toast(function(this) return this:name() end)
        :ability(
        AbilityTpl()
            :targetType(ABILITY_TARGET_TYPE.tag_nil)
            :onEvent(EVENT.Ability.Effective, function(effectiveData)
            async.call(effectiveData.triggerUnit:owner(), function()
                UI_LikEcho:echo("使用了" .. colour.hex(colour.gold, '[' .. effectiveData.triggerItem:name() .. ']'))
            end)
            call(effectiveData.triggerUnit)
        end))
end
autoItemConf({
    name = "小金币", modelAlias = "item/Golds", icon = "item/ChestOfGold", modelScale = 0.9, scale = 0.9,
    description = {
        "零零散散的金币",
        colour.hex(colour.lawngreen, "获得随机1~2枚金币"),
    } },
    function(triggerUnit)
        triggerUnit:owner():award({ gold = math.rand(1, 2) })
    end)
autoItemConf({
    name = "大金币", modelAlias = "item/Golds", icon = "item/ChestOfGold", modelScale = 1.2, scale = 1.2,
    description = {
        "叮咚作响的金币",
        colour.hex(colour.lawngreen, "获得随机3~6枚金币"),
    } },
    function(triggerUnit)
        triggerUnit:owner():award({ gold = math.rand(3, 6) })
    end)
autoItemConf({
    name = "加工冷冻肉", modelAlias = "item/Food", icon = "item/MiscFood49", modelScale = 1,
    description = {
        "加工的鲜甜冻肉",
        colour.hex(colour.lawngreen, "恢复 60% HP"),
    } },
    function(triggerUnit)
        triggerUnit:attach("AIheTarget", "origin", 1)
        triggerUnit:hpBack(0.6 * triggerUnit:hp())
    end)
autoItemConf({
    name = "熊肉", modelAlias = "item/MonsterLure2", icon = "item/MiscFood89", modelScale = 1,
    description = {
        "一块熊类的肉",
        colour.hex(colour.lawngreen, "恢复 15% HP"),
    } },
    function(triggerUnit)
        triggerUnit:attach("AIheTarget", "origin", 1)
        triggerUnit:hpBack(0.15 * triggerUnit:hp())
    end)
autoItemConf({
    name = "虎肉", modelAlias = "item/MonsterLure2", icon = "item/MiscFood71", modelScale = 1,
    description = {
        "一块虎类的肉",
        colour.hex(colour.lawngreen, "恢复 15% MP"),
    } },
    function(triggerUnit)
        triggerUnit:attach("AImaTarget", "origin", 1)
        triggerUnit:mpBack(0.15 * triggerUnit:mp())
    end)
autoItemConf({
    name = "古怪蜘蛛卵", modelAlias = "ThunderLizardEgg", icon = "item/Egg09", modelScale = 1,
    description = {
        "古怪蜘蛛送的蛋卵",
        colour.hex(colour.lawngreen, "恢复 10% HP"),
        colour.hex(colour.lawngreen, "恢复 10% MP"),
    } },
    function(triggerUnit)
        triggerUnit:attach("AIheTarget", "origin", 1)
        triggerUnit:hpBack(0.10 * triggerUnit:hp())
        triggerUnit:mpBack(0.10 * triggerUnit:mp())
    end)
autoItemConf({
    name = "天穹至礼", modelAlias = "BundleOfGifts", icon = "item/HolidayChristmasPresent01", modelScale = 1,
    description = {
        "自称天穹使者赠与的礼包",
        colour.hex(colour.lawngreen, "是次轮回中，攻击增加15%"),
    } },
    function(triggerUnit)
        triggerUnit:attach("AIimTarget", "origin", 1)
        triggerUnit:mutation("attack", "+=15")
    end)
autoItemConf({
    name = "海族赠礼", modelAlias = "BundleOfGifts", icon = "item/HolidayChristmasPresent01", modelScale = 1,
    description = {
        "帮助海族后获得的赠礼",
        colour.hex(colour.lawngreen, "是次轮回中，冷却减少25%"),
    } },
    function(triggerUnit)
        triggerUnit:attach("AIimTarget", "origin", 1)
        triggerUnit:coolDownPercent("-=25")
    end)
autoItemConf({
    name = "醉天璇液美酒", modelAlias = "item/Potion_Red", icon = "item/AlchemyPotion06", modelScale = 1.5,
    description = {
        "半壶香喷喷的美酒",
        colour.hex(colour.lawngreen, "恢复 30% HP"),
        colour.hex(colour.lawngreen, "恢复 30% MP"),
    } },
    function(triggerUnit)
        triggerUnit:attach("AIheTarget", "origin", 1)
        triggerUnit:hpBack(0.30 * triggerUnit:hp())
        triggerUnit:mpBack(0.30 * triggerUnit:mp())
    end)
autoItemConf({
    name = "特大熊肉", modelAlias = "item/MonsterLure2", icon = "item/MiscFood89", modelScale = 2, scale = 2,
    description = {
        "一大块熊类的肉",
        colour.hex(colour.lawngreen, "恢复 50% HP"),
    } },
    function(triggerUnit)
        triggerUnit:attach("AIheTarget", "origin", 1)
        triggerUnit:hpBack(0.5 * triggerUnit:hp())
    end)