Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(5000)
        print("Client: Hello World")
    end
end)