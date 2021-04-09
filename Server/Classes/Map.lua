Map = inherit(Object)

function Map:constructor(data)
    self.m_Data = data
end

function Map:destructor()
end

function Map:GetModes()
    return self.m_Data.SupportedModes
end

function Map:GetViewModes()
    return self.m_Data.SupportedCameraModes
end

function Map:GetSpawnLocations(mode)
    return self.m_Data.SpawnLocations[mode]
end
