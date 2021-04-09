WeaponManager = inherit(Singleton)

function WeaponManager:constructor()
end

function WeaponManager:destructor()
    for _, weapon in pairs(NanosWeapon) do
        weapon:Destroy()
    end
end
