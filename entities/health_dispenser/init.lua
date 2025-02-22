AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()

    if (IsValid(phys)) then
        phys:Wake()
    end

    self:SetHealth(self.BaseHealth)
end

function ENT:SpawnFunction(ply, tr, ClassName)
    if (!tr.Hit) then return end
    
    local entCount = ply:GetNWInt(ClassName .. "count")
    if (entCount < self.Limit) then

        local SpawnPos = ply:GetShootPos() + ply:GetForward() * 80

        self.Owner = ply

        local ent = ents.Create(ClassName)
        ent:SetPos(SpawnPos)
        ent:Spawn()
        ent:Activate()

        ply:SetNWInt(ClassName .. "count", entCount + 1)

        return ent
    end
    return
end

function ENT:Use(activator, caller)
    local ammoType = activator:GetActiveWeapon():GetPrimaryAmmoType()

    if (activator:Health() < 100) then
        activator:Health() = activator:Health() + 5
    else
        if (activator:Health() == 99) then
            activator:Health() = activator:Health() + 1
        end 
    end
end

function ENT:Think()

end

function ENT:OnTakeDamage(damage)
    self:SetHealth(self:Health() - damage:GetDamage())

    if (self:Health() <= 0) then
        self:Remove
    end
end

function ENT:OnRemove()
    local Owner = self.Owner
    local ClassName = self:GetClass()
    local entCount = Owner:GetNWInt(ClassName .. "count")
    
    if (Owner:IsValid()) then
        if (Owner:GetNWInt(ClassName.."count") > 0) then
            Owner:SetNWInt(ClassName .. "count", entCount - 1)
        end
    end
end