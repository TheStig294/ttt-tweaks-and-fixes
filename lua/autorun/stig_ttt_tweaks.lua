-- Non-weapon tweaks to various mods on the workshop
-- Weapon tweaks reside in stig_ttt_weapon_tweaks.lua
if engine.ActiveGamemode() ~= "terrortown" then return end
-- Server convars
local inspectCvar
local wallhacksCvar

if SERVER then
    inspectCvar = CreateConVar("ttt_tweaks_tfa_inspect", "0", nil, "Whether inspecting TFA weapons is enabled")
    wallhacksCvar = CreateConVar("ttt_tweaks_auto_trigger_wallhack_randomat", "0", nil, "Seconds into a round to trigger the 'No-one can hide from my sight' randomat, set to 0 to disable")
end

-- Replicated convars
local damagenumbersCvar = CreateConVar("ttt_tweaks_better_damagenumber_default", "1", FCVAR_REPLICATED, "Whether the TF2 damage numbers mod is forced to better-looking defaults on the client")

local verisonUpdateSpamCvar = CreateConVar("ttt_tweaks_simfphys_lvs_update_message", "0", {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Whether the simfphys/LVS mods should show 'A newer version is available!' messages in chat")

local tipsCvar = CreateConVar("ttt_tweaks_tips", "1", FCVAR_REPLICATED, "Whether TTT tips are enabled that show at the bottom of the screen while dead")
local pickupPromptCvar = CreateConVar("ttt_tweaks_pickup_prompt", "1", FCVAR_REPLICATED, "Whether a 'Press E to pickup' prompt appears when looking closely at a weapon that can be picked up in that way")

hook.Add("PostGamemodeLoaded", "StigTTTTweaks", function()
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

if SERVER then
    hook.Add("InitPostEntity", "StigTTTTweaks", function()
        -- Disables TFA inspect button
        if ConVarExists("sv_tfa_cmenu") and not inspectCvar:GetBool() then
            RunConsoleCommand("sv_tfa_cmenu", 0)
        end
    end)

    hook.Add("TTTBeginRound", "StigTTTTweaks", function()
        -- Triggers the "No-one can hide from my sight" randomat after there are so many minutes remaining"
        if wallhacksCvar:GetInt() == 0 then return end

        timer.Create("TTTTweaksAutoTriggerWallhacks", wallhacksCvar:GetInt(), 1, function()
            RunConsoleCommand("ttt_randomat_trigger", "wallhack")
        end)
    end)

    hook.Add("TTTEndRound", "StigTTTTweaks", function()
        timer.Remove("TTTTweaksAutoTriggerWallhacks")
    end)
end

if CLIENT then
    hook.Add("InitPostEntity", "StigTTTTweaks", function()
        -- Disables tips text box for everyone
        if ConVarExists("ttt_tips_enable") and not tipsCvar:GetBool() then
            RunConsoleCommand("ttt_tips_enable", 0)
        end

        -- Makes TF2 damage numbers mod have better defaults
        if ConVarExists("ttt_combattext_antialias") and damagenumbersCvar:GetBool() then
            RunConsoleCommand("ttt_combattext_antialias", "1")
            RunConsoleCommand("ttt_combattext_color", "ffffff80")
        end

        -- "Press E to Pickup" prompt
        if pickupPromptCvar:GetBool() then
            local weaponQuickSwapInstalled = file.Exists("gamemodes/terrortown/gamemode/lang/weapon_quick_swap.lua", "GAME")
            local client = LocalPlayer()
            local pickupableWeapon = false

            -- Check for a pickup-able weapon in a timer, rather than in the HUD hook itself, 
            -- because HUD hooks are called very often and a 0.1 second timer is more than enough frequency for checking if a pickupable weapon is being looked at
            timer.Create("StigTTTTweaksCheckForPickupableWeapon", 0.1, 0, function()
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

            hook.Add("HUDPaint", "StigTTTTweaks", function()
                if pickupableWeapon then
                    draw.SimpleTextOutlined(text, "DermaLarge", ScrW() / 2, ScrH() / 1.8, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, COLOR_BLACK)
                end
            end)
        end
    end)
end