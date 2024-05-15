# TTT Tweaks and Fixes

## Tweaks

Below is a list of all convars/options available with this mod, which allows you to turn on and off individual tweaks. Set to 1 to enable, and 0 to disable.\
\
If you don't know/don't have a weapon/mod listed below, it's fine, the mod will only apply the fixes and tweaks to the things you have installed on the server.\
\
Copy the below into your server's server.cfg, or to your local Gmod install's listenserver.cfg if you are hosting games just from the Gmod main menu, normally at: C:\Program Files (x86)\Steam\steamapps\common\GarrysMod\garrysmod\cfg

```cfg
ttt_tweaks_remington_damage 35                       // Various buffs to underpowered floor weapons, you can change the buffs here (or nerf the weapons instead!)
ttt_tweaks_vector_recoil 0.7
ttt_tweaks_pocket_damage 75
ttt_tweaks_pp19_firedelay 0.05
ttt_tweaks_pp19_damage 7
ttt_tweaks_pp19_recoil 1.2
ttt_tweaks_p228_recoil 25
ttt_tweaks_t38_damage 65
ttt_tweaks_g3sg1_damage 30
ttt_tweaks_gewehr43_damage 40
ttt_tweaks_gewehr43_firedelay 0.39
ttt_tweaks_luger_damage 20
ttt_tweaks_welrod_damage 30
ttt_tweaks_dp_damage 20
ttt_tweaks_banana_gun_ammo 20
ttt_tweaks_banana_gun_damage 30
ttt_tweaks_viper_rifle_damage 65
ttt_tweaks_ares_shrike_damage 12
ttt_tweaks_ares_shrike_recoil 2
ttt_tweaks_ares_shrike_clipsize 100
ttt_tweaks_ares_shrike_defaultclip 200

ttt_tweaks_ares_shrike_recoil_exponential 0          // Whether the Ares Shrike has exponentially increasing recoil as you shoot it

ttt_tweaks_artillery_rebuyable 0                    // Whether the artillery cannon is re-buyable or not
ttt_tweaks_artillery_always_red 1                   // Whether the artillery cannon should always be red
ttt_tweaks_artillery_cover_damage 1                 // Whether players should take reduced damage behind cover from the artillery cannon

ttt_tweaks_bonk_bat_floor_ceiling 1                 // Whether the jail created by the bonk bat should have a floor and ceiling

ttt_tweaks_invisibility_cloak_killer 0              // Whether the invisibility cloak should be given to Killers as a loadout weapon
ttt_tweaks_invisibility_cloak_removes_amatrasu 1    // Whether using the invisibility cloak removes your amatrasu weapon if you have one

ttt_tweaks_railgun_no_karma_penalty 0               // Whether the railgun doesn't take karma for kills, and killing someone holding a railgun doesn't take karma either

ttt_tweaks_better_damagenumber_default 1            // Whether the TF2 damage numbers mod is forced to better-looking defaults on the client

ttt_tweaks_hot_potato_no_copyright_music 0          // Whether the hot potato's music is replaced with non-copyright music

ttt_tweaks_simfphys_lvs_update_message 0            // Whether the simfphys/LVS mods should show 'A newer version is available!' messages in chat

ttt_tweaks_tips 1                                   // Whether TTT tips are enabled that show at the bottom of the screen while dead

ttt_tweaks_tfa_inspect 0                            // Whether inspecting TFA weapons is enabled

ttt_tweaks_auto_trigger_wallhack_randomat 0         // Seconds into a round to trigger the 'No-one can hide from my sight' randomat, set to 0 to disable

ttt_tweaks_pickup_prompt 1                          // Whether a 'Press E to pickup' prompt appears when looking closely at a weapon that can be picked up in that way

ttt_tweaks_deathcam_thirdperson 1                   // Whether your camera views your body in third-person rather than first-person on dying

ttt_tweaks_dead_ringer_original_behaviour 1         // Whether the TTT2 version of the dead ringer should act like the original version by default

ttt_tweaks_rmb_damage_reduction 0                   // Whether vanilla traitors take less damage from the red matter bomb, and vanilla jesters are immune

ttt_tweaks_force_off_notification_sound 1           // Whether the sound that plays when a notification appears in the top-right corner of the screen is forced off for all players

ttt_tweaks_bruhbunker_sound_hud_icon 1              // Whether the bruh bunker should show a HUD icon on being bought, and play a 'Bruh' sound effect on triggering
```

## Steam Workshop Link

<https://steamcommunity.com/sharedfiles/filedetails/?id=3101810034>

## Credits

'Happy Happy Game Show' Kevin MacLeod (incompetech.com)\
Licensed under Creative Commons: By Attribution 4.0 License\
<http://creativecommons.org/licenses/by/4.0/>\
Used when Hot Potato music replacement setting is on\
\
Credit to the original authors of the various mods fixed for the modified bits of their code used for the fixes:

- "Lift Grenade" by Corvatile\
Fixed error spam\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2958417945>

- "Mimic Spanwer" by Jensons\
Fixed error spam, fixed the "Mimics spawned" message not displaying to Custom Roles traitors\
<https://steamcommunity.com/sharedfiles/filedetails/?id=1092624255>

- "Beenade" by Jensons\
Fixed beenade not dealing less damage to Custom Roles traitors\
Fixed missing NULL entity check error\
<https://steamcommunity.com/sharedfiles/filedetails/?id=913310851>

- "Shark Trap" by TheBonBon\
Fixed the shark trap not killing when it should\
and error spamming whenever touching something that is not a player\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2550782000>

- "Orbital Bass Cannon" by Jase\
Fixed a heck of a lua error dump spam whenever the orbital bass cannon is used\
(10,000+ lines of errors...)\
<https://steamcommunity.com/sharedfiles/filedetails/?id=252189849>

- "Command Prompt" by Dark\
Fixed many lua errors with the different effects of the command prompt\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2181940209>

- "Amaterasu" by Dilusionz\
Fixed missing valid player check lua error\
<https://steamcommunity.com/sharedfiles/filedetails/?id=1978094981>

- "Time Manipulator" by Tony_Bamanabon\
Fixed various lua errors\
<https://steamcommunity.com/sharedfiles/filedetails/?id=1318271171>

- "Homerun Bat" by Hagen\
Fixed lua error if you appear to hit something on the server but not on the client\
<https://steamcommunity.com/sharedfiles/filedetails/?id=648957314>

- "The PropHuntGun" by Jensons\
Fixed the prop hunt gun not fully disguising you, you are now fully invisible and role icons like the detective icon no longer show overhead\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2796353349>

- "Artillery Cannon" by Valafi\
Added option for players to behind cover take reduced damage from the artillery cannon, added options to make artillery cannon always red and not re-buyable\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2087368173>

- "Hot Potato" by SkyDivingL\
Added option of changing the music of the hot potato to a royalty-free alternative\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2377790970>

- "Bonk Bat" by kev0\
Added an option for adding a ceiling and floor to the jail to prevent players from escaping\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2475989756>

- "Cloaking Device 2.0" by twilight\
Fixed becoming permanently invisible if handcuffed while using the cloak, added option to make the weapon given to the Killer role as part of their weapon loadout (not enabled by default), makes it so you cannot use the Amatrasu weapon at the same time as using the cloak\
<https://steamcommunity.com/sharedfiles/filedetails/?id=1389756626>

- "[TTT/2] Dead Ringer [ITEM]" by dhkatz\
Added convar to make the dead ringer behave exactly like the original version by default\
<https://steamcommunity.com/sharedfiles/filedetails/?id=3074845055>

- "TTT Weeping Angel SWEP" by DatLycan\
Fixed the weeping angel erroring whenever it is shot\
<https://steamcommunity.com/sharedfiles/filedetails/?id=1346794275>

- "[TTT] Jetpack" by HowdyImFate\
Fixed the jetpack erroring on being spawned\
<https://steamcommunity.com/sharedfiles/filedetails/?id=1735229517>

- "D.Va mech w/English voice actor" by Zydel\
Fixed the jetpack erroring on being spawned\
<https://steamcommunity.com/sharedfiles/filedetails/?id=942252663>

- "FiresTTT - Detective Bruh Bunker" by Sam\
Added a HUD icon to indicate the bruh bunker being bought, added a local "bruh" sound on being bought and a global "bruh" sound on triggering\
<https://steamcommunity.com/sharedfiles/filedetails/?id=942252663>

- HUD icon system originally created by Zaratusa
Modified by me to work with Custom Role's changes to passive items

## Extra fixes

The following mods were fixed without needing to change bits of their code.

- "Fortnite Building Tool" by LeBroomer\
Fixed lua error when holstering the fortnite building tool\
<https://steamcommunity.com/sharedfiles/filedetails/?id=1433010063>

- "R8 Revolver" by Corvatile\
Fixed shoot sound having no volume drop-off (shoot sound is global), fixed pistol not taking pistol slot\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2903604575>

- "Big Glock Compressed" by Frisco\
Fixed big glock not using TTT ammo\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2169931075>

- "Rocket Thruster" by Travh98\
Fixed rocket thruster using wrong HUD slot and its internal name as its display name\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2458340155>

- "Orbital Headcrab Launcher" by Leo\
Fixed headcrab launcher's name being too long\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2068059005>

- "Immortality Potion" by Malivil\
Fix immortality potion's name being too long\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2593566065>

- "No Scope AWP" by satrams\
Fixed no-scope AWP taking different slot visually than it actually takes\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2860986215>

- "Viper Rifle" by Kemot44\
Fixed not using TTT ammo and having a weird viewmodel, increased its damage to 65 to make it a clean 2 shot kill to make up for its long shoot delay and high recoil\
<https://steamcommunity.com/sharedfiles/filedetails/?id=1595492061>

- "Banana Pistol" by SweptThr.one\
Fixed not having a worldmodel and not using TTT ammo, also increase the weapon's damage and ammo slightly\
<https://steamcommunity.com/sharedfiles/filedetails/?id=921509375>

- "TF2 Damage Numbers" by wget\
Added option for TF2 damage numbers mod to have better colour defaults\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2791060001>

- "Randomat 2.0 for Custom Roles" by Malivil\
Added option for the "No-one can hide from my sight" randomat to trigger after there are so many minutes remaining"\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2055805086>

- "TFA Base" by YuRaNnNzZZ\
Added option to completely disable the TFA weapon inspect button as people accidentally press it and get stuck on the inspection screen\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2840031720>
