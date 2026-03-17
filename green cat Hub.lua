getgenv().Setting = {
    FastAttack = true,
    AttackSpeed = 0.01,

    Fly = false,
    FlySpeed = 360,

    AutoFarm = false,
    SelectMob = "",

    Distance = 10,

    Hitbox = true,
    HitboxSize = 15,
    HitboxDistance = 50
}

getgenv().AutoMastery = false
getgenv().AutoAllBoss = false
getgenv().AutoBones = false

local plr = game.Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", plr.PlayerGui)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,460,0,360)
main.Position = UDim2.new(0.3,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(20,60,20)
main.Active = true
main.Draggable = true

local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(0,120,1,0)
tabFrame.BackgroundColor3 = Color3.fromRGB(30,90,30)

local content = Instance.new("Frame", main)
content.Position = UDim2.new(0,120,0,0)
content.Size = UDim2.new(1,-120,1,0)
content.BackgroundColor3 = Color3.fromRGB(25,70,25)

local pages = {}

local function Tab(name)
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(1,0,0,45)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50,120,50)
    btn.TextColor3 = Color3.fromRGB(220,255,220)

    local page = Instance.new("Frame", content)
    page.Size = UDim2.new(1,0,1,0)
    page.Visible = false

    pages[name] = page

    btn.MouseButton1Click:Connect(function()
        for _,p in pairs(pages) do p.Visible = false end
        page.Visible = true
    end)

    return page
end

-- TAB
local farm = Tab("Farm")
local misc = Tab("Khác")

-- UI FUNC
local function Btn(parent,text,y,callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0,250,0,40)
    b.Position = UDim2.new(0,20,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(60,130,60)
    b.TextColor3 = Color3.fromRGB(220,255,220)
    b.MouseButton1Click:Connect(callback)
end

local function Box(parent,y,callback)
    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.new(0,250,0,35)
    box.Position = UDim2.new(0,20,0,y)
    box.PlaceholderText = "Nhập tên quái..."
    box.BackgroundColor3 = Color3.fromRGB(50,90,50)
    box.TextColor3 = Color3.new(1,1,1)
    box.FocusLost:Connect(function()
        callback(box.Text)
    end)
end

-- FARM
Btn(farm,"Auto Farm",0,function()
    getgenv().Setting.AutoFarm = not getgenv().Setting.AutoFarm
end)

Box(farm,50,function(v)
    getgenv().Setting.SelectMob = v
end)

-- MISC
Btn(misc,"Fast Attack",0,function()
    getgenv().Setting.FastAttack = not getgenv().Setting.FastAttack
end)

Btn(misc,"Fly",50,function()
    getgenv().Setting.Fly = not getgenv().Setting.Fly
end)

Btn(misc,"Auto Mastery (Godhuman)",100,function()
    getgenv().AutoMastery = not getgenv().AutoMastery
end)

Btn(misc,"Auto Boss (Haki)",150,function()
    getgenv().AutoAllBoss = not getgenv().AutoAllBoss
end)

Btn(misc,"Auto Bones (Guitar)",200,function()
    getgenv().AutoBones = not getgenv().AutoBones
end)

Btn(misc,"Hitbox",250,function()
    getgenv().Setting.Hitbox = not getgenv().Setting.Hitbox
end)

-- AUTO FARM (ĐỨNG TRÊN ĐẦU + XA)
spawn(function()
    while task.wait(0.1) do
        if getgenv().Setting.AutoFarm then
            for _,v in pairs(game.Workspace.Enemies:GetChildren()) do
                if v.Name:find(getgenv().Setting.SelectMob) then
                    plr.Character.HumanoidRootPart.CFrame =
                        v.HumanoidRootPart.CFrame *
                        CFrame.new(0, getgenv().Setting.Distance, getgenv().Setting.HitboxDistance)
                end
            end
        end
    end
end)

-- HITBOX
spawn(function()
    while task.wait(0.2) do
        if getgenv().Setting.Hitbox then
            for _,v in pairs(game.Workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("HumanoidRootPart") then
                    v.HumanoidRootPart.Size = Vector3.new(
                        getgenv().Setting.HitboxSize,
                        getgenv().Setting.HitboxSize,
                        getgenv().Setting.HitboxSize
                    )
                    v.HumanoidRootPart.Transparency = 0.7
                    v.HumanoidRootPart.CanCollide = false
                end
            end
        end
    end
end)

-- FAST ATTACK
spawn(function()
    while task.wait(getgenv().Setting.AttackSpeed) do
        if getgenv().Setting.FastAttack then
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:Button1Down(Vector2.new(0,0))
                vu:Button1Up(Vector2.new(0,0))

                for _,tool in pairs(plr.Character:GetChildren()) do
                    if tool:IsA("Tool") then
                        tool:Activate()
                    end
                end
            end)
        end
    end
end)

-- FLY
spawn(function()
    while task.wait() do
        if getgenv().Setting.Fly then
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Velocity = Vector3.new(0, getgenv().Setting.FlySpeed, 0)
            end
        end
    end
end)

-- AUTO MASTERY
spawn(function()
    while task.wait(0.1) do
        if getgenv().AutoMastery then
            for _,v in pairs(game.Workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    plr.Character.HumanoidRootPart.CFrame =
                        v.HumanoidRootPart.CFrame * CFrame.new(0,10,0)
                end
            end
        end
    end
end)

-- AUTO BOSS
spawn(function()
    while task.wait(1) do
        if getgenv().AutoAllBoss then
            for _,v in pairs(game.Workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") then
                    plr.Character.HumanoidRootPart.CFrame =
                        v.HumanoidRootPart.CFrame
                end
            end
        end
    end
end)

-- AUTO BONES
spawn(function()
    while task.wait(0.1) do
        if getgenv().AutoBones then
            for _,v in pairs(game.Workspace.Enemies:GetChildren()) do
                if v.Name:lower():find("skeleton") then
                    plr.Character.HumanoidRootPart.CFrame =
                        v.HumanoidRootPart.CFrame * CFrame.new(0,10,0)
                end
            end
        end
    end
end)