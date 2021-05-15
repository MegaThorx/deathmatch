CommandManager = inherit(Singleton)

function CommandManager:constructor()
    self.m_Commands = {}

    self.m_OnCommand = bind(self.OnCommand, self)
    self.m_OnConsole = bind(self.OnConsole, self)

    Client:Subscribe("Chat", self.m_OnCommand)
    Client:Subscribe("Console", self.m_OnConsole)
end

function CommandManager:destructor()
end

function CommandManager:OnCommand(text)
	if string.sub(text, 1, 1) == "/" then
		local text = string.sub(text, 2, string.len(text))
		local args = split(text, " ")
		if args and args[1] then
			local command = args[1]
			table.remove(args, 1)

			for k, v in ipairs(self.m_Commands) do
				if v.command == command then
					v.callback(command, table.unpack(args))
				end
			end
		end
	end
end

function CommandManager:OnConsole(text)
    local args = split(text, " ")
    if args and args[1] then
        local command = args[1]
        table.remove(args, 1)

        for k, v in ipairs(self.m_Commands) do
            if v.command == command then
                v.callback(command, table.unpack(args))
            end
        end
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