---@class backend
local backend = {
    GetMods = CETMMEXT.GetMods,                     ---@type fun(): Mods
    OpenModsFolder = CETMMEXT.OpenModsFolder,       ---@type fun(): void
    OpenDofilesFolder = CETMMEXT.OpenDofilesFolder, ---@type fun(): void
    OpenUrl = CETMMEXT.OpenUrl,                     ---@type fun(url: string): void
    GetFonts = CETMMEXT.GetFonts,                   ---@type fun(): Fonts
}

return backend