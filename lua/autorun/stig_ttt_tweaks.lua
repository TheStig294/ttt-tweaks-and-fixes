-- Non-weapon tweaks to various mods on the workshop
-- Weapon tweaks reside in stig_ttt_weapon_tweaks.lua
if engine.ActiveGamemode() ~= "terrortown" then return end
local damagenumbersCvar = CreateConVar("ttt_tweaks_better_damagenumber_default", "1", FCVAR_REPLICATED, "Whether the TF2 damage numbers mod is forced to better-looking defaults on the client")

local verisonUpdateSpamCvar = CreateConVar("ttt_tweaks_simfphys_lvs_update_message", "0", {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Whether the simfphys/LVS mods should show 'A newer version is available!' messages in chat")

local tipsCvar = CreateConVar("ttt_tweaks_tips", "1", FCVAR_REPLICATED, "Whether TTT tips are enabled that show at the bottom of the screen while dead")
local inspectCvar = CreateConVar("ttt_tweaks_tfa_inspect", "0", nil, "Whether inspecting TFA weapons is enabled")
local wallhacksCvar = CreateConVar("ttt_tweaks_auto_trigger_wallhack_randomat", "0", nil, "Minutes into a round to trigger the 'No-one can hide from my sight' randomat, set to 0 to disable")

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

hook.Add("InitPostEntity", "StigTTTTweaks", function()
    -- Makes TF2 damage numbers mod have better defaults
    if ConVarExists("ttt_combattext_antialias") and damagenumbersCvar:GetBool() then
        RunConsoleCommand("ttt_combattext_antialias", "1")
        RunConsoleCommand("ttt_combattext_color", "ffffff80")
    end

    -- Disables TFA inspect button
    if ConVarExists("sv_tfa_cmenu") and not inspectCvar:GetBool() then
        RunConsoleCommand("sv_tfa_cmenu", 0)
    end

    -- Disables tips text box for everyone
    if ConVarExists("ttt_tips_enable") and not tipsCvar:GetBool() then
        RunConsoleCommand("ttt_tips_enable", 0)
    end
end)

hook.Add("TTTEndRound", "StigTTTTweaks", function()
    timer.Remove("TTTTweaksAutoTriggerWallhacks")
end)

hook.Add("TTTBeginRound", "StigTTTTweaks", function()
    if wallhacksCvar:GetInt() == 0 then return end

    -- Triggers the "No-one can hide from my sight" randomat after there are so many minutes remaining"
    timer.Create("TTTTweaksAutoTriggerWallhacks", wallhacksCvar:GetInt(), 1, function()
        RunConsoleCommand("ttt_randomat_trigger", "wallhack")
    end)
end)