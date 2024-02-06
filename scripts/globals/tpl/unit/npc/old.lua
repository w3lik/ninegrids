TPL_UNIT.NPC_Zeus = UnitTpl()
    :name("怪老头")
    :modelAlias("hero/Zeus")
    :icon("unit/AvatarOn")
    :modelScale(1)
    :scale(1)
    :itemSlot(false)
    :superposition("noAttack", 1)
    :superposition("invulnerable", 1)
    :hp(99999)
    :mp(99999)
    :move(0)
    :balloon(
    {
        z = 300,
        interval = 0.01,
        message = {
            {
                tips = function()
                    local txt
                    if (Game():achievement(6)) then
                        txt = {
                            "你已经拥有改变气候的力量",
                            Game():balloonKeyboardTips("改变气候")
                        }
                    else
                        txt = {
                            "给我找来 " .. colour.hex(colour.aliceblue, "5 个【大空陨石】"),
                            "我可以赐予你改变气候的力量",
                            Game():balloonKeyboardTips("给予大空陨石")
                        }
                    end
                    return txt
                end,
                call = function()
                    local gd = Game():GD()
                    local p = gd.me:owner()
                    if (Game():achievement(6)) then
                        async.call(p, function()
                            UIKit("ninegrids_essence"):essence("weather", 2, false)
                        end)
                    else
                        local tpl = TPL_ITEM.Mission_SoraStone
                        local w = p:warehouseSlot()
                        if (w:has(tpl) == false) then
                            async.call(p, function()
                                UI_NinegridsInfo:info("error", 3, "毛都没有，老头子也骗？")
                            end)
                            return
                        end
                        if (w:quantity(tpl) < 5) then
                            async.call(p, function()
                                UI_NinegridsInfo:info("error", 3, "数量还不够呢")
                            end)
                            return
                        end
                        w:removeTpl(tpl)
                        Game():achievement(6, true)
                        UIKit("ninegrids_essence"):stage().switch.weather:alpha(255)
                    end
                end
            }
        }
    })