local Tool = SWEP

Tool.PrintName = "Clone Wand"
Tool.Category = "THKY's Weaponsq"
Tool.Author = "THKY"

Tool.Instructions = "Right click to copy.\nHold left click to fire."
Tool.Purpose = "Tomfoolery machine."

Tool.Slot = 0
Tool.SlotPos = 128
Tool.BounceWeaponIcon = false
Tool.AdminOnly = false
Tool.Spawnable = true

Tool.ViewModel = Model("models/weapons/c_stunstick.mdl")
Tool.WorldModel = Model("models/weapons/w_stunbaton.mdl")
Tool.ViewModelFOV = 54
Tool.UseHands = true

Tool.BobScale = 1
Tool.SwayScale = 1

Tool.Weight = 0

Tool.DrawAmmo = false
Tool.DrawCrosshair = true
Tool.AccurateCrosshair = true

Tool.Primary =
{
	Ammo = "none",
	ClipSize = 0,
	DefaultClip = 0,
	Automatic = true
}

Tool.Secondary =
{
	Ammo = "none",
	ClipSize = 0,
	DefaultClip = 0,
	Automatic = false
}

function Tool:Initialize()
	self:SetHoldType("magic")
end
