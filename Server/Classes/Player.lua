NanosPlayer = Player
Player = inherit(Object)
registerElementClass("Player", Player)

function Player:virtual_constructor()
    self.m_PublicData = {}

    self:SetPublicData("Kills", 0)
    self:SetPublicData("Deaths", 0)
    self:SetPublicData("Score", 0)
	self:SetPublicData("LockedViewMode", nil)

    self.m_LockedViewMode = nil
end

function Player:virtual_destructor()
end

function Player:IncreasePublicData(key)
    self:SetPublicData(key, (self.m_PublicData[key] and self.m_PublicData[key] or 0) + 1)
end

function Player:DecreasePublicData(key)
    self:SetPublicData(key, (self.m_PublicData[key] and self.m_PublicData[key] or 0) - 1)
end

function Player:SetPublicData(key, value)
    self.m_PublicData[key] = value
    Events:BroadcastRemote("Player_UpdatePublicData", {self, key, value})
end

function Player:SendAllPublicDataTo(player)
    for key, value in pairs(self.m_PublicData) do
        Events:CallRemote("Player_UpdatePublicData", player, {self, key, value})
    end
end

function Player:GetPublicData(key)
    return self.m_PublicData[key]
end

function Player:GetLockedViewMode()
    return self.m_LockedViewMode
end

function Player:SetLockedViewMode(viewMode)
    if viewMode == "FPV" or viewMode == "TPV" or viewMode == nil then
		self.m_LockedViewMode = viewMode
		self:SetPublicData("LockedViewMode", self.m_LockedViewMode)
        self:UpdateViewMode()
    else
        error("Invalid view mode provided")
    end
end

function Player:UpdateViewMode()
    local character = self:GetControlledCharacter()
    if character then
        local currentMode = character:GetViewMode()

        if self.m_LockedViewMode == "FPV" then
            if currentMode ~= 0 then
                character:SetViewMode(0)
            end
        elseif self.m_LockedViewMode == "TPV" then
            if currentMode == 0 then
                character:SetViewMode(1)
            end
        end
    end
end
