TPL_UNIT.NPC_FireDo = UnitTpl()
    :name("火魔")
    :modelAlias("unit/FireElemental2")
    :icon("unit/MagmaElemental")
    :modelScale(0.9)
    :scale(2.0)
    :itemSlot(false)
    :superposition("noAttack", 1)
    :superposition("invulnerable", 1)
    :hp(1)
    :mp(1)
    :move(0)
    :balloon(
    {
        z = 210,
        interval = 0.01,
        message = {
            {
                tips = function()
                    local gd = Game():GD()
                    if (gd.fireLevel < 9) then
                        return {
                            "准备好了吗？",
                            "开始挑战火焰山：" .. colour.hex(colour.gold, "Lv." .. math.min(9, gd.fireLevel + 1)),
                            "成功挑战每一层可获得3点能力点和金币",
                            Game():balloonKeyboardTips("开始挑战")
                        }
                    else
                        return {
                            "征服者你好！",
                            "再次挑战火焰山：" .. colour.hex(colour.gold, "Lv.9"),
                            "成功挑战可获得银币奖励",
                            Game():balloonKeyboardTips("开始挑战")
                        }
                    end
                end,
                call = function()
                    local gd = Game():GD()
                    if (isClass(gd.me, UnitClass) and gd.me:isAlive()) then
                        Game():closeDoor()
                        Game():npcClear()
                        async.call(gd.me:owner(), function()
                            audio(Vcm("monster"))
                        end)
                        ProcessCurrent:next("slice_fire_battle")
                    end
                end
            }
        },
    })
TPL_UNIT.Fire_mid = UnitTpl("LavaSpawn")
    :name("青至火魔")
    :icon("unit/MagmaElemental")
    :modelAlias("unit/FireElementalGreen")
    :modelScale(1.1)
    :scale(1.1)
    :abilitySlot({ TPL_ABILITY_FIRE[1], TPL_ABILITY_FIRE[2], TPL_ABILITY_FIRE[4] })
    :attackSpaceBase(2)
    :mp(300)
    :reborn(10)
    :attackRange(300)
    :sight(2000)
    :attackRangeAcquire(2000)
    :prop("sp", "火体质，冰水抗性减10%")
    :enchantMaterial(DAMAGE_TYPE.fire)
    :enchantResistance(DAMAGE_TYPE.water, -10)
    :enchantResistance(DAMAGE_TYPE.ice, -10)
    :attackMode(AttackMode():mode("missile")
                            :missileModel("DemonHunterMissile")
                            :damageType(DAMAGE_TYPE.fire):damageTypeLevel(2)
                            :height(200):speed(600))
TPL_UNIT.Fire_lava = UnitTpl("LavaSpawn")
    :name("小炎魔")
    :icon("unit/LavaSpawn")
    :modelAlias("LavaSpawn")
    :abilitySlot({ TPL_ABILITY_FIRE[1], TPL_ABILITY_FIRE[2] })
    :attackSpaceBase(1.2)
    :attackRange(200)
    :move(250)
    :mp(0)
    :prop("sp", "火体质，冰水抗性减20%")
    :enchantMaterial(DAMAGE_TYPE.fire)
    :enchantResistance(DAMAGE_TYPE.water, -20)
    :enchantResistance(DAMAGE_TYPE.ice, -20)
    :attackMode(AttackMode():mode("missile")
                            :missileModel("LavaSpawnBirthMissile")
                            :damageType(DAMAGE_TYPE.fire):damageTypeLevel(1)
                            :height(50):speed(800))
TPL_UNIT.Fire_felboar = UnitTpl("QuillBeast")
    :name("小火猪")
    :icon("unit/SeethingHelhound")
    :modelAlias("unit/FelBoar4x")
    :abilitySlot({ TPL_ABILITY_FIRE[1], TPL_ABILITY_FIRE[2] })
    :attackSpaceBase(0.8)
    :attackRange(100)
    :move(280)
    :mp(0)
    :prop("sp", "火体质，冰水抗性减25%")
    :enchantMaterial(DAMAGE_TYPE.fire)
    :enchantResistance(DAMAGE_TYPE.water, -25)
    :enchantResistance(DAMAGE_TYPE.ice, -25)
    :attackMode(AttackMode():mode("common"):damageType(DAMAGE_TYPE.fire):damageTypeLevel(1))
TPL_UNIT.Fire_lavaKirami = UnitTpl("QuillBeast")
    :name("极炎魔")
    :icon("unit/MagmaElemental")
    :modelAlias("unit/Ragnaros")
    :modelScale(1.3)
    :scale(1.3)
    :abilitySlot({ TPL_ABILITY_FIRE[1], TPL_ABILITY_FIRE[2], TPL_ABILITY_FIRE[4], TPL_ABILITY_FIRE[8] })
    :attackSpaceBase(1.4)
    :attackRange(100)
    :reborn(8)
    :mp(500)
    :prop("sp", "火体质、免疫，7%几率暴击200%，10%几率眩晕1秒")
    :odds("crit", 7):crit(100)
    :odds("stun", 10):stun(1)
    :enchantImmune(DAMAGE_TYPE.fire, 1)
    :enchantMaterial(DAMAGE_TYPE.fire)
    :attackMode(AttackMode():mode("common"):damageType(DAMAGE_TYPE.fire):damageTypeLevel(2))