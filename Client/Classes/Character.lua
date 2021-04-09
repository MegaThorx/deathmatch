NanosCharacter = Character
Character = inherit(Object)
registerElementClass("Character", Character)

function Character:virtual_constructor()
end

function Character:virtual_destructor()
	self:DestroyNametag()
end

function Character:SpawnNametag(name)
	if self.m_NameTag then
		self:DestroyNametag()
	end

	-- self.m_NameTag = TextRender(Vector(), Rotator(), name, Color(1, 1, 1), 1, 0, 24, 0, true)
	self.m_NameTag = TextRender(Vector(), Rotator(), name, Color(1, 1, 1), 1, 0, 24, 1, true)
	self.m_NameTag:AttachTo(self, "", Vector(0, 0, 250), Rotator())
end

function Character:DestroyNametag()
	if self.m_NameTag and self.m_NameTag:IsValid() then
		self.m_NameTag:Destroy()
	end
	self.m_NameTag = nil
end
