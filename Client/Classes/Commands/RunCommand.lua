RunCommand = inherit(Singleton)

function RunCommand:constructor()
    Package:Log("RunCommand:constructor")
    self.m_OnCommand = bind(self.OnCommand, self)
    CommandManager:GetSingleton():Register("dcrun", self.m_OnCommand)
end

function RunCommand:destructor()
    CommandManager:GetSingleton():Unregister("dcrun", self.m_OnCommand)
end

function RunCommand:OnCommand(cmd, ...)
    Package:Log("RunCommand:OnCommand")
    local codeString = table.concat({...})
    Client:SendChatMessage(string.format("Executed command: <italic>%s</>", codeString))
    
    local returned = true
    local commandFunction, errorMessage = load("return " .. codeString)

    if errorMessage then
        returned = false
        commandFunction, errorMessage = load(codeString)
    end

    if errorMessage then
        Client:SendChatMessage(string.format("<red>Error: %s</>", errorMessage))
        return
    end

    local results = {pcall(commandFunction)}

    if not results[1] then
        Client:SendChatMessage(string.format("<red>Error: %s</>", results[2]))
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
            Client:SendChatMessage(string.format("Command results: %s", resultsString))
        else
            Client:SendChatMessage(string.format("Command results: %s", nil))
        end
    else
        Client:SendChatMessage("Command executed!")
    end
end
