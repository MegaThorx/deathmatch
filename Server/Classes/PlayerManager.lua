PlayerManager = inherit(Singleton)

function PlayerManager:constructor()
    self.m_Players = {}
    self.m_QuitHook = Hook:New()
    self.m_DeathHook = Hook:New()

    NanosPlayer:Subscribe("Spawn", bind(self.Event_Spawn, self))
    NanosPlayer:Subscribe("Possess", bind(self.Event_Possess, self))
    NanosPlayer:Subscribe("UnPossess", bind(self.Event_UnPossess, self))
    NanosPlayer:Subscribe("Destroy", bind(self.Event_Destroy, self))

    Events:Subscribe("Player_Ready", bind(self.Ready, self))

    for _, player in pairs(NanosPlayer) do
        self:Event_Spawn(player)
    end
end

function PlayerManager:destructor()
    for _, player in pairs(NanosPlayer) do
        player:Delete()
    end
end

function PlayerManager:InitializeExistingPlayers()
    for _, player in pairs(NanosPlayer) do
        if player:IsValid() then
            enew(player, Player)
        end
    end
end

function PlayerManager:IsNameUsed(name)
    for _, player in pairs(self.m_Players) do
        if player:GetName() == name then
            return true
        end
    end

    return false
end

function PlayerManager:Event_Spawn(player)
    local nameIsUsed = self:IsNameUsed(player:GetName())

    if nameIsUsed then
        local num = 1
        while true do
            local name = player:GetName() .. num

            if not self:IsNameUsed(name) then
                player:SetName(player:GetName() .. num)
                break
            end

            num = num + 1
        end
    end

    table.insert(self.m_Players, player)
end

function PlayerManager:Ready(player)
    Package:Log("PlayerManager:Ready @ " .. tostring(player))
    GamemodeManager:GetSingleton():AddPlayer(player)

    for _, tPlayer in pairs(self.m_Players) do
        tPlayer:SendAllPublicDataTo(player)
    end
end

function PlayerManager:Event_Respawn(player)
    -- player:Respawn()
end

function PlayerManager:Event_Possess(player, character)
end

function PlayerManager:Event_UnPossess(player, character, isDisconnecting)
end

function PlayerManager:Event_Destroy(player)
    Package:Log("PlayerManager:Event_Destroy @ " .. tostring(player))
    self.m_QuitHook:Call(player)
    table.removevalue(self.m_Players, player)
end

function PlayerManager:OnPlayerDeath(player, character, instigator, lastDamageTaken, lastBoneDamaged, damageTypeReason, hitFromDirection)
    self.m_DeathHook:Call(player, character, instigator, lastDamageTaken, lastBoneDamaged, damageTypeReason, hitFromDirection)
end

function PlayerManager:GetQuitHook()
    return self.m_QuitHook
end

function PlayerManager:GetDeathHook()
    return self.m_DeathHook
end
