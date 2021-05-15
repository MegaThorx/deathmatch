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

	self.m_PublicData["state"] = BaseMode.States.PreRound

	self.m_PublicData["timeLimit"] = -1
	self.m_PublicData["scoreLimit"] = -1

	self.m_PublicData["countdownTime"] = 15
	self.m_PublicData["countdownTimeElapsed"] = 15

	self.m_TimeElapsed = 0
	self.m_CountdownTimeElapsed = 0

	self.m_CountdownTick = bind(self.CountdownTick, self)
	self.m_CountdownTimer = nil
end

function BaseMode:virtual_destructor()
	self:EndRound()
end

function BaseMode:StartPreRound()
	self:SetState(BaseMode.States.PreRound)
end

function BaseMode:EndPreRound()
end

function BaseMode:StartCountdown()
	if self:GetState() == BaseMode.States.PreRound then
		self:EndPreRound()

		self.m_CountdownTimeElapsed = 0

		if self.m_CountdownTimer then
			Timer:ClearTimeout(self.m_CountdownTimer)
		end
	
		self:SetState(BaseMode.States.Countdown)
	
		self.m_CountdownTimer = Timer:SetTimeout(1000, self.m_CountdownTick, {})	
	end
end

function BaseMode:CountdownTick()
	Package:Log("BaseMode:CountdownTick")
	self.m_CountdownTimeElapsed = self.m_CountdownTimeElapsed + 1

	self:SetPublicData("countdownTimeElapsed", self.m_CountdownTimeElapsed)

	if self.m_CountdownTimeElapsed >= self.m_PublicData["countdownTime"] then
		self:EndCountdown()
		return false
	end
end

function BaseMode:EndCountdown(force)
	Package:Log("BaseMode:EndCountdown")
	if self:IsCountdownRunning() then

		if not force then
			self:StartRound()
		else
			Timer:ClearTimeout(self.m_CountdownTimer)
		end
	end
end

function BaseMode:StartRound()
	Package:Log("BaseMode:StartRound")
	self:SetState(BaseMode.States.Running)
    self.m_TimeStart = os.time()
end

function BaseMode:EndRound()
	if self:GetState() == BaseMode.States.Countdown then
		self:EndCountdown(true)
	end

	self:SetState(BaseMode.States.Ending)
end

function BaseMode:GetName()
    return self.m_Name
end

function BaseMode:GetState()
	return self.m_PublicData["state"]
end

function BaseMode:SetState(state)
	if state ~= BaseMode.States.PreRound and state ~= BaseMode.States.Countdown and state ~= BaseMode.States.Running and state ~= BaseMode.States.Ending then
		return false
	end

	return self:SetPublicData("state", state)
end

function BaseMode:IsRoundRunning()
	return self:GetState() == BaseMode.States.Running
end

function BaseMode:IsCountdownRunning()
	return self:GetState() == BaseMode.States.Countdown
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

function BaseMode:GetScoreLimit()
    return self.m_PublicData["scoreLimit"]
end

function BaseMode:GetTimeLimit()
    return self.m_PublicData["timeLimit"]
end

function BaseMode:GetScoreLimit()
    return self.m_PublicData["scoreLimit"]
end

function BaseMode:SetPublicData(key, value)
	self.m_PublicData[key] = value

	for k, player in ipairs(self.m_Players) do
		if player:IsValid() then
			Events:CallRemote("GameMode_UpdatePublicData", player, {key, value})
		end
	end
	return true
end

function BaseMode:GetPublicData(key)
	return self.m_PublicData[key]
end

function BaseMode:CanStart()
	Package:Log("BaseMode:CanStart")
	return false
end

function BaseMode:AddPlayer(player)
	table.insert(self.m_Players, player)
end

function BaseMode:SendAllPublicDataTo(player)
	for key, value in pairs(self.m_PublicData) do
		Events:CallRemote("GameMode_UpdatePublicData", player, {key, value})
	end
end

function BaseMode:RemovePlayer(player)
    table.removevalue(self.m_Players, player)
end

function BaseMode:Spawn()
    error("Spawning function isn't implemented")
end

function BaseMode:SendKillFeedEntry(text)
    for _, player in pairs(self.m_Players) do
        Events:CallRemote("HUD_AddKillFeedEntry", player, {text})
    end
end
