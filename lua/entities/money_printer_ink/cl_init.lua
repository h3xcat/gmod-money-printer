include("shared.lua")
surface.CreateFont( "MoneyPrinterInk", {
	font 		= "ChatFont",
	size 		= 10,
	weight 		= 50,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= false,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= false
} )
local ang = Angle(0,0,90)
function ENT:Draw()
    self.Entity:DrawModel()
    local ink = math.Round(self.Entity:GetNWInt("ink"))
    ang.yaw = ang.yaw + 0.1
    if ang.yaw > 360 then ang.yaw = 0 end
     
     
    cam.Start3D2D(self.Entity:GetPos() + Vector(0,0,13),ang , 1)
        draw.SimpleTextOutlined(ink.."%", "MoneyPrinterInk", 0, 0, Color(255,255,255), 1, 1, 1, Color(0,0,0,255))
		
    cam.End3D2D()
     
    cam.Start3D2D(self.Entity:GetPos() + Vector(0,0,13),Angle(0,180 + ang.yaw,90) , 1)
        draw.SimpleTextOutlined(ink.."%", "MoneyPrinterInk", 0, 0, Color(255,255,255), 1, 1, 1, Color(0,0,0,255))
    cam.End3D2D()
end