ScoreboardManager = inherit(Singleton)

function ScoreboardManager:constructor()
    self.m_UpdateScoreboard = bind(self.UpdateScoreboard, self)

    PlayerManager:GetSingleton():GetDataUpdateHook():Register(self.m_UpdateScoreboard)
    Timer:SetTimeout(200, self.m_UpdateScoreboard, {})

    Client:Subscribe("KeyDown", bind(self.ShowScoreboard, self))
    Client:Subscribe("KeyUp", bind(self.HideScoreboard, self))
end

function ScoreboardManager:UpdateScoreboard()
    local players = {}

    -- {name: 'MegaThorx', team: 0, data: [{name: 'Kills', value: '7'}, {name: 'Deaths', value: '3'}, {name: 'Score', value: '1123'}]}

    for _, player in pairs(PlayerManager:GetSingleton():GetPlayers()) do
        if player:IsValid() then
            local entry = {}

            entry.name = player:GetName()
            entry.ping = player:GetPing()
            entry.data = {}
            entry.team = 0
            
            local character = player:GetControlledCharacter()

            if character then
                entry.team = character:GetTeam()
            end

            for name, value in pairs(player:GetAllPublicData()) do
                entry.data[name] = value
            end

            table.insert(players, entry)
        end
    end


	HUD:GetSingleton():TriggerEvent("ScoreboardSetPlayers", JSON.stringify(players))
end

function ScoreboardManager:ShowScoreboard(keyName)
    if keyName == "Tab" then
        HUD:GetSingleton():TriggerEvent("ScoreboardSetVisible", true)
    end
end

function ScoreboardManager:HideScoreboard(keyName)
    if keyName == "Tab" then
        HUD:GetSingleton():TriggerEvent("ScoreboardSetVisible", false)
    end
end