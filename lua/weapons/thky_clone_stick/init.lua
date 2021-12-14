local Tool = SWEP
local Extra = util
local History = undo
local Duplicator = duplicator

local Timer = 0
local Target = Target or {}

include("shared.lua")

local Ray = include("include/ray.lua")
local Sounds = include("include/sounds.lua")

function Tool:PrimaryAttack()
	local Owner = self:GetOwner()
	
	Timer = Timer + 1
	
	if Timer > 5 then
		if Target[Owner] then
			local Location = Owner:GetShootPos() + (Owner:GetAimVector() * 75)
			local Velocity = Owner:GetAimVector() * 2000
			local Angle = Owner:EyeAngles()
			
			if Extra.IsInWorld(Location) then
				local Entity = Duplicator.CreateEntityFromTable(Owner,Target[Owner])
				local Physics = Entity:GetPhysicsObject()
				
				if Physics:IsValid() then
					Physics:EnableMotion(true)
					
					Physics:SetPos(Location)
					Physics:SetVelocity(Velocity)
					Physics:SetAngles(Angle)
					Physics:Wake()
				end
				
				History.Create("prop")
				History.AddEntity(Entity)
				History.SetPlayer(Owner)
				History.Finish("Clone Wand " .. tostring(Entity))

				Owner:AddCleanup("props", Entity)
				
				Owner:EmitSound(Sounds.Fire)
			else
				Owner:EmitSound(Sounds.Fail)
			end
		end
		
		Timer = 0
	end
end

function Tool:SecondaryAttack()
	local Owner = self:GetOwner()
	local Result = Ray(Owner:GetShootPos(),Owner:GetAimVector() * (256^3))
	
	if Result.Entity then
		if Duplicator.IsAllowed(Result.Entity:GetClass()) then
			Target[Owner] = Duplicator.CopyEntTable(Result.Entity)
			Owner:EmitSound(Sounds.Select)
			
			if Result.Entity:GetPhysicsObject():IsValid() then
				Owner:PrintMessage(HUD_PRINTCENTER,string.format("Selected %s",tostring(Result.Entity)))
			else
				Owner:PrintMessage(HUD_PRINTCENTER,string.format("%s does not have a physics object.\nThis entity can still be cloned.",tostring(Result.Entity)))
			end
		else
			Owner:PrintMessage(HUD_PRINTCENTER,string.format("Cloning is locked for %s",tostring(Result.Entity)))
		end
	end
end

function Tool:Reload()
	local Owner = self:GetOwner()
	
	if Target then
		Target[Owner] = nil
		Owner:EmitSound(Sounds.Clear)
		Owner:PrintMessage(HUD_PRINTCENTER,"Cleared selection.")
	end
end

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
