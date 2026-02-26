local args = {
    [1] = "Ghost"
}

while true do
    game:GetService("ReplicatedStorage").ActivateGear:FireServer(unpack(args))
    task.wait(15.1)  -- espera 15.5 segundos antes de la siguiente activación
end
