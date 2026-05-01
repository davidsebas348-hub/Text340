-- 🔒 ANTI DUPLICADO (CLAVE PARA AUTO EXECUTE)
if getgenv().AutoExecLoaded then return end
getgenv().AutoExecLoaded = true

repeat task.wait() until game:IsLoaded()

-- 🔁 RE-EJECUTAR EN TELEPORT
if queue_on_teleport then
    queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/davidsebas348-hub/Text340/main/Text340.lua"))()')
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

-- ========= TOUCH =========
local function fireTouch(part)
    if part and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        firetouchinterest(player.Character.HumanoidRootPart, part, 0)
        task.wait()
        firetouchinterest(player.Character.HumanoidRootPart, part, 1)
    end
end

local function doEscapeOrEnter()
    local workspace = game:GetService("Workspace")

    local escape = workspace:FindFirstChild("EscapeArea")

    if escape and escape:IsA("BasePart") then
        fireTouch(escape)
    else
        -- 🔥 AHORA ACTIVA LOS 3 ENTERS
        local posibles = {"Enter1", "Enter2", "Enter3"}

        for _, name in ipairs(posibles) do
            local part = workspace:FindFirstChild(name)
            if part and part:IsA("BasePart") then
                fireTouch(part)
            end
        end
    end
end

-- ========= REMOTES =========
local function fireLobbyRemotes()
    local tp1 = ReplicatedStorage:FindFirstChild("TPToLobby")
    local tp2 = ReplicatedStorage:FindFirstChild("TPGuardToLobby")

    if tp1 then tp1:FireServer() end
    if tp2 then tp2:FireServer() end
end

-- ========= REJOIN =========
local function rejoin()
    task.wait(6)
    TeleportService:Teleport(game.PlaceId, player)
end

-- ========= DETECTOR =========
local function detectEscapes()
    local leaderstats = player:WaitForChild("leaderstats", 10)
    if not leaderstats then return end

    local escapeStat = leaderstats:FindFirstChild("Escapes")
    if not escapeStat then return end

    local lastValue = escapeStat.Value

    escapeStat:GetPropertyChangedSignal("Value"):Connect(function()
        if escapeStat.Value > lastValue then
            lastValue = escapeStat.Value
            fireLobbyRemotes()
            task.spawn(rejoin)
        end
    end)
end

-- ========= START =========
task.spawn(detectEscapes)
doEscapeOrEnter()
