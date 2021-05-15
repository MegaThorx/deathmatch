GamemodeManager = inherit(Singleton)

function GamemodeManager:constructor()
    self.m_SupportedModes = {
        [Deathmatch.Name] = Deathmatch,
		[TeamDeathmatch.Name] = TeamDeathmatch,
		[SnowballFight.Name] = SnowballFight
    }

    self.m_CurrentMode = nil

    Events:Subscribe("GameMode_StartGame", bind(self.StartGame, self))
    Events:Subscribe("GameMode_CountdownStart", bind(self.CountdownStart, self))
    Events:Subscribe("GameMode_RoundStart", bind(self.RoundStart, self))
    Events:Subscribe("GameMode_RoundEnd", bind(self.RoundEnd, self))
    Events:Subscribe("GameMode_CountdownEnd", bind(self.CountdownEnd, self))
    Events:Subscribe("GameMode_EndGame", bind(self.EndGame, self))
    Events:Subscribe("GameMode_AddPlayer", bind(self.AddPlayer, self))
    Events:Subscribe("GameMode_RemovePlayer", bind(self.RemovePlayer, self))
	Events:Subscribe("GameMode_UpdatePublicData", bind(self.UpdatePublicData, self))
end

function GamemodeManager:destructor()
    if self.m_CurrentMode then
        delete(self.m_CurrentMode)
    end
end

function GamemodeManager:StartGame(gameMode)
    if self.m_CurrentMode then
        delete(self.m_CurrentMode)
    end

    self.m_CurrentMode = self.m_SupportedModes[gameMode]:New()
end

function GamemodeManager:EndGame()
    if self.m_CurrentMode then
        delete(self.m_CurrentMode)
    end
end

function GamemodeManager:RoundStart()
	if self.m_CurrentMode then
		self.m_CurrentMode:RoundStart()

		HUD:GetSingleton():TriggerEvent("GameModeUpdate", self.m_CurrentMode:GetName())
    end
end

function GamemodeManager:RoundEnd()
    if self.m_CurrentMode then
        self.m_CurrentMode:RoundEnd()
		HUD:GetSingleton():TriggerEvent("GameModeUpdate", "unknown")
    end
end

function GamemodeManager:CountdownStart()
    if self.m_CurrentMode then
        self.m_CurrentMode:CountdownStart()
    end
end

function GamemodeManager:CountdownEnd()
    if self.m_CurrentMode then
        self.m_CurrentMode:CountdownEnd()
    end
end

function GamemodeManager:UpdatePublicData(key, value)
    if self.m_CurrentMode then
        self.m_CurrentMode:UpdatePublicData(key, value)
    end
end

function GamemodeManager:AddPlayer(player)
    if self.m_CurrentMode then
        self.m_CurrentMode:AddPlayer(player)
    end
end

function GamemodeManager:RemovePlayer(player)
    if self.m_CurrentMode then
        self.m_CurrentMode:RemovePlayer(player)
    end
end
