<a href="https://www.buymeacoffee.com/mingm"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=mingm&button_colour=FF5F5F&font_colour=ffffff&font_family=Comic&outline_colour=000000&coffee_colour=FFDD00" width="180px"></a>
<a href='https://ko-fi.com/U6U572VOM' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

# CyberEngineTweaks Mod Manager

## Features

Download: https://github.com/Nats-ji/CET-Mod-Manager/releases/

Nexusmods: https://www.nexusmods.com/cyberpunk2077/mods/895

- A Mod Manager for CyberEngineTweaks based mods
- Enable/Disable CyberEngineTweaks based mods inside game with a single click
- Open the interface by pressing the hotkey you bound in CET


![imgage](https://staticdelivery.nexusmods.com/mods/3333/images/895/895-1610480969-1242777005.png)

## Installation

This mod requires:
1. the latest version of **Cyber Engine Tweaks** Mod. [[nexusmods]](https://www.nexusmods.com/cyberpunk2077/mods/107) | [[github]](https://github.com/yamashi/CyberEngineTweaks)
2. the latest version of **Red4EXT**. [[nexusmods]](https://www.nexusmods.com/cyberpunk2077/mods/2380) | [[github]](https://github.com/WopsS/RED4ext)

Extract `bin` into the root directory of Cyberpunk2077's install path.

Restart the game.

## Usage

1. To use it, you just simply press `hotkey` you bound to open the inertface.

2. Press the button `Scan` to scan your installed mods.

3. Tick/untick the checkbox in front of the mod name to enable/disable them.

4. Press the `Reload ALL Mods` button on the console to reload the mods.

### Change language
Check this [guide](https://wiki.redmodding.org/cyber-engine-tweaks/getting-started/configuration/change-font-and-font-size#how-to-display-non-english-characters) for more information.

### API (deprecated)

1. To use the API (currently only supports CET) to query the mod list
   ```lua
   -- returns a table
   modlist = GetMod("cet_mod_manager").GetModList()

   -- print the mod list in console
   GetMod("cet_mod_manager").PrintModList()
   ```
2. Return format by the API
   ```lua
   {
      archive = { "a", "list", "of", "mods"},
      asi = { "a", "list", "of", "mods"},
      cet = { "a", "list", "of", "mods"},
      red4ext = { "a", "list", "of", "mods"},
      redscript = { "a", "list", "of", "mods"}
   }
   ```

## Uninstallation

1. Before you uninstall this mod, make sure you have **re-enabled** all the mods.

2. Remove `cet_mod_manager.asi` from `\Cyberpunk 2077\bin\x64\plugins\`

## Translations
- English
- Simplified Chinese (Translator: Nats-ji)
- Traditional Chinese (Translator: Nats-ji)
- Japanese (Translator: Nats-ji)
- German (Translator: keanuWheeze)
- Russian (Translator: vanja-san)
- Turkish (Translator: sebepne)
- Romanian (Translator: Maddmaniak)
- Brazilian Portuguese (Translator: mathfelin)

## Credits

- yamashi's CyberEngineTweaks https://github.com/yamashi?tab=repositories
- WhySoSerious for answering every question I had about lua https://github.com/WSSDude420
- Development Team behind CyberEngineTweaks and and RED4extSDK
- CP77 Modding Tools Discord Community https://discord.gg/cp77modding
- And people who translated for this project.
