Core = inherit(Object)

function Core:constructor()
    CharacterManager:New()
    PlayerManager:New()
    GamemodeManager:New()
    WeaponManager:New()
    CommandManager:New()
    MapManager:New()

    PlayerManager:GetSingleton():InitializeExistingPlayers()
    self:InitializeCommands()

    Timer:SetTimeout(5000, bind(FixFallingCommand:GetSingleton().OnCommand, FixFallingCommand:GetSingleton()), {})
end

function Core:InitializeCommands()
    ListPlayersCommand:New()
    WeaponTestCommand:New()
    PaintingsCommand:New()
	FixFallingCommand:New()
	GamemodeCommand:New()
end

function Core:destructor()
    delete(PlayerManager:GetSingleton())
    delete(CharacterManager:GetSingleton())
    delete(WeaponManager:GetSingleton())
    delete(CommandManager:GetSingleton())
end
