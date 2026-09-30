-- Many, many pure bug fixes for various weapons on the workshop
-- These are the weapons that only have fixes
-- Any weapon that has both a fix and tweak resides in stig_ttt_weapon_tweaks.lua, not here
if engine.ActiveGamemode() ~= "terrortown" then return end

-- All the default TTT SWEPs and ENTs that have SWEP/ENT.WeaponID
-- Used for a minor networking optimisation to save sending the classname to the client for showing weapon/entity names in the end-of-round report
-- Misused by countless custom SWEPs/ENTs on the workshop, which mistakenly set this property,
-- overriding the names of all other SWEPs/ENTs that set it with the same value... (in the end-of-round report)
-- Also fixes any mods using default TTT's EnumToWep() or WepToEnum() functions, which also use SWEP/ENT.WeaponID
local defaultTTTWeapons = {
    weapon_ttt_cse = true,
    weapon_ttt_flaregun = true,
    weapon_ttt_defuser = true,
    weapon_ttt_m16 = true,
    weapon_ttt_knife = true,
    weapon_ttt_teleport = true,
    weapon_ttt_binoculars = true,
    weapon_zm_shotgun = true,
    weapon_ttt_radio = true,
    weapon_ttt_push = true,
    weapon_ttt_stungun = true,
    weapon_ttt_smokegrenade = true,
    weapon_ttt_health_station = true,
    weapon_ttt_beacon = true,
    weapon_zm_molotov = true,
    weapon_ttt_sipistol = true,
    weapon_ttt_glock = true,
    weapon_ttt_wtester = true,
    weapon_zm_rifle = true,
    weapon_zm_mac10 = true,
    weapon_ttt_decoy = true,
    weapon_zm_pistol = true,
    weapon_ttt_phammer = true,
    weapon_ttt_confgrenade = true,
    weapon_ttt_c4 = true,
    weapon_zm_sledge = true,
    weapon_zm_revolver = true,
    weapon_zm_improvised = true,
}

-- This is the only default TTT entity that sets ENT.WeaponID
local defaultTTTEnts = {
    ttt_knife_proj = true,
}

hook.Add("PreRegisterSWEP", "StigTTTWeaponFixes", function(SWEP, class)
    -- Quick fix for TTT weapons given slot 3 when it should be 2
    -- (+1 to slot number to determine its slot in-game, some weapons are 1-off the correct slot)
    if SWEP.Kind and SWEP.Kind ~= WEAPON_NADE and SWEP.Slot and SWEP.Slot == 3 then
        SWEP.Slot = 2
    end

    -- Fix custom weapons setting SWEP.WeaponID when it's only for default weapons
    -- (Causes weapon names to override each other on the end-of-round popup/round report)
    if SWEP.WeaponID and not defaultTTTWeapons[class] then
        SWEP.WeaponID = nil
    end

    if class == "ttt_no_scope_awp" then
        -- Fix no-scope AWP taking different slot visually than it actually takes
        SWEP.Slot = 6
    elseif class == "weapon_ttt_mc_immortpotion" then
        -- Fix immortality potion's name being too long
        SWEP.PrintName = "Immortality Pot."
    elseif class == "weapon_ttt_headlauncher" then
        -- Fix headcrab launcher's name being too long
        SWEP.PrintName = "Headcrab Launcher"
    elseif class == "weapon_ttt_rocket_thruster" then
        -- Fix rocket thruster using wrong HUD slot and print name
        SWEP.Slot = 1
        SWEP.PrintName = "Rocket Thruster"
    elseif class == "weapon_lee" then
        -- Fix not using TTT ammo
        SWEP.AmmoEnt = "item_ammo_revolver_ttt"
        SWEP.Primary.Ammo = "AlyxGun"
    elseif class == "tfa_dax_big_glock" then
        -- Fix big glock not using TTT ammo
        SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize
        SWEP.Primary.Ammo = "357"
        SWEP.AmmoEnt = "item_ammo_357_ttt"
    elseif class == "weapon_ttt_fortnite_building" then
        -- Fix lua error with fortnite building tool
        function SWEP:Holster()
            if CLIENT and IsValid(self.c_Model) then
                self.c_Model:SetNoDraw(true)
            end

            return true
        end
    elseif class == "weapon_ttt_prop_hunt_gun" then
        -- Fixes the prop hunt gun not fully disguising you
        SWEP.PrintName = "Prop Disguiser"
        hook.Remove("EntityTakeDamage", "CauseGodModeIsOP")
        SWEP.OldPropDisguise = SWEP.PropDisguise
        SWEP.OldPropUnDisguise = SWEP.PropUnDisguise

        -- Fixes detective being outed by their overhead icon while prop disguised
        hook.Add("TTTTargetIDPlayerBlockIcon", "StigWeaponFixesBlockPropHuntGunIcon", function(ply, client)
            if ply:GetNWBool("PHR_Disguised") then return true end
        end)

        function SWEP:PropDisguise()
            self.OldPropDisguise(self)
            local owner = self:GetOwner()
            if not IsValid(owner) then return end
            -- Some maps have the uber-shiny default cubemap, that has the side-effect of making players
            -- with the "heatwave" material set super visible, a common way of making players invisible
            -- for most uses, like the dead ringer, this doesn't really matter, but with the prop hunt
            -- gun, you typically stay still, making the problem more pronounced
            -- So we just set the player to be outright unrendered until they are undisguised
            owner:SetNoDraw(true)
        end

        function SWEP:PropUnDisguise()
            local owner = self:GetOwner()
            if not IsValid(owner) then return end
            owner:SetNoDraw(false)
            self.OldPropUnDisguise(self)
        end
    elseif class == "weapon_ap_tec9" then
        -- Fixes error spam with the tec9's ricochet function
        function SWEP:RicochetCallback(bouncenum, attacker, tr, dmginfo)
            if not IsFirstTimePredicted() then
                return {
                    damage = false,
                    effects = false
                }
            end

            if tr.HitSky then return end
            self.MaxRicochet = 1
            if bouncenum > self.MaxRicochet then return end
            -- Bounce vector
            local trace = {}
            trace.start = tr.HitPos
            trace.endpos = trace.start + tr.HitNormal * 16384
            trace = util.TraceLine(trace)
            local DotProduct = tr.HitNormal:Dot(tr.Normal * -1)
            local ricochetbullet = {}
            ricochetbullet.Num = 1
            ricochetbullet.Src = tr.HitPos + tr.HitNormal * 5
            ricochetbullet.Dir = 2 * tr.HitNormal * DotProduct + tr.Normal + VectorRand() * 0.05
            ricochetbullet.Spread = Vector(0, 0, 0)
            ricochetbullet.Tracer = 1
            ricochetbullet.TracerName = "Impact"
            ricochetbullet.Force = dmginfo:GetDamageForce() * 0.8
            ricochetbullet.Damage = dmginfo:GetDamage() * 0.8

            ricochetbullet.Callback = function(a, b, c)
                if IsValid(self) and isfunction(self.RicochetCallback) then return self:RicochetCallback(bouncenum + 1, a, b, c) end
            end

            timer.Simple(0, function()
                attacker:FireBullets(ricochetbullet)
            end)

            return {
                damage = true,
                effects = true
            }
        end
    elseif class == "weapon_ttt_minic" then
        -- Fixes the "Mimics spawned" message only displaying to vanilla traitors
        local mymodel = ""

        function SWEP:PrimaryAttack()
            mymodel = 60
            local maxmodel = 60

            if mymodel > 60 then
                maxmodel = 60
            else
                maxmodel = mymodel
            end

            if SERVER then
                for i = 1, math.random(maxmodel) do
                    local ent = ents.Create("ttt_minictest") -- This creates our npc entity
                    ent:Spawn()
                end
            end

            local mimicCount = table.Count(ents.FindByClass("ttt_minictest"))

            if mimicCount > 0 then
                for k, v in pairs(player.GetAll()) do
                    if v:GetRole() == ROLE_TRAITOR or v.IsTraitorTeam and v:IsTraitorTeam() then
                        v:PrintMessage(HUD_PRINTTALK, mimicCount .. " mimics spawned")
                    end
                end
            end

            if SERVER then
                self:Remove()
            end
        end
    elseif class == "weapon_enfield_4" then
        -- Fixes the lee enfield not being able to be shot sometimes, and erroring
        SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize
        local FireSound = Sound("weapons/enfield_fire.wav")

        function SWEP:PrimaryAttack()
            local owner = self:GetOwner()
            if not IsValid(owner) then return end
            self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
            self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
            if not self:CanPrimaryAttack() then return end
            self:EmitSound(FireSound)
            self:ShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
            self:TakePrimaryAmmo(1)
            if owner:IsNPC() then return end
            owner:ViewPunch(Angle(math.Rand(-0.2, -0.1) * self.Primary.Recoil, math.Rand(-0.1, 0.1) * self.Primary.Recoil, 0))
        end
    elseif class == "weapon_ttt_homebat" and CLIENT then
        -- Fixes lua error with the homerun bat
        net.Receive("Bat Primary Hit", function()
            local tr, _, wep = net.ReadTable(), net.ReadEntity(), net.ReadEntity()
            local ent = tr.Entity
            if not IsValid(ent) then return end
            local edata = EffectData()
            edata:SetStart(tr.StartPos)
            edata:SetOrigin(tr.HitPos)
            edata:SetNormal(tr.Normal)
            edata:SetSurfaceProp(tr.SurfaceProps)
            edata:SetHitBox(tr.HitBox)
            edata:SetEntity(ent)
            local isply = ent:IsPlayer()

            if isply and ent:GetClass() == "prop_ragdoll" then
                if isply then
                    wep:EmitSound("Bat.Sound")

                    timer.Simple(.48, function()
                        if IsValid(ent) and IsValid(wep) and ent:Alive() then
                            wep:EmitSound("Bat.HomeRun")
                        end
                    end)
                end

                util.Effect("BloodImpact", edata)
            else
                util.Effect("Impact", edata)
            end
        end)
    elseif class == "weapons_ttt_time_manipulator" then
        -- Fix using wrong slot number (Weapon kind is WEAPON_EQUIP1)
        SWEP.Slot = 6

        -- Fixes lua errors with the time manipulator
        function SWEP:PrimaryAttack()
            if not self:CanPrimaryAttack() then return end
            self:TakePrimaryAmmo(1)
            self:SetNextPrimaryFire(CurTime() + 5)
            self:SetNextSecondaryFire(CurTime() + 5)
            self:GetOwner():PrintMessage(HUD_PRINTTALK, "Slowed down time!")

            if SERVER then
                game.SetTimeScale(GetConVar("tm_slowdown"):GetFloat())
            end

            timer.Simple(5, function()
                if SERVER then
                    game.SetTimeScale(1)
                end

                if IsValid(self) and IsPlayer(self:GetOwner()) then
                    self:GetOwner():PrintMessage(HUD_PRINTTALK, "Sped up time!")
                end
            end)
        end

        function SWEP:SecondaryAttack()
            if not self:CanPrimaryAttack() then return end
            self:TakePrimaryAmmo(1)
            self:SetNextPrimaryFire(CurTime() + 30)
            self:SetNextSecondaryFire(CurTime() + 30)
            self:GetOwner():PrintMessage(HUD_PRINTTALK, "Sped up time!")

            if SERVER then
                game.SetTimeScale(GetConVar("tm_speedup"):GetFloat())
            end

            timer.Simple(30, function()
                if SERVER then
                    game.SetTimeScale(1)
                end

                if IsValid(self) and IsPlayer(self:GetOwner()) then
                    self:GetOwner():PrintMessage(HUD_PRINTTALK, "Slowed down time!")
                end
            end)
        end
    elseif class == "ttt_amaterasu" then
        -- Fixes lua error with the amatratsu weapon
        hook.Add("PlayerHurt", "AmaterasuCheck", function(target, attacker, healthremaining, damagetaken)
            if IsValid(target) and target:IsPlayer() and target:GetNWBool("amatBurning") and IsValid(attacker) and attacker:IsPlayer() then
                local wep = attacker:GetActiveWeapon()

                if IsValid(wep) and wep:GetClass() == "weapon_zm_improvised" then
                    target:SetNWBool("amatBurning", false)
                    target:Extinguish()
                end
            end
        end)
    elseif class == "ttt_cmdpmpt" and SERVER then
        -- Fixes many bugs with the "command prompt" weapon
        function SWEP:PrimaryAttack()
            local ply = self:GetOwner()

            if self.cmdpmptused ~= true then
                self.cmdpmptused = true
                local passivestate = math.random(6)
                local selectedmode = 0

                if passivestate == 1 then
                    selectedmode = 1
                    ply:PrintMessage(HUD_PRINTCENTER, "Executing damage_pos_swap.exe .....")
                    self:Remove()
                elseif passivestate == 2 then
                    selectedmode = 2
                    ply:PrintMessage(HUD_PRINTCENTER, "Executing increased_speed_v2.exe .....")
                elseif passivestate == 3 then
                    selectedmode = 3
                    ply:PrintMessage(HUD_PRINTCENTER, "Executing equipmenthack_stealer.exe .....")
                    self:Remove()
                elseif passivestate == 4 then
                    selectedmode = 4
                    ply:PrintMessage(HUD_PRINTCENTER, "Executing traitor_spam_version2.exe .....")
                    self:Remove()
                elseif passivestate == 5 then
                    selectedmode = 5
                    ply:PrintMessage(HUD_PRINTCENTER, "Executing aimbot_assist.exe .....")
                    self:Remove()
                elseif passivestate == 6 then
                    selectedmode = 6
                    ply:PrintMessage(HUD_PRINTCENTER, "Executing forcefield.exe .....")
                    self:Remove()
                else
                    ply:ChatPrint("Failed to execute aimbot_v2_cracked.drklt , unrecognised file type. Please try again.")
                    ply:PrintMessage(HUD_PRINTCENTER, "Failed to execute aimbot_v2_cracked.drklt , unrecognised file type. Please try again.")
                    self.cmdpmptused = nil
                    ply:EmitSound("weapons/cmdpmpt/viruserror.wav")

                    return
                end

                net.Start("commandpromptopen")
                net.Send(ply)
                hook.Add("PlayerDisconnected", "cmdpmptdisconnect", lifeforcedisconnect)
                hook.Add("PlayerDeath", "cmdpmptdeath", cmdpmptplayerdeath)
                hook.Add("TTTEndRound", "cmdpmptroundend", cmdpmptend)
                hook.Add("TTTPrepareRound", "cmdpmptroundprep", cmdpmptend)

                timer.Create("cmdpromptgiveability" .. ply:AccountID(), 5, 1, function()
                    if selectedmode == 1 then
                        hook.Add("EntityTakeDamage", "cmdpmpttakedamage", cmdpmpttakedamage)
                        ply:ChatPrint("COMMAND PROMPT: When taking damage from a player, you will swap positions with a random player. Has a 7 second cooldown.")
                        ply.cmdpmptmode = 1
                        hook.Call("TTTCMDPROMT", nil, ply, "position swap on damage")
                    elseif selectedmode == 2 then
                        hook.Add("TTTPlayerSpeedModifier", "cmdpmptspeed", cmdpmptspeed)
                        ply:ChatPrint("COMMAND PROMPT: You will now have increased speed. Right-Click a player to toggle their speed. Can be used on a maximum of 2 other players.")
                        self.cmdpmptspeedleft = 2
                        ply.cmdpmptmode = 2
                        hook.Call("TTTCMDPROMT", nil, ply, "speed buff")
                    elseif selectedmode == 3 then
                        hook.Add("TTTOrderedEquipment", "cmdpmptequipment", cmdpmpttequip)
                        ply:ChatPrint("COMMAND PROMPT: Program active and running in background. When a T next buys a weapon it'll strip them of it and you will recieve the weapon instead.")
                        ply.cmdpmptmode = 3

                        for k, v in pairs(player.GetAll()) do
                            if v:Alive() and IsValid(v) and v:IsPlayer() and not v:GetNWBool("SpecDM_Enabled", false) and v:GetRole() == ROLE_TRAITOR then
                                net.Start("commandprompstealer")
                                net.Send(v)
                            end
                        end

                        hook.Call("TTTCMDPROMT", nil, ply, "equipment stealer")
                    elseif selectedmode == 4 then
                        hook.Add("Think", "cmdpmptnearbyhack", nearbyhack)
                        ply:ChatPrint("COMMAND PROMPT: When traitors get near you their screens will become blocked with adware. The closer they get the more there are.")
                        ply.cmdpmptmode = 4

                        for k, v in pairs(player.GetAll()) do
                            if v:Alive() and IsValid(v) and v:IsPlayer() and not v:GetNWBool("SpecDM_Enabled", false) and v:GetRole() == ROLE_TRAITOR then
                                net.Start("commandprompnearbystart")
                                net.Send(v)
                            end
                        end

                        hook.Call("TTTCMDPROMT", nil, ply, "traitor spammer")
                    elseif selectedmode == 5 then
                        hook.Add("KeyPress", "cmdpmptkeypress", aimhack)
                        hook.Add("EntityTakeDamage", "cmdpmpttakedamage", cmdpmpttakedamage)
                        ply:ChatPrint("COMMAND PROMPT: You will now have assisted aim with any weapon. You will gain an extra 50 health. However, you will only do 70% of the original damage.")
                        ply:SetMaxHealth(150)
                        ply:SetHealth(ply:Health() + 50)
                        ply.cmdpmptmode = 5
                        hook.Call("TTTCMDPROMT", nil, ply, "aim assist")
                    elseif selectedmode == 6 then
                        hook.Add("EntityTakeDamage", "cmdpmpttakedamage", cmdpmpttakedamage)
                        ply:ChatPrint("COMMAND PROMPT: You will now have a forcefield, you will take 60% less damage if the attacker is too far away.")
                        ply.cmdpmptmode = 6
                        hook.Call("TTTCMDPROMT", nil, ply, "forcefield")
                    else
                        ply:ChatPrint("COMMAND PROMPT: Failed to execute aimbot_v2_cracked.drklt , unrecognised file type. Please try again.")

                        return
                    end
                end)
            end
        end
    elseif class == "weapon_ttt_obc" then
        -- Fixes error spam with the orbital base cannon weapon
        local function BassCannonStart(tr, trace, wep, hitPlayer)
            local tracedata2 = {}
            tracedata2.start = trace.HitPos
            tracedata2.endpos = trace.HitPos + Vector(0, 0, -50000)
            tracedata2.filter = ents.GetAll()
            local trace2 = util.TraceLine(tracedata2)
            wep.glow = ents.Create("env_lightglow")
            wep.glow:SetKeyValue("rendercolor", "255 255 255")
            wep.glow:SetKeyValue("VerticalGlowSize", "50")
            wep.glow:SetKeyValue("HorizontalGlowSize", "150")
            wep.glow:SetKeyValue("MaxDist", "200")
            wep.glow:SetKeyValue("MinDist", "1")
            wep.glow:SetKeyValue("HDRColorScale", "100")
            local hitPlayerPos = nil

            if hitPlayer then
                hitPlayerPos = hitPlayer:GetPos()
                wep.glow:SetPos(hitPlayerPos + Vector(0, 0, 32))
            else
                wep.glow:SetPos(trace2.HitPos + Vector(0, 0, 32))
            end

            wep.glow:Spawn()
            wep.glow2 = ents.Create("env_lightglow")
            wep.glow2:SetKeyValue("rendercolor", "53 255 253")
            wep.glow2:SetKeyValue("VerticalGlowSize", "100")
            wep.glow2:SetKeyValue("HorizontalGlowSize", "100")
            wep.glow2:SetKeyValue("MaxDist", "300")
            wep.glow2:SetKeyValue("MinDist", "1")
            wep.glow2:SetKeyValue("HDRColorScale", "100")

            if hitPlayer then
                wep.glow2:SetPos(hitPlayerPos + Vector(0, 0, 32))
            else
                wep.glow2:SetPos(trace2.HitPos + Vector(0, 0, 32))
            end

            wep.glow2:Spawn()
            wep.glow3 = ents.Create("env_lightglow")
            wep.glow3:SetKeyValue("rendercolor", "255 255 255")
            wep.glow3:SetKeyValue("VerticalGlowSize", "10")
            wep.glow3:SetKeyValue("HorizontalGlowSize", "30")
            wep.glow3:SetKeyValue("MaxDist", "400")
            wep.glow3:SetKeyValue("MinDist", "1")
            wep.glow3:SetKeyValue("HDRColorScale", "100")

            if hitPlayer then
                wep.glow3:SetPos(hitPlayerPos + Vector(0, 0, 27000))
            else
                wep.glow3:SetPos(trace2.HitPos + Vector(0, 0, 27000))
            end

            wep.glow3:Spawn()
            wep.targ = ents.Create("info_target")
            wep.targ:SetKeyValue("targetname", tostring(wep.targ))

            if hitPlayer then
                wep.targ:SetPos(hitPlayerPos + Vector(0, 0, -50000))
            else
                wep.targ:SetPos(tr.HitPos + Vector(0, 0, -50000))
            end

            wep.targ:Spawn()
            wep.laser = ents.Create("env_laser")
            wep.laser:SetKeyValue("texture", "beam/laser01.vmt")
            wep.laser:SetKeyValue("TextureScroll", "100")
            wep.laser:SetKeyValue("noiseamplitude", "1.5")
            wep.laser:SetKeyValue("width", "512")
            wep.laser:SetKeyValue("damage", "10000")
            wep.laser:SetKeyValue("rendercolor", "255 255 255")
            wep.laser:SetKeyValue("renderamt", "255")
            wep.laser:SetKeyValue("dissolvetype", "0")
            wep.laser:SetKeyValue("lasertarget", tostring(wep.targ))

            if hitPlayer then
                wep.laser:SetPos(hitPlayerPos)
            else
                wep.laser:SetPos(trace.HitPos)
            end

            wep.laser:Spawn()
            wep.laser:Fire("turnon", 0)
            wep.effects = ents.Create("effects")

            if hitPlayer then
                wep.effects:SetPos(hitPlayerPos)
            else
                wep.effects:SetPos(trace.HitPos)
            end

            wep.effects:Spawn()
            wep.remover = ents.Create("remover")

            if hitPlayer then
                wep.remover:SetPos(hitPlayerPos)
            else
                wep.remover:SetPos(trace.HitPos)
            end

            wep.remover:Spawn()
            wep.blastwave = ents.Create("blastwave")

            if hitPlayer then
                wep.blastwave:SetPos(hitPlayerPos)
            else
                wep.blastwave:SetPos(trace2.HitPos)
            end

            wep.blastwave:Spawn()
        end

        function SWEP:PrimaryAttack()
            if not IsFirstTimePredicted() then return end
            local tr = self:GetOwner():GetEyeTrace()
            local hitPlayer = nil

            if IsPlayer(tr.Entity) then
                hitPlayer = tr.Entity
            end

            local tracedata = {}
            tracedata.start = tr.HitPos + Vector(0, 0, 0)
            tracedata.endpos = tr.HitPos + Vector(0, 0, 50000)
            tracedata.filter = ents.GetAll()
            local trace = util.TraceLine(tracedata)

            if trace.HitSky == true then
                hitsky = true
            else
                hitsky = true
            end

            if hitsky == true then
                self:GetOwner():SetAnimation(PLAYER_ATTACK1)
                self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
            else
                self:EmitSound(FailSound)
            end

            if not SERVER then return end

            if hitsky == true then
                self:TakePrimaryAmmo(1)

                if hitPlayer then
                    hitPlayer:EmitSound("OBC/LTBCKI.wav", 125, 100)
                else
                    sound.Play("OBC/LTBCKI.wav", tr.HitPos, 125, 100)
                end

                timer.Simple(5, function()
                    BassCannonStart(tr, trace, self, hitPlayer)
                end)

                timer.Simple(18, function()
                    kill(self)
                end)
            end
        end
    elseif class == "weapon_banana" then
        function SWEP:SecondaryAttack()
            if SERVER then
                timer.Simple(0.3, function()
                    if not IsValid(self) then return end
                    local owner = self:GetOwner()
                    if not IsValid(owner) then return end
                    owner:EmitSound(self.Sounds["Squeeze" .. math.random(1, 3)])
                    self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
                end)
            end

            self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
            self:SetNextPrimaryFire(CurTime() + 0.14)
            self:SetNextSecondaryFire(CurTime() + 1)

            -- Gotta love some globals polution...
            if newFuse and CLIENT then
                timer.Simple(0.7, function()
                    newFuse = true
                end)

                newFuse = false

                if fuseTime <= 0.125 then
                    fuseTime = baseFuseTime
                else
                    if fuseTime >= 2 and fuseTime < 8 then
                        fuseTime = fuseTime - 1
                    else
                        fuseTime = fuseTime / 2
                    end
                end

                net.Start("smod_Banana_setFuseOnThrow")
                net.WriteFloat(fuseTime)
                net.SendToServer()
            end

            return false
        end
    elseif class == "weapon_ttt_brain_parasite" then
        SWEP.IsSilent = true
        SWEP.Primary.Sound = Sound("Weapon_USP.SilencedShot")
        SWEP.Primary.SoundLevel = 50
        SWEP.IronSightsPos = Vector(-5.91, -4, 2.84)
        SWEP.IronSightsAng = Vector(-0.5, 0, 0)
        SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK_SILENCED
        SWEP.ReloadAnim = ACT_VM_RELOAD_SILENCED
        SWEP.Primary.Recoil = 1.35
        SWEP.Primary.Damage = 1
        SWEP.Primary.Delay = 0.38
        SWEP.Primary.Cone = 0.02
        SWEP.Primary.ClipSize = 1
        SWEP.Primary.Automatic = true
        SWEP.Primary.DefaultClip = 1
        SWEP.Primary.ClipMax = 1

        if CLIENT then
            SWEP.PrintName = "Brain Parasite"

            SWEP.EquipMenuData = {
                type = "item_weapon",
                desc = "Silenced pistol loaded with parasites that force the target to shoot arbitrarily.\n\nThe parasite kills the victim 20 seconds after infection.\n\n1 dart."
            }
        end

        function SWEP:Deploy()
            self:SendWeaponAnim(ACT_VM_DRAW_SILENCED)

            return self.BaseClass.Deploy(self)
        end

        function SWEP:PrimaryAttack()
            if not self:CanPrimaryAttack() then return end
            local owner = self:GetOwner()
            if not IsValid(owner) then return end
            self:TakePrimaryAmmo(1)
            self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
            self:ShootEffects()
            owner:EmitSound(self.Primary.Sound)

            if owner:IsPlayer() then
                owner:ViewPunch(Angle(math.Rand(-0.2, -0.1) * self.Primary.Recoil, math.Rand(-0.1, 0.1) * self.Primary.Recoil, 0))
            end

            if CLIENT or not IsFirstTimePredicted() then return end
            local tr = owner:GetEyeTrace()
            local victim = tr.Entity
            if not IsPlayer(victim) then return end
            victim.BrainParasiteActive = true
            victim:ConCommand("+attack")
            local attacker = owner

            timer.Simple(20, function()
                if IsValid(victim) and victim.BrainParasiteActive then
                    victim.BrainParasiteActive = nil
                    victim:ConCommand("-attack")
                    local dmg = DamageInfo()

                    if not IsValid(attacker) then
                        attacker = victim
                    end

                    dmg:SetInflictor(ents.Create("weapon_ttt_brain_parasite"))
                    dmg:SetAttacker(attacker)
                    dmg:SetDamage(10000)
                    dmg:SetDamageType(DMG_BULLET)
                    victim:TakeDamageInfo(dmg)
                end
            end)

            hook.Add("PostPlayerDeath", "BrainParasiteDeath", function(ply)
                ply.BrainParasiteActive = nil
                victim:ConCommand("-attack")
            end)

            hook.Add("TTTPrepareRound", "BrainParasiteReset", function()
                for _, ply in player.Iterator() do
                    if ply.BrainParasiteActive then
                        ply.BrainParasiteActive = nil
                        victim:ConCommand("-attack")
                    end
                end

                hook.Remove("PostPlayerDeath", "BrainParasiteDeath")
                hook.Remove("TTTPrepareRound", "BrainParasiteReset")
            end)
        end
    elseif class == "giantsupermariomushroom" then
        -- Fix for when TTT2 is not installed
        SWEP.PrintName = "Mario Mushroom"

        function SWEP:OwnerChanged()
            local owner = self:GetOwner()
            if not IsValid(owner) then return end
            owner.GetSubRoleModel = owner.GetSubRoleModel or function(ply) return ply:GetModel() end

            owner.SetSubRoleModel = owner.SetSubRoleModel or function(ply, model)
                FindMetaTable("Entity").SetModel(ply, model)
            end
        end
    elseif class == "ttt_kamehameha_swep" then
        -- Fix lua error when firing the kamehameha and the weapon is removed (e.g. the player dies before it goes off)
        -- Fix multiple players shooting the beam causing errors/stopping the other player from shooting
        SWEP.OldPrimaryAttack = SWEP.PrimaryAttack

        function SWEP:PrimaryAttack(arguments)
            self:OldPrimaryAttack()
            timer.Remove("FinalHA")
            local owner = self:GetOwner()
            if not IsValid(owner) then return end

            timer.Simple(3.4, function()
                if not IsValid(owner) or not IsValid(self) then return end
                owner:Freeze(true)
                BroadcastLua("surface.PlaySound(\"weapons/shoot/ha.wav\")")
                local timerName = "TTTKamehamehaBeam" .. owner:SteamID64()

                timer.Create(timerName, 0.01, 50, function()
                    if not IsValid(owner) or not IsValid(self) then
                        timer.Remove(timerName)

                        return
                    end

                    local bullet = {}
                    bullet.Src = owner:GetShootPos()
                    bullet.Dir = owner:GetAimVector()
                    bullet.Spread = Vector(0, 0, 0)
                    bullet.Num = 1
                    bullet.Tracer = 1
                    bullet.Damage = 30
                    bullet.TracerName = "kamebeam"
                    self:TakePrimaryAmmo(1)
                    owner:FireBullets(bullet)
                    local effects = EffectData()
                    local trace = owner:GetEyeTrace()
                    effects:SetOrigin(trace.HitPos + Vector(math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.5)))
                    effects:SetScale(10)
                    effects:SetRadius(200)
                    effects:SetMagnitude(3.1)
                    effects:SetAngles(Angle(0, 90, 0))
                    util.Effect("beampact", effects)
                    util.BlastDamage(self, self, trace.HitPos, 200, 170)
                    sound.Play("weapons/explosion/dbzexplosion.wav", trace.HitPos, 180)
                end)
            end)
        end
    elseif class == "tfa_gun_base" then
        -- Fix errors when trying to acces an invalid player in TFA guns, e.g. when a player has just died
        SWEP.OldCalculateViewModelOffset = SWEP.CalculateViewModelOffset

        function SWEP:CalculateViewModelOffset(...)
            if not IsValid(self:GetOwner()) then return end

            return self:OldCalculateViewModelOffset(...)
        end

        SWEP.OldDrawKeyBindHints = SWEP.DrawKeyBindHints

        function SWEP:DrawKeyBindHints(...)
            if not IsValid(self:GetOwner()) then return end

            return self:OldDrawKeyBindHints(...)
        end

        SWEP.OldDrawHUDAmmo = SWEP.DrawHUDAmmo

        function SWEP:DrawHUDAmmo(...)
            if not IsValid(self:GetOwner()) then return end
            self:OldDrawHUDAmmo(...)
        end

        SWEP.OldRecoil = SWEP.Recoil

        function SWEP:Recoil(...)
            if not IsValid(self:GetOwner()) then return end
            self:OldRecoil(...)
        end
    elseif class == "stungun" and CLIENT then
        -- Fix lua error when the weapon is stripped
        timer.Simple(0, function()
            net.Receive("tazerondrop", function()
                local ent = net.ReadEntity()

                if IsValid(ent) and ent.OnDrop and isfunction(ent.OnDrop) then
                    ent:OnDrop()
                end
            end)
        end)
    elseif class == "weapon_portalgun" and SERVER then
        -- Fix performance issue on the server where the portal gun is checking for visible portals even when the portal gun is not being used
        -- "SetupPlayerVisibility" is a very costly hook that is called multiple times a server tick
        hook.Remove("SetupPlayerVisibility", "PORTALGUN_PORTAL_SETUPVIS")

        function SWEP:Initialize()
            self:SetWeaponHoldType("shotgun")

            hook.Add("SetupPlayerVisibility", "PORTALGUN_PORTAL_SETUPVIS", function()
                -- Also, this was originally being called with "pairs(ents.GetAll())" (very slow for something called so often...)
                for _, ent in ents.Iterator() do
                    if ent:GetClass() == "portalgun_portal" then
                        AddOriginToPVS(ent:GetPos())
                    end
                end
            end)

            hook.Add("TTTPrepareRound", "PORTALGUN_PORTAL_SETUPVIS_RESET", function()
                hook.Remove("SetupPlayerVisibility", "PORTALGUN_PORTAL_SETUPVIS")
                hook.Remove("TTTPrepareRound", "PORTALGUN_PORTAL_SETUPVIS_RESET")
            end)
        end
    elseif class == "weapon_ttt_beartrap" then
        -- Fix the bear trap damaging players over on the next round, if they are trapped as the round restarts
        function SWEP:Initialize()
            hook.Add("TTTPrepareRound", "TTTTweaksBearTrapReset", function()
                for _, ply in player.Iterator() do
                    local timername = "beartrapdmg" .. ply:EntIndex()

                    if timer.Exists(timername) then
                        timer.Remove(timername)
                        ply.IsTrapped = false
                        ply:Freeze(false)
                    end
                end

                hook.Remove("TTTPrepareRound", "TTTTweaksBearTrapReset")
            end)
        end
    elseif class == "weapon_ttt_demonsign" then
        -- Fixed the demonic possession error spamming if it goes unused for the round, after being placed down and the round restarts
        SWEP.OldInitialize = SWEP.Initialize

        function SWEP:Initialize()
            hook.Add("PlayerDisconnected", "TTTTweaksDemonicPossessionReset", function(ply)
                hook.Remove("StartCommand", "Demon_MoveVictim" .. ply:Nick())
            end)

            hook.Add("TTTPrepareRound", "TTTTweaksDemonicPossessionReset", function()
                for _, ply in player.Iterator() do
                    hook.Remove("StartCommand", "Demon_MoveVictim" .. ply:Nick())
                end
            end)

            return self:OldInitialize()
        end

        if CLIENT then
            SWEP.OldPrimaryAttack = SWEP.PrimaryAttack

            function SWEP:PrimaryAttack()
                self:OldPrimaryAttack()
                local owner = self:GetOwner()
                if not IsValid(owner) then return end
                local hooks = hook.GetTable()["StartCommand"]
                local hookId = "Demon_MoveVictim" .. owner:Nick()
                local oldFn = hooks[hookId]

                hook.Add("StartCommand", hookId, function(ply, ucmd)
                    if not IsValid(self) or not oldFn then return end
                    oldFn(ply, ucmd)
                end)
            end
        end
    elseif class == "ttt_weapon_lasso" then
        -- Fixes the lasso removing PAP upgrades from weapons and not restoring remaining ammo in the clip properly
        local LASSO_SAFE_DIST = 80
        local LASSO_RETURN_SPEED = 800
        local LASSO_RAGDOLL_FORWARD_OFFSET = 55
        local LASSO_RAGDOLL_SIDE_OFFSET = 35
        local LASSO_PULL_FORCE_MULT = 35
        local LASSO_RAGDOLL_PULL_FORCE_MULT = 10
        local LASSO_PULL_DAMPING = 10
        local LASSO_PULL_MAX_SPEED = 1200
        local LASSO_RAGDOLL_PULL_MAX_SPEED = 350
        local LASSO_PULL_RESPONSE = 0.85
        local LASSO_RAGDOLL_PULL_RESPONSE = 0.45
        local LASSO_TARGET_ARRIVE_DIST = 70
        local LASSO_PULL_MAX_TIME = 2.25
        local LASSO_PLAYER_COOLDOWN = 4
        local LASSO_PLAYER_RAGDOLL_EXTRA_TIME = 2
        local LASSO_SPIN_SPEED_RETURN = 20
        local LASSO_SET_POS_MAGNITUDE = 15
        local LASSO_SET_POS_ITERATIONS = 2

        local function LassoPlayerInvis(ply, invisible)
            if not IsValid(ply) then return end
            ply:SetNoDraw(invisible)
            ply:DrawShadow(not invisible)
        end

        local lassoHullTraceData = {}

        local function LassoPlayerHullTrace(pos, ply, filter)
            lassoHullTraceData.start = pos
            lassoHullTraceData.endpos = pos
            lassoHullTraceData.filter = filter

            return util.TraceEntity(lassoHullTraceData, ply)
        end

        local lassoSetPosDirections = {Vector(0, 0, 0), Vector(0, 0, 1), Vector(1, 0, 0), Vector(-1, 0, 0), Vector(0, 1, 0), Vector(0, -1, 0)}

        for deg = 45, 315, 90 do
            local r = math.rad(deg)
            table.insert(lassoSetPosDirections, Vector(math.Round(math.cos(r)), math.Round(math.sin(r)), 0))
        end

        local function LassoPlayerSetPosNoBlock(ply, pos, filter)
            if not IsValid(ply) then return false end
            local tr
            local dirvec
            local magnitude = LASSO_SET_POS_MAGNITUDE
            local directionIndex = 1
            local iteration = 1
            repeat
                dirvec = lassoSetPosDirections[directionIndex] * magnitude
                directionIndex = directionIndex + 1

                if directionIndex > #lassoSetPosDirections then
                    iteration = iteration + 1
                    directionIndex = 1
                    magnitude = magnitude + LASSO_SET_POS_MAGNITUDE

                    if iteration > LASSO_SET_POS_ITERATIONS then
                        ply:SetPos(pos)

                        return false
                    end
                end

                tr = LassoPlayerHullTrace(pos + dirvec, ply, filter)
            until tr.Hit == false
            ply:SetPos(pos + dirvec)

            return true
        end

        local function LassoRetrieveWeapons(ply)
            if not IsValid(ply) then return end
            local papData = ply.lassoPAPData or {}

            for _, stored in ipairs(ply.lassoStoredWeapons or {}) do
                if stored.class then
                    local wep = ply:Give(stored.class)

                    if IsValid(wep) then
                        -- Re-apply PAP upgrades that were stripped by the lasso
                        local upgrade = papData[stored.class]

                        if upgrade then
                            wep.PAPUpgrade = upgrade

                            if TTTPAP and TTTPAP.ApplyUpgrade then
                                TTTPAP:ApplyUpgrade(wep, upgrade)
                            end
                        end

                        if stored.clip1 ~= nil then
                            wep:SetClip1(stored.clip1)
                        end

                        if stored.clip2 ~= nil then
                            wep:SetClip2(stored.clip2)
                        end
                    end
                end
            end

            ply.lassoStoredWeapons = nil
            ply.lassoPAPData = nil
        end

        local function EndLassoRagdoll(ply, finalPos)
            if not IsValid(ply) then return end
            local rag = ply.lassoRagdoll
            local ragValid = IsValid(rag)
            local wasLassoRagdolled = ragValid or ply:GetNWBool("LassoRagdolled", false) or ply.lassoOldMoveType ~= nil or ply.lassoOldCollisionGroup ~= nil or ply.lassoStoredWeapons ~= nil
            ply:SetNWBool("LassoRagdolled", false)
            ply:SetNWEntity("LassoViewRagdoll", NULL)

            if not wasLassoRagdolled then
                if ply.lassoNeedsVisibleOnSpawn and ply:Alive() and not (ply.IsSpec and ply:IsSpec()) then
                    LassoPlayerInvis(ply, false)
                    ply.lassoNeedsVisibleOnSpawn = nil
                end

                return
            end

            if not ply:Alive() or (ply.IsSpec and ply:IsSpec()) then
                ply:SetParent(nil)

                if ragValid then
                    rag.lassoPlayer = nil
                    SafeRemoveEntity(rag)
                end

                ply.lassoRagdoll = nil
                ply.lassoOldMoveType = nil
                ply.lassoOldCollisionGroup = nil
                ply.lassoOldPos = nil
                ply.lassoStoredWeapons = nil
                ply.lassoPAPData = nil
                ply.lassoNeedsVisibleOnSpawn = true

                return
            end

            ply.lassoNeedsVisibleOnSpawn = nil
            local pos = finalPos

            if not pos then
                if ragValid then
                    pos = rag:GetPos()
                elseif ply.lassoOldPos then
                    pos = ply.lassoOldPos
                else
                    pos = ply:GetPos()
                end
            end

            ply:SetParent(nil)
            ply:SetMoveType(ply.lassoOldMoveType or MOVETYPE_WALK)
            ply:SetCollisionGroup(ply.lassoOldCollisionGroup or COLLISION_GROUP_PLAYER)
            LassoPlayerInvis(ply, false)

            if ragValid then
                LassoPlayerSetPosNoBlock(ply, pos + Vector(0, 0, 5), {ply, rag})

                rag.lassoPlayer = nil
                SafeRemoveEntity(rag)
            else
                LassoPlayerSetPosNoBlock(ply, pos + Vector(0, 0, 5), {ply})
            end

            timer.Simple(0, function()
                if IsValid(ply) and ply:Alive() and not (ply.IsSpec and ply:IsSpec()) then
                    LassoPlayerInvis(ply, false)
                end
            end)

            timer.Simple(0.1, function()
                if IsValid(ply) and ply:Alive() and not (ply.IsSpec and ply:IsSpec()) then
                    LassoRetrieveWeapons(ply)
                end
            end)

            ply.lassoRagdoll = nil
            ply.lassoOldMoveType = nil
            ply.lassoOldCollisionGroup = nil
            ply.lassoOldPos = nil
        end

        local function EndGhostPull(ent)
            if not IsValid(ent) then return end
            ent:SetNotSolid(false)
            ent:SetCollisionGroup(ent.__lasso_oldColl or COLLISION_GROUP_NONE)
            ent:SetMoveType(ent.__lasso_oldMoveType or MOVETYPE_STEP)
            local phys = ent:GetPhysicsObject()

            if IsValid(phys) and ent.__lasso_physWasMotion ~= nil then
                phys:EnableMotion(ent.__lasso_physWasMotion)

                if ent.__lasso_physWasMotion then
                    phys:Wake()
                end
            end

            ent.__lasso_oldMoveType = nil
            ent.__lasso_oldColl = nil
            ent.__lasso_oldSolid = nil
            ent.__lasso_physWasMotion = nil
        end

        local function CleanupPulledTarget(target, targetPlayer)
            if IsValid(targetPlayer) then
                EndLassoRagdoll(targetPlayer)

                return
            end

            if IsValid(target) then
                EndGhostPull(target)
            end
        end

        local function GetLassoReturnPos(owner)
            if not IsValid(owner) then return Vector(0, 0, 0) end
            local bone = owner:LookupBone("ValveBiped.Bip01_R_Hand")

            if bone then
                local pos, ang = owner:GetBonePosition(bone)
                if pos and ang then return pos + ang:Up() * 10 + ang:Forward() * 4 end
            end

            return owner:GetShootPos() + owner:GetRight() * 12 - owner:GetUp() * 18
        end

        local function GetLassoModelAngle(dir, yawOffset)
            local ang = dir:Angle()
            ang:RotateAroundAxis(ang:Right(), 90)
            ang:RotateAroundAxis(ang:Right(), -20)
            ang.y = ang.y + (yawOffset or 0)

            return ang
        end

        local function ClampAboveGround(pos, target)
            local mins = Vector(-16, -16, 0)
            local maxs = Vector(16, 16, 72)

            if IsValid(target) then
                local obbMins = target:OBBMins()
                local obbMaxs = target:OBBMaxs()

                if obbMins and obbMaxs then
                    mins = Vector(obbMins.x, obbMins.y, 0)
                    maxs = Vector(obbMaxs.x, obbMaxs.y, math.max(obbMaxs.z - obbMins.z, 64))
                end
            end

            local start = pos + Vector(0, 0, 64)
            local finish = pos - Vector(0, 0, 2048)

            local tr = util.TraceHull({
                start = start,
                endpos = finish,
                mins = mins,
                maxs = maxs,
                mask = MASK_SOLID_BRUSHONLY,
                filter = function() return false end
            })

            if tr.Hit then
                local safeZ = tr.HitPos.z + 2

                if pos.z < safeZ then
                    pos.z = safeZ
                end
            end

            return pos
        end

        local function SetPhysAngularVelocityZero(phys)
            if not IsValid(phys) then return end

            if phys.SetAngleVelocity then
                phys:SetAngleVelocity(Vector(0, 0, 0))
            elseif phys.GetAngleVelocity and phys.AddAngleVelocity then
                phys:AddAngleVelocity(-phys:GetAngleVelocity())
            end
        end

        local function ApplyPullForceToPhysicsObject(phys, goalPos, dt, forceMult, maxSpeed, response)
            if not IsValid(phys) then return false end
            forceMult = forceMult or LASSO_PULL_FORCE_MULT
            maxSpeed = maxSpeed or LASSO_PULL_MAX_SPEED
            response = response or LASSO_PULL_RESPONSE
            phys:EnableMotion(true)
            phys:Wake()
            local pos = phys:GetPos()
            local offset = goalPos - pos
            local dist = offset:Length()
            if dist <= 1 then return true end
            local dir = offset:GetNormalized()
            local mass = math.max(phys:GetMass(), 1)
            local desiredSpeed = math.Clamp(dist * forceMult, 60, maxSpeed)

            if dist < LASSO_TARGET_ARRIVE_DIST then
                desiredSpeed = math.Clamp(dist * 3, 0, maxSpeed)
            end

            local desiredVelocity = dir * desiredSpeed
            local currentVelocity = phys:GetVelocity()
            local velocityDelta = (desiredVelocity - currentVelocity) * response
            local force = (velocityDelta * mass) / math.max(dt, 0.01)
            force = force - (currentVelocity * mass * LASSO_PULL_DAMPING)
            local maxForce = mass * 60000

            if force:Length() > maxForce then
                force = force:GetNormalized() * maxForce
            end

            phys:ApplyForceCenter(force)

            return true
        end

        local function ApplyPhysicsPull(target, goalPos, dt)
            if not IsValid(target) then return false end

            if target:GetClass() == "prop_ragdoll" then
                local ragPos = target:GetPos()
                local offset = goalPos - ragPos

                for i = 0, target:GetPhysicsObjectCount() - 1 do
                    local phys = target:GetPhysicsObjectNum(i)

                    if IsValid(phys) then
                        ApplyPullForceToPhysicsObject(phys, phys:GetPos() + offset, dt, LASSO_RAGDOLL_PULL_FORCE_MULT, LASSO_RAGDOLL_PULL_MAX_SPEED, LASSO_RAGDOLL_PULL_RESPONSE)
                    end
                end

                return true
            end

            local phys = target:GetPhysicsObject()
            if IsValid(phys) then return ApplyPullForceToPhysicsObject(phys, goalPos, dt, LASSO_PULL_FORCE_MULT, LASSO_PULL_MAX_SPEED, LASSO_PULL_RESPONSE) end

            return false
        end

        local function MoveNonPhysicsFallback(target, goalPos)
            if not IsValid(target) then return end
            local currentPos = target:GetPos()
            local dist = currentPos:Distance(goalPos)
            if dist <= 1 then return end
            local stepScale = math.Clamp(dist / 700, 0.05, 0.22)
            target:SetPos(LerpVector(stepScale, currentPos, goalPos))
        end

        local function PullTargetTowardGoal(target, goalPos, dt)
            if not IsValid(target) then return end
            local usedPhysics = ApplyPhysicsPull(target, goalPos, dt)

            if not usedPhysics then
                MoveNonPhysicsFallback(target, goalPos)
            end
        end

        local function StopPulledPhysics(target)
            if not IsValid(target) then return end

            if target:GetClass() == "prop_ragdoll" then
                for i = 0, target:GetPhysicsObjectCount() - 1 do
                    local phys = target:GetPhysicsObjectNum(i)

                    if IsValid(phys) then
                        phys:SetVelocity(Vector(0, 0, 0))
                        SetPhysAngularVelocityZero(phys)
                        phys:Wake()
                    end
                end

                return
            end

            local phys = target:GetPhysicsObject()

            if IsValid(phys) then
                phys:SetVelocity(Vector(0, 0, 0))
                SetPhysAngularVelocityZero(phys)
                phys:Wake()
            end
        end

        local function GetTargetDistanceToGoal(target, goalPos)
            if not IsValid(target) then return 0 end
            if target:GetClass() == "prop_ragdoll" then return target:GetPos():Distance(goalPos) end
            local phys = target:GetPhysicsObject()
            if IsValid(phys) then return phys:GetPos():Distance(goalPos) end

            return target:GetPos():Distance(goalPos)
        end

        function SWEP:LassoReturn(owner, lassoModel, rope, target, targetPlayer)
            if not IsValid(owner) then
                if IsValid(lassoModel) then
                    if lassoModel.LassoSound then
                        lassoModel.LassoSound:Stop()
                    end

                    lassoModel:Remove()
                end

                if IsValid(rope) then
                    rope:Remove()
                end

                CleanupPulledTarget(target, targetPlayer)
                self.LassoActive = false
                local revealDelay = math.max((self:GetNextPrimaryFire() or CurTime()) - CurTime(), 0)
                self:ScheduleHeldLassoReveal(revealDelay)

                return
            end

            local timerRet = "Lasso_Return_" .. self:EntIndex()
            local lassoYawOffset = 0
            local pullStartTime = CurTime()

            timer.Create(timerRet, 0.01, 0, function()
                if not IsValid(self) or not IsValid(owner) or not IsValid(lassoModel) then
                    if IsValid(lassoModel) then
                        if lassoModel.LassoSound then
                            lassoModel.LassoSound:Stop()
                        end

                        lassoModel:Remove()
                    end

                    if IsValid(rope) then
                        rope:Remove()
                    end

                    CleanupPulledTarget(target, targetPlayer)
                    timer.Remove(timerRet)

                    if IsValid(self) then
                        self.LassoActive = false
                        local revealDelay = math.max((self:GetNextPrimaryFire() or CurTime()) - CurTime(), 0)
                        self:ScheduleHeldLassoReveal(revealDelay)
                    end

                    return
                end

                local handPos = GetLassoReturnPos(owner)
                local ownerAim = owner:GetAimVector()
                local goalPos

                if IsValid(targetPlayer) then
                    goalPos = owner:GetShootPos() + ownerAim * LASSO_RAGDOLL_FORWARD_OFFSET + owner:GetRight() * LASSO_RAGDOLL_SIDE_OFFSET
                else
                    goalPos = owner:GetShootPos() + ownerAim * LASSO_SAFE_DIST
                end

                goalPos = ClampAboveGround(goalPos, target)
                local pos = lassoModel:GetPos()
                local dirBack = (handPos - pos):GetNormalized()
                local newPos = pos + dirBack * (LASSO_RETURN_SPEED * FrameTime())
                lassoModel:SetPos(newPos)
                lassoYawOffset = lassoYawOffset + LASSO_SPIN_SPEED_RETURN
                lassoModel:SetAngles(GetLassoModelAngle(dirBack, lassoYawOffset))

                if IsValid(target) then
                    PullTargetTowardGoal(target, goalPos, FrameTime())
                end

                local lassoReturned = newPos:Distance(handPos) < 50
                local targetReachedGoal = not IsValid(target) or GetTargetDistanceToGoal(target, goalPos) <= LASSO_TARGET_ARRIVE_DIST
                local pullTimedOut = CurTime() - pullStartTime >= LASSO_PULL_MAX_TIME

                if lassoReturned and (targetReachedGoal or pullTimedOut) then
                    if IsValid(lassoModel) then
                        if lassoModel.LassoSound then
                            lassoModel.LassoSound:Stop()
                        end

                        lassoModel:Remove()
                    end

                    if IsValid(rope) then
                        rope:Remove()
                    end

                    if IsValid(targetPlayer) then
                        local nextFireTime = CurTime() + LASSO_PLAYER_COOLDOWN
                        self:SetNextPrimaryFire(nextFireTime)
                        self:SetNextSecondaryFire(nextFireTime)

                        if IsValid(target) then
                            StopPulledPhysics(target)
                        end

                        timer.Simple(LASSO_PLAYER_RAGDOLL_EXTRA_TIME, function()
                            if IsValid(targetPlayer) and IsValid(targetPlayer.lassoRagdoll) then
                                EndLassoRagdoll(targetPlayer)
                            end
                        end)

                        self.LassoActive = false
                        self:ScheduleHeldLassoReveal(nextFireTime - CurTime())
                    else
                        if IsValid(target) then
                            StopPulledPhysics(target)
                            EndGhostPull(target)
                        end

                        local revealDelay = math.max((self:GetNextPrimaryFire() or CurTime()) - CurTime(), 0)
                        self.LassoActive = false
                        self:ScheduleHeldLassoReveal(revealDelay)
                    end

                    timer.Remove(timerRet)
                end
            end)
        end

        -- Stores a weapon's PAP upgrade
        -- This is called just before ragdolling players and stripping their weapons in the original SWEP
        SWEP.OldBreakTetherOnPrimaryTarget = SWEP.BreakTetherOnPrimaryTarget

        function SWEP:BreakTetherOnPrimaryTarget(target)
            if IsValid(target) and target:IsPlayer() and not IsValid(target.lassoRagdoll) then
                target.lassoPAPData = {}

                for _, wep in ipairs(target:GetWeapons()) do
                    if IsValid(wep) and wep.PAPUpgrade then
                        target.lassoPAPData[wep:GetClass()] = wep.PAPUpgrade
                    end
                end
            end

            return self:OldBreakTetherOnPrimaryTarget(target)
        end

        hook.Add("PlayerDeath", "LassoCleanupRagdoll", function(ply)
            EndLassoRagdoll(ply)
            local tetherWeapon = ply:GetNWEntity("LassoTetherWeapon", NULL)

            if IsValid(tetherWeapon) and tetherWeapon.ClearTether then
                tetherWeapon:ClearTether(true)
            end

            for _, wep in ipairs(ents.FindByClass("weapon_ttt_lasso")) do
                if IsValid(wep) and wep.TetherTarget == ply then
                    wep:ClearTether(true)
                end
            end
        end)

        hook.Add("PlayerDisconnected", "LassoCleanupDisconnected", function(ply)
            EndLassoRagdoll(ply)
            local tetherWeapon = ply:GetNWEntity("LassoTetherWeapon", NULL)

            if IsValid(tetherWeapon) and tetherWeapon.ClearTether then
                tetherWeapon:ClearTether(true)
            end

            for _, wep in ipairs(ents.FindByClass("weapon_ttt_lasso")) do
                if IsValid(wep) and wep.TetherTarget == ply then
                    wep:ClearTether(true)
                end
            end
        end)

        hook.Add("PlayerSpawn", "LassoCleanupRagdollSpawn", function(ply)
            EndLassoRagdoll(ply)
            ply:SetNWBool("LassoRagdolled", false)
            ply:SetNWEntity("LassoViewRagdoll", NULL)
            local tetherWeapon = ply:GetNWEntity("LassoTetherWeapon", NULL)

            if IsValid(tetherWeapon) and tetherWeapon.ClearTether then
                tetherWeapon:ClearTether(true)
            else
                ply:SetNWBool("LassoTethered", false)
                ply:SetNWEntity("LassoTetherOwner", NULL)
                ply:SetNWEntity("LassoTetherWeapon", NULL)
                TTT_Lasso_TetherRegistry[ply] = nil
            end
        end)

        hook.Add("EntityRemoved", "LassoCleanupRemovedRagdoll", function(ent)
            if IsValid(ent.lassoPlayer) then
                EndLassoRagdoll(ent.lassoPlayer)
            end
        end)
    end
end)

-- 
-- 
-- Weapon entity fixes -------------------------------------------------------------------------------------------------------------------------------------------------
-- 
-- 
hook.Add("PreRegisterSENT", "StigTTTWeaponFixes", function(ENT, class)
    -- Fix custom entities setting ENT.WeaponID when it's only for default entities
    -- (Causes entity names to override each other on the end-of-round popup/round report)
    if ENT.WeaponID and not defaultTTTEnts[class] then
        ENT.WeaponID = nil
    end

    if class == "projectile_laser_sandbox" then
        -- Fixes a heck of a lua error dump spam whenever the orbital base cannon is used
        -- (10,000+ lines of errors...)
        function ENT:Initialize()
            self.Touched = {}
            self.OriginalAngles = self:GetAngles()
            self.flightvector = self:GetForward() * 40

            if SERVER then
                self:Fire("kill", "", 0.6)
            end

            self:SetModel("models/weapons/w_bugbait.mdl")
            self:DrawShadow(false)
            self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
            self:SetCustomCollisionCheck(true)
            self:PhysicsInit(SOLID_VPHYSICS)
            self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
            self:SetColor(Color(255, 255, 255, 0))
            self:SetMaterial("sprites/heatwave")

            if SERVER then
                self:SetTrigger(true)
            end

            self:SetCustomCollisionCheck(true)
        end

        function ENT:Think()
            local owner = self:GetOwner()
            local shootpos = owner:GetShootPos()
            local aimvector = owner:GetAimVector()
            local filter = owner

            local tr = util.TraceLine({
                start = shootpos,
                endpos = shootpos + aimvector * 50000,
                filter = filter
            })

            if not IsValid(tr.Entity) then
                tr = util.TraceHull({
                    start = shootpos,
                    endpos = shootpos + aimvector * 50000,
                    filter = filter,
                    mins = Vector(-3, -3, -3),
                    maxs = Vector(3, 3, 3)
                })
            end

            if CLIENT then
                self:SetRenderBoundsWS(self:GetEndPos(), self:GetPos(tr.HitPos), Vector() * 8)
            end

            if not self.Size then
                self.Size = 0
            end

            self.Size = math.Approach(self.Size, 1, 10 * FrameTime())
        end

        local matLight = Material("egon/muzzlelight")

        function ENT:Draw()
            self:DrawModel()
            local Owner = self:GetOwner()
            if not Owner or Owner == NULL then return end
            local owner = self:GetOwner()
            local shootpos = owner:GetShootPos()
            local aimvector = owner:GetAimVector()

            local filter = {Owner, Owner:GetActiveWeapon()}

            local tr = util.TraceLine({
                start = shootpos,
                endpos = shootpos + aimvector * 50000,
                filter = filter
            })

            if not IsValid(tr.Entity) then
                tr = util.TraceHull({
                    start = shootpos,
                    endpos = shootpos + aimvector * 50000,
                    filter = filter,
                    mins = Vector(-3, -3, -3),
                    maxs = Vector(3, 3, 3)
                })
            end

            local tr1 = util.TraceLine({
                start = shootpos,
                endpos = shootpos + aimvector * 1,
                filter = filter
            })

            if not IsValid(tr.Entity) then
                tr1 = util.TraceHull({
                    start = shootpos,
                    endpos = shootpos + aimvector * 1,
                    filter = filter,
                    mins = Vector(-3, -3, -3),
                    maxs = Vector(3, 3, 3)
                })
            end

            local StartPos = tr1.HitPos + self:GetOwner():GetForward() * 25 + self:GetOwner():GetUp() * 0 + self:GetOwner():GetRight() * 10
            local EndPos = tr.HitPos
            local ViewModel = Owner == LocalPlayer()
            local angle = self:SetAngles(Angle(-0, -0, -0))

            -- If it's the local player we start at the viewmodel
            if ViewModel then
                local vm1 = Owner:GetViewModel()
                if not vm1 or vm1 == NULL then return end
                local attachment = vm1:GetAttachment(1)

                if attachment then
                    StartPos = attachment.Pos
                else
                    -- If we're viewing another player we start at their weapon
                    local vm2 = Owner:GetActiveWeapon()
                    if not vm2 or vm2 == NULL then return end
                    attachment = vm2:GetAttachment(1)

                    if attachment then
                        StartPos1 = attachment.Pos
                    end
                end
            end

            -- Predict the endpoint, smoother, faster, harder, stronger
            tr.endpos = tr.HitPos

            tr.filter = {Owner, Owner:GetActiveWeapon()}

            EndPos = tr.HitPos
            -- Make the texture coords relative to distance so they're always a nice size
            local Distance = EndPos:Distance(StartPos) * self.Size
            angle = (EndPos - StartPos):Angle()
            local Normal = angle:Forward()
            render.SetMaterial(matLight)
            render.DrawQuadEasy(EndPos + tr.HitNormal, tr.HitNormal, 64 * self.Size, 64 * self.Size, color_white)
            render.DrawQuadEasy(EndPos + tr.HitNormal, tr.HitNormal, math.Rand(32, 128) * self.Size, math.Rand(32, 128) * self.Size, color_white)
            render.DrawSprite(EndPos + tr.HitNormal, 64, 64, Color(255, 150, 150, self.Size * 255))
            -- Draw the beam
            self:DrawMainBeam(StartPos, StartPos + Normal * Distance)
            -- Draw curly Beam
            self:DrawCurlyBeam(StartPos, StartPos + Normal * Distance, angle)
            -- Light glow coming from gun to hide ugly edges :x
            render.SetMaterial(matLight)
            render.DrawSprite(StartPos, 128, 128, Color(255, 0, 0, 255 * self.Size))
            render.DrawSprite(StartPos + Normal * 32, 64, 64, Color(255, 150, 150, 255 * self.Size))

            if not self.LastDecal or self.LastDecal < CurTime() then
                util.Decal("DarkEgonBurn", StartPos, StartPos + Normal * Distance * 1.1)
                self.LastDecal = CurTime() + 0.01
            end
        end
    elseif class == "ttt_shark_trap" then
        -- Fixes the shark trap not killing when it should
        -- and error spamming whenever touching something that is not a player
        function ENT:Touch(toucher)
            if not IsPlayer(toucher) or not IsValid(self) then return end
            toucher:Freeze(true)
            self:Remove()
            self:EmitSound("shark_trap.mp3", 100, 100, 1)
            local attacker = self:GetPlacer()

            timer.Simple(1.6, function()
                if not IsValid(toucher) then return end
                local effectData = EffectData()
                effectData:SetOrigin(toucher:GetPos())
                effectData:SetScale(20)
                effectData:SetMagnitude(20)
                util.Effect("watersplash", effectData)
                local shark = ents.Create("ttt_shark_ent")
                shark:SetPos(toucher:GetPos() + Vector(0, 0, -75))
                shark:SetAngles(Angle(90, 0, 0))
                shark:SetLocalVelocity(Vector(0, 0, 200))
                shark:Spawn()

                timer.Simple(0.5, function()
                    shark:SetLocalVelocity(Vector(0, 0, -300))
                end)

                --- Dmg Info ---
                local dmg = DamageInfo()
                local inflictor = ents.Create("ttt_shark_trap")

                if not IsValid(attacker) then
                    attacker = toucher
                end

                dmg:SetAttacker(attacker)
                dmg:SetInflictor(inflictor)
                dmg:SetDamage(10000)
                dmg:SetDamageType(DMG_DROWN)
                ------
                toucher:TakeDamageInfo(dmg)
                toucher:Freeze(false)

                timer.Simple(2.5, function()
                    if IsValid(shark) then
                        shark:Remove()
                    end
                end)
            end)
        end
    elseif class == "ttt_beenade_proj" then
        local function IsBee(ent)
            if ent:GetClass() == BeeNPCClass then
                for _, child in pairs(ent:GetChildren()) do
                    if not IsValid(child) then continue end
                    if child:GetModel() ~= "models/lucian/props/stupid_bee.mdl" then continue end

                    return true
                end
            end

            return false
        end

        -- Fixes beenade not dealing less damage to non-vanilla traitors and non-bee manhacks using bee damage convars and dropping bee corpses
        function BeeNadeDamage(victim, dmg)
            local attacker = dmg:GetAttacker()

            -- Fixed error when victim is nil
            -- Fixed non-bee manhacks using bee damage convars
            if IsValid(attacker) and attacker:IsNPC() and IsBee(attacker) then
                if not IsValid(victim) or not victim.GetRole then
                    dmg:SetDamage(BeeInnocentDamage)
                elseif victim:GetRole() == ROLE_INNOCENT or victim.IsInnocentTeam and victim:IsInnocentTeam() then
                    dmg:SetDamage(BeeInnocentDamage)
                elseif victim:GetRole() == ROLE_TRAITOR or victim.IsTraitorTeam and victim:IsTraitorTeam() then
                    dmg:SetDamage(BeeTraitorDamage)
                else
                    dmg:SetDamage(BeeInnocentDamage)
                end
            end

            -- Annoyingly complex check to make the headcrab ragdolls invisible
            -- Fixed non-bee manhacks dropping bee corpses
            if IsBee(victim) then
                dmg:SetDamageType(DMG_REMOVENORAGDOLL)

                --Odd behaviour occured when killing Bees with the 'crowbar'
                --Extra steps had to be taken to reliably hide the ragdoll.
                if dmg:GetInflictor():GetClass() == "weapon_zm_improvised" then
                    local Bee = ents.Create("prop_physics")
                    Bee:SetModel("models/lucian/props/stupid_bee.mdl")
                    Bee:SetPos(victim:GetPos())
                    Bee:SetAngles(victim:GetAngles() + Angle(0, -90, 0))
                    Bee:SetColor(Color(128, 128, 128, 255))
                    Bee:SetCollisionGroup(COLLISION_GROUP_WEAPON)
                    Bee:Spawn()
                    Bee:Activate()
                    local phys = Bee:GetPhysicsObject()

                    if not (phys and IsValid(phys)) then
                        Bee:Remove()
                    end

                    victim:SetNoDraw(false)
                    victim:SetColor(Color(255, 2555, 255, 1))
                    victim:Remove()
                end

                if dmg:GetDamageType() == DMG_DROWN then
                    dmg:SetDamage(0)
                end

                if victim:Health() - dmg:GetDamage() < 980 then
                    local Bee = ents.Create("prop_physics")
                    Bee:SetModel("models/lucian/props/stupid_bee.mdl")
                    Bee:SetPos(victim:GetPos())
                    Bee:SetAngles(victim:GetAngles() + Angle(0, -90, 0))
                    Bee:SetColor(Color(128, 128, 128, 255))
                    Bee:SetCollisionGroup(COLLISION_GROUP_WEAPON)
                    Bee:Spawn()
                    Bee:Activate()
                    local phys = Bee:GetPhysicsObject()

                    if not (phys and IsValid(phys)) then
                        Bee:Remove()
                    end

                    victim:Remove()
                end
            end
        end

        hook.Add("EntityTakeDamage", "BeenadeDmgHandle", BeeNadeDamage)
    elseif class == "ttt_minictest" then
        -- Fixes error spam with the mimic spawner
        local JUMP_HORIZ_SPEED = 400
        local ATTACK_DIST = 150

        function ENT:JumpAtTarget()
            if not IsValid(self.Target) then return end
            local vel

            if self.TargetHasPhysics and IsValid(self.TargetPhys) then
                vel = self.TargetPhys:GetVelocity()
            else
                vel = self.Target:GetVelocity()
            end

            local mypos = self:GetPos()
            local targpos = self.Target:EyePos()
            local disp = targpos - mypos
            local proj = vel - disp:Dot(vel) / disp:Dot(disp) * disp
            local dest = targpos + proj * 0.6
            local dist = mypos:Distance(dest)
            vel = (dest - mypos) * JUMP_HORIZ_SPEED / dist
            vel.z = 250

            if vel.z < 20 then
                vel.z = 20
            end

            if IsValid(self.Phys) then
                self.Phys:AddVelocity(vel)
                self.Phys:AddAngleVelocity(Vector(0, 0, 5))
            end

            -- Attack!
            if dist < ATTACK_DIST then
                self.Attacking = true
            else
                self.Attacking = false
            end
        end

        function ENT:PhysicsCollide(data, phys)
            if data.Speed < 30 then return end

            if data.Speed > 900 then
                self:TakeDamage(0.2 * (data.Speed - 900), data.HitEntity, data.HitEntity)
            end

            if self.Attacking and not (data.HitEntity:IsWorld() or data.HitEntity.IsChicken) then
                local dmg = 5

                if data.HitEntity:IsPlayer() then
                    if data.HitEntity:GetRole() == ROLE_DETECTIVE then
                        dmg = 10
                    end

                    if IsValid(data.HitEntity:GetActiveWeapon()) and data.HitEntity:GetActiveWeapon():GetClass() == "weapon_ttt_riot" then
                        dmg = 5
                    end
                end

                local dmginfo = DamageInfo()
                dmginfo:SetDamage(dmg)
                dmginfo:SetAttacker(self.Attacker)
                dmginfo:SetInflictor(self)
                dmginfo:SetDamageType(DMG_CLUB)
                dmginfo:SetDamageForce(self:GetPos() - data.HitEntity:GetPos())
                dmginfo:SetDamagePosition(data.HitEntity:GetPos())

                if self.IsPoisoned and data.HitEntity:IsPlayer() and isfunction(TakePoisonDamage) then
                    TakePoisonDamage(data.HitEntity, self.Attacker, self)
                end

                data.HitEntity:TakeDamageInfo(dmginfo)
                self.Attacking = false
            end
        end
    elseif class == "ttt_liftgren_proj" then
        -- Fixes error spam with the lift grenade
        function ENT:Explode(tr)
            if SERVER then
                self:SetNoDraw(true)
                self:SetSolid(SOLID_NONE)

                if tr.Fraction ~= 1.0 then
                    self:SetPos(tr.HitPos + tr.HitNormal * 0.6)
                end

                local pos = self:GetPos()
                local effect = EffectData()
                effect:SetStart(pos)
                effect:SetOrigin(pos)
                effect:SetScale(2)
                effect:SetRadius(2)
                effect:SetMagnitude(2)

                if tr.Fraction ~= 1.0 then
                    effect:SetNormal(tr.HitNormal)
                end

                -- copied code:
                for k, v in pairs(ents.FindInSphere(self:GetPos(), 150)) do
                    if IsValid(v) and v:GetClass() ~= "ttt_liftgren_proj" then
                        if v:IsPlayer() or v:IsNPC() then
                            local backupgravity = v:GetGravity()
                            v:SetGravity(-0.0001)
                            v:SetLocalVelocity(Vector(0, 0, 251))

                            timer.Simple(4.5, function()
                                v:SetGravity(backupgravity)
                            end)
                        elseif v:GetClass() ~= "ttt_liftgren_proj" and v:GetPhysicsObject():IsValid() then
                            v:GetPhysicsObject():EnableGravity(false)
                            v:GetPhysicsObject():SetVelocity(v:GetVelocity() + Vector(0, 0, 251))

                            timer.Simple(4.5, function()
                                if IsValid(v) then
                                    local phys = v:GetPhysicsObject()

                                    if IsValid(phys) then
                                        phys:EnableGravity(true)
                                    end
                                end
                            end)
                        end
                    end
                end

                self:EmitSound("ambient/machines/thumper_hit.wav", SNDLVL_180dB)
                self:EmitSound("npc/vort/health_charge.wav", SNDLVL_140dB)
                local effectdata = EffectData()
                effectdata:SetOrigin(self:GetPos())
                util.Effect("VortDispel", effectdata)
                self:Remove()
            end
        end
    elseif class == "weepingangel" then
        local STAB_COOLDOWN = 2
        local STAB_FORCE = 12000
        local STAB_DAMAGE = 500
        local TELEPORT_COOLDOWN = 1
        local TELEPORT_MAX_DIST_FROM_PLR = 450
        local TELEPORT_MIN_DIST_FROM_PLR = 100
        local TELEPORT_MAX_TRIES = 20

        -- Fixes the weeping angel having error models, erroring whenever it is shot, and erroring trying to play missing sounds
        function ENT:Initialize()
            self:SetModel("models/the_sniper_9/doctorwho/extras/angels/angelidle.mdl")
            self:PhysicsInit(SOLID_VPHYSICS)
            local phys = self:GetPhysicsObject()

            if phys:IsValid() then
                phys:Wake()
            end

            self.Width = self:BoundingRadius() * 0.5
            self.CurSound = ""
            self.NextTeleport = 0
            self.NextCreep = 0
            self.NextEmit = 0
            self.NextStab = 0
            self.Knife = NULL
            self.IsBeingCreepy = false
            self:SetMoveType(MOVETYPE_NONE)
        end

        function ENT:DrawKnife(vec)
            self:SetModel("models/the_sniper_9/doctorwho/extras/angels/angelattack.mdl")
            vec.z = 0
            vec:Normalize()
            local knifepos = self:GetPos() + vec * self.Width + Vector(0, 0, 0.5 * self.Width)
            self.Knife = ents.Create("prop_physics")
            self.Knife:SetPos(knifepos)
            self.Knife:SetModel("models/weapons/w_knife_t.mdl")
            self.Knife:SetAngles(vec:Angle())
            self.Knife:Spawn()
            self.Knife:SetColor(Color(0, 0, 0, 0))
            self.Knife:SetParent(self)
        end

        function ENT:TeleportToPos(pos)
            self:SetModel("models/the_sniper_9/doctorwho/extras/angels/angelidle.mdl")

            for i = 1, TELEPORT_MAX_TRIES do
                local tr = util.TraceLine({
                    start = pos,
                    endpos = pos - Vector(0, 0, 64),
                    filter = {self, self.Kinfe},
                    mask = MASK_NPCSOLID
                })

                local spawnpos = tr.HitPos + Vector(0, 0, self.Width + 8)

                if util.PointContents(spawnpos) then
                    self:SetPos(spawnpos)
                    -- Jostle it a bit in case it's stuck
                    local phys = self:GetPhysicsObject()
                    phys:ApplyForceCenter(VectorRand() * 2)
                    break
                end

                pos = pos + Vector(math.Rand(-20, 20), math.Rand(-20, 20), math.Rand(-5, 5))
            end
        end

        function ENT:TeleportBehindVictim()
            self:SetModel("models/the_sniper_9/doctorwho/extras/angels/angelpoint.mdl")
            if CurTime() < self.NextTeleport then return end
            local plraim = self.Victim:GetAimVector()
            plraim.z = 0
            plraim:Normalize()
            local plrpos = self.Victim:GetShootPos()

            local tr = util.TraceLine({
                start = plrpos - plraim * TELEPORT_MIN_DIST_FROM_PLR,
                endpos = plrpos - plraim * TELEPORT_MAX_DIST_FROM_PLR,
                filter = {self, self.Kinfe, self.Victim},
                mask = MASK_NPCSOLID
            })

            self:TeleportToPos(tr.HitPos + tr.HitNormal * self.Width)
            self.NextTeleport = CurTime() + TELEPORT_COOLDOWN
        end

        function ENT:StabbyLunge(vec)
            if CurTime() < self.NextStab then return end
            local phys = self:GetPhysicsObject()
            local stabvec = vec * STAB_FORCE + Vector(0, 0, 0.4 * STAB_FORCE)
            phys:ApplyForceCenter(stabvec)
            local vicpos = self.Victim:GetShootPos()
            self.Victim:TakeDamage(STAB_DAMAGE, self, self.Knife)
            self.NextStab = CurTime() + STAB_COOLDOWN
        end
    elseif class == "d.va_mech" then
        -- Fixes the D.Va mech erroring on activating self-destruct
        function ENT:Self_Destruct()
            if self:GetNWFloat("UltiCharge", 0) + self.UltiChargeSave < 1000 then return end
            self:SetModel("models/Pichachu/overwatch/mech2.mdl")
            self:SetPos(self:GetPos() + Vector(0, 0, 1))
            local effectdata = EffectData()
            effectdata:SetEntity(self)
            effectdata:SetScale(1)
            util.Effect("Dva_mech_Self_Destruct_Main", effectdata)
            self.SystemOff = true
            self.UltiSaveActivator = self.Activator

            for i = 1, 10 do
                timer.Simple((i - 1) * 0.3, function()
                    if not IsValid(self) then return end
                    local effectdata2 = EffectData()
                    effectdata2:SetEntity(self)
                    effectdata2:SetScale(i)
                    util.Effect("Dva_mech_Self_Destruct", effectdata)
                end)
            end

            local SaveAc = self.Activator
            local SaveSe = self

            timer.Simple(3.5, function()
                if not IsValid(self) then return end
                local effectdata2 = EffectData()
                effectdata2:SetEntity(self)
                effectdata2:SetScale(1)
                effectdata2:SetOrigin(self:GetPos())
                util.Effect("Dva_mech_Self_Destruct_Main_", effectdata2)
                util.BlastDamage(SaveSe, SaveAc, self:GetPos(), 1500, 3000)
                self:Remove()
            end)

            self:SetNWFloat("UltiCharge", 0)
            self:SetNWBool("UltiChargeBool", true)
            local activator = self.Activator
            activator:EmitSound("Skill/self_d.mp3", 500, 100, 1, CHAN_WEAPON)
            self:EmitSound("Skill/Ultimate2.mp3", 500, 100, 1, CHAN_WEAPON)
            drive.PlayerStopDriving(activator)
            activator.DvaMechCollid = self
            self.DvaMechCollid = self
            activator:SetEyeAngles(self:GetAngles())
            activator:SetNWEntity("DvaMech", false)

            timer.Simple(1, function()
                if not IsValid(self) then return end
                activator.DvaMechCollid = nil
                self.DvaMechCollid = nil
            end)

            activator:SetParent(NULL)
            activator:SetPos(self:GetPos())
            self.Activator = NULL
            self.DriveTime = CurTime() + 1
            self:SetNWEntity("Activator", NULL)
            activator:SetNoDraw(false)

            timer.Simple(0.1, function()
                if not IsValid(self) then return end
                local Seq = self:LookupSequence("walk_SMG1_Relaxed_all")
                self:SetSequence(Seq)
                self:ResetSequence(Seq)
                self:SetPlaybackRate(2)
            end)
        end
    elseif class == "ent_fortnitestructure" then
        -- Fix error when damage attacker is a NULL entity
        function ENT:OnTakeDamage(damage)
            if damage:GetDamage() <= 0 then return end

            if damage:GetDamageType() == DMG_CLUB then
                self:SetHealth(self:Health() - 1.5 * damage:GetDamage())
            elseif damage:GetDamageType() == DMG_BLAST then
                self:SetHealth(self:Health() - 2.0 * damage:GetDamage())
            else
                self:SetHealth(self:Health() - 1.2 * damage:GetDamage())
            end

            if self:Health() <= 0 and SERVER then
                local neighbours = self.Neighbours
                local selfEntityCount = self.EntityCount
                local attacker = damage:GetAttacker()

                if not IsValid(attacker) then
                    attacker = nil
                end

                timer.Create("Fortnite_Destroy_Timer" .. tostring(selfEntityCount), 0.08, 4, function()
                    for _, ent in pairs(neighbours) do
                        if IsValid(ent) and not ent:ConnectedToGround() then
                            ent:TakeDamage(ent:GetMaxHealth() / 4, attacker)
                        end
                    end
                end)

                self:Remove()
            end
        end
    elseif class == "ttt_bear_trap" then
        -- Fixed bear trap entity not having a human-readable name set
        ENT.PrintName = "Bear Trap"
    elseif class == "sent_eggt" then
        -- Fixed chickenator egg not setting the spawned chicken's attacker correctly
        -- Also fixes errors that happen when spawning chickens from eggs
        function ENT:PhysicsCollide(data)
            timer.Simple(0.05, function()
                if not IsValid(self) then return end
                if self.Spawning then return end
                self.Spawning = true
                local pos = data.HitPos
                local norm = data.HitNormal
                pos = pos + 4 * norm
                -- Spawn the chicken
                local chicken = ents.Create("ttt_chickent")
                chicken:SetPos(pos)
                chicken:Spawn()
                chicken:Activate()
                chicken:SetAttacker(self:GetOwner())
                self:Remove()
            end)
        end
    end
end)