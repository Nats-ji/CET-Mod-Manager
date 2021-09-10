local CETMM = require("scripts/CETMM")
local dpi = require("scripts/gui/dpi")
local i18n = require("scripts/i18n")
local languages = require("lang/lang")
local widgets = require("scripts/gui/widgets")
local style = require("scripts/gui/style")
local theme = require("scripts/gui/theme")
local enums = CETMM.GetEnums()
local options = CETMM.GetOptions()
local mods = CETMM.GetModList()
local dofiles = CETMM.GetDofiles()

local window = {
  m_draw = true,
  m_over_size = false,
  m_btn_Dofiles = false,
  m_btn_Scan = false,
  m_btn_Help = false,
}

local layout = {
  _ = 0,
  tb_modlist_height = 0,
  tb_footer_heigh = 0,
  header_btn_height = 0,
  selectable_height = 25,
}

local function settings_popup()
  if ImGui.BeginPopup("Settings", ImGuiWindowFlags.NoMove) then
    ImGui.Spacing()
    ImGui.Text(i18n("text_select_settings"))
    ImGui.Spacing()

    options.m_autoscan = widgets.btnToggle({
      i18n("button_autoscan_on"), i18n("button_autoscan_off"),
    }, options.m_autoscan)

    ImGui.SameLine()

    options.m_autoappear = widgets.btnToggle({
      i18n("button_autoappear_on"), i18n("button_autoappear_off"),
    }, options.m_autoappear)

    -- Language list
    ImGui.Spacing()
    ImGui.Separator()
    ImGui.Spacing()
    ImGui.Text(i18n("text_select_lang"))
    ImGui.Spacing()
    ImGui.PushStyleVar(ImGuiStyleVar.SelectableTextAlign, 0, 0.5)
    for _, entry in ipairs(languages) do
      if ImGui.Selectable(entry.name, false, ImGuiSelectableFlags.None, 0,
                          layout.selectable_height) then
        options.m_lang = entry.id
        CETMM.GetLocale().SetLocale()
      end
    end

    ImGui.Spacing()
    ImGui.Separator()
    ImGui.Spacing()
    if ImGui.Selectable("Check Update", false, ImGuiSelectableFlags.None, 0,
                        layout.selectable_height) then
      CETMM.GetModOpEx().OpenLink(
        "https://www.nexusmods.com/cyberpunk2077/mods/895?tab=files")
    end
    if ImGui.Selectable("Buy me a coffee", false, ImGuiSelectableFlags.None, 0,
                        layout.selectable_height) then
      CETMM.GetModOpEx().OpenLink("https://www.buymeacoffee.com/mingm")
    end
    ImGui.PopStyleVar(1)

    ImGui.EndPopup()
  end
end

-- public methods

function window.Initialize()
  window.m_over_size = 600 * dpi.GetScale() > dpi.GetDisplayResolution().y * 0.8
  layout.selectable_height = 25 * dpi.GetScale()
end

function window.Render()
  window.m_draw = ImGui.Begin(i18n("window_title"), window.m_draw,
                              ImGuiWindowFlags.NoResize)
  if window.m_draw then
    -- Set window size and position
    ImGui.SetWindowPos(dpi.GetDisplayResolution().x / 2 - 210 * dpi.GetScale(),
                       dpi.GetDisplayResolution().y / 2 - 320 * dpi.GetScale(),
                       ImGuiCond.FirstUseEver)
    if window.m_over_size then
      ImGui.SetWindowSize(420 * dpi.GetScale(),
                          dpi.GetDisplayResolution().y * 0.8, ImGuiCond.Always)
    else
      ImGui.SetWindowSize(420 * dpi.GetScale(), 640 * dpi.GetScale(),
                          ImGuiCond.Always)
    end

    -- Header Buttons
    if ImGui.BeginTable("header_btns", 2, ImGuiTableFlags.NoSavedSettings) then
      ImGui.TableSetupColumn("col1", ImGuiTableColumnFlags.WidthStretch)
      ImGui.TableSetupColumn("col2", ImGuiTableColumnFlags.WidthFixed)
      ImGui.TableNextRow()
      ImGui.TableSetColumnIndex(0)
      window.m_btn_Dofiles = widgets.btnToggle(i18n("button_dofiles"),
                                               window.m_btn_Dofiles)
      ImGui.TableSetColumnIndex(1)

      -- Scan Button
      if ImGui.Button(i18n("button_scan")) then
        CETMM.GetScanSystem().ScanALL()
        dofiles.Scan()
      end

      layout._, layout.header_btn_height = ImGui.GetItemRectSize()

      ImGui.SameLine()

      -- Settings Button
      if ImGui.Button("!", layout.header_btn_height, layout.header_btn_height) then
        ImGui.OpenPopup("Settings")
      end
      if ImGui.IsItemHovered() then
        ImGui.SetTooltip(i18n("tooltip_btn_settings"))
      end

      -- Settings Popup Menu
      settings_popup()

      ImGui.SameLine()

      -- Help Button
      window.m_btn_Help = widgets.btnToggle("?", window.m_btn_Help,
                                            layout.header_btn_height,
                                            layout.header_btn_height)
      if ImGui.IsItemHovered() then
        ImGui.SetTooltip(i18n("tooltip_btn_help"))
      end

      ImGui.EndTable()
    end

    -- Helper Text
    if window.m_btn_Help then
      if not window.m_btn_Dofiles then
        style.PushColor(ImGuiCol.Text, theme.Separator)
        ImGui.TextWrapped(i18n("text_help_manager_1"))
        ImGui.Spacing()
        ImGui.TextWrapped(i18n("text_help_manager_2"))
        ImGui.Spacing()
        ImGui.TextWrapped(i18n("text_help_manager_3"))
        ImGui.Spacing()
        ImGui.TextWrapped(i18n("text_help_manager_4"))
        ImGui.Spacing()
        ImGui.TextWrapped(i18n("text_help_manager_5"))
        ImGui.PopStyleColor(1)
      else
        ImGui.TextWrapped(i18n("text_help_dofiles_1"))
        ImGui.Spacing()
        ImGui.TextWrapped(i18n("text_help_dofiles_2"))
        ImGui.Spacing()
        ImGui.TextWrapped(i18n("text_help_dofiles_3"))
        ImGui.Spacing()
        ImGui.TextWrapped(i18n("text_help_dofiles_4"))
        ImGui.Spacing()
        ImGui.TextWrapped(i18n("text_help_dofiles_5"))
      end
      ImGui.Spacing()
    end

    -- Mod List
    layout._, layout.tb_modlist_height = ImGui.GetContentRegionAvail()
    if ImGui.BeginTable("mod_list", 2, bit32.bor(
                          ImGuiTableFlags.NoSavedSettings,
                          ImGuiTableFlags.ScrollY), 0,
                        layout.tb_modlist_height - layout.tb_footer_heigh -
                          ImGui.GetStyle().ItemSpacing.y) then

      ImGui.TableSetupColumn("cb", ImGuiTableColumnFlags.WidthFixed)
      ImGui.TableSetupColumn("name", ImGuiTableColumnFlags.WidthStretch)

      -- Mod list
      if not window.m_btn_Dofiles then
        ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, 5, 5)

        for _, entry in ipairs(mods.Get()[enums.MODTYPE.CET]) do
          ImGui.TableNextRow(ImGuiTableRowFlags.None, 30 * dpi.GetScale())
          ImGui.TableSetColumnIndex(0)
          local state, pressed = ImGui.Checkbox("##" .. entry:GetName(),
                                                entry:IsEnabled())
          if pressed then
            CETMM.GetModOpEx().ToggleCETModState(entry)
          end
          ImGui.TableSetColumnIndex(1)
          ImGui.Text(entry:GetFormatedName())
        end

        ImGui.PopStyleVar(1)

        -- Dofile list
      else
        for _, entry in ipairs(dofiles.Get()) do
          ImGui.TableNextRow(ImGuiTableRowFlags.None, 30 * dpi.GetScale())
          ImGui.TableSetColumnIndex(0)
          if ImGui.Button("Run##" .. entry:GetName()) then
            entry:Run()
          end
          ImGui.TableSetColumnIndex(1)
          ImGui.Text(entry:GetFormatedName())
        end
      end

      ImGui.EndTable()
    end

    -- Footer Buttons
    if ImGui.BeginTable("footer_btns", 1, ImGuiTableFlags.NoSavedSettings) then
      ImGui.TableNextRow()
      ImGui.TableSetColumnIndex(0)

      if ImGui.Button(i18n("button_mods_folder")) then
        CETMM.GetModOpEx().OpenFolder(CETMM.GetPaths().cetmods)
      end

      ImGui.SameLine()

      if ImGui.Button(i18n("button_dofile_folder")) then
        CETMM.GetModOpEx().OpenFolder(CETMM.GetPaths().cetmmRoot / "dofiles")
      end

      ImGui.EndTable()
    end
    layout._, layout.tb_footer_heigh = ImGui.GetItemRectSize()
  end
  ImGui.End()
end

return window
