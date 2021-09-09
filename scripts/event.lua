local CETMM = require("scripts/CETMM")

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
