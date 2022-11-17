---Type defines for backend
---@meta
---@diagnostic disable

---@class FontStyle
---@field family string
---@field style string

---@class FontFamily
---@field family string
---@field styles FontStyle[]

---@class Fonts
---@field currentFamily FontFamily
---@field currentStyle FontStyle
---@field currentGlyph string
---@field currentSize number
---@field settingChanged boolean
---@field families FontFamily[]
---@field SetFont fun(aFontFamily: FontFamily, aFontStyle: FontStyle, aGlyph: string, aSize: number): nil

---@class Mod
---@field GetName fun(): string
---@field GetFormatedName fun(): string
---@field IsEnabled fun(): boolean
---@field Toggle fun(): nil

---@class Mods
---@field Scan fun(): nil
---@field GetCETMods fun(): Mod[]

---@class Uninstall
---@field IsAsiRemoved fun(): bool
---@field SetFilesToRemove fun(aRemoveFiles: bool, aRemoveConfig: bool, aRemoveDofiles: bool): nil