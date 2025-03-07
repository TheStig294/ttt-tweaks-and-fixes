-- Non-weapon tweaks to various mods on the workshop
-- Weapon tweaks reside in stig_ttt_weapon_tweaks.lua
if engine.ActiveGamemode() ~= "terrortown" then return end

-- Server and client
local verisonUpdateSpamCvar = CreateConVar("ttt_tweaks_simfphys_lvs_update_message", "0", {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Whether the simfphys/LVS mods should show 'A newer version is available!' messages in chat")

hook.Add("PostGamemodeLoaded", "TTTTweaksDisableLVSUpdateMessage", function()
    -- Stopping the update now spam in the chat box from the vehicles base mod: LVS
    if (simfphys or LVS) and not verisonUpdateSpamCvar:GetBool() then
        if simfphys then
            function simfphys:CheckUpdates()
            end
        end

        if LVS then
            function LVS:CheckUpdates()
            end
        end
    end
end)

-- Server-only
if SERVER then
    -- Disables TFA inspect button
    local inspectCvar = CreateConVar("ttt_tweaks_tfa_inspect", "0", nil, "Whether inspecting TFA weapons is enabled")

    hook.Add("InitPostEntity", "TTTTweaksDisableTFAInspect", function()
        if ConVarExists("sv_tfa_cmenu") and not inspectCvar:GetBool() then
            RunConsoleCommand("sv_tfa_cmenu", 0)
        end

        -- Removes the "Ben is awesome" chat message spam from Jenson's Beenade weapon
        hook.Add("PlayerInitialSpawn", "SteamIDDisplay", function() end)
    end)

    -- Triggers the "No-one can hide from my sight" randomat after there are so many minutes remaining"
    local wallhacksCvar = CreateConVar("ttt_tweaks_auto_trigger_wallhack_randomat", "0", nil, "Seconds into a round to trigger the 'No-one can hide from my sight' randomat, set to 0 to disable")

    hook.Add("TTTBeginRound", "TTTTweaksWallhacks", function()
        if wallhacksCvar:GetInt() == 0 then return end

        timer.Create("TTTTweaksAutoTriggerWallhacks", wallhacksCvar:GetInt(), 1, function()
            RunConsoleCommand("ttt_randomat_trigger", "wallhack")
        end)
    end)

    hook.Add("TTTEndRound", "TTTTweaksWallhacks", function()
        timer.Remove("TTTTweaksAutoTriggerWallhacks")
    end)

    -- Makes you camera go to a 3rd person view on dying rather than 1st person
    local deathcamThirdpersonCvar = CreateConVar("ttt_tweaks_deathcam_thirdperson", "1", nil, "Whether your camera views your body in third-person rather than first-person on dying")

    hook.Add("PostPlayerDeath", "TTTTweaks3rdPersonDeath", function(ply)
        if deathcamThirdpersonCvar:GetBool() and ply:GetObserverMode() == OBS_MODE_IN_EYE then
            ply:SetObserverMode(OBS_MODE_CHASE)
        end
    end)

    -- Forces barnacles to ignore players on the jester team
    local barnaclesIgnoreJestersCvar = CreateConVar("ttt_tweaks_barnacles_ignore_jesters", "1", nil, "Whether to allow players on the jester team to be picked up by barnacles")

    -- When a new barnacle is placed
    hook.Add("OnEntityCreated", "TTTTweaksBarnacleIgnoreJesters", function(ent)
        if not barnaclesIgnoreJestersCvar:GetBool() then return end

        timer.Simple(0, function()
            if IsValid(ent) and ent:GetClass() == "npc_barnacle" then
                for _, ply in player.Iterator() do
                    if ply.IsJesterTeam and ply:IsJesterTeam() then
                        ent:AddEntityRelationship(ply, D_LI, 99)
                    end
                end
            end
        end)
    end)

    -- When a player becomes/stops being a jester role
    hook.Add("TTTPlayerRoleChanged", "TTTTweaksBarnacleIgnoreJesters", function(ply, oldRole, newRole)
        if not barnaclesIgnoreJestersCvar:GetBool() then return end

        if JESTER_ROLES[oldRole] and not JESTER_ROLES[newRole] then
            for _, barnacle in ipairs(ents.FindByClass("npc_barnacle")) do
                barnacle:AddEntityRelationship(ply, D_HT, 99)
            end
        elseif JESTER_ROLES[newRole] and not JESTER_ROLES[oldRole] then
            local inBarnacle = ply:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE)

            for _, barnacle in ipairs(ents.FindByClass("npc_barnacle")) do
                barnacle:AddEntityRelationship(ply, D_LI, 99)

                if inBarnacle then
                    barnacle:Fire("LetGo")
                end
            end
        end
    end)
end

-- Client-only
local tipsCvar = CreateConVar("ttt_tweaks_tips", "1", FCVAR_REPLICATED, "Whether TTT tips are enabled that show at the bottom of the screen while dead")
local damagenumbersCvar = CreateConVar("ttt_tweaks_better_damagenumber_default", "1", FCVAR_REPLICATED, "Whether the TF2 damage numbers mod is forced to better-looking defaults on the client")
local pickupPromptCvar = CreateConVar("ttt_tweaks_pickup_prompt", "1", FCVAR_REPLICATED, "Whether a 'Press E to pickup' prompt appears when looking closely at a weapon that can be picked up in that way")
local disableNotificationSoundCvar = CreateConVar("ttt_tweaks_force_off_notification_sound", "1", FCVAR_REPLICATED, "Whether the sound that plays when a notification appears in the top-right corner of the screen is forced off for all players")

if CLIENT then
    hook.Add("InitPostEntity", "TTTTweaksInitPostEntity", function()
        -- Disables tips text box for everyone
        if ConVarExists("ttt_tips_enable") and not tipsCvar:GetBool() then
            RunConsoleCommand("ttt_tips_enable", 0)
        end

        -- Makes TF2 damage numbers mod have better defaults
        if ConVarExists("ttt_combattext_antialias") and damagenumbersCvar:GetBool() then
            RunConsoleCommand("ttt_combattext_antialias", "1")
            RunConsoleCommand("ttt_combattext_color", "ffffff80")
            RunConsoleCommand("ttt_combattext", "1")
        end

        -- "Press E to Pickup" prompt
        if pickupPromptCvar:GetBool() then
            local weaponQuickSwapInstalled = file.Exists("gamemodes/terrortown/gamemode/lang/weapon_quick_swap.lua", "GAME")
            local client = LocalPlayer()
            local pickupableWeapon = false

            -- Check for a pickup-able weapon in a timer, rather than in the HUD hook itself, 
            -- because HUD hooks are called very often and a 0.1 second timer is more than enough frequency for checking if a pickupable weapon is being looked at
            timer.Create("TTTTweaksCheckForPickupableWeapon", 0.1, 0, function()
                local tr = client:GetEyeTrace()
                local wep = tr.Entity

                -- First, check for a weapon being looked at at all
                -- Then check if it is close enough, 70 is actual distance, use 70*70=4900 for performance
                if not IsValid(wep) or not wep:IsWeapon() or not wep.Kind or wep:GetPos():DistToSqr(client:GetPos()) > 4900 then
                    pickupableWeapon = false

                    return
                end

                -- Finally check if the weapon is able to be picked up
                if weaponQuickSwapInstalled or wep.Kind == WEAPON_EQUIP1 or wep.Kind == WEAPON_EQUIP2 or wep.Kind > WEAPON_ROLE then
                    pickupableWeapon = true
                else
                    pickupableWeapon = false
                end
            end)

            local text = "Press " .. string.upper(input.LookupBinding("+use", true)) .. " to pickup"

            hook.Add("HUDPaint", "TTTTweaksEToPickupText", function()
                if pickupableWeapon then
                    draw.SimpleTextOutlined(text, "DermaLarge", ScrW() / 2, ScrH() / 1.8, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, COLOR_BLACK)
                end
            end)
        end

        -- Disables the annoying notification sound for everyone
        if ConVarExists("ttt_cl_msg_soundcue") and disableNotificationSoundCvar:GetBool() then
            RunConsoleCommand("ttt_cl_msg_soundcue", 0)
        end
    end)
end