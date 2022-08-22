  
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


-- Avoir le grade du joueur
ESX.RegisterServerCallback('gPersonalmenu:getUsergroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local group = xPlayer.getGroup()
	--print(GetPlayerName(source).." - "..group)
	cb(group)
end)

-- Factures
ESX.RegisterServerCallback('fPersonalmenu:facture', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local bills = {}

		for i = 1, #result do
			bills[#bills + 1] = {
				id = result[i].id,
				label = result[i].label,
				amount = result[i].amount
			}
		end

		cb(bills)
	end)
end)

--- Admin 


--Argent cash
RegisterServerEvent("fPersonalmenu:GiveArgentCash")
AddEventHandler("fPersonalmenu:GiveArgentCash", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	
	xPlayer.addMoney((total))
end)

--Argent sale
RegisterServerEvent("fPersonalmenu:GiveArgentSale")
AddEventHandler("fPersonalmenu:GiveArgentSale", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	
	xPlayer.addAccountMoney('black_money', total)
end)

--Argent banque
RegisterServerEvent("fPersonalmenu:GiveArgentBanque")
AddEventHandler("fPersonalmenu:GiveArgentBanque", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	
	xPlayer.addAccountMoney('bank', total)
end)



function sendToDiscordWithSpecialURL(name,message,des,color,url)
    local DiscordWebHook = url
	local embeds = {
		{
			["title"]=message,
			['description']=des,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "fPersonalmenu rework by FIRSTYY",
			},
		}
	}
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({username = name, avatar_url = "https://help.twitter.com/content/dam/help-twitter/brand/logo.png", embeds = embeds}), { ['Content-Type'] = 'application/json' })
end