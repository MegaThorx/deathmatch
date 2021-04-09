ListPlayersCommand = inherit(Singleton)

function ListPlayersCommand:constructor()
    self.m_OnCommand = bind(self.OnCommand, self)
    CommandManager:GetSingleton():Register("list", self.m_OnCommand)
end

function ListPlayersCommand:destructor()
    CommandManager:GetSingleton():Unregister("list", self.m_OnCommand)
end

function ListPlayersCommand:OnCommand()
    Package:Log("==== LISTING PLAYERS ====")
    for k, v in pairs(NanosPlayer) do
        Package:Log(tostring(k) .. " " .. tostring(v) .. " " .. tostring(v:GetName()))
    end
    Package:Log("==== END LISTING PLAYERS ====")
    Package:Log("==== LISTING ROUND PLAYERS ====")
    for k, v in pairs(GamemodeManager:GetSingleton().m_CurrentMode.m_Players) do
        Package:Log(tostring(k) .. " " .. tostring(v) .. " " .. tostring(v:GetName()))
    end
    Package:Log("==== END LISTING ROUND PLAYERS ====")
end
