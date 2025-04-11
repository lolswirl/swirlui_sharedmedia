# SwirlUI SharedMedia
created for custom sounds on various effects such as shadowmeld, bloodlust, dwarf plus specific kaze mrt reminders for spells and abilities like healthpot, personals, revival, invoke chi-ji, evangelism, etc.

## Sound Creation
created via [voicemaker.in](https://voicemaker.in)  
setting used:
 - kaiya (f) / english
 - volume: 20db
 - speed: 13%
 - pitch: 0%
 - v2
 - 48000Hz mp3

## Modifications

new media can be added directly into their respective folders, then by executing [updateMedia.sh](https://github.com/lolswirl/swirlui_sharedmedia/blob/master/updateMedia.sh), the script will automatically register new media entries into the addon.

if creating new kaze cooldown callouts, enter the `name: iconId` pair as well as the `longName: shortName` pair, if it exists, of the spell into [iconLinks.json](https://github.com/lolswirl/swirlui_sharedmedia/blob/master/iconLinks.json) to combine a cooldown audio file with its own icon and register it with a short name

## Special Thanks

special thanks to [vaethryn](https://x.com/vaethryn/status/1868019620659019778) for creating the bad spec icons that are used in details or other places among my ui pack :3