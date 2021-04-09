Hook = inherit(Object)

function Hook:constructor()
    self.m_Functions = {}
end

function Hook:Register(hookFunc)
    self.m_Functions[#self.m_Functions + 1] = hookFunc
end

function Hook:Unregister(hookFunc)
	for k, registeredFunc in pairs(self.m_Functions) do
		if hookFunc == registeredFunc then
			table.remove(self.m_Functions, k)
			return true
		end
	end
end

function Hook:Call(...)
    for k, hookFunc in pairs(self.m_Functions) do
        if hookFunc(...) then
            return true
        end
    end
end
