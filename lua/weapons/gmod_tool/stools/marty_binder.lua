TOOL.Category = "Marty's Tools"
TOOL.Name = "Binder"

TOOL.Information = {
    { name = "left" }
}

local boundNpcs = boundNpcs or {}

function TOOL:LeftClick(trace)
    if (IsValid(trace.Entity) && !trace.Entity:IsNPC()) then return false end
    if (CLIENT) then return true end

    print("start bind")

    local entity = trace.Entity
    local model = entity:GetModel()

    local ragdoll = ents.Create("prop_ragdoll")
    ragdoll:SetModel(model)
    ragdoll:SetPos(entity:GetPos())
    print("create ragdoll")

    local originalColor = entity:GetColor()
    local originalMode = entity:GetRenderMode()
    entity:SetColor(Color(255, 255, 255, 0))
    entity:SetRenderMode(RENDERMODE_TRANSCOLOR)

    entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

    boundNpcs[entity] = ragdoll

    ragdoll:Spawn()

    local clean = {}

    print("Bone count", entity:GetBoneCount() - 1)

    for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
        local bone = ragdoll:GetPhysicsObjectNum( i )

        if ( IsValid(bone) ) then

            local boneId = ragdoll:TranslatePhysBoneToBone( i )
            local pos, ang = entity:GetBonePosition( boneId )
            if ( pos ) then bone:SetPos( pos ) end
            if ( ang ) then bone:SetAngles( ang ) end

            local con, rope = constraint.Elastic(
                entity,
                ragdoll,
                boneId,
                boneId,
                pos - entity:GetPos(),
                pos - entity:GetPos(),
                500,
                15,
                1,
                "cable/cable",
                0.5,
                1,
                Color(255, 255, 255, 255)
            )

            if con then
                table.insert(clean, rope)
                table.insert(clean, con)
            end
        end
    end


    print("successful constraints: ", #clean)

    undo.Create("prop")
        undo.AddEntity(fake)
        undo.AddEntity(ragdoll)
        for _, v in pairs(clean) do
            undo.AddEntity(v)
        end
        undo.SetPlayer(self:GetOwner())
        undo.AddFunction(function()
            if (!IsValid(entity)) then return end
            boundNpcs[entity] = nil
            entity:SetColor(originalColor)
            entity:SetRenderMode(originalMode)
            for _, v in pairs(clean) do
                v:Remove()
            end
        end)
    undo.Finish("Bound entity")
end

function TOOL.BuildCPanel(CPanel)
    CPanel:AddControl("Header", { description = "Bind entities" })
    CPanel:AddControl("Label", { text = "There are no controls currently" })
end

hook.Add("Think", "MartyToolsBoundRagdolls", function()
    for npc, ragdoll in pairs(boundNpcs) do
        for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
            local bone = ragdoll:GetPhysicsObjectNum( i )
            if ( IsValid(bone) ) then
                bone:Wake()

                local boneId = ragdoll:TranslatePhysBoneToBone( i )
                local pos, ang = npc:GetBonePosition( boneId )
                bone:SetVelocity( npc:GetVelocity() )
                if ( pos ) then bone:SetPos( pos ) end
                if ( ang ) then bone:SetAngles( ang ) end
            end
        end
    end
end)

hook.Add("OnNPCKilled", "MartyToolsBoundNpc", function(npc)
    if (boundNpcs[npc]) then
        boundNpcs[npc] = nil
    end
end)
