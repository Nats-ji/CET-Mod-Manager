local dpi = require("modules/gui/dpi")
local i18n = require("modules/i18n")
local languages = require("lang/lang")
local widgets = require("modules/gui/widgets")
local themeSys = require("modules/gui/themeSys")
local options = CETMM.GetOptions()
local mods = CETMM.GetBackEnd().GetMods()
local dofiles = CETMM.GetDofiles()
-- local font = CETMM.GetFont()

---@class window
local window = {
  m_draw = false,
  m_draw_about = false,
  -- m_draw_font = false,
  m_about_title = "",
  m_about_text = "",
  m_over_size = false,
  m_btn_Dofiles = false,
  m_btn_Scan = false,
  m_btn_Help = false
}

local font_popup = {
  m_fontlist_current_item = "",
  m_fontstyle_current_item = ""
}

local layout = {
  _ = 0,
  tb_modlist_height = 0,
  tb_footer_heigh = 0,
  header_btn_height = 0
}

local function renderAboutWindow()
  window.m_draw_about = ImGui.Begin(window.m_about_title, window.m_draw_about, bit32.bor(ImGuiWindowFlags.NoSavedSettings, ImGuiWindowFlags.NoResize))
  if window.m_draw_about then
    themeSys.GetCurrentTheme():CallIf("white", "GetHoverState", "about")
    ImGui.SetWindowPos(dpi.GetDisplayResolution().x / 2 - dpi.Scale(300),
                          dpi.Scale(dpi.GetDisplayResolution().y * 0.1),
                         ImGuiCond.FirstUseEver)
    ImGui.SetWindowSize(dpi.Scale(600),
                        dpi.GetDisplayResolution().y * 0.8, ImGuiCond.FirstUseEver)
    ImGui.Text(window.m_about_text)
    ImGui.End()
  end
end

---@param aFile string
---@return string
local function loadFile(aFile)
  local text = ""
  local file = io.open(aFile)
  if file ~= nil then
    text = file:read("*a")
    file:close()
  end
  return text
end

-- local function renderFontWidnow()
--   window.m_draw_font = ImGui.Begin("Font", window.m_draw_font, ImGuiWindowFlags.NoSavedSettings)
--   if window.m_draw_font then
--     ImGui.SetWindowPos(dpi.GetDisplayResolution().x / 2 - 300 * dpi.GetScale(),
--                          dpi.GetDisplayResolution().y * 0.1 * dpi.GetScale(),
--                          ImGuiCond.FirstUseEver)
--     ImGui.Text("Font:")
--     if ImGui.BeginCombo("Font", font_popup.m_fontlist_current_item) then

--       if ImGui.Selectable("Default", font_popup.m_fontlist_current_item == "Default") then
--         font_popup.m_fontlist_current_item = "Default"
--         font_popup.m_fontstyle_current_item = "Regular"
--       end
--       if font_popup.m_fontlist_current_item == "Default" then
--         ImGui.SetItemDefaultFocus()
--       end

--       for _, fontfamily in ipairs(font.fontfamilies) do
--         local is_selected = font_popup.m_fontlist_current_item == fontfamily
--         if ImGui.Selectable(fontfamily, is_selected) then
--           font_popup.m_fontlist_current_item = fontfamily
--           for fontstyle, _ in pairs(font.list[fontfamily]) do
--             font_popup.m_fontstyle_current_item = fontstyle
--             break
--           end
--         end
--         if is_selected then
--           ImGui.SetItemDefaultFocus()
--         end
--       end
--       ImGui.EndCombo()
--     end
--     ImGui.Text("Font Style:")
--     if ImGui.BeginCombo("Font Style", font_popup.m_fontstyle_current_item) then
--       if font_popup.m_fontlist_current_item == "Default" then
--         ImGui.Selectable("Regular", true)
--         ImGui.SetItemDefaultFocus()
--       elseif type(font.list[font_popup.m_fontlist_current_item]) == "table" then
--         for fontstyle, _ in pairs(font.list[font_popup.m_fontlist_current_item]) do
--           local is_selected = font_popup.m_fontstyle_current_item == fontstyle
--           if ImGui.Selectable(fontstyle, is_selected) then
--             font_popup.m_fontstyle_current_item = fontstyle
--           end
--           if is_selected then
--             ImGui.SetItemDefaultFocus()
--           end
--         end
--       end
--       ImGui.EndCombo()
--     end
--     ImGui.Text("Size:")
--     ImGui.Text("Font Range:")

--     ImGui.Button("Ok")
--     ImGui.SameLine()
--     ImGui.Button("Cancel")
--     ImGui.End()
--   end
-- end

local function settings_popup()
  ImGui.PushStyleVar(ImGuiStyleVar.WindowPadding, dpi.Scale(8), dpi.Scale(12))
  if ImGui.BeginPopup("Settings", ImGuiWindowFlags.NoMove) then
    ImGui.PushStyleVar(ImGuiStyleVar.ItemSpacing, dpi.Scale(8), dpi.Scale(15))  -- Menu item height
    ImGui.Text(i18n("text_select_settings"))

    options.m_autoappear = widgets.btnToggle({
      i18n("button_autoappear_on"), i18n("button_autoappear_off"),
    }, options.m_autoappear)
    
    ImGui.Separator()
    
    -- Font #not ready
    -- if ImGui.MenuItem("Font") then
    --   -- window.m_draw_font = true
    -- end

    -- Theme
    if ImGui.BeginMenu("Theme") then
      if select(2, ImGui.MenuItem("Default", "", options.m_theme == "default")) then
        themeSys.Load("default")
      end
      if select(2, ImGui.MenuItem("UA Special", "", options.m_theme == "ua_special")) then
        themeSys.Load("ua_special")
      end
      if select(2, ImGui.MenuItem("White", "", options.m_theme == "white")) then
        themeSys.Load("white")
      end
      ImGui.EndMenu()
    end
    
    -- Language menu
    if ImGui.BeginMenu("Language") then
      ImGui.Text(i18n("text_select_lang"))
      ImGui.SameLine()
      
      ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, 0, 0) -- help ? button padding
      if ImGui.Button("?", ImGui.GetFontSize() + dpi.Scale(2), ImGui.GetFontSize() + dpi.Scale(2)) then
        CETMM.GetBackEnd().OpenUrl("font_wiki")
      end
      ImGui.PopStyleVar()
      if ImGui.IsItemHovered() then
        ImGui.SetTooltip(i18n("tooltip_btn_howto_change_font"))
      end

      for _, entry in ipairs(languages) do
        if select(2, ImGui.MenuItem(entry.name, "", options.m_lang == entry.id)) then
          options.m_lang = entry.id
          CETMM.GetLocale().SetLocale()
        end
      end

      ImGui.EndMenu()
    end

    -- Select language hint text and help button

    ImGui.Separator()

    if ImGui.MenuItem("LICENSE") then
      window.m_about_title = "License"
      window.m_draw_about = true
      window.m_about_text = loadFile("LICENSE")
    end
    if ImGui.MenuItem("Third Party License") then
      window.m_about_title = "Third Party License"
      window.m_draw_about = true
      window.m_about_text = loadFile("Third_Party_LICENSES")
    end
    if ImGui.MenuItem(string.format([[%s (v%s)]], "Check Update",
                                      CETMM.GetVersion())) then
      CETMM.GetBackEnd().OpenUrl("update")
    end

    ImGui.Separator()

    if ImGui.MenuItem("Buy me a coffee") then
      CETMM.GetBackEnd().OpenUrl("coffee")
    end

    ImGui.PopStyleVar() -- Pop menu item height
    ImGui.EndPopup()
  end
  ImGui.PopStyleVar()
end

-- public methods

function window.Initialize()
  window.m_over_size = 600 * dpi.GetScale() > dpi.GetDisplayResolution().y * 0.8
  -- font_popup.m_fontlist_current_item = font.current_settings.fontfamily
  -- font_popup.m_fontstyle_current_item = font.current_settings.style
end

function window.Render()
  window.m_draw = ImGui.Begin(i18n("window_title"), window.m_draw)
  if window.m_draw then
    -- Hover check for white theme
    themeSys.GetCurrentTheme():CallIf("white", "GetHoverState", "main")
    -- Set window size and position
    ImGui.SetWindowPos(dpi.GetDisplayResolution().x / 2 - 210 * dpi.GetScale(),
                       dpi.GetDisplayResolution().y / 2 - 320 * dpi.GetScale(),
                       ImGuiCond.FirstUseEver)
    if window.m_over_size then
      ImGui.SetWindowSize(420 * dpi.GetScale(),
                          dpi.GetDisplayResolution().y * 0.8, ImGuiCond.FirstUseEver)
    else
      ImGui.SetWindowSize(420 * dpi.GetScale(), 640 * dpi.GetScale(),
                          ImGuiCond.FirstUseEver)
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
      if widgets.button(i18n("button_scan")) then
        mods.Scan()
        dofiles.Scan()
      end

      layout._, layout.header_btn_height = ImGui.GetItemRectSize()

      ImGui.SameLine()

      -- Settings Button
      if widgets.button("!", layout.header_btn_height, layout.header_btn_height, false) then
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
                                            layout.header_btn_height, false)
      if ImGui.IsItemHovered() then
        ImGui.SetTooltip(i18n("tooltip_btn_help"))
      end

      ImGui.EndTable()
    end

    -- Helper Text
    if window.m_btn_Help then
      if not window.m_btn_Dofiles then
        ImGui.TextWrapped(i18n("text_help_manager_1"))
        ImGui.Spacing()
        ImGui.TextWrapped(i18n("text_help_manager_2"))
        ImGui.Spacing()
        ImGui.TextWrapped(i18n("text_help_manager_3"))
        ImGui.Spacing()
        ImGui.TextWrapped(i18n("text_help_manager_4"))
        ImGui.Spacing()
        ImGui.TextWrapped(i18n("text_help_manager_5"))
      else
        themeSys.PushColor(ImGuiCol.Text, themeSys.GetCurrentTheme():GetStyleColor("AltText"))
        ImGui.TextWrapped(i18n("text_help_dofiles_1"))
        ImGui.Spacing()
        ImGui.TextWrapped(i18n("text_help_dofiles_2"))
        ImGui.Spacing()
        ImGui.TextWrapped(i18n("text_help_dofiles_3"))
        ImGui.Spacing()
        ImGui.TextWrapped(i18n("text_help_dofiles_4"))
        ImGui.Spacing()
        ImGui.TextWrapped(i18n("text_help_dofiles_5"))
        ImGui.PopStyleColor(1)
      end
      ImGui.Spacing()
    end

    -- Mod List
    layout._, layout.tb_modlist_height = ImGui.GetContentRegionAvail()
    ImGui.PushStyleVar(ImGuiStyleVar.CellPadding, dpi.Scale(4), dpi.Scale(6))
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

        if #mods.GetCETMods() == 0 then -- Hint text when not scanned
          ImGui.TableNextRow(ImGuiTableRowFlags.None, 30 * dpi.GetScale())
          ImGui.TableSetColumnIndex(0)
          ImGui.Text(i18n.translate("text_please_scan"))

        else
          for _, entry in ipairs(mods.GetCETMods()) do
            ImGui.TableNextRow(ImGuiTableRowFlags.None, 30 * dpi.GetScale())
            ImGui.TableSetColumnIndex(0)
            ImGui.BeginDisabled(entry:GetName() == "cet_mod_manager")
            local state, pressed = ImGui.Checkbox("##" .. entry:GetName(),
                                                  entry:IsEnabled())
            ImGui.EndDisabled()
            if pressed then
              entry:Toggle()
            end
            ImGui.TableSetColumnIndex(1)
            ImGui.Text(entry:GetFormatedName())
          end
        end

        ImGui.PopStyleVar(1)

        -- Dofile list
      else
        if (#dofiles.Get()) == 0 then -- Hint text when no dofiles
          ImGui.TableNextRow(ImGuiTableRowFlags.None, 30 * dpi.GetScale())
          ImGui.TableSetColumnIndex(0)
          ImGui.Text(i18n.translate("text_no_dofiles"))

        else
          for _, entry in ipairs(dofiles.Get()) do
            ImGui.TableNextRow(ImGuiTableRowFlags.None, 30 * dpi.GetScale())
            ImGui.TableSetColumnIndex(0)
            if widgets.button(i18n("button_dofile_run").."##" .. entry:GetName()) then
              entry:Run()
            end
            ImGui.TableSetColumnIndex(1)
            ImGui.Text(entry:GetFormatedName())
          end
        end
      end

      ImGui.EndTable()
    end
    ImGui.PopStyleVar(1)

    -- Footer Buttons
    if ImGui.BeginTable("footer_btns", 2, ImGuiTableFlags.NoSavedSettings) then
      ImGui.TableSetupColumn("col1", ImGuiTableColumnFlags.WidthStretch)
      ImGui.TableSetupColumn("col2", ImGuiTableColumnFlags.WidthFixed)
      ImGui.TableNextRow()
      ImGui.TableSetColumnIndex(0)

      if widgets.button(i18n("button_mods_folder")) then
        CETMM.GetBackEnd().OpenModsFolder()
      end

      ImGui.SameLine()

      if widgets.button(i18n("button_dofile_folder")) then
        CETMM.GetBackEnd().OpenDofilesFolder()
      end

      themeSys.GetCurrentTheme():CallIf("ua_special", "RenderFooter")

      ImGui.EndTable()
    end
    layout._, layout.tb_footer_heigh = ImGui.GetItemRectSize()
    ImGui.End()
  end

  renderAboutWindow()
  -- renderFontWidnow()
end

return window
