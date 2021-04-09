WeaponTestCommand = inherit(Singleton)

function WeaponTestCommand:constructor()
    self.m_OnCommandSpawn = bind(self.OnCommandSpawn, self)
    self.m_OnCommandDestroy = bind(self.OnCommandDestroy, self)
    self.m_OnCommandList = bind(self.OnCommandList, self)
    self.m_Weapons = {}
    
    CommandManager:GetSingleton():Register("spawn_w", self.m_OnCommandSpawn)
    CommandManager:GetSingleton():Register("destroy_w", self.m_OnCommandDestroy)
    CommandManager:GetSingleton():Register("list_w", self.m_OnCommandList)
end

function WeaponTestCommand:destructor()
    CommandManager:GetSingleton():Unregister("spawn_w", self.m_OnCommandSpawn)
    CommandManager:GetSingleton():Unregister("destroy_w", self.m_OnCommandDestroy)
    CommandManager:GetSingleton():Unregister("list_w", self.m_OnCommandList)
end

function WeaponTestCommand:OnCommandSpawn()
    Package:Log("Spawn weapon")
    local weapon = NanosWorldWeapons.AK47(Vector(), Rotator())
    table.insert(self.m_Weapons, weapon)
end

function WeaponTestCommand:OnCommandDestroy()
    Package:Log("Destroy weapons")
    for k, v in pairs(self.m_Weapons) do
        v:Destroy()
    end
    self.m_Weapons = {}
end

function WeaponTestCommand:OnCommandList()
    Package:Log("List weapons")
    for k, v in pairs(Weapon) do
        Package:Log("Weapon: " .. tostring(v))
    end
end
