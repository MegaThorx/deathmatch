PlayerManager = inherit(Singleton)

function PlayerManager:constructor()
    self.m_Players = {}
    self.m_DataUpdateHook = Hook:New()

    NanosPlayer:Subscribe("Spawn", bind(self.Event_Spawn, self))
    Events:Subscribe("Player_UpdatePublicData", bind(self.Event_UpdatePublicData, self))

    Package:Log("PlayerManager:constructor")
    NanosWorld:Subscribe("SpawnLocalPlayer", function(localPlayer)
        Package:Log("NanosWorld.Subscribe")
        Player.LocalPlayer = localPlayer
    end)

    for _, player in pairs(NanosPlayer) do
        if player:IsValid() then
            if not instanceof(player, Player)  then
                enew(player, Player)
            end
            if player:IsLocalPlayer() then
                Player.LocalPlayer = player
            end
            table.insert(self.m_Players, player)
        end
    end
end

function PlayerManager:Event_UpdatePublicData(player, key, value)
    if player and player:IsValid() then
        player:__InternalSetPublicData(key, value)
        self.m_DataUpdateHook:Call(player, key, value)
    end
end

function PlayerManager:GetPlayers()
    return self.m_Players
end

function PlayerManager:GetDataUpdateHook()
    return self.m_DataUpdateHook
end

function PlayerManager:Event_Spawn(player)
    if not instanceof(player, Player) then
        enew(player, Player)
    end

    for k, v in pairs(self.m_Players) do
        if v == player then
            return
        end
    end

    table.insert(self.m_Players, player)
end

function PlayerManager:GetPlayers()
    return self.m_Players
end
