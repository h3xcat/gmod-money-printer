include("shared.lua")
surface.CreateFont( "MoneyPrinterCoolerTitle", {
	font 		= "Arial",
	size 		= 34,
	weight 		= 1000,
	blursize 	= 0,
	scanlines 	= 2,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= true
} )
surface.CreateFont( "MoneyPrinterCoolerFont", {
	font 		= "Arial",
	size 		= 34,
	weight 		= 50,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= true
} )
surface.CreateFont( "MoneyPrinterCooling", {
	font 		= "Arial",
	size 		= 60,
	weight 		= 1000,
	blursize 	= 0,
	scanlines 	= 2,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= false
} )
function ENT:Draw()
	self:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local connected = self.Entity:GetNWBool("connected")
	
	if(connected)then
		Ang:RotateAroundAxis(Ang:Right(), 270)
		Ang:RotateAroundAxis(Ang:Up(), 90)
		cam.Start3D2D(Pos + Ang:Up() * 8 - Ang:Right() * 4 - Ang:Forward() * 15.5, Ang, 0.11)
		draw.DrawText( "Cooling", "MoneyPrinterCooling", 140, 2, Color(80,158,238), 1 )
		cam.End3D2D()
	else
		Ang:RotateAroundAxis(Ang:Up(), 90)
		cam.Start3D2D(Pos + Ang:Up() * 3.1 - Ang:Right() * 7.4 - Ang:Forward() * 10.9, Ang, 0.11)
			
			surface.SetDrawColor( Color(0, 0, 0, 255) )
			surface.DrawRect( 0, 0, 198, 125 )
			draw.DrawText( "Touch any", "MoneyPrinterCoolerFont", 99, 10, Color(255,255,255), 1 )
			draw.DrawText( "Money Printer", "MoneyPrinterCoolerTitle", 99, 45, Color(0,255,0), 1 )
			draw.DrawText( "to connect", "MoneyPrinterCoolerFont", 99, 80, Color(255,255,255), 1 )
		cam.End3D2D()
	end
end