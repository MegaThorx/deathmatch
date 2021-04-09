PaintingsCommand = inherit(Singleton)

function PaintingsCommand:constructor()
    self.m_OnCommand = bind(self.OnCommand, self)
    CommandManager:GetSingleton():Register("paintings", self.m_OnCommand)
end

function PaintingsCommand:destructor()
    CommandManager:GetSingleton():Unregister("paintings", self.m_OnCommand)
end

function PaintingsCommand:OnCommand()
    Package:Log("==== LISTING PAININGS ====")
    for k, v in pairs(NanosPlayer) do
        if v:GetControlledCharacter() then
            local position = v:GetControlledCharacter():GetLocation()
            NanosPlayer:PickUp(MyProp)
        end
    end
    Package:Log("==== END LISTING PAININGS ====")
end
