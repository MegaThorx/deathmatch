local files = {
    "Classes/Core.lua",
    "Classes/Player.lua",
    "Classes/Character.lua",
    "Classes/HUD.lua",
    "Classes/PlayerManager.lua",
    "Classes/CharacterManager.lua",
    "Classes/ScoreboardManager.lua",

    "Classes/GamemodeManager.lua",
    "Classes/Gamemodes/BaseMode.lua",
    "Classes/Gamemodes/Deathmatch.lua",
    "Classes/Gamemodes/TeamDeathmatch.lua",
    "Classes/Gamemodes/SnowballFight.lua",
    "Classes/CommandManager.lua",

    "Classes/Commands/ListPlayersCommand.lua",
    "Classes/Commands/ListRoundPlayerCommand.lua",
    "Classes/Commands/RunCommand.lua"
}

for _, file in ipairs(files) do
    Package:Require(file)
end

for k, v in pairs(Package) do
    Package:Log("Package." .. tostring(k) .. ": " .. tostring(v))
end
Package:Subscribe("Load", function()
    core = Core:New()
end)

Package:Subscribe("Unload", function()
    if core then
        core:Delete()
    end
end)
