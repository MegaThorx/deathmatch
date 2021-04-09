Deathmatch = inherit(BaseMode)
Deathmatch.Name = "deathmatch"

function Deathmatch:virtual_constructor()
    self.m_Name = Deathmatch.Name

	self.m_PublicData["timeLimit"] = 15 * 60
	self.m_PublicData["scoreLimit"] = 30

    self.m_TimeStart = os.time()
    self.m_Ending = false

    self.m_Respawn = bind(self.Respawn, self)

    self.m_Spawns = MapManager:GetSingleton():GetCurrentMap():GetSpawnLocations(self.m_Name)
    self.m_ViewModes = MapManager:GetSingleton():GetCurrentMap():GetViewModes()
    self.m_Timer = Timer:SetTimeout(500, bind(self.Tick, self), {})
end

function Deathmatch:virtual_destructor()
    Timer:ClearTimeout(self.m_Timer)
    for k, player in ipairs(self.m_Players) do
        if player:IsValid() then
            local character = player:GetControlledCharacter()
            if character and character:IsValid() then
                local weapon = character:GetCurrentPickUpObject()
                if weapon and weapon:IsValid() then
                    weapon:Destroy()
                end
                character:Destroy()
            end
        end
    end
end

function Deathmatch:EndRound()
    if self.m_Ending then
        return
    end

    self.m_Ending = true
    for k, player in ipairs(self.m_Players) do
        if player:GetControlledCharacter() then
            self:OnPlayerDeath(player:GetControlledCharacter(), player, nil)
            player:GetControlledCharacter():Destroy()
        end

        Events:CallRemote("GameMode_RoundEnd", player, {})
    end

    --[[
    Timer:SetTimeout(10 * 1000, function()
        GamemodeManager:GetSingleton():NextGame()
        return false
    end, {})
    ]]
end

function Deathmatch:CanStart()
    Package:Log("Deathmatch:CanStart " .. tostring(self:GetState()) .. " " .. tostring(#self.m_Players))
    if self:GetState() == BaseMode.States.PreRound then
        if #self.m_Players >= 2 then
            return true
        end
    end

    return false
end

function Deathmatch:Tick()
    self.m_TimeElapsed = os.time() - self.m_TimeStart

    if self.m_TimeElapsed >= self:GetTimeLimit() then
        self:EndRound()
    end
end

function Deathmatch:AddPlayer(player)
	table.insert(self.m_Players, player)

    player:SetPublicData("Score", 0)
    player:SetPublicData("Kills", 0)
	player:SetPublicData("Deaths", 0)

    Events:CallRemote("GameMode_RoundStart", player, {})

    player:SetLockedViewMode("FPV")

    self:Spawn(player)
end

function Deathmatch:RemovePlayer(player)
    table.removevalue(self.m_Players, player)
end

function Deathmatch:Spawn(player)
    if self.m_Ending then
        return
	end

    local position = self.m_Spawns[math.random(1, #self.m_Spawns)]
    local character = NanosCharacter(position)
    local weapon = NanosWorldWeapons.AK47(Vector(), Rotator())
    player:Possess(character)
    character:PickUp(weapon)
end

function Deathmatch:Respawn(player, character)
    if self.m_Ending then
        return
    end
    if character and character:IsValid() then
        local position = self.m_Spawns[math.random(1, #self.m_Spawns)]
        character:SetHealth(100)
        character:SetLocation(position)
        local weapon = NanosWorldWeapons.AK47(Vector(), Rotator())
        character:PickUp(weapon)
    else
        self:Spawn(player)
    end
    return false
end

function Deathmatch:OnPlayerDeath(player, character, instigator, lastDamageTaken, lastBoneDamaged, damageTypeReason, hitFromDirection)
    if table.find(self.m_Players, player) then
        local weapon = character:GetCurrentPickUpObject()
        if weapon and weapon:IsValid() then
            weapon:Destroy()
        end

        player:IncreasePublicData("Deaths")

        if instigator then
            instigator:IncreasePublicData("Kills")
            instigator:IncreasePublicData("Score")
            self:SendKillFeedEntry(instigator:GetName() .. " killed " .. player:GetName())

            if instigator:GetPublicData("Score") >= self:GetScoreLimit() then
                self:EndRound()
            end
        else
            self:SendKillFeedEntry(player:GetName() .. " died")
        end

        if not self.m_Ending then
            Timer:SetTimeout(2000, self.m_Respawn, {player, character})
        end
    end
end
