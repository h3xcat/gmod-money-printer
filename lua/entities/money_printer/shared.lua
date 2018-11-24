ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Printer"
ENT.Author = "H3xCat (STEAM_0:0:20178582)"
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Ranks = {
	["user"]={
		speed = 8,
		quantity = 8
	},
	["respected"]={
		speed = 10,
		quantity = 10
	},
	["vip"]={
		speed = 11,
		quantity = 11
	},
	["superadmin"]={
		speed = 12,
		quantity = 12
	}
}

ENT.LevelPrices = { 
	[1]={
		speed = 120,
		quantity = 120
	},
	[2]={
		speed = 150,
		quantity = 150
	},
	[3]={
		speed = 190,
		quantity = 190
	},
	[4]={
		speed = 240,
		quantity = 240
	},
	[5]={
		speed = 300, 
		quantity = 300
	},
	[6]={
		speed = 370,
		quantity = 370
	},
	[7]={
		speed = 450,
		quantity = 450
	},
	[8]={
		speed = 540,
		quantity = 540
	},
	[9]={
		speed = 640,
		quantity = 640
	},
	[10]={
		speed = 750,
		quantity = 750
	},
	[11]={
		speed = 870,
		quantity = 870
	},
	[12]={
		speed = 1000,
		quantity = 1000
	}
}
ENT.Levels = {

	[0]={
		speed = 5,
		quantity = 6
	},
	[1]={
		speed = 4.85,
		quantity = 8
	},
	[2]={
		speed = 4.7,
		quantity = 10
	},
	[3]={
		speed = 4.55,
		quantity = 12
	},
	[4]={
		speed = 4.4,
		quantity = 14
	},
	[5]={
		speed = 4.25,
		quantity = 16
	},
	[6]={
		speed = 4.1,
		quantity = 18
	},
	[7]={
		speed = 3.95,
		quantity = 20
	},
	[8]={
		speed = 3.8,
		quantity = 22
	},
	[9]={
		speed = 3.65,
		quantity = 24
	},
	[10]={
		speed = 3.5,
		quantity = 26
	},
	[11]={
		speed = 3.35,
		quantity = 28
	},
	[12]={
		speed = 3.2,
		quantity = 30
	}
}
ENT.MaxInk = 100
ENT.MaxNormalSpeed = ENT.Ranks["user"].speed
ENT.MaxNormalQuantity = ENT.Ranks["user"].quantity


function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"price")
	self:NetworkVar("Entity",1,"owning_ent")
end

