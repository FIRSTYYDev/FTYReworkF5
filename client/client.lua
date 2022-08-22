ESX = nil

local actionCles, ShowName, gamerTags, invisible, hasCinematic = {select = {"Prêter", "Détruire"}, index = 1}, false, {}, false, false

local fPerso = {
    ItemSelected = {},
    ItemSelected2 = {},
    WeaponData = {},
    factures = {},
    cledevoiture = {},
    bank = nil,
    sale = nil,
    DoorState = {
		FrontLeft = false,
		FrontRight = false,
		BackLeft = false,
		BackRight = false,
		Hood = false,
		Trunk = false
    },
	DoorIndex = 1,
	DoorList = {"Avant Gauche", "Avant Droite", "Arrière Gauche", "Arrière Droite"},
    minimap = true,
    cinema = false
}

local societymoney, societymoney2 = nil, nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.TriggerServerCallback('gPersonalmenu:getUsergroup', function(group)
        playergroup = group
    end)


    fPerso.WeaponData = ESX.GetWeaponList()
	for i = 1, #fPerso.WeaponData, 1 do
		if fPerso.WeaponData[i].name == 'WEAPON_UNARMED' then
			fPerso.WeaponData[i] = nil
		else
			fPerso.WeaponData[i].hash = GetHashKey(fPerso.WeaponData[i].name)
		end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)

		if ShowName then
			local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
			for _, v in pairs(GetActivePlayers()) do
				local otherPed = GetPlayerPed(v)
			
				if otherPed ~= pPed then
					if #(pCoords - GetEntityCoords(otherPed, false)) < 250.0 then
						gamerTags[v] = CreateFakeMpGamerTag(otherPed, ('[%s] %s'):format(GetPlayerServerId(v), GetPlayerName(v)), false, false, '', 0)
						SetMpGamerTagVisibility(gamerTags[v], 4, 1)
					else
						RemoveMpGamerTag(gamerTags[v])
						gamerTags[v] = nil
					end
				end
			end
		else
			for _, v in pairs(GetActivePlayers()) do
				RemoveMpGamerTag(gamerTags[v])
			end
		end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
	  ESX.PlayerData.money = money
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	RefreshMoney()
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
	RefreshMoney2()
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for i=1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == account.name then
			ESX.PlayerData.accounts[i] = account
			break
		end
	end
end)



function gPersonalmenu()
    local MPersonalmenu = RageUI.CreateMenu(Config.nomduserveur, "~p~ FTY Base")
    local Mportefeuille = RageUI.CreateSubMenu(MPersonalmenu, Config.nomduserveur, "~p~ FTY Base")
    local Mportefeuilleli = RageUI.CreateSubMenu(Mportefeuille, Config.nomduserveur, "~p~ FTY Base")
    local Mportefeuillesale = RageUI.CreateSubMenu(Mportefeuille, Config.nomduserveur, "~p~ FTY Base")
    local Mfacture = RageUI.CreateSubMenu(MPersonalmenu, Config.nomduserveur, "~p~ FTY Base")
    local Mvetements = RageUI.CreateSubMenu(MPersonalmenu, Config.nomduserveur, "~p~ FTY Base")
    local Mgestveh = RageUI.CreateSubMenu(MPersonalmenu, Config.nomduserveur, "~p~ FTY Base")
    local Mdivers = RageUI.CreateSubMenu(MPersonalmenu, Config.nomduserveur, "~p~ FTY Base")
    local Madmin = RageUI.CreateSubMenu(MPersonalmenu, Config.nomduserveur, "~p~ FTY Base")
    MPersonalmenu:SetRectangleBanner(11, 11, 11, 1)
    Mportefeuille:SetRectangleBanner(11, 11, 11, 1)
    Mportefeuilleli:SetRectangleBanner(11, 11, 11, 1)
    Mportefeuillesale:SetRectangleBanner(11, 11, 11, 1)
    Mfacture:SetRectangleBanner(11, 11, 11, 1)
    Mvetements:SetRectangleBanner(11, 11, 11, 1)
    Mgestveh:SetRectangleBanner(11, 11, 11, 1)
    Mdivers:SetRectangleBanner(11, 11, 11, 1)
    Madmin:SetRectangleBanner(11, 11, 11, 1)
        RageUI.Visible(MPersonalmenu, not RageUI.Visible(MPersonalmenu))
            while MPersonalmenu do
            Citizen.Wait(0)
            RageUI.IsVisible(MPersonalmenu, true, true, true, function()
                RageUI.Line()
                RageUI.Separator('Vos Informations : ~y~'..GetPlayerName(PlayerId()))
                RageUI.Separator('Votre ID : ~y~'..GetPlayerServerId(PlayerId()))
                RageUI.Line()
                RageUI.ButtonWithStyle("Portefeuille", "~y~Où ce trouve ton argent...", {RightLabel = "→"}, true, function(Hovered,Active,Selected)
                end, Mportefeuille)
                RageUI.ButtonWithStyle("Factures", "~y~Où ce trouve tes factures...", {RightLabel = "→"}, true, function(Hovered,Active,Selected)
                end, Mfacture)
                RageUI.ButtonWithStyle("Vétements", "~y~Où ce trouve ton style...", {RightLabel = "→"}, true, function(Hovered,Active,Selected)
                end, Mvetements)
                if IsPedSittingInAnyVehicle(PlayerPedId()) then
                    RageUI.ButtonWithStyle("Gestion Véhicule", "~y~Où ce trouve les intéractions de ton véhicule", {RightLabel = "→"}, true, function(Hovered,Active,Selected)
                    end, Mgestveh)                       
                    else
                    RageUI.ButtonWithStyle('Gestion Véhicule', description, {RightBadge = RageUI.BadgeStyle.Lock }, false, function(Hovered, Active, Selected)
                            if (Selected) then
                                end 
                            end)
                        end


            RageUI.Info("~P~FTY Base", {"Bienvenue sur FTY Base", "N'hésite pas à nous soutenir"}, {"~y~discord.gg/firstyy", "tebex.io/firstyy"})


            RageUI.ButtonWithStyle("Divers", "~y~Où ce trouve différentes actions...", {RightLabel = "→"}, true, function(Hovered,Active,Selected)
            end, Mdivers)

                end, function()
                end)


            RageUI.IsVisible(Mportefeuille, true, true, true, function()

                RageUI.Separator('~y~Métier : '..ESX.PlayerData.job.label, ESX.PlayerData.job.grade_label)

                if Config.DoubleJob then
                RageUI.Separator('~y~Oganisation : '..ESX.PlayerData.job2.label, ESX.PlayerData.job2.grade_label)
                end

                RageUI.ButtonWithStyle('Liquide : ', description, {RightLabel = "~g~$"..ESX.Math.GroupDigits(ESX.PlayerData.money.."~s~ →")}, true, function(Hovered, Active, Selected) 
                    if (Selected) then 
                        end 
                    end, Mportefeuilleli)

                for i = 1, #ESX.PlayerData.accounts, 1 do
                        if ESX.PlayerData.accounts[i].name == 'black_money' then
                            fPerso.sale = RageUI.ButtonWithStyle('Argent Sale : ', description, {RightLabel = "~r~$"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.."~s~ →")}, true, function(Hovered, Active, Selected) 
                                if (Selected) then 
                                        end 
                                end, Mportefeuillesale)

                            end
        
                    if ESX.PlayerData.accounts[i].name == 'bank' then
                        fPerso.bank = RageUI.ButtonWithStyle('Banque : ', description, {RightLabel = "~b~$"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.."~s~")}, true, function(Hovered, Active, Selected) 
                            if (Selected) then 
                                    end 
                                end)


                    end
                end

        if Config.JSFourIDCard then

            RageUI.Separator('~p~ ↓ Vos papiers ↓')
            
			RageUI.ButtonWithStyle('Montrer sa carte d\'identité', nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestDistance ~= -1 and closestDistance <= 3.0 then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
					else
						ESX.ShowNotification('Aucun joueur ~r~proche !')
					end
				end
			end)

			RageUI.ButtonWithStyle('Regarder sa carte d\'identité', nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
				end
			end)

			RageUI.ButtonWithStyle('Montrer son permis de conduire', nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestDistance ~= -1 and closestDistance <= 3.0 then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
					else
						ESX.ShowNotification('Aucun joueur ~r~proche !')
					end
				end
			end)

			RageUI.ButtonWithStyle('Regarder son permis de conduire', nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
				end
			end)

			RageUI.ButtonWithStyle('Montrer son permis port d\'armes', nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestDistance ~= -1 and closestDistance <= 3.0 then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
					else
						ESX.ShowNotification('Aucun joueur ~r~proche !')
					end
				end
			end)

			RageUI.ButtonWithStyle('Regarder son permis port d\'armes', nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
				end
			end)
		end

            end, function()
            end)
            RageUI.IsVisible(Mportefeuilleli, true, true, true, function()
                RageUI.ButtonWithStyle("Donner", nil, {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered,Active,Selected)
                    if Selected then
                        local quantity = fPersonalmenuKeyboardInput("Somme d'argent que vous voulez donner", '', 25)
                            if tonumber(quantity) then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                        if closestDistance ~= -1 and closestDistance <= 3 then
                            local closestPed = GetPlayerPed(closestPlayer)

                            if not IsPedSittingInAnyVehicle(closestPed) then
                                TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_money', 'rien', tonumber(quantity))
                            else
                               ESX.ShowNotification('Vous ne pouvez pas donner de l\'argent dans un véhicles')
                            end
                        else
                           ESX.ShowNotification('Aucun joueur proche !')
                        end
                    else
                       ESX.ShowNotification('Somme invalid')
                    end
                end
            end)

            RageUI.ButtonWithStyle("Jeter", nil, {RightBadge = RageUI.BadgeStyle.Tick}, false, function(Hovered, Active, Selected)
                if Selected then
                    local quantity = fPersonalmenuKeyboardInput("Somme d'argent que vous voulez jeter", "", 25)
                    if tonumber(quantity) then
                        if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                            TriggerServerEvent('esx:removeInventoryItem', 'item_money', 'rien', tonumber(quantity))
                            RageUI.CloseAll()
                        else
                            ESX.ShowNotification("~r~Cette action est impossible dans un véhicule !")
                        end
                    else
                        ESX.ShowNotification("~r~Les champs sont incorrects !")
                    end
                end
            end)

            end, function()
            end)

            RageUI.IsVisible(Mportefeuillesale, true, true, true, function()
                for i = 1, #ESX.PlayerData.accounts, 1 do
                    if ESX.PlayerData.accounts[i].name == 'black_money' then
                        RageUI.ButtonWithStyle("Donner", nil, {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered,Active,Selected)
                            if Selected then
                                local quantity = fPersonalmenuKeyboardInput("Somme d'argent que vous voulez jeter", "", 25)
                                if tonumber(quantity) then
                                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                                if closestDistance ~= -1 and closestDistance <= 3 then
                                    local closestPed = GetPlayerPed(closestPlayer)

                                    if not IsPedSittingInAnyVehicle(closestPed) then
                                        TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, tonumber(quantity))
                                        --RageUI.CloseAll()
                                    else
                                       ESX.ShowNotification(_U('Vous ne pouvez pas donner ', 'de l\'argent dans un véhicles'))
                                    end
                                else
                                   ESX.ShowNotification('Aucun joueur proche !')
                                end
                            else
                               ESX.ShowNotification('Somme invalid')
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Jeter", nil, {RightBadge = RageUI.BadgeStyle.Tick}, false, function(Hovered, Active, Selected)
                        if Selected then
                            local quantity = fPersonalmenuKeyboardInput("Somme d'argent que vous voulez jeter", "", 25)
                            if tonumber(quantity) then
                                if not IsPedSittingInAnyVehicle(PlayerPed) then
                                    TriggerServerEvent('esx:removeInventoryItem', 'item_account', ESX.PlayerData.accounts[i].name, tonumber(quantity))
                                   -- RageUI.CloseAll()
                                        else
                                           ESX.ShowNotification('Vous pouvez pas jeter', 'de l\'argent')
                                            end
                                        else
                                           ESX.ShowNotification('Somme Invalid')
                                        end
                                    end
                                end)
                            end
                        end
            end, function()
            end)
            RageUI.IsVisible(Mfacture, true, true, true, function()
                ESX.TriggerServerCallback('fPersonalmenu:facture', function(bills) fPerso.factures = bills end)

                if #fPerso.factures == 0 then
                    RageUI.Separator("")
                    RageUI.Separator("~y~Aucune facture impayée")
                    RageUI.Separator("")
                end
                    
                for i = 1, #fPerso.factures, 1 do
                RageUI.ButtonWithStyle(fPerso.factures[i].label, nil, {RightLabel = '[~b~$' .. ESX.Math.GroupDigits(fPerso.factures[i].amount.."~s~] →")}, true, function(Hovered,Active,Selected)
                    if Selected then
                            ESX.TriggerServerCallback('esx_billing:payBill', function()
                            ESX.TriggerServerCallback('fPersonalmenu:facture', function(bills) fPerso.factures = bills end)
                                    end, fPerso.factures[i].id)
                                end
                            end)
                        end
            end, function()
            end)
            RageUI.IsVisible(Mvetements, true, true, true, function()

                RageUI.Separator('~p~↓ Vêtements ↓')

                RageUI.ButtonWithStyle("Haut", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered, Active,Selected)
                    if (Selected) then
                       TriggerEvent('fPersonalmenu:actionhaut')   
                   end 
               end)
           
               RageUI.ButtonWithStyle("Pantalon", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered, Active,Selected)
                    if (Selected) then
                       TriggerEvent('fPersonalmenu:actionpantalon')  
                   end 
               end)
           
               RageUI.ButtonWithStyle("Chaussure", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered, Active,Selected)
                   if (Selected) then 
                   TriggerEvent('fPersonalmenu:actionchaussure')
                  end 
              end)
           
              RageUI.ButtonWithStyle("Sac", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered, Active,Selected)
               if (Selected) then
                   TriggerEvent('fPersonalmenu:actionsac') 
                   end 
               end)
           
               RageUI.ButtonWithStyle("Gilet par balle", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered, Active,Selected)
                   if (Selected) then
                       TriggerEvent('fPersonalmenu:actiongiletparballe') 
                   end 
               end)

               RageUI.Separator('~y~ ↓ Accessoires ↓')

            RageUI.ButtonWithStyle("Masque", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered, Active,Selected)
                if (Selected) then
                    TriggerEvent('fPersonalmenu:masque')
                end 
            end)

            RageUI.ButtonWithStyle("Gant", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered, Active,Selected)
                if (Selected) then
                    TriggerEvent('fPersonalmenu:gant')
                end 
            end)

            end, function()
            end)


            RageUI.IsVisible(Mgestveh, true, true, true, function()

                local Ped = GetPlayerPed(-1)
                local GetSourcevehicle = GetVehiclePedIsIn(Ped, false)
                local Vengine = GetVehicleEngineHealth(GetSourcevehicle)/10
                local Vengine = math.floor(Vengine)
                local VehPed = GetVehiclePedIsIn(PlayerPedId(), false)

                if IsPedSittingInAnyVehicle(PlayerPedId()) then
                    RageUI.Separator("Plaque d'immatriculation = ~b~"..GetVehicleNumberPlateText(VehPed).." ")
                else
                    RageUI.GoBack()
                end

                RageUI.Separator("Etat du moteur~s~ =~b~ "..Vengine.."%")
                
                RageUI.ButtonWithStyle("Allumer/Eteindre le Moteur", nil, {}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if IsPedSittingInAnyVehicle(PlayerPedId()) then
                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        
                            if GetIsVehicleEngineRunning(plyVeh) then
                                SetVehicleEngineOn(plyVeh, false, false, true)
                                SetVehicleUndriveable(plyVeh, true)
                            elseif not GetIsVehicleEngineRunning(plyVeh) then
                                SetVehicleEngineOn(plyVeh, true, false, true)
                                SetVehicleUndriveable(plyVeh, false)
                            end
                        else
                            ESX.ShowNotification("Vous n'êtes pas dans un véhicule")
                        end
                    end
                end)


                RageUI.List("Ouvrir/Fermer Porte", fPerso.DoorList, fPerso.DoorIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
                    if (Selected) then
                        if IsPedSittingInAnyVehicle(PlayerPedId()) then
                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        
                            if Index == 1 then
                                if not fPerso.DoorState.FrontLeft then
                                    fPerso.DoorState.FrontLeft = true
                                    SetVehicleDoorOpen(plyVeh, 0, false, false)
                                elseif fPerso.DoorState.FrontLeft then
                                    fPerso.DoorState.FrontLeft = false
                                    SetVehicleDoorShut(plyVeh, 0, false, false)
                                end
                            elseif Index == 2 then
                                if not fPerso.DoorState.FrontRight then
                                    fPerso.DoorState.FrontRight = true
                                    SetVehicleDoorOpen(plyVeh, 1, false, false)
                                elseif fPerso.DoorState.FrontRight then
                                    fPerso.DoorState.FrontRight = false
                                    SetVehicleDoorShut(plyVeh, 1, false, false)
                                end
                            elseif Index == 3 then
                                if not fPerso.DoorState.BackLeft then
                                    fPerso.DoorState.BackLeft = true
                                    SetVehicleDoorOpen(plyVeh, 2, false, false)
                                elseif fPerso.DoorState.BackLeft then
                                    fPerso.DoorState.BackLeft = false
                                    SetVehicleDoorShut(plyVeh, 2, false, false)
                                end
                            elseif Index == 4 then
                                if not fPerso.DoorState.BackRight then
                                    fPerso.DoorState.BackRight = true
                                    SetVehicleDoorOpen(plyVeh, 3, false, false)
                                elseif fPerso.DoorState.BackRight then
                                    fPerso.DoorState.BackRight = false
                                    SetVehicleDoorShut(plyVeh, 3, false, false)
                                end
                            end
                        else
                            ESX.ShowNotification("Vous n'êtes pas dans un véhicule")
                        end
                    end
        
                    fPerso.DoorIndex = Index
                end)

                RageUI.ButtonWithStyle("Ouvrir/Fermer Capot", nil, {}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if IsPedSittingInAnyVehicle(PlayerPedId()) then
                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        
                            if not fPerso.DoorState.Hood then
                                fPerso.DoorState.Hood = true
                                SetVehicleDoorOpen(plyVeh, 4, false, false)
                            elseif fPerso.DoorState.Hood then
                                fPerso.DoorState.Hood = false
                                SetVehicleDoorShut(plyVeh, 4, false, false)
                            end
                        else
                            ESX.ShowNotification("Vous n'êtes pas dans un véhicule")
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Ouvrir/Fermer Coffre", nil, {}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if IsPedSittingInAnyVehicle(PlayerPedId()) then
                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        
                            if not fPerso.DoorState.Trunk then
                                fPerso.DoorState.Trunk = true
                                SetVehicleDoorOpen(plyVeh, 5, false, false)
                            elseif fPerso.DoorState.Trunk then
                                fPerso.DoorState.Trunk = false
                                SetVehicleDoorShut(plyVeh, 5, false, false)
                            end
                        else
                            ESX.ShowNotification("Vous n'êtes pas dans un véhicule")
                        end
                    end
                end)
            end, function()
            end)




                RageUI.IsVisible(Mdivers, true, true, true, function()

                RageUI.Checkbox("Afficher / Désactiver la map", nil, fPerso.minimap,{},function(Hovered,Ative,Selected,Checked)
                    if Selected then
                        fPerso.minimap = Checked
                        if Checked then
                            DisplayRadar(true)
                        else
                            DisplayRadar(false)
                        end
                    end
                end)


                local ragdolling = false
                RageUI.ButtonWithStyle('Dormir / Se Reveiller', description, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                    if (Selected) then
                        ragdolling = not ragdolling
                        while ragdolling do
                         Wait(0)
                        local myPed = GetPlayerPed(-1)
                        SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
                        ResetPedRagdollTimer(myPed)
                        AddTextEntry(GetCurrentResourceName(), ('Appuyez sur ~INPUT_JUMP~ pour vous ~b~Réveillé'))
                        DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
                        ResetPedRagdollTimer(myPed)
                        if IsControlJustPressed(0, 22) then 
                        break
                            end
                        end
                    end
                end)


                RageUI.Checkbox("Afficher / Désactiver le mode cinématique", nil, fPerso.cinema,{},function(Hovered,Ative,Selected,Checked)
                    if Selected then
                        fPerso.cinema = Checked
                        if Checked then
                            SendNUIMessage({openCinema = true})
                            ESX.UI.HUD.SetDisplay(0.0)
                            TriggerEvent('es:setMoneyDisplay', 0.0)
                            TriggerEvent('esx_status:setDisplay', 0.0)
                            DisplayRadar(false)
                            TriggerEvent('ui:toggle', false)
                            TriggerEvent('ui:togglevoit', false)
					cinematique = true
                        else
                            SendNUIMessage({openCinema = false})
                            ESX.UI.HUD.SetDisplay(1.0)
                            TriggerEvent('es:setMoneyDisplay', 0.0)
                            TriggerEvent('esx_status:setDisplay', 1.0)
                            DisplayRadar(true)
                            TriggerEvent('ui:toggle', true)
                            TriggerEvent('ui:togglevoit', true)
                            cinematique = false
                        end
                    end
                end)
        
                end, function()
                end)

            if not RageUI.Visible(MPersonalmenu) and not RageUI.Visible(Mportefeuille) and not RageUI.Visible(Mportefeuilleli) and not RageUI.Visible(Mportefeuillesale) and not RageUI.Visible(Mfacture) and not RageUI.Visible(Mvetements) and not RageUI.Visible(Mgestveh) and not RageUI.Visible(Mdivers) and not RageUI.Visible(Madmin) then
            MPersonalmenu = RMenu:DeleteType("MPersonalmenu", true)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 0
        if IsControlJustPressed(1,166) then
            ESX.TriggerServerCallback('fPersonalmenu:facture', function(bills)
                fPerso.factures = bills
                gPersonalmenu()
            end)
        end

        if IsControlJustReleased(0, 73) and IsInputDisabled(2) then
			ClearPedTasks(PlayerPedId())
		end
        
        Citizen.Wait(Timer)
    end
end)

function RefreshCles()
    getCles = {}
    ESX.TriggerServerCallback("fPersonalmenu:clevoiture", function(cles)
            for k, v in pairs(cles) do
                table.insert(getCles, {id = v.id, label = v.label, value = v.value})
            end
        end)
end


---


RegisterNetEvent('fPersonalmenu:envoyeremployer')
AddEventHandler('fPersonalmenu:envoyeremployer', function(service, nom, message)
	if service == 'patron' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('INFO '..ESX.PlayerData.job.label, '~b~A lire', 'Patron: ~g~'..nom..'\n~w~Message: ~g~'..message..'', 'CHAR_MINOTAUR', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)	
	end
end)


-- pour les Vétements Mettre/Enlever

RegisterNetEvent('fPersonalmenu:actionhaut')
AddEventHandler('fPersonalmenu:actionhaut', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skina)
        TriggerEvent('skinchanger:getSkin', function(skinb)
            local lib, anim = 'clothingtie', 'try_tie_neutral_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            Citizen.Wait(1000)
            ClearPedTasks(PlayerPedId())

            if skina.torso_1 ~= skinb.torso_1 then
                vethaut = true
                TriggerEvent('skinchanger:loadClothes', skinb, {['torso_1'] = skina.torso_1, ['torso_2'] = skina.torso_2, ['tshirt_1'] = skina.tshirt_1, ['tshirt_2'] = skina.tshirt_2, ['arms'] = skina.arms})
            else
                TriggerEvent('skinchanger:loadClothes', skinb, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15})
                vethaut = false
            end
        end)
    end)
end)

RegisterNetEvent('fPersonalmenu:actionpantalon')
AddEventHandler('fPersonalmenu:actionpantalon', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skina)
        TriggerEvent('skinchanger:getSkin', function(skinb)
            local lib, anim = 'clothingtrousers', 'try_trousers_neutral_c'

            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            Citizen.Wait(1000)
            ClearPedTasks(PlayerPedId())

            if skina.pants_1 ~= skinb.pants_1 then
                TriggerEvent('skinchanger:loadClothes', skinb, {['pants_1'] = skina.pants_1, ['pants_2'] = skina.pants_2})
                vetbas = true
            else
                vetbas = false
                if skina.sex == 1 then
                    TriggerEvent('skinchanger:loadClothes', skinb, {['pants_1'] = 15, ['pants_2'] = 0})
                else
                    TriggerEvent('skinchanger:loadClothes', skinb, {['pants_1'] = 61, ['pants_2'] = 1})
                end
            end
        end)
    end)
end)


RegisterNetEvent('fPersonalmenu:actionchaussure')
AddEventHandler('fPersonalmenu:actionchaussure', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skina)
        TriggerEvent('skinchanger:getSkin', function(skinb)
            local lib, anim = 'clothingshoes', 'try_shoes_positive_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            Citizen.Wait(1000)
            ClearPedTasks(PlayerPedId())
            if skina.shoes_1 ~= skinb.shoes_1 then
                TriggerEvent('skinchanger:loadClothes', skinb, {['shoes_1'] = skina.shoes_1, ['shoes_2'] = skina.shoes_2})
                vetch = true
            else
                vetch = false
                if skina.sex == 1 then
                    TriggerEvent('skinchanger:loadClothes', skinb, {['shoes_1'] = 35, ['shoes_2'] = 0})
                else
                    TriggerEvent('skinchanger:loadClothes', skinb, {['shoes_1'] = 34, ['shoes_2'] = 0})
                end
            end
        end)
    end)
end)

RegisterNetEvent('fPersonalmenu:actionsac')
AddEventHandler('fPersonalmenu:actionsac', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skina)
        TriggerEvent('skinchanger:getSkin', function(skinb)
            local lib, anim = 'clothingtie', 'try_tie_neutral_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            Citizen.Wait(1000)
            ClearPedTasks(PlayerPedId())
            if skina.bags_1 ~= skinb.bags_1 then
                TriggerEvent('skinchanger:loadClothes', skinb, {['bags_1'] = skina.bags_1, ['bags_2'] = skina.bags_2})
                vetsac = true
            else
                TriggerEvent('skinchanger:loadClothes', skinb, {['bags_1'] = 0, ['bags_2'] = 0})
                vetsac = false
            end
        end)
    end)
end)


RegisterNetEvent('fPersonalmenu:actiongiletparballe')
AddEventHandler('fPersonalmenu:actiongiletparballe', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skina)
        TriggerEvent('skinchanger:getSkin', function(skinb)
            local lib, anim = 'clothingtie', 'try_tie_neutral_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            Citizen.Wait(1000)
            ClearPedTasks(PlayerPedId())
            if skina.bproof_1 ~= skinb.bproof_1 then
                TriggerEvent('skinchanger:loadClothes', skinb, {['bproof_1'] = skina.bproof_1, ['bproof_2'] = skina.bproof_2})
                vetgilet = true
            else
                TriggerEvent('skinchanger:loadClothes', skinb, {['bproof_1'] = 0, ['bproof_2'] = 0})
                vetgilet = false
            end
        end)
    end)
end)

RegisterNetEvent('fPersonalmenu:masque')
AddEventHandler('fPersonalmenu:masque', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skina)
        TriggerEvent('skinchanger:getSkin', function(skinb)
            local lib, anim = 'clothingtie', 'try_tie_neutral_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            Citizen.Wait(1000)
            ClearPedTasks(PlayerPedId())
            if skina.mask_1 ~= skinb.mask_1 then
                TriggerEvent('skinchanger:loadClothes', skinb, {['mask_1'] = skina.mask_1, ['mask_2'] = skina.mask_2})
                vetmask = true
            else
                TriggerEvent('skinchanger:loadClothes', skinb, {['mask_1'] = 0, ['mask_2'] = 0})
                vetmask = false
            end
        end)
    end)
end)

