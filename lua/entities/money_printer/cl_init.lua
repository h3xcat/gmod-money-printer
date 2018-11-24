include("shared.lua")
surface.CreateFont( "MoneyPrinterTitle", {
	font 		= "Arial",
	size 		= 40,
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
surface.CreateFont( "MoneyPrinterUpgrade", {
	font 		= "Arial",
	size 		= 30,
	weight 		= 50,
	blursize 	= 0,
	scanlines 	= 1,
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
surface.CreateFont( "MoneyPrinterNumber", {
	font 		= "Arial",
	size 		= 25,
	weight 		= 50,
	blursize 	= 0,
	scanlines 	= 1,
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
surface.CreateFont( "MoneyPrinterButton", {
	font 		= "Arial",
	size 		= 30,
	weight 		= 50,
	blursize 	= 0,
	scanlines 	= 1,
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
surface.CreateFont( "MoneyPrinterBottom", {
	font 		= "Arial",
	size 		= 40,
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
surface.CreateFont( "MoneyPrinterFrame", {
	font 		= "DermaDefault",
	size 		= 12,
	weight 		= 500,
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
	outline 	= false
} )
local KeyPos = {
	{-10.844,2.954, -6.435, 15.044},	--QUpgrade
	{-3.454, 2.954, 0.946, 15.044},	--SUpgrade
	{4.568,7.918, 8.953,15.044}		--Take
}
local function Wrap(str, width)
	if surface.GetTextSize( str ) > width then
		local t = ""
		for i=1, string.len(str) do
			if(surface.GetTextSize( t .. string.sub(str,i,i) .. "..." ) > width)then
				return t .. "..."
			end
			t =  t .. string.sub(str,i,i)
		end
	else
		return str
	end
end
function ENT:Draw()
	self.Entity:DrawModel()
	local distance = self.Entity:GetPos():Distance( LocalPlayer():GetPos() )
	if(distance>300)then return end
	local Pos = self.Entity:GetPos()
	local Ang = self.Entity:GetAngles()
	local money = self.Entity:GetNWInt("money")
	local QLevel = self.Entity:GetNWInt("QLevel")
	local SLevel = self.Entity:GetNWInt("SLevel")
	local Cooling = self.Entity:GetNWBool("cooling")
	local Ink = self.Entity:GetNWInt("ink")
	local owner = self:Getowning_ent()
	local upgradeSpeedLimit = self.MaxNormalSpeed
	local upgradeQuantityLimit = self.MaxNormalQuantity
	for k,v in pairs(self.Ranks) do
		if (ULib and LocalPlayer():CheckGroup(k) or LocalPlayer():IsUserGroup(k)) and v and v.speed > upgradeSpeedLimit then
			upgradeSpeedLimit=v.speed
		end
		if (ULib and LocalPlayer():CheckGroup(k) or LocalPlayer():IsUserGroup(k)) and v and v.quantity > upgradeQuantityLimit then
			upgradeQuantityLimit=v.quantity
		end
	end
	owner = (IsValid(owner) and owner:Nick()) or "unknown"

	Ang:RotateAroundAxis(Ang:Up(), 90)
	
	cam.Start3D2D(Pos + Ang:Up() * 10.6 - Ang:Right() * 16.35 - Ang:Forward() * 15.20, Ang, 0.11)
		local DrawButtons = distance < 150
		local tr =  LocalPlayer():GetEyeTrace()
		local pos = self.Entity:WorldToLocal(tr.HitPos)
		
		local enabled = {
			QLevel<12 and QLevel<upgradeQuantityLimit,
			SLevel<12 and SLevel<upgradeSpeedLimit,
			money>0
		}
		--print(pos)
		local key=0
		if (pos.z>10 and pos.z<12 and DrawButtons) then
			for i=1, #KeyPos do
				if	enabled[i] and
					pos.x>KeyPos[i][1] and pos.x<KeyPos[i][3] and
					pos.y>KeyPos[i][2] and pos.y<KeyPos[i][4] then 
						key=i
						break
				end
			end
		end
		
		if (LocalPlayer():KeyDown(IN_USE) and not self.lastKey) then
			if (key == 1) then
				local frame = vgui.Create("DFrame")
				frame:SetSize(270,80)
				frame:ShowCloseButton(false)
				frame:SetDeleteOnClose(true)
				frame:SetBackgroundBlur(true)
				frame:SetDraggable(false)
				frame:SetTitle("Upgrade Confirmation")
				frame:MakePopup()
				frame:Center()
				local Info = vgui.Create("DLabel",frame)
				Info:SetText("Would you like to upgrade the Quantity of production of\nthis Money Printer to level "..(QLevel+1).."?\nCosts: $"..(self.LevelPrices[QLevel+1].quantity)..".")
				Info:SetPos(50,25)
				Info:SetFont("MoneyPrinterFrame")
				Info:SizeToContents()
				Info:SetPos(5, 25)
				Info:SetColor(Color(255,255,255,255))
				local Continue = vgui.Create( "DButton", frame )
				Continue:SetSize( 39, 23 )
				Continue:SetPos( 175, 52 )
				Continue:SetText( "Okay" )
				Continue.DoClick = function( button )
					if self and IsValid(self.Entity) then 
						RunConsoleCommand("moneyprinter_qupgrade",self.Entity:EntIndex())
					end
					frame:Close()
				end
				local Cancel = vgui.Create( "DButton", frame )
				Cancel:SetSize( 46, 23 )
				 
				Cancel:SetPos( 219, 52 )
				Cancel:SetText( "Cancel" )
				Cancel.DoClick = function( button )
					frame:Close()
				end
			elseif (key == 2) then
				local frame = vgui.Create("DFrame")
				frame:SetSize(270,80)
				frame:ShowCloseButton(false)
				frame:SetDeleteOnClose(true)
				frame:SetBackgroundBlur(true)
				frame:SetDraggable(false)
				frame:SetTitle("Upgrade Confirmation")
				frame:MakePopup()
				frame:Center()
				local Info = vgui.Create("DLabel",frame)
				Info:SetText("Would you like to upgrade the Speed of production of\nthis Money Printer to level "..(SLevel+1).."?\nCosts: $"..(self.LevelPrices[SLevel+1].speed)..".")
				Info:SetPos(50,25)
				Info:SetFont("MoneyPrinterFrame")
				Info:SizeToContents()
				Info:SetPos(5, 25)
				Info:SetColor(Color(255,255,255,255))
				local Continue = vgui.Create( "DButton", frame )
				Continue:SetSize( 39, 23 )
				Continue:SetPos( 175, 52 )
				Continue:SetText( "Okay" )
				Continue.DoClick = function( button )
					if self and IsValid(self.Entity) then 
						RunConsoleCommand("moneyprinter_supgrade",self.Entity:EntIndex())
					end
					
					frame:Close()
				end
				local Cancel = vgui.Create( "DButton", frame )
				Cancel:SetSize( 46, 23 )
				 
				Cancel:SetPos( 219, 52 )
				Cancel:SetText( "Cancel" )
				Cancel.DoClick = function( button )
					frame:Close()
				end
				
			elseif (key == 3) then
				RunConsoleCommand("moneyprinter_take",self.Entity:EntIndex())
			end
			
		end
		self.lastKey = LocalPlayer():KeyDown(IN_USE)
		surface.SetDrawColor( Color(0, 0, 0, 255) )
		surface.DrawRect( 0, 0, 280, 280 )
		surface.SetDrawColor( Color(33, 33, 33, 255) )
		surface.DrawRect( 5, 5, 270, 40 )
		surface.DrawRect( 5, 50, 270, 135 )
		surface.DrawRect( 5, 190, 115, 40 )--surface.DrawRect( 5, 190, 270, 40 )
		surface.DrawRect( 125, 190, 150, 40 )
		surface.DrawRect( 5, 235, 270, 40 )
		draw.DrawText( "Money Printer", "MoneyPrinterTitle", 140, 2, Cooling and Color(50,128,198) or Color(0,255,0), 1 )
		
		draw.DrawText( "Quantity:", "MoneyPrinterUpgrade", 8, 50, Color(255,255,255), 0 )
		if(DrawButtons)then
			surface.SetDrawColor( Color(50, 50, 50, 255) )
			surface.DrawRect( 165, 50, 110, 40 )
			surface.SetDrawColor( key==1 and Color(40, 40, 40, 255) or Color(0, 0, 0, 255) )
			surface.DrawRect( 167, 52, 106, 36 )
			draw.DrawText( "Upgrade", "MoneyPrinterButton", 167+53, 54, enabled[1] and Color(220,255,220) or Color(50,50,50), 1 )
		end
		draw.DrawText( "Speed:", "MoneyPrinterUpgrade", 8, 117.5, Color(255,255,255), 0 )
		
		if(DrawButtons)then
			surface.SetDrawColor( Color(50, 50, 50, 255) )
			surface.DrawRect( 165, 117.5, 110, 40 )
			surface.SetDrawColor( key==2 and Color(40, 40, 40, 255) or Color(0, 0, 0, 255) )
			surface.DrawRect( 167, 119.5, 106, 36 )
			draw.DrawText( "Upgrade", "MoneyPrinterButton", 167+53, 121.5, enabled[2] and Color(220,255,220) or Color(50,50,50), 1 )
		end
		surface.SetDrawColor( Color(255, 255, 255, 255) )
		surface.SetMaterial( Material("icon16/star.png") )
		for i=1, 12 do
			if(i>self.MaxNormalQuantity)then
				surface.SetDrawColor( Color(0, 0, 255, 255) )
			end
			if(i>QLevel)then
				surface.SetDrawColor( Color(0, 0, 0, 255) )
			end
			surface.DrawTexturedRect( -13+i*22, 94, 21, 21 )
		end
		surface.SetDrawColor( Color(255, 255, 255, 255) )
		for i=1, 12 do
			if(i>self.MaxNormalSpeed)then
				surface.SetDrawColor( Color(0, 0, 255, 255) )
			end
			if(i>SLevel)then
				surface.SetDrawColor( Color(0, 0, 0, 255) )
			end
			
			surface.DrawTexturedRect( -13+i*22, 161.5, 21, 21 )
		end
		
		
		
		--draw.DrawText( "$"..money, "MoneyPrinterBottom", 8, 190, Color(255,255,255), 0 )
		draw.DrawText( "Ink: "..Ink, "MoneyPrinterNumber", 14, 197, Color(255,255,255), 0 )
		draw.DrawText( "$"..money, "MoneyPrinterNumber", 130, 197, Color(255,255,255), 0 )
		if(DrawButtons)then
			surface.SetDrawColor( Color(50, 50, 50, 255) )
			surface.DrawRect( 210, 190, 65, 40 )
			surface.SetDrawColor( key==3 and Color(40, 40, 40, 255) or Color(0, 0, 0, 255) )
			surface.DrawRect( 212, 192, 61, 36 )
			draw.DrawText( "Take", "MoneyPrinterButton", 212+30.5, 194, enabled[3] and Color(220,255,220) or Color(50,50,50), 1 )
		end
		surface.SetFont("MoneyPrinterBottom")
		draw.DrawText( Wrap(owner,265), "MoneyPrinterBottom", 8, 234, Color(50,200,20), 0 )
	cam.End3D2D()

end

function ENT:Think()
end
