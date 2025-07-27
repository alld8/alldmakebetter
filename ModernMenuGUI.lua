-- Anti Duplikat
pcall(function()
	local gui = game:GetService("CoreGui"):FindFirstChild("ModernMenuGUI")
	if gui then gui:Destroy() end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "ModernMenuGUI"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

local themeColor = Color3.fromRGB(0, 120, 215)
local bgColor = Color3.fromRGB(25, 25, 35)
local accentColor = Color3.fromRGB(0, 150, 255)

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 600, 0, 350)
main.Position = UDim2.new(0.5, -300, 0.5, -175)
main.BackgroundColor3 = bgColor
main.BorderSizePixel = 0

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Topbar
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 30)
top.BackgroundColor3 = themeColor
top.BorderSizePixel = 0

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, -90, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Modern Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamSemibold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

-- Buttons (Close, Minimize)
local function makeBtn(text, offset)
	local btn = Instance.new("TextButton", top)
	btn.Size = UDim2.new(0, 28, 0, 28)
	btn.Position = UDim2.new(1, offset, 0, 1)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.BackgroundColor3 = Color3.fromRGB(0, 90, 170)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BorderSizePixel = 0
	return btn
end

local close = makeBtn("X", -30)
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Sidebar Tabs
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 140, 1, -30)
sidebar.Position = UDim2.new(0, 0, 0, 30)
sidebar.BackgroundColor3 = Color3.fromRGB(20, 30, 45)

local tabBtn = Instance.new("TextButton", sidebar)
tabBtn.Size = UDim2.new(1, 0, 0, 40)
tabBtn.Position = UDim2.new(0, 0, 0, 10)
tabBtn.Text = "👥  Player"
tabBtn.TextColor3 = Color3.new(1, 1, 1)
tabBtn.Font = Enum.Font.GothamBold
tabBtn.TextSize = 14
tabBtn.BackgroundColor3 = accentColor
tabBtn.BorderSizePixel = 0

Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

-- Content Panel
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -140, 1, -30)
content.Position = UDim2.new(0, 140, 0, 30)
content.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 8)

-- TargetPlayer logic
local TargetPlayer = nil

-- Dropdown
local dropdown = Instance.new("TextButton", content)
dropdown.Size = UDim2.new(0, 300, 0, 35)
dropdown.Position = UDim2.new(0, 20, 0, 20)
dropdown.Text = "Select Player"
dropdown.TextColor3 = Color3.new(1,1,1)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
dropdown.BackgroundColor3 = themeColor

local dropdownList = Instance.new("Frame", dropdown)
dropdownList.Position = UDim2.new(0, 0, 1, 0)
dropdownList.Size = UDim2.new(1, 0, 0, 120)
dropdownList.Visible = false
dropdownList.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
dropdownList.ClipsDescendants = true

dropdown.MouseButton1Click:Connect(function()
	dropdownList.Visible = not dropdownList.Visible
end)

local function refreshDropdown()
	dropdownList:ClearAllChildren()
	local y = 0
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local btn = Instance.new("TextButton", dropdownList)
			btn.Size = UDim2.new(1, 0, 0, 25)
			btn.Position = UDim2.new(0, 0, 0, y)
			btn.Text = p.Name
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 13
			btn.TextColor3 = Color3.new(1,1,1)
			btn.BackgroundColor3 = Color3.fromRGB(30, 60, 90)
			btn.MouseButton1Click:Connect(function()
				TargetPlayer = p
				dropdown.Text = "🎯 " .. p.Name
				dropdownList.Visible = false
			end)
			y += 26
		end
	end
end
refreshDropdown()
Players.PlayerAdded:Connect(refreshDropdown)
Players.PlayerRemoving:Connect(refreshDropdown)

-- Buttons helper
local function createBtn(text, yOffset, callback)
	local btn = Instance.new("TextButton", content)
	btn.Size = UDim2.new(0, 300, 0, 35)
	btn.Position = UDim2.new(0, 20, 0, yOffset)
	btn.Text = text
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 14
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
	btn.BorderSizePixel = 0
	btn.MouseButton1Click:Connect(callback)
	return btn
end

createBtn("ESP All", 70, function()
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			print("ESP >>", p.Name)
		end
	end
end)

createBtn("ESP Target", 115, function()
	if TargetPlayer then
		print("ESP Target >>", TargetPlayer.Name)
	end
end)

createBtn("Teleport to Player", 160, function()
	if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character:MoveTo(TargetPlayer.Character.HumanoidRootPart.Position)
	end
end)

local viewing = false
local viewBtn = createBtn("View Target", 205, function()
	if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("Head") then
		viewing = not viewing
		workspace.CurrentCamera.CameraSubject = viewing and TargetPlayer.Character.Head or LocalPlayer.Character:FindFirstChild("Head")
		viewBtn.Text = viewing and "Unview Target" or "View Target"
	end
end)
