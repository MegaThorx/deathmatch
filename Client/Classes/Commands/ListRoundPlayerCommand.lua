ListRoundPlayerCommand = inherit(Singleton)

function ListRoundPlayerCommand:constructor()
    self.m_OnCommand = bind(self.OnCommand)
    CommandManager:GetSingleton():Register("list", self.m_OnCommand)
end

function ListRoundPlayerCommand:destructor()
    CommandManager:GetSingleton():Unregister("list", self.m_OnCommand)
end

function ListRoundPlayerCommand:OnCommand()
    Package:Log("==== LISTING ROUND PLAYERS ====")
    for k, v in pairs(GamemodeManager:GetSingleton().m_CurrentMode.m_Players) do
        Package:Log(tostring(k) .. " " .. tostring(v) .. " " .. tostring(v:GetName()))
    end
    Package:Log("==== END LISTING ROUND PLAYERS ====")
end
