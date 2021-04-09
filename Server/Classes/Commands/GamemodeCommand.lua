GamemodeCommand = inherit(Singleton)

function GamemodeCommand:constructor()
    self.m_OnCommand = bind(self.OnCommand, self)
    CommandManager:GetSingleton():Register("startround", self.m_OnCommand)
    CommandManager:GetSingleton():Register("endround", self.m_OnCommand)
end

function GamemodeCommand:destructor()
    CommandManager:GetSingleton():Unregister("startround", self.m_OnCommand)
    CommandManager:GetSingleton():Unregister("endround", self.m_OnCommand)
end

function GamemodeCommand:OnCommand(player, command)
	Package:Log(tostring(player) .. "used " .. tostring(command))
	if command == "startround" then
		GamemodeManager:GetSingleton():StartGame()
	elseif command == "endround" then
		GamemodeManager:GetSingleton():EndGame()
	end
end
