local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TargetHighlightEvent = Instance.new("RemoteEvent")
TargetHighlightEvent.Name = "TargetHighlightEvent"
TargetHighlightEvent.Parent = ReplicatedStorage

local function getNearestEnemy(player, range)
    local character = player.Character
    if not character then return nil end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end

    local nearestEnemy = nil
    local shortestDistance = range

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local otherRootPart = otherPlayer.Character.HumanoidRootPart
            local distance = (humanoidRootPart.Position - otherRootPart.Position).magnitude

            if distance < shortestDistance then
                nearestEnemy = otherPlayer
                shortestDistance = distance
            end
        end
    end

    return nearestEnemy
end

local function onPlayerRequestHighlight(player)
    local target = getNearestEnemy(player, 100) -- Range of 100 studs
    if target and target.Character and target.Character:FindFirstChild("Head") then
        TargetHighlightEvent:FireClient(player, target.Character.Head.Position)
    end
end

TargetHighlightEvent.OnServerEvent:Connect(onPlayerRequestHighlight)
