local files = {
    "Constants/Weapons.lua",

    "Classes/Core.lua",
    "Classes/Player.lua",
    "Classes/Character.lua",
    "Classes/Weapon.lua",
    "Classes/PlayerManager.lua",
    "Classes/WeaponManager.lua",
    "Classes/CharacterManager.lua",
    "Classes/CommandManager.lua",
    "Classes/Map.lua",
    "Classes/MapManager.lua",

    "Classes/GamemodeManager.lua",
    "Classes/Gamemodes/BaseMode.lua",
    "Classes/Gamemodes/Deathmatch.lua",
    "Classes/Gamemodes/TeamDeathmatch.lua",
    "Classes/Gamemodes/SnowballFight.lua",

    "Classes/Commands/ListPlayersCommand.lua",
    "Classes/Commands/WeaponTestCommand.lua",
    "Classes/Commands/PaintingsCommand.lua",
	"Classes/Commands/FixFallingCommand.lua",
	"Classes/Commands/GamemodeCommand.lua",
    "Classes/Commands/RunCommand.lua",

    "MapDefinition.lua"
}

for _, file in ipairs(files) do
    Package:Require(file)
end

Package:Subscribe("Load", function()
    core = Core:New()
end)

Package:Subscribe("Unload", function()
    if core then
        core:Delete()
    end
end)
