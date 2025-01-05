-- Tweaks and changes for various weapons on the workshop
-- These weapons may only have a tweak (e.g. Ares Shrike), or both fixes and tweaks (e.g. Invisibility Cloak)
-- Any weapon that has both a fix and tweak resides here, not in stig_ttt_weapon_fixes.lua
if engine.ActiveGamemode() ~= "terrortown" then return end

hook.Add("PreRegisterSWEP", "StigSpecialWeaponTweaks", function(SWEP, class)
    -- First, a bunch of buffs to weapons that were way too weak to be usable
    if class == "weapon_pp_remington" then
        local damageCvar = CreateConVar("ttt_tweaks_remington_damage", 35, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Damage of the Remington gun")

        SWEP.Primary.Damage = damageCvar:GetFloat()
    elseif class == "weapon_ap_vector" then
        local recoilCvar = CreateConVar("ttt_tweaks_vector_recoil", 0.7, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Recoil of the Vector gun")

        SWEP.Primary.Recoil = recoilCvar:GetFloat()
    elseif class == "weapon_rp_pocket" then
        local damageCvar = CreateConVar("ttt_tweaks_pocket_damage", 75, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Damage of the Pocket Rifle gun")

        SWEP.Primary.Damage = damageCvar:GetFloat()
    elseif class == "weapon_ap_pp19" then
        local damageCvar = CreateConVar("ttt_tweaks_pp_19_damage", 8, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Damage of the PP19 gun")

        SWEP.Primary.Damage = damageCvar:GetFloat()
    elseif class == "weapon_ttt_p228" then
        local damageCvar = CreateConVar("ttt_tweaks_p228_recoil", 25, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Damage of the P228 gun")

        SWEP.Primary.Damage = damageCvar:GetFloat()
    elseif class == "weapon_t38" then
        local damageCvar = CreateConVar("ttt_tweaks_t38_damage", 65, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Damage of the Type 38 gun")

        SWEP.Primary.Damage = damageCvar:GetFloat()
    elseif class == "weapon_ttt_g3sg1" then
        local damageCvar = CreateConVar("ttt_tweaks_g3sg1_damage", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Damage of the G3SG1 gun")

        SWEP.Primary.Damage = damageCvar:GetFloat()
    elseif class == "weapon_gewehr43" then
        local damageCvar = CreateConVar("ttt_tweaks_gewehr43_damage", 40, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Damage of the Gewehr Type 43 gun")

        SWEP.Primary.Damage = damageCvar:GetFloat()

        local firedelayCvar = CreateConVar("ttt_tweaks_gewehr43_firedelay", 0.39, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Fire delay of the Gewehr Type 43 gun")

        SWEP.Primary.Delay = firedelayCvar:GetFloat()
    elseif class == "weapon_luger" then
        local damageCvar = CreateConVar("ttt_tweaks_luger_damage", 20, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Damage of the Luger gun")

        SWEP.Primary.Damage = damageCvar:GetFloat()
    elseif class == "weapon_welrod" then
        local damageCvar = CreateConVar("ttt_tweaks_welrod_damage", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Damage of the Welrod gun")

        SWEP.Primary.Damage = damageCvar:GetFloat()
    elseif class == "weapon_dp" then
        local damageCvar = CreateConVar("ttt_tweaks_dp_damage", 20, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Damage of the DP gun")

        SWEP.Primary.Damage = damageCvar:GetFloat()
    elseif class == "st_bananapistol" then
        -- Fix not having a worldmodel and not using TTT ammo
        -- Also increase the weapon's damage and ammo slightly
        SWEP.WorldModel = "models/props/cs_italy/bananna.mdl"
        SWEP.Primary.Ammo = "Pistol"
        SWEP.AmmoEnt = "item_ammo_pistol_ttt"
        SWEP.PrintName = "Banana Gun"

        local ammoCvar = CreateConVar("ttt_tweaks_banana_gun_ammo", 20, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Ammo of the Banana gun")

        SWEP.Primary.ClipSize = ammoCvar:GetFloat()
        SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize

        local damageCvar = CreateConVar("ttt_tweaks_banana_gun_damage", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Damage of the Banana gun")

        SWEP.Primary.Damage = damageCvar:GetFloat()

        SWEP.WElements = {
            ["bananaworld"] = {
                type = "Model",
                model = "models/props/cs_italy/bananna.mdl",
                bone = "ValveBiped.Bip01_R_Hand",
                rel = "",
                pos = Vector(5.714, 2.714, -1.558),
                angle = Angle(0, 90, 45),
                size = Vector(1, 1, 1),
                color = Color(255, 255, 255, 255),
                surpresslightning = false,
                material = "",
                skin = 0,
                bodygroup = {}
            }
        }
    elseif class == "swep_rifle_viper" then
        -- Fix not using TTT ammo and having a weird viewmodel
        -- Increase its damage to 65 to make it a clean 2 shot kill to make up for its long shoot delay and high recoil
        SWEP.Base = "weapon_tttbase"
        SWEP.Primary.Ammo = "357"
        SWEP.AmmoEnt = "item_ammo_357_ttt"
        SWEP.AutoSpawnable = true
        SWEP.Slot = 2
        SWEP.Kind = WEAPON_HEAVY
        SWEP.PrintName = "Viper Rifle"
        SWEP.ViewModelFlip = false
        SWEP.DrawCrosshair = false
        SWEP.Icon = "vgui/ttt/ttt_viper_rifle"

        local damageCvar = CreateConVar("ttt_tweaks_viper_rifle_damage", 65, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Damage of the Viper Rifle gun")

        SWEP.Primary.Damage = damageCvar:GetFloat()

        function SWEP:Deploy()
            self:SetHoldType(self.HoldType)
            self:SendWeaponAnim(ACT_VM_DRAW)

            return true
        end
    elseif class == "weapon_hp_ares_shrike" then
        -- Remove the exponential component of the ares shrike's recoil
        -- Recoil now increases linearly, which is actually manageable
        -- Also lower its linear recoil slightly and increase damage slightly
        -- Give slightly more ammo as well
        local damageCvar = CreateConVar("ttt_tweaks_ares_shrike_damage", 12, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Damage of the Ares Shrike gun")

        SWEP.Primary.Damage = damageCvar:GetFloat()

        local recoilCvar = CreateConVar("ttt_tweaks_ares_shrike_recoil", 2, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Recoil of the Ares Shrike gun")

        SWEP.Primary.Recoil = recoilCvar:GetFloat()

        local clipsizeCvar = CreateConVar("ttt_tweaks_ares_shrike_clipsize", 100, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Clip size of the Ares Shrike gun")

        SWEP.Primary.ClipSize = clipsizeCvar:GetInt()

        local defaultclipCvar = CreateConVar("ttt_tweaks_ares_shrike_defaultclip", 200, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Starting ammo of the Ares Shrike gun")

        SWEP.Primary.DefaultClip = defaultclipCvar:GetInt()

        local exponentialCvar = CreateConVar("ttt_tweaks_ares_shrike_recoil_exponential", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether the Ares Shrike's recoil exponentially increases as you shoot it, rather than linearly")

        if not exponentialCvar:GetBool() then
            function SWEP:PrimaryAttack(worldsnd)
                local recoil = self.Primary.Recoil
                self.ModulationTime = CurTime() + 2
                self.ModulationRecoil = math.min(20, self.ModulationRecoil * 1.2)
                self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
                self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
                if not self:CanPrimaryAttack() then return end

                if not worldsnd then
                    self:EmitSound(self.Primary.Sound, self.Primary.SoundLevel)
                elseif SERVER then
                    sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
                end

                self:ShootBullet(self.Primary.Damage, recoil, self.Primary.NumShots, self:GetPrimaryCone())
                self:TakePrimaryAmmo(1)
                local owner = self:GetOwner()
                if not IsValid(owner) or owner:IsNPC() or not owner.ViewPunch then return end
                owner:ViewPunch(Angle(math.Rand(-0.2, -0.1) * recoil, math.Rand(-0.1, 0.1) * recoil, 0))
            end
        end
    elseif class == "weapon_ttt_artillery" then
        -- Make artillery cannon always red and not re-buyable
        local rebuyableCvar = CreateConVar("ttt_tweaks_artillery_rebuyable", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether the artillery cannon is re-buyable or not")

        SWEP.LimitedStock = not rebuyableCvar:GetBool()

        local alwaysRedCvar = CreateConVar("ttt_tweaks_artillery_always_red", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether the artillery cannon should always be red")

        if alwaysRedCvar:GetBool() then
            SWEP.CannonColor = HSVToColor(0, 0.7, 0.7)

            function SWEP:WasBought(buyer)
                return self.BaseClass.WasBought(self, buyer)
            end
        end
    elseif class == "weapon_rp_railgun" then
        -- Turns the railgun into the "Free kill gun" that allows to be killed or to kill without karma penalty
        -- (Not enabled by default)
        local freeKillGunCvar = CreateConVar("ttt_tweaks_railgun_no_karma_penalty", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether the railgun doesn't take karma for kills, and killing someone holding a railgun doesn't take karma either")

        if not freeKillGunCvar:GetBool() then return end
        SWEP.PrintName = "Free Kill Gun"

        hook.Add("TTTKarmaGivePenalty", "TTTTweaksFreeKillKarma", function(ply, penalty, victim)
            -- If someone uses the free kill gun on someone, don't take their karma
            local plyActiveWep = ply:GetActiveWeapon()
            if IsValid(plyActiveWep) and WEPS.GetClass(plyActiveWep) == class then return true end
            -- If someone shoots someone holding the free kill gun, don't take their karma either
            local victimActiveWep = victim:GetActiveWeapon()
            if IsValid(victimActiveWep) and WEPS.GetClass(victimActiveWep) == class then return true end
        end)

        function SWEP:ShootBullet(dmg, recoil, numbul, cone)
            local owner = self:GetOwner()
            self:SendWeaponAnim(self.PrimaryAnim)
            owner:MuzzleFlash()
            owner:SetAnimation(PLAYER_ATTACK1)
            if not IsFirstTimePredicted() then return end
            local sights = self:GetIronsights()
            numbul = numbul or 1
            cone = cone or 0.01
            local bullet = {}
            bullet.Num = numbul
            bullet.Src = owner:GetShootPos()
            bullet.Dir = owner:GetAimVector()
            bullet.Spread = Vector(cone, cone, 0)
            bullet.Tracer = 1
            bullet.TracerName = "ToolTracer"
            bullet.Force = 10
            bullet.Damage = dmg
            owner:FireBullets(bullet)
            -- Owner can die after firebullets
            if not IsValid(owner) or not owner:Alive() or owner:IsNPC() then return end

            if game.SinglePlayer() and SERVER or not game.SinglePlayer() and CLIENT and IsFirstTimePredicted() then
                -- reduce recoil if ironsighting
                recoil = sights and recoil * 0.6 or recoil

                if recoil and isnumber(recoil) then
                    local eyeang = owner:EyeAngles()
                    eyeang.pitch = eyeang.pitch - recoil
                    owner:SetEyeAngles(eyeang)
                end
            end
        end

        function SWEP:BfgFire(worldsnd)
            self:SetNextSecondaryFire(CurTime() + 0.5)
            self:SetNextPrimaryFire(CurTime() + 0.5)

            if not worldsnd then
                self:EmitSound(self.Primary.Sound, self.Primary.SoundLevel)
            elseif SERVER then
                sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
            end

            local recoil, damage

            if self.mode == "single" then
                self:TakePrimaryAmmo(1)
                recoil = 7
                damage = 20
            end

            if self.mode == "2" then
                self:TakePrimaryAmmo(2)
                recoil = 16
                damage = 40
            end

            if self.mode == "3" then
                self:TakePrimaryAmmo(3)
                recoil = 36
                damage = 80
            end

            if self.mode == "4" then
                self:TakePrimaryAmmo(4)
                recoil = 82
                damage = 160
            end

            self:ShootBullet(damage, recoil, self.Primary.NumShots, self:GetPrimaryCone())
            local owner = self:GetOwner()
            if not recoil or not IsValid(owner) or owner:IsNPC() or not owner.ViewPunch then return end
            owner:ViewPunch(Angle(math.Rand(-0.2, -0.1) * recoil, math.Rand(-0.1, 0.1) * recoil, 0))

            if self.ChargeSound then
                self.ChargeSound:Stop()
            end
        end
    elseif class == "weapon_ttt_cloak" then
        -- Fixes becoming permanently invisible if handcuffed while using the cloak
        -- Makes the weapon given to the Killer role as part of their weapon loadout (not enabled by default)
        -- Makes it so you cannot use the Amatrasu weapon at the same time as using the cloak
        local killerCvar = CreateConVar("ttt_tweaks_invisibility_cloak_killer", "0", {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Whether the invisibility cloak should be given to Killers as a loadout weapon")

        if killerCvar:GetBool() then
            SWEP.InLoadoutFor = {ROLE_KILLER}
        end

        local amatrasuCvar = CreateConVar("ttt_tweaks_invisibility_cloak_removes_amatrasu", "1", nil, "Whether using the invisibility cloak removes your amatrasu weapon if you have one")

        function SWEP:Cloak()
            local owner = self:GetOwner()
            owner:SetColor(Color(255, 255, 255, 0))
            owner:DrawShadow(false)
            owner:SetMaterial("models/effects/vol_light001")
            owner:SetRenderMode(RENDERMODE_TRANSALPHA)
            self:EmitSound("xeno/cloak.wav")
            self.conceal = true

            if SERVER and owner:HasWeapon("ttt_amaterasu") and amatrasuCvar:GetBool() then
                owner:StripWeapon("ttt_amaterasu")
                owner:ChatPrint("Uncloak to use the amaterasu")
                self.amaterasu = true
            end
        end

        function SWEP:UnCloak()
            local owner = self:GetOwner()
            owner:DrawShadow(true)
            owner:SetMaterial("")
            owner:SetRenderMode(RENDERMODE_NORMAL)
            self:EmitSound("xeno/decloak.wav")
            self:SetMaterial("")
            self.conceal = false

            if self.amaterasu then
                self:GetOwner():ChatPrint("Giving amaterasu in 2 seconds")

                timer.Simple(2, function()
                    if IsPlayer(self:GetOwner()) and self.conceal == false then
                        self:GetOwner():Give("ttt_amaterasu")
                        self.amaterasu = false
                    end
                end)
            end
        end

        function SWEP:ShouldDropOnDie()
            return false
        end

        hook.Add("TTTPrepareRound", "UnCloakAll", function()
            for k, v in pairs(player.GetAll()) do
                v:SetMaterial("")
            end
        end)

        hook.Add("PlayerDroppedWeapon", "DropCloakingDeviceUnCloak", function(owner, wep)
            if wep:GetClass() == "weapon_ttt_cloak" then
                owner:DrawShadow(true)
                owner:SetMaterial("")
                owner:SetRenderMode(RENDERMODE_NORMAL)
                wep:EmitSound("xeno/decloak.wav")
                wep:SetMaterial("")
                wep.conceal = false

                if wep.amaterasu then
                    wep.amaterasu = false
                    owner:ChatPrint("Giving amaterasu in 2 seconds")

                    timer.Simple(2, function()
                        if IsPlayer(owner) then
                            wep:GetOwner():Give("ttt_amaterasu")
                        end
                    end)
                end
            end
        end)
    elseif class == "weapon_ttt_bonk_bat" then
        -- Adds a ceiling and floor to the jail to prevent players from escaping
        local ceilingCvar = CreateConVar("ttt_tweaks_bonk_bat_floor_ceiling", "1", nil, "Whether the jail created by the bonk bat should have a floor and ceiling")

        function SWEP:PrimaryAttack()
            local ply = self:GetOwner()
            self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
            if not IsValid(ply) or self:Clip1() <= 0 then return end
            ply:SetAnimation(PLAYER_ATTACK1)
            self:SendWeaponAnim(ACT_VM_MISSCENTER)
            self:EmitSound("Bat.Swing")
            local av, spos = ply:GetAimVector(), ply:GetShootPos()
            local epos = spos + av * self.Range
            local kmins = Vector(1, 1, 1) * 7
            local kmaxs = Vector(1, 1, 1) * 7
            ply:LagCompensation(true)

            local tr = util.TraceHull({
                start = spos,
                endpos = epos,
                filter = ply,
                mask = MASK_SHOT_HULL,
                mins = kmins,
                maxs = kmaxs
            })

            -- Hull might hit environment stuff that line does not hit
            if not IsValid(tr.Entity) then
                tr = util.TraceLine({
                    start = spos,
                    endpos = epos,
                    filter = ply,
                    mask = MASK_SHOT_HULL
                })
            end

            ply:LagCompensation(false)
            local ent = tr.Entity
            if not tr.Hit or not (tr.HitWorld or IsValid(ent)) then return end
            if not ent:IsPlayer() then return end

            if ent:GetClass() == "prop_ragdoll" then
                ply:FireBullets{
                    Src = spos,
                    Dir = av,
                    Tracer = 0,
                    Damage = 0
                }
            end

            if CLIENT then return end
            net.Start("Bonk Bat Primary Hit")
            net.WriteTable(tr)
            net.WriteEntity(self)
            net.Broadcast()
            local dmg = DamageInfo()
            dmg:SetDamage(ent:IsPlayer() and self.Primary.Damage or self.Primary.Damage * 0.5)
            dmg:SetAttacker(ply)
            dmg:SetInflictor(self)
            dmg:SetDamageForce(av * 2000)
            dmg:SetDamagePosition(ply:GetPos())
            dmg:SetDamageType(DMG_CLUB)
            ent:DispatchTraceAttack(dmg, tr)
            self:TakePrimaryAmmo(1)

            if self:Clip1() <= 0 then
                timer.Simple(0.49, function()
                    if IsValid(self) then
                        self:Remove()
                        RunConsoleCommand("lastinv")
                    end
                end)
            end

            -- grenade to stop detective getting stuck in jail
            local gren = ents.Create("jail_discombob")
            gren:SetPos(ent:GetPos())
            gren:SetOwner(ent)
            gren:SetThrower(ent)
            gren:Spawn()
            gren:SetDetonateExact(CurTime())
            local name = ent:Name()
            local jail = {}

            -- making the jail
            timer.Create("jaildiscombob", 0.7, 1, function()
                -- far side
                jail[0] = JailWall(ent:GetPos() + Vector(0, -25, 50), Angle(0, 275, 0))
                -- close side
                jail[1] = JailWall(ent:GetPos() + Vector(0, 25, 50), Angle(0, 275, 0))
                -- left side
                jail[2] = JailWall(ent:GetPos() + Vector(-25, 0, 50), Angle(0, 180, 0))
                -- right side
                jail[3] = JailWall(ent:GetPos() + Vector(25, 0, 50), Angle(0, 180, 0))

                if ceilingCvar:GetBool() then
                    -- ceiling side
                    jail[4] = JailWall(ent:GetPos() + Vector(0, 0, 100), Angle(90, 0, 0))
                    -- floor side
                    jail[5] = JailWall(ent:GetPos() + Vector(0, 0, -5), Angle(90, 0, 0))
                end

                for _, v in pairs(player.GetAll()) do
                    v:ChatPrint(name .. " has been sent to horny jail!")
                end
            end)

            timer.Simple(15, function()
                -- remove the jail
                for _, v in pairs(jail) do
                    v:Remove()
                end
            end)
        end
    elseif class == "weapon_ttt_hotpotato" then
        -- Changes the music of the hot potato to a royalty-free alternative
        local musicCvar = CreateConVar("ttt_tweaks_hot_potato_no_copyright_music", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether the hot potato's music is replaced with non-copyright music")

        local oldMusic = "hotpotatoloop.wav"
        local newMusic = Sound("stig_ttt_tweaks_and_fixes/hotpotato.mp3")

        -- A global function from the hot potato SWEP file
        -- Hijack it to use it like a hook for removing the potato sound when it should be
        if musicCvar:GetBool() then
            local old_fn_CleanUp = fn_CleanUp

            function fn_CleanUp(ply)
                if SERVER then
                    ply:StopSound(newMusic)
                end

                return old_fn_CleanUp(ply)
            end
        end

        -- Resetting the speed boost given by hot potato
        SWEP.OldTweaksPrimaryAttack = SWEP.PrimaryAttack

        function SWEP:PrimaryAttack()
            local owner = self:GetOwner()

            timer.Simple(0.1, function()
                if IsValid(owner) then
                    local wep = owner:GetActiveWeapon()

                    if not IsValid(wep) or not wep.PotatoChef then
                        owner:SetWalkSpeed(220)
                        owner:SetRunSpeed(220)
                    end
                end
            end)

            return self:OldTweaksPrimaryAttack()
        end

        SWEP.OldTweaksPotatoTime = SWEP.PotatoTime

        function SWEP:PotatoTime(ply, PotatoChef)
            -- Fixes the speed boost of the hot potato not working
            hook.Add("WeaponEquip", "TTTTweaksHotPotatoSpeedBoost", function(wep, p)
                timer.Simple(0.1, function()
                    if IsValid(wep) and wep.PotatoChef then
                        p:SetWalkSpeed(p:GetWalkSpeed() * GetConVar("ttt_hotpotato_speedbuff"):GetFloat())
                        p:SetRunSpeed(p:GetRunSpeed() * GetConVar("ttt_hotpotato_speedbuff"):GetFloat())
                    end
                end)
            end)

            hook.Add("TTTPrepareRound", "TTTTweaksHotPotatoSpeedBoost", function()
                hook.Remove("WeaponEquip", "TTTTweaksHotPotatoSpeedBoost")
                hook.Remove("TTTPrepareRound", "TTTTweaksHotPotatoSpeedBoost")
            end)

            SWEP:OldTweaksPotatoTime(ply, PotatoChef)

            if musicCvar:GetBool() then
                ply:StopSound(oldMusic)
                ply:StartLoopingSound(newMusic)

                timer.Simple(0.1, function()
                    ply:StopSound(oldMusic)
                end)
            end
        end

        if musicCvar:GetBool() then
            SWEP.OldTweaksDetonate = SWEP.Detonate

            function SWEP:Detonate(ply)
                SWEP:OldTweaksDetonate(ply)
                ply:StopSound(newMusic)
            end
        end
    elseif class == "weapon_ttt_deadringer" and ConVarExists("ttt_deadringer_sound_activate_local") then
        -- Have to do extra check to differentiate other versions of the dead ringer with the same classname
        -- Changes the TTT2 version of the dead ringer to act like the original verion by default
        local ogCvar = CreateConVar("ttt_tweaks_dead_ringer_original_behaviour", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether the TTT2 version of the dead ringer should act like the original version by default")

        if not ogCvar:GetBool() then return end
        -- Dead ringer auto-reactivates after it recharges
        RunConsoleCommand("ttt_deadringer_cloak_reactivate", 1)
        -- Dead ringer activate/deactive sounds can be heard by everyone
        RunConsoleCommand("ttt_deadringer_sound_activate_local", 0)
        RunConsoleCommand("ttt_deadringer_sound_deactivate_local", 0)

        -- Only purchasable by traitors
        SWEP.CanBuy = {ROLE_TRAITOR}

        local CLOAK = {
            NONE = 0,
            READY = 1,
            DISABLED = 2,
            CLOAKED = 3,
            UNCLOAKED = 4
        }

        -- Attempting to shoot while cloaked uncloaks you
        function SWEP:Think()
            local owner = self:GetOwner()
            if not IsValid(owner) then return end
            local cloaked = self:GetCloaked()
            local status = self:GetStatus()
            local chargeTime = owner:GetNWFloat("DRChargeTime", 1 / 0)

            if CLIENT and owner.DRNoTarget == nil then
                owner.DRNoTarget = Either(owner.NoTarget == nil, -1, owner.NoTarget and 1 or 0)
            end

            if not cloaked then
                if status == CLOAK.UNCLOAKED and chargeTime < CurTime() then
                    if SERVER then
                        if self.CVarCloakReactivate:GetBool() then
                            self:SetStatus(CLOAK.READY)
                        else
                            self:SetStatus(CLOAK.DISABLED)
                        end

                        if TTT2 and not self.CVarHudClassic:GetBool() then
                            STATUS:AddStatus(owner, "deadringer_ready")
                        end
                    end

                    if self.CVarSoundRecharge:GetBool() then
                        self:PlaySound("ttt/recharged.wav", self.CVarSoundRechargeLocal:GetBool() and owner or nil)
                    end
                end

                if CLIENT then
                    if owner.NoTarget and owner.DRNoTarget < 1 then
                        owner.NoTarget = Either(owner.DRNoTarget == -1, nil, false)
                    end

                    for _, wep in ipairs(owner:GetWeapons()) do
                        if IsValid(wep) then
                            if wep.DRNoDraw == nil then
                                wep.DRNoDraw = wep:GetNoDraw()
                            end

                            if wep:GetNoDraw() and not wep.DRNoDraw then
                                wep:SetNoDraw(false)
                            end
                        end
                    end
                end
            else
                if status == CLOAK.CLOAKED then
                    if CLIENT then
                        if not self.CVarCloakTargetid:GetBool() and owner.NoTarget ~= true then
                            owner.NoTarget = true
                        end

                        for _, wep in ipairs(owner:GetWeapons()) do
                            if IsValid(wep) then
                                if wep.DRNoDraw == nil then
                                    wep.DRNoDraw = wep:GetNoDraw()
                                end

                                if not wep:GetNoDraw() then
                                    wep:SetNoDraw(true)
                                end
                            end
                        end
                    end

                    -- Fix being able to shoot while cloaked
                    if chargeTime < CurTime() or owner:KeyDown(IN_ATTACK) or owner:KeyDown(IN_ATTACK2) then
                        self:Uncloak(owner)
                    end
                end
            end

            if SERVER and TTT2 and self.CVarHudClassic:GetBool() then
                STATUS:RemoveStatus(owner, "deadringer_ready")
                STATUS:RemoveStatus(owner, "deadringer_cloaked")
                STATUS:RemoveStatus(owner, "deadringer_cooldown")
            end
        end

        -- Fixing uncloak sound being overriden by gunshot sounds
        if CLIENT then
            net.Receive("DR.Sound", function()
                local wep = net.ReadEntity()
                local snd = net.ReadString()
                if not IsValid(wep) then return end
                wep:EmitSound(snd, 100, 100, 1, CHAN_STATIC)
            end)
        end
    elseif class == "weapon_dr2_remote" then
        -- Changing model of the drone controller weapon to not use a Wii controller model
        local modelCvar = CreateConVar("ttt_tweaks_drone_controller_tool_gun_model", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether to change the model of the drone controller weapon to the tool gun model")

        if not modelCvar:GetBool() then return end
        SWEP.ViewModel = "models/weapons/c_toolgun.mdl"
        SWEP.WorldModel = "models/weapons/w_toolgun.mdl"

        function SWEP:Deploy()
            self:SendWeaponAnim(ACT_VM_DRAW)

            return true
        end
    end
end)

-- 
-- 
-- Weapon entity tweaks -------------------------------------------------------------------------------------------------------------------------------------------------
-- 
-- 
hook.Add("PreRegisterSENT", "StigSpecialWeaponChangesEntities", function(ENT, class)
    if class == "zay_shell" then
        -- Makes it so players behind cover take reduced damage from the artillery cannon
        if SERVER then
            local coverCvar = CreateConVar("ttt_tweaks_artillery_cover_damage", "1", nil, "Wether players should take reduced damage behind cover from the artillery cannon")

            function ENT:PhysicsCollide(data, phys)
                if self.zay_Collided == true then return end

                timer.Simple(0, function()
                    if not IsValid(self) then return end
                    self:SetNoDraw(true)
                    local a_phys = self:GetPhysicsObject()

                    if IsValid(a_phys) then
                        a_phys:Wake()
                        a_phys:EnableMotion(false)
                    end
                end)

                zay.f.CreateNetEffect("shell_explosion", self:GetPos())

                for _, ent in pairs(ents.FindInSphere(self:GetPos(), GetConVar("ttt_artillery_range"):GetFloat())) do
                    if IsValid(ent) then
                        local Trace = {}
                        Trace.start = self:GetPos()
                        Trace.endpos = ent:GetPos()

                        Trace.filter = {self, ent}

                        Trace.mask = MASK_SHOT
                        Trace.collisiongroup = COLLISION_GROUP_PROJECTILE
                        local TraceResult = util.TraceLine(Trace)
                        local damage = GetConVar("ttt_artillery_damage"):GetFloat()

                        -- Players behind cover take half damage
                        if coverCvar:GetBool() and TraceResult.Hit then
                            damage = damage / 2
                        end

                        local d = DamageInfo()
                        d:SetDamage(damage)
                        d:SetAttacker(self:GetPhysicsAttacker())
                        d:SetInflictor(self)
                        d:SetDamageType(DMG_BLAST)
                        ent:TakeDamageInfo(d)
                    end
                end

                local deltime = FrameTime() * 2

                if not game.SinglePlayer() then
                    deltime = FrameTime() * 6
                end

                SafeRemoveEntityDelayed(self, deltime)
                self.zay_Collided = true
            end
        end

        -- Fixes "2" being spammed in the console whenever an artillery shell lands
        if CLIENT then
            zay.NetEffectGroups.shell_explosion.action = function(pos)
                local effectdata = EffectData()
                effectdata:SetOrigin(pos)
                local scale = 2 * GetConVar("ttt_artillery_range"):GetFloat() / 750
                effectdata:SetRadius(scale)
                effectdata:SetScale(scale)
                effectdata:SetMagnitude(scale)
                util.Effect("effect_explosion_scaleable", effectdata)
                zay.f.PositionSound(pos, "zay_artillery_explo_ttt")
                util.Decal("Scorch", pos + Vector(0, 0, 15), pos - Vector(0, 0, 200))
            end
        end
    elseif class == "ttt_redblackhole" and SERVER then
        -- Makes it so all players take regular damage from the red matter bomb, regardless of role
        local dmgCvar = CreateConVar("ttt_tweaks_rmb_damage_reduction", "0", FCVAR_ARCHIVE, "Whether vanilla traitors take less damage from the red matter bomb, and vanilla jesters are immune")
        if dmgCvar:GetBool() then return end

        local eatsounds = {"ambient/materials/door_hit1.wav", "ambient/materials/metal_groan.wav"}

        function ENT:Think()
            if self.DieAt < CurTime() then
                self:Remove()

                return
            end

            local pos = self:GetPos()
            local valve_radius = self:GetRadius() * 18

            for _, ent in pairs(ents.FindInSphere(pos, valve_radius)) do
                local phys = ent:GetPhysicsObject()
                local posdiff = -(ent:GetPos() - pos)
                local dist = posdiff:Length()
                posdiff:Normalize()

                if ent:IsPlayer() then
                    if ent:Alive() and not ent:IsSpec() then
                        if dist < self:GetRadius() and 1 > 0 then
                            ent:TakeDamage(math.random(1, 2), self:GetSpawner())
                            self:IncrRadius(0.2)
                            ent:EmitSound("ambient/energy/zap8.wav")
                        else
                            local force = posdiff * ((valve_radius - dist) / 25) * 45
                            ent:SetVelocity(force)
                        end
                    end
                elseif phys:IsValid() and not ent.WYOZIBHDontEat and self:IsGoodEnt(ent, phys) then
                    if dist < self:GetRadius() * 0.75 and 1 then
                        local effectdata = EffectData()
                        effectdata:SetStart(ent:GetPos())
                        effectdata:SetOrigin(self:GetPos()) -- end pos
                        effectdata:SetEntity(ent)
                        util.Effect("blackhole_eatent", effectdata)
                        ent.WYOZIBHDontEat = true
                        self:EmitSound(table.Random(eatsounds))

                        timer.Simple(0.5, function()
                            if ent:IsValid() then
                                ent:Remove()
                            end
                        end)

                        self:IncrRadius(1.5)
                        self.DieAt = self.DieAt + 0.1
                    end
                end
            end

            self:NextThink(CurTime() + 0.1)

            return true
        end
    elseif class == "bruhbunker_shield" then
        -- Making the bruh bunker make a "bruh" sound on being triggered
        function ENT:Initialize()
            self:EmitSound("stig_ttt_tweaks_and_fixes/bruh.mp3")
        end
    elseif class == "sent_jetpack" then
        -- Fixes the jetpack erroring on being spawned
        -- Adds an indicator to current fuel left when infinite fuel is turned off
        DEFINE_BASECLASS("base_predictedent")

        function ENT:Initialize()
            if self.SetSlotName then
                self:SetSlotName(self:GetClass())
            end

            BaseClass.Initialize(self)

            if SERVER then
                self:SetModel("models/thrusters/jetpack.mdl")
                self:InitPhysics()
                self:SetMaxHealth(GetConVar("JetpackMaxHealth"):GetInt())
                self:SetHealth(self:GetMaxHealth())
                self:SetInfiniteFuel(GetConVar("UseInfiniteFuel"):GetBool())
                self:SetMaxFuel(GetConVar("MaxJetPackFuel"):GetInt())
                self:SetFuel(self:GetMaxFuel())
                self:SetFuelDrain(GetConVar("JetPackDrainRate"):GetInt()) --drain in seconds
                self:SetFuelRecharge(GetConVar("JetPackRefuelRate"):GetInt()) --recharge in seconds
                self:SetActive(false)
                self:SetGoneApeshit(math.random(0, 100) > 95) --little chance that on spawn we're gonna be crazy!
                self:SetGoneApeshitTime(0)
                self:SetCanStomp(false)
                self:SetDoGroundSlam(false)
                self:SetAirResistance(2.5)
                self:SetRemoveGravity(false)
                self:SetJetpackSpeed(224)
                self:SetJetpackStrafeSpeed(600)
                self:SetJetpackVelocity(1200)
                self:SetJetpackStrafeVelocity(1200)
            else
                self:SetLastActive(false)
                self:SetWingClosure(0)
                self:SetWingClosureStartTime(0)
                self:SetWingClosureEndTime(0)
                self:SetNextParticle(0)
                self:SetNextFlameTrace(0)
                self:SetLastFlameTrace(nil)
            end
        end

        function ENT:OnInitPhysics(physobj)
            if IsValid(physobj) then
                physobj:SetMass(75)
            end

            self:SetCollisionGroup(COLLISION_GROUP_NONE)
        end

        if SERVER then
            util.AddNetworkString("TTTEquippedJetpackFuelIndicator")
        end

        function ENT:OnAttach(ply)
            self:SetDoGroundSlam(false)
            if GetConVar("UseInfiniteFuel"):GetBool() then return end
            net.Start("TTTEquippedJetpackFuelIndicator")
            net.WriteEntity(self)
            net.Send(ply)
        end

        if CLIENT then
            net.Receive("TTTEquippedJetpackFuelIndicator", function()
                local ply = LocalPlayer()
                local jetpack = net.ReadEntity()
                local backgroundColor = Color(128, 128, 128, 200)
                local textColor = COLOR_WHITE

                hook.Add("HUDPaint", "TTTEquippedJetpackFuelIndicator", function()
                    if not IsValid(jetpack) or not IsValid(jetpack:GetControllingPlayer()) or jetpack:GetControllingPlayer() ~= ply then
                        hook.Remove("HUDPaint", "TTTEquippedJetpackFuelIndicator")

                        return
                    end

                    draw.WordBox(8, 330, ScrH() - 50, "Fuel: " .. math.Round(jetpack:GetFuel()), "HealthAmmo", backgroundColor, textColor, TEXT_ALIGN_CENTER)
                end)
            end)
        end
    end
end)

-- 
-- 
-- Passive item tweaks -------------------------------------------------------------------------------------------------------------------------------------------------
-- 
-- 
hook.Add("InitPostEntity", "StigSpecialWeaponChangesPassives", function()
    -- Bruh bunker is annoying and adds itself in an InitPostEntity hook, different to any other passive item on the workshop...
    -- So put the modification in a 0 second timer to ensure this gets run after the bruh bunker gets added to the EquipmentItems table
    local bruhBunkerCvar = CreateConVar("ttt_tweaks_bruhbunker_sound_hud_icon", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether the bruh bunker should show a HUD icon on being bought, and play a 'Bruh' sound effect on triggering")

    if not bruhBunkerCvar:GetBool() then return end

    timer.Simple(0, function()
        if EQUIP_BUNKER then
            for _, equTable in pairs(EquipmentItems) do
                for _, equ in ipairs(equTable) do
                    -- Bruh Bunker
                    if equ.id == EQUIP_BUNKER then
                        if CLIENT then
                            LANG.AddToLanguage("english", "bunker_name", "Bruh Bunker")
                            LANG.AddToLanguage("english", "bunker_desc", "Creates a bunker around you after taking damage from another player")
                            LANG.AddToLanguage("english", "bunker_alert", "Cringe Breach Detected! An Emergency Bruh Bunker has been activated!")
                            LANG.AddToLanguage("english", "bunker_warning", "You have 5 seconds left of your Bruh Bunker.")
                            LANG.AddToLanguage("english", "bunker_expire", "Your Bruh Bunker has expired.")
                        end

                        equ.name = "bunker_name"
                        equ.desc = "bunker_desc"
                        equ.hud = true

                        hook.Add("TTTPrepareRound", "removetimers", function()
                            for _, ply in player.Iterator() do
                                ply:SetNWBool("TTTBruhBunker", false)
                                ply.cringealert = false
                            end

                            timer.Remove("bruhbunkerdiscombob")
                        end)

                        hook.Remove("Think", "bruhbunkertimer")
                        -- Fixing the bug where the jester shooting you, and similar 0 damage events, triggers the bruh bunker even though damage wasn't taken
                        hook.Remove("EntityTakeDamage", "bruhbunkeractivation")

                        hook.Add("PostEntityTakeDamage", "bruhbunkeractivation", function(target, dmginfo, took)
                            -- Adding the "took and" check here, and making this a PostEntityTakeDamage hook rather than EntityTakeDamage
                            -- Also only triggering the bruh bunker if we are sure this is damage dealt by another player
                            if took and target:IsPlayer() and target.cringealert and IsValid(dmginfo:GetAttacker()) and dmginfo:GetAttacker():IsPlayer() then
                                target.cringealert = false
                                local gren = ents.Create("bruhbunker_shield")
                                gren:SetPos(target:GetPos())
                                gren:SetOwner(target)
                                gren:SetThrower(target)
                                gren:Spawn()
                                gren:SetDetonateExact(CurTime())

                                timer.Create("bruhbunkerdiscombob", 0.7, 1, function()
                                    -- Also check for the target player being valid here since this is a timer
                                    if not IsValid(target) then return end
                                    -- And remove their HUD icon for the bruh bunker since it is now used
                                    target:SetNWBool("TTTBruhBunker", false)
                                    local bunker = ents.Create("prop_physics")
                                    bunker:SetModel("models/props_phx/misc/bunker01.mdl")
                                    bunker:SetPos(target:GetPos() - Vector(0, 0, 3))
                                    local angles = target:EyeAngles()
                                    bunker:SetAngles(Angle(0, angles.yaw + 275, 0))
                                    bunker:Spawn()
                                    bunker:EmitSound("zap_spawn")
                                    local physobj = bunker:GetPhysicsObject()

                                    if physobj:IsValid() then
                                        physobj:EnableMotion(false)
                                        physobj:Sleep(false)
                                    end

                                    -- Also making the alert message translatable
                                    BroadcastLua("chat.AddText(LANG.GetTranslation(\"bunker_alert\"))")

                                    timer.Simple(10, function()
                                        if IsValid(target) then
                                            target:SendLua("chat.AddText(LANG.GetTranslation(\"bunker_warning\"))")
                                        end
                                    end)

                                    timer.Simple(15, function()
                                        if IsValid(target) then
                                            target:SendLua("chat.AddText(LANG.GetTranslation(\"bunker_expire\"))")
                                        end

                                        if IsValid(bunker) then
                                            bunker:EmitSound("zap_despawn")
                                            bunker:Remove()
                                        end
                                    end)
                                end)
                            end
                        end)

                        -- Adding a local sound effect and HUD icon to actually indicate you've bought the bruh bunker
                        hook.Add("TTTOrderedEquipment", "bruhbunkercringealert", function(ply, equipment, is_item)
                            if equipment == EQUIP_BUNKER then
                                ply.cringealert = true
                                ply:SendLua("surface.PlaySound(\"stig_ttt_tweaks_and_fixes/bruh.mp3\")")
                                ply:SetNWBool("TTTBruhBunker", true)
                            end
                        end)

                        if CLIENT then
                            -- HUD icon
                            -- feel for to use this function for your own perk, but please credit Zaratusa
                            -- your perk needs a "hud = true" in the table, to work properly
                            local defaultY = ScrH() / 2 + 20
                            local client = LocalPlayer()

                            local function getYCoordinate(currentPerkID)
                                local amount, i, perk = 0, 1
                                client = client or LocalPlayer()

                                while i < currentPerkID do
                                    local role = client:GetRole()
                                    perk = GetEquipmentItem(role, i)

                                    if not perk then
                                        perk = GetEquipmentItem(ROLE_TRAITOR, i)

                                        if not perk then
                                            perk = GetEquipmentItem(ROLE_DETECTIVE, i)
                                        end
                                    end

                                    if istable(perk) and perk.hud and client:HasEquipmentItem(perk.id) then
                                        amount = amount + 1
                                    end

                                    if CRVersion and CRVersion("2.1.2") then
                                        i = i + 1
                                    else
                                        i = i * 2
                                    end
                                end

                                return defaultY - 80 * amount
                            end

                            local yCoordinate = defaultY

                            -- best performance, but the has about 0.5 seconds delay to the HasEquipmentItem() function
                            hook.Add("TTTBoughtItem", "bruhbunkericon", function()
                                if client:HasEquipmentItem(EQUIP_BUNKER) then
                                    yCoordinate = getYCoordinate(EQUIP_BUNKER)
                                end
                            end)

                            local material = Material("materials/vgui/ttt/ttt_bruhbunker_hud.png")

                            hook.Add("HUDPaint", "TTTBruhBunkerIcon", function()
                                if client:GetNWBool("TTTBruhBunker") and client:HasEquipmentItem(EQUIP_BUNKER) then
                                    surface.SetMaterial(material)
                                    surface.SetDrawColor(255, 255, 255, 255)
                                    surface.DrawTexturedRect(20, yCoordinate, 64, 64)
                                end
                            end)
                        end
                    end
                end
            end
        end
    end)
end)