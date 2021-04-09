GamemodeManager = inherit(Singleton)

--[[
    StartGame -> starts the gamemode in "preRound"
    -> StartRound gets triggered when CanStart returns true
    StartRound -> starts the "countdown"
    EndRound -> ends the round and goes to "ending"
    StopGame -> ends the gamemode fully

    StartGame       -> constructor
    StartPreRound   -> Set state to preRound
    StartCountdown  -> Set state to countdown
    StartRound      -> Set state to running
    EndRound        -> Set state to ending
    StopGame        -> destructor
]]

function GamemodeManager:constructor()
    self.m_SupportedModes = {
        [Deathmatch.Name] = Deathmatch,
		[TeamDeathmatch.Name] = TeamDeathmatch,
		[SnowballFight.Name] = SnowballFight
    }

    self.m_Players = {}
    PlayerManager:GetSingleton():GetQuitHook():Register(bind(self.OnPlayerQuit, self))
    PlayerManager:GetSingleton():GetDeathHook():Register(bind(self.OnPlayerDeath, self))
	Events:Subscribe("GameMode_RequestPublicData", bind(self.RequestPublicData, self))

    self.m_CurrentModeName = Deathmatch.Name
    self.m_CurrentMode = nil
    self.m_IsMapLoaded = false
end

function GamemodeManager:destructor()
end

function GamemodeManager:StartGame()
    Package:Log("GamemodeManager:StartGame")
    if not self.m_IsMapLoaded then
        error("Can't start a game when the map isn't loaded yet.")
    end

    if self.m_CurrentMode then
        return false
	end

	for _, entity in pairs(NanosCharacter) do if entity:IsValid() then entity:Destroy() end end
	for _, entity in pairs(NanosWeapon) do if entity:IsValid() then entity:Destroy() end end
	for _, entity in pairs(Grenade) do if entity:IsValid() then entity:Destroy() end end

    self.m_CurrentMode = self.m_SupportedModes[self.m_CurrentModeName]:New()
    self.m_CurrentMode:StartPreRound()

    for _, player in ipairs(self.m_Players) do
        self:AddPlayerToGamemode(player)
    end
end

function GamemodeManager:EndGame()
	if not self.m_CurrentMode then return end
    for k, player in pairs(self.m_CurrentMode.m_Players) do
        Events:CallRemote("GameMode_EndGame", player, {})
    end
    delete(self.m_CurrentMode)
    self.m_CurrentMode = nil
end

function GamemodeManager:NextGame()
    self:EndGame()
    self:StartGame()
end

function GamemodeManager:OnPlayerQuit(player)
    table.removevalue(self.m_Players, player)

    if self.m_CurrentMode then
		self.m_CurrentMode:RemovePlayer(player)

		if #self.m_Players == 0 then
			self:EndGame()
		end
    end
end

function GamemodeManager:RequestPublicData(player)
    if self.m_CurrentMode then
        self.m_CurrentMode:SendAllPublicDataTo(player)
    end
end

function GamemodeManager:OnPlayerDeath(player, character, instigator, lastDamageTaken, lastBoneDamaged, damageTypeReason, hitFromDirection)
    if self.m_CurrentMode then
        self.m_CurrentMode:OnPlayerDeath(player, character, instigator, lastDamageTaken, lastBoneDamaged, damageTypeReason, hitFromDirection)
    end
end

function GamemodeManager:OnMapLoaded(map)
    Package:Log("GamemodeManager:OnMapLoaded")
    local modes = map:GetModes()

    local found = false

    for _, mode in ipairs(modes) do
        if mode == self.m_CurrentModeName then
            found = true
        end
    end

	if not found then
		found = false

		for supportedMode, _ in pairs(self.m_SupportedModes) do
			for _, mode in ipairs(modes) do
				if mode == supportedMode then
					found = true
					self.m_CurrentModeName = mode
					Package:Log("GamemodeManager:OnMapLoaded - Changing gamemode to " .. tostring(mode))
					break
				end
			end

			if found then
				break
			end
		end

		if not found then
			error("Current map doesn't support the current mode " .. self.m_CurrentModeName)
		end
    end

    self.m_IsMapLoaded = true

    self:StartGame() -- Start a game if map has loaded
end

function GamemodeManager:AddPlayer(player)
    Package:Log("GamemodeManager:AddPlayer " .. tostring(player))
    table.insert(self.m_Players, player)

    self:AddPlayerToGamemode(player)
end

function GamemodeManager:AddPlayerToGamemode(player)
    if self.m_CurrentMode then
        Package:Log("GamemodeManager:AddPlayer to CurrentMode " .. tostring(player))
        Events:CallRemote("GameMode_StartGame", player, {self.m_CurrentMode:GetName()})
        Events:CallRemote("GameMode_AddPlayer", player, {player})
        for k, tPlayer in pairs(self.m_CurrentMode.m_Players) do
            Events:CallRemote("GameMode_AddPlayer", tPlayer, {player})
            Events:CallRemote("GameMode_AddPlayer", player, {tPlayer})
        end
		self.m_CurrentMode:AddPlayer(player)

        Package:Log("GamemodeManager:AddPlayerToGamemode - " .. tostring(self.m_CurrentMode:GetState()))

        if self.m_CurrentMode:GetState() == BaseMode.States.PreRound then
            Package:Log("GamemodeManager:AddPlayerToGamemode - check can start")
            if self.m_CurrentMode:CanStart() then
                Package:Log("GamemodeManager:AddPlayerToGamemode - start countdown")
                self.m_CurrentMode:StartCountdown()
            end
        end
	end
end
