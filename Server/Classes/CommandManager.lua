CommandManager = inherit(Singleton)

function CommandManager:constructor()
    self.m_Commands = {}

    self.m_OnConsoleCommand = bind(self.OnConsoleCommand, self)
    self.m_OnCommand = bind(self.OnCommand, self)
    Server:Subscribe("Console", self.m_OnConsoleCommand)
    Server:Subscribe("Chat", self.m_OnCommand)
    Package:Log("CommandManager:constructor")
end

function CommandManager:destructor()
end

function CommandManager:OnConsoleCommand(text)
    local args = split(text, " ")
    if args and args[1] then
        local command = args[1]
        table.remove(args, 1)

        for k, v in ipairs(self.m_Commands) do
            if v.command == command then
                v.callback(nil, command, table.unpack(args))
            end
        end
    end
end

function CommandManager:OnCommand(text, player)
	if string.sub(text, 1, 1) == "/" then
		local text = string.sub(text, 2, string.len(text))
		local args = split(text, " ")
		if args and args[1] then
			local command = args[1]
			table.remove(args, 1)

			for k, v in ipairs(self.m_Commands) do
				if v.command == command then
					v.callback(player, command, table.unpack(args))
				end
			end
		end
		return false
	end
end

function CommandManager:Register(command, callback)
    table.insert(self.m_Commands, {
        command = command,
        callback = callback
    })
end

function CommandManager:Unregister(command, callback)
    for k, v in ripairs(self.m_Commands) do
        if v.command == command then
            if not callback or v.callback == callback then
                table.remove(k, v)
            end
        end
    end
end
