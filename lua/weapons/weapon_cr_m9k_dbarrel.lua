-- Taken from Malivil's [TTT] M9K Weapons (Fixed) mod at their request for this feature:
-- https://steamcommunity.com/sharedfiles/filedetails/?id=3025019026
-- 
-- The model and sounds are packaged with CR4TTT so that is required
if not CR_VERSION or not CRVersion("2.1.18") then return false end

local enabledCvar = CreateConVar("ttt_tweaks_cr_m9k_dbarrel", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Whether to force the M9K double barrel shotgun to spawn as a floor weapon, but using the model and sounds from Custom Roles (Requires map change for changes to take effect)", 0, 1)

if not enabledCvar:GetBool() then return end
SWEP.Gun = "m9k_dbarrel"
SWEP.Category = "M9K Shotguns"
SWEP.Author = ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.MuzzleAttachment = "1"
SWEP.ShellEjectAttachment = "2"
SWEP.PrintName = "Double Barrel"
SWEP.Slot = 2
SWEP.SlotPos = 3
SWEP.DrawAmmo = true
SWEP.DrawWeaponInfoBox = false
SWEP.BounceWeaponIcon = false
SWEP.DrawCrosshair = false
SWEP.Weight = 30
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
SWEP.HoldType = "shotgun"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.Base = "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AutoSpawnable = true
SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_SHOTGUN
SWEP.Primary.RPM = 180
SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 2
SWEP.Primary.ClipMax = 24
SWEP.Primary.Delay = 0.8
SWEP.Primary.Cone = 0.07
SWEP.Primary.Recoil = 7
SWEP.Primary.KickUp = 10
SWEP.Primary.KickDown = 5
SWEP.Primary.KickHorizontal = 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Buckshot"
SWEP.AmmoEnt = "item_box_buckshot_ttt"
SWEP.Secondary.IronFOV = 0
SWEP.data = {}
SWEP.data.ironsights = 1
SWEP.ShellTime = .5
SWEP.Primary.NumShots = 8
SWEP.Primary.Damage = 11
SWEP.Primary.Spread = .03
SWEP.Primary.IronAccuracy = .03
SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = Vector(0, 0, 0)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(11.475, -7.705, -2.787)
SWEP.RunSightsAng = Vector(0.574, 51.638, 5.737)
-- Other than code cleanup, the only changes are these lines, so the double barrel can exist with just Custom Roles installed
SWEP.Primary.Sound = "weapons/ttt/dbsingle.wav"
SWEP.ViewModel = "models/weapons/v_old_doublebarrel.mdl"
SWEP.WorldModel = "models/weapons/w_old_doublebarrel.mdl"

function SWEP:SecondaryAttack()
    if self:Clip1() == 2 then
        self:PrimaryAttack()
        self:SetNextPrimaryFire(CurTime() + .05)

        timer.Simple(0.05, function()
            if IsValid(self) then
                self:PrimaryAttack()
            end
        end)
    elseif self:Clip1() == 1 then
        self:PrimaryAttack()
    elseif self:Clip1() == 0 then
        self:Reload()
    end
end

SWEP.reloadtimer = 0

function SWEP:SetupDataTables()
    self:DTVar("Bool", 0, "reloading")

    return self.BaseClass.SetupDataTables(self)
end

function SWEP:Reload()
    self:SetIronsights(false)
    if self.dt.reloading then return end
    if not IsFirstTimePredicted() then return end
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    owner:GetViewModel():SetPlaybackRate(2)

    if self:Clip1() < self.Primary.ClipSize and owner:GetAmmoCount(self.Primary.Ammo) > 0 then
        self:StartReload()
    end
end

function SWEP:StartReload()
    if self.dt.reloading then return false end
    if not IsFirstTimePredicted() then return false end
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    if not owner or owner:GetAmmoCount(self.Primary.Ammo) <= 0 then return false end
    if self:Clip1() >= self.Primary.ClipSize then return false end
    self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
    self.reloadtimer = CurTime() + self:SequenceDuration()
    self.dt.reloading = true

    return true
end

function SWEP:PerformReload()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    if not owner or owner:GetAmmoCount(self.Primary.Ammo) <= 0 then return end
    if self:Clip1() >= self.Primary.ClipSize then return end
    owner:RemoveAmmo(1, self.Primary.Ammo, false)
    self:SetClip1(self:Clip1() + 1)
    self:SendWeaponAnim(ACT_VM_RELOAD)
    self.reloadtimer = CurTime() + self:SequenceDuration()
end

function SWEP:FinishReload()
    self.dt.reloading = false
    self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
    self.reloadtimer = CurTime() + self:SequenceDuration()
end

function SWEP:CanPrimaryAttack()
    if self:Clip1() <= 0 then
        self:EmitSound("Weapon_Shotgun.Empty")
        self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

        return false
    end

    return true
end

function SWEP:Think()
    if self.dt.reloading and IsFirstTimePredicted() then
        local owner = self:GetOwner()
        if not IsValid(owner) then return end

        if owner:KeyDown(IN_ATTACK) then
            self:FinishReload()

            return
        end

        if self.reloadtimer <= CurTime() then
            if owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
                self:FinishReload()
            elseif self:Clip1() < self.Primary.ClipSize then
                self:PerformReload()
            else
                self:FinishReload()
            end

            return
        end
    end
end

function SWEP:Deploy()
    self.dt.reloading = false
    self.reloadtimer = 0

    return self.BaseClass.Deploy(self)
end

function SWEP:GetHeadshotMultiplier(victim, dmginfo)
    local att = dmginfo:GetAttacker()
    if not IsValid(att) then return 3 end
    local dist = victim:GetPos():Distance(att:GetPos())
    local d = math.max(0, dist - 140)

    return 1 + math.max(0, 2.1 - 0.002 * (d ^ 1.25))
end