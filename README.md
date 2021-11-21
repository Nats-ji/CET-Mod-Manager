<a href="https://www.buymeacoffee.com/mingm"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=mingm&button_colour=FF5F5F&font_colour=ffffff&font_family=Comic&outline_colour=000000&coffee_colour=FFDD00" width="180px"></a>
<a href='https://ko-fi.com/U6U572VOM' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

# CyberEngineTweaks Mod Manager

## Features

Download: https://github.com/Nats-ji/CET-Mod-Manager/releases/

- A Mod Manager for CyberEngineTweaks based mods
- Enable/Disable CyberEngineTweaks based mods inside game with a single click
- Open the interface by pressing the hotkey you bound in CET
- An API for other mods to request for a list of mods (Archive mods, ASI plugins, CET mods, Redscripts, Red4Ext plugins) loaded by the game.


![imgage](https://staticdelivery.nexusmods.com/mods/3333/images/895/895-1610480969-1242777005.png)

## Installation

This mod requires the latest version of **Cyber Engine Tweaks** Mod. Please Install it first. https://github.com/yamashi/CyberEngineTweaks/releases

Put `cet_mod_manager` folder inside `\Cyberpunk 2077\bin\x64\plugins\cyber_engine_tweaks\mods\`

Restart the game. Or reload Mods from the CyberEngineTweaks Console.

## Usage

1. To use it, you just simply press `hotkey` you bound to open the inertface.

2. Press the button `Scan` to scan your installed mods. (Set the game to `Borderless Windows` mode to avoid being thrown out to the desktop.)

3. Tick/untick the checkbox in front of the mod name to enable/disable them.

4. Press the `Reload ALL Mods` button on the console to reload the mods.

### API

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

2. Remove the `cet_mod_manager` folder from `\Cyberpunk 2077\bin\x64\plugins\cyber_engine_tweaks\mods\`

3. Restart the game. Or reload Mods from the CyberEngineTweaks Console.

   *To uninstall CyberEngineTweaks please follow its uninstall instruction.
   
## Known Bug

None

## Credits

- yamashi's CyberEngineTweaks https://github.com/yamashi?tab=repositories
- WhySoSerious for answering every question I had about lua https://github.com/WSSDude420
- Development Team behind CyberEngineTweaks and and RED4extSDK
- CP77 Modding Tools Discord Community https://discord.gg/cp77modding
