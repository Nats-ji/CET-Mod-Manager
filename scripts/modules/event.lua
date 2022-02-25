local CETMM = require("modules/CETMM")

---@class event
local event = {}

function event.Register()
  registerForEvent("onOverlayOpen", function()
    if CETMM.GetOptions().m_autoappear then
      CETMM.GetUISystem().GetWindow().m_draw = true
    end
  end)

  registerForEvent("onOverlayClose", function()
    if CETMM.GetOptions().m_autoappear then
      CETMM.GetUISystem().GetWindow().m_draw = false
    end
  end)
end

return event
