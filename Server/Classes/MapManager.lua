MapManager = inherit(Singleton)

function MapManager:constructor()
    self.m_CurrentMap = nil

    Events:Subscribe("Map_Data", bind(self.Event_Loaded, self))
    
    Timer:SetTimeout(250, function() Events:Call("Map_RequestData", {}) return false end, {})
end

function MapManager:destructor()
end

function MapManager:Event_Loaded(data)
    if self.m_CurrentMap then
        delete(self.m_CurrentMap)
        self.m_CurrentMap = nil
    end
    self.m_CurrentMap = Map:New(data)
    
    GamemodeManager:GetSingleton():OnMapLoaded(self.m_CurrentMap)
end

function MapManager:GetCurrentMap()
    return self.m_CurrentMap
end
