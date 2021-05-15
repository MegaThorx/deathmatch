RunCommand = inherit(Singleton)

function RunCommand:constructor()
    Package:Log("RunCommand registered?")
    self.m_OnCommand = bind(self.OnCommand, self)
    CommandManager:GetSingleton():Register("drun", self.m_OnCommand)
end

function RunCommand:destructor()
    CommandManager:GetSingleton():Unregister("drun", self.m_OnCommand)
end

function RunCommand:OnCommand(player, cmd, ...)
    local name = player and player:GetName() or "Console"
    if true then -- YOLO
        local codeString = table.concat({...})
        Server:BroadcastChatMessage(string.format("%s executed command: <italic>%s</>", name, codeString))
        
	    local returned = true
        local commandFunction, errorMessage = load("return " .. codeString)

        if errorMessage then
            returned = false
            commandFunction, errorMessage = load(codeString)
        end

        if errorMessage then
            Server:BroadcastChatMessage(string.format("<red>Error: %s</>", errorMessage))
            return
        end

        local results = {pcall(commandFunction)}

        if not results[1] then
            Server:BroadcastChatMessage(string.format("<red>Error: %s</>", results[2]))
            return
        end

        if returned then
            local resultsString = ""
            local first = true
            for i = 2, #results do
                if first then
                    first = false
                else
                    resultsString = resultsString..", "
                end
                if type(results[i]) ~= "table" then
                    resultsString = resultsString .. inspect(results[i])
                else
                    resultsString = resultsString .. tostring(results[i])
                end
            end
            
            if resultsString ~= "" then
                Server:BroadcastChatMessage(string.format("Command results: %s", resultsString))
            else
                Server:BroadcastChatMessage(string.format("Command results: %s", nil))
            end
        else
            Server:BroadcastChatMessage("Command executed!")
        end
    else
        Server:SendChatMessage(player, "Permission denied")
    end
end
