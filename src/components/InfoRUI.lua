function RageUI.Info(Title, RightText, LeftText)
    local LineCount = #RightText >= #LeftText and #RightText or #LeftText
    if Title ~= nil then
        RenderText("~h~" .. Title .. "~h~", 350 + 80 + 100, 2, 0, 0.34, 255, 255, 255, 255, 0)
    end
    if RightText ~= nil then
        RenderText(table.concat(RightText, "\n"), 350 + 80 + 100, Title ~= nil and 35 or 7, 0, 0.28, 120, 0, 235, 255, 0)
    end
    if LeftText ~= nil then
        RenderText(table.concat(LeftText, "\n"), 350 + 500 + 100, Title ~= nil and 35 or 7, 0, 0.28, 120, 0, 235, 255, 2)
    end
    RenderRectangle(350 + 10 + 170, 0, 430, Title ~= nil and 50 + (LineCount * 30) or ((LineCount + 1) * 20), 0, 0, 0, 160)
end


-- RageUI.Info("Titre", {"Sous titre 1", "Sous titre 2", "Sous titre 3","Sous titre 4"}, {"Sous titre droite 1", "Sous titre droite 2", "Sous titre droite 3","Sous titre droite 4" })




---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = 38 },
    Text = { X = 8, Y = 4, Scale = 0.33 },
}

function RageUI.Line()
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            local Option = RageUI.Options + 1
            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
                RenderRectangle(CurrentMenu.X + (CurrentMenu.WidthOffset * 2.5 ~= 0 and CurrentMenu.WidthOffset * 2.5 or 200)-150+8, CurrentMenu.Y + RageUI.ItemOffset + 15, 300, 3, 255,255,255,150)
                RageUI.ItemOffset = RageUI.ItemOffset + SettingsButton.Rectangle.Height
                if (CurrentMenu.Index == Option) then
                    if (RageUI.LastControl) then
                        CurrentMenu.Index = Option - 1
                        if (CurrentMenu.Index < 1) then
                            CurrentMenu.Index = RageUI.CurrentMenu.Options
                        end
                    else
                        CurrentMenu.Index = Option + 1
                    end
                end
            end
            RageUI.Options = RageUI.Options + 1
        end
    end
end