BaseMode = inherit(Object)
BaseMode.Name = "unknown"
BaseMode.States = {
	PreRound = "preRound",
	Countdown = "countdown",
	Running = "running",
	Ending = "ending"
}

function BaseMode:virtual_constructor()
    self.m_Name = BaseMode.Name

    self.m_Players = {}

	self.m_PublicData = {}

	self.m_PublicData["timeLimit"] = -1
	self.m_PublicData["scoreLimit"] = -1
	self.m_PublicData["score"] = 0
	self.m_PublicData["timeElapsed"] = 0
	self.m_PublicData["countdownTime"] = 0
	self.m_PublicData["countdownTimeElapsed"] = 0

    self.m_TimeStart = -1
	self.m_CountdownVisible = false

	self.m_PublicDataChangeHook = Hook:New()
	self.m_HandleCountdown = bind(self.HandleCountdown, self)
	self.m_PublicDataChangeHook:Register(self.m_HandleCountdown)
	
	self.m_OnCharacterPossessed = bind(self.OnCharacterPossessed, self)
    CharacterManager:GetSingleton():GetPossessedHook():Register(self.m_OnCharacterPossessed)

	-- Client:SetInputEnabled(false)
	if Player.LocalPlayer:GetControlledCharacter() then
		Player.LocalPlayer:GetControlledCharacter():SetMovementEnabled(false)
	end

	Events:CallRemote("GameMode_RequestPublicData", {})
end

function BaseMode:virtual_destructor()
    CharacterManager:GetSingleton():GetPossessedHook():Unregister(self.m_OnCharacterPossessed)
end

function BaseMode:GetPublicDataChangeHook()
	return self.self.m_PublicDataChangeHook
end

function BaseMode:OnCharacterPossessed(player, character)
	if Player.LocalPlayer == player then
		if not self:GetState() or self:GetState() == BaseMode.States.PreRound then
			character:SetMovementEnabled(false)
		end
	end
end

function BaseMode:GetName()
    return self.m_Name
end

function BaseMode:GetState()
	-- preRound, countdown, running, ending
	return self.m_PublicData["state"]
end

function BaseMode:HasTimeLimit()
    return self.m_PublicData["timeLimit"] ~= -1
end

function BaseMode:HasScoreLimit()
    return self.m_PublicData["scoreLimit"] ~= -1
end

function BaseMode:GetTimeLimit()
    return self.m_PublicData["timeLimit"]
end

function BaseMode:RoundStart()
    self.m_TimeStart = os.time()
end

function BaseMode:RoundEnd()
    self.m_Ending = true
end

function BaseMode:IsRoundRunning()
	return self:GetState() == BaseMode.States.Running
end

function BaseMode:IsCountdownRunning()
	return self:GetState() == BaseMode.States.Countdown
end

function BaseMode:UpdatePublicData(key, value)
	self.m_PublicData[key] = value
	self.m_PublicDataChangeHook:Call(key, value)
end

function BaseMode:HandleCountdown(key, value)
	if self:IsCountdownRunning() then
		self.m_CountdownVisible = true
		HUD:GetSingleton():TriggerEvent("UpdateCountdown", true, self:GetCountdownRemainingTime())
	elseif self.m_CountdownVisible then
		HUD:GetSingleton():TriggerEvent("UpdateCountdown", false, 0)
		self.m_CountdownVisible = false
		-- Client:SetInputEnabled(true)
		if Player.LocalPlayer:GetControlledCharacter() then
			Player.LocalPlayer:GetControlledCharacter():SetMovementEnabled(true)
		end
	elseif self:IsRoundRunning() then
		-- Client:SetInputEnabled(true)
		if Player.LocalPlayer:GetControlledCharacter() then
			Player.LocalPlayer:GetControlledCharacter():SetMovementEnabled(true)
		end
	end
end

function BaseMode:UpdateUI()
end

function BaseMode:GetCountdownRemainingTime()
    return self.m_PublicData["countdownTime"] - self.m_PublicData["countdownTimeElapsed"]
end

function BaseMode:GetRemainingTime()
    if self.m_TimeStart ~= -1 then
        local remainingTime = self.m_PublicData["timeLimit"] - (os.time() - self.m_TimeStart + self.m_PublicData["timeElapsed"])
        if remainingTime < 0 then remainingTime = 0 end
        return remainingTime
    end

    return -1
end

function BaseMode:GetScoreLimit()
    return self.m_PublicData["scoreLimit"]
end

function BaseMode:GetScore()
    return self.m_PublicData["score"]
end

function BaseMode:AddPlayer(player)
    table.insert(self.m_Players, player)
end

function BaseMode:RemovePlayer(player)
    table.removevalue(self.m_Players, player)
end

function BaseMode:Spawn()
    error("Spawning function isn't implemented")
end

