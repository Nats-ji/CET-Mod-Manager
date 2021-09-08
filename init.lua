local CETMM = require ("scripts/CETMM")

CETMM.Initialize()
CETMM.Event()
CETMM.Update()
CETMM.Render()
CETMM.Shutdown()

return CETMM.GetAPI()