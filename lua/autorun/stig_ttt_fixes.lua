-- All non-weapon fixes for various mods on the workshop
-- Weapon fixes reside in stig_ttt_weapon_fixes.lua
if engine.ActiveGamemode() ~= "terrortown" then return end

if SERVER then
    -- Fixes "Custom Chat" mod letting dead players speak with living players
    -- The problem is the Custom Chat mod has re-created the chat box from scratch, and so has to re-add all of the hooks the old chat box had
    -- The creator missed a few hooks, so we have to get the server-side only dead chat convar over to a client-side only hook the mod actually supports
    -- ttt_limit_spectator_chat is a vanilla TTT convar and it is server-side only, because it used a server-side hook (GM:PlayerCanSeePlayersChat, that the Custom Chat creator missed)
    -- 
    -- Setting the initial value of the limit chat convar for the dead chat fix
    hook.Add("TTTPrepareRound", "StigTTTFixCustomChat", function()
        SetGlobalBool("ttt_limit_spectator_chat", GetConVar("ttt_limit_spectator_chat"):GetBool())
        hook.Remove("TTTPrepareRound", "StigTTTFixCustomChat")
    end)

    -- And if the convar is updated mid-game, we need to update the global bool too
    cvars.AddChangeCallback("ttt_limit_spectator_chat", function(convar_name, value_old, value_new)
        SetGlobalBool("ttt_limit_spectator_chat", tobool(value_new))
    end)
end

-- Fixes spectators being visible at the start of the round
local function FixVisibleSpectators()
    for _, ply in ipairs(player.GetAll()) do
        if ply:IsSpec() then
            ply:SetNoDraw(true)
            ply:SetRenderMode(RENDERMODE_TRANSALPHA)
            ply:SetMaterial("models/effects/vol_light001")

            if SERVER then
                ply:Fire("alpha", 0, 0)
            end
        else
            ply:SetNoDraw(false)
            ply:DrawShadow(true)
            ply:SetMaterial("")
            ply:SetRenderMode(RENDERMODE_NORMAL)

            if SERVER then
                ply:Fire("alpha", 255, 0)
            end
        end
    end
end

hook.Add("TTTPrepareRound", "StigTTTFixes", function()
    FixVisibleSpectators()
    timer.Simple(0.1, FixVisibleSpectators)

    timer.Create("StigTTTFixesVisibleSpectators", 1, 4, function()
        FixVisibleSpectators()
    end)
end)

if CLIENT then
    -- Fixes "Custom Chat" mod letting dead players speak with living players
    hook.Add("OnPlayerChat", "StigTTTFixCustomChat", function(ply, text, teamChat, isDead)
        if GetGlobalBool("ttt_limit_spectator_chat") and isDead and LocalPlayer():Alive() and not LocalPlayer():IsSpec() then return true end
    end)
end