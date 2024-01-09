-- All changes to buy menu weapon descriptions, to make them actually describe what the weapons do
-- The weapons below don't have a description that a new TTT player would really understand, and are changed to one that is hopefully more helpful
if engine.ActiveGamemode() ~= "terrortown" then return end

hook.Add("PreRegisterSWEP", "StigTTTWeaponDescriptions", function(SWEP, class)
    if class == "weapon_ttt_minic" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "On use, turns random props around the map into hostile mimic props. \n\nThey jump towards and damage players on touch!"
        }
    elseif class == "giantsupermariomushroom" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "One use, gain a lot of health and become huge for " .. GetConVar("ttt_giantsupermariomushroom_duration"):GetInt() .. " seconds!"
        }
    elseif class == "weapon_amongussummoner" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Left-click to place an invisible trap on the ground.\n\nIf a player walks over it, an explosive-holding monster spawns and attacks!"
        }
    elseif class == "ttt_weeping_angel" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Shoot someone to have a \"Weeping Angel\" statue follow them.\n\nWhile they aren't looking at it, the angel statue will get closer to them.\n\nIf the statue touches them, they die."
        }
    elseif class == "weapon_ttt_prop_hunt_gun" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Left-click to hide as a barrel!\n\nGo up to a prop and press 'E' to change your disguise to it"
        }
    elseif class == "weapon_ttt_mine_turtle" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Left-click to throw on the ground, right-click to place against a wall.\n\nArms itself after a few seconds, if another player walks by, it explodes!"
        }
    elseif class == "weapon_ttt_hotpotato" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Left-click someone in melee range to give them the hot potato!\n\nIf they don't pass it on in 12 seconds, they explode!"
        }
    elseif class == "weapon_ttt_bonk_bat" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Send people to horny jail!\n\nA bat that traps those you hit in a cage for a few seconds."
        }
    elseif class == "weapon_ttt_printer" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Spend a credit to make more credits!\n\nLeft-click to place the credit printer on the ground and, once it's done, press 'E' to get your credits!\n\nMakes noise once placed..."
        }
    elseif class == "weapon_shark_trap" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "A trap to be placed on the ground.\nCan be picked up with a magneto stick..."
        }
    elseif class == "ttt_cmdpmpt" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Left-click: Grants a random powerful ability!\n\nA description of the ability appears in chat"
        }
    elseif class == "weapon_ttt_cloak" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Hold to become almost invisible\n\nDoesn't hide bloodstains or your name/health popup\n\nSome maps may have bad lighting and leave you a bit too visible."
        }
    elseif class == "weapon_ttt_jetpackspawner" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Left click to drop a jetpack, press 'E' to equip it."
        }
    elseif class == "weapon_ttt_detectiveball" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Throw on someone close to turn them into a detective! \nReveals their role instead if they are a traitor. \n\nNothing happens if they are a special innocent or traitor, like a glitch or a hypnotist."
        }
    elseif class == "rotgun" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Shooting someone with this turns them around."
        }
    elseif class == "weapon_ttt_lightningar1" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "A Guitar-Gun!\n\nA high-damage, musical rifle with some very cool animations and sounds."
        }
    elseif class == "weapon_portalgun" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Left click to shoot a blue hole into a wall/ground, right click to shoot an orange one.\n\nAnything that goes through one hole comes out the other."
        }
    elseif class == "weapon_ttt_prop_disguiser" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Disguise yourself as an object! \n\nR: Select an object you're looking at\n\nLeft-click: Enable disguise"
        }
    elseif class == "weapon_ttt_detective_lightsaber" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "A green lightsaber, green since you're a detective. \nLeft-click: Swing\nR: Change what your right-click does\nRight-click: Whatever you've set with 'R'\n\nYou can switch between: \n- Reflect bullets \n- Push someone using the force\n- Pull someone using the force"
        }
    elseif class == "weapon_dubstepgun" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Hold left click to shoot musical lasers that deal a lot of damage!"
        }
    elseif class == "weapon_randomlauncher" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Launches a random object that deals a lot of damage, usually killing instantly."
        }
    elseif class == "weapon_ttt_fakedeath" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Spawns a fake dead body of yourself at your feet! \n\nLeft-click: Spawn body\n\nRight-click: Change your body's role \n\nR: Change how you died"
        }
    elseif class == "weapon_slazer_new" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Hold left click to fire this MASSIVE laser cannon!\n\nCauses a powerful explosion"
        }
    elseif class == "weapon_ttt_barnacle" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "A deadly alien trap on the ceiling!\n\nLeft click to place the trap on the ceiling, anyone that walks underneath will be slowly killed."
        }
    elseif class == "weapon_vadim_blink" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Instantly teleport to where you're looking!\n\nHold left click to select a location, right click to cancel."
        }
    elseif class == "weapon_ttt_killersnail" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Shoot to cause a snail to slowly follow someone and kill them if it gets close enough."
        }
    elseif class == "weapon_ttt_artillery" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Spawns a very powerful artillery cannon that shoots a large bomb over a long range. \n\nTo control, stand right behind it and press 'E' on the controls that appear."
        }
    elseif class == "weapon_ttt_m4a1_s" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "A silenced automatic rifle. Victims die silently."
        }
    elseif class == "weapon_ttt_rmgrenade" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "A cube-shaped grenade that spawns a black hole! \n\nAnyone too close gets sucked in!\n\nSounds an alarm before the black hole spawns."
        }
    elseif class == "weapon_ttt_comrade_bomb" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "A suicide bomb that transforms anyone in the blast into traitors!"
        }
    elseif class == "weapon_ttt_supersheep" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Let fly an explosive flying sheep!\n\nYour camera follows behind it while you stand still. \n\nSteer it with your mouse, collide into something to explode and press 'R' for a speed boost."
        }
    elseif class == "weapon_ttt_timestop" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Freezes time for a few seconds. \nYou can kill others while they are frozen.\n\nDoesn't affect Detectives!"
        }
    elseif class == "weapon_ttt_traitor_lightsaber" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "A red lightsaber, red since you're a traitor. \nLeft-click: Swing\nR: Change what your right-click does\nRight-click: Whatever you've set with 'R'\n\nYou can switch between: \n- Reflect bullets\n- Shoot lightning\n- Push someone using the force\n- Pull someone using the force"
        }
    elseif class == "weapon_ttt_medkit" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Right-click to heal yourself\n\nLeft-click to heal someone in front of you"
        }
    elseif class == "weapon_ttt_homebat" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Hit people really far with a bat!\nDeals a moderate amount of damage on hit"
        }
    elseif class == "weapon_ttt_obc" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Shoot the ground to summon an ABSOLUTELY MASSIVE laser after a few seconds."
        }
    elseif class == "ttt_deal_with_the_devil" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Reveal you are a traitor to everyone, but receive a powerful perk in return!"
        }
    elseif class == "weapon_ttt_dragon_elites" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Duel-wield pistols with a cool reload animation."
        }
    elseif class == "weapons_ttt_time_manipulator" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Left-click: Slow down time.\n\nRight-click: Speed up time.\n\nR: Reset to normal speed."
        }
    elseif class == "maclunkey" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Deal no damage with other guns while you have this on you. \n\nHas one shot that instantly kills but takes a while to draw.\n\nCan be dropped to deal damage with other guns again."
        }
    elseif class == "weapon_ttt_dead_ringer" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "Turn invisible for a while and leave a body the next time you take damage!\n\nLeft-click to turn on.\nDoes not need to be held once turned on.\n\nYou cannot shoot while invisible.\nRight-click to end the invisibility early."
        }
    elseif class == "weapon_ttt_boomerang" then
        SWEP.EquipMenuData = {
            type = "Weapon",
            desc = "A deadly throwable boomerang, \n\nLeft-click: Kills in 1 hit and moves faster, but doesn't return.\n\nRight-click: Kills in 2 hits and moves slower, but does return."
        }
    elseif class == "ttt_amaterasu" then
        SWEP.EquipMenuData = {
            type = "Passive effect item",
            desc = "Set the next person you look at on fire. \n\nYou don't have to equip this to use it, \njust look at someone."
        }
    end
end)