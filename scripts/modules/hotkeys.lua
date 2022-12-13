local i18n = require("modules/i18n")

---@class hotkeys
local hotkeys = {}

-- public
function hotkeys.Register()
  registerHotkey("hotkey_manager", i18n.translate("hotkey_manager"), function ()
    CETMM.GetUISystem().GetWindow().m_btn_Dofiles = false
    CETMM.GetUISystem().GetWindow().m_draw = not CETMM.GetUISystem().GetWindow().m_draw
  end)

  registerHotkey("hotkey_dofiles", i18n.translate("hotkey_dofiles"), function ()
    CETMM.GetUISystem().GetWindow().m_btn_Dofiles = true
    CETMM.GetUISystem().GetWindow().m_draw = not CETMM.GetUISystem().GetWindow().m_draw
  end)
end

return hotkeys