NanosWeapon = Weapon
Weapon = inherit(Object)
registerElementClass("Weapon", Weapon)

function Weapon:virtual_constructor(name)
	self.m_Name = name
end

function Weapon:virtual_destructor()
end

function Weapon:GetName()
	return self.m_Name
end
