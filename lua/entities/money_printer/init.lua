AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.SeizeReward = 900

-- DarkRP 2.5 FIX
local function CanAfford(ply, ammount)
	local PLAYER = FindMetaTable("Player")
	if type(PLAYER.CanAfford) == "function" then
		return ply:CanAfford(ammount)
	else
		return ply:canAfford(ammount)
	end
end
local function AddMoney(ply, ammount)
	local PLAYER = FindMetaTable("Player")
	if type(PLAYER.AddMoney) == "function" then
		return ply:AddMoney(ammount)
	else
		return ply:addMoney(ammount)
	end	
end

local function Notify(ply, tp, t, msg)
	if type(DarkRP.notify) == "function" then
		return DarkRP.notify(ply, tp, t, msg)
	else
		return GAMEMODE:Notify(ply, tp, t, msg)
	end	
end


function ENT:Initialize()
	self:SetModel("models/props_c17/consolebox01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self.Entity:SetNWBool("cooling", false)
	self.Money = 0
	self.Ink = 0
	self.Entity:SetNWInt("ink", 0)
	
	self.QLevel = 0
	self.SLevel = 0
	self.damage = 100
	self.IsMoneyPrinter = true
	self.Cooler = nil
	timer.Simple(5, function() self:CreateMoney() end)
end

function ENT:OnTakeDamage(dmg)
	if self.burningup then return end

	self.damage = (self.damage or 100) - dmg:GetDamage()
	if self.damage <= 0 then
		local rnd = math.random(1, 10)
		if rnd < 3 then
			self:BurstIntoFlames()
		else
			self:Destruct()
			self:Remove()
		end
	end
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
	Notify(self:Getowning_ent(), 1, 4, "Your money printer has exploded!")
	
end

function ENT:BurstIntoFlames()
	Notify(ply, 0, 4, "Your money printer is overheating!")
	self.burningup = true
	local burntime = math.random(8, 18)
	self:Ignite(burntime, 0)
	timer.Simple(burntime, function() self:Fireball() end)
end

function ENT:Fireball()
	if not self:IsOnFire() then self.burningup = false return end
	local dist = math.random(20, 280) -- Explosion radius
	self:Destruct()
	for k, v in pairs(ents.FindInSphere(self:GetPos(), dist)) do
		if not v:IsPlayer() and not v:IsWeapon() and v:GetClass() ~= "predicted_viewmodel" and not v.IsMoneyPrinter then
			v:Ignite(math.random(5, 22), 0)
		elseif v:IsPlayer() then
			local distance = v:GetPos():Distance(self:GetPos())
			v:TakeDamage(distance / dist * 100, self, self)
		end
	end
	self:Remove()
end
function ENT:TakeMoney(ply)	
	AddMoney(ply, self.Money)
	self.Money = 0
	self.Entity:SetNWInt("money", self.Money)
end
function ENT:QUpgrade(ply)	
	local cost = self.LevelPrices[self.QLevel+1].quantity
	if CanAfford(ply,cost) then
		local upgradeQuantityLimit = self.MaxNormalQuantity
		for k,v in pairs(self.Ranks) do
			if (ULib and ply:CheckGroup(k) or ply:IsUserGroup(k)) and v and v.quantity > upgradeQuantityLimit then
				upgradeQuantityLimit=v.quantity
			end
		end
		if (self.QLevel<12 and self.QLevel<upgradeQuantityLimit) then
			self.QLevel = self.QLevel + 1
			AddMoney(ply, -cost)
		end
		self.Entity:SetNWInt("QLevel", self.QLevel)
	else
		Notify(ply, 1, 4, DarkRP.getPhrase("cant_afford", ""))
	end
end
function ENT:SUpgrade(ply)	
	local cost = self.LevelPrices[self.SLevel+1].speed
	if CanAfford(ply,cost) then
		local upgradeSpeedLimit = self.MaxNormalSpeed
		for k,v in pairs(self.Ranks) do
			if (ULib and ply:CheckGroup(k) or ply:IsUserGroup(k)) and v and v.speed > upgradeSpeedLimit then
				upgradeSpeedLimit=v.speed
			end
		end
		if (self.SLevel<12 and self.SLevel<upgradeSpeedLimit) then
			self.SLevel = self.SLevel + 1
			AddMoney(ply, -cost)
		end
		self.Entity:SetNWInt("SLevel", self.SLevel)
	else
		Notify(ply, 1, 4, DarkRP.getPhrase("cant_afford", ""))
	end
end


function ENT:CreateMoney()
	
	if not IsValid(self) or self:IsOnFire() or self.Ink < 2 then 
		timer.Simple(3, function() 
			if (IsValid(self)) then 
				self:CreateMoney()
			end 
		end)
		return
	end
	self.Ink = self.Ink - 2
	self.Entity:SetNWInt("ink", math.ceil(self.Ink))

	if math.random(1, (625+self.QLevel*20+self.SLevel*20)*(self.Cooler and 2 or 1)) == 29 then 
		self:BurstIntoFlames() 
	end

	local amount = self.Levels[self.QLevel].quantity

	self.Money = self.Money + amount
	self.Entity:SetNWInt("money", self.Money)
	timer.Simple(self.Levels[self.SLevel].speed, function() self:CreateMoney() end)
end

function ENT:Think()

	if self:WaterLevel() > 0 then
		if(CurTime()-self.surfTime >=20)then
		  self:Destruct()
		  self:Remove()
		end
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetMagnitude(2)
		effectdata:SetScale(1)
		effectdata:SetRadius(2)
		util.Effect("Sparks", effectdata)
		if(self.Cooler)then
			self.Cooler.IsConnected = false
			self.Cooler.Entity:SetNWBool("connected", false)
			self.Cooler:SetParent(nil)
			self.Cooler:SetPos(self:GetPos())
			self.Cooler:PhysWake()
			self.Cooler=nil
			self.Entity:SetNWBool("cooling", false)
		end
	else
		self.surfTime = CurTime()
	end
	


	
end

concommand.Add( "moneyprinter_qupgrade",function( ply,cmd,args,str )
    local ent = Entity(tonumber(args[1]))
	if(ent:GetPos():Distance( ply:GetPos() ) < 160) then
		ent:QUpgrade(ply)
	end
end )
concommand.Add( "moneyprinter_supgrade",function( ply,cmd,args,str )
    local ent = Entity(tonumber(args[1]))
	if(ent:GetPos():Distance( ply:GetPos() ) < 160) then
		ent:SUpgrade(ply)
	end
end )
concommand.Add( "moneyprinter_take",function( ply,cmd,args,str )
	local ent = Entity(tonumber(args[1]))
	
	if(ent:GetPos():Distance( ply:GetPos() ) < 160) then
		ent:TakeMoney(ply)
	end
end )

function ENT:Touch( hitEnt )
	if hitEnt.IsCooler and not self.Cooler and not hitEnt.IsConnected and not (self:WaterLevel() > 0) then
		self.Entity:SetNWBool("cooling", true)
		hitEnt.IsConnected = true
		hitEnt.Entity:SetNWBool("connected", true)
		
		self.Cooler = hitEnt
		self.OldAngles = self.Entity:GetAngles()
		self.Entity:SetAngles(Angle(0, 0, 0))

		hitEnt:SetPos(self.Entity:GetPos() + Vector(11, -3.3, 3.5))
		hitEnt:SetAngles(self.Entity:GetAngles() + Angle(0, 0, 0))
		hitEnt:SetParent( self.Entity )
		self.Entity:SetAngles(self.OldAngles)
	elseif hitEnt.IsInk then
		local need = self.MaxInk - self.Ink
		local take = math.min(need,hitEnt.Ink)
		self.Ink = self.Ink+take
		hitEnt.Ink = hitEnt.Ink-take
		if (hitEnt.Ink == 0) then
			hitEnt:Remove()
		end
		self.Entity:SetNWInt("ink", math.ceil(self.Ink))
		hitEnt.Entity:SetNWInt("ink", math.ceil(hitEnt.Ink))
	end
end 