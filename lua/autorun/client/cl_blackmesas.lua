
-- gross hack to make stuff work :)
spawnmenu.AddContentType = function(name, func)
    if name ~= "entity" then
        spawnmenu.AddContentType(name, func)
        return
    end

    func = function(container, obj)
        local out = func(container, obj)
        out.OpenMenuExtra = function(self, menu)
            (out.OpenMenuExtra or function() end)(self, menu)

            menu:AddOption( "Spawn with Clone Wand", function()
                print("This is a test!")
            end):SetIcon( "icon16/brick_add.png" )
        end

        return out
    end
    spawnmenu.AddContentType(name, func)
end


