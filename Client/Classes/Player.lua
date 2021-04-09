NanosPlayer = Player
Player = inherit(Object)
registerElementClass("Player", Player)

Player.LocalPlayer = nil

function Player:virtual_constructor()
    self.m_PublicData = {}
end

function Player:virtual_destructor()
end

function Player:GetPublicData(key)
    return self.m_PublicData[key]
end

function Player:GetAllPublicData()
    return self.m_PublicData
end

function Player:GetLockedViewMode()
    return self.m_PublicData["LockedViewMode"]
end

function Player:__InternalSetPublicData(key, value)
    self.m_PublicData[key] = value
end
