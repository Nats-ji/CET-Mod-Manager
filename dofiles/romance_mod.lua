-- Credit to axstin https://github.com/axstin/cyberpunk-things/tree/master/romance-mod
for i, v in next, { "judy", "river", "kerry", "panam" } do
    Game.GetQuestsSystem():SetFactStr(v .. "_romanceable", 1)
end
print("Now go date.")
