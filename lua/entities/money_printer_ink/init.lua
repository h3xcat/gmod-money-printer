AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()	
	self:SetModel("models/props_junk/metal_paintcan001b.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	
	self:SetMaterial("phoenix_storms/metalset_1-2")
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self.IsInk = true
	self.Ink = self.InkAmount
	self.Entity:SetNWInt("ink", self.InkAmount)
end
