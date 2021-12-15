
local original = spawnmenu.AddContentType

local function addOption(menu)
    menu:AddOption( "Spawn using Clone Wand", function()
        print("This is a test!")
    end):SetIcon( "icon16/brick_add.png" )
end

-- gross hack to make stuff work :)
spawnmenu.AddContentType = function(name, func)
    if name ~= "entity" && name ~= "weapon" && name ~= "model" then
        original(name, func)
        return
    end

    local originalFunc = func

    func = function(container, obj)
        local out = originalFunc(container, obj)

        if name ~= "model" then

            local originalExtra = (out.OpenMenuExtra || function() end)
            out.OpenMenuExtra = function(self, menu)
                originalExtra(self, menu)

                addOption(menu)
            end
        else

            out.OpenMenu = function( icon )

                -- Use the containter that we are dragged onto, not the one we were created on
                if ( icon:GetParent() && icon:GetParent().ContentContainer ) then
                    container = icon:GetParent().ContentContainer
                end

                local menu = DermaMenu()
                menu:AddOption( "#spawnmenu.menu.copy", function() SetClipboardText( string.gsub( obj.model, "\\", "/" ) ) end ):SetIcon( "icon16/page_copy.png" )
                menu:AddOption( "#spawnmenu.menu.spawn_with_toolgun", function() RunConsoleCommand( "gmod_tool", "creator" ) RunConsoleCommand( "creator_type", "4" ) RunConsoleCommand( "creator_name", obj.model ) end ):SetIcon( "icon16/brick_add.png" )
                addOption(menu)

                local submenu, submenu_opt = menu:AddSubMenu( "#spawnmenu.menu.rerender", function() icon:RebuildSpawnIcon() end )
                submenu_opt:SetIcon( "icon16/picture_save.png" )
                submenu:AddOption( "#spawnmenu.menu.rerender_this", function() icon:RebuildSpawnIcon() end ):SetIcon( "icon16/picture.png" )
                submenu:AddOption( "#spawnmenu.menu.rerender_all", function() container:RebuildAll() end ):SetIcon( "icon16/pictures.png" )

                menu:AddOption( "#spawnmenu.menu.edit_icon", function()

                    local editor = vgui.Create( "IconEditor" )
                    editor:SetIcon( icon )
                    editor:Refresh()
                    editor:MakePopup()
                    editor:Center()

                end ):SetIcon( "icon16/pencil.png" )

                -- Do not allow removal/size changes from read only panels
                if ( IsValid( icon:GetParent() ) && icon:GetParent().GetReadOnly && icon:GetParent():GetReadOnly() ) then menu:Open() return end

                icon:InternalAddResizeMenu( menu, function( w, h )

                    icon:SetSize( w, h )
                    icon:InvalidateLayout( true )
                    container:OnModified()
                    container:Layout()
                    icon:SetModel( obj.model, obj.skin || 0, obj.body )

                end )

                menu:AddSpacer()
                menu:AddOption( "#spawnmenu.menu.delete", function() icon:Remove() hook.Run( "SpawnlistContentChanged" ) end ):SetIcon( "icon16/bin_closed.png" )
                menu:Open()

            end
        end

        return out
    end
    original(name, func)
end


