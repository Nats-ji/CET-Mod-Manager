player = Game.GetPlayer()
pos = player:GetWorldPosition()
pos.z = pos.z + 60
Game.TeleportPlayerToPosition(pos.x, pos.y, pos.z)
print("Bon voyage!")
