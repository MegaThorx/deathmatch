NanosCharacter = Character
Character = inherit(Object)
registerElementClass("Character", Character)

function Character:virtual_constructor()
    -- self.m_LastDamager = nil
    self.m_LastPickUpObject = nil
	self.m_CurrentPickUpObject = nil
	self.m_Alive = true
end

function Character:virtual_destructor()
    self:Destroy()
end

--function Character:OnTakeDamage(damage, type, bone, fromDirection, instigator)
    -- self.m_LastDamager = instigator
--end

function Character:OnPlayerDeath(player, character, instigator, lastDamageTaken, lastBoneDamaged, damageTypeReason, hitFromDirection)
	self.m_Alive = false
end

function Character:OnPickUp(object)
    self.m_LastPickUpObject = self.m_CurrentPickUpObject
    self.m_CurrentPickUpObject = object
end

function Character:SetHealth(health)
	self.parent:SetHealth(health)

	self.m_Alive = health > 0
end

function Character:IsAlive()
	return self.m_Alive
end

-- function Character:GetLastDamager()
--     return self.m_LastDamager
--end

function Character:GetLastPickUpObject()
    return self.m_LastPickUpObject
end

function Character:GetCurrentPickUpObject()
    return self.m_CurrentPickUpObject
end
