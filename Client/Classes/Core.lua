Core = inherit(Object)

function Core:constructor()
	PlayerManager:New()
	CharacterManager:New()
    CommandManager:New()

    self:InitializeCommands()

    self.m_ReadyCheckTimer = Timer:SetTimeout(50, bind(self.CheckIfReady, self), {})

	-- self.m_Music = Sound(Vector(), "SnowMap::A_Christmas_Background_Music", true, false, 1, 0.25, 1)
end

function Core:InitializeCommands()
    ListPlayersCommand:New()
    ListRoundPlayerCommand:New()
end

function Core:CheckIfReady()
    if Player.LocalPlayer then
        Timer:ClearTimeout(self.m_ReadyCheckTimer)
        self:Ready()
    end
    return true
end

function Core:Ready()
    HUD:New()
    GamemodeManager:New()
    ScoreboardManager:New()
    Events:CallRemote("Player_Ready", {Player.LocalPlayer})
end

function Core:destructor()
	Package:Log("Destroying Core")
	-- self.m_Music:Destroy()
    delete(HUD:GetSingleton())
    delete(GamemodeManager:GetSingleton())
end
