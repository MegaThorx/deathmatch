FixFallingCommand = inherit(Singleton)

function FixFallingCommand:constructor()
    self.m_OnCommand = bind(self.OnCommand, self)
    CommandManager:GetSingleton():Register("list", self.m_OnCommand)
end

function FixFallingCommand:destructor()
    CommandManager:GetSingleton():Unregister("list", self.m_OnCommand)
end

function FixFallingCommand:OnCommand()
    for k, v in pairs(NanosPlayer) do
        local character = v:GetControlledCharacter()
        if character and character:IsValid() then
            if character:GetLocation().Z < -100 then
                GamemodeManager:GetSingleton():OnPlayerDeath(character, v)
            end
        end
    end
end
