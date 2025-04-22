local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "FOVGui"

local Label = Instance.new("TextLabel", ScreenGui)
Label.Size = UDim2.new(0.4, 0, 0.08, 0)
Label.Position = UDim2.new(0.3, 0, 0.9, 0)
Label.BackgroundColor3 = Color3.fromRGB(20,20,20)
Label.BackgroundTransparency = 1
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.TextScaled = true
Label.Font = Enum.Font.GothamBold
Label.Visible = false
Label.TextStrokeTransparency = 0.5
Label.TextStrokeColor3 = Color3.new(0,0,0)
Label.BorderSizePixel = 0
Label.ClipsDescendants = true

local ControlsHint = Instance.new("TextLabel", ScreenGui)
ControlsHint.Size = UDim2.new(0.25, 0, 0.18, 0)
ControlsHint.Position = UDim2.new(0.73, 0, 0.02, 0)
ControlsHint.BackgroundTransparency = 0.2
ControlsHint.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ControlsHint.TextColor3 = Color3.fromRGB(255, 255, 255)
ControlsHint.TextScaled = true
ControlsHint.Font = Enum.Font.Gotham
ControlsHint.TextXAlignment = Enum.TextXAlignment.Left
ControlsHint.TextYAlignment = Enum.TextYAlignment.Top
ControlsHint.Text = [[🎮 Управление:
B - Разблокировать FOV
N - Разблокировать FOV + мышку
M - Вернуть всё обратно
V - Включить noclip
G - Включить флай

 by MadFox]] 
ControlsHint.BorderSizePixel = 0
ControlsHint.TextStrokeTransparency = 0.6
ControlsHint.TextStrokeColor3 = Color3.new(0,0,0)

local soundB = Instance.new("Sound", player.PlayerGui)
soundB.SoundId = "rbxassetid://12221967"
soundB.Volume = 1

local soundN = Instance.new("Sound", player.PlayerGui)
soundN.SoundId = "rbxassetid://9118823100"
soundN.Volume = 1

local soundM = Instance.new("Sound", player.PlayerGui)
soundM.SoundId = "rbxassetid://6734419174"
soundM.Volume = 1

local soundV = Instance.new("Sound", player.PlayerGui)
soundV.SoundId = "rbxassetid://12345678"  -- Замените на нужный ID для звука noclip
soundV.Volume = 1

local soundG = Instance.new("Sound", player.PlayerGui)
soundG.SoundId = "rbxassetid://12345678"  -- Замените на нужный ID для звука флая
soundG.Volume = 1

local noclipEnabled = false
local flying = false
local speed = 50
local bodyVelocity = nil

local function showMessage(text, color)
	Label.Text = text
	Label.TextColor3 = color
	Label.BackgroundTransparency = 0.25
	Label.Visible = true

	local fadeIn = TweenService:Create(Label, TweenInfo.new(0.3), {TextTransparency = 0, BackgroundTransparency = 0.25})
	local fadeOut = TweenService:Create(Label, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1})

	fadeIn:Play()
	task.wait(1.5)
	fadeOut:Play()
	task.wait(0.5)
	Label.Visible = false
end

UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.B then
		player.CameraMode = Enum.CameraMode.Classic
		camera.FieldOfView = 90
		UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
		UIS.MouseIconEnabled = false
		soundB:Play()
		showMessage("🎥 FOV разблокирован", Color3.fromRGB(100, 200, 255))

	elseif input.KeyCode == Enum.KeyCode.N then
		player.CameraMode = Enum.CameraMode.Classic
		camera.FieldOfView = 90
		UIS.MouseBehavior = Enum.MouseBehavior.Default
		UIS.MouseIconEnabled = true
		soundN:Play()
		showMessage("🖱️ FOV и мышка разблокированы", Color3.fromRGB(150, 255, 150))

	elseif input.KeyCode == Enum.KeyCode.M then
		player.CameraMode = Enum.CameraMode.LockFirstPerson
		camera.FieldOfView = 70
		UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
		UIS.MouseIconEnabled = false
		soundM:Play()
		showMessage("🔒 Возврат в First Person", Color3.fromRGB(255, 100, 100))

	elseif input.KeyCode == Enum.KeyCode.V then
		noclipEnabled = not noclipEnabled
		if noclipEnabled then
			-- Включаем noclip
			player.Character.Humanoid.PlatformStand = true
			player.Character:WaitForChild("HumanoidRootPart").CanCollide = false
			soundV:Play()
			showMessage("🚀 Noclip включен", Color3.fromRGB(255, 255, 100))
		else
			-- Выключаем noclip
			player.Character.Humanoid.PlatformStand = false
			player.Character:WaitForChild("HumanoidRootPart").CanCollide = true
			soundV:Play()
			showMessage("❌ Noclip выключен", Color3.fromRGB(255, 100, 100))
		end

	elseif input.KeyCode == Enum.KeyCode.G then
		flying = not flying
		if flying then
			-- Включаем флай
			local humanoid = player.Character:WaitForChild("Humanoid")
			bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
			bodyVelocity.Velocity = Vector3.new(0, speed, 0)
			bodyVelocity.Parent = player.Character:WaitForChild("HumanoidRootPart")
			soundG:Play()
			showMessage("✈️ Флай включен", Color3.fromRGB(100, 255, 255))
		else
			-- Выключаем флай
			if bodyVelocity then
				bodyVelocity:Destroy()
				bodyVelocity = nil
			end
			soundG:Play()
			showMessage("❌ Флай выключен", Color3.fromRGB(255, 100, 100))
		end
	end
end)
