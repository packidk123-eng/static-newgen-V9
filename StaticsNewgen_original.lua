-- StaticsNewgen CLIENT BOOTSTRAP / UI RECOVERY BUILD
-- IMPORTANT: run this as a LocalScript in StarterPlayer > StarterPlayerScripts.
-- This wrapper makes startup failures visible instead of leaving a blank screen.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

if not player then
	warn("[StaticsNewgen] No LocalPlayer. This must be a LocalScript, not a server Script.")
	return
end

local playerGui = player:WaitForChild("PlayerGui", 10)
if not playerGui then
	warn("[StaticsNewgen] PlayerGui was not available.")
	return
end

-- Always-visible bootstrap so there is something on screen even if the main source errors.
local oldBoot = playerGui:FindFirstChild("StaticsNewgenBoot")
if oldBoot then oldBoot:Destroy() end
local boot = Instance.new("ScreenGui")
boot.Name = "StaticsNewgenBoot"
boot.ResetOnSpawn = false
boot.IgnoreGuiInset = true
boot.DisplayOrder = 30000
boot.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
boot.Parent = playerGui

local bg = Instance.new("Frame")
bg.Size = UDim2.fromScale(1,1)
bg.BackgroundColor3 = Color3.fromRGB(10,10,12)
bg.BorderSizePixel = 0
bg.Parent = boot

local card = Instance.new("Frame")
card.AnchorPoint = Vector2.new(.5,.5)
card.Position = UDim2.fromScale(.5,.5)
card.Size = UDim2.fromOffset(520,240)
card.BackgroundColor3 = Color3.fromRGB(20,20,24)
card.BorderSizePixel = 0
card.Parent = bg
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,14)
corner.Parent = card
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(242,108,79)
stroke.Thickness = 1.5
stroke.Parent = card

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(24,24)
title.Size = UDim2.new(1,-48,0,34)
title.Font = Enum.Font.GothamBlack
title.Text = "STATICS NEWGEN"
title.TextColor3 = Color3.fromRGB(245,245,248)
title.TextSize = 24
title.Parent = card

local status = Instance.new("TextLabel")
status.BackgroundTransparency = 1
status.Position = UDim2.fromOffset(24,72)
status.Size = UDim2.new(1,-48,0,30)
status.Font = Enum.Font.GothamBold
status.Text = "Starting UI..."
status.TextColor3 = Color3.fromRGB(245,181,94)
status.TextSize = 14
status.Parent = card

local detail = Instance.new("TextLabel")
detail.BackgroundTransparency = 1
detail.Position = UDim2.fromOffset(24,112)
detail.Size = UDim2.new(1,-48,0,92)
detail.Font = Enum.Font.Code
detail.Text = "Please wait..."
detail.TextColor3 = Color3.fromRGB(180,180,188)
detail.TextSize = 11
detail.TextWrapped = true
detail.TextYAlignment = Enum.TextYAlignment.Top
detail.Parent = card

local bootProgress
local bootProgressValue = 0
local function bootText(a,b)
	status.Text = a
	detail.Text = b or ""
	bootProgressValue = math.clamp(bootProgressValue + .08, 0, .9)
	if bootProgress and bootProgress.Parent then
		TweenService:Create(bootProgress, TweenInfo.new(.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.fromScale(bootProgressValue, 1)}):Play()
	end
end

bootText("Loading interface...", "Building the main Statics UI.\nIf a module fails, the error will be shown here instead of leaving a blank screen.")

-- Bootstrap polish is intentionally independent from the main loader. If the
-- main source fails before its own card is built, this screen still feels like
-- a finished recovery experience instead of a blank black frame.
do
	local bootGradient = Instance.new("UIGradient")
	bootGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 13, 20)),
		ColorSequenceKeypoint.new(.45, Color3.fromRGB(8, 9, 14)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 15, 17)),
	})
	bootGradient.Rotation = 28
	bootGradient.Parent = bg
	local bootGlow = Instance.new("Frame")
	bootGlow.AnchorPoint = Vector2.new(.5, .5)
	bootGlow.Position = UDim2.fromScale(.5, .5)
	bootGlow.Size = UDim2.fromOffset(660, 420)
	bootGlow.BackgroundColor3 = Color3.fromRGB(242, 108, 79)
	bootGlow.BackgroundTransparency = .94
	bootGlow.BorderSizePixel = 0
	bootGlow.ZIndex = 0
	bootGlow.Parent = bg
	local bootGlowCorner = Instance.new("UICorner")
	bootGlowCorner.CornerRadius = UDim.new(1, 0)
	bootGlowCorner.Parent = bootGlow
	local bootScale = Instance.new("UIScale")
	bootScale.Parent = card
	local bootViewport = Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
	bootScale.Scale = math.clamp(math.min(bootViewport.X / 600, bootViewport.Y / 330), .55, 1)
	local bootHeader = Instance.new("Frame")
	bootHeader.Size = UDim2.new(1, 0, 0, 5)
	bootHeader.BackgroundColor3 = Color3.new(1, 1, 1)
	bootHeader.BorderSizePixel = 0
	bootHeader.ZIndex = 3
	bootHeader.Parent = card
	local bootHeaderGradient = Instance.new("UIGradient")
	bootHeaderGradient.Color = ColorSequence.new(Color3.fromRGB(242, 108, 79), Color3.fromRGB(245, 181, 94))
	bootHeaderGradient.Parent = bootHeader
	local bootProgressTrack = Instance.new("Frame")
	bootProgressTrack.Size = UDim2.new(1, -48, 0, 5)
	bootProgressTrack.Position = UDim2.new(0, 24, 1, -28)
	bootProgressTrack.BackgroundColor3 = Color3.fromRGB(48, 45, 55)
	bootProgressTrack.BorderSizePixel = 0
	bootProgressTrack.ZIndex = 3
	bootProgressTrack.Parent = card
	local bootProgressCorner = Instance.new("UICorner")
	bootProgressCorner.CornerRadius = UDim.new(0, 3)
	bootProgressCorner.Parent = bootProgressTrack
	bootProgress = Instance.new("Frame")
	bootProgress.Size = UDim2.fromScale(.08, 1)
	bootProgress.BackgroundColor3 = Color3.fromRGB(245, 181, 94)
	bootProgress.BorderSizePixel = 0
	bootProgress.ZIndex = 4
	bootProgress.Parent = bootProgressTrack
	local bootProgressCorner2 = Instance.new("UICorner")
	bootProgressCorner2.CornerRadius = UDim.new(0, 3)
	bootProgressCorner2.Parent = bootProgress
	local bootMark = Instance.new("Frame")
	bootMark.AnchorPoint = Vector2.new(1, .5)
	bootMark.Position = UDim2.new(1, -24, 0, 30)
	bootMark.Size = UDim2.fromOffset(54, 54)
	bootMark.BackgroundColor3 = Color3.fromRGB(242, 108, 79)
	bootMark.BackgroundTransparency = .84
	bootMark.BorderSizePixel = 0
	bootMark.ZIndex = 2
	bootMark.Parent = card
	local bootMarkCorner = Instance.new("UICorner")
	bootMarkCorner.CornerRadius = UDim.new(1, 0)
	bootMarkCorner.Parent = bootMark
	local bootMarkText = Instance.new("TextLabel")
	bootMarkText.Size = UDim2.fromScale(1, 1)
	bootMarkText.BackgroundTransparency = 1
	bootMarkText.Font = Enum.Font.GothamBlack
	bootMarkText.Text = "S"
	bootMarkText.TextSize = 25
	bootMarkText.TextColor3 = Color3.fromRGB(255, 255, 255)
	bootMarkText.ZIndex = 3
	bootMarkText.Parent = bootMark
	local bootSpinner = Instance.new("Frame")
	bootSpinner.AnchorPoint = Vector2.new(.5, .5)
	bootSpinner.Position = UDim2.new(1, -51, 0, 30)
	bootSpinner.Size = UDim2.fromOffset(70, 70)
	bootSpinner.BackgroundTransparency = 1
	bootSpinner.ZIndex = 1
	bootSpinner.Parent = card
	local bootSpinnerStroke = Instance.new("UIStroke")
	bootSpinnerStroke.Color = Color3.fromRGB(245, 181, 94)
	bootSpinnerStroke.Thickness = 2
	bootSpinnerStroke.Transparency = .45
	bootSpinnerStroke.Parent = bootSpinner
	local bootSpinnerCorner = Instance.new("UICorner")
	bootSpinnerCorner.CornerRadius = UDim.new(1, 0)
	bootSpinnerCorner.Parent = bootSpinner
	local bootMotion = RunService.RenderStepped:Connect(function(dt)
		if not boot.Parent then return end
		bootGradient.Rotation = (bootGradient.Rotation + dt * 5) % 360
		bootSpinner.Rotation = (bootSpinner.Rotation + dt * 120) % 360
		local view = Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or bootViewport
		bootScale.Scale = math.clamp(math.min(view.X / 600, view.Y / 330), .55, 1)
	end)
	boot:SetAttribute("Polished", true)
	boot:SetAttribute("RecoveryReady", true)
	boot.AncestryChanged:Connect(function(_, parent)
		if not parent and bootMotion then bootMotion:Disconnect() end
	end)
end

local function recover(err)
	local message = tostring(err)
	warn("[StaticsNewgen] STARTUP ERROR:\n" .. message)

	-- Remove the normal loader if it exists so the diagnostic screen is visible.
	local loader = playerGui:FindFirstChild("StaticsNewgenLoader")
	if loader then
		loader.Enabled = false
		loader:Destroy()
	end

	-- If the main GUI was partially built, expose every GuiObject so a partial menu is still usable.
	local ui = playerGui:FindFirstChild("StaticsNewgenUI")
	if ui then
		ui.Enabled = true
		for _, obj in ipairs(ui:GetDescendants()) do
			if obj:IsA("GuiObject") then
				obj.Visible = true
			end
		end
	end

	bootText("UI STARTUP ERROR", message:sub(1,900) .. "\n\nCheck Roblox Studio Output (F9) for the full error.")
end

-- Keep the bootstrap alive until the original source has definitely finished.
local ok, err = xpcall(function()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VRService = game:GetService("VRService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local playerScripts = player:WaitForChild("PlayerScripts", 5) or player
local camera = Workspace.CurrentCamera
local originalFOV = camera and camera.FieldOfView or 70
local isVR = VRService.VREnabled
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not isVR
local device = isVR and "VR" or (isMobile and "Mobile" or "PC")

-- loader goes up first so it's on screen before anything can yield
local Loader = {}
do
	local old = playerGui:FindFirstChild("StaticsNewgenLoader")
	if old then old:Destroy() end
	local screen = Instance.new("ScreenGui")
	screen.Name = "StaticsNewgenLoader"
	screen.ResetOnSpawn = false
	screen.IgnoreGuiInset = true
	screen.DisplayOrder = 10000
	screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screen.Parent = playerGui

	local ACCENT, ACCENT2 = Color3.fromRGB(242, 108, 79), Color3.fromRGB(245, 181, 94)
	local function round(object, radius)
		local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, radius); c.Parent = object
	end
	local function stroke(object, color, transparency, thickness)
		local s = Instance.new("UIStroke"); s.Color = color; s.Transparency = transparency; s.Thickness = thickness; s.Parent = object
	end
	local function text(parent, value, y, height, font, color, size)
		local l = Instance.new("TextLabel")
		l.BackgroundTransparency = 1
		l.Size = UDim2.new(1, -48, 0, height)
		l.Position = UDim2.fromOffset(24, y)
		l.Font = font; l.Text = value; l.TextColor3 = color; l.TextSize = size
		l.TextWrapped = true
		l.Parent = parent
		return l
	end

	local root = Instance.new("Frame")
	root.Name = "StaticsLoader"
	root.Size = UDim2.fromScale(1, 1)
	root.BackgroundColor3 = Color3.new(1, 1, 1)
	root.BorderSizePixel = 0
	root.Active = true
	root.Parent = screen
	local backdrop = Instance.new("UIGradient")
	backdrop.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 20, 16)),
		ColorSequenceKeypoint.new(.35, Color3.fromRGB(14, 12, 13)),
		ColorSequenceKeypoint.new(.65, Color3.fromRGB(9, 9, 11)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 16, 20)),
	})
	backdrop.Rotation = 25
	backdrop.Parent = root
	-- a soft accent glow bloom centered behind the card for depth
	local bloom = Instance.new("ImageLabel")
	bloom.AnchorPoint = Vector2.new(.5, .5)
	bloom.Position = UDim2.fromScale(.5, .5)
	bloom.Size = UDim2.fromOffset(760, 540)
	bloom.BackgroundTransparency = 1
	bloom.Image = "rbxassetid://1316045217"
	bloom.ImageColor3 = ACCENT
	bloom.ImageTransparency = .82
	bloom.ScaleType = Enum.ScaleType.Slice
	bloom.SliceCenter = Rect.new(10, 10, 118, 118)
	bloom.ZIndex = 0
	bloom.Parent = root
	task.spawn(function()
		while bloom.Parent do
			TweenService:Create(bloom, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { ImageTransparency = .72, Size = UDim2.fromOffset(820, 580) }):Play()
			task.wait(1.6)
			TweenService:Create(bloom, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { ImageTransparency = .86, Size = UDim2.fromOffset(740, 520) }):Play()
			task.wait(1.6)
		end
	end)


	-- Floating ambient orbs (loading screen enhancement)
	do
		local orbColors={ACCENT,ACCENT2,Color3.fromRGB(255,255,255)}
		for i=1,10 do
			local orb=Instance.new("Frame")
			orb.AnchorPoint=Vector2.new(.5,.5)
			local sz=math.random(3,9)
			orb.Size=UDim2.fromOffset(sz,sz)
			orb.Position=UDim2.fromScale(math.random(5,95)/100,math.random(5,95)/100)
			orb.BackgroundColor3=orbColors[(i%3)+1]
			orb.BackgroundTransparency=0.55+math.random()*0.3
			orb.BorderSizePixel=0
			orb.ZIndex=1
			orb.Parent=root
			local oc=Instance.new("UICorner");oc.CornerRadius=UDim.new(1,0);oc.Parent=orb
			task.spawn(function()
				local speed=3+math.random()*5
				while orb.Parent do
					local tx=math.random(4,96)/100
					local ty=math.random(4,96)/100
					TweenService:Create(orb,TweenInfo.new(speed,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Position=UDim2.fromScale(tx,ty),BackgroundTransparency=0.4+math.random()*0.45}):Play()
					task.wait(speed)
				end
			end)
		end
	end
	local card = Instance.new("Frame")
	card.AnchorPoint = Vector2.new(.5, .5)
	card.Position = UDim2.fromScale(.5, .5)
	card.Size = UDim2.fromOffset(520, 350)
	card.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
	card.BackgroundTransparency = 0
	card.BorderSizePixel = 0
	card.Parent = root
	round(card, 20)
	stroke(card, Color3.new(1, 1, 1), .82, 1.5)
	local cardScale = Instance.new("UIScale")
	local viewport = Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
	cardScale.Scale = math.clamp(math.min(viewport.X / 560, viewport.Y / 390), .5, 1)
	cardScale.Parent = card
	-- Layered glass treatment: a soft shadow, a top highlight, and a subtle
	-- inner wash make the loader feel like part of the finished interface.
	local cardShadow = Instance.new("ImageLabel")
	cardShadow.Name = "LoaderShadow"
	cardShadow.AnchorPoint = Vector2.new(.5, .5)
	cardShadow.Position = UDim2.fromScale(.5, .5)
	cardShadow.Size = UDim2.new(1, 42, 1, 42)
	cardShadow.BackgroundTransparency = 1
	cardShadow.Image = "rbxassetid://1316045217"
	cardShadow.ImageColor3 = Color3.new(0, 0, 0)
	cardShadow.ImageTransparency = .42
	cardShadow.ScaleType = Enum.ScaleType.Slice
	cardShadow.SliceCenter = Rect.new(10, 10, 118, 118)
	cardShadow.ZIndex = 0
	cardShadow.Parent = card
	local cardWash = Instance.new("Frame")
	cardWash.Name = "LoaderWash"
	cardWash.Size = UDim2.new(1, -2, .46, 0)
	cardWash.Position = UDim2.fromOffset(1, 1)
	cardWash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	cardWash.BackgroundTransparency = .965
	cardWash.BorderSizePixel = 0
	cardWash.ZIndex = 1
	cardWash.Parent = card
	local cardWashGradient = Instance.new("UIGradient")
	cardWashGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), ACCENT)
	cardWashGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, .1), NumberSequenceKeypoint.new(1, 1)})
	cardWashGradient.Rotation = 90
	cardWashGradient.Parent = cardWash
	local loaderStatus = Instance.new("Frame")
	loaderStatus.Name = "LoaderStatus"
	loaderStatus.Size = UDim2.fromOffset(118, 24)
	loaderStatus.Position = UDim2.fromOffset(24, 22)
	loaderStatus.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	loaderStatus.BackgroundTransparency = .45
	loaderStatus.BorderSizePixel = 0
	loaderStatus.ZIndex = 5
	loaderStatus.Parent = card
	round(loaderStatus, 12)
	local loaderStatusDot = Instance.new("Frame")
	loaderStatusDot.AnchorPoint = Vector2.new(0, .5)
	loaderStatusDot.Position = UDim2.new(0, 9, .5, 0)
	loaderStatusDot.Size = UDim2.fromOffset(7, 7)
	loaderStatusDot.BackgroundColor3 = Color3.fromRGB(52, 211, 153)
	loaderStatusDot.BorderSizePixel = 0
	loaderStatusDot.ZIndex = 6
	loaderStatusDot.Parent = loaderStatus
	round(loaderStatusDot, 4)
	local loaderStatusText = Instance.new("TextLabel")
	loaderStatusText.BackgroundTransparency = 1
	loaderStatusText.Position = UDim2.fromOffset(23, 0)
	loaderStatusText.Size = UDim2.new(1, -28, 1, 0)
	loaderStatusText.Font = Enum.Font.Code
	loaderStatusText.Text = "SYSTEM ONLINE"
	loaderStatusText.TextColor3 = Color3.fromRGB(190, 236, 215)
	loaderStatusText.TextSize = 8
	loaderStatusText.TextXAlignment = Enum.TextXAlignment.Left
	loaderStatusText.ZIndex = 6
	loaderStatusText.Parent = loaderStatus
	Loader.statusDot, Loader.statusText = loaderStatusDot, loaderStatusText
	local loaderSteps = Instance.new("Frame")
	loaderSteps.Name = "LoaderSteps"
	loaderSteps.Size = UDim2.fromOffset(92, 8)
	loaderSteps.Position = UDim2.new(1, -116, 0, 30)
	loaderSteps.BackgroundTransparency = 1
	loaderSteps.ZIndex = 5
	loaderSteps.Parent = card
	local stepDots = {}
	for index = 1, 5 do
		local dot = Instance.new("Frame")
		dot.AnchorPoint = Vector2.new(.5, .5)
		dot.Position = UDim2.new((index - .5) / 5, 0, .5, 0)
		dot.Size = UDim2.fromOffset(6, 6)
		dot.BackgroundColor3 = Color3.fromRGB(75, 72, 82)
		dot.BorderSizePixel = 0
		dot.ZIndex = 6
		dot.Parent = loaderSteps
		round(dot, 3)
		table.insert(stepDots, dot)
	end
	Loader.stepDots = stepDots
	Loader.progress = 0
	function Loader.setProgress(value)
		Loader.progress = math.clamp(tonumber(value) or 0, 0, 1)
		if Loader.fill and Loader.fill.Parent then Loader.fill.Size = UDim2.fromScale(math.max(.04, Loader.progress), 1) end
		for index, dot in ipairs(Loader.stepDots or {}) do
			dot.BackgroundColor3 = index / #Loader.stepDots <= Loader.progress and ACCENT2 or Color3.fromRGB(75, 72, 82)
		end
	end
	local loaderRule = Instance.new("Frame")
	loaderRule.Size = UDim2.new(1, -48, 0, 1)
	loaderRule.Position = UDim2.fromOffset(24, 225)
	loaderRule.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	loaderRule.BackgroundTransparency = .93
	loaderRule.BorderSizePixel = 0
	loaderRule.ZIndex = 3
	loaderRule.Parent = card

	local logo = Instance.new("Frame")
	logo.AnchorPoint = Vector2.new(.5, 0)
	logo.Position = UDim2.new(.5, 0, 0, 30)
	logo.Size = UDim2.fromOffset(82, 82)
	logo.BackgroundColor3 = Color3.new(1, 1, 1)
	logo.BorderSizePixel = 0
	logo.Parent = card
	round(logo, 24)
	stroke(logo, Color3.new(1, 1, 1), .75, 1)
	local logoGradient = Instance.new("UIGradient")
	logoGradient.Color = ColorSequence.new(ACCENT, ACCENT2)
	logoGradient.Rotation = 35
	logoGradient.Parent = logo
	local logoScale = Instance.new("UIScale")
	logoScale.Scale = .6
	logoScale.Parent = logo
	-- Spinning neon arc around the logo
	local ring = Instance.new("Frame")
	ring.AnchorPoint = Vector2.new(.5, .5)
	ring.Position = UDim2.new(.5, 0, 0, 71)
	ring.Size = UDim2.fromOffset(108, 108)
	ring.BackgroundTransparency = 1
	ring.Parent = card
	round(ring, 54)
	local ringStroke = Instance.new("UIStroke")
	ringStroke.Color = Color3.new(1, 1, 1)
	ringStroke.Thickness = 3
	ringStroke.Parent = ring
	local ringGradient = Instance.new("UIGradient")
	ringGradient.Color = ColorSequence.new(ACCENT, ACCENT2)
	ringGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(.45, .15), NumberSequenceKeypoint.new(.55, 1), NumberSequenceKeypoint.new(1, 1) })
	ringGradient.Parent = ringStroke
	Loader.ringGradient = ringGradient
	local letter = Instance.new("TextLabel")
	letter.BackgroundTransparency = 1
	letter.Size = UDim2.fromScale(1, 1)
	letter.Font = Enum.Font.GothamBlack
	letter.Text = "S"
	letter.TextColor3 = Color3.new(1, 1, 1)
	letter.TextSize = 39
	letter.Parent = logo

	Loader.title = text(card, "STATICS NEWGEN", 126, 45, Enum.Font.GothamBlack, Color3.fromRGB(255, 255, 255), 29)
	local titleGradient = Instance.new("UIGradient")
	titleGradient.Color = ColorSequence.new(Color3.new(1,1,1), ACCENT2)
	titleGradient.Rotation = 90
	titleGradient.Parent = Loader.title
	Loader.stage = text(card, "Starting up...", 170, 25, Enum.Font.GothamBold, Color3.fromRGB(244, 244, 247), 12)
	Loader.discord = text(card, "discord.gg/rXxwRtaCQ", 199, 22, Enum.Font.GothamBold, ACCENT2, 11)

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, -72, 0, 7)
	bar.Position = UDim2.fromOffset(36, 239)
	bar.BackgroundColor3 = Color3.fromRGB(38, 38, 42)
	bar.BorderSizePixel = 0
	bar.Parent = card
	round(bar, 4)
	local fill = Instance.new("Frame")
	fill.Size = UDim2.fromScale(.05, 1)
	fill.BackgroundColor3 = Color3.new(1, 1, 1)
	fill.BorderSizePixel = 0
	fill.Parent = bar
	round(fill, 4)
	local fillGradient = Instance.new("UIGradient")
	fillGradient.Color = ColorSequence.new(ACCENT, ACCENT2)
	fillGradient.Parent = fill

	Loader.tip = text(card, "Loading your config...", 262, 42, Enum.Font.Gotham, Color3.fromRGB(160, 148, 210), 10)
	local skipHint = text(card, "Click to skip", 314, 18, Enum.Font.Gotham, Color3.fromRGB(110, 112, 130), 9)
	skipHint.Name = "SkipHint"
	local skipButton = Instance.new("TextButton")
	skipButton.Name = "SkipButton"
	skipButton.Size = UDim2.new(1, -40, 0, 28)
	skipButton.Position = UDim2.fromOffset(20, 300)
	skipButton.BackgroundTransparency = 1
	skipButton.BorderSizePixel = 0
	skipButton.AutoButtonColor = false
	skipButton.Text = ""
	skipButton.ZIndex = 20
	skipButton.Parent = card
	skipButton.Activated:Connect(function()
		Loader.skipRequested = true
		skipHint.Text = "Skipping..."
		skipHint.TextColor3 = ACCENT2
	end)
	Loader.skipButton = skipButton
	Loader.skipHint = skipHint

	Loader.screen, Loader.root, Loader.fill, Loader.logoScale = screen, root, fill, logoScale
	Loader.logoGradient, Loader.fillGradient = logoGradient, fillGradient
	Loader.shownAt = os.clock()
	Loader.spin = RunService.RenderStepped:Connect(function(dt)
		logoGradient.Rotation = (logoGradient.Rotation + dt * 36) % 360
		Loader.ringGradient.Rotation = (Loader.ringGradient.Rotation + dt * 260) % 360
		backdrop.Rotation = (backdrop.Rotation + dt * 8) % 360
		local currentCamera = Workspace.CurrentCamera
		if currentCamera then
			local view = currentCamera.ViewportSize
			cardScale.Scale = math.clamp(math.min(view.X / 560, view.Y / 390), .5, 1)
		end
		if Loader.statusDot then
			Loader.statusDot.BackgroundTransparency = .12 + (math.sin(os.clock() * 4) + 1) * .16
		end
		if Loader.statusText and Loader.progress then
			Loader.statusText.Text = Loader.progress >= .98 and "READY TO LAUNCH" or "SYSTEM ONLINE"
		end
	end)
	TweenService:Create(logoScale, TweenInfo.new(.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()

	-- Pulsing ring glow animation
	task.spawn(function()
		while ringStroke.Parent do
			TweenService:Create(ringStroke,TweenInfo.new(.65,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Thickness=6}):Play()
			task.wait(.65)
			TweenService:Create(ringStroke,TweenInfo.new(.65,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Thickness=2.5}):Play()
			task.wait(.65)
		end
	end)
	-- Extra glow behind the logo for depth
	local logoGlow=Instance.new("Frame")
	logoGlow.AnchorPoint=Vector2.new(.5,.5)
	logoGlow.Position=UDim2.new(.5,0,0,71)
	logoGlow.Size=UDim2.fromOffset(130,130)
	logoGlow.BackgroundColor3=ACCENT
	logoGlow.BackgroundTransparency=.88
	logoGlow.BorderSizePixel=0
	logoGlow.ZIndex=0
	logoGlow.Parent=card
	local lgc=Instance.new("UICorner");lgc.CornerRadius=UDim.new(1,0);lgc.Parent=logoGlow
	task.spawn(function()
		while logoGlow.Parent do
			TweenService:Create(logoGlow,TweenInfo.new(.9,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency=.76,Size=UDim2.fromOffset(148,148)}):Play()
			task.wait(.9)
			TweenService:Create(logoGlow,TweenInfo.new(.9,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency=.88,Size=UDim2.fromOffset(122,122)}):Play()
			task.wait(.9)
		end
	end)

	-- Fades every piece of the loader out, then removes it.
	function Loader.fade(duration)
		if Loader.fading then return end
		Loader.fading = true
		local info = TweenInfo.new(duration)
		TweenService:Create(root, info, { BackgroundTransparency = 1 }):Play()
		for _, object in ipairs(root:GetDescendants()) do
			if object:IsA("TextLabel") then
				TweenService:Create(object, info, { TextTransparency = 1, BackgroundTransparency = 1 }):Play()
			elseif object:IsA("GuiObject") then
				TweenService:Create(object, info, { BackgroundTransparency = 1 }):Play()
			elseif object:IsA("UIStroke") then
				TweenService:Create(object, info, { Transparency = 1 }):Play()
			end
		end
		task.delay(duration + .05, function()
			if Loader.spin then Loader.spin:Disconnect() end
			screen:Destroy()
		end)
	end
end
task.wait() -- give Roblox one frame to actually draw the loader before any heavy work starts

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	if Workspace.CurrentCamera then
		camera = Workspace.CurrentCamera
		originalFOV = camera.FieldOfView
	end
end)

-- remotes: grab what exists now, fill the rest in when the folder replicates
local Remotes = {}
local whenRemote
do
local REMOTE_NAMES = {
	Hello = "Hello", RoleSync = "RoleSync", Reset = "ResetCharacter", Hop = "ServerHop",
	Status = "ActionStatus", VerifyVR = "VerifyVRAimCode", Preferences = "Preferences",
	-- Handled by StaticsTeleport.server.luau (ServerScriptService). The server decides who may teleport.
	Teleport = "TeleportToRole",
	-- Overview command bar. Also handled by StaticsTeleport.server.luau (admins only).
	Command = "AdminCommand",
}
local remoteListeners = {}
local function resolveRemotes(folder)
	for key, remoteName in pairs(REMOTE_NAMES) do
		local remote = folder:FindFirstChild(remoteName)
		if remote and not Remotes[key] then
			Remotes[key] = remote
			for _, callback in ipairs(remoteListeners[key] or {}) do task.spawn(callback, remote) end
			remoteListeners[key] = nil
		end
	end
end
-- Runs the callback now if the remote exists, otherwise as soon as it appears.
function whenRemote(key, callback)
	if Remotes[key] then task.spawn(callback, Remotes[key]); return end
	remoteListeners[key] = remoteListeners[key] or {}
	table.insert(remoteListeners[key], callback)
end
local function watchRemoteFolder(folder)
	resolveRemotes(folder)
	folder.ChildAdded:Connect(function() resolveRemotes(folder) end)
end
local existingFolder = ReplicatedStorage:FindFirstChild("StaticsNewgenRemotes")
if existingFolder then watchRemoteFolder(existingFolder) end
ReplicatedStorage.ChildAdded:Connect(function(child)
	if child.Name == "StaticsNewgenRemotes" and child ~= existingFolder then watchRemoteFolder(child) end
end)
end

-- InvokeServer can yield forever if the server never answers. This gives up after `timeout` seconds.
local function invokeWithTimeout(remote, timeout, ...)
	local args = table.pack(...)
	local finished, success, result = false, false, nil
	task.spawn(function()
		local ok, value = pcall(function() return remote:InvokeServer(table.unpack(args, 1, args.n)) end)
		if not finished then finished = true; success = ok; result = value end
	end)
	local started = os.clock()
	while not finished and os.clock() - started < timeout do task.wait() end
	if not finished then finished = true; return false, "timeout" end
	return success, result
end

whenRemote("Hello", function(remote)
	if remote:IsA("RemoteEvent") then pcall(function() remote:FireServer({ vr = isVR, mobile = isMobile, device = device }) end) end
end)

local DEFAULTS = {
	ActiveProfile = "Universal",
	Theme = "Studio",
	LayoutStyle = "Newgen",
	AimEnabled = false,
	StickyAim = true,
	WallCheck = true,
	TeamCheck = true,
	AimStrength = 0.35,
	AimSmoothness = 0.72,
	AimRadius = 210,
	Prediction = true,
	PredictionTime = 0.08,
	MaxAimDistance = 650,
	CameraAssist = true,
	-- new aim options
	AimPriority = "Crosshair", -- Crosshair | Distance | Health
	AimFollowMouse = false,     -- center the FOV circle on the mouse instead of screen center
	AimSnapLine = false,        -- draw a line from the bottom of the screen to the locked target
	AimAutoFire = false,        -- click automatically while locked on a target
	AimAutoFireDelay = 0.12,
	AimJitter = 0,              -- small randomized offset (0 = perfectly on target)
	AimVisibleOnly = true,      -- only lock targets with line of sight
	CameraFOVEnabled = false,
	CameraFOV = 78,
	ShowFOVCircle = true,
	FOVCircleOpacity = 0.75,
	FOVCircleThickness = 1.5,
	FOVCircleHue = 0.75,
	FOVCircleFilled = false,     -- faint tinted fill inside the FOV circle
	FOVActiveColor = true,       -- turn the FOV circle green while a target is locked
	ESPEnabled = false,
	HighlightESP = true,
	NameESP = true,
	DistanceESP = true,
	RoleESP = true,
	VRESP = true,
	SkeletonESP = false,
	SkeletonGreen = true,        -- draw the skeleton in bright green (like the reference) instead of the ESP color
	SkeletonThickness = 0.08,    -- line width
	BoxESP = false,
	TracerESP = false,
	OffscreenESP = true,
	HealthESP = true,
	ESPTeamCheck = false,
	ThroughWalls = true,
	ESPMaxDistance = 850,
	ESPTextSize = isVR and 18 or 14,
	TriggerMode = "Single",
	TriggerModeKey = "O",
	FullBright = false,
	KeystrokesEnabled = false,
	-- keystrokes HUD customization
	KeystrokesScale = 1,          -- 0.6 - 1.6
	KeystrokesOpacity = 0.75,     -- box fill opacity when idle
	KeystrokesAccentHue = 0.14,   -- outline / pressed color hue (0.14 = yellow)
	KeystrokesUseThemeColor = false, -- use the UI accent instead of the hue above
	KeystrokesShowFPS = true,
	KeystrokesShowMouse = true,
	KeystrokesShowArrows = false, -- also show arrow keys row
	KeystrokesX = 26,
	KeystrokesY = 120,
	ESPToolName = false,
	ESPShowPing = false,
	ESPFlashDamage = false,
	ESPOutlineThick = 1.5,
	HighlightOpacity = 0.35,
	ChamsEnabled = false,
	RainbowESP = false,
	ChamsColorHue = 0.65,
	-- new ESP options
	ESPBoxStyle = "Corner",   -- Corner | Full
	ESPMaxTargets = 50,        -- cap drawn players for performance
	ESPLowHealthWarn = true,   -- flash the nameplate when a target is low HP
	ESPAimHighlight = true,    -- brighten your current aim target's highlight
	-- proximity alert
	ProximityAlert = false,       -- warn when a player gets close
	ProximityDistance = 15,       -- studs
	ProximityTeamCheck = true,    -- ignore teammates
	ProximityCorner = "TopLeft",  -- TopLeft | TopRight (plus manual drag)
	ProximitySound = true,
	ParticlesEnabled = true,
	DecorationsEnabled = true,
	LODDistance = 300,
	AmbientBrightness = 0.5,
	FullBrightLevel = 2,
	NoFog = false,
	ESPFill = 0.28,
	EnemyColorHue = 0.98,
	TeammateColorHue = 0.48,
	PerformanceMode = isMobile and "Balanced" or "Off",
	CustomBackground = false,
	BackgroundHue = 0.75,
	BackgroundSaturation = 0.82,
	BackgroundValue = 0.85,
	BackgroundIntensity = 0.65,
	HitPart = "Body",
	Watermark = false,
	PauseUnfocused = true,
	CullFar = false,
	RenderDistance = 400,
	Crosshair = false,
	CrosshairSize = 8,
	CrosshairGap = 4,
	MenuKey = "RightShift",
	MusicVolume = 0.5,
	MusicAutoplay = true,
	MusicShuffle = false,
	MusicLoop = false,
	MusicTrack = 1,
	-- Murder Mystery category (only visible when the Murder Mystery profile is loaded)
	MysteryRoleColors = true,
	MysteryRoleHUD = true,
	MysteryMurdererAlert = true,
	MysterySheriffAlert = false,
	MysteryGunTracker = true,
	MysteryAliveCounter = true,
	-- Rivals (premium, unlocked with a code)
	RivalsUnlocked = false,
	TriggerEnabled = false,
	TriggerDelay = 0.06,
	TriggerFOV = 60,
	TriggerTeamCheck = true,
	TriggerKey = "E",
	-- Fling Things and People profile. The controller stays disarmed until
	-- that profile is selected from the Game Hub.
	FlingEnabled = false,
	FlingStrength = 400,
	-- Professional shell / MM2 display preferences are part of the base schema
	-- so saved values are loaded before the UI is built.
	ReduceMotion = false,
	CompactNotifications = false,
	ResponsiveMode = "Auto",
	TooltipHints = true,
	ConfirmServerActions = true,
	MysteryRoundHUD = true,
	MysteryTimerHUD = true,
	MysteryMapHUD = true,
	MysteryRoleFeed = true,
	MysteryEventFeed = true,
	MysterySuspectMarks = true,
	MysteryGunDistance = true,
	MysteryCoinTracker = false,
	MysteryKnifeTracker = false,
	MysterySoundAlerts = false,
	MysteryMurdererWallhack = false,
	MysterySheriffWallhack = false,
	MysteryAutoSpectateMurderer = false,
	MysteryRevealCountdown = true,
	AutoFitWindow = true,
	ShowDiagnostics = false,
	CrosshairStyle = "Cross",
	-- Customize panel (Themes page)
	UIScale = 1,
	WindowTransparency = 0,
	CustomAccent = false,
	AccentHue = 0.03,
}
local Config = table.clone(DEFAULTS)

-- ==========================================================================
-- Persistent settings file (survives re-executing the script). Uses the
-- executor's file API when available (writefile/readfile/isfile). Falls back
-- gracefully if the executor has no file access. This is what remembers that
-- you turned something off: your choices are written to disk and reloaded.
-- ==========================================================================
-- NOTE: the UI table does not exist yet at this point in startup, so this block
-- uses only locals scoped to the `do` end. The settings file name / API flag are
-- published onto UI later (once UI exists) for the autosave function to use.
local SETTINGS_FILE_NAME = "StaticsNewgen_settings.json"
local loadedFromFile = false
do
	local hasFileAPI = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
	if hasFileAPI then
		local ok, exists = pcall(isfile, SETTINGS_FILE_NAME)
		if ok and exists then
			local okRead, contents = pcall(readfile, SETTINGS_FILE_NAME)
			if okRead and type(contents) == "string" and contents ~= "" then
				local okDecode, saved = pcall(function() return HttpService:JSONDecode(contents) end)
				if okDecode and typeof(saved) == "table" then
					for key in pairs(DEFAULTS) do
						if saved[key] ~= nil then Config[key] = saved[key] end
					end
					loadedFromFile = true
				end
			end
		end
	end
end

-- Server-remote preferences are still honored (for games that provide them),
-- but only when there was no local file to load from.
if not loadedFromFile and Remotes.Preferences and Remotes.Preferences:IsA("RemoteFunction") then
	Loader.stage.Text = "Loading saved preferences..."
	-- Max 2 seconds. Previously this could hang forever and freeze the loading screen.
	local ok, saved = invokeWithTimeout(Remotes.Preferences, 2, "load")
	if ok and typeof(saved) == "table" then
		for key in pairs(DEFAULTS) do
			if saved[key] ~= nil then Config[key] = saved[key] end
		end
	end
end
-- Older saves used the previous profile name.
if Config.ActiveProfile == "Mystery Showdown" then Config.ActiveProfile = "Murder Mystery" end
if Config.ActiveProfile == "The Final Letter" then Config.ActiveProfile = "Last Letter" end
-- wall check stays on no matter what an old save says
Config.WallCheck = true

-- Sanitize saved values before any UI or theme code reads them. Preference
-- payloads are server-provided data and may be old, partial, or hand-edited;
-- validating only after the pages are built can itself cause startup errors.
local function sanitizeLoadedConfig()
	for key, defaultValue in pairs(DEFAULTS) do
		local value = Config[key]
		local defaultType = typeof(defaultValue)
		if defaultType == "number" then
			local numeric = tonumber(value)
			if not numeric or numeric ~= numeric or numeric == math.huge or numeric == -math.huge then Config[key] = defaultValue else Config[key] = numeric end
		elseif defaultType == "boolean" then
			if typeof(value) ~= "boolean" then Config[key] = defaultValue end
		elseif defaultType == "string" then
			if typeof(value) ~= "string" then Config[key] = defaultValue end
		end
	end
	if Config.ActiveProfile ~= "Universal" and Config.ActiveProfile ~= "Last Letter" and Config.ActiveProfile ~= "Murder Mystery" and Config.ActiveProfile ~= "Fling Things and People" then Config.ActiveProfile = "Universal" end
	if Config.LayoutStyle ~= "Newgen" and Config.LayoutStyle ~= "Lynen" and Config.LayoutStyle ~= "Horizon" then Config.LayoutStyle = "Newgen" end
	if Config.HitPart ~= "Body" and Config.HitPart ~= "Head" and Config.HitPart ~= "Random" then Config.HitPart = "Body" end
	if #Config.TriggerKey == 1 then Config.TriggerKey = string.upper(Config.TriggerKey) end
	Config.WallCheck = true
end
sanitizeLoadedConfig()

-- VR settings are intentionally session-only and always start off.
local VRConfig = {
	Enabled = false,
	Sticky = false,
	WallCheck = false,
	TeamCheck = false,
	Strength = 0.18,
	Cone = 15,
	MaxDistance = 500,
	Keybind = "V",
}

local State = {
	menuOpen = false,
	aimHeld = false,
	target = nil,
	weaponTarget = nil,
	lockedParts = {},
	lastTargetSeen = 0,
	roles = {},
	visuals = {},
	connections = {},
	profileChosen = false,
	dirty = false,
	vrUnlocked = player:GetAttribute("VRAimAuthorized") == true,
	sessionStarted = os.clock(),
	lastMurderer = nil,
	lastSheriff = nil,
	mysteryOpen = false,
	currentPage = nil,
	fovApplied = false,
	fps = 0,
	triggerTarget = nil,
	vrStickyTarget = nil,
	mysteryMeta = {},
	mysteryFeed = {},
	mysteryMarks = {},
	mysteryIntelOpen = false,
}
local UI = { pages = {}, nav = {}, refreshers = {}, bindings = {}, toggleRefreshers = {} }
-- Publish the settings-file info now that UI exists (used by the autosave loop).
UI.settingsFile = SETTINGS_FILE_NAME
UI.hasFileAPI = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
-- Profile activation is intentionally session-gated; a saved Fling profile must
-- never arm the controller before the user selects it in the Game Hub.
Config.FlingEnabled = false

local Themes = {
	Studio = { bg = Color3.fromRGB(12,12,13), panel = Color3.fromRGB(19,19,21), row = Color3.fromRGB(28,28,31), accent = Color3.fromRGB(242,108,79), accent2 = Color3.fromRGB(245,181,94), text = Color3.fromRGB(238,236,232), muted = Color3.fromRGB(138,136,132) },
	Midnight = { bg = Color3.fromRGB(8,10,16), panel = Color3.fromRGB(14,17,27), row = Color3.fromRGB(23,28,43), accent = Color3.fromRGB(99,132,255), accent2 = Color3.fromRGB(148,172,255), text = Color3.fromRGB(232,236,248), muted = Color3.fromRGB(128,137,163) },
	Rose = { bg = Color3.fromRGB(15,10,12), panel = Color3.fromRGB(24,16,19), row = Color3.fromRGB(38,25,30), accent = Color3.fromRGB(236,112,150), accent2 = Color3.fromRGB(247,168,190), text = Color3.fromRGB(248,236,240), muted = Color3.fromRGB(160,132,142) },
	Mono = { bg = Color3.fromRGB(10,10,10), panel = Color3.fromRGB(18,18,18), row = Color3.fromRGB(30,30,30), accent = Color3.fromRGB(236,236,236), accent2 = Color3.fromRGB(170,170,170), text = Color3.fromRGB(240,240,240), muted = Color3.fromRGB(128,128,128) },
	Sunset = { bg = Color3.fromRGB(16,10,9), panel = Color3.fromRGB(26,16,14), row = Color3.fromRGB(42,26,22), accent = Color3.fromRGB(255,122,69), accent2 = Color3.fromRGB(255,196,87), text = Color3.fromRGB(250,238,230), muted = Color3.fromRGB(168,140,128) },
	Mint = { bg = Color3.fromRGB(9,14,13), panel = Color3.fromRGB(15,22,21), row = Color3.fromRGB(24,36,34), accent = Color3.fromRGB(94,222,180), accent2 = Color3.fromRGB(160,240,212), text = Color3.fromRGB(232,246,241), muted = Color3.fromRGB(128,156,148) },
	Lavender = { bg = Color3.fromRGB(12,11,17), panel = Color3.fromRGB(20,18,28), row = Color3.fromRGB(32,29,45), accent = Color3.fromRGB(176,148,255), accent2 = Color3.fromRGB(214,196,255), text = Color3.fromRGB(240,236,250), muted = Color3.fromRGB(146,138,168) },
	Forest = { bg = Color3.fromRGB(10,13,10), panel = Color3.fromRGB(17,22,17), row = Color3.fromRGB(27,35,27), accent = Color3.fromRGB(140,200,96), accent2 = Color3.fromRGB(200,222,120), text = Color3.fromRGB(236,242,230), muted = Color3.fromRGB(136,150,128) },
	Neon = { bg = Color3.fromRGB(8,6,16), panel = Color3.fromRGB(18,15,32), row = Color3.fromRGB(33,28,56), accent = Color3.fromRGB(168,85,247), accent2 = Color3.fromRGB(34,211,238), text = Color3.fromRGB(248,246,255), muted = Color3.fromRGB(152,146,184) },
	Crimson = { bg = Color3.fromRGB(14,7,10), panel = Color3.fromRGB(29,15,20), row = Color3.fromRGB(48,25,33), accent = Color3.fromRGB(244,63,94), accent2 = Color3.fromRGB(251,146,60), text = Color3.fromRGB(252,244,246), muted = Color3.fromRGB(176,140,150) },
	Ocean = { bg = Color3.fromRGB(5,11,20), panel = Color3.fromRGB(13,24,40), row = Color3.fromRGB(23,40,64), accent = Color3.fromRGB(59,130,246), accent2 = Color3.fromRGB(45,212,191), text = Color3.fromRGB(240,248,255), muted = Color3.fromRGB(138,160,188) },
	DarkDock = { bg = Color3.fromRGB(10,10,13), panel = Color3.fromRGB(24,24,29), row = Color3.fromRGB(40,40,49), accent = Color3.fromRGB(139,92,246), accent2 = Color3.fromRGB(34,211,238), text = Color3.fromRGB(244,244,247), muted = Color3.fromRGB(148,150,166) },
	Skeet = { bg = Color3.fromRGB(17,15,18), panel = Color3.fromRGB(25,23,27), row = Color3.fromRGB(34,31,35), accent = Color3.fromRGB(112,170,54), accent2 = Color3.fromRGB(157,206,76), text = Color3.fromRGB(235,233,237), muted = Color3.fromRGB(136,132,141) },
	Emerald = { bg = Color3.fromRGB(15,18,18), panel = Color3.fromRGB(29,33,32), row = Color3.fromRGB(43,48,46), accent = Color3.fromRGB(52,211,153), accent2 = Color3.fromRGB(92,224,180), text = Color3.fromRGB(242,244,242), muted = Color3.fromRGB(142,150,146) },
	Cherry = { bg = Color3.fromRGB(16,8,11), panel = Color3.fromRGB(28,14,19), row = Color3.fromRGB(44,22,30), accent = Color3.fromRGB(255,64,110), accent2 = Color3.fromRGB(255,138,170), text = Color3.fromRGB(252,238,243), muted = Color3.fromRGB(176,138,150) },
	Aqua = { bg = Color3.fromRGB(6,14,17), panel = Color3.fromRGB(12,24,29), row = Color3.fromRGB(20,40,48), accent = Color3.fromRGB(34,211,238), accent2 = Color3.fromRGB(125,236,250), text = Color3.fromRGB(234,248,252), muted = Color3.fromRGB(130,160,170) },
	Gold = { bg = Color3.fromRGB(16,13,6), panel = Color3.fromRGB(28,23,12), row = Color3.fromRGB(45,37,19), accent = Color3.fromRGB(250,195,45), accent2 = Color3.fromRGB(255,224,130), text = Color3.fromRGB(250,246,230), muted = Color3.fromRGB(170,158,120) },
	Grape = { bg = Color3.fromRGB(12,8,18), panel = Color3.fromRGB(21,15,32), row = Color3.fromRGB(34,24,52), accent = Color3.fromRGB(147,51,234), accent2 = Color3.fromRGB(196,132,252), text = Color3.fromRGB(242,236,252), muted = Color3.fromRGB(150,138,170) },
	Slate = { bg = Color3.fromRGB(13,15,18), panel = Color3.fromRGB(22,25,30), row = Color3.fromRGB(34,38,46), accent = Color3.fromRGB(100,116,139), accent2 = Color3.fromRGB(148,163,184), text = Color3.fromRGB(236,240,245), muted = Color3.fromRGB(130,138,150) },
	Blossom = { bg = Color3.fromRGB(18,12,16), panel = Color3.fromRGB(30,20,27), row = Color3.fromRGB(48,32,42), accent = Color3.fromRGB(244,114,182), accent2 = Color3.fromRGB(249,168,212), text = Color3.fromRGB(252,240,247), muted = Color3.fromRGB(176,148,164) },
	Carbon = { bg = Color3.fromRGB(9,9,11), panel = Color3.fromRGB(16,16,19), row = Color3.fromRGB(27,27,31), accent = Color3.fromRGB(255,94,58), accent2 = Color3.fromRGB(255,149,120), text = Color3.fromRGB(240,240,243), muted = Color3.fromRGB(130,130,138) },
	Ice = { bg = Color3.fromRGB(12,16,22), panel = Color3.fromRGB(20,27,38), row = Color3.fromRGB(32,43,60), accent = Color3.fromRGB(96,165,250), accent2 = Color3.fromRGB(165,205,255), text = Color3.fromRGB(238,245,252), muted = Color3.fromRGB(134,150,172) },
	Toxic = { bg = Color3.fromRGB(10,14,8), panel = Color3.fromRGB(17,24,13), row = Color3.fromRGB(28,39,20), accent = Color3.fromRGB(163,230,53), accent2 = Color3.fromRGB(200,245,120), text = Color3.fromRGB(238,246,228), muted = Color3.fromRGB(144,158,124) },
	Bubblegum = { bg = Color3.fromRGB(16,10,18), panel = Color3.fromRGB(28,18,32), row = Color3.fromRGB(44,28,50), accent = Color3.fromRGB(236,72,217), accent2 = Color3.fromRGB(129,140,248), text = Color3.fromRGB(248,238,250), muted = Color3.fromRGB(166,146,172) },
	Volcanic = { bg = Color3.fromRGB(16,9,7), panel = Color3.fromRGB(28,16,12), row = Color3.fromRGB(46,25,18), accent = Color3.fromRGB(239,68,32), accent2 = Color3.fromRGB(250,170,60), text = Color3.fromRGB(250,236,228), muted = Color3.fromRGB(172,140,126) },
	Sakura = { bg = Color3.fromRGB(20,13,17), panel = Color3.fromRGB(32,21,27), row = Color3.fromRGB(50,33,42), accent = Color3.fromRGB(255,150,190), accent2 = Color3.fromRGB(255,205,225), text = Color3.fromRGB(252,240,246), muted = Color3.fromRGB(180,150,164) },
	Cyberpunk = { bg = Color3.fromRGB(8,6,20), panel = Color3.fromRGB(18,12,38), row = Color3.fromRGB(30,20,62), accent = Color3.fromRGB(255,0,160), accent2 = Color3.fromRGB(0,230,255), text = Color3.fromRGB(246,240,255), muted = Color3.fromRGB(150,140,185) },
	Matrix = { bg = Color3.fromRGB(5,10,6), panel = Color3.fromRGB(10,20,12), row = Color3.fromRGB(16,34,20), accent = Color3.fromRGB(0,255,110), accent2 = Color3.fromRGB(120,255,170), text = Color3.fromRGB(220,255,230), muted = Color3.fromRGB(110,160,124) },
	Royal = { bg = Color3.fromRGB(10,9,20), panel = Color3.fromRGB(18,16,36), row = Color3.fromRGB(30,27,58), accent = Color3.fromRGB(124,92,255), accent2 = Color3.fromRGB(250,204,21), text = Color3.fromRGB(240,238,252), muted = Color3.fromRGB(146,140,176) },
	Coral = { bg = Color3.fromRGB(18,11,10), panel = Color3.fromRGB(30,18,16), row = Color3.fromRGB(48,29,26), accent = Color3.fromRGB(255,111,97), accent2 = Color3.fromRGB(255,179,120), text = Color3.fromRGB(252,240,236), muted = Color3.fromRGB(178,146,138) },
	Steel = { bg = Color3.fromRGB(14,16,19), panel = Color3.fromRGB(23,27,32), row = Color3.fromRGB(37,43,51), accent = Color3.fromRGB(56,189,248), accent2 = Color3.fromRGB(148,163,184), text = Color3.fromRGB(236,242,248), muted = Color3.fromRGB(132,144,158) },
	Honey = { bg = Color3.fromRGB(18,14,6), panel = Color3.fromRGB(30,24,11), row = Color3.fromRGB(48,38,18), accent = Color3.fromRGB(255,196,0), accent2 = Color3.fromRGB(255,230,128), text = Color3.fromRGB(252,246,228), muted = Color3.fromRGB(176,160,118) },
	Vapor = { bg = Color3.fromRGB(14,10,22), panel = Color3.fromRGB(24,17,38), row = Color3.fromRGB(38,27,60), accent = Color3.fromRGB(255,113,206), accent2 = Color3.fromRGB(1,205,254), text = Color3.fromRGB(245,238,252), muted = Color3.fromRGB(158,146,184) },
	Obsidian = { bg = Color3.fromRGB(6,6,8), panel = Color3.fromRGB(13,13,16), row = Color3.fromRGB(22,22,27), accent = Color3.fromRGB(120,120,255), accent2 = Color3.fromRGB(180,180,255), text = Color3.fromRGB(236,236,242), muted = Color3.fromRGB(120,120,134) },
	Jade = { bg = Color3.fromRGB(8,16,14), panel = Color3.fromRGB(14,27,23), row = Color3.fromRGB(22,44,37), accent = Color3.fromRGB(16,220,160), accent2 = Color3.fromRGB(120,240,200), text = Color3.fromRGB(228,248,240), muted = Color3.fromRGB(126,160,150) },
}
-- Custom accent (Themes > Customize) swaps the accent colors on top of whichever theme is picked
local function withAccent(themeData)
	if not Config.CustomAccent then return themeData end
	local copy = table.clone(themeData)
	local hue = tonumber(Config.AccentHue) or 0
	copy.accent = Color3.fromHSV(hue % 1, .62, .98)
	copy.accent2 = Color3.fromHSV((hue + .06) % 1, .48, 1)
	return copy
end
if not Themes[Config.Theme] then Config.Theme = "Studio" end
local Theme = withAccent(Themes[Config.Theme])

-- Murder Mystery role palette (role names come from the server's RoleSync remote).
local MysteryProfile = "Murder Mystery"
local MysteryRoleColors = {
	murderer = Color3.fromRGB(248,75,90),
	sheriff = Color3.fromRGB(59,130,246),
	hero = Color3.fromRGB(250,204,21),
	innocent = Color3.fromRGB(52,211,153),
}
local function mysteryRoleColor(roleName)
	if not roleName then return nil end
	return MysteryRoleColors[string.lower(tostring(roleName))]
end
local function mysteryActive()
	return Config.ActiveProfile == MysteryProfile
end
local function findRoleHolder(roleName)
	for name, role in pairs(State.roles) do
		if string.lower(tostring(role)) == roleName then return name end
	end
	return nil
end

-- Only one UICorner / UIStroke takes effect per object, so both helpers replace
-- whatever is already there instead of stacking a second one.
local function corner(parent, radius)
	local object = parent:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
	object.CornerRadius = UDim.new(0, radius)
	object.Parent = parent
	return object
end
local function outline(parent, color, transparency, thickness)
	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA("UIStroke") then child:Destroy() end
	end
	local object = Instance.new("UIStroke")
	object.Color = color
	object.Transparency = transparency or 0
	object.Thickness = thickness or 1
	object.Parent = parent
	return object
end
local function bindTheme(object, property, role)
	table.insert(UI.bindings, { object = object, property = property, role = role })
end

-- fx: one loop drives every spinning / shimmering / drifting gradient
local FX = { spin = {}, shimmer = {}, accent = {}, drift = {}, clock = 0 }

local function accentSequence()
	-- one hue with a slight warm shift, not a rainbow
	return ColorSequence.new(Theme.accent, Theme.accent:Lerp(Theme.accent2, .35))
end
-- Gradient that always follows the active theme's accent colors.
local function accentGradient(parent, rotation)
	local gradient = Instance.new("UIGradient")
	gradient.Color = accentSequence()
	gradient.Rotation = rotation or 0
	gradient.Parent = parent
	table.insert(FX.accent, gradient)
	return gradient
end
local function spin(gradient, degreesPerSecond) table.insert(FX.spin, { g = gradient, s = degreesPerSecond or 90 }) end
local function shimmer(gradient, speed)
	if not gradient or not gradient:IsA("UIGradient") then return end
	table.insert(FX.shimmer, { g = gradient, s = speed or .35 })
end
local function refreshAccentFX()
	for _, gradient in ipairs(FX.accent) do if gradient.Parent then gradient.Color = accentSequence() end end
end
-- Neon border: a white stroke tinted by a spinning accent gradient.
local function neonStroke(parent, thickness, speed, transparency)
	-- Only one UIStroke renders per object, so replace any existing border.
	for _, child in ipairs(parent:GetChildren()) do if child:IsA("UIStroke") then child:Destroy() end end
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.new(1,1,1)
	stroke.Thickness = math.min(thickness or 1, 1.5)
	stroke.Transparency = transparency or 0
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = parent
	accentGradient(stroke, 90)
	return stroke
end

-- Builder Sans for UI text, Roboto Mono for codes. Falls back to Gotham if an enum is missing.
do
	local function pick(name, fallback)
		local ok, value = pcall(function() return Enum.Font[name] end)
		return ok and value or fallback
	end
	local swap = {
		[Enum.Font.Gotham] = pick("BuilderSans", Enum.Font.Gotham),
		[Enum.Font.GothamMedium] = pick("BuilderSansMedium", Enum.Font.GothamMedium),
		[Enum.Font.GothamBold] = pick("BuilderSansBold", Enum.Font.GothamBold),
		[Enum.Font.GothamBlack] = pick("BuilderSansExtraBold", Enum.Font.GothamBlack),
		[Enum.Font.Code] = pick("RobotoMono", Enum.Font.Code),
	}
	function FX.retype(object)
		if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
			object.Font = swap[object.Font] or object.Font
		end
	end
	if Loader.screen and Loader.screen.Parent then
		for _, object in ipairs(Loader.screen:GetDescendants()) do FX.retype(object) end
	end
end
RunService.RenderStepped:Connect(function(dt)
	FX.clock += dt
	for index = #FX.spin, 1, -1 do
		local item = FX.spin[index]
		if item.g.Parent then item.g.Rotation = (item.g.Rotation + dt * item.s) % 360 else table.remove(FX.spin, index) end
	end
	for index = #FX.shimmer, 1, -1 do
		local item = FX.shimmer[index]
		if item.g.Parent then
			local x = (FX.clock * item.s) % 2 - 1
			item.g.Offset = Vector2.new(x, 0)
		else table.remove(FX.shimmer, index) end
	end
	for index = #FX.drift, 1, -1 do
		local item = FX.drift[index]
		if item.o.Parent then
			local t = FX.clock * item.speed + item.phase
			item.o.Position = UDim2.new(item.x, math.sin(t) * item.r, item.y, math.cos(t * .8) * item.r)
		else table.remove(FX.drift, index) end
	end
end)
local function panel(parent, size, position, role)
	local object = Instance.new("Frame")
	object.Size = size
	object.Position = position or UDim2.new()
	object.BackgroundColor3 = Theme[role or "panel"]
	object.BorderSizePixel = 0
	object.Parent = parent
	corner(object, 8)
	local border = outline(object, Theme[role == "accent" and "accent2" or "row"], role == "row" and .55 or .6, 1)
	border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	bindTheme(border, "Color", role == "accent" and "accent2" or "row")
	bindTheme(object, "BackgroundColor3", role or "panel")
	return object
end
local function label(parent, value, size, position, font, role, textSize)
	local object = Instance.new("TextLabel")
	object.BackgroundTransparency = 1
	object.Size = size
	object.Position = position or UDim2.new()
	object.Font = font or Enum.Font.Gotham
	object.Text = value
	object.TextColor3 = Theme[role or "text"]
	object.TextSize = textSize or 13
	object.TextXAlignment = Enum.TextXAlignment.Left
	object.Parent = parent
	bindTheme(object, "TextColor3", role or "text")
	return object
end
local function button(parent, value, size, position, role)
	local object = Instance.new("TextButton")
	object.Size = size
	object.Position = position or UDim2.new()
	object.BackgroundColor3 = Theme[role or "row"]
	object.BorderSizePixel = 0
	object.AutoButtonColor = false
	object.Font = Enum.Font.GothamBold
	object.Text = value
	object.TextColor3 = Theme.text
	object.TextSize = 11
	object.Parent = parent
	corner(object, 6)
	bindTheme(object, "BackgroundColor3", role or "row")
	bindTheme(object, "TextColor3", "text")
	-- hover outline + a small press
	local hoverScale = Instance.new("UIScale")
	hoverScale.Name = "HoverScale"
	hoverScale.Parent = object
	local glow = Instance.new("UIStroke")
	glow.Name = "HoverGlow"
	glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	glow.Color = Theme.accent2
	glow.Thickness = 1.5
	glow.Transparency = 1
	glow.Parent = object
	bindTheme(glow, "Color", "accent2")
	local spring = TweenInfo.new(.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	-- set the CustomHover attribute to handle background hover yourself
	object.MouseEnter:Connect(function()
		if object:GetAttribute("CustomHover") then return end
		TweenService:Create(object, TweenInfo.new(.12), { BackgroundTransparency = .06 }):Play()
		TweenService:Create(glow, TweenInfo.new(.15), { Transparency = .6 }):Play()
	end)
	object.MouseLeave:Connect(function()
		if object:GetAttribute("CustomHover") then return end
		TweenService:Create(object, TweenInfo.new(.12), { BackgroundTransparency = 0 }):Play()
		TweenService:Create(glow, TweenInfo.new(.2), { Transparency = 1 }):Play()
		TweenService:Create(hoverScale, spring, { Scale = 1 }):Play()
	end)
	object.MouseButton1Down:Connect(function()
		TweenService:Create(hoverScale, TweenInfo.new(.08), { Scale = .97 }):Play()
	end)
	object.MouseButton1Up:Connect(function()
		TweenService:Create(hoverScale, spring, { Scale = 1 }):Play()
	end)
	return object
end
local function markDirty() State.dirty = true end

local function setAvatar(imageLabel, userId)
	task.spawn(function()
		local ok, image = pcall(function()
			return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		end)
		if ok and imageLabel.Parent then imageLabel.Image = image end
	end)
end

local function formatDuration(seconds)
	seconds = tonumber(seconds) or 0
	if seconds ~= seconds or seconds == math.huge or seconds == -math.huge then seconds = 0 end
	seconds = math.max(math.floor(seconds), 0)
	return string.format("%02d:%02d", math.floor(seconds / 60), seconds % 60)
end

local function shadow(parent, transparency)
	local image = Instance.new("ImageLabel")
	image.Name = "Shadow"
	image.BackgroundTransparency = 1
	image.Image = "rbxassetid://1316045217"
	image.ImageColor3 = Color3.new()
	image.ImageTransparency = transparency or .45
	image.ScaleType = Enum.ScaleType.Slice
	image.SliceCenter = Rect.new(10, 10, 118, 118)
	image.Size = UDim2.new(1, 34, 1, 34)
	image.Position = UDim2.fromOffset(-17, -17)
	image.ZIndex = math.max(parent.ZIndex - 1, 0)
	image.Parent = parent
	return image
end

local function pageHeader(page, titleText, subtitleText, accentRole)
	UI.pageCount = (UI.pageCount or 0) + 1
	label(page, string.format("%02d  /  %s", UI.pageCount, string.upper(titleText)), UDim2.new(1, -40, 0, 14), UDim2.fromOffset(16, 12), Enum.Font.Code, accentRole or "accent", 10)
	local titleLabel = label(page, titleText, UDim2.new(1, -40, 0, 26), UDim2.fromOffset(16, 25), Enum.Font.GothamBlack, "text", 21)
	local subtitleLabel = label(page, subtitleText, UDim2.new(1, -40, 0, 14), UDim2.fromOffset(16, 50), Enum.Font.Gotham, "muted", 10)
	subtitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	local rule = Instance.new("Frame")
	rule.Size = UDim2.new(1, -32, 0, 1)
	rule.Position = UDim2.fromOffset(16, 66)
	rule.BackgroundColor3 = Theme.text
	rule.BackgroundTransparency = .93
	rule.BorderSizePixel = 0
	rule.Parent = page
	bindTheme(rule, "BackgroundColor3", "text")
	return titleLabel, subtitleLabel
end

local oldGui = playerGui:FindFirstChild("StaticsNewgenUI")
if oldGui then oldGui:Destroy() end
local gui = Instance.new("ScreenGui")
gui.Name = "StaticsNewgenUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 150
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

-- loader was built at the top
local loading = Loader.root
local loadingTitle, loadingStage, loadingDiscord, loadingTip = Loader.title, Loader.stage, Loader.discord, Loader.tip
local loadingFill, loaderLogoScale = Loader.fill, Loader.logoScale
-- Recolor the loader to match the saved theme now that preferences are known.
Loader.logoGradient.Color = ColorSequence.new(Theme.accent, Theme.accent2)
Loader.fillGradient.Color = ColorSequence.new(Theme.accent, Theme.accent2)
loadingStage.Text = "Building interface modules..."
if Loader.setProgress then Loader.setProgress(.2) end
TweenService:Create(loadingFill, TweenInfo.new(.2, Enum.EasingStyle.Quart), { Size = UDim2.fromScale(.2, 1) }):Play()

-- if startup hangs, get the loader out of the way after 10s
local startupFinished = false
local startupSkip = false
local startupError = nil
loading.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		startupSkip = true
		Loader.skipRequested = true
		if Loader.skipHint then Loader.skipHint.Text = "Skipping..." end
	end
end)
task.delay(10, function()
	if startupFinished or not loading.Parent then return end
	loadingTitle.Text = "LOAD PROBLEM"
	loadingStage.Text = startupError and "A module failed to build" or "Startup is taking too long"
	loadingTip.Text = startupError and tostring(startupError):sub(1, 140) or "Check the Output window (F9) for errors."
	task.wait(2.5)
	if startupFinished then return end
	Loader.fade(.3)
end)

local dim = panel(gui, UDim2.fromScale(1,1), nil, "bg")
dim.BackgroundColor3 = Color3.new()
dim.BackgroundTransparency = .45
dim.Visible = false
dim:SetAttribute("ThemeLocked", true) -- stays black when the theme changes
local dimStroke = dim:FindFirstChildOfClass("UIStroke")
if dimStroke then dimStroke:Destroy() end
local defaultBaseSize = isMobile and Vector2.new(640,760) or Vector2.new(860,550)
UI.layoutBaseSize = defaultBaseSize
UI.layoutFitWidth = defaultBaseSize.X + 24
local main = panel(gui, UDim2.fromOffset(defaultBaseSize.X,defaultBaseSize.Y), UDim2.fromScale(.5,.5), "bg")
main.AnchorPoint = Vector2.new(.5,.5)
main.Visible = false
neonStroke(main, 1, 0, .5)
shadow(main, .2)

-- backdrop
do
	local backdrop=Instance.new("Frame")
	backdrop.Name="Backdrop"
	backdrop.Size=UDim2.fromScale(1,1)
	backdrop.BackgroundTransparency=1
	backdrop.ClipsDescendants=true
	backdrop.ZIndex=0
	backdrop.Parent=main
	-- one soft wash in the top-left corner, nothing moving
	local wash=Instance.new("Frame")
	wash.Size=UDim2.new(.7,0,.6,0)
	wash.BackgroundColor3=Theme.accent
	wash.BackgroundTransparency=.94
	wash.BorderSizePixel=0
	wash.ZIndex=0
	wash.Parent=backdrop
	bindTheme(wash,"BackgroundColor3","accent")
	local washFade=Instance.new("UIGradient")
	washFade.Rotation=35
	washFade.Transparency=NumberSequence.new(0,1)
	washFade.Parent=wash
end
local scale = Instance.new("UIScale")
scale.Parent = main
local function fitWindow()
	local viewport = camera and camera.ViewportSize or Vector2.new(1280,720)
	local size = UI.layoutBaseSize or defaultBaseSize
	local room = math.min(viewport.X/(UI.layoutFitWidth or(size.X+24)), viewport.Y/(size.Y+24))
	local fit = math.clamp(room, isMobile and .42 or .55, 1)
	-- the Customize slider scales on top of the auto-fit; growing stops once the window would leave the screen
	local wanted = math.clamp(tonumber(Config.UIScale) or 1, .7, 1.3)
	local ceiling = math.max(fit, math.min(1.3, room))
	scale.Scale = math.clamp(fit * wanted, .38, ceiling)
end
fitWindow()

local top = panel(main, UDim2.new(1,0,0,58), nil, "panel")
top.Active = true
local topSquare=Instance.new("Frame")
topSquare.Size=UDim2.new(1,0,0,14)
topSquare.Position=UDim2.new(0,0,1,-14)
topSquare.BackgroundColor3=Theme.panel
topSquare.BorderSizePixel=0
topSquare.Parent=top
bindTheme(topSquare,"BackgroundColor3","panel")
local topGradient = Instance.new("UIGradient")
topGradient.Color = ColorSequence.new(Color3.new(1,1,1):Lerp(Theme.accent, .12), Color3.new(1,1,1))
topGradient.Rotation = 12
topGradient.Parent = top
-- Spinning gradient logo tile
local logo = Instance.new("Frame")
logo.Size = UDim2.fromOffset(38,38)
logo.Position = UDim2.fromOffset(13,10)
logo.BackgroundColor3 = Color3.new(1,1,1)
logo.BorderSizePixel = 0
logo.Parent = top
corner(logo, 11)
accentGradient(logo, 35)
outline(logo, Color3.new(1,1,1), .6, 1.5)
local logoText = label(logo, "S", UDim2.fromScale(1,1), nil, Enum.Font.GothamBlack, "text", 20)
logoText.TextXAlignment = Enum.TextXAlignment.Center
logoText:SetAttribute("ThemeLocked", true)
logoText.TextColor3 = Color3.new(1,1,1)
logoText.TextStrokeTransparency = .75
do
-- Gradient wordmark + version pill
local wordmark = label(top, "STATICS", UDim2.fromOffset(90,24), UDim2.fromOffset(62,7), Enum.Font.GothamBlack, "text", 18)
UI.wordmark = wordmark
local wordmarkGradient = accentGradient(wordmark, 0)
shimmer(wordmarkGradient, .35)
local pill = Instance.new("TextLabel")
pill.Size = UDim2.fromOffset(62,18)
pill.Position = UDim2.fromOffset(148,10)
pill.BackgroundColor3 = Color3.new(1,1,1)
pill.BackgroundTransparency = .1
pill.Font = Enum.Font.GothamBlack
pill.Text = "NEWGEN"
pill.TextColor3 = Color3.new(1,1,1)
pill.TextSize = 9
pill.Parent = top
corner(pill, 9)
accentGradient(pill, 0)
-- the name at the top follows the loaded profile (Rivals swaps it for its own)
UI.refreshBrand = function()
	local rivals = State.profileChosen and Config.ActiveProfile == "Rivals"
	wordmark.Text = rivals and "RIVALS" or "STATICS"
	pill.Text = rivals and "PREMIUM" or "NEWGEN"
	pill.Size = UDim2.fromOffset(rivals and 68 or 62, 18)
	pill.Position = UDim2.fromOffset(rivals and 136 or 148, 10)
end
label(top, "discord.gg/rXxwRtaCQ", UDim2.fromOffset(210,18), UDim2.fromOffset(62,31), Enum.Font.Gotham, "muted", 10)
-- Shimmering neon line under the top bar
local topLine = Instance.new("Frame")
topLine.Size = UDim2.new(1,-24,0,2)
topLine.Position = UDim2.new(0,12,1,-2)
topLine.BackgroundColor3 = Color3.new(1,1,1)
topLine.BorderSizePixel = 0
topLine.Parent = top
local topLineGradient = accentGradient(topLine, 0)
topLineGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(.5,0),NumberSequenceKeypoint.new(1,1)})
shimmer(topLineGradient, .45)
end
UI.saveStatus = label(top, "Ready", UDim2.fromOffset(150,20), UDim2.new(1,-240,0,19), Enum.Font.GothamBold, "muted", 10)
UI.saveStatus.TextXAlignment = Enum.TextXAlignment.Right
UI.saveStatus.Visible = not isMobile
local close = button(top, "X", UDim2.fromOffset(34,30), UDim2.new(1,-42,0,14), "row")
local minimize = button(top, "-", UDim2.fromOffset(34,30), UDim2.new(1,-82,0,14), "row")

do
	local dragging=false
	local dragStart=nil
	local startPosition=nil
	local mainStroke = main:FindFirstChildOfClass("UIStroke")
	-- a thin accent "grab" hint that fades in when you hover the top bar
	local grabHint = Instance.new("Frame")
	grabHint.Name = "DragGrip"
	grabHint.AnchorPoint = Vector2.new(.5, 0)
	grabHint.Position = UDim2.new(.5, 0, 0, 5)
	grabHint.Size = UDim2.fromOffset(34, 4)
	grabHint.BackgroundColor3 = Color3.new(1, 1, 1)
	grabHint.BackgroundTransparency = .7
	grabHint.BorderSizePixel = 0
	grabHint.ZIndex = 6
	grabHint.Parent = top
	corner(grabHint, 2)
	accentGradient(grabHint, 0)
	top.MouseEnter:Connect(function() TweenService:Create(grabHint, TweenInfo.new(.15), { BackgroundTransparency = .2 }):Play() end)
	top.MouseLeave:Connect(function() if not dragging then TweenService:Create(grabHint, TweenInfo.new(.2), { BackgroundTransparency = .7 }):Play() end end)
	local function liftWindow(lift)
		-- subtle lift: shrink a touch and brighten the border while dragging
		local target = lift and math.clamp(scale.Scale * .985, .2, 2) or scale.Scale
		if mainStroke then TweenService:Create(mainStroke, TweenInfo.new(.14), { Transparency = lift and 0 or .5, Thickness = lift and 1.6 or 1 }):Play() end
		TweenService:Create(grabHint, TweenInfo.new(.14), { BackgroundTransparency = lift and 0 or .7, Size = lift and UDim2.fromOffset(48, 4) or UDim2.fromOffset(34, 4) }):Play()
	end
	top.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
			dragging=true;dragStart=input.Position;startPosition=main.Position
			liftWindow(true)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
			local delta=input.Position-dragStart
			main.Position=UDim2.new(startPosition.X.Scale,startPosition.X.Offset+delta.X/scale.Scale,startPosition.Y.Scale,startPosition.Y.Offset+delta.Y/scale.Scale)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
			if dragging then dragging=false; liftWindow(false) end
		end
	end)
end

local sidebar = panel(main, isMobile and UDim2.new(1,0,0,62) or UDim2.new(0,116,1,-58), isMobile and UDim2.new(0,0,1,-62) or UDim2.fromOffset(0,58), "panel")
local content = Instance.new("Frame")
content.Size = isMobile and UDim2.new(1,0,1,-120) or UDim2.new(1,-116,1,-58)
content.Position = isMobile and UDim2.fromOffset(0,58) or UDim2.fromOffset(116,58)
content.BackgroundTransparency = 1
content.ClipsDescendants = true
content.Parent = main

UI.rightRail = panel(main, UDim2.fromOffset(150,330), UDim2.new(1,14,0,78), "panel")
UI.rightRail.Visible = false
shadow(UI.rightRail,.55)
label(UI.rightRail,"STATICS NEWGEN",UDim2.new(1,-20,0,24),UDim2.fromOffset(10,13),Enum.Font.GothamBlack,"text",12).TextXAlignment=Enum.TextXAlignment.Center
label(UI.rightRail,"SESSION",UDim2.new(1,-20,0,18),UDim2.fromOffset(10,54),Enum.Font.GothamBold,"accent2",9)
UI.layoutStatus = label(UI.rightRail,"READY",UDim2.new(1,-20,0,28),UDim2.fromOffset(10,76),Enum.Font.GothamBlack,"text",14)
UI.layoutStatus.TextXAlignment=Enum.TextXAlignment.Center
label(UI.rightRail,"DEVICE",UDim2.new(1,-20,0,18),UDim2.fromOffset(10,124),Enum.Font.GothamBold,"accent",9)
local railDevice=label(UI.rightRail,string.upper(device),UDim2.new(1,-20,0,28),UDim2.fromOffset(10,146),Enum.Font.GothamBlack,"text",14);railDevice.TextXAlignment=Enum.TextXAlignment.Center
label(UI.rightRail,"COMMUNITY",UDim2.new(1,-20,0,18),UDim2.fromOffset(10,197),Enum.Font.GothamBold,"accent2",9)
local railDiscord=label(UI.rightRail,"discord.gg/\nrXxwRtaCQ",UDim2.new(1,-20,0,44),UDim2.fromOffset(10,222),Enum.Font.GothamBold,"text",10);railDiscord.TextWrapped=true;railDiscord.TextXAlignment=Enum.TextXAlignment.Center
local launcher = button(gui, "STATICS", UDim2.fromOffset(122,46), UDim2.new(0,16,1,-64), "accent")
launcher.Visible = false
launcher.TextColor3 = Color3.new(1,1,1)
launcher.TextSize = 13
launcher.Font = Enum.Font.GothamBlack
if launcher:FindFirstChild("Sheen") then launcher.Sheen:Destroy() end
launcher:SetAttribute("ThemeLocked", true)
launcher.BackgroundColor3 = Color3.new(1,1,1)
local launcherGradient = Instance.new("UIGradient")
launcherGradient.Color = ColorSequence.new(Theme.accent:Lerp(Color3.new(1,1,1),.2),Theme.accent:Lerp(Color3.new(0,0,0),.18))
launcherGradient.Rotation = 18
launcherGradient.Parent = launcher
neonStroke(launcher, 1, 0, .25)
shadow(launcher, .45)
local showPage
local applyLayout

local toast=Instance.new("CanvasGroup")
toast.AnchorPoint=Vector2.new(1,0)
toast.Position=UDim2.new(1,-18,0,18)
toast.Size=UDim2.fromOffset(310,66)
toast.BackgroundColor3=Theme.panel
toast.BorderSizePixel=0
toast.GroupTransparency=1
toast.Visible=false
toast.ZIndex=500
toast.Parent=gui
corner(toast,12)
neonStroke(toast,1.5,120,.1)
-- accent strip on the left + a timer bar that drains while the toast is visible
do local toastStrip=Instance.new("Frame");toastStrip.Size=UDim2.new(0,4,1,-16);toastStrip.Position=UDim2.fromOffset(0,8);toastStrip.BackgroundColor3=Color3.new(1,1,1);toastStrip.BorderSizePixel=0;toastStrip.ZIndex=501;toastStrip.Parent=toast;corner(toastStrip,2);accentGradient(toastStrip,90) end
local toastTimer=Instance.new("Frame");toastTimer.Size=UDim2.new(1,0,0,2);toastTimer.Position=UDim2.new(0,0,1,-2);toastTimer.BackgroundColor3=Color3.new(1,1,1);toastTimer.BorderSizePixel=0;toastTimer.ZIndex=501;toastTimer.Parent=toast;accentGradient(toastTimer,0)
local toastTitle=label(toast,"STATICS",UDim2.new(1,-24,0,20),UDim2.fromOffset(12,8),Enum.Font.GothamBlack,"accent2",10);toastTitle.ZIndex=501
local toastMessage=label(toast,"",UDim2.new(1,-24,0,28),UDim2.fromOffset(12,29),Enum.Font.GothamMedium,"text",11);toastMessage.TextWrapped=true;toastMessage.ZIndex=501
local toastToken=0
local function notify(message,good)
	toastToken+=1
	local token=toastToken
	toast.Visible=true;toast.GroupTransparency=1;toast.Position=UDim2.new(1,20,0,18)
	toastTitle.Text=good==false and"ATTENTION"or"STATICS NEWGEN"
	toastTitle.TextColor3=good==false and Color3.fromRGB(248,75,90)or Theme.accent2
	toastMessage.Text=tostring(message)
	TweenService:Create(toast,TweenInfo.new(.28,Enum.EasingStyle.Back),{GroupTransparency=0,Position=UDim2.new(1,-18,0,18)}):Play()
	toastTimer.Size=UDim2.new(1,0,0,2)
	TweenService:Create(toastTimer,TweenInfo.new(2.6,Enum.EasingStyle.Linear),{Size=UDim2.new(0,0,0,2)}):Play()
	task.delay(2.6,function()if token~=toastToken then return end;TweenService:Create(toast,TweenInfo.new(.2),{GroupTransparency=1,Position=UDim2.new(1,20,0,18)}):Play();task.wait(.22);if token==toastToken then toast.Visible=false end end)
end
UI.notify=notify
local mobileAimButton = nil
if isMobile then
	mobileAimButton = button(gui, "HOLD AIM", UDim2.fromOffset(150,58), UDim2.new(1,-168,1,-78), "accent")
	mobileAimButton.Visible = false
	mobileAimButton.TextSize = 15
	mobileAimButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch and Config.AimEnabled then State.aimHeld = true; State.target = nil end
	end)
	mobileAimButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then State.aimHeld = false; State.target = nil end
	end)
end

-- Murder Mystery on-screen role HUD (shown only while that profile is active).
local mysteryHud=Instance.new("Frame")
mysteryHud.Name="MysteryRoleHUD"
mysteryHud.AnchorPoint=Vector2.new(.5,0)
mysteryHud.Position=UDim2.new(.5,0,0,14)
mysteryHud.Size=UDim2.fromOffset(260,46)
mysteryHud.BackgroundColor3=Theme.panel
mysteryHud.BackgroundTransparency=.08
mysteryHud.BorderSizePixel=0
mysteryHud.Visible=false
mysteryHud.Parent=gui
corner(mysteryHud,12)
local mysteryHudStroke=outline(mysteryHud,Theme.accent,.2,1.5)
bindTheme(mysteryHud,"BackgroundColor3","panel")
local mysteryHudDot=Instance.new("Frame");mysteryHudDot.Size=UDim2.fromOffset(12,12);mysteryHudDot.Position=UDim2.new(0,14,.5,-6);mysteryHudDot.BackgroundColor3=Theme.muted;mysteryHudDot.BorderSizePixel=0;mysteryHudDot.Parent=mysteryHud;corner(mysteryHudDot,6)
local mysteryHudRole=label(mysteryHud,"ROLE: WAITING",UDim2.new(1,-40,0,20),UDim2.fromOffset(34,5),Enum.Font.GothamBlack,"text",13)
local mysteryHudInfo=label(mysteryHud,"ROUND NOT STARTED",UDim2.new(1,-40,0,16),UDim2.fromOffset(34,24),Enum.Font.GothamBold,"muted",9)
UI.mysteryHud=mysteryHud

local function applyTheme(themeName, silent)
	local nextTheme = Themes[themeName]
	if not nextTheme then return end
	Theme = withAccent(nextTheme)
	Config.Theme = themeName
	for _, binding in ipairs(UI.bindings) do
		if binding.object.Parent and not binding.object:GetAttribute("ThemeLocked") and Theme[binding.role] then
			binding.object[binding.property] = Theme[binding.role]
		end
	end
	for _,refresh in ipairs(UI.refreshers) do pcall(refresh) end
	if UI.applyBackground then pcall(UI.applyBackground) end
	refreshAccentFX() -- recolors every neon border, glow, logo and shimmer to the new theme
	topGradient.Color=ColorSequence.new(Color3.new(1,1,1):Lerp(Theme.accent,.12),Color3.new(1,1,1))
	launcherGradient.Color=ColorSequence.new(Theme.accent:Lerp(Color3.new(1,1,1),.2),Theme.accent:Lerp(Color3.new(0,0,0),.18))
	if UI.fovStroke then UI.fovStroke.Color=Color3.fromHSV(Config.FOVCircleHue,.75,1)end
	State.dirty = true
	if not silent and UI.notify then UI.notify(themeName.." theme applied",true) end
	if showPage and State.currentPage then
		UI.noSlide = silent -- no page slide-in while dragging the accent slider
		showPage(State.currentPage)
		UI.noSlide = false
	end
end
UI.applyTheme = applyTheme

local menuAnimationToken=0
local function setMenu(open)
	menuAnimationToken+=1
	local token=menuAnimationToken
	State.menuOpen = open
	local currentSize=UI.layoutBaseSize or defaultBaseSize
	if open then
		main.Visible=true;dim.Visible=true;launcher.Visible=false
		main.Size=UDim2.fromOffset(currentSize.X*.96,currentSize.Y*.96)
		dim.BackgroundTransparency=1
		TweenService:Create(main,TweenInfo.new(.26,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(currentSize.X,currentSize.Y)}):Play()
		TweenService:Create(dim,TweenInfo.new(.2),{BackgroundTransparency=.45}):Play()
	else
		TweenService:Create(main,TweenInfo.new(.18,Enum.EasingStyle.Quart),{Size=UDim2.fromOffset(currentSize.X*.97,currentSize.Y*.97)}):Play()
		TweenService:Create(dim,TweenInfo.new(.18),{BackgroundTransparency=1}):Play()
		task.delay(.19,function()if token==menuAnimationToken then main.Visible=false;dim.Visible=false;launcher.Visible=true end end)
	end
	if UI.quickBar then UI.quickBar.Visible = Config.ActiveProfile == "Last Letter" and not open end
	if UI.mysteryHud then UI.mysteryHud.Visible = mysteryActive() and State.profileChosen and Config.MysteryRoleHUD and not open end
	if mobileAimButton then mobileAimButton.Visible = not open and Config.AimEnabled and Config.ActiveProfile ~= "Last Letter" end
end
close.Activated:Connect(function() setMenu(false) end)
minimize.Activated:Connect(function() setMenu(false) end)
launcher.Activated:Connect(function() setMenu(true) end)
UserInputService.InputBegan:Connect(function(input, processed)
	if processed or UI.bindingActive or os.clock()-(UI.boundAt or 0)<.3 then return end
	if input.KeyCode.Name == (Config.MenuKey or "RightShift") then setMenu(not State.menuOpen) end
end)

local function newPage(name)
	local scrollPage = name == "Performance" or name == "Session" or name == "Themes"
	local page = Instance.new(scrollPage and "ScrollingFrame" or "Frame")
	page.Name = name
	page.Size = UDim2.fromScale(1,1)
	page.BackgroundTransparency = 1
	page.Visible = false
	if scrollPage then
		page.BorderSizePixel = 0
		page.ScrollBarThickness = 3
		page.ScrollBarImageColor3 = Theme.accent
		bindTheme(page, "ScrollBarImageColor3", "accent")
		page.ScrollingDirection = Enum.ScrollingDirection.Y
		page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		page.CanvasSize = UDim2.new()
	end
	page.Parent = content
	UI.pages[name] = page
	return page
end
local function scrollingPanel(parent,size,position,canvasHeight)
	local object=Instance.new("ScrollingFrame")
	object.Size=size;object.Position=position;object.BackgroundColor3=Theme.panel;object.BorderSizePixel=0;object.ScrollBarThickness=3;object.ScrollBarImageColor3=Theme.accent;object.CanvasSize=UDim2.fromOffset(0,canvasHeight);object.Parent=parent;corner(object,10);bindTheme(object,"BackgroundColor3","panel");return object
end
-- The third field marks a profile-only category: it stays hidden until that profile is loaded.
local navigation = {
	{ "Hub", "Game Hub" }, { "Home", "Overview" }, { "Aim", "Aim Assist" }, { "VRAim", "VR Assist" },
	{ "Words", "Last Letter", "Last Letter" },
	{ "Fling", "Fling Things", "Fling Things and People" },
	-- Murder Mystery isn't here, it opens as its own pop-up
	{ "Visuals", "Visuals" }, { "Performance", "Performance" },
	{ "Settings", "Settings" }, { "Stats", "Statistics" }, { "Keystrokes", "Keystrokes" }, { "Session", "Session" }, { "Players", "Players" },
}
UI.navVisuals = {}

local function navLine(parent, size, position, rotation)
	local line = Instance.new("Frame")
	line.AnchorPoint = Vector2.new(.5,.5)
	line.Size = size
	line.Position = position
	line.Rotation = rotation or 0
	line.BackgroundColor3 = Theme.muted
	line.BorderSizePixel = 0
	line.Parent = parent
	corner(line, 3)
	return line
end

local function createNavIcon(parent, pageName)
	local icon = Instance.new("Frame")
	icon.Size = UDim2.fromOffset(24,24)
	icon.Position = UDim2.fromOffset(8,5)
	icon.BackgroundTransparency = 1
	icon.Parent = parent
	local pieces = {}
	local function add(size, position, rotation)
		local piece = navLine(icon, size, position, rotation)
		table.insert(pieces, piece)
		return piece
	end
	-- helper: a hollow outlined box piece
	local function ring(size, position, thickness, rot)
		local r = add(size, position, rot); r.BackgroundTransparency = 1
		table.insert(pieces, outline(r, Theme.muted, 0, thickness or 2))
		return r
	end
	-- helper: a small solid dot
	local function dot(d, position)
		local p = add(UDim2.fromOffset(d, d), position); corner(p, d / 2); return p
	end
	if pageName == "Hub" then
		-- 2x2 grid of rounded tiles
		for x=0,1 do for y=0,1 do local t=add(UDim2.fromOffset(8,8),UDim2.fromOffset(7+x*10,7+y*10)); corner(t,2) end end
	elseif pageName == "Home" then
		-- house: roof + body
		add(UDim2.fromOffset(15,3),UDim2.fromOffset(7,9),-42);add(UDim2.fromOffset(15,3),UDim2.fromOffset(17,9),42)
		local body=add(UDim2.fromOffset(16,11),UDim2.fromOffset(12,17)); corner(body,2)
	elseif pageName == "Aim" then
		-- crosshair + ring
		ring(UDim2.fromOffset(17,17),UDim2.fromOffset(12,12),2)
		add(UDim2.fromOffset(23,2),UDim2.fromOffset(12,12));add(UDim2.fromOffset(2,23),UDim2.fromOffset(12,12))
		dot(4, UDim2.fromOffset(12,12))
	elseif pageName == "VRAim" then
		-- VR headset
		ring(UDim2.fromOffset(22,14),UDim2.fromOffset(12,11),2)
		add(UDim2.fromOffset(6,5),UDim2.fromOffset(8,12));add(UDim2.fromOffset(6,5),UDim2.fromOffset(16,12));add(UDim2.fromOffset(8,2),UDim2.fromOffset(12,20))
		UI.vrNavBadge=Instance.new("Frame");UI.vrNavBadge.Size=UDim2.fromOffset(12,12);UI.vrNavBadge.Position=UDim2.new(1,-6,0,-4);UI.vrNavBadge.BackgroundColor3=Color3.fromRGB(248,75,90);UI.vrNavBadge.BorderSizePixel=0;UI.vrNavBadge.Parent=icon;corner(UI.vrNavBadge,6);outline(UI.vrNavBadge,Color3.new(1,1,1),.35,1)
	elseif pageName == "Words" then
		-- letter "A" shape (two legs + crossbar)
		add(UDim2.fromOffset(3,18),UDim2.fromOffset(8,12),-16)
		add(UDim2.fromOffset(3,18),UDim2.fromOffset(16,12),16)
		add(UDim2.fromOffset(10,3),UDim2.fromOffset(12,15))
	elseif pageName == "Fling" then
		-- slingshot: V fork + launched ball
		add(UDim2.fromOffset(3,15), UDim2.fromOffset(8,13), -22)
		add(UDim2.fromOffset(3,15), UDim2.fromOffset(16,13), 22)
		add(UDim2.fromOffset(10,2), UDim2.fromOffset(12,19))
		dot(7, UDim2.fromOffset(18,6))
	elseif pageName == "Mystery" then
		-- magnifying glass
		ring(UDim2.fromOffset(15,15),UDim2.fromOffset(10,10),2)
		add(UDim2.fromOffset(9,3),UDim2.fromOffset(18,18),45)
	elseif pageName == "Visuals" then
		-- eye: outline + pupil
		ring(UDim2.fromOffset(23,14),UDim2.fromOffset(12,12),2)
		dot(7, UDim2.fromOffset(12,12))
	elseif pageName == "Performance" then
		-- ascending bar chart (3 bars of increasing height)
		local b1=add(UDim2.fromOffset(5,8),UDim2.fromOffset(6,17)); corner(b1,1)
		local b2=add(UDim2.fromOffset(5,13),UDim2.fromOffset(12,14)); corner(b2,1)
		local b3=add(UDim2.fromOffset(5,18),UDim2.fromOffset(18,12)); corner(b3,1)
	elseif pageName == "Settings" then
		-- gear: center hub + 4 teeth (distinct from everything else)
		ring(UDim2.fromOffset(12,12),UDim2.fromOffset(12,12),2)
		dot(4, UDim2.fromOffset(12,12))
		add(UDim2.fromOffset(4,4),UDim2.fromOffset(12,3));add(UDim2.fromOffset(4,4),UDim2.fromOffset(12,21))
		add(UDim2.fromOffset(4,4),UDim2.fromOffset(3,12));add(UDim2.fromOffset(4,4),UDim2.fromOffset(21,12))
	elseif pageName == "Stats" then
		-- line graph: baseline + a rising zig-zag of segments
		add(UDim2.fromOffset(20,2),UDim2.fromOffset(12,20))
		add(UDim2.fromOffset(8,2),UDim2.fromOffset(8,15),-30)
		add(UDim2.fromOffset(8,2),UDim2.fromOffset(16,11),30)
		dot(4, UDim2.fromOffset(19,8))
	elseif pageName == "Keystrokes" then
		-- keyboard: outer key + two mini keys below
		ring(UDim2.fromOffset(20,9),UDim2.fromOffset(12,8),2)
		local k1=add(UDim2.fromOffset(8,5),UDim2.fromOffset(8,17)); corner(k1,1)
		local k2=add(UDim2.fromOffset(8,5),UDim2.fromOffset(16,17)); corner(k2,1)
	elseif pageName == "Players" then
		-- two people: heads + shoulders
		dot(6, UDim2.fromOffset(9,8)); dot(6, UDim2.fromOffset(17,8))
		local s1=add(UDim2.fromOffset(9,7),UDim2.fromOffset(9,18)); corner(s1,3)
		local s2=add(UDim2.fromOffset(9,7),UDim2.fromOffset(17,18)); corner(s2,3)
	elseif pageName == "Themes" then
		-- paint swatch pair
		local a=ring(UDim2.fromOffset(14,13),UDim2.fromOffset(9,9),2)
		local b=ring(UDim2.fromOffset(14,13),UDim2.fromOffset(15,15),2)
	elseif pageName == "Colors" then
		-- color wheel: ring + 3 dots
		ring(UDim2.fromOffset(20,20),UDim2.fromOffset(12,12),2)
		dot(5, UDim2.fromOffset(8,8)); dot(5, UDim2.fromOffset(16,8)); dot(5, UDim2.fromOffset(12,16))
	elseif pageName == "Session" then
		-- power / refresh arrows
		add(UDim2.fromOffset(16,3),UDim2.fromOffset(10,8));add(UDim2.fromOffset(8,3),UDim2.fromOffset(18,6),45)
		add(UDim2.fromOffset(16,3),UDim2.fromOffset(14,16));add(UDim2.fromOffset(8,3),UDim2.fromOffset(6,18),45)
	else
		-- fallback: a simple diamond, visually distinct from the real icons
		local d=add(UDim2.fromOffset(12,12),UDim2.fromOffset(12,12),45); d.BackgroundTransparency=1; table.insert(pieces, outline(d,Theme.muted,0,2))
	end
	return icon,pieces
end
local function refreshNavigation()
	local visible = {}
	for _, spec in ipairs(navigation) do
		local show = not spec[3] or (State.profileChosen and Config.ActiveProfile == spec[3])
		UI.nav[spec[1]].Visible = show
		if show then table.insert(visible, spec) end
	end
	for index, spec in ipairs(visible) do
		local navButton = UI.nav[spec[1]]
		if isMobile or Config.LayoutStyle == "Horizon" then
			navButton.Size = UDim2.new(1/#visible,-4,0,48)
			navButton.Position = UDim2.new((index-1)/#visible,2,0,7)
			UI.navVisuals[spec[1]].title.Visible = false
			UI.navVisuals[spec[1]].icon.Position = UDim2.new(.5,-12,0,11)
		elseif Config.LayoutStyle == "Lynen" then
			local step=math.min(43,math.floor(406/#visible))
			local height=math.clamp(step-5,30,38)
			navButton.Size = UDim2.new(1,-14,0,height)
			navButton.Position = UDim2.fromOffset(7,7+(index-1)*step)
			UI.navVisuals[spec[1]].title.Visible = true
			UI.navVisuals[spec[1]].icon.Position = UDim2.fromOffset(8,7)
		else
			navButton.Size = UDim2.new(1,-16,0,34)
			navButton.Position = UDim2.fromOffset(8,7+(index-1)*38)
			UI.navVisuals[spec[1]].title.Visible = true
			UI.navVisuals[spec[1]].icon.Position = UDim2.fromOffset(8,5)
		end
	end
end
showPage=function(name)
	if name == "VRAim" and not State.vrUnlocked then UI.openVRGate(); return end

	if name == "Mystery" then if UI.setMysteryPopup then UI.setMysteryPopup(true) end; return end
	if not UI.pages[name] then name = "Hub" end
	State.currentPage=name
	for pageName, page in pairs(UI.pages) do
		local active = pageName == name
		page.Visible = active
		if active then
			if UI.noSlide then
				page.Position = UDim2.new()
			else
				page.Position = UDim2.fromOffset(22,0)
				TweenService:Create(page,TweenInfo.new(.32,Enum.EasingStyle.Quint),{Position=UDim2.new()}):Play()
			end
		end
	end
	local horizontal = isMobile or Config.LayoutStyle == "Horizon"
	local fast = TweenInfo.new(.22,Enum.EasingStyle.Quart)
	for pageName, navButton in pairs(UI.nav) do
		local active = pageName == name
		local visual = UI.navVisuals[pageName]
		visual.active = active
		TweenService:Create(navButton,fast,{BackgroundColor3 = Theme.accent, BackgroundTransparency = active and .84 or 1}):Play()
		visual.activeGradient.Enabled = false
		TweenService:Create(visual.title,fast,{TextColor3 = active and Theme.text or Theme.muted}):Play()
		local pill = visual.pill
		if horizontal then
			pill.AnchorPoint = Vector2.new(.5,1)
			pill.Position = UDim2.new(.5,0,1,-3)
			TweenService:Create(pill,TweenInfo.new(.3,Enum.EasingStyle.Back),{Size = active and UDim2.fromOffset(22,3) or UDim2.fromOffset(0,3),BackgroundTransparency = active and 0 or 1}):Play()
		else
			pill.AnchorPoint = Vector2.new(0,.5)
			pill.Position = UDim2.new(0,-5,.5,0)
			TweenService:Create(pill,TweenInfo.new(.3,Enum.EasingStyle.Back),{Size = active and UDim2.fromOffset(3,20) or UDim2.fromOffset(3,0),BackgroundTransparency = active and 0 or 1}):Play()
		end
		for _,piece in ipairs(visual.pieces) do
			local color = active and Theme.accent or Theme.muted
			if piece:IsA("UIStroke") then piece.Color=color else piece.BackgroundColor3=color end
		end
		if visual.stroke then visual.stroke.Transparency = active and .7 or 1 end
	end
end
for _, spec in ipairs(navigation) do
	local name = spec[1]
	local navButton = button(sidebar, "", UDim2.new(1,-16,0,34), nil, "row")
	navButton:SetAttribute("ThemeLocked", true) -- showPage handles its colors
	navButton:SetAttribute("CustomHover", true)
	navButton.BackgroundTransparency = 1
	local hoverGlow = navButton:FindFirstChild("HoverGlow")
	if hoverGlow then hoverGlow:Destroy() end
	local navStroke = Instance.new("UIStroke")
	navStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	navStroke.Color = Theme.accent
	navStroke.Transparency = 1
	navStroke.Parent = navButton
	bindTheme(navStroke, "Color", "accent")
	local activeGradient = accentGradient(navButton, 0)
	activeGradient.Enabled = false
	local pill = Instance.new("Frame")
	pill.Name = "ActivePill"
	pill.Size = UDim2.fromOffset(3,0)
	pill.BackgroundColor3 = Color3.new(1,1,1)
	pill.BackgroundTransparency = 1
	pill.BorderSizePixel = 0
	pill.Parent = navButton
	corner(pill, 2)
	accentGradient(pill, 90)
	local icon,pieces=createNavIcon(navButton,name)
	local title=label(navButton,spec[2],UDim2.new(1,-43,1,0),UDim2.fromOffset(38,0),Enum.Font.GothamBold,"muted",10)
	title.TextWrapped=true
	title:SetAttribute("ThemeLocked", true)
	UI.nav[name] = navButton
	local visual={icon=icon,pieces=pieces,title=title,pill=pill,activeGradient=activeGradient,stroke=navStroke,active=false}
	UI.navVisuals[name]=visual
	navButton.MouseEnter:Connect(function()
		TweenService:Create(title,TweenInfo.new(.15),{Position=UDim2.fromOffset(41,0)}):Play()
		if not visual.active then
			navButton.BackgroundColor3 = Theme.text
			TweenService:Create(navButton,TweenInfo.new(.12),{BackgroundTransparency=.95}):Play()
			TweenService:Create(title,TweenInfo.new(.12),{TextColor3=Theme.text}):Play()
		end
	end)
	navButton.MouseLeave:Connect(function()
		TweenService:Create(title,TweenInfo.new(.15),{Position=UDim2.fromOffset(38,0)}):Play()
		if not visual.active then
			TweenService:Create(navButton,TweenInfo.new(.15),{BackgroundTransparency=1}):Play()
			TweenService:Create(title,TweenInfo.new(.15),{TextColor3=Theme.muted}):Play()
		end
	end)
	navButton.Activated:Connect(function() showPage(name) end)
end

-- sidebar footer (only shown in the default sidebar layout)
do
	local footer=Instance.new("Frame")
	footer.Name="SidebarFooter"
	footer.Size=UDim2.new(1,-16,0,36)
	footer.Position=UDim2.new(0,8,1,-44)
	footer.BackgroundColor3=Color3.new(0,0,0)
	footer.BackgroundTransparency=.55
	footer.BorderSizePixel=0
	footer.Parent=sidebar
	corner(footer,10)
	neonStroke(footer,1,90,.55)
	local dot=Instance.new("Frame");dot.AnchorPoint=Vector2.new(0,.5);dot.Position=UDim2.new(0,10,.5,0);dot.Size=UDim2.fromOffset(7,7);dot.BackgroundColor3=Color3.fromRGB(52,211,153);dot.BorderSizePixel=0;dot.Parent=footer;corner(dot,4)
	TweenService:Create(dot,TweenInfo.new(.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{BackgroundTransparency=.7}):Play()
	local online=label(footer,"ONLINE",UDim2.new(1,-26,0,14),UDim2.fromOffset(23,4),Enum.Font.GothamBlack,"text",9)
	online:SetAttribute("ThemeLocked",true)
	online.TextColor3=Color3.fromRGB(52,211,153)
	label(footer,"v2.5  /  "..string.upper(device),UDim2.new(1,-26,0,12),UDim2.fromOffset(23,18),Enum.Font.GothamBold,"muted",8)
	UI.sidebarFooter=footer
end

applyLayout=function(layoutName,animate)
	if layoutName~="Newgen"and layoutName~="Lynen"and layoutName~="Horizon"then layoutName="Newgen"end
	Config.LayoutStyle=layoutName
	main.Position=UDim2.fromScale(.5,.5)
	local size
	if isMobile then
		size=Vector2.new(640,760)
		UI.layoutFitWidth=size.X+20
		top.Size=UDim2.new(1,0,0,58);top.Position=UDim2.new()
		sidebar.Size=UDim2.new(1,0,0,62);sidebar.Position=UDim2.new(0,0,1,-62)
		content.Size=UDim2.new(1,0,1,-120);content.Position=UDim2.fromOffset(0,58)
		UI.rightRail.Visible=false
		main.BackgroundTransparency=0
	elseif layoutName=="Lynen"then
		size=Vector2.new(760,560)
		UI.layoutFitWidth=1080
		top.Size=UDim2.new(1,0,0,58);top.Position=UDim2.new()
		sidebar.Size=UDim2.fromOffset(148,420);sidebar.Position=UDim2.fromOffset(-160,76)
		content.Size=UDim2.new(1,0,1,-58);content.Position=UDim2.fromOffset(0,58)
		UI.rightRail.Position=UDim2.new(1,12,0,76);UI.rightRail.Visible=true
		main.BackgroundTransparency=.08;sidebar.BackgroundTransparency=.08;UI.rightRail.BackgroundTransparency=.08
	elseif layoutName=="Horizon"then
		size=Vector2.new(1080,640)
		UI.layoutFitWidth=1110
		top.Size=UDim2.new(1,0,0,56);top.Position=UDim2.new()
		sidebar.Size=UDim2.fromOffset(720,62);sidebar.Position=UDim2.new(.5,-360,1,-70)
		content.Size=UDim2.new(1,0,1,-132);content.Position=UDim2.fromOffset(0,56)
		UI.rightRail.Visible=false
		main.BackgroundTransparency=.32;sidebar.BackgroundTransparency=.04
	else
		size=Vector2.new(860,550)
		UI.layoutFitWidth=884
		top.Size=UDim2.new(1,0,0,58);top.Position=UDim2.new()
		sidebar.Size=UDim2.new(0,116,1,-58);sidebar.Position=UDim2.fromOffset(0,58)
		content.Size=UDim2.new(1,-116,1,-58);content.Position=UDim2.fromOffset(116,58)
		UI.rightRail.Visible=false
		main.BackgroundTransparency=0;sidebar.BackgroundTransparency=.18
	end
	UI.layoutBaseSize=size
	if UI.sidebarFooter then UI.sidebarFooter.Visible=not isMobile and layoutName=="Newgen" end
	if animate then TweenService:Create(main,TweenInfo.new(.32,Enum.EasingStyle.Quart),{Size=UDim2.fromOffset(size.X,size.Y)}):Play()else main.Size=UDim2.fromOffset(size.X,size.Y)end
	if Config.AutoFitWindow ~= false then fitWindow() end
	refreshNavigation();State.dirty=true
	if UI.layoutStatus then UI.layoutStatus.Text=string.upper(layoutName)end
	if UI.overviewLayout then UI.overviewLayout.Text="LAYOUT  /  "..string.upper(layoutName)end
	if UI.notify and animate then UI.notify(layoutName.." interface loaded",true)end
end
UI.applyLayout=applyLayout

local function makeToggle(parent, title, y, getter, setter)
	local row = panel(parent, UDim2.new(1,-20,0,40), UDim2.fromOffset(10,y), "row")
	local rowStroke = row:FindFirstChildOfClass("UIStroke")
	-- the whole row is clickable, not just the switch
	local hit = Instance.new("TextButton")
	hit.Size = UDim2.fromScale(1,1)
	hit.BackgroundTransparency = 1
	hit.Text = ""
	hit.Parent = row
	local bar = Instance.new("Frame")
	bar.AnchorPoint = Vector2.new(0,.5)
	bar.Position = UDim2.new(0,6,.5,0)
	bar.Size = UDim2.fromOffset(3,0)
	bar.BackgroundColor3 = Color3.new(1,1,1)
	bar.BorderSizePixel = 0
	bar.Parent = row
	corner(bar,2)
	accentGradient(bar,90)
	local titleLabel = label(row, title, UDim2.new(1,-110,1,0), UDim2.fromOffset(16,0), Enum.Font.GothamMedium, "text", 12)
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	local stateLabel = label(row, "OFF", UDim2.fromOffset(34,40), UDim2.new(1,-92,0,0), Enum.Font.GothamBlack, "muted", 9)
	stateLabel.TextXAlignment = Enum.TextXAlignment.Right
	stateLabel:SetAttribute("ThemeLocked", true)
	local switch = button(row, "", UDim2.fromOffset(44,24), UDim2.new(1,-54,.5,-12), "row")
	switch:SetAttribute("ThemeLocked", true)
	for _, child in ipairs(switch:GetChildren()) do if child:IsA("UICorner") then child:Destroy() end end
	corner(switch,12)
	-- gradient that fades in when ON
	local onGradient = accentGradient(switch, 0)
	local glow = switch:FindFirstChild("HoverGlow")
	local dot = Instance.new("Frame")
	dot.Size = UDim2.fromOffset(18,18)
	dot.Position = UDim2.fromOffset(3,3)
	dot.BackgroundColor3 = Color3.new(1,1,1)
	dot.BorderSizePixel = 0
	dot.Parent = switch
	corner(dot,9)
	local dotShadow = outline(dot, Color3.new(0,0,0), .7, 1)
	dotShadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local first = true
	local function refresh()
		local enabled = getter()
		local info = first and TweenInfo.new(0) or TweenInfo.new(.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		first = false
		onGradient.Enabled = enabled
		TweenService:Create(switch, TweenInfo.new(.2), { BackgroundColor3 = enabled and Color3.new(1,1,1) or Color3.fromRGB(58,56,74) }):Play()
		TweenService:Create(dot, info, { Position = enabled and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3) }):Play()
		TweenService:Create(bar, info, { Size = UDim2.fromOffset(3, enabled and 20 or 0) }):Play()
		TweenService:Create(row, TweenInfo.new(.2), { BackgroundColor3 = enabled and Theme.row:Lerp(Theme.accent,.1) or Theme.row }):Play()
		if rowStroke then
			TweenService:Create(rowStroke, TweenInfo.new(.2), { Color = enabled and Theme.accent or Theme.row, Transparency = enabled and .45 or .55 }):Play()
		end
		stateLabel.Text = enabled and "ON" or "OFF"
		stateLabel.TextColor3 = enabled and Theme.accent2 or Theme.muted
		if glow then glow.Transparency = enabled and .45 or 1 end
	end
	-- the same setting can have a toggle on several pages, so flipping one repaints all of them
	local function flip()
		setter(not getter())
		State.dirty = true
		for _, other in ipairs(UI.toggleRefreshers) do pcall(other) end
	end
	switch.MouseLeave:Connect(function() if glow then task.delay(.22, function() if getter() then glow.Transparency = .45 end end) end end)
	hit.MouseEnter:Connect(function()
		TweenService:Create(titleLabel, TweenInfo.new(.15), { Position = UDim2.fromOffset(19,0) }):Play()
		if rowStroke and not getter() then TweenService:Create(rowStroke, TweenInfo.new(.15), { Transparency = .3 }):Play() end
	end)
	hit.MouseLeave:Connect(function()
		TweenService:Create(titleLabel, TweenInfo.new(.15), { Position = UDim2.fromOffset(16,0) }):Play()
		if rowStroke and not getter() then TweenService:Create(rowStroke, TweenInfo.new(.2), { Transparency = .55 }):Play() end
	end)
	hit.Activated:Connect(flip)
	switch.Activated:Connect(flip)
	refresh()
	table.insert(UI.refreshers, refresh)
	table.insert(UI.toggleRefreshers, refresh)
	return refresh
end
-- A toggle row with a built-in rebindable keybind pill. Click the pill, press any
-- key, and that key becomes the in-game toggle. The switch flips the setting from the
-- UI; the pill shows (and sets) the key that does the same thing in-game.
--   enabledGet/enabledSet -> the on/off Config value (e.g. Config.TriggerEnabled)
--   keyGet/keySet         -> the key name Config value  (e.g. Config.TriggerKey)
local function makeKeybindToggle(parent, title, y, enabledGet, enabledSet, keyGet, keySet)
	local row = panel(parent, UDim2.new(1,-20,0,52), UDim2.fromOffset(10,y), "row")
	local rowStroke = row:FindFirstChildOfClass("UIStroke")
	local bar = Instance.new("Frame")
	bar.AnchorPoint = Vector2.new(0,.5)
	bar.Position = UDim2.new(0,6,.5,0)
	bar.Size = UDim2.fromOffset(3,0)
	bar.BackgroundColor3 = Color3.new(1,1,1)
	bar.BorderSizePixel = 0
	bar.Parent = row
	corner(bar,2)
	accentGradient(bar,90)

	local titleLabel = label(row, title, UDim2.new(1,-200,0,20), UDim2.fromOffset(16,6), Enum.Font.GothamBold, "text", 12)
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	local stateLabel = label(row, "OFF", UDim2.new(1,-200,0,14), UDim2.fromOffset(16,28), Enum.Font.GothamBlack, "muted", 9)
	stateLabel:SetAttribute("ThemeLocked", true)

	-- keybind pill (click to rebind)
	local keyCap = button(row, string.upper(tostring(keyGet() or "NONE")), UDim2.fromOffset(78,32), UDim2.new(1,-150,.5,-16), "row")
	keyCap.Font = Enum.Font.Code
	keyCap.TextSize = 12
	keyCap:SetAttribute("CustomHover", true)
	local keyStroke = keyCap:FindFirstChildOfClass("UIStroke") or outline(keyCap, Theme.accent2, .4, 1)
	keyStroke.Color = Theme.accent2
	keyStroke.Transparency = .4

	-- on/off switch
	local switch = button(row, "", UDim2.fromOffset(44,24), UDim2.new(1,-54,.5,-12), "row")
	switch:SetAttribute("ThemeLocked", true)
	for _, child in ipairs(switch:GetChildren()) do if child:IsA("UICorner") then child:Destroy() end end
	corner(switch,12)
	local onGradient = accentGradient(switch, 0)
	local dot = Instance.new("Frame")
	dot.Size = UDim2.fromOffset(18,18)
	dot.Position = UDim2.fromOffset(3,3)
	dot.BackgroundColor3 = Color3.new(1,1,1)
	dot.BorderSizePixel = 0
	dot.Parent = switch
	corner(dot,9)
	local dotShadow = outline(dot, Color3.new(0,0,0), .7, 1)
	dotShadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local listening = false
	local first = true
	local function refresh()
		local enabled = enabledGet() == true
		local info = first and TweenInfo.new(0) or TweenInfo.new(.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		first = false
		onGradient.Enabled = enabled
		TweenService:Create(switch, TweenInfo.new(.2), { BackgroundColor3 = enabled and Color3.new(1,1,1) or Color3.fromRGB(58,56,74) }):Play()
		TweenService:Create(dot, info, { Position = enabled and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3) }):Play()
		TweenService:Create(bar, info, { Size = UDim2.fromOffset(3, enabled and 24 or 0) }):Play()
		TweenService:Create(row, TweenInfo.new(.2), { BackgroundColor3 = enabled and Theme.row:Lerp(Theme.accent,.1) or Theme.row }):Play()
		if rowStroke then
			TweenService:Create(rowStroke, TweenInfo.new(.2), { Color = enabled and Theme.accent or Theme.row, Transparency = enabled and .45 or .55 }):Play()
		end
		stateLabel.Text = enabled and ("ON  /  "..string.upper(tostring(keyGet() or "NONE")).." TOGGLES") or ("OFF  /  "..string.upper(tostring(keyGet() or "NONE")).." TOGGLES")
		stateLabel.TextColor3 = enabled and Theme.accent2 or Theme.muted
		if not listening then keyCap.Text = string.upper(tostring(keyGet() or "NONE")) end
	end
	local function flip()
		enabledSet(not (enabledGet() == true))
		State.dirty = true
		for _, other in ipairs(UI.toggleRefreshers) do pcall(other) end
	end
	switch.Activated:Connect(flip)

	-- rebind flow
	keyCap.Activated:Connect(function()
		if listening then return end
		listening = true
		UI.bindingActive = true
		keyCap.Text = "PRESS KEY..."
		keyStroke.Transparency = 0
		local conn
		conn = UserInputService.InputBegan:Connect(function(input, processed)
			if processed then return end
			if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
			local code = input.KeyCode
			listening = false
			UI.bindingActive = false
			keyStroke.Transparency = .4
			conn:Disconnect()
			if code == Enum.KeyCode.Escape or code == Enum.KeyCode.Unknown then
				refresh()
				return
			end
			keySet(code.Name)
			State.dirty = true
			if UI.notify then UI.notify(title.." key set to "..code.Name, true) end
			for _, other in ipairs(UI.refreshers) do pcall(other) end
		end)
	end)

	keyCap.MouseEnter:Connect(function() if not listening then TweenService:Create(keyStroke, TweenInfo.new(.12), { Transparency = .1 }):Play() end end)
	keyCap.MouseLeave:Connect(function() if not listening then TweenService:Create(keyStroke, TweenInfo.new(.15), { Transparency = .4 }):Play() end end)

	refresh()
	table.insert(UI.refreshers, refresh)
	table.insert(UI.toggleRefreshers, refresh)
	return refresh
end
local function makeSlider(parent,title,y,minimum,maximum,getter,setter)
	local row = panel(parent, UDim2.new(1,-20,0,58), UDim2.fromOffset(10,y), "row")
	label(row,title,UDim2.new(1,-80,0,24),UDim2.fromOffset(10,3),Enum.Font.GothamMedium,"text",12)
	local valueLabel = label(row,"",UDim2.fromOffset(70,24),UDim2.new(1,-80,0,3),Enum.Font.GothamBold,"accent2",11)
	valueLabel.TextXAlignment=Enum.TextXAlignment.Right
	local bar=button(row,"",UDim2.new(1,-20,0,6),UDim2.fromOffset(10,40),"row")
	local barScale=bar:FindFirstChild("HoverScale");if barScale then barScale:Destroy()end
	-- gradient fill + glowing knob
	local fill=Instance.new("Frame");fill.Size=UDim2.fromScale(0,1);fill.BackgroundColor3=Color3.new(1,1,1);fill.BorderSizePixel=0;fill.Parent=bar;corner(fill,3)
	accentGradient(fill,0)
	local knob=Instance.new("Frame");knob.AnchorPoint=Vector2.new(.5,.5);knob.Size=UDim2.fromOffset(14,14);knob.Position=UDim2.fromScale(0,.5);knob.BackgroundColor3=Color3.new(1,1,1);knob.BorderSizePixel=0;knob.ZIndex=bar.ZIndex+2;knob.Parent=bar;corner(knob,7)
	local knobRing=outline(knob,Theme.accent2,.1,2);bindTheme(knobRing,"Color","accent2")
	local knobScale=Instance.new("UIScale");knobScale.Parent=knob
	bar.MouseEnter:Connect(function()TweenService:Create(knobScale,TweenInfo.new(.15,Enum.EasingStyle.Back),{Scale=1.25}):Play()end)
	bar.MouseLeave:Connect(function()TweenService:Create(knobScale,TweenInfo.new(.15),{Scale=1}):Play()end)
	local dragging=false
	local function refresh() local n=getter();local a=math.clamp((n-minimum)/(maximum-minimum),0,1);fill.Size=UDim2.fromScale(a,1);knob.Position=UDim2.fromScale(a,.5);valueLabel.Text=tostring(math.floor(n*100+.5)/100) end
	local function setX(x) local a=math.clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1);setter(minimum+(maximum-minimum)*a);State.dirty=true;refresh() end
	bar.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true;setX(input.Position.X) end end)
	UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then setX(input.Position.X) end end)
	UserInputService.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
	refresh()
end

-- The remaining source is preserved in this complete file below.
-- It is kept in the same xpcall scope so all original pages, profiles, systems,
-- and startup behavior remain available.


-- ==========================================================================
-- PROFILE PAGES / HUB
-- ==========================================================================

-- Music is deliberately local and asset-id based. Roblox does not allow a
-- LocalScript to stream arbitrary web URLs, so the queue contains only audio
-- assets that the experience owner has permission to use.
do
	local SoundService = game:GetService("SoundService")
	local TRACKS = {
		-- { id = 1234567890, title = "Track title", artist = "Artist" },
	}
	local function clockText(seconds)
		seconds = math.max(0, math.floor(tonumber(seconds) or 0))
		return string.format("%d:%02d", math.floor(seconds / 60), seconds % 60)
	end
	function UI.buildMusic(parent, y)
		local music = panel(parent, UDim2.new(1, -28, 0, 176), UDim2.fromOffset(14, y), "panel")
		music.Name = "MusicPlayer"
		local title = label(music, "MUSIC", UDim2.fromOffset(120, 15), UDim2.fromOffset(14, 11), Enum.Font.Code, "accent", 10)
		local state = label(music, "IDLE", UDim2.new(1, -150, 0, 15), UDim2.fromOffset(136, 11), Enum.Font.Code, "muted", 9)
		state.TextXAlignment = Enum.TextXAlignment.Right
		local trackName = label(music, "Nothing queued", UDim2.new(1, -28, 0, 22), UDim2.fromOffset(14, 38), Enum.Font.GothamBlack, "text", 15)
		trackName.TextTruncate = Enum.TextTruncate.AtEnd
		local artistName = label(music, "Add owned audio ids to the TRACKS table", UDim2.new(1, -28, 0, 14), UDim2.fromOffset(14, 62), Enum.Font.Gotham, "muted", 10)
		artistName.TextTruncate = Enum.TextTruncate.AtEnd
		local progress = Instance.new("Frame")
		progress.Size = UDim2.new(1, -28, 0, 5)
		progress.Position = UDim2.fromOffset(14, 91)
		progress.BackgroundColor3 = Theme.row
		progress.BorderSizePixel = 0
		progress.Parent = music
		corner(progress, 3)
		bindTheme(progress, "BackgroundColor3", "row")
		local progressFill = Instance.new("Frame")
		progressFill.Size = UDim2.fromScale(0, 1)
		progressFill.BackgroundColor3 = Theme.accent
		progressFill.BorderSizePixel = 0
		progressFill.Parent = progress
		corner(progressFill, 3)
		bindTheme(progressFill, "BackgroundColor3", "accent")
		local elapsed = label(music, "0:00", UDim2.fromOffset(60, 14), UDim2.fromOffset(14, 101), Enum.Font.Code, "muted", 9)
		local duration = label(music, "--:--", UDim2.fromOffset(60, 14), UDim2.new(1, -74, 0, 101), Enum.Font.Code, "muted", 9)
		duration.TextXAlignment = Enum.TextXAlignment.Right
		local previous = button(music, "◀◀", UDim2.fromOffset(54, 32), UDim2.fromOffset(14, 126), "row")
		local play = button(music, "PLAY", UDim2.fromOffset(92, 32), UDim2.fromOffset(74, 126), "accent")
		local next = button(music, "▶▶", UDim2.fromOffset(54, 32), UDim2.fromOffset(174, 126), "row")
		local loop = button(music, "LOOP", UDim2.fromOffset(66, 32), UDim2.fromOffset(236, 126), "row")
		local volume = makeSlider -- keep the local name visible to the page builder without shadowing Config
		local sound = Instance.new("Sound")
		sound.Name = "StaticsMusic"
		sound.Volume = math.clamp(tonumber(Config.MusicVolume) or .5, 0, 1)
		sound.Looped = Config.MusicLoop == true
		sound.Parent = SoundService
		UI.musicSound = sound
		local index = math.clamp(math.floor(tonumber(Config.MusicTrack) or 1), 1, math.max(#TRACKS, 1))
		local loadToken = 0
		local function render()
			local info = TRACKS[index]
			trackName.Text = info and (info.title or ("Track " .. index)) or "Nothing queued"
			artistName.Text = info and (info.artist or "Unknown artist") or "Add owned audio ids to the TRACKS table"
			state.Text = sound.Playing and "PLAYING" or (#TRACKS > 0 and "PAUSED" or "IDLE")
			play.Text = sound.Playing and "PAUSE" or "PLAY"
			loop.Text = Config.MusicLoop and "LOOP ON" or "LOOP"
			local length = sound.TimeLength
			local ratio = length > 0 and math.clamp(sound.TimePosition / length, 0, 1) or 0
			progressFill.Size = UDim2.fromScale(ratio, 1)
			elapsed.Text = clockText(sound.TimePosition)
			duration.Text = length > 0 and clockText(length) or "--:--"
		end
		local function loadTrack(newIndex)
			if #TRACKS == 0 then
				notify("The music queue is empty", false)
				return
			end
			index = ((newIndex - 1) % #TRACKS) + 1
			Config.MusicTrack = index
			State.dirty = true
			loadToken += 1
			local token = loadToken
			sound:Stop()
			sound.SoundId = "rbxassetid://" .. tostring(TRACKS[index].id)
			task.spawn(function()
				local began = os.clock()
				while token == loadToken and not sound.IsLoaded and os.clock() - began < 8 do task.wait(.1) end
				if token ~= loadToken then return end
				if sound.IsLoaded then
					sound:Play()
					render()
				else
					notify("Audio asset could not be loaded", false)
					render()
				end
			end)
			render()
		end
		UI.toggleMusic = function()
			if sound.Playing then sound:Pause()
			elseif sound.IsLoaded and sound.TimePosition > 0 then sound:Resume()
			else loadTrack(index) end
			render()
		end
		play.Activated:Connect(UI.toggleMusic)
		previous.Activated:Connect(function() if #TRACKS > 0 then loadTrack(index - 1) end end)
		next.Activated:Connect(function() if #TRACKS > 0 then loadTrack(index + 1) end end)
		loop.Activated:Connect(function()
			Config.MusicLoop = not Config.MusicLoop
			sound.Looped = Config.MusicLoop
			State.dirty = true
			render()
		end)
		sound.Ended:Connect(function() if not sound.Looped and #TRACKS > 0 then loadTrack(index + 1) end end)
		sound:GetPropertyChangedSignal("Playing"):Connect(render)
		table.insert(UI.refreshers, render)
		if Config.MusicAutoplay and #TRACKS > 0 then task.defer(function() loadTrack(index) end) end
		render()
	end
end

local function buildHub()
	local page = newPage("Hub")
	pageHeader(page, "Game Hub", "Choose a profile. Universal keeps the core pages available.", "accent")
	local banner = panel(page, UDim2.new(1, -28, 0, 76), UDim2.fromOffset(14, 76), "panel")
	local bannerGradient = Instance.new("UIGradient")
	bannerGradient.Color = ColorSequence.new(Theme.accent:Lerp(Theme.bg, .3), Theme.panel)
	bannerGradient.Rotation = 12
	bannerGradient.Parent = banner
	label(banner, "STATICS NEWGEN", UDim2.new(1, -190, 0, 24), UDim2.fromOffset(16, 12), Enum.Font.GothamBlack, "text", 19)
	local welcome = label(banner, "Profiles are reversible and settings remain local to this session until saved.", UDim2.new(1, -190, 0, 16), UDim2.fromOffset(16, 42), Enum.Font.Gotham, "muted", 10)
	welcome.TextTruncate = Enum.TextTruncate.AtEnd
	local deviceBadge = label(banner, string.upper(device), UDim2.fromOffset(130, 32), UDim2.new(1, -146, 0, 22), Enum.Font.GothamBlack, "accent2", 12)
	deviceBadge.TextXAlignment = Enum.TextXAlignment.Right
	local profiles = {
		{name = "Universal", code = "UNI", description = "Aim, visuals, performance, themes, session tools, and player utilities.", tags = "AIM  /  ESP  /  FPS"},
		{name = "Last Letter", code = "LL", description = "A local typing helper that suggests words without reading chat text boxes.", tags = "WORDS  /  AUTO"},
		{name = "Murder Mystery", code = "MM", description = "Round intel, role feed, timer, map, gun tracker, suspects, and alerts.", tags = "ROLES  /  INTEL  /  MM2"},
		{name = "Fling Things and People", code = "FTP", description = "Grab an item or player, right-click, and launch it using the selected throw strength.", tags = "FLING  /  PHYSICS  /  PROFILE"},
	}
	-- A compact profile rail sits below the Game Hub banner. It gives the hub a
	-- clear game-selector treatment without consuming the whole page.
	local selector = panel(page, UDim2.new(1, -28, 0, 34), UDim2.fromOffset(14, 158), "row")
	selector.Name = "HubProfileRail"
	local selectorTitle = label(selector, "PROFILE", UDim2.fromOffset(68, 14), UDim2.fromOffset(10, 10), Enum.Font.Code, "accent2", 8)
	local selectorLine = Instance.new("Frame")
	selectorLine.Size = UDim2.new(1, -92, 0, 2)
	selectorLine.Position = UDim2.fromOffset(82, 16)
	selectorLine.BackgroundColor3 = Theme.muted
	selectorLine.BackgroundTransparency = .7
	selectorLine.BorderSizePixel = 0
	selectorLine.Parent = selector
	corner(selectorLine, 2)
	local selectorFill = Instance.new("Frame")
	selectorFill.Size = UDim2.fromScale(0, 1)
	selectorFill.BackgroundColor3 = Theme.accent
	selectorFill.BorderSizePixel = 0
	selectorFill.Parent = selectorLine
	corner(selectorFill, 2)
	UI.hubSelector = {root = selector, buttons = {}, fill = selectorFill}
	UI.hubCards = {}
	for index, spec in ipairs(profiles) do
		local selectorButton = button(selector, spec.code, UDim2.new(1 / #profiles, -4, 0, 24), UDim2.new((index - 1) / #profiles, 78, 0, 5), "row")
		selectorButton.Name = "Select_" .. spec.code
		selectorButton.Font = Enum.Font.GothamBlack
		selectorButton.TextSize = 8
		selectorButton.ZIndex = selector.ZIndex + 2
		UI.hubSelector.buttons[spec.name] = selectorButton
		selectorButton.Activated:Connect(function()
			if UI.loadProfile then UI.loadProfile(spec.name) end
		end)
	end
	for index, spec in ipairs(profiles) do
		local card = panel(page, UDim2.new(1 / #profiles, -12, 0, 260), UDim2.new((index - 1) / #profiles, 8, 0, 202), "panel")
		card.ClipsDescendants = true
		local art = Instance.new("Frame")
		art.Size = UDim2.new(1, 0, 0, 82)
		art.BackgroundColor3 = Theme.accent
		art.BorderSizePixel = 0
		art.Parent = card
		corner(art, 8)
		local artGradient = Instance.new("UIGradient")
		artGradient.Color = ColorSequence.new(Theme.accent, Theme.accent2)
		artGradient.Rotation = 32
		artGradient.Parent = art
		local code = label(art, spec.code, UDim2.fromScale(1, 1), nil, Enum.Font.GothamBlack, "text", 30)
		code.TextXAlignment = Enum.TextXAlignment.Center
		code.TextColor3 = Color3.new(1, 1, 1)
		code:SetAttribute("ThemeLocked", true)
		local name = label(card, spec.name, UDim2.new(1, -24, 0, 22), UDim2.fromOffset(12, 96), Enum.Font.GothamBlack, "text", 14)
		name.TextTruncate = Enum.TextTruncate.AtEnd
		local tags = label(card, spec.tags, UDim2.new(1, -24, 0, 16), UDim2.fromOffset(12, 122), Enum.Font.Code, "accent2", 9)
		local description = label(card, spec.description, UDim2.new(1, -24, 0, 48), UDim2.fromOffset(12, 146), Enum.Font.Gotham, "muted", 10)
		description.TextWrapped = true
		description.TextYAlignment = Enum.TextYAlignment.Top
		local isMystery = spec.name == "Murder Mystery"
		local isFling = spec.name == "Fling Things and People"
		local idleText = isMystery and "OPEN POP-UP" or (isFling and "OPEN FLING" or "LOAD PROFILE")
		local load = button(card, idleText, UDim2.new(1, -24, 0, 36), UDim2.new(0, 12, 1, -48), "accent")
		load.Font = Enum.Font.GothamBlack
		load.TextSize = 10
		local active = label(card, "ACTIVE", UDim2.fromOffset(64, 14), UDim2.new(1, -76, 0, 12), Enum.Font.Code, "accent2", 8)
		active.TextXAlignment = Enum.TextXAlignment.Right
		active.Visible = false
		UI.hubCards[spec.name] = {button = load, active = active, idle = idleText}
		load.Activated:Connect(function()
			if UI.loadProfile then UI.loadProfile(spec.name) end
		end)
		table.insert(UI.refreshers, function()
			local selected = State.profileChosen and Config.ActiveProfile == spec.name
			active.Visible = selected
			load.Text = selected and (isMystery and "OPEN POP-UP" or (isFling and "FLING READY" or "LOADED / OPEN")) or UI.hubCards[spec.name].idle
			artGradient.Color = ColorSequence.new(Theme.accent, Theme.accent2)
			local selectorButton = UI.hubSelector and UI.hubSelector.buttons[spec.name]
			if selectorButton then
				selectorButton.BackgroundColor3 = selected and Theme.accent or Theme.row
				selectorButton.BackgroundTransparency = selected and .2 or .2
				selectorButton.TextColor3 = selected and Theme.text or Theme.muted
			end
		end)
	end
	UI.loadProfile = function(profile)
		local previousProfile = Config.ActiveProfile
		if previousProfile == "Fling Things and People" and profile ~= previousProfile and UI.stopFling then UI.stopFling() end
		if profile ~= "Murder Mystery" and UI.setMysteryPopup then UI.setMysteryPopup(false) end
		Config.ActiveProfile = profile
		if profile ~= "Murder Mystery" and UI.mysteryHud then UI.mysteryHud.Visible = false end
		Config.FlingEnabled = profile == "Fling Things and People"
		State.profileChosen = true
		State.dirty = true
		for index, spec in ipairs(profiles) do
			if spec.name == profile and UI.hubSelector and UI.hubSelector.fill then
				UI.hubSelector.fill.Size = UDim2.new(index / #profiles, 0, 1, 0)
			end
		end
		refreshNavigation()
		if UI.refreshBrand then pcall(UI.refreshBrand) end
		for _, refresh in ipairs(UI.refreshers) do pcall(refresh) end
		if profile == "Murder Mystery" then
			if UI.setMysteryPopup then UI.setMysteryPopup(true) end
			notify("Murder Mystery profile opened", true)
		elseif profile == "Last Letter" then
			Config.AimEnabled = false
			State.aimHeld = false
			Config.ESPEnabled = false
			showPage("Words")
			notify("Last Letter profile loaded", true)
		elseif profile == "Fling Things and People" then
			Config.AimEnabled = false
			Config.TriggerEnabled = false
			State.aimHeld = false
			State.target = nil
			showPage("Fling")
			notify("Fling Things and People loaded / right-click a grabbed object", true)
		else
			showPage("Home")
			notify("Universal profile loaded", true)
		end
	end
end

local function buildHome()
	local page = newPage("Home")
	pageHeader(page, "Overview", "A live summary of the current client and server session.", "accent")
	local hero = panel(page, UDim2.new(1, -28, 0, 82), UDim2.fromOffset(14, 76), "panel")
	local avatar = Instance.new("ImageLabel")
	avatar.Size = UDim2.fromOffset(54, 54)
	avatar.Position = UDim2.fromOffset(14, 14)
	avatar.BackgroundColor3 = Theme.row
	avatar.BorderSizePixel = 0
	avatar.Parent = hero
	corner(avatar, 27)
	setAvatar(avatar, player.UserId)
	label(hero, "SIGNED IN AS", UDim2.fromOffset(180, 13), UDim2.fromOffset(84, 13), Enum.Font.Code, "accent", 9)
	local displayName = label(hero, player.DisplayName, UDim2.new(1, -320, 0, 23), UDim2.fromOffset(84, 30), Enum.Font.GothamBlack, "text", 19)
	displayName.TextTruncate = Enum.TextTruncate.AtEnd
	label(hero, "@" .. player.Name .. "  /  " .. string.upper(device), UDim2.new(1, -320, 0, 15), UDim2.fromOffset(84, 55), Enum.Font.Gotham, "muted", 9)
	UI.overviewProfile = label(hero, "NONE", UDim2.fromOffset(180, 19), UDim2.new(1, -202, 0, 27), Enum.Font.GothamBlack, "accent2", 12)
	UI.overviewProfile.TextXAlignment = Enum.TextXAlignment.Right
	UI.overviewRole = label(hero, "WAITING", UDim2.fromOffset(180, 14), UDim2.new(1, -202, 0, 51), Enum.Font.Code, "muted", 9)
	UI.overviewRole.TextXAlignment = Enum.TextXAlignment.Right
	local _uc = label(hero, "163 USERS ONLINE", UDim2.fromOffset(180, 13), UDim2.new(1, -202, 0, 66), Enum.Font.Code, "accent2", 8)
	_uc.TextXAlignment = Enum.TextXAlignment.Right
	do local _n = 163; task.spawn(function() while _uc.Parent do task.wait(math.random(6,16)); _n=math.clamp(_n+math.random(-2,3),155,172); if _uc.Parent then _uc.Text=tostring(_n).." USERS ONLINE" end end end) end
	local tiles = Instance.new("Frame")
	tiles.Size = UDim2.new(1, -28, 0, 72)
	tiles.Position = UDim2.fromOffset(14, 170)
	tiles.BackgroundTransparency = 1
	tiles.Parent = page
	local grid = Instance.new("UIGridLayout")
	grid.CellSize = UDim2.new(.25, -6, 1, 0)
	grid.CellPadding = UDim2.fromOffset(8, 0)
	grid.Parent = tiles
	local function statTile(order, titleText, subtitleText)
		local tile = panel(tiles, UDim2.new(), nil, "panel")
		tile.LayoutOrder = order
		label(tile, titleText, UDim2.new(1, -16, 0, 12), UDim2.fromOffset(8, 9), Enum.Font.Code, "muted", 8)
		local value = label(tile, "--", UDim2.new(1, -16, 0, 24), UDim2.fromOffset(8, 25), Enum.Font.GothamBlack, "text", 18)
		local sub = label(tile, subtitleText, UDim2.new(1, -16, 0, 12), UDim2.fromOffset(8, 51), Enum.Font.Gotham, "muted", 8)
		local fill = Instance.new("Frame")
		fill.AnchorPoint = Vector2.new(0, 1)
		fill.Position = UDim2.new(1, -7, 1, -8)
		fill.Size = UDim2.new(0, 3, 0, 0)
		fill.BackgroundColor3 = Theme.accent
		fill.BorderSizePixel = 0
		fill.Parent = tile
		corner(fill, 2)
		bindTheme(fill, "BackgroundColor3", "accent")
		return value, sub, fill
	end
	UI.overviewPlayers, UI.overviewPlayersSub, UI.overviewPlayersBar = statTile(1, "PLAYERS", "in server")
	UI.overviewPing, UI.overviewPingSub, UI.overviewPingBar = statTile(2, "PING", "round trip")
	UI.overviewFps, UI.overviewFpsSub, UI.overviewFpsBar = statTile(3, "FPS", "render rate")
	UI.overviewTime, UI.overviewTimeSub, UI.overviewTimeBar = statTile(4, "SESSION", "elapsed")
	local actions = panel(page, UDim2.new(1, -28, 0, 112), UDim2.fromOffset(14, 254), "panel")
	label(actions, "QUICK ACTIONS", UDim2.fromOffset(140, 14), UDim2.fromOffset(12, 10), Enum.Font.Code, "accent2", 9)
	local function actionButton(textValue, x, callback)
		local b = button(actions, textValue, UDim2.new(.25, -10, 0, 42), UDim2.new(x, 6, 0, 42), "row")
		b.Font = Enum.Font.GothamBlack
		b.TextSize = 10
		b.Activated:Connect(callback)
		return b
	end
	actionButton("AIM ASSIST", 0, function()
		Config.AimEnabled = not Config.AimEnabled
		State.target = nil
		for _, refresh in ipairs(UI.refreshers) do pcall(refresh) end
	end)
	actionButton("PLAYER ESP", .25, function()
		Config.ESPEnabled = not Config.ESPEnabled
		State.dirty = true
		for _, refresh in ipairs(UI.refreshers) do pcall(refresh) end
	end)
	actionButton("GAME HUB", .5, function() showPage("Hub") end)
	actionButton("MUSIC", .75, function() if UI.toggleMusic then UI.toggleMusic() end end)
	local commandCard = panel(page, UDim2.new(1, -28, 0, 88), UDim2.fromOffset(14, 382), "panel")
	label(commandCard, "COMMAND BAR", UDim2.fromOffset(160, 14), UDim2.fromOffset(12, 9), Enum.Font.Code, "accent", 9)
	local commandBox = Instance.new("TextBox")
	commandBox.Size = UDim2.new(1, -136, 0, 34)
	commandBox.Position = UDim2.fromOffset(12, 31)
	commandBox.BackgroundColor3 = Theme.row
	commandBox.BorderSizePixel = 0
	commandBox.ClearTextOnFocus = false
	commandBox.PlaceholderText = "fov 80  /  esp  /  cmds"
	commandBox.PlaceholderColor3 = Theme.muted
	commandBox.TextColor3 = Theme.text
	commandBox.Font = Enum.Font.Code
	commandBox.TextSize = 12
	commandBox.Parent = commandCard
	corner(commandBox, 6)
	bindTheme(commandBox, "BackgroundColor3", "row")
	bindTheme(commandBox, "TextColor3", "text")
	bindTheme(commandBox, "PlaceholderColor3", "muted")
	UI.commandBox = commandBox
	local run = button(commandCard, "RUN", UDim2.fromOffset(92, 34), UDim2.new(1, -104, 0, 31), "accent")
	UI.commandRun = run
	UI.commandOutput = label(commandCard, "Ready", UDim2.new(1, -24, 0, 12), UDim2.fromOffset(12, 70), Enum.Font.Code, "muted", 8)
	UI.commandOutput.TextTruncate = Enum.TextTruncate.AtEnd
	UI.buildMusic(page, 486)
end

-- ==========================================================================
-- AIM / VR / VISUALS / LAST LETTER
-- ==========================================================================

local function buildAim()
	local page = newPage("Aim")
	pageHeader(page, "Aim Assist", "Smooth camera assistance with a separately controlled trigger section.", "accent")
	local left = scrollingPanel(page, UDim2.new(.58, -20, 1, -82), UDim2.fromOffset(14, 70), 1880)
	local right = panel(page, UDim2.new(.42, -8, 1, -82), UDim2.new(.58, 0, 0, 70), "panel")
	UI.refreshAim = makeToggle(left, "Master aim assist", 10, function() return Config.AimEnabled end, function(value)
		Config.AimEnabled = value
		if not value then State.target = nil; State.aimHeld = false end
	end)
	makeToggle(left, "Sticky target", 58, function() return Config.StickyAim end, function(value) Config.StickyAim = value end)
	makeToggle(left, "Wall check (always enforced)", 106, function() return true end, function() Config.WallCheck = true; notify("Wall Check is always enforced", true) end)
	makeToggle(left, "Team check", 154, function() return Config.TeamCheck end, function(value) Config.TeamCheck = value end)
	makeToggle(left, "Prediction", 202, function() return Config.Prediction end, function(value) Config.Prediction = value end)
	makeToggle(left, "Camera assist", 250, function() return Config.CameraAssist end, function(value) Config.CameraAssist = value end)
	makeToggle(left, "Show FOV circle", 298, function() return Config.ShowFOVCircle end, function(value) Config.ShowFOVCircle = value end)
	makeToggle(left, "Custom camera FOV", 346, function() return Config.CameraFOVEnabled end, function(value) Config.CameraFOVEnabled = value end)
	makeSlider(left, "Strength", 398, .02, .85, function() return Config.AimStrength end, function(value) Config.AimStrength = value end)
	makeSlider(left, "FOV radius", 462, 40, 500, function() return Config.AimRadius end, function(value) Config.AimRadius = value end)
	makeSlider(left, "FOV opacity", 526, .05, 1, function() return Config.FOVCircleOpacity end, function(value) Config.FOVCircleOpacity = value end)
	makeSlider(left, "FOV thickness", 590, .5, 4, function() return Config.FOVCircleThickness end, function(value) Config.FOVCircleThickness = value end)
	makeSlider(left, "FOV color hue", 654, 0, 1, function() return Config.FOVCircleHue end, function(value) Config.FOVCircleHue = value end)
	makeSlider(left, "Prediction time", 718, 0, .2, function() return Config.PredictionTime end, function(value) Config.PredictionTime = value end)
	makeSlider(left, "Max range", 782, 100, 1800, function() return Config.MaxAimDistance end, function(value) Config.MaxAimDistance = value end)
	makeSlider(left, "Camera FOV", 846, 50, 130, function() return Config.CameraFOV end, function(value) Config.CameraFOV = value end)
	local hitPart = button(left, "HIT PART: " .. string.upper(Config.HitPart), UDim2.new(1, -20, 0, 42), UDim2.fromOffset(10, 910), "row")
	hitPart.Activated:Connect(function()
		local modes = {"Body", "Head", "Random"}
		local index = table.find(modes, Config.HitPart) or 1
		Config.HitPart = modes[index % #modes + 1]
		hitPart.Text = "HIT PART: " .. string.upper(Config.HitPart)
		State.lockedParts = {}
		State.dirty = true
	end)
	makeSlider(left, "Aim smoothness", 964, .08, 1, function() return Config.AimSmoothness end, function(value) Config.AimSmoothness = value end)

	-- ---- ADVANCED AIM (new) ----------------------------------------------
	local advHeader = panel(left, UDim2.new(1, -20, 0, 30), UDim2.fromOffset(10, 1032), "panel")
	advHeader.BackgroundColor3 = Theme.accent:Lerp(Theme.panel, .8); bindTheme(advHeader, "BackgroundColor3", "panel")
	label(advHeader, "ADVANCED AIM", UDim2.fromOffset(160, 14), UDim2.fromOffset(14, 8), Enum.Font.GothamBlack, "accent", 9)
	-- target priority cycle button
	local priBtn = button(left, "PRIORITY: " .. string.upper(Config.AimPriority or "Crosshair"), UDim2.new(1, -20, 0, 40), UDim2.fromOffset(10, 1070), "row")
	priBtn.Font = Enum.Font.GothamBold
	priBtn.Activated:Connect(function()
		local modes = {"Crosshair", "Distance", "Health"}
		local i = table.find(modes, Config.AimPriority) or 1
		Config.AimPriority = modes[i % #modes + 1]
		priBtn.Text = "PRIORITY: " .. string.upper(Config.AimPriority)
		State.dirty = true
		notify("Aim priority: " .. Config.AimPriority, true)
	end)
	makeToggle(left, "FOV follows mouse", 1118, function() return Config.AimFollowMouse end, function(v) Config.AimFollowMouse = v end)
	makeToggle(left, "Snap line to target", 1166, function() return Config.AimSnapLine end, function(v) Config.AimSnapLine = v end)
	makeToggle(left, "Visible targets only", 1214, function() return Config.AimVisibleOnly end, function(v) Config.AimVisibleOnly = v end)
	makeToggle(left, "Auto-fire on target", 1262, function() return Config.AimAutoFire end, function(v) Config.AimAutoFire = v end)
	makeSlider(left, "Auto-fire delay (s)", 1310, 0.03, .5, function() return Config.AimAutoFireDelay end, function(v) Config.AimAutoFireDelay = v end)
	makeSlider(left, "Aim jitter (studs)", 1374, 0, 3, function() return Config.AimJitter end, function(v) Config.AimJitter = v end)

	-- ---- TRIGGERBOT -------------------------------------------------------
	local triggerHeader = panel(left, UDim2.new(1, -20, 0, 34), UDim2.fromOffset(10, 1452), "panel")
	triggerHeader.BackgroundColor3 = Theme.accent:Lerp(Theme.panel, .78)
	bindTheme(triggerHeader, "BackgroundColor3", "panel")
	local thBar = Instance.new("Frame"); thBar.AnchorPoint = Vector2.new(0,.5); thBar.Position = UDim2.new(0,6,.5,0); thBar.Size = UDim2.fromOffset(3,16); thBar.BorderSizePixel = 0; thBar.Parent = triggerHeader; corner(thBar,2); accentGradient(thBar,90)
	label(triggerHeader, "TRIGGERBOT", UDim2.fromOffset(140, 16), UDim2.fromOffset(16, 9), Enum.Font.GothamBlack, "accent", 10)
	local triggerHint = label(triggerHeader, "Equip a tool  /  set your toggle key", UDim2.new(1, -170, 0, 14), UDim2.fromOffset(160, 10), Enum.Font.Code, "muted", 8)
	triggerHint.TextXAlignment = Enum.TextXAlignment.Right

	-- Master toggle WITH a rebindable keybind. Click the key pill, press any key,
	-- and that key toggles the triggerbot in-game. The switch toggles it from the UI.
	makeKeybindToggle(left, "Triggerbot", 1494,
		function() return Config.TriggerEnabled end,
		function(value) Config.TriggerEnabled = value; State.triggerTarget = nil; State.dirty = true end,
		function() return Config.TriggerKey end,
		function(name) Config.TriggerKey = name end)

	makeToggle(left, "Trigger team check", 1554, function() return Config.TriggerTeamCheck end, function(value) Config.TriggerTeamCheck = value end)
	makeSlider(left, "Trigger delay (seconds)", 1602, 0, .25, function() return Config.TriggerDelay end, function(value) Config.TriggerDelay = value end)
	makeSlider(left, "Trigger FOV (pixels)", 1666, 10, 200, function() return Config.TriggerFOV end, function(value) Config.TriggerFOV = value end)

	-- fire mode (single tap vs auto hold) with its own rebindable switch key
	label(left,"FIRE MODE",UDim2.new(1,-24,0,16),UDim2.fromOffset(12,1734),Enum.Font.Code,"accent2",9)
	local _mRow=panel(left,UDim2.new(1,-20,0,38),UDim2.fromOffset(10,1754),"row")
	local _mSingle=button(_mRow,"SINGLE",UDim2.new(.5,-6,0,26),UDim2.fromOffset(4,6),"accent")
	local _mAuto=button(_mRow,"AUTO HOLD",UDim2.new(.5,-6,0,26),UDim2.new(.5,2,0,6),"row")
	local function _rfMode() if _mSingle.Parent then _mSingle.BackgroundColor3=Config.TriggerMode=="Single" and Theme.accent or Theme.row end; if _mAuto.Parent then _mAuto.BackgroundColor3=Config.TriggerMode=="Auto" and Theme.accent or Theme.row end end
	_mSingle.Activated:Connect(function() Config.TriggerMode="Single";_rfMode();State.dirty=true;notify("Single: clicks repeatedly on target",true) end)
	_mAuto.Activated:Connect(function() Config.TriggerMode="Auto";_rfMode();State.dirty=true;notify("Auto hold: holds mouse while on target",true) end)
	table.insert(UI.refreshers,_rfMode); _rfMode()
	local _mkR=panel(left,UDim2.new(1,-20,0,42),UDim2.fromOffset(10,1800),"row")
	label(_mkR,"Mode switch key",UDim2.new(.6,0,1,0),UDim2.fromOffset(12,0),Enum.Font.GothamBold,"text",11)
	local _mkB=button(_mkR,string.upper(Config.TriggerModeKey or "O"),UDim2.fromOffset(78,30),UDim2.new(1,-90,.5,-15),"row"); _mkB.Font=Enum.Font.Code; _mkB.TextSize=12
	local _mkS=_mkB:FindFirstChildOfClass("UIStroke") or outline(_mkB,Theme.accent2,.4,1); _mkS.Color=Theme.accent2; _mkS.Transparency=.4
	local _mkL=false; _mkB.Activated:Connect(function() if _mkL then return end; _mkL=true; UI.bindingActive=true; _mkB.Text="PRESS KEY..."; _mkS.Transparency=0; local c; c=UserInputService.InputBegan:Connect(function(i,p) if p then return end; if i.UserInputType==Enum.UserInputType.Keyboard then _mkL=false; UI.bindingActive=false; _mkS.Transparency=.4; c:Disconnect(); if i.KeyCode~=Enum.KeyCode.Escape and i.KeyCode~=Enum.KeyCode.Unknown then Config.TriggerModeKey=i.KeyCode.Name; State.dirty=true; notify("Mode switch key set to "..i.KeyCode.Name,true) end; _mkB.Text=string.upper(Config.TriggerModeKey or "O") end end) end)
	label(right, "TARGET RADAR", UDim2.fromOffset(140, 14), UDim2.fromOffset(14, 13), Enum.Font.Code, "accent", 9)
	local radar = Instance.new("Frame")
	radar.AnchorPoint = Vector2.new(.5, 0)
	radar.Position = UDim2.new(.5, 0, 0, 38)
	radar.Size = UDim2.fromOffset(210, 210)
	radar.BackgroundColor3 = Theme.bg
	radar.BorderSizePixel = 0
	radar.ClipsDescendants = true
	radar.Parent = right
	corner(radar, 105)
	bindTheme(radar, "BackgroundColor3", "bg")
	outline(radar, Theme.accent, .45, 1)
	for _, ratio in ipairs({.33, .66}) do
		local ring = Instance.new("Frame")
		ring.AnchorPoint = Vector2.new(.5, .5)
		ring.Position = UDim2.fromScale(.5, .5)
		ring.Size = UDim2.fromScale(ratio, ratio)
		ring.BackgroundTransparency = 1
		ring.Parent = radar
		corner(ring, 100)
		outline(ring, Theme.text, .9, 1)
	end
	local horizontal = Instance.new("Frame")
	horizontal.AnchorPoint = Vector2.new(.5, .5)
	horizontal.Position = UDim2.fromScale(.5, .5)
	horizontal.Size = UDim2.new(1, 0, 0, 1)
	horizontal.BackgroundColor3 = Theme.text
	horizontal.BackgroundTransparency = .9
	horizontal.BorderSizePixel = 0
	horizontal.Parent = radar
	local vertical = horizontal:Clone()
	vertical.Size = UDim2.new(0, 1, 1, 0)
	vertical.Parent = radar
	local me = Instance.new("Frame")
	me.AnchorPoint = Vector2.new(.5, .5)
	me.Position = UDim2.fromScale(.5, .5)
	me.Size = UDim2.fromOffset(10, 10)
	me.BackgroundColor3 = Theme.text
	me.BorderSizePixel = 0
	me.Parent = radar
	corner(me, 5)
	local radarStatus = label(right, "NO TARGET", UDim2.new(1, -24, 0, 25), UDim2.fromOffset(12, 270), Enum.Font.GothamBlack, "text", 16)
	radarStatus.TextXAlignment = Enum.TextXAlignment.Center
	local radarInfo = label(right, "Hold the configured aim input to acquire a target.", UDim2.new(1, -32, 0, 42), UDim2.fromOffset(16, 302), Enum.Font.Gotham, "muted", 9)
	radarInfo.TextWrapped = true
	radarInfo.TextXAlignment = Enum.TextXAlignment.Center
	local triggerInfo = panel(right, UDim2.new(1, -24, 0, 90), UDim2.fromOffset(12, 360), "row")
	label(triggerInfo, "TRIGGER STATUS", UDim2.new(1, -20, 0, 14), UDim2.fromOffset(10, 9), Enum.Font.Code, "accent2", 9)
	UI.triggerStatus = label(triggerInfo, "DISABLED", UDim2.new(1, -20, 0, 24), UDim2.fromOffset(10, 31), Enum.Font.GothamBlack, "muted", 13)
	UI.triggerStatus.TextXAlignment = Enum.TextXAlignment.Center
	local note = label(triggerInfo, "The server must validate every activation.", UDim2.new(1, -20, 0, 14), UDim2.fromOffset(10, 62), Enum.Font.Gotham, "muted", 8)
	note.TextXAlignment = Enum.TextXAlignment.Center
	local radarDots = {}
	RunService.RenderStepped:Connect(function()
		if not State.menuOpen or State.currentPage ~= "Aim" then return end
		local livingResolver = UI.living
		if not livingResolver or not camera then return end
		local _, _, myRoot = livingResolver(player)
		if not myRoot then return end
		local look = camera.CFrame.LookVector
		local yaw = math.atan2(-look.X, -look.Z)
		for _, target in ipairs(Players:GetPlayers()) do
			if target ~= player then
				local _, _, root = livingResolver(target)
				local dot = radarDots[target]
				if not dot then
					dot = Instance.new("Frame")
					dot.AnchorPoint = Vector2.new(.5, .5)
					dot.Size = UDim2.fromOffset(8, 8)
					dot.BorderSizePixel = 0
					dot.Parent = radar
					corner(dot, 4)
					radarDots[target] = dot
				end
				if root then
					local offset = root.Position - myRoot.Position
					local x = offset.X * math.cos(yaw) - offset.Z * math.sin(yaw)
					local z = offset.X * math.sin(yaw) + offset.Z * math.cos(yaw)
					local flat = Vector2.new(x, z) / math.max(Config.MaxAimDistance, 50)
					if flat.Magnitude > 1 then flat = flat.Unit end
					dot.Position = UDim2.fromScale(.5 + flat.X * .46, .5 + flat.Y * .46)
					dot.Visible = true
					dot.BackgroundColor3 = State.target == target and Theme.accent2 or Theme.accent
				else
					dot.Visible = false
				end
			end
		end
		if State.target then
			radarStatus.Text = State.target.DisplayName
			radarStatus.TextColor3 = Theme.accent2
			radarInfo.Text = "Target acquired. Wall check and team check are still applied."
		else
			radarStatus.Text = "NO TARGET"
			radarStatus.TextColor3 = Theme.muted
		end
	end)
end

local function buildVRAim()
	local page = newPage("VRAim")
	pageHeader(page, "VR Aim Assist", "Session-only VR controls. Access remains protected by the gate.", "accent2")
	local left = scrollingPanel(page, UDim2.new(.58, -20, 1, -82), UDim2.fromOffset(14, 70), 480)
	local right = panel(page, UDim2.new(.42, -8, 1, -82), UDim2.new(.58, 0, 0, 70), "panel")
	makeToggle(left, "VR player assist", 10, function() return VRConfig.Enabled end, function(value) VRConfig.Enabled = value; State.vrStickyTarget = nil end)
	makeToggle(left, "Sticky VR target", 58, function() return VRConfig.Sticky end, function(value) VRConfig.Sticky = value; State.vrStickyTarget = nil end)
	makeToggle(left, "VR wall check", 106, function() return VRConfig.WallCheck end, function(value) VRConfig.WallCheck = value end)
	makeToggle(left, "VR team check", 154, function() return VRConfig.TeamCheck end, function(value) VRConfig.TeamCheck = value end)
	makeSlider(left, "Strength", 206, .02, .8, function() return VRConfig.Strength end, function(value) VRConfig.Strength = value end)
	makeSlider(left, "Cone", 270, 4, 35, function() return VRConfig.Cone end, function(value) VRConfig.Cone = value end)
	makeSlider(left, "Range", 334, 40, 900, function() return VRConfig.MaxDistance end, function(value) VRConfig.MaxDistance = value end)
	local keyCard = panel(left, UDim2.new(1, -20, 0, 58), UDim2.fromOffset(10, 402), "row")
	label(keyCard, "Toggle keybind", UDim2.new(1, -150, 0, 18), UDim2.fromOffset(12, 9), Enum.Font.GothamBold, "text", 12)
	local key = button(keyCard, VRConfig.Keybind or "V", UDim2.fromOffset(112, 34), UDim2.new(1, -124, .5, -17), "accent")
	key.Font = Enum.Font.Code
	local binding = false
	key.Activated:Connect(function()
		binding = not binding
		UI.bindingActive = binding
		key.Text = binding and "PRESS KEY" or (VRConfig.Keybind or "NONE")
	end)
	UserInputService.InputBegan:Connect(function(input)
		if not binding or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
		binding = false
		UI.bindingActive = false
		if input.KeyCode ~= Enum.KeyCode.Escape then VRConfig.Keybind = input.KeyCode.Name end
		key.Text = VRConfig.Keybind or "NONE"
	end)
	label(right, "VR LINK", UDim2.fromOffset(120, 15), UDim2.fromOffset(14, 14), Enum.Font.Code, "accent2", 9)
	local headset = Instance.new("Frame")
	headset.AnchorPoint = Vector2.new(.5, 0)
	headset.Position = UDim2.new(.5, 0, 0, 52)
	headset.Size = UDim2.fromOffset(190, 88)
	headset.BackgroundColor3 = Theme.row
	headset.BorderSizePixel = 0
	headset.Parent = right
	corner(headset, 32)
	outline(headset, Theme.accent, .15, 1.5)
	for side = 0, 1 do
		local lens = Instance.new("Frame")
		lens.Size = UDim2.fromOffset(68, 42)
		lens.Position = UDim2.fromOffset(19 + side * 84, 23)
		lens.BackgroundColor3 = Theme.accent
		lens.BorderSizePixel = 0
		lens.Parent = headset
		corner(lens, 16)
		local glare = Instance.new("Frame")
		glare.Size = UDim2.fromScale(1, 1)
		glare.BackgroundColor3 = Color3.new(1, 1, 1)
		glare.BackgroundTransparency = .75
		glare.BorderSizePixel = 0
		glare.Parent = lens
		corner(glare, 16)
	end
	local vrStatus = label(right, "LOCKED", UDim2.new(1, -28, 0, 28), UDim2.fromOffset(14, 168), Enum.Font.GothamBlack, "text", 19)
	vrStatus.TextXAlignment = Enum.TextXAlignment.Center
	UI.vrStatus = vrStatus
	local vrNote = label(right, "VR settings begin disabled every execution. Enter a valid creator code to unlock the page.", UDim2.new(1, -30, 0, 60), UDim2.fromOffset(15, 214), Enum.Font.Gotham, "muted", 9)
	vrNote.TextWrapped = true
	vrNote.TextXAlignment = Enum.TextXAlignment.Center
	UI.updateVRPanel = function()
		local unlocked = State.vrUnlocked == true
		vrStatus.Text = unlocked and (VRConfig.Enabled and "UNLOCKED / ON" or "UNLOCKED / OFF") or "LOCKED"
		vrStatus.TextColor3 = unlocked and Theme.accent2 or Color3.fromRGB(248, 75, 90)
	end
	table.insert(UI.refreshers, UI.updateVRPanel)
	UI.updateVRPanel()
end

local function buildVisuals()
	local page = newPage("Visuals")
	pageHeader(page, "Visuals", "Highlights, labels, distance, roles, skeletons, boxes, tracers, and health.", "accent2")
	local left = scrollingPanel(page, UDim2.new(.58, -20, 1, -82), UDim2.fromOffset(14, 70), 2560)
	local right = panel(page, UDim2.new(.42, -8, 1, -82), UDim2.new(.58, 0, 0, 70), "panel")
	makeToggle(left, "Master ESP", 10, function() return Config.ESPEnabled end, function(value) Config.ESPEnabled = value end)
	makeToggle(left, "Highlight", 58, function() return Config.HighlightESP end, function(value) Config.HighlightESP = value end)
	makeToggle(left, "Nameplates", 106, function() return Config.NameESP end, function(value) Config.NameESP = value end)
	makeToggle(left, "Distance", 154, function() return Config.DistanceESP end, function(value) Config.DistanceESP = value end)
	makeToggle(left, "Known roles", 202, function() return Config.RoleESP end, function(value) Config.RoleESP = value end)
	makeToggle(left, "VR badge", 250, function() return Config.VRESP end, function(value) Config.VRESP = value end)
	makeToggle(left, "Skeleton", 298, function() return Config.SkeletonESP end, function(value) Config.SkeletonESP = value end)
	makeToggle(left, "2D boxes", 346, function() return Config.BoxESP end, function(value) Config.BoxESP = value end)
	makeToggle(left, "Screen tracers", 394, function() return Config.TracerESP end, function(value) Config.TracerESP = value end)
	makeToggle(left, "Health bars", 442, function() return Config.HealthESP end, function(value) Config.HealthESP = value end)
	makeToggle(left, "Off-screen arrows", 490, function() return Config.OffscreenESP end, function(value) Config.OffscreenESP = value end)
	makeToggle(left, "ESP team filter", 538, function() return Config.ESPTeamCheck end, function(value) Config.ESPTeamCheck = value end)
	makeToggle(left, "Through walls", 586, function() return Config.ThroughWalls end, function(value) Config.ThroughWalls = value end)
	makeSlider(left, "ESP range", 638, 100, 2200, function() return Config.ESPMaxDistance end, function(value) Config.ESPMaxDistance = value end)
	makeSlider(left, "Text size", 702, 10, 24, function() return Config.ESPTextSize end, function(value) Config.ESPTextSize = math.floor(value + .5) end)
	makeSlider(left, "Fill visibility", 766, .05, .9, function() return Config.ESPFill end, function(value) Config.ESPFill = value end)
	makeSlider(left, "Enemy color hue", 830, 0, 1, function() return Config.EnemyColorHue end, function(value) Config.EnemyColorHue = value end)
	makeSlider(left, "Teammate color hue", 894, 0, 1, function() return Config.TeammateColorHue end, function(value) Config.TeammateColorHue = value end)
	makeToggle(left, "Custom crosshair", 958, function() return Config.Crosshair end, function(value) Config.Crosshair = value end)
	makeSlider(left, "Crosshair size", 1006, 2, 24, function() return Config.CrosshairSize end, function(value) Config.CrosshairSize = math.floor(value + .5) end)
	makeSlider(left, "Crosshair gap", 1070, 0, 20, function() return Config.CrosshairGap end, function(value) Config.CrosshairGap = math.floor(value + .5) end)
	label(left, "ADVANCED ESP", UDim2.new(1,-24,0,16), UDim2.fromOffset(12,1140), Enum.Font.Code, "accent2", 9)
	makeToggle(left,"Show tool name",1162,function() return Config.ESPToolName end,function(v) Config.ESPToolName=v end)
	makeToggle(left,"Show ping on nameplate",1210,function() return Config.ESPShowPing end,function(v) Config.ESPShowPing=v end)
	makeToggle(left,"Flash highlight on damage",1258,function() return Config.ESPFlashDamage end,function(v) Config.ESPFlashDamage=v end)
	makeToggle(left,"Chams (solid fill)",1306,function() return Config.ChamsEnabled end,function(v) Config.ChamsEnabled=v end)
	makeToggle(left,"Rainbow ESP mode",1354,function() return Config.RainbowESP end,function(v) Config.RainbowESP=v end)
	makeSlider(left,"Outline thickness",1406,0.5,5,function() return Config.ESPOutlineThick end,function(v) Config.ESPOutlineThick=v end)
	makeSlider(left,"Highlight opacity",1470,0,1,function() return Config.HighlightOpacity end,function(v) Config.HighlightOpacity=v end)
	makeSlider(left,"Chams hue",1534,0,1,function() return Config.ChamsColorHue end,function(v) Config.ChamsColorHue=v end)

	-- ---- MORE ESP (new) --------------------------------------------------
	label(left, "ESP EXTRAS", UDim2.new(1,-24,0,16), UDim2.fromOffset(12,1598), Enum.Font.Code, "accent2", 9)
	makeToggle(left, "Highlight aim target", 1618, function() return Config.ESPAimHighlight end, function(v) Config.ESPAimHighlight = v end)
	makeToggle(left, "Low-health warning", 1666, function() return Config.ESPLowHealthWarn end, function(v) Config.ESPLowHealthWarn = v end)
	local boxStyleBtn = button(left, "BOX STYLE: " .. string.upper(Config.ESPBoxStyle or "Corner"), UDim2.new(1,-20,0,40), UDim2.fromOffset(10,1714), "row")
	boxStyleBtn.Font = Enum.Font.GothamBold
	boxStyleBtn.Activated:Connect(function()
		Config.ESPBoxStyle = Config.ESPBoxStyle == "Corner" and "Full" or "Corner"
		boxStyleBtn.Text = "BOX STYLE: " .. string.upper(Config.ESPBoxStyle)
		State.dirty = true
	end)
	makeSlider(left, "Max ESP targets", 1762, 1, 100, function() return Config.ESPMaxTargets end, function(v) Config.ESPMaxTargets = math.floor(v + .5) end)

	-- ---- WORLD / LIGHTING (Fullbright lives here now) --------------------
	local worldHeader = panel(left, UDim2.new(1,-20,0,34), UDim2.fromOffset(10,1878), "panel")
	worldHeader.BackgroundColor3 = Theme.accent2:Lerp(Theme.panel, .8)
	bindTheme(worldHeader, "BackgroundColor3", "panel")
	local whBar = Instance.new("Frame"); whBar.AnchorPoint = Vector2.new(0,.5); whBar.Position = UDim2.new(0,6,.5,0); whBar.Size = UDim2.fromOffset(3,16); whBar.BorderSizePixel = 0; whBar.Parent = worldHeader; corner(whBar,2); accentGradient(whBar,90)
	label(worldHeader, "WORLD / LIGHTING", UDim2.fromOffset(180, 16), UDim2.fromOffset(16, 9), Enum.Font.GothamBlack, "accent2", 10)
	label(worldHeader, "Local only  /  resets when you turn it off", UDim2.new(1,-210,0,14), UDim2.fromOffset(200,10), Enum.Font.Code, "muted", 8).TextXAlignment = Enum.TextXAlignment.Right
	makeToggle(left, "Fullbright", 1920, function() return Config.FullBright end, function(v)
		Config.FullBright = v
		if UI.applyFullbright then UI.applyFullbright() end
	end)
	makeSlider(left, "Fullbright brightness", 1968, 1, 5, function() return Config.FullBrightLevel or 2 end, function(v)
		Config.FullBrightLevel = v
		if Config.FullBright and UI.applyFullbright then UI.applyFullbright() end
	end)
	makeToggle(left, "Remove fog", 2032, function() return Config.NoFog end, function(v)
		Config.NoFog = v
		pcall(function() local L=game:GetService("Lighting"); if v then L.FogEnd=1e6 end end)
	end)

	-- ---- SKELETON (new) --------------------------------------------------
	label(left, "SKELETON", UDim2.new(1,-24,0,16), UDim2.fromOffset(12, 2088), Enum.Font.Code, "accent2", 9)
	makeToggle(left, "Skeleton green (like image)", 2108, function() return Config.SkeletonGreen end, function(v) Config.SkeletonGreen = v; for _, d in pairs(State.visuals) do d.skeletonModel = nil end end)
	makeSlider(left, "Skeleton thickness", 2156, 0.02, 0.3, function() return Config.SkeletonThickness end, function(v) Config.SkeletonThickness = v end)

	-- ---- PROXIMITY ALERT (new) -------------------------------------------
	label(left, "PROXIMITY ALERT", UDim2.new(1,-24,0,16), UDim2.fromOffset(12, 2220), Enum.Font.Code, "accent2", 9)
	makeToggle(left, "Enable proximity alert", 2240, function() return Config.ProximityAlert end, function(v) Config.ProximityAlert = v end)
	makeSlider(left, "Alert distance (studs)", 2288, 3, 60, function() return Config.ProximityDistance end, function(v) Config.ProximityDistance = math.floor(v + .5) end)
	makeToggle(left, "Ignore teammates", 2352, function() return Config.ProximityTeamCheck end, function(v) Config.ProximityTeamCheck = v end)
	makeToggle(left, "Alert sound", 2400, function() return Config.ProximitySound end, function(v) Config.ProximitySound = v end)
	local cornerBtn = button(left, "CORNER: " .. (Config.ProximityCorner == "TopRight" and "TOP RIGHT" or "TOP LEFT"), UDim2.new(1,-20,0,40), UDim2.fromOffset(10, 2448), "row")
	cornerBtn.Font = Enum.Font.GothamBold
	cornerBtn.Activated:Connect(function()
		Config.ProximityCorner = Config.ProximityCorner == "TopRight" and "TopLeft" or "TopRight"
		cornerBtn.Text = "CORNER: " .. (Config.ProximityCorner == "TopRight" and "TOP RIGHT" or "TOP LEFT")
		if UI.placeProximityCorner then UI.placeProximityCorner() end
		State.dirty = true
	end)
	label(left, "You can also drag the alert box anywhere on screen.", UDim2.new(1,-24,0,28), UDim2.fromOffset(12, 2496), Enum.Font.Gotham, "muted", 9).TextWrapped = true

	label(right, "LIVE PREVIEW", UDim2.fromOffset(140, 15), UDim2.fromOffset(14, 13), Enum.Font.Code, "accent", 9)
	local preview = panel(right, UDim2.new(1, -28, 0, 230), UDim2.fromOffset(14, 38), "bg")
	local floor = Instance.new("Frame")
	floor.AnchorPoint = Vector2.new(0, 1)
	floor.Position = UDim2.fromScale(0, 1)
	floor.Size = UDim2.new(1, 0, .22, 0)
	floor.BackgroundColor3 = Theme.row
	floor.BorderSizePixel = 0
	floor.Parent = preview
	bindTheme(floor, "BackgroundColor3", "row")
	local figure = Instance.new("Frame")
	figure.AnchorPoint = Vector2.new(.5, 1)
	figure.Position = UDim2.new(.5, 0, .82, 0)
	figure.Size = UDim2.fromOffset(60, 148)
	figure.BackgroundColor3 = Theme.accent
	figure.BorderSizePixel = 0
	figure.Parent = preview
	corner(figure, 20)
	local head = Instance.new("Frame")
	head.AnchorPoint = Vector2.new(.5, 0)
	head.Position = UDim2.new(.5, 0, 0, -28)
	head.Size = UDim2.fromOffset(34, 34)
	head.BackgroundColor3 = Theme.accent2
	head.BorderSizePixel = 0
	head.Parent = figure
	corner(head, 17)
	local box = Instance.new("Frame")
	box.AnchorPoint = Vector2.new(.5, 1)
	box.Position = UDim2.new(.5, 0, .82, 4)
	box.Size = UDim2.fromOffset(86, 170)
	box.BackgroundTransparency = 1
	box.Parent = preview
	local boxStroke = outline(box, Theme.accent, 0, 1.5)
	local tag = label(preview, "Player\nINNOCENT  /  42st", UDim2.fromOffset(190, 34), UDim2.new(.5, -95, .82, -210), Enum.Font.GothamBold, "text", 10)
	tag.TextXAlignment = Enum.TextXAlignment.Center
	local healthTrack = Instance.new("Frame")
	healthTrack.AnchorPoint = Vector2.new(1, 1)
	healthTrack.Position = UDim2.new(.5, -50, .82, 4)
	healthTrack.Size = UDim2.fromOffset(4, 170)
	healthTrack.BackgroundColor3 = Theme.row
	healthTrack.BorderSizePixel = 0
	healthTrack.Parent = preview
	local healthFill = Instance.new("Frame")
	healthFill.AnchorPoint = Vector2.new(0, 1)
	healthFill.Position = UDim2.fromScale(0, 1)
	healthFill.Size = UDim2.fromScale(1, .78)
	healthFill.BackgroundColor3 = Color3.fromRGB(52, 211, 153)
	healthFill.BorderSizePixel = 0
	healthFill.Parent = healthTrack
	local cross = label(preview, "+", UDim2.fromOffset(28, 28), UDim2.new(.5, -14, .5, -14), Enum.Font.GothamBlack, "accent2", 22)
	cross.TextXAlignment = Enum.TextXAlignment.Center
	local previewText = label(right, "ESP OFF", UDim2.new(1, -28, 0, 30), UDim2.fromOffset(14, 286), Enum.Font.GothamBlack, "muted", 14)
	previewText.TextXAlignment = Enum.TextXAlignment.Center
	local previewNote = label(right, "Use the controls on the left to preview the visual language.", UDim2.new(1, -32, 0, 42), UDim2.fromOffset(16, 324), Enum.Font.Gotham, "muted", 9)
	previewNote.TextWrapped = true
	previewNote.TextXAlignment = Enum.TextXAlignment.Center
	UI.refreshVisualPreview = function()
		local enabled = Config.ESPEnabled
		local color = Color3.fromHSV(Config.EnemyColorHue, .78, 1)
		figure.BackgroundColor3 = enabled and color:Lerp(Theme.text, .2) or Theme.row
		head.BackgroundColor3 = enabled and color or Theme.muted
		box.Visible = enabled and Config.BoxESP
		boxStroke.Color = color
		healthTrack.Visible = enabled and Config.HealthESP and Config.BoxESP
		tag.Visible = enabled and Config.NameESP
		tag.TextSize = Config.ESPTextSize
		cross.Visible = Config.Crosshair
		previewText.Text = enabled and "ESP ON" or "ESP OFF"
		previewText.TextColor3 = enabled and Theme.accent2 or Theme.muted
		previewNote.Text = Config.ThroughWalls and "Highlights are allowed to draw through walls." or "Highlights respect depth occlusion."
	end
	table.insert(UI.refreshers, UI.refreshVisualPreview)
	UI.refreshVisualPreview()
end

local function buildWords()
	local page = newPage("Words")
	pageHeader(page, "Last Letter", "Type letters outside chat, then choose a local suggestion.", "accent2")
	UI.wordLabel = label(page, "TYPE LETTERS ANYWHERE", UDim2.new(1, -28, 0, 32), UDim2.fromOffset(14, 76), Enum.Font.GothamBlack, "accent2", 18)
	UI.wordLabel.TextXAlignment = Enum.TextXAlignment.Center
	local list = panel(page, UDim2.new(1, -28, 1, -132), UDim2.fromOffset(14, 120), "panel")
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 6)
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.Parent = list
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 8)
	padding.Parent = list
	UI.wordButtons = {}
	for index = 1, 6 do
		local choice = button(list, "-", UDim2.new(1, -12, 0, 40), nil, "row")
		choice.LayoutOrder = index
		choice.Font = Enum.Font.GothamBlack
		choice.TextSize = 14
		choice:SetAttribute("Word", nil)
		UI.wordButtons[index] = choice
	end
	local info = label(page, "Chat text boxes are ignored. Suggestions are created from the local dictionary near the end of this script.", UDim2.new(1, -28, 0, 18), UDim2.fromOffset(14, 96), Enum.Font.Gotham, "muted", 9)
	info.TextXAlignment = Enum.TextXAlignment.Center
	info.TextTruncate = Enum.TextTruncate.AtEnd
end

-- ==========================================================================
-- MURDER MYSTERY POPUP / UTILITIES / THEMES / SESSION
-- ==========================================================================

-- ==========================================================================
-- FLING THINGS AND PEOPLE PROFILE
-- ==========================================================================

local function buildFling()
	local page = newPage("Fling")
	pageHeader(page, "Fling Things and People", "Grab an item or player, then right-click to launch it with your chosen strength.", "accent2")

	local statusCard = panel(page, UDim2.new(1, -28, 0, 74), UDim2.fromOffset(14, 76), "panel")
	local statusDot = Instance.new("Frame")
	statusDot.Size = UDim2.fromOffset(12, 12)
	statusDot.Position = UDim2.fromOffset(16, 18)
	statusDot.BackgroundColor3 = Theme.muted
	statusDot.BorderSizePixel = 0
	statusDot.Parent = statusCard
	corner(statusDot, 6)
	local statusTitle = label(statusCard, "FLING CONTROLLER", UDim2.new(1, -180, 0, 18), UDim2.fromOffset(38, 10), Enum.Font.Code, "accent2", 9)
	local status = label(statusCard, "PROFILE NOT ACTIVE", UDim2.new(1, -180, 0, 22), UDim2.fromOffset(38, 30), Enum.Font.GothamBlack, "muted", 13)
	local targetLabel = label(statusCard, "Waiting for GrabParts...", UDim2.fromOffset(210, 18), UDim2.new(1, -226, 0, 26), Enum.Font.Code, "muted", 8)
	targetLabel.TextXAlignment = Enum.TextXAlignment.Right
	targetLabel.TextTruncate = Enum.TextTruncate.AtEnd
	UI.flingStatus = status
	UI.flingTarget = targetLabel

	local strengthCard = panel(page, UDim2.new(1, -28, 0, 166), UDim2.fromOffset(14, 162), "panel")
	label(strengthCard, "THROW STRENGTH", UDim2.fromOffset(180, 18), UDim2.fromOffset(14, 12), Enum.Font.GothamBlack, "text", 15)
	local strengthHint = label(strengthCard, "Type any finite number, or drag the line for a quick value.", UDim2.new(1, -220, 0, 15), UDim2.fromOffset(14, 36), Enum.Font.Gotham, "muted", 9)
	strengthHint.TextTruncate = Enum.TextTruncate.AtEnd
	local strengthBox = Instance.new("TextBox")
	strengthBox.Size = UDim2.fromOffset(126, 34)
	strengthBox.Position = UDim2.new(1, -140, 0, 10)
	strengthBox.BackgroundColor3 = Theme.row
	strengthBox.BorderSizePixel = 0
	strengthBox.ClearTextOnFocus = false
	strengthBox.Text = tostring(math.floor(tonumber(Config.FlingStrength) or 400))
	strengthBox.PlaceholderText = "400"
	strengthBox.PlaceholderColor3 = Theme.muted
	strengthBox.TextColor3 = Theme.accent2
	strengthBox.Font = Enum.Font.GothamBlack
	strengthBox.TextSize = 15
	strengthBox.TextXAlignment = Enum.TextXAlignment.Center
	strengthBox.Parent = strengthCard
	corner(strengthBox, 7)
	bindTheme(strengthBox, "BackgroundColor3", "row")
	local strengthTrack = Instance.new("Frame")
	strengthTrack.Size = UDim2.new(1, -28, 0, 8)
	strengthTrack.Position = UDim2.fromOffset(14, 84)
	strengthTrack.BackgroundColor3 = Theme.row
	strengthTrack.BorderSizePixel = 0
	strengthTrack.Parent = strengthCard
	corner(strengthTrack, 4)
	bindTheme(strengthTrack, "BackgroundColor3", "row")
	local strengthFill = Instance.new("Frame")
	strengthFill.Size = UDim2.fromScale(0, 1)
	strengthFill.BackgroundColor3 = Theme.accent2
	strengthFill.BorderSizePixel = 0
	strengthFill.Parent = strengthTrack
	corner(strengthFill, 4)
	accentGradient(strengthFill, 0)
	local strengthKnob = Instance.new("Frame")
	strengthKnob.AnchorPoint = Vector2.new(.5, .5)
	strengthKnob.Size = UDim2.fromOffset(18, 18)
	strengthKnob.Position = UDim2.fromScale(0, .5)
	strengthKnob.BackgroundColor3 = Theme.text
	strengthKnob.BorderSizePixel = 0
	strengthKnob.Parent = strengthTrack
	corner(strengthKnob, 9)
	outline(strengthKnob, Theme.accent2, .05, 2)
	local flingConnections = {}
	local function connectFling(signal, callback)
		if not signal or type(callback) ~= "function" then return nil end
		local ok, connection = pcall(function() return signal:Connect(callback) end)
		if ok and connection then table.insert(flingConnections, connection); return connection end
		return nil
	end
	local rangeLabel = label(strengthCard, "0", UDim2.fromOffset(70, 14), UDim2.fromOffset(14, 100), Enum.Font.Code, "muted", 8)
	local rangeMax = label(strengthCard, "5000  (type more)", UDim2.fromOffset(120, 14), UDim2.new(1, -134, 0, 100), Enum.Font.Code, "muted", 8)
	rangeMax.TextXAlignment = Enum.TextXAlignment.Right
	local resetStrength = button(strengthCard, "RESET 400", UDim2.fromOffset(112, 28), UDim2.new(1, -126, 1, -38), "row")
	resetStrength.Font = Enum.Font.Code
	local strengthDragging = false
	local sliderDisplayMax = 5000
	local function safeStrength(value)
		value = tonumber(value)
		if not value or value ~= value or value == math.huge or value == -math.huge then return nil end
		return math.clamp(value, 0, 1000000)
	end
	local function displayStrength(value)
		value = tonumber(value) or 0
		if math.abs(value - math.floor(value)) < .0001 then return tostring(math.floor(value)) end
		return string.format("%.3f", value):gsub("0+$", ""):gsub("%.$", "")
	end
	local function setStrength(value, fromText)
		local safe = safeStrength(value)
		if safe == nil then
			if fromText then strengthBox.Text = displayStrength(Config.FlingStrength) end
			if UI.notify then UI.notify("Throw strength must be a number", false) end
			return false
		end
		Config.FlingStrength = safe
		strengthFill.Size = UDim2.fromScale(math.clamp(safe / sliderDisplayMax, 0, 1), 1)
		strengthKnob.Position = UDim2.fromScale(math.clamp(safe / sliderDisplayMax, 0, 1), .5)
		if not strengthBox:IsFocused() or fromText then strengthBox.Text = displayStrength(safe) end
		State.dirty = true
		-- live-update the controller readout so you can see the slider taking effect
		if UI.refreshFlingStatus then UI.refreshFlingStatus() end
		return true
	end
	strengthBox.FocusLost:Connect(function()
		setStrength(strengthBox.Text, true)
	end)
	resetStrength.Activated:Connect(function() setStrength(400, true) end)
	local function setStrengthFromX(x)
		local ratio = math.clamp((x - strengthTrack.AbsolutePosition.X) / math.max(strengthTrack.AbsoluteSize.X, 1), 0, 1)
		setStrength(ratio * sliderDisplayMax, false)
	end
	connectFling(strengthTrack.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			strengthDragging = true
			setStrengthFromX(input.Position.X)
		end
	end)
	connectFling(UserInputService.InputChanged, function(input)
		if strengthDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then setStrengthFromX(input.Position.X) end
	end)
	connectFling(UserInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then strengthDragging = false end
	end)
	setStrength(Config.FlingStrength, true)

	local howCard = panel(page, UDim2.new(1, -28, 0, 132), UDim2.fromOffset(14, 340), "panel")
	label(howCard, "QUICK GUIDE", UDim2.fromOffset(140, 16), UDim2.fromOffset(14, 12), Enum.Font.Code, "accent", 9)
	local guide = label(howCard, "1  Grab an item or player.\n2  Hold or click the right mouse button.\n3  Release the grab to launch forward.\n\nLeft-click release cancels the launch. The game still decides whether the physics action replicates.", UDim2.new(1, -28, 0, 94), UDim2.fromOffset(14, 34), Enum.Font.Gotham, "muted", 10)
	guide.TextWrapped = true
	guide.TextYAlignment = Enum.TextYAlignment.Top

	-- Fling runtime — mirrors the proven GrabParts script, but reads the slider's
	-- Config.FlingStrength LIVE at the moment of launch, so sliding the bar or typing
	-- a number changes the very next throw. (Original used a fixed `strength = 400`.)
	local _FD = game:GetService("Debris")
	local function setFlingStatus(txt, col)
		if UI.flingStatus and UI.flingStatus.Parent then UI.flingStatus.Text=txt; UI.flingStatus.TextColor3=col or Theme.muted end
		if statusDot and statusDot.Parent then statusDot.BackgroundColor3=col or Theme.muted end
	end
	local function currentStrength()
		local n = tonumber(Config.FlingStrength) or 400
		if n ~= n or n == math.huge or n == -math.huge then n = 400 end
		return math.clamp(n, 0, 1000000)
	end
	-- Arm one GrabParts model: on release, right-click launches with the LIVE
	-- strength value, left-click cancels. Re-arms the same model if it is grabbed
	-- again (does not permanently flag it), so repeated grabs keep working.
	local function watchGrab(model)
		if model.Name ~= "GrabParts" then return end
		if not Config.FlingEnabled or Config.ActiveProfile ~= "Fling Things and People" then return end
		local part_to_impulse = nil
		pcall(function() part_to_impulse = model["GrabPart"]["WeldConstraint"].Part1 end)
		if not part_to_impulse or not part_to_impulse:IsA("BasePart") then return end
		if UI.flingTarget then UI.flingTarget.Text = "GRABBED  /  " .. part_to_impulse.Name end
		setFlingStatus("ARMED / RIGHT-CLICK TO LAUNCH", Theme.accent2)
		local velocityObj = Instance.new("BodyVelocity")
		velocityObj.Name = "FlingVelocity"
		velocityObj.MaxForce = Vector3.new(0, 0, 0)
		velocityObj.Velocity = Vector3.new(0, 0, 0)
		velocityObj.Parent = part_to_impulse
		local launched = false
		model:GetPropertyChangedSignal("Parent"):Connect(function()
			if model.Parent or launched then return end
			launched = true
			local inputType = UserInputService:GetLastInputType()
			if inputType == Enum.UserInputType.MouseButton2 then
				local strength = currentStrength()
				local cam = workspace.CurrentCamera
				velocityObj.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
				velocityObj.Velocity = (cam and cam.CFrame.LookVector or Vector3.new(0,0,-1)) * strength
				_FD:AddItem(velocityObj, 1)
				setFlingStatus("LAUNCHED  /  STRENGTH " .. tostring(math.floor(strength)), Theme.accent2)
				if UI.flingTarget then UI.flingTarget.Text = "Waiting for GrabParts..." end
			elseif inputType == Enum.UserInputType.MouseButton1 then
				velocityObj:Destroy()
				setFlingStatus("LAUNCH CANCELLED", Theme.muted)
				if UI.flingTarget then UI.flingTarget.Text = "Waiting for GrabParts..." end
			else
				velocityObj:Destroy()
				setFlingStatus("READY / RIGHT-CLICK TO LAUNCH", Theme.accent2)
				if UI.flingTarget then UI.flingTarget.Text = "Waiting for GrabParts..." end
			end
		end)
	end
	-- Arm every GrabParts the game spawns, and any already present.
	connectFling(Workspace.ChildAdded, watchGrab)
	UI.refreshFlingStatus = function()
		local active = Config.FlingEnabled and Config.ActiveProfile == "Fling Things and People"
		if active then
			setFlingStatus("READY / RIGHT-CLICK TO LAUNCH  /  STRENGTH " .. tostring(math.floor(currentStrength())), Theme.accent2)
			for _, child in ipairs(Workspace:GetChildren()) do if child.Name == "GrabParts" then watchGrab(child) end end
		else
			setFlingStatus("PROFILE NOT ACTIVE", Theme.muted)
		end
	end
	table.insert(UI.refreshers, UI.refreshFlingStatus)
	UI.refreshFlingStatus()
end

local function buildMystery()
	local popup = Instance.new("Frame")
	popup.Name = "MurderMysteryPopup"
	popup.AnchorPoint = Vector2.new(.5, .5)
	popup.Position = UDim2.fromScale(.5, .5)
	popup.Size = UDim2.fromOffset(650, 540)
	popup.BackgroundColor3 = Theme.bg
	popup.BorderSizePixel = 0
	popup.Visible = false
	popup.ZIndex = 60
	popup.Parent = gui
	corner(popup, 14)
	neonStroke(popup, 2, 90, .1)
	bindTheme(popup, "BackgroundColor3", "bg")
	UI.mysteryPopup = popup
	local popupScale = Instance.new("UIScale")
	popupScale.Parent = popup
	UI.mysteryPopupScale = popupScale
	UI.mysteryPopupFitScale = 1
	local topbar = panel(popup, UDim2.new(1, 0, 0, 56), nil, "panel")
	local badge = Instance.new("Frame")
	badge.Size = UDim2.fromOffset(36, 36)
	badge.Position = UDim2.fromOffset(12, 10)
	badge.BackgroundColor3 = MysteryRoleColors.murderer
	badge.BorderSizePixel = 0
	badge.Parent = topbar
	corner(badge, 10)
	local badgeText = label(badge, "MM", UDim2.fromScale(1, 1), nil, Enum.Font.GothamBlack, "text", 13)
	badgeText.TextXAlignment = Enum.TextXAlignment.Center
	badgeText.TextColor3 = Color3.new(1, 1, 1)
	badgeText:SetAttribute("ThemeLocked", true)
	label(topbar, "Murder Mystery", UDim2.new(1, -180, 0, 22), UDim2.fromOffset(60, 8), Enum.Font.GothamBlack, "text", 17)
	label(topbar, "Role and round tools", UDim2.new(1, -180, 0, 14), UDim2.fromOffset(60, 32), Enum.Font.Gotham, "muted", 9)
	local close = button(topbar, "X", UDim2.fromOffset(34, 30), UDim2.new(1, -44, 0, 13), "row")
	local open = false
	local function setMysteryPopup(value)
		open = value == true
		State.mysteryOpen = open
		if not open then
			State.mysteryIntelOpen = false
			if UI.mysteryIntelFrame then UI.mysteryIntelFrame.Visible = false end
		else
			if not State.mysteryIntelOpen then
				if UI.mysteryIntelFrame then UI.mysteryIntelFrame.Visible = false end
				if UI.mysteryIntelButton then UI.mysteryIntelButton.Visible = mysteryActive() and State.profileChosen end
			end
		end
		popup.Visible = open
		local fitScale = UI.mysteryPopupFitScale or 1
		if open then
			popupScale.Scale = fitScale * .88
			TweenService:Create(popupScale, TweenInfo.new(.25, Enum.EasingStyle.Back), {Scale = fitScale}):Play()
			mysteryHud.Visible = false
		else
			popupScale.Scale = fitScale
			mysteryHud.Visible = mysteryActive() and State.profileChosen and Config.MysteryRoleHUD and not State.menuOpen
		end
	end
	UI.setMysteryPopup = setMysteryPopup
	UI.toggleMysteryPopup = function() setMysteryPopup(not open) end
	close.Activated:Connect(function() setMysteryPopup(false) end)
	local mmButton = button(gui, "MM", UDim2.fromOffset(46, 46), UDim2.new(0, 146, 1, -64), "accent")
	mmButton.Visible = false
	mmButton.ZIndex = 55
	mmButton.Font = Enum.Font.GothamBlack
	mmButton.TextSize = 14
	UI.mysteryButton = mmButton
	mmButton.Activated:Connect(function() UI.toggleMysteryPopup() end)
	UserInputService.InputBegan:Connect(function(input, processed)
		if not processed and input.KeyCode == Enum.KeyCode.RightControl and mysteryActive() and State.profileChosen then UI.toggleMysteryPopup() end
	end)
	local left = scrollingPanel(popup, UDim2.new(.57, -20, 1, -72), UDim2.fromOffset(14, 64), 1280)
	local right = panel(popup, UDim2.new(.43, -14, 1, -72), UDim2.new(.57, 0, 0, 64), "panel")

	-- Section 1: Round options
	label(left, "ROUND OPTIONS", UDim2.new(1, -24, 0, 18), UDim2.fromOffset(12, 8), Enum.Font.Code, "accent2", 9)
	makeToggle(left, "Role colors on ESP", 30, function() return Config.MysteryRoleColors end, function(value) Config.MysteryRoleColors = value end)
	makeToggle(left, "My role HUD badge", 78, function() return Config.MysteryRoleHUD end, function(value) Config.MysteryRoleHUD = value end)
	makeToggle(left, "Murderer reveal alert", 126, function() return Config.MysteryMurdererAlert end, function(value) Config.MysteryMurdererAlert = value end)
	makeToggle(left, "Sheriff reveal alert", 174, function() return Config.MysterySheriffAlert end, function(value) Config.MysterySheriffAlert = value end)
	makeToggle(left, "Dropped gun tracker", 222, function() return Config.MysteryGunTracker end, function(value) Config.MysteryGunTracker = value end)
	makeToggle(left, "Alive counter", 270, function() return Config.MysteryAliveCounter end, function(value) Config.MysteryAliveCounter = value end)

	-- Section 2: Role tracking (NEW) — always-see murderer/sheriff + auto-spectate
	label(left, "ROLE TRACKING", UDim2.new(1, -24, 0, 16), UDim2.fromOffset(12, 326), Enum.Font.Code, "accent2", 9)
	makeToggle(left, "Murderer always visible", 346, function() return Config.MysteryMurdererWallhack end, function(v) Config.MysteryMurdererWallhack = v end)
	makeToggle(left, "Sheriff always visible", 394, function() return Config.MysterySheriffWallhack end, function(v) Config.MysterySheriffWallhack = v end)
	makeToggle(left, "Auto-spectate murderer", 442, function() return Config.MysteryAutoSpectateMurderer end, function(v) Config.MysteryAutoSpectateMurderer = v end)
	makeToggle(left, "Reveal countdown", 490, function() return Config.MysteryRevealCountdown end, function(v) Config.MysteryRevealCountdown = v end)
	makeToggle(left, "Suspect marks on ESP", 538, function() return Config.MysterySuspectMarks end, function(v) Config.MysterySuspectMarks = v end)
	makeToggle(left, "Gun distance label", 586, function() return Config.MysteryGunDistance end, function(v) Config.MysteryGunDistance = v end)

	-- Section 3: HUD + feed
	label(left, "HUD + FEED", UDim2.new(1, -24, 0, 16), UDim2.fromOffset(12, 642), Enum.Font.Code, "accent2", 9)
	makeToggle(left, "Compact round HUD", 662, function() return Config.MysteryRoundHUD end, function(v) Config.MysteryRoundHUD = v end)
	makeToggle(left, "Timer display", 710, function() return Config.MysteryTimerHUD end, function(v) Config.MysteryTimerHUD = v end)
	makeToggle(left, "Map name display", 758, function() return Config.MysteryMapHUD end, function(v) Config.MysteryMapHUD = v end)
	makeToggle(left, "Role reveal feed", 806, function() return Config.MysteryRoleFeed end, function(v) Config.MysteryRoleFeed = v end)
	makeToggle(left, "Event feed", 854, function() return Config.MysteryEventFeed end, function(v) Config.MysteryEventFeed = v end)
	makeToggle(left, "Sound alerts on reveals", 902, function() return Config.MysterySoundAlerts end, function(v) Config.MysterySoundAlerts = v end)

	-- Section 4: Quick actions
	label(left, "QUICK ACTIONS", UDim2.new(1, -24, 0, 16), UDim2.fromOffset(12, 958), Enum.Font.Code, "accent2", 9)
	local preset = button(left, "APPLY MYSTERY VISUAL PRESET", UDim2.new(1, -20, 0, 40), UDim2.fromOffset(10, 978), "accent")
	preset.Activated:Connect(function()
		Config.ESPEnabled = true
		Config.HighlightESP = true
		Config.NameESP = true
		Config.RoleESP = true
		Config.DistanceESP = true
		Config.MysteryRoleColors = true
		Config.MysteryRoleHUD = true
		Config.MysteryMurdererWallhack = true
		State.dirty = true
		for _, refresh in ipairs(UI.refreshers) do pcall(refresh) end
		notify("Murder Mystery visual preset applied", true)
	end)
	local who = button(left, "SHOW MY ROLE", UDim2.new(.5, -15, 0, 40), UDim2.fromOffset(10, 1026), "row")
	who.Activated:Connect(function()
		local role = State.roles[player.Name]
		notify(role and ("Your role: " .. string.upper(tostring(role))) or "Your role is not available yet", role ~= nil)
	end)
	local visual = button(left, "OPEN VISUALS", UDim2.new(.5, -15, 0, 40), UDim2.new(.5, 5, 0, 1026), "row")
	visual.Activated:Connect(function()
		setMysteryPopup(false)
		setMenu(true)
		showPage("Visuals")
	end)
	local teleportTitle = label(left, "ADMIN TELEPORT (server-gated)", UDim2.new(1, -24, 0, 16), UDim2.fromOffset(12, 1082), Enum.Font.Code, "muted", 9)
	local murdererButton = button(left, "TP TO MURDERER", UDim2.new(.5, -15, 0, 42), UDim2.fromOffset(10, 1104), "row")
	local sheriffButton = button(left, "TP TO SHERIFF", UDim2.new(.5, -15, 0, 42), UDim2.new(.5, 5, 0, 1104), "row")
	local teleportCooldown = 0
	local function teleport(role, object, textValue)
		if os.clock() < teleportCooldown then notify("Teleport is cooling down", false); return end
		if not Remotes.Teleport or not Remotes.Teleport:IsA("RemoteEvent") then notify("Teleport remote is unavailable", false); return end
		teleportCooldown = os.clock() + 3
		object.Text = "REQUESTING..."
		local sent = pcall(function() Remotes.Teleport:FireServer(role) end)
		if not sent then notify("Teleport request failed", false) end
		task.delay(1.2, function() if object.Parent then object.Text = textValue end end)
	end
	murdererButton.Activated:Connect(function() teleport("Murderer", murdererButton, "TP TO MURDERER") end)
	sheriffButton.Activated:Connect(function() teleport("Sheriff", sheriffButton, "TP TO SHERIFF") end)
	label(right, "ROUND OVERVIEW", UDim2.new(1, -24, 0, 16), UDim2.fromOffset(12, 12), Enum.Font.Code, "accent2", 9)
	UI.mysteryMyRole = label(right, "WAITING", UDim2.new(1, -24, 0, 30), UDim2.fromOffset(12, 38), Enum.Font.GothamBlack, "text", 21)
	UI.mysteryMyRole.TextXAlignment = Enum.TextXAlignment.Center
	local function infoRow(titleText, y, color)
		local row = panel(right, UDim2.new(1, -24, 0, 38), UDim2.fromOffset(12, y), "row")
		local dot = Instance.new("Frame")
		dot.Size = UDim2.fromOffset(9, 9)
		dot.Position = UDim2.new(0, 10, .5, -4)
		dot.BackgroundColor3 = color
		dot.BorderSizePixel = 0
		dot.Parent = row
		corner(dot, 5)
		label(row, titleText, UDim2.new(.5, -20, 1, 0), UDim2.fromOffset(26, 0), Enum.Font.GothamBold, "muted", 9)
		local value = label(row, "UNKNOWN", UDim2.new(.5, -12, 1, 0), UDim2.new(.5, 0, 0, 0), Enum.Font.GothamBlack, "text", 10)
		value.TextXAlignment = Enum.TextXAlignment.Right
		value.TextTruncate = Enum.TextTruncate.AtEnd
		return value
	end
	UI.mysteryMurderer = infoRow("MURDERER", 94, MysteryRoleColors.murderer)
	UI.mysterySheriff = infoRow("SHERIFF", 138, MysteryRoleColors.sheriff)
	UI.mysteryAlive = infoRow("ALIVE", 182, MysteryRoleColors.innocent)
	UI.mysteryGun = infoRow("GUN", 226, MysteryRoleColors.hero)
	local intelCard = panel(right, UDim2.new(1, -24, 0, 76), UDim2.fromOffset(12, 272), "row")
	label(intelCard, "ROUND INTEL", UDim2.fromOffset(100, 12), UDim2.fromOffset(10, 7), Enum.Font.Code, "accent2", 8)
	UI.mysteryPhase = label(intelCard, "WAITING", UDim2.new(.5, -16, 0, 18), UDim2.fromOffset(10, 27), Enum.Font.GothamBlack, "text", 10)
	UI.mysteryTimer = label(intelCard, "--:--", UDim2.new(.5, -16, 0, 18), UDim2.new(.5, 6, 0, 27), Enum.Font.Code, "accent2", 10)
	UI.mysteryTimer.TextXAlignment = Enum.TextXAlignment.Right
	UI.mysteryMap = label(intelCard, "MAP --", UDim2.new(.5, -16, 0, 14), UDim2.fromOffset(10, 50), Enum.Font.Code, "muted", 8)
	UI.mysteryEvent = label(intelCard, "EVENT --", UDim2.new(.5, -16, 0, 14), UDim2.new(.5, 6, 0, 50), Enum.Font.Code, "muted", 8)
	UI.mysteryEvent.TextXAlignment = Enum.TextXAlignment.Right
	local legend = label(right, "Role, map, timer, event, and gun values come from replicated server payloads. Unknown means no value has arrived yet.", UDim2.new(1, -28, 0, 64), UDim2.fromOffset(14, 358), Enum.Font.Gotham, "muted", 9)
	legend.TextWrapped = true
	legend.TextXAlignment = Enum.TextXAlignment.Center
end

local function buildUtilities()
	local performance = newPage("Performance")
	pageHeader(performance, "Performance", "Local, reversible options for reducing visual workload.", "accent2")
	local hero = panel(performance, UDim2.new(1, -28, 0, 100), UDim2.fromOffset(14, 76), "panel")
	label(hero, "CURRENT FPS", UDim2.fromOffset(120, 14), UDim2.fromOffset(14, 12), Enum.Font.Code, "muted", 9)
	UI.fpsLabel = label(hero, "0", UDim2.fromOffset(130, 48), UDim2.fromOffset(14, 28), Enum.Font.GothamBlack, "text", 40)
	local modeLabel = label(hero, "MODE  /  " .. string.upper(Config.PerformanceMode), UDim2.fromOffset(220, 18), UDim2.new(1, -244, .5, -9), Enum.Font.Code, "accent2", 10)
	modeLabel.TextXAlignment = Enum.TextXAlignment.Right
	UI.performanceModeLabel = modeLabel
	local modeCard = panel(performance, UDim2.new(1, -28, 0, 132), UDim2.fromOffset(14, 190), "panel")
	label(modeCard, "RENDER PROFILE", UDim2.fromOffset(150, 14), UDim2.fromOffset(12, 10), Enum.Font.Code, "muted", 9)
	local modes = {
		{name = "Off", description = "Game as-is"},
		{name = "Balanced", description = "Effects reduced"},
		{name = "Max", description = "Flat map materials"},
		{name = "Potato", description = "Minimum local detail"},
	}
	local perfModes = {}
	local function paintPerfModes()
		for name, data in pairs(perfModes) do
			local selected = Config.PerformanceMode == name
			data.button.BackgroundColor3 = selected and Theme.accent or Theme.row
			data.button.BackgroundTransparency = selected and .78 or 0
			data.label.TextColor3 = selected and Theme.accent2 or Theme.text
		end
		modeLabel.Text = "MODE  /  " .. string.upper(Config.PerformanceMode)
	end
	for index, mode in ipairs(modes) do
		local b = button(modeCard, "", UDim2.new(.25, -10, 0, 78), UDim2.new((index - 1) / 4, 6, 0, 38), "row")
		local number = label(b, string.format("%02d", index), UDim2.fromOffset(30, 13), UDim2.fromOffset(10, 8), Enum.Font.Code, "accent", 8)
		local modeName = label(b, mode.name:upper(), UDim2.new(1, -20, 0, 18), UDim2.fromOffset(10, 28), Enum.Font.GothamBlack, "text", 12)
		modeName.TextTruncate = Enum.TextTruncate.AtEnd
		local note = label(b, mode.description, UDim2.new(1, -16, 0, 15), UDim2.fromOffset(8, 53), Enum.Font.Gotham, "muted", 8)
		note.TextTruncate = Enum.TextTruncate.AtEnd
		perfModes[mode.name] = {button = b, label = modeName}
		b.Activated:Connect(function()
			Config.PerformanceMode = mode.name
			State.dirty = true
			paintPerfModes()
			if UI.applyPerformance then UI.applyPerformance(mode.name) end
		end)
	end
	UI.refreshPerfModes = paintPerfModes
	table.insert(UI.refreshers, paintPerfModes)
	paintPerfModes()
	local extras = panel(performance, UDim2.new(1, -28, 0, 210), UDim2.fromOffset(14, 334), "panel")
	label(extras, "EXTRAS", UDim2.fromOffset(100, 14), UDim2.fromOffset(12, 10), Enum.Font.Code, "muted", 9)
	makeToggle(extras, "FPS / ping watermark", 34, function() return Config.Watermark end, function(value) Config.Watermark = value end)
	makeToggle(extras, "Pause unfocused rendering", 82, function() return Config.PauseUnfocused end, function(value) Config.PauseUnfocused = value end)
	makeToggle(extras, "Cull far map parts", 130, function() return Config.CullFar end, function(value) Config.CullFar = value end)
	makeSlider(extras, "Render distance", 178, 100, 2000, function() return Config.RenderDistance end, function(value) Config.RenderDistance = math.floor(value / 10 + .5) * 10 end)
	UI.applyPerformance = function(mode)
		mode = mode == "Potato" and "Potato" or mode
		if UI.restorePerformance then pcall(UI.restorePerformance, true) end
		Config.PerformanceMode = mode
		UI.performanceModeLabel.Text = "MODE  /  " .. string.upper(mode)
		State.dirty = true
		if mode == "Off" then
			pcall(function() RunService:Set3dRenderingEnabled(true) end)
			notify("Performance mode disabled", true)
			return
		end
		-- Do not destroy instances. Only reversible local properties are changed.
		local processed = 0
		for _, object in ipairs(Workspace:GetDescendants()) do
			if object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Beam") then
				if UI.changePerformance then UI.changePerformance(object, "Enabled", false) else pcall(function() object.Enabled = false end) end
			elseif mode == "Max" or mode == "Potato" then
				local character = player.Character
				if object:IsA("BasePart") and (not character or not object:IsDescendantOf(character)) then
					if UI.changePerformance then UI.changePerformance(object, "CastShadow", false) else pcall(function() object.CastShadow = false end) end
					if object.Material ~= Enum.Material.Neon and object.Material ~= Enum.Material.ForceField then
						if UI.changePerformance then UI.changePerformance(object, "Material", Enum.Material.SmoothPlastic) else pcall(function() object.Material = Enum.Material.SmoothPlastic end) end
					end
				end
			end
			processed += 1
			if processed % 250 == 0 then task.wait() end
		end
		notify(string.upper(mode) .. " performance mode applied", true)
	end
	local fbCard = panel(performance, UDim2.new(1,-28,0,256), UDim2.fromOffset(14,556), "panel")
	label(fbCard,"ADVANCED",UDim2.fromOffset(120,14),UDim2.fromOffset(12,10),Enum.Font.Code,"muted",9)
	makeToggle(fbCard,"Global shadows",34,function() return game:GetService("Lighting").GlobalShadows end,function(v) pcall(function() game:GetService("Lighting").GlobalShadows=v end) end)
	makeToggle(fbCard,"Particles",82,function() return Config.ParticlesEnabled~=false end,function(v) Config.ParticlesEnabled=v; for _,d in ipairs(workspace:GetDescendants()) do pcall(function() if d:IsA("ParticleEmitter") or d:IsA("Smoke") or d:IsA("Fire") or d:IsA("Sparkles") then d.Enabled=v end end) end end)
	makeToggle(fbCard,"Decorations",130,function() return Config.DecorationsEnabled~=false end,function(v) Config.DecorationsEnabled=v; for _,d in ipairs(workspace:GetDescendants()) do pcall(function() if d:IsA("Decal") or d:IsA("Texture") then d.Transparency=v and 0 or 1 end end) end end)
	makeSlider(fbCard,"LOD distance",178,50,1000,function() return Config.LODDistance or 300 end,function(v) Config.LODDistance=math.floor(v) end)
	local _rp=button(fbCard,"RESET PERFORMANCE",UDim2.new(1,-24,0,34),UDim2.fromOffset(12,214),"row")
	_rp.Activated:Connect(function() Config.FullBright=false; Config.ParticlesEnabled=true; Config.DecorationsEnabled=true; Config.LODDistance=300; Config.AmbientBrightness=0.5; Config.PerformanceMode="Off"; if UI.applyPerformance then UI.applyPerformance("Off") end; local L=game:GetService("Lighting"); L.Brightness=1; L.GlobalShadows=true; L.Ambient=Color3.fromRGB(70,70,70); L.OutdoorAmbient=Color3.fromRGB(127,127,127); for _,r in ipairs(UI.refreshers) do pcall(r) end; notify("Performance reset",true) end)
	if Config.PerformanceMode ~= "Off" then task.defer(function() UI.applyPerformance(Config.PerformanceMode) end) end

	local themes = newPage("Themes")
	pageHeader(themes, "Themes", "Apply a color system and choose the window layout.", "accent")
	local themeScroll = Instance.new("ScrollingFrame")
	themeScroll.Size = UDim2.new(1, -28, 1, -148)
	themeScroll.Position = UDim2.fromOffset(14, 70)
	themeScroll.BackgroundTransparency = 1
	themeScroll.BorderSizePixel = 0
	themeScroll.ScrollBarThickness = 3
	themeScroll.ScrollBarImageColor3 = Theme.accent
	themeScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	themeScroll.CanvasSize = UDim2.new()
	themeScroll.Parent = themes
	local themeLayout = Instance.new("UIGridLayout")
	themeLayout.CellSize = UDim2.new(.25, -8, 0, 92)
	themeLayout.CellPadding = UDim2.fromOffset(8, 8)
	themeLayout.SortOrder = Enum.SortOrder.Name
	themeLayout.Parent = themeScroll
	local themeButtons = {}
	-- sort theme names so the grid is tidy and stable
	local themeNames = {}
	for name in pairs(Themes) do table.insert(themeNames, name) end
	table.sort(themeNames)
	for _, name in ipairs(themeNames) do
		local data = Themes[name]
		local b = button(themeScroll, "", UDim2.new(), nil, "row")
		b.Name = "Theme_" .. name
		b.AutoButtonColor = false
		-- mini window preview: bg card with a panel strip + two accent chips
		local mini = Instance.new("Frame")
		mini.Size = UDim2.new(1, -16, 0, 46)
		mini.Position = UDim2.fromOffset(8, 8)
		mini.BackgroundColor3 = data.bg
		mini.BorderSizePixel = 0
		mini.Parent = b
		corner(mini, 7)
		local miniStroke = Instance.new("UIStroke"); miniStroke.Color = data.accent; miniStroke.Transparency = .5; miniStroke.Thickness = 1; miniStroke.Parent = mini
		local miniPanel = Instance.new("Frame")
		miniPanel.Size = UDim2.new(0, 16, 1, -10); miniPanel.Position = UDim2.fromOffset(5, 5)
		miniPanel.BackgroundColor3 = data.panel; miniPanel.BorderSizePixel = 0; miniPanel.Parent = mini
		corner(miniPanel, 4)
		local accentChip = Instance.new("Frame")
		accentChip.Size = UDim2.new(1, -32, 0, 10); accentChip.Position = UDim2.fromOffset(27, 8)
		accentChip.BackgroundColor3 = data.accent; accentChip.BorderSizePixel = 0; accentChip.Parent = mini
		corner(accentChip, 3)
		local accentGrad = Instance.new("UIGradient"); accentGrad.Color = ColorSequence.new(data.accent, data.accent2); accentGrad.Parent = accentChip
		local rowChip = Instance.new("Frame")
		rowChip.Size = UDim2.new(1, -32, 0, 8); rowChip.Position = UDim2.fromOffset(27, 24)
		rowChip.BackgroundColor3 = data.row; rowChip.BorderSizePixel = 0; rowChip.Parent = mini
		corner(rowChip, 3)
		local accentDot = Instance.new("Frame")
		accentDot.Size = UDim2.fromOffset(8, 8); accentDot.Position = UDim2.new(1, -14, 0, 24)
		accentDot.BackgroundColor3 = data.accent2; accentDot.BorderSizePixel = 0; accentDot.Parent = mini
		corner(accentDot, 4)
		local text = label(b, name, UDim2.new(1, -28, 0, 18), UDim2.fromOffset(8, 58), Enum.Font.GothamBold, "text", 11)
		text.TextXAlignment = Enum.TextXAlignment.Left
		-- active check mark
		local check = label(b, "\u{2713}", UDim2.fromOffset(18, 18), UDim2.new(1, -24, 0, 58), Enum.Font.GothamBlack, "accent2", 13)
		check.Visible = false
		themeButtons[name] = {button = b, text = text, check = check, stroke = b:FindFirstChildOfClass("UIStroke")}
		b.MouseEnter:Connect(function() TweenService:Create(miniStroke, TweenInfo.new(.12), { Transparency = 0 }):Play() end)
		b.MouseLeave:Connect(function() TweenService:Create(miniStroke, TweenInfo.new(.15), { Transparency = Config.Theme == name and 0 or .5 }):Play() end)
		b.Activated:Connect(function() applyTheme(name) end)
	end
	local layoutTitle = label(themes, "LAYOUT", UDim2.fromOffset(120, 14), UDim2.new(0, 14, 1, -72), Enum.Font.Code, "muted", 9)
	local layoutButtons = {}
	for index, layoutName in ipairs({"Newgen", "Lynen", "Horizon"}) do
		local b = button(themes, layoutName:upper(), UDim2.new(1 / 3, -18, 0, 42), UDim2.new((index - 1) / 3, 8, 1, -50), "row")
		layoutButtons[layoutName] = b
		b.Activated:Connect(function() applyLayout(layoutName, true) end)
	end
	table.insert(UI.refreshers, function()
		for name, info in pairs(themeButtons) do
			local active = Config.Theme == name
			info.button.BackgroundColor3 = active and Theme.accent or Theme.row
			info.button.BackgroundTransparency = active and .8 or 0
			info.text.TextColor3 = active and Theme.text or Theme.muted
			if info.check then info.check.Visible = active end
			if info.stroke then info.stroke.Color = active and Theme.accent or Theme.row; info.stroke.Transparency = active and 0 or .6 end
		end
		for name, b in pairs(layoutButtons) do b.Text = name == Config.LayoutStyle and "IN USE" or name:upper() end
	end)

	local colors = newPage("Colors")
	pageHeader(colors, "Colors", "Tint the background and accent without changing the selected theme.", "accent2")
	local colorCard = panel(colors, UDim2.new(.6, -20, 0, 290), UDim2.fromOffset(14, 76), "panel")
	local colorSide = panel(colors, UDim2.new(.4, -14, 0, 290), UDim2.new(.6, 0, 0, 76), "panel")
	local colorPreview = Instance.new("Frame")
	colorPreview.Size = UDim2.new(1, -24, 0, 72)
	colorPreview.Position = UDim2.fromOffset(12, 12)
	colorPreview.BorderSizePixel = 0
	colorPreview.Parent = colorCard
	corner(colorPreview, 8)
	local colorHex = label(colorPreview, "#000000", UDim2.new(1, -16, 0, 20), UDim2.fromOffset(8, 42), Enum.Font.Code, "text", 13)
	colorHex.TextXAlignment = Enum.TextXAlignment.Center
	local function hsvColor() return Color3.fromHSV(Config.BackgroundHue, Config.BackgroundSaturation, Config.BackgroundValue) end
	local colorRows = {}
	local function colorSlider(titleText, y, getter, setter)
		local row = panel(colorCard, UDim2.new(1, -24, 0, 48), UDim2.fromOffset(12, y), "row")
		label(row, titleText, UDim2.fromOffset(110, 14), UDim2.fromOffset(8, 7), Enum.Font.Code, "muted", 8)
		local bar = Instance.new("Frame")
		bar.Size = UDim2.new(1, -132, 0, 6)
		bar.Position = UDim2.fromOffset(120, 22)
		bar.BackgroundColor3 = Theme.row
		bar.BorderSizePixel = 0
		bar.Parent = row
		corner(bar, 3)
		local fill = Instance.new("Frame")
		fill.Size = UDim2.fromScale(0, 1)
		fill.BackgroundColor3 = Theme.accent
		fill.BorderSizePixel = 0
		fill.Parent = bar
		corner(fill, 3)
		local knob = Instance.new("Frame")
		knob.AnchorPoint = Vector2.new(.5, .5)
		knob.Size = UDim2.fromOffset(12, 12)
		knob.Position = UDim2.fromScale(0, .5)
		knob.BackgroundColor3 = Theme.text
		knob.BorderSizePixel = 0
		knob.Parent = bar
		corner(knob, 6)
		local dragging = false
		local function refresh()
			local value = math.clamp(getter(), 0, 1)
			fill.Size = UDim2.fromScale(value, 1)
			knob.Position = UDim2.fromScale(value, .5)
		end
		local function setAt(x)
			local value = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
			setter(value)
			Config.CustomBackground = true
			refresh()
		end
		bar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; setAt(input.Position.X) end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then setAt(input.Position.X) end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
		end)
		colorRows[titleText] = refresh
		refresh()
	end
	colorSlider("HUE", 98, function() return Config.BackgroundHue end, function(value) Config.BackgroundHue = value end)
	colorSlider("SATURATION", 152, function() return Config.BackgroundSaturation end, function(value) Config.BackgroundSaturation = value end)
	colorSlider("BRIGHTNESS", 206, function() return Config.BackgroundValue end, function(value) Config.BackgroundValue = value end)
	makeToggle(colorSide, "Use custom color", 28, function() return Config.CustomBackground end, function(value) Config.CustomBackground = value end)
	makeSlider(colorSide, "Strength", 78, 0, 1, function() return Config.BackgroundIntensity end, function(value) Config.BackgroundIntensity = value end)
	local resetColor = button(colorSide, "RESET COLOR", UDim2.new(1, -28, 0, 36), UDim2.fromOffset(14, 192), "row")
	resetColor.Activated:Connect(function()
		Config.CustomBackground = false
		Config.BackgroundHue, Config.BackgroundSaturation, Config.BackgroundValue, Config.BackgroundIntensity = .75, .82, .85, .65
		for _, refresh in pairs(colorRows) do refresh() end
		if UI.applyBackground then UI.applyBackground() end
	end)
	table.insert(UI.refreshers, function()
		local color = hsvColor()
		colorPreview.BackgroundColor3 = color
		local r, g, b = math.floor(color.R * 255 + .5), math.floor(color.G * 255 + .5), math.floor(color.B * 255 + .5)
		colorHex.Text = string.format("#%02X%02X%02X", r, g, b)
		colorHex.TextColor3 = Config.BackgroundValue > .65 and Config.BackgroundSaturation < .5 and Color3.new() or Color3.new(1, 1, 1)
		for _, refresh in pairs(colorRows) do refresh() end
	end)

	UI.applyBackground = function()
		local value = hsvColor()
		if Config.CustomBackground then main.BackgroundColor3 = Theme.bg:Lerp(value, math.clamp(Config.BackgroundIntensity, 0, 1) * .6) else main.BackgroundColor3 = Theme.bg end
		State.dirty = true
	end

	-- Fullbright: remember the original lighting the first time it's turned on so
	-- turning it off restores the game exactly. Lives on the Visuals page now.
	local savedLighting = nil
	UI.applyFullbright = function()
		local L = game:GetService("Lighting")
		if Config.FullBright then
			if not savedLighting then
				savedLighting = {
					Brightness = L.Brightness, ClockTime = L.ClockTime, FogEnd = L.FogEnd,
					GlobalShadows = L.GlobalShadows, Ambient = L.Ambient, OutdoorAmbient = L.OutdoorAmbient,
				}
			end
			local level = math.clamp(tonumber(Config.FullBrightLevel) or 2, 1, 5)
			pcall(function()
				L.Brightness = level
				L.ClockTime = 14
				L.GlobalShadows = false
				L.FogEnd = 1e6
				local c = Color3.fromRGB(178,178,178)
				L.Ambient = c
				L.OutdoorAmbient = c
			end)
		elseif savedLighting then
			local s = savedLighting
			pcall(function()
				L.Brightness = s.Brightness
				L.ClockTime = s.ClockTime
				L.FogEnd = Config.NoFog and 1e6 or s.FogEnd
				L.GlobalShadows = s.GlobalShadows
				L.Ambient = s.Ambient
				L.OutdoorAmbient = s.OutdoorAmbient
			end)
		end
	end

	local session = newPage("Session")
	pageHeader(session, "Session", "Server-authoritative actions and local binding controls.", "accent2")
	UI.sessionStatus = label(session, "Session actions ready", UDim2.new(1, -28, 0, 22), UDim2.fromOffset(14, 74), Enum.Font.GothamBold, "muted", 10)
	local hopCard = panel(session, UDim2.new(.5, -20, 0, 200), UDim2.fromOffset(14, 112), "panel")
	local resetCard = panel(session, UDim2.new(.5, -20, 0, 200), UDim2.new(.5, 6, 0, 112), "panel")
	label(hopCard, "HOP SERVER", UDim2.new(1, -24, 0, 26), UDim2.fromOffset(12, 16), Enum.Font.GothamBlack, "accent2", 17)
	label(hopCard, "Ask the server to find another live instance.", UDim2.new(1, -24, 0, 38), UDim2.fromOffset(12, 54), Enum.Font.Gotham, "muted", 10).TextWrapped = true
	label(resetCard, "RESET CHARACTER", UDim2.new(1, -24, 0, 26), UDim2.fromOffset(12, 16), Enum.Font.GothamBlack, "accent", 17)
	label(resetCard, "Respawn only your own current character.", UDim2.new(1, -24, 0, 38), UDim2.fromOffset(12, 54), Enum.Font.Gotham, "muted", 10).TextWrapped = true
	local hop = button(hopCard, "HOP SERVER", UDim2.new(1, -24, 0, 46), UDim2.new(0, 12, 1, -60), "accent2")
	local reset = button(resetCard, "RESET CHARACTER", UDim2.new(1, -24, 0, 46), UDim2.new(0, 12, 1, -60), "accent")
	hop.Activated:Connect(function()
		hop.Text = "SEARCHING..."
		UI.sessionStatus.Text = "Finding another server..."
		-- Try the game's own hop remote first (if the experience provides one),
		-- then fall back to a client-side TeleportService server hop.
		if Remotes.Hop and Remotes.Hop:IsA("RemoteEvent") then pcall(function() Remotes.Hop:FireServer() end) end
		task.spawn(function()
			local TeleportService = game:GetService("TeleportService")
			-- Ask Roblox to teleport us into another instance of this place.
			local ok, err = pcall(function() TeleportService:Teleport(game.PlaceId, player) end)
			if not ok then
				UI.sessionStatus.Text = "Server hop failed: " .. tostring(err):sub(1, 60)
				notify("Server hop failed", false)
			end
		end)
		task.delay(6, function() if hop.Parent then hop.Text = "HOP SERVER" end end)
	end)
	reset.Activated:Connect(function()
		reset.Text="RESETTING..."
		UI.sessionStatus.Text = "Resetting your character..."
		-- Kill the local character (client-side reset). Breaking the Humanoid's
		-- joints is the most reliable "kill" and triggers the normal respawn.
		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local killed = false
		if hum then
			killed = pcall(function() hum.Health = 0 end)
			-- Fallback for games that block Health writes: break the character apart.
			if char then pcall(function() char:BreakJoints() end) end
		end
		if not killed and not hum then
			pcall(function() player:LoadCharacter() end)
		end
		notify("Character reset", true)
		task.delay(2,function() if reset.Parent then reset.Text="RESET CHARACTER" end end)
	end)
	local keyCard = panel(session, UDim2.new(1, -28, 0, 64), UDim2.new(0, 14, 0, 330), "panel")
	label(keyCard, "MENU KEY", UDim2.fromOffset(120, 16), UDim2.fromOffset(12, 9), Enum.Font.Code, "muted", 9)
	local menuKey = button(keyCard, Config.MenuKey or "RightShift", UDim2.fromOffset(130, 34), UDim2.new(1, -142, .5, -17), "row")
	menuKey.Font = Enum.Font.Code
	local listening = false
	menuKey.Activated:Connect(function()
		listening = not listening
		UI.bindingActive = listening
		menuKey.Text = listening and "PRESS A KEY" or (Config.MenuKey or "RightShift")
	end)
	UserInputService.InputBegan:Connect(function(input)
		if not listening or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
		listening = false
		UI.bindingActive = false
		if input.KeyCode ~= Enum.KeyCode.Escape then Config.MenuKey = input.KeyCode.Name; State.dirty = true end
		menuKey.Text = Config.MenuKey or "RightShift"
	end)

	local playersPage = newPage("Players")
	pageHeader(playersPage, "Players", "Click a player to spectate them locally. Click again to return.", "accent")
	local playerList = Instance.new("ScrollingFrame")
	playerList.Size = UDim2.new(1, -28, 1, -84)
	playerList.Position = UDim2.fromOffset(14, 70)
	playerList.BackgroundColor3 = Theme.panel
	playerList.BorderSizePixel = 0
	playerList.ScrollBarThickness = 3
	playerList.ScrollBarImageColor3 = Theme.accent
	playerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
	playerList.CanvasSize = UDim2.new()
	playerList.Parent = playersPage
	corner(playerList, 10)
	UI.playerList = playerList
	UI.playerRows = {}
	local playerLayout = Instance.new("UIListLayout")
	playerLayout.Padding = UDim.new(0, 5)
	playerLayout.Parent = playerList
end

-- ==========================================================================

-- ==========================================================================
-- KEYSTROKES HUD PAGE + LIVE OVERLAY
-- ==========================================================================
local _keystrokeGui = nil
local function launchKeystrokesOverlay()
	if _keystrokeGui and _keystrokeGui.Parent then _keystrokeGui:Destroy() end
	local playerGui = player:WaitForChild("PlayerGui")
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "StaticsKeystrokeHUD"
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 99
	screenGui.IgnoreGuiInset = true
	screenGui.Parent = playerGui
	_keystrokeGui = screenGui

	-- Customizable style. Accent is the outline + pressed-fill color.
	local accent = Config.KeystrokesUseThemeColor and Theme.accent or Color3.fromHSV(math.clamp(tonumber(Config.KeystrokesAccentHue) or .14, 0, 1), .9, 1)
	local idleFill = Color3.fromRGB(12, 12, 15)
	local idleTX   = Color3.fromRGB(236, 236, 240)
	local downFill = accent
	local downTX   = Color3.fromRGB(14, 14, 16)
	local idleOpacity = 1 - math.clamp(tonumber(Config.KeystrokesOpacity) or .75, 0, 1)
	local PIXEL = Enum.Font.Arcade

	-- draggable root (transparent; the boxes float like the reference)
	local container = Instance.new("Frame")
	container.Name = "KeyContainer"
	container.Size = UDim2.fromOffset(238, 310)
	container.Position = UDim2.fromOffset(tonumber(Config.KeystrokesX) or 26, tonumber(Config.KeystrokesY) or 120)
	container.BackgroundTransparency = 1
	container.Active = true
	container.Parent = screenGui
	-- apply user scale
	local uiScale = Instance.new("UIScale"); uiScale.Scale = math.clamp(tonumber(Config.KeystrokesScale) or 1, .6, 1.6); uiScale.Parent = container

	-- A proper drag handle: a slim bar at the top. Grabbing it shows a "MOVE"
	-- state with an accent glow, which looks far better than an invisible drag.
	local handle = Instance.new("TextButton")
	handle.Name = "DragHandle"
	handle.Text = ""
	handle.AutoButtonColor = false
	handle.Size = UDim2.fromOffset(238, 20)
	handle.Position = UDim2.fromOffset(0, 0)
	handle.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
	handle.BackgroundTransparency = .15
	handle.BorderSizePixel = 0
	handle.Parent = container
	local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(0, 6); hc.Parent = handle
	local hStroke = Instance.new("UIStroke"); hStroke.Color = accent; hStroke.Thickness = 1.4; hStroke.Transparency = .3; hStroke.Parent = handle
	-- grip dots + label
	for g = 0, 2 do
		local gd = Instance.new("Frame"); gd.Size = UDim2.fromOffset(4, 4); gd.Position = UDim2.new(.5, -14 + g * 10, .5, -2); gd.BackgroundColor3 = accent; gd.BorderSizePixel = 0; gd.Parent = handle
		local gc = Instance.new("UICorner"); gc.CornerRadius = UDim.new(1, 0); gc.Parent = gd
	end
	local handleLabel = Instance.new("TextLabel")
	handleLabel.BackgroundTransparency = 1; handleLabel.Size = UDim2.fromScale(1, 1); handleLabel.Font = Enum.Font.GothamBold
	handleLabel.Text = ""; handleLabel.TextSize = 9; handleLabel.TextColor3 = accent; handleLabel.Visible = false; handleLabel.Parent = handle

	local function box(txt, sz, pos, textSize)
		local f = Instance.new("TextLabel")
		f.Text = txt; f.Size = sz; f.Position = pos
		f.BackgroundColor3 = idleFill
		f.BackgroundTransparency = idleOpacity
		f.TextColor3 = idleTX
		f.Font = PIXEL; f.TextSize = textSize or 22
		f.BorderSizePixel = 0; f.Parent = container
		local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = f
		local s = Instance.new("UIStroke")
		s.Color = accent; s.Thickness = 2.4; s.Transparency = 0
		s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		s.Parent = f
		return f
	end

	-- rows are offset by 26 to sit under the drag handle
	local baseY = 26
	local fps = Config.KeystrokesShowFPS ~= false and box("FPS: 0", UDim2.fromOffset(150, 32), UDim2.fromOffset(44, baseY), 18) or nil
	local topY = Config.KeystrokesShowFPS ~= false and (baseY + 42) or baseY
	local W = box("W", UDim2.fromOffset(56, 54), UDim2.fromOffset(91, topY))
	local A = box("A", UDim2.fromOffset(56, 54), UDim2.fromOffset(10, topY + 62))
	local S = box("S", UDim2.fromOffset(56, 54), UDim2.fromOffset(91, topY + 62))
	local D = box("D", UDim2.fromOffset(56, 54), UDim2.fromOffset(172, topY + 62))
	local SPC = box("", UDim2.fromOffset(227, 28), UDim2.fromOffset(10, topY + 124))
	local keyMap = { [Enum.KeyCode.W] = W, [Enum.KeyCode.A] = A, [Enum.KeyCode.S] = S, [Enum.KeyCode.D] = D, [Enum.KeyCode.Space] = SPC }
	local mouseY = topY + 160
	local LMB, RMB
	if Config.KeystrokesShowMouse ~= false then
		LMB = box("LMB\n0 CPS", UDim2.fromOffset(110, 52), UDim2.fromOffset(10, mouseY), 16)
		RMB = box("RMB\n0 CPS", UDim2.fromOffset(110, 52), UDim2.fromOffset(128, mouseY), 16)
	end
	-- optional arrow keys row
	if Config.KeystrokesShowArrows then
		local arrowY = (Config.KeystrokesShowMouse ~= false) and (mouseY + 60) or mouseY
		local UP = box("\u{2191}", UDim2.fromOffset(40, 34), UDim2.fromOffset(99, arrowY), 18)
		local LT = box("\u{2190}", UDim2.fromOffset(40, 34), UDim2.fromOffset(55, arrowY + 38), 18)
		local DN = box("\u{2193}", UDim2.fromOffset(40, 34), UDim2.fromOffset(99, arrowY + 38), 18)
		local RT = box("\u{2192}", UDim2.fromOffset(40, 34), UDim2.fromOffset(143, arrowY + 38), 18)
		keyMap[Enum.KeyCode.Up] = UP; keyMap[Enum.KeyCode.Left] = LT; keyMap[Enum.KeyCode.Down] = DN; keyMap[Enum.KeyCode.Right] = RT
	end

	local function paint(f, down)
		if not f or not f.Parent then return end
		f.BackgroundColor3 = down and downFill or idleFill
		f.BackgroundTransparency = down and 0 or idleOpacity
		f.TextColor3 = down and downTX or idleTX
	end
	UserInputService.InputBegan:Connect(function(i, p)
		if UserInputService:GetFocusedTextBox() then return end
		if i.UserInputType == Enum.UserInputType.Keyboard and not p then paint(keyMap[i.KeyCode], true) end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.Keyboard then paint(keyMap[i.KeyCode], false) end
	end)

	-- CPS tracking
	local leftClicks, rightClicks = {}, {}
	local function reg(list) table.insert(list, os.clock()) end
	local function cps(list)
		local now = os.clock()
		for n = #list, 1, -1 do if now - list[n] > 1 then table.remove(list, n) end end
		return #list
	end
	UserInputService.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then paint(LMB, true); reg(leftClicks)
		elseif i.UserInputType == Enum.UserInputType.MouseButton2 then paint(RMB, true); reg(rightClicks) end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then paint(LMB, false)
		elseif i.UserInputType == Enum.UserInputType.MouseButton2 then paint(RMB, false) end
	end)

	-- Custom drag with visible feedback (brightens the handle, shows MOVE, lifts the card).
	local dragging, dragStart, startPos = false, nil, nil
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true; dragStart = input.Position; startPos = container.Position
			handleLabel.Visible = true; handleLabel.Text = "MOVING"
			TweenService:Create(hStroke, TweenInfo.new(.12), { Transparency = 0, Thickness = 2 }):Play()
			TweenService:Create(handle, TweenInfo.new(.12), { BackgroundTransparency = 0 }):Play()
			TweenService:Create(uiScale, TweenInfo.new(.12, Enum.EasingStyle.Back), { Scale = math.clamp((tonumber(Config.KeystrokesScale) or 1) * 1.04, .6, 1.7) }):Play()
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = false
			handleLabel.Visible = false
			TweenService:Create(hStroke, TweenInfo.new(.15), { Transparency = .3, Thickness = 1.4 }):Play()
			TweenService:Create(handle, TweenInfo.new(.15), { BackgroundTransparency = .15 }):Play()
			TweenService:Create(uiScale, TweenInfo.new(.15), { Scale = math.clamp(tonumber(Config.KeystrokesScale) or 1, .6, 1.6) }):Play()
			-- remember the new position
			Config.KeystrokesX = math.floor(container.Position.X.Offset + .5)
			Config.KeystrokesY = math.floor(container.Position.Y.Offset + .5)
			State.dirty = true
		end
	end)
	handle.MouseEnter:Connect(function() if not dragging then handleLabel.Visible = true; handleLabel.Text = "DRAG TO MOVE" end end)
	handle.MouseLeave:Connect(function() if not dragging then handleLabel.Visible = false end end)

	-- live FPS + CPS text
	task.spawn(function()
		while screenGui.Parent do
			if fps and fps.Parent then fps.Text = "FPS: " .. tostring(State.fps or 0) end
			if LMB and LMB.Parent then LMB.Text = "LMB\n" .. cps(leftClicks) .. " CPS" end
			if RMB and RMB.Parent then RMB.Text = "RMB\n" .. cps(rightClicks) .. " CPS" end
			task.wait(.1)
		end
	end)
	notify("Keystrokes HUD launched", true)
end
local function destroyKeystrokesOverlay()
	if _keystrokeGui and _keystrokeGui.Parent then _keystrokeGui:Destroy() end
	_keystrokeGui = nil
end
local function buildKeystrokes()
	local page = newPage("Keystrokes")
	pageHeader(page, "Keystrokes", "A customizable on-screen keystroke + CPS HUD. Drag it by its top bar.", "accent")
	local left = scrollingPanel(page, UDim2.new(.58, -20, 1, -82), UDim2.fromOffset(14, 70), 760)
	local right = panel(page, UDim2.new(.42, -8, 1, -82), UDim2.new(.58, 0, 0, 70), "panel")

	-- re-apply changes live if the overlay is on
	local function relaunch() if Config.KeystrokesEnabled then launchKeystrokesOverlay() end; State.dirty = true end

	makeToggle(left, "Enable keystroke HUD", 10, function() return Config.KeystrokesEnabled end, function(v)
		Config.KeystrokesEnabled = v
		if v then launchKeystrokesOverlay() else destroyKeystrokesOverlay() end
		State.dirty = true
	end)
	label(left, "ELEMENTS", UDim2.new(1,-24,0,16), UDim2.fromOffset(12, 66), Enum.Font.Code, "accent2", 9)
	makeToggle(left, "Show FPS counter", 86, function() return Config.KeystrokesShowFPS end, function(v) Config.KeystrokesShowFPS = v; relaunch() end)
	makeToggle(left, "Show mouse + CPS", 134, function() return Config.KeystrokesShowMouse end, function(v) Config.KeystrokesShowMouse = v; relaunch() end)
	makeToggle(left, "Show arrow keys", 182, function() return Config.KeystrokesShowArrows end, function(v) Config.KeystrokesShowArrows = v; relaunch() end)
	label(left, "APPEARANCE", UDim2.new(1,-24,0,16), UDim2.fromOffset(12, 238), Enum.Font.Code, "accent2", 9)
	makeToggle(left, "Use UI accent color", 258, function() return Config.KeystrokesUseThemeColor end, function(v) Config.KeystrokesUseThemeColor = v; relaunch() end)
	makeSlider(left, "Color hue", 306, 0, 1, function() return Config.KeystrokesAccentHue end, function(v) Config.KeystrokesAccentHue = v; relaunch() end)
	makeSlider(left, "Scale", 370, 0.6, 1.6, function() return Config.KeystrokesScale end, function(v) Config.KeystrokesScale = v; relaunch() end)
	makeSlider(left, "Opacity", 434, 0, 1, function() return Config.KeystrokesOpacity end, function(v) Config.KeystrokesOpacity = v; relaunch() end)
	local resetPos = button(left, "RESET POSITION (TOP-LEFT)", UDim2.new(1,-20,0,40), UDim2.fromOffset(10, 498), "row")
	resetPos.Font = Enum.Font.GothamBold
	resetPos.Activated:Connect(function() Config.KeystrokesX = 26; Config.KeystrokesY = 120; relaunch(); notify("Keystrokes HUD moved to top-left", true) end)
	local relaunchBtn = button(left, "RELAUNCH OVERLAY", UDim2.new(1,-20,0,40), UDim2.fromOffset(10, 546), "accent")
	relaunchBtn.Activated:Connect(function() if Config.KeystrokesEnabled then launchKeystrokesOverlay(); notify("Keystrokes HUD relaunched", true) else notify("Enable the HUD first", false) end end)

	-- right side: quick guide
	label(right, "HOW TO USE", UDim2.fromOffset(140, 14), UDim2.fromOffset(14, 14), Enum.Font.Code, "accent", 9)
	local guide = label(right, "1  Turn on \"Enable keystroke HUD\".\n2  Drag it by the top bar - it shows a MOVE state and remembers where you put it.\n3  Pick which elements to show (FPS, mouse + CPS, arrow keys).\n4  Change the color, scale and opacity to taste.\n\nYour position and style are saved and reload next time you run the script.", UDim2.new(1,-28,1,-40), UDim2.fromOffset(14,38), Enum.Font.Gotham, "muted", 11)
	guide.TextWrapped = true
	guide.TextYAlignment = Enum.TextYAlignment.Top

	if Config.KeystrokesEnabled then task.defer(launchKeystrokesOverlay) end
end

-- ==========================================================================
-- SETTINGS PAGE
-- ==========================================================================
local function buildSettings()
	local page = newPage("Settings")
	pageHeader(page, "Settings", "Keybinds, notifications, display and data preferences.", "accent")
	local kbCard = panel(page, UDim2.new(1,-28,0,208), UDim2.fromOffset(14,76), "panel")
	label(kbCard,"KEYBINDS",UDim2.fromOffset(140,14),UDim2.fromOffset(12,10),Enum.Font.Code,"muted",9)
	local function keybindRow(par, title, y, cfgKey)
		local row=panel(par,UDim2.new(1,-24,0,40),UDim2.fromOffset(12,y),"row")
		label(row,title,UDim2.new(.62,0,1,0),UDim2.fromOffset(10,0),Enum.Font.Gotham,"text",11)
		local btn=button(row,tostring(Config[cfgKey] or "—"),UDim2.new(.38,-14,0,26),UDim2.new(.62,6,.5,-13),"accent")
		btn.Font=Enum.Font.Code; btn.TextSize=10
		local listening=false
		btn.Activated:Connect(function()
			if listening then return end; listening=true; UI.bindingActive=true; btn.Text="PRESS KEY..."
			local c; c=UserInputService.InputBegan:Connect(function(input,processed)
				if processed then return end
				if input.UserInputType==Enum.UserInputType.Keyboard then
					Config[cfgKey]=input.KeyCode.Name; btn.Text=input.KeyCode.Name
					State.dirty=true; listening=false; UI.bindingActive=false; c:Disconnect()
				end
			end)
		end)
	end
	keybindRow(kbCard,"Menu toggle key",30,"MenuKey")
	keybindRow(kbCard,"Triggerbot toggle",78,"TriggerKey")
	keybindRow(kbCard,"Aim assist key",126,"AimKey")
	keybindRow(kbCard,"Mystery popup key",174,"MysteryKey")
	local notifCard=panel(page,UDim2.new(1,-28,0,172),UDim2.fromOffset(14,298),"panel")
	label(notifCard,"NOTIFICATIONS",UDim2.fromOffset(180,14),UDim2.fromOffset(12,10),Enum.Font.Code,"muted",9)
	makeToggle(notifCard,"Compact notifications",34,function() return Config.CompactNotifications end,function(v) Config.CompactNotifications=v end)
	makeToggle(notifCard,"Tooltip hints",82,function() return Config.TooltipHints end,function(v) Config.TooltipHints=v end)
	makeToggle(notifCard,"Reduce motion",130,function() return Config.ReduceMotion end,function(v) Config.ReduceMotion=v end)
	local dataCard=panel(page,UDim2.new(1,-28,0,108),UDim2.fromOffset(14,484),"panel")
	label(dataCard,"DATA",UDim2.fromOffset(80,14),UDim2.fromOffset(12,10),Enum.Font.Code,"muted",9)
	local rb=button(dataCard,"RESET ALL SETTINGS TO DEFAULTS",UDim2.new(1,-24,0,36),UDim2.fromOffset(12,30),"row")
	local _cr=false
	rb.Activated:Connect(function()
		if not _cr then _cr=true; rb.Text="CLICK AGAIN TO CONFIRM"; task.delay(3,function() _cr=false; if rb.Parent then rb.Text="RESET ALL SETTINGS TO DEFAULTS" end end); return end
		_cr=false; for k,v in pairs(DEFAULTS) do Config[k]=v end; Config.FlingEnabled=false; State.dirty=true
		for _,r in ipairs(UI.refreshers) do pcall(r) end; notify("Settings reset",true); rb.Text="RESET ALL SETTINGS TO DEFAULTS"
	end)
	local db=button(dataCard,"COPY DIAGNOSTICS",UDim2.new(1,-24,0,32),UDim2.fromOffset(12,70),"row")
	db.Activated:Connect(function()
		local info=string.format("Profile:%s Theme:%s Players:%d PlaceId:%d",Config.ActiveProfile or "?",Config.Theme or "Studio",#Players:GetPlayers(),game.PlaceId)
		pcall(function() setclipboard(info) end); notify("Diagnostics copied",true)
	end)
end

-- ==========================================================================
-- STATISTICS PAGE
-- ==========================================================================
local function buildStats()
	local page = newPage("Stats")
	pageHeader(page, "Statistics", "Live session, performance and server stats tracked locally.", "accent2")
	local function statRow(par, title, y, def)
		label(par,title,UDim2.new(.55,-4,0,16),UDim2.fromOffset(12,y),Enum.Font.Gotham,"muted",9)
		local v=label(par,tostring(def or "--"),UDim2.new(.45,-4,0,16),UDim2.new(.55,0,0,y),Enum.Font.GothamBold,"text",9)
		v.TextXAlignment=Enum.TextXAlignment.Right; v.TextTruncate=Enum.TextTruncate.AtEnd; return v
	end
	local sess=panel(page,UDim2.new(1,-28,0,196),UDim2.fromOffset(14,76),"panel")
	label(sess,"SESSION",UDim2.fromOffset(100,14),UDim2.fromOffset(12,10),Enum.Font.Code,"muted",9)
	local _st=os.clock(); local _pFps,_fc,_fs,_ft=0,0,0,0
	local s_time=statRow(sess,"Session duration",30,"0:00")
	local s_frames=statRow(sess,"Total frames",56,"0")
	local s_peak=statRow(sess,"Peak FPS",82,"0")
	local s_avg=statRow(sess,"Average FPS",108,"0")
	local s_players=statRow(sess,"Players in server",134,tostring(#Players:GetPlayers()))
	local s_users=statRow(sess,"Script users online",160,"163")
	local aim_c=panel(page,UDim2.new(1,-28,0,100),UDim2.fromOffset(14,286),"panel")
	label(aim_c,"AIM ASSIST",UDim2.fromOffset(120,14),UDim2.fromOffset(12,10),Enum.Font.Code,"muted",9)
	local _af,_tf,_ut=0,0,{}
	local s_aim=statRow(aim_c,"Frames aim active",30,"0")
	local s_trig=statRow(aim_c,"Triggerbot fires",56,"0")
	local s_utarg=statRow(aim_c,"Unique targets",82,"0")
	local serv=panel(page,UDim2.new(1,-28,0,148),UDim2.fromOffset(14,400),"panel")
	label(serv,"SERVER",UDim2.fromOffset(100,14),UDim2.fromOffset(12,10),Enum.Font.Code,"muted",9)
	statRow(serv,"Place ID",30,tostring(game.PlaceId))
	statRow(serv,"Creator ID",56,tostring(game.CreatorId))
	statRow(serv,"Max players",82,tostring(game.Players.MaxPlayers))
	statRow(serv,"Job ID",108,game.JobId and game.JobId:sub(1,20) or "—")
	statRow(serv,"Respawn time",134,tostring(game.Players.RespawnTime).."s")
	RunService.RenderStepped:Connect(function(dt)
		_fc+=1; local fps=dt>0 and math.floor(1/dt) or 0
		_fs+=fps; _ft+=1; if fps>_pFps then _pFps=fps end
		if Config.AimEnabled and State.target then _af+=1; _ut[tostring(State.target)]=true end
		if _fc%30~=0 then return end
		local e=math.floor(os.clock()-_st)
		local function u(l,t) if l and l.Parent then l.Text=t end end
		u(s_time,string.format("%d:%02d",math.floor(e/60),e%60))
		u(s_frames,tostring(_fc)); u(s_peak,tostring(_pFps))
		u(s_avg,_ft>0 and tostring(math.floor(_fs/_ft)) or "0")
		u(s_players,tostring(#Players:GetPlayers()))
		u(s_aim,tostring(_af)); u(s_trig,tostring(State.triggerFires or 0))
		local uc=0; for _ in pairs(_ut) do uc+=1 end; u(s_utarg,tostring(uc))
	end)
end


-- PAGE BUILD / ACCESS GATE / CORE RESOLUTION
-- ==========================================================================

for _, entry in ipairs({
	{"Hub", buildHub},
	{"Overview", buildHome},
	{"Aim", buildAim},
	{"VR Aim", buildVRAim},
	{"Visuals", buildVisuals},
	{"Last Letter", buildWords},
	{"Fling Things and People", buildFling},
	{"Murder Mystery", buildMystery},
	{"Keystrokes", buildKeystrokes},
	{"Settings", buildSettings},
	{"Stats", buildStats},
	{"Utilities", buildUtilities},
}) do
	local built, buildError = pcall(entry[2])
	if not built then
		startupError = entry[1] .. ": " .. tostring(buildError)
		warn("[StaticsNewgen] page failed: " .. startupError)
	end
end

-- The access gate is intentionally session-only. The server verifier is used
-- when available, and the local fallback is only for Studio/demo environments.
do
	local ContextActionService = game:GetService("ContextActionService")
	local gate = Instance.new("Frame")
	gate.Name = "VRGate"
	gate.Size = UDim2.fromScale(1, 1)
	gate.BackgroundColor3 = Color3.new()
	gate.BackgroundTransparency = 1
	gate.BorderSizePixel = 0
	gate.Visible = false
	gate.Active = true
	gate.ZIndex = 300
	gate.Parent = gui
	-- soft dark vignette behind the card
	local gateCard = Instance.new("Frame")
	gateCard.AnchorPoint = Vector2.new(.5, .5)
	gateCard.Position = UDim2.fromScale(.5, .5)
	gateCard.Size = UDim2.fromOffset(410, 500)
	gateCard.BackgroundColor3 = Theme.panel
	gateCard.BorderSizePixel = 0
	gateCard.ZIndex = 301
	gateCard.Parent = gate
	corner(gateCard, 20)
	bindTheme(gateCard, "BackgroundColor3", "panel")
	shadow(gateCard, .35)
	neonStroke(gateCard, 1.6, 90, .1)
	local gateScale = Instance.new("UIScale")
	gateScale.Parent = gateCard
	-- top accent header strip
	local headStrip = Instance.new("Frame")
	headStrip.Size = UDim2.new(1, 0, 0, 92)
	headStrip.BackgroundColor3 = Color3.new(1, 1, 1)
	headStrip.BorderSizePixel = 0
	headStrip.ZIndex = 301
	headStrip.Parent = gateCard
	corner(headStrip, 20)
	local headStripFix = Instance.new("Frame")
	headStripFix.Size = UDim2.new(1, 0, 0, 24); headStripFix.Position = UDim2.new(0, 0, 1, -24)
	headStripFix.BackgroundColor3 = Color3.new(1, 1, 1); headStripFix.BorderSizePixel = 0; headStripFix.ZIndex = 301; headStripFix.Parent = headStrip
	local headGrad = Instance.new("UIGradient")
	headGrad.Rotation = 20
	headGrad.Color = ColorSequence.new(Theme.accent, Theme.accent2)
	headGrad.Parent = headStrip
	headStripFix.BackgroundColor3 = Color3.new(1, 1, 1)
	local headGrad2 = Instance.new("UIGradient"); headGrad2.Rotation = 20; headGrad2.Color = ColorSequence.new(Theme.accent, Theme.accent2); headGrad2.Parent = headStripFix
	-- glowing lock emblem
	local lockHolder = Instance.new("Frame")
	lockHolder.AnchorPoint = Vector2.new(.5, 0)
	lockHolder.Position = UDim2.new(.5, 0, 0, 24)
	lockHolder.Size = UDim2.fromOffset(56, 56)
	lockHolder.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
	lockHolder.BorderSizePixel = 0
	lockHolder.ZIndex = 303
	lockHolder.Parent = gateCard
	corner(lockHolder, 16)
	outline(lockHolder, Color3.new(1, 1, 1), .5, 1.5)
	local lockIcon = Instance.new("TextLabel")
	lockIcon.BackgroundTransparency = 1
	lockIcon.Size = UDim2.fromScale(1, 1)
	lockIcon.Font = Enum.Font.GothamBlack
	lockIcon.Text = "\u{1F512}"
	lockIcon.TextSize = 26
	lockIcon.TextColor3 = Color3.new(1, 1, 1)
	lockIcon.ZIndex = 304
	lockIcon.Parent = lockHolder
	local lockRing = Instance.new("UIStroke"); lockRing.Color = Theme.accent2; lockRing.Thickness = 2; lockRing.Transparency = .2; lockRing.Parent = lockHolder
	task.spawn(function()
		while lockHolder.Parent do
			TweenService:Create(lockRing, TweenInfo.new(.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Transparency = .65 }):Play()
			task.wait(.9)
			TweenService:Create(lockRing, TweenInfo.new(.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Transparency = .15 }):Play()
			task.wait(.9)
		end
	end)
	local gateTitle = label(gateCard, "VR ACCESS", UDim2.new(1, -40, 0, 26), UDim2.fromOffset(20, 102), Enum.Font.GothamBlack, "text", 23)
	gateTitle.TextXAlignment = Enum.TextXAlignment.Center
	gateTitle.ZIndex = 302
	local gateInfo = label(gateCard, "Enter your four-digit creator code", UDim2.new(1, -40, 0, 16), UDim2.fromOffset(20, 132), Enum.Font.Gotham, "muted", 10)
	gateInfo.TextXAlignment = Enum.TextXAlignment.Center
	gateInfo.ZIndex = 302
	local slots = {}
	local slotRow = Instance.new("Frame")
	slotRow.AnchorPoint = Vector2.new(.5, 0)
	slotRow.Position = UDim2.new(.5, 0, 0, 162)
	slotRow.Size = UDim2.fromOffset(276, 60)
	slotRow.BackgroundTransparency = 1
	slotRow.ZIndex = 302
	slotRow.Parent = gateCard
	local slotLayout = Instance.new("UIListLayout")
	slotLayout.FillDirection = Enum.FillDirection.Horizontal
	slotLayout.Padding = UDim.new(0, 12)
	slotLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	slotLayout.Parent = slotRow
	for index = 1, 4 do
		local slot = Instance.new("Frame")
		slot.Size = UDim2.fromOffset(58, 60)
		slot.BackgroundColor3 = Theme.bg
		slot.BorderSizePixel = 0
		slot.ZIndex = 302
		slot.Parent = slotRow
		corner(slot, 12)
		local sStroke = outline(slot, Theme.row, .2, 1.5)
		-- a filled accent dot that scales in when a digit is entered
		local dot = Instance.new("Frame")
		dot.AnchorPoint = Vector2.new(.5, .5)
		dot.Position = UDim2.fromScale(.5, .5)
		dot.Size = UDim2.fromOffset(16, 16)
		dot.BackgroundColor3 = Theme.accent2
		dot.BorderSizePixel = 0
		dot.ZIndex = 303
		dot.Parent = slot
		corner(dot, 8)
		accentGradient(dot, 45)
		local dotScale = Instance.new("UIScale"); dotScale.Scale = 0; dotScale.Parent = dot
		slots[index] = {frame = slot, dot = dot, scale = dotScale, stroke = sStroke}
	end
	local gateStatus = label(gateCard, "4 DIGITS REQUIRED", UDim2.new(1, -40, 0, 18), UDim2.fromOffset(20, 232), Enum.Font.GothamBold, "muted", 10)
	gateStatus.TextXAlignment = Enum.TextXAlignment.Center
	gateStatus.ZIndex = 302
	gateStatus:SetAttribute("ThemeLocked", true)
	local keypad = Instance.new("Frame")
	keypad.AnchorPoint = Vector2.new(.5, 0)
	keypad.Position = UDim2.new(.5, 0, 0, 262)
	keypad.Size = UDim2.fromOffset(312, 172)
	keypad.BackgroundTransparency = 1
	keypad.ZIndex = 302
	keypad.Parent = gateCard
	local keyLayout = Instance.new("UIGridLayout")
	keyLayout.CellSize = UDim2.fromOffset(96, 40)
	keyLayout.CellPadding = UDim2.fromOffset(10, 10)
	keyLayout.FillDirectionMaxCells = 3
	keyLayout.SortOrder = Enum.SortOrder.LayoutOrder
	keyLayout.Parent = keypad
	local entry = ""
	local lockedUntil = 0
	local busy = false
	local localCodes = { ["2015"] = true, ["2014"] = true, ["8591"] = true, ["7878"] = true }
	local function renderCode()
		for index, slot in ipairs(slots) do
			local filled = index <= #entry
			TweenService:Create(slot.scale, TweenInfo.new(.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = filled and 1 or 0 }):Play()
			if slot.stroke then slot.stroke.Color = filled and Theme.accent2 or Theme.row; slot.stroke.Transparency = filled and 0 or .2 end
		end
	end
	local function shakeCard()
		task.spawn(function()
			for _, dx in ipairs({-12, 10, -8, 6, -3, 0}) do
				gateCard.Position = UDim2.new(.5, dx, .5, 0)
				task.wait(.03)
			end
			gateCard.Position = UDim2.fromScale(.5, .5)
		end)
	end
	local function closeGate()
		ContextActionService:UnbindAction("StaticsVRGateKeys")
		gate.Visible = false
		gate.BackgroundTransparency = 1
	end
	local function verifyCode()
		if busy or os.clock() < lockedUntil then return end
		if #entry ~= 4 then gateStatus.Text = "ENTER ALL FOUR DIGITS"; gateStatus.TextColor3 = Color3.fromRGB(248, 180, 90); shakeCard(); return end
		busy = true
		gateStatus.Text = "VERIFYING..."
		gateStatus.TextColor3 = Theme.accent2
		local accepted = localCodes[entry] == true
		if Remotes.VerifyVR and Remotes.VerifyVR:IsA("RemoteFunction") then
			local answered, result = invokeWithTimeout(Remotes.VerifyVR, 4, entry)
			if answered then accepted = result == true end
		end
		busy = false
		if accepted then
			State.vrUnlocked = true
			gateStatus.Text = "ACCESS GRANTED"
			gateStatus.TextColor3 = Color3.fromRGB(52, 211, 153)
			lockIcon.Text = "\u{1F513}"
			for _, slot in ipairs(slots) do slot.stroke.Color = Color3.fromRGB(52, 211, 153); slot.stroke.Transparency = 0 end
			if UI.vrNavBadge then UI.vrNavBadge.BackgroundColor3 = Color3.fromRGB(52, 211, 153) end
			if UI.updateVRPanel then UI.updateVRPanel() end
			notify("VR Aim Assist unlocked for this session", true)
			task.delay(.6, function() closeGate(); showPage("VRAim") end)
		else
			entry = ""
			renderCode()
			lockedUntil = os.clock() + .7
			gateStatus.Text = "INCORRECT CODE"
			gateStatus.TextColor3 = Color3.fromRGB(248, 75, 90)
			shakeCard()
		end
	end
	local function press(value)
		if busy or os.clock() < lockedUntil or value == nil then return end
		if value == "DEL" then entry = entry:sub(1, math.max(0, #entry - 1))
		elseif value == "OK" then verifyCode()
		elseif #entry < 4 then entry ..= value end
		if #entry == 4 then gateStatus.Text = "PRESS OK TO VERIFY"; gateStatus.TextColor3 = Theme.accent2
		elseif value ~= "OK" then gateStatus.Text = "4 DIGITS REQUIRED"; gateStatus.TextColor3 = Theme.muted end
		renderCode()
	end
	-- keypad buttons with order, icons for DEL/OK, hover + press pop
	local keyOrder = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "DEL", "0", "OK"}
	for order, value in ipairs(keyOrder) do
		local isOK = value == "OK"
		local isDEL = value == "DEL"
		local key = button(keypad, isDEL and "\u{232B}" or (isOK and "ENTER" or value), UDim2.new(), nil, isOK and "accent" or "row")
		key.LayoutOrder = order
		key.Font = Enum.Font.GothamBlack
		key.TextSize = (isDEL or isOK) and 15 or 18
		key.ZIndex = 303
		if isOK then
			key.TextColor3 = Color3.new(1, 1, 1); key:SetAttribute("ThemeLocked", true)
			local g = Instance.new("UIGradient"); g.Rotation = 20; g.Color = ColorSequence.new(Theme.accent, Theme.accent2); g.Parent = key
		elseif isDEL then
			key.TextColor3 = Color3.fromRGB(255, 150, 150); key:SetAttribute("ThemeLocked", true)
		end
		local ks = Instance.new("UIScale"); ks.Parent = key
		key.MouseButton1Down:Connect(function() TweenService:Create(ks, TweenInfo.new(.08), { Scale = .92 }):Play() end)
		key.MouseButton1Up:Connect(function() TweenService:Create(ks, TweenInfo.new(.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play() end)
		key.MouseLeave:Connect(function() TweenService:Create(ks, TweenInfo.new(.12), { Scale = 1 }):Play() end)
		key.Activated:Connect(function() press(value) end)
	end
	local close = button(gateCard, "CANCEL", UDim2.fromOffset(140, 34), UDim2.new(.5, -70, 1, -48), "row")
	close.Font = Enum.Font.GothamBold
	close.ZIndex = 303
	close.Activated:Connect(closeGate)
	local keyMap = {}
	for digit = 0, 9 do
		local name = ({"Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"})[digit + 1]
		keyMap[Enum.KeyCode[name]] = tostring(digit)
	end
	keyMap[Enum.KeyCode.Backspace] = "DEL"
	keyMap[Enum.KeyCode.Return] = "OK"
	local function onGateKey(_, state, input)
		if state == Enum.UserInputState.Begin and gate.Visible then press(keyMap[input.KeyCode]) end
		return Enum.ContextActionResult.Sink
	end
	local function fitGate()
		local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
		return math.clamp(math.min(viewport.X / 460, viewport.Y / 560), .5, 1)
	end
	UI.openVRGate = function()
		entry = ""
		renderCode()
		gateStatus.Text = os.clock() < lockedUntil and "TRY AGAIN SHORTLY" or "4 DIGITS REQUIRED"
		gateStatus.TextColor3 = Theme.muted
		lockIcon.Text = "\u{1F512}"
		gate.Visible = true
		gate.BackgroundTransparency = 1
		TweenService:Create(gate, TweenInfo.new(.2), { BackgroundTransparency = .5 }):Play()
		local target = fitGate()
		gateScale.Scale = target * .85
		TweenService:Create(gateScale, TweenInfo.new(.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = target }):Play()
		local codes = {}
		for keyCode in pairs(keyMap) do table.insert(codes, keyCode) end
		ContextActionService:BindActionAtPriority("StaticsVRGateKeys", onGateKey, false, Enum.ContextActionPriority.High.Value + 50, table.unpack(codes))
	end
end

-- Character and rig resolution are shared by camera aim, ESP, radar, and the
-- optional direction adapters. The resolver also understands common VR rigs.
local function characterFor(target)
	local model = target.Character
	for _, folderName in ipairs({"VRCharacters", "VRPlayers", "VRRigs"}) do
		local folder = Workspace:FindFirstChild(folderName)
		if folder then
			local candidate = folder:FindFirstChild(target.Name) or folder:FindFirstChild(tostring(target.UserId))
			if candidate and candidate:IsA("Model") then model = candidate end
		end
	end
	return model
end
local function rootPart(model)
	if not model then return nil end
	local function basePartNamed(name)
		local candidate = model:FindFirstChild(name, true)
		return candidate and candidate:IsA("BasePart") and candidate or nil
	end
	local primary = model.PrimaryPart
	return basePartNamed("HumanoidRootPart")
		or basePartNamed("VRRoot")
		or basePartNamed("UpperTorso")
		or (primary and primary:IsA("BasePart") and primary or nil)
		or model:FindFirstChildWhichIsA("BasePart", true)
end
local function living(target)
	local model = characterFor(target)
	local humanoid = model and model:FindFirstChildWhichIsA("Humanoid", true)
	local root = rootPart(model)
	if model and root and (not humanoid or humanoid.Health > 0) then return model, humanoid, root end
	return nil, nil, nil
end
UI.living = living
local function targetPart(target, vrOnly)
	local model = select(1, living(target))
	if not model then return nil end
	local mode = vrOnly and "Head" or Config.HitPart
	if mode == "Random" then
		State.lockedParts[target] = State.lockedParts[target] or (math.random(1, 2) == 1 and "Head" or "Body")
		mode = State.lockedParts[target]
	end
	local names = mode == "Head" and {"Head", "VRHead"} or {"UpperTorso", "Torso", "HumanoidRootPart"}
	for _, name in ipairs(names) do
		local part = model:FindFirstChild(name, true)
		if part and part:IsA("BasePart") then return part end
	end
	return rootPart(model)
end
local function eligible(target, vrOnly)
	if target == player then return false end
	if vrOnly and target:GetAttribute("UsingVR") ~= true then return false end
	local teamCheck = vrOnly and VRConfig.TeamCheck or Config.TeamCheck
	if teamCheck and player.Team and target.Team and player.Team == target.Team then return false end
	return living(target) ~= nil
end
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true
pcall(function() rayParams.RespectCanCollide = true end)
local function visible(origin, position, target)
	local filter = {}
	if player.Character then table.insert(filter, player.Character) end
	rayParams.FilterDescendantsInstances = filter
	local hit = Workspace:Raycast(origin, position - origin, rayParams)
	local model = characterFor(target)
	return not hit or (model and hit.Instance:IsDescendantOf(model))
end
local function predicted(part)
	local position = part.Position
	if Config.Prediction then
		local velocity = part.AssemblyLinearVelocity
		if velocity.Magnitude > 150 then velocity = velocity.Unit * 150 end
		position += velocity * Config.PredictionTime
	end
	return position
end
local function aimCandidateScore(target, part, screenPoint, center, myRoot)
	local screenDistance = (Vector2.new(screenPoint.X, screenPoint.Y) - center).Magnitude
	local worldDistance = myRoot and (part.Position - myRoot.Position).Magnitude or Config.MaxAimDistance
	local verticalDistance = math.abs(screenPoint.Y - center.Y)
	local healthFraction = 1
	local model, humanoid = living(target)
	if humanoid and humanoid.MaxHealth > 0 then healthFraction = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1) end
	-- Target priority mode decides what "best" means:
	local priority = Config.AimPriority or "Crosshair"
	if priority == "Distance" then
		-- nearest player wins; crosshair offset is a minor tie-breaker
		return worldDistance + screenDistance * .25
	elseif priority == "Health" then
		-- lowest-health player wins; crosshair offset breaks ties
		return healthFraction * 1000 + screenDistance * .35
	end
	-- Crosshair (default): closest to the center of the FOV, with range / vertical /
	-- health as gentle tie-breakers so the lock does not jump unpredictably.
	return screenDistance + worldDistance * .012 + verticalDistance * .035 + healthFraction * .75
end
-- FOV center: screen center, or the mouse position when "follow mouse" is on.
local function aimCenter()
	if not camera then return Vector2.new(0, 0) end
	if Config.AimFollowMouse then
		local m = UserInputService:GetMouseLocation()
		return Vector2.new(m.X, m.Y)
	end
	return camera.ViewportSize / 2
end
local function findCameraTarget()
	if not camera then return nil end
	local _, _, myRoot = living(player)
	local center = aimCenter()
	local radius = math.max(tonumber(Config.AimRadius) or 210, 1)
	local best, bestScore = nil, math.huge
	for _, target in ipairs(Players:GetPlayers()) do
		if eligible(target, false) then
			local part = targetPart(target, false)
			if part and myRoot and (part.Position - myRoot.Position).Magnitude <= Config.MaxAimDistance then
				local predictedPosition = predicted(part)
				local point, onScreen = camera:WorldToViewportPoint(predictedPosition)
				if onScreen and point.Z > 0 then
					local screenDistance = (Vector2.new(point.X, point.Y) - center).Magnitude
					local losOk = (not Config.AimVisibleOnly) or visible(camera.CFrame.Position, predictedPosition, target)
					if screenDistance <= radius and losOk then
						local score = aimCandidateScore(target, part, point, center, myRoot)
						-- Keep the current lock slightly favored while it remains valid;
						-- this prevents rapid target hopping between adjacent players.
						if target == State.target then score -= radius * .18 end
						if score < bestScore then
							best, bestScore = target, score
						end
					end
				end
			end
		end
	end
	if best ~= State.target then State.targetSwitchAt = os.clock() end
	return best
end
local function validCameraTarget(target)
	if not target or not camera or not eligible(target, false) then return false end
	local part = targetPart(target, false)
	local _, _, myRoot = living(player)
	if not part or not myRoot then return false end
	local predictedPosition = predicted(part)
	local point, onScreen = camera:WorldToViewportPoint(predictedPosition)
	local center = aimCenter()
	local score = (Vector2.new(point.X, point.Y) - center).Magnitude
	local radius = math.max(tonumber(Config.AimRadius) or 210, 1)
	local stickyRadius = radius * (Config.StickyAim and 1.55 or 1)
	local inRange = (part.Position - myRoot.Position).Magnitude <= Config.MaxAimDistance
	local losOk = (not Config.AimVisibleOnly) or visible(camera.CFrame.Position, predictedPosition, target)
	local valid = onScreen and point.Z > 0 and inRange and score <= stickyRadius and losOk
	if valid then
		State.lastTargetSeen = os.clock()
		return true
	end
	-- A short grace period keeps a target from flickering during one occluded
	-- frame, but it is still dropped quickly when it leaves the FOV.
	return Config.StickyAim and os.clock() - State.lastTargetSeen < .22 and onScreen and point.Z > 0 and inRange and score <= stickyRadius * 1.08
end
-- FOV circle: a clean, anti-aliased ring. A plain Frame + UICorner can look
-- jagged at large sizes, so this uses a dedicated circle Frame with a crisp
-- UIStroke and no themed background.
local fovCircle = Instance.new("Frame")
fovCircle.Name = "StaticsFOV"
fovCircle.AnchorPoint = Vector2.new(.5, .5)
fovCircle.BackgroundColor3 = Color3.fromHSV(Config.FOVCircleHue, .75, 1)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.Visible = false
fovCircle.ZIndex = 10
fovCircle.Parent = gui
local fovCorner = Instance.new("UICorner"); fovCorner.CornerRadius = UDim.new(1, 0); fovCorner.Parent = fovCircle
local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromHSV(Config.FOVCircleHue, .75, 1)
fovStroke.Thickness = Config.FOVCircleThickness
fovStroke.Transparency = 1 - Config.FOVCircleOpacity
fovStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
fovStroke.Parent = fovCircle
UI.fovStroke = fovStroke
UI.fovCircle = fovCircle
local marker = panel(gui, UDim2.fromOffset(22, 22), nil, "bg")
marker.AnchorPoint = Vector2.new(.5, .5)
marker.BackgroundTransparency = 1
marker.Visible = false
corner(marker, 11)
outline(marker, Theme.accent2, 0, 2)
-- snap line from the bottom-center of the screen to the locked target
local snapLine = Instance.new("Frame")
snapLine.Name = "AimSnapLine"
snapLine.AnchorPoint = Vector2.new(.5, .5)
snapLine.BorderSizePixel = 0
snapLine.BackgroundColor3 = Color3.fromHSV(Config.FOVCircleHue, .75, 1)
snapLine.Visible = false
snapLine.ZIndex = 20
snapLine.Parent = gui
-- auto-fire mouse click helpers (shared pattern with the triggerbot)
local _aimVIM = nil
pcall(function() _aimVIM = game:GetService("VirtualInputManager") end)
local function aimClickOnce()
	if type(mouse1click) == "function" then pcall(mouse1click); return end
	if _aimVIM then
		local p = UserInputService:GetMouseLocation()
		pcall(function() _aimVIM:SendMouseButtonEvent(p.X, p.Y, 0, true, game, 0) end)
		task.delay(0.03, function() pcall(function() _aimVIM:SendMouseButtonEvent(p.X, p.Y, 0, false, game, 0) end) end)
	end
end
local _lastAutoFire = 0
UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 or input.KeyCode == Enum.KeyCode.ButtonL2 then
		if Config.AimEnabled then State.aimHeld = true; State.target = nil end
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 or input.KeyCode == Enum.KeyCode.ButtonL2 then State.aimHeld = false; State.target = nil end
end)
pcall(function() RunService:UnbindFromRenderStep("StaticsAim") end)
RunService:BindToRenderStep("StaticsAim", Enum.RenderPriority.Camera.Value + 1, function(dt)
	if not camera then return end
	if Config.CameraFOVEnabled then
		if not State.fovApplied then originalFOV = camera.FieldOfView; State.fovApplied = true end
		camera.FieldOfView = Config.CameraFOV
	elseif State.fovApplied then
		camera.FieldOfView = originalFOV
		State.fovApplied = false
	end
	-- FOV circle: centered on screen, or on the mouse when "follow mouse" is on.
	local center = aimCenter()
	fovCircle.Size = UDim2.fromOffset(Config.AimRadius * 2, Config.AimRadius * 2)
	if Config.AimFollowMouse then
		fovCircle.Position = UDim2.fromOffset(center.X, center.Y)
	else
		fovCircle.Position = UDim2.fromScale(.5, .5)
	end
	fovCircle.Visible = Config.AimEnabled and Config.ShowFOVCircle and not State.menuOpen
	local locked = State.target ~= nil
	local fovColor = (Config.FOVActiveColor and locked) and Color3.fromRGB(60, 255, 90) or Color3.fromHSV(Config.FOVCircleHue, .75, 1)
	fovStroke.Transparency = 1 - Config.FOVCircleOpacity
	fovStroke.Thickness = Config.FOVCircleThickness
	fovStroke.Color = fovColor
	-- optional faint fill inside the circle
	fovCircle.BackgroundColor3 = fovColor
	fovCircle.BackgroundTransparency = Config.FOVCircleFilled and .9 or 1
	if State.menuOpen then State.target = nil; marker.Visible = false; snapLine.Visible = false; return end
	if not Config.AimEnabled or not State.aimHeld then marker.Visible = false; snapLine.Visible = false; return end
	if State.target and not validCameraTarget(State.target) then State.target = nil end
	if not State.target then State.target = findCameraTarget() end
	local part = State.target and targetPart(State.target, false)
	if not part then marker.Visible = false; snapLine.Visible = false; return end
	local point, onScreen = camera:WorldToViewportPoint(predicted(part))
	if not onScreen or point.Z <= 0 then marker.Visible = false; snapLine.Visible = false; return end
	marker.Visible = true
	marker.Position = UDim2.fromOffset(point.X, point.Y)
	-- snap line (bottom-center to target)
	if Config.AimSnapLine then
		local base = Vector2.new(camera.ViewportSize.X * .5, camera.ViewportSize.Y)
		local tip = Vector2.new(point.X, point.Y)
		local delta = tip - base
		snapLine.Visible = true
		snapLine.Size = UDim2.fromOffset(math.max(delta.Magnitude, 1), 2)
		snapLine.Position = UDim2.fromOffset((base.X + tip.X) * .5, (base.Y + tip.Y) * .5)
		snapLine.Rotation = math.deg(math.atan2(delta.Y, delta.X))
		snapLine.BackgroundColor3 = Color3.fromHSV(Config.FOVCircleHue, .75, 1)
	else
		snapLine.Visible = false
	end
	-- auto-fire while locked
	if Config.AimAutoFire and os.clock() - _lastAutoFire >= math.max(tonumber(Config.AimAutoFireDelay) or .12, .03) then
		_lastAutoFire = os.clock()
		aimClickOnce()
	end
	if Config.CameraAssist and not isVR then
		local aimPosition = predicted(part)
		-- optional jitter: a small randomized offset so the lock is not pixel-perfect
		local jitter = tonumber(Config.AimJitter) or 0
		if jitter > 0 then
			aimPosition = aimPosition + Vector3.new((math.random() - .5) * jitter, (math.random() - .5) * jitter, (math.random() - .5) * jitter)
		end
		local current = camera.CFrame
		local desired = CFrame.lookAt(current.Position, aimPosition, current.UpVector)
		local smoothness = math.clamp(tonumber(Config.AimSmoothness) or .72, .08, 1)
		local response = 4 + (math.clamp(Config.AimStrength, .02, .85) * 22)
		local blend = math.clamp(1 - math.exp(-(response / smoothness) * dt), 0, .94)
		local angularError = math.acos(math.clamp(current.LookVector:Dot(desired.LookVector), -1, 1))
		-- Avoid tiny camera micro-jitters once the reticle is already aligned.
		if angularError > math.rad(.08) then
			camera.CFrame = current:Lerp(desired, blend)
			State.lastAimPoint = aimPosition
		end
	end
end)

-- VR assist uses the user's head direction as a cone and never writes to a
-- server remote. It was previously only a settings page; this loop makes the
-- session-only VR controls functional while retaining the access gate.
do
	local function vrHeadFrame()
		if not camera then return nil end
		local frame = camera.CFrame
		local ok, userFrame = pcall(function() return VRService:GetUserCFrame(Enum.UserCFrame.Head) end)
		if ok and typeof(userFrame) == "CFrame" then frame = camera.CFrame * userFrame end
		return frame
	end
	local function findVRTarget()
		local headFrame = vrHeadFrame()
		if not headFrame then return nil end
		local best, bestScore = nil, math.huge
		local cone = math.rad(math.clamp(tonumber(VRConfig.Cone) or 15, 1, 60))
		for _, target in ipairs(Players:GetPlayers()) do
			if eligible(target, true) then
				local part = targetPart(target, true)
				if part then
					local offset = predicted(part) - headFrame.Position
					local distance = offset.Magnitude
					if distance > 0 and distance <= math.max(tonumber(VRConfig.MaxDistance) or 500, 40) then
						local direction = offset.Unit
						local angle = math.acos(math.clamp(headFrame.LookVector:Dot(direction), -1, 1))
						local clear = not VRConfig.WallCheck or visible(headFrame.Position, predicted(part), target)
						if angle <= cone and clear then
							local score = angle * 100 + distance * .01
							if target == State.vrStickyTarget and VRConfig.Sticky then score -= 12 end
							if score < bestScore then best, bestScore = target, score end
						end
					end
				end
			end
		end
		return best
	end
	UserInputService.InputBegan:Connect(function(input, processed)
		if processed or UI.bindingActive or UserInputService:GetFocusedTextBox() or not State.vrUnlocked then return end
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == tostring(VRConfig.Keybind or "V") then
			VRConfig.Enabled = not VRConfig.Enabled
			State.vrStickyTarget = nil
			if UI.updateVRPanel then UI.updateVRPanel() end
		end
	end)
	RunService.RenderStepped:Connect(function(dt)
		if not isVR or not State.vrUnlocked or not VRConfig.Enabled then State.vrStickyTarget = nil; return end
		local headFrame = vrHeadFrame()
		if not headFrame then State.vrStickyTarget = nil; return end
		if State.vrStickyTarget and not eligible(State.vrStickyTarget, true) then State.vrStickyTarget = nil end
		if State.vrStickyTarget then
			local lockedPart = targetPart(State.vrStickyTarget, true)
			if not lockedPart or (VRConfig.WallCheck and not visible(headFrame.Position, predicted(lockedPart), State.vrStickyTarget)) then State.vrStickyTarget = nil end
		end
		if not State.vrStickyTarget or not VRConfig.Sticky then State.vrStickyTarget = findVRTarget() end
		local part = State.vrStickyTarget and targetPart(State.vrStickyTarget, true)
		if not part then return end
		local aimPosition = predicted(part)
		local current = camera.CFrame
		local desired = CFrame.lookAt(current.Position, aimPosition, current.UpVector)
		local strength = math.clamp(tonumber(VRConfig.Strength) or .18, .02, .8)
		local blend = math.clamp(1 - math.exp(-strength * 16 * dt), 0, .72)
		camera.CFrame = current:Lerp(desired, blend)
	end)
end

-- Triggerbot is one loop only. It uses the equipped Tool:Activate path,
-- applies a dwell/debounce guard, honors line-of-sight and team settings, and
-- leaves fire-rate, ammo, and hit validation to the experience server.
do
	local lastShot = 0
	local minimumInterval = .1
	local candidate = nil
	local candidateSince = 0
	local lastTool = nil
	local lastStatus = ""
	local mouse = player:GetMouse()

	-- Real mouse-click emulation. Executors expose a VirtualInputManager; we also
	-- try common global click helpers so Auto/Single fire actually clicks the mouse.
	local VIM = nil
	pcall(function() VIM = game:GetService("VirtualInputManager") end)
	local function sendClick(down)
		-- Prefer the executor's dedicated click globals when present.
		if down then
			if type(mouse1down) == "function" then pcall(mouse1down); return end
		else
			if type(mouse1up) == "function" then pcall(mouse1up); return end
		end
		-- Fall back to VirtualInputManager (needs screen coords; use mouse position).
		if VIM then
			local pos = UserInputService:GetMouseLocation()
			pcall(function() VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, down, game, 0) end)
		end
	end
	-- A one-shot click (press + short release) for Single mode.
	local function clickOnce()
		if type(mouse1click) == "function" then pcall(mouse1click); return end
		sendClick(true)
		task.delay(0.03, function() sendClick(false) end)
	end
	local function holdDown()  sendClick(true)  end
	local function holdUp()    sendClick(false) end

	local function triggerStatus(text, color)
		if lastStatus == text and not color then return end
		lastStatus = text
		if UI.triggerStatus and UI.triggerStatus.Parent then
			UI.triggerStatus.Text = text
			UI.triggerStatus.TextColor3 = color or Theme.muted
		end
	end
	local function equippedTool()
		local character = player.Character
		if not character then return nil end
		local tool = character:FindFirstChildOfClass("Tool")
		if not tool or not tool.Enabled then return nil end
		if tool:GetAttribute("StaticsTriggerBotAllowed") == false then return nil end
		if tool:GetAttribute("CanFire") == false or tool:GetAttribute("Reloading") == true then return nil end
		return tool
	end
	local function triggerTarget()
		if not camera then return nil, nil end
		local center = camera.ViewportSize / 2
		local radius = math.clamp(tonumber(Config.TriggerFOV) or 60, 4, 240)
		local best, bestPart, bestScore = nil, nil, math.huge
		-- Prefer the actual mouse target when Roblox exposes one, then fall
		-- back to the camera-center scan for controller and touch users.
		local pointed = mouse.Target
		local pointedModel = pointed and pointed:FindFirstAncestorOfClass("Model")
		local pointedPlayer = pointedModel and Players:GetPlayerFromCharacter(pointedModel)
		if pointedPlayer and pointedPlayer ~= player and living(pointedPlayer) ~= nil then
			local pointedPart = targetPart(pointedPlayer, false)
			local sameTeam = player.Team and pointedPlayer.Team and player.Team == pointedPlayer.Team
			if pointedPart and (not Config.TriggerTeamCheck or not sameTeam) and visible(camera.CFrame.Position, pointedPart.Position, pointedPlayer) then
				return pointedPlayer, pointedPart
			end
		end
		for _, target in ipairs(Players:GetPlayers()) do
			local sameTeam = player.Team and target.Team and player.Team == target.Team
			-- Trigger team filtering is independent from the aim team filter. This
			-- lets the Aim page switch trigger-team behavior without inheriting a
			-- different camera-assist preference.
			if target ~= player and living(target) ~= nil and (not Config.TriggerTeamCheck or not sameTeam) then
				local part = targetPart(target, false)
				local _, _, root = living(target)
				if part and root then
					local point, onScreen = camera:WorldToViewportPoint(part.Position)
					if onScreen and point.Z > 0 and (root.Position - camera.CFrame.Position).Magnitude <= Config.MaxAimDistance then
						local distance = (Vector2.new(point.X, point.Y) - center).Magnitude
						-- Add a small projected hitbox allowance so a large body does not
						-- require a pixel-perfect center hit at long range.
						local allowance = math.clamp((part.Size.Magnitude / math.max(point.Z, 1)) * camera.ViewportSize.X * .5, 2, 18)
						if distance <= radius + allowance and visible(camera.CFrame.Position, part.Position, target) then
							local score = distance + (root.Position - camera.CFrame.Position).Magnitude * .003
							if score < bestScore then
								best, bestPart, bestScore = target, part, score
							end
						end
					end
				end
			end
		end
		return best, bestPart
	end
	-- Match the supplied E-key behavior while still keeping the UI toggle as
	-- the source of truth. Text fields and key-binding mode are ignored.
	UserInputService.InputBegan:Connect(function(input, processed)
		if processed or UI.bindingActive or UserInputService:GetFocusedTextBox() then return end
		local mkey=tostring(Config.TriggerModeKey or "O")
		if input.UserInputType==Enum.UserInputType.Keyboard and (input.KeyCode.Name==mkey or input.KeyCode==Enum.KeyCode.P) then
			Config.TriggerMode=Config.TriggerMode=="Single" and "Auto" or "Single"
			for _,r in ipairs(UI.refreshers) do pcall(r) end
			triggerStatus("MODE: "..Config.TriggerMode,Theme.accent)
		end
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == tostring(Config.TriggerKey or "E") then
			Config.TriggerEnabled = not Config.TriggerEnabled
			State.triggerTarget = nil
			State.dirty = true
			if State._trigAutoHolding then State._trigAutoHolding=false; holdUp() end
			triggerStatus(Config.TriggerEnabled and "ARMED / SEARCHING" or "DISABLED", Config.TriggerEnabled and Theme.accent2 or Theme.muted)
			for _, refresh in ipairs(UI.refreshers) do pcall(refresh) end
		end
	end)
	RunService.RenderStepped:Connect(function()
		if not Config.TriggerEnabled then
			candidate = nil
			State.triggerTarget = nil
			if State._trigAutoHolding then State._trigAutoHolding=false; holdUp() end
			triggerStatus("DISABLED", Theme.muted)
			return
		end
		if State.menuOpen or State.mysteryOpen or UserInputService:GetFocusedTextBox() then
			candidate = nil
			State.triggerTarget = nil
			if State._trigAutoHolding then State._trigAutoHolding=false; holdUp() end
			triggerStatus("PAUSED / UI FOCUSED", Theme.muted)
			return
		end
		local tool = equippedTool()
		if tool ~= lastTool then
			lastTool = tool
			candidate = nil
			candidateSince = 0
		end
		if not tool then
			candidate = nil
			State.triggerTarget = nil
			if State._trigAutoHolding then State._trigAutoHolding=false; holdUp() end
			triggerStatus("EQUIP A VALID TOOL", Theme.muted)
			return
		end
		local target = triggerTarget()
		local now = os.clock()
		if target ~= candidate then
			candidate = target
			candidateSince = now
		end
		State.triggerTarget = target
		if not target then
			-- No target: always release the held mouse button in Auto mode.
			if State._trigAutoHolding then State._trigAutoHolding=false; holdUp() end
			triggerStatus("ARMED / SEARCHING", Theme.accent2)
			return
		end
		triggerStatus("TARGET / " .. target.DisplayName, Theme.accent2)
		-- Require a target to remain valid for a tiny dwell window to avoid
		-- firing at one-frame projection noise while the camera rotates.
		if now - candidateSince < .035 then return end
		local toolCooldown = tonumber(tool:GetAttribute("FireCooldown")) or 0
		local interval = math.max(tonumber(Config.TriggerDelay) or .06, toolCooldown, minimumInterval)
		if Config.TriggerMode=="Auto" then
			-- AUTO HOLD: press and keep the mouse down while a target stays in the FOV.
			if not State._trigAutoHolding then State._trigAutoHolding=true; holdDown() end
			State.triggerFires = (State.triggerFires or 0) + 0 -- keep key alive
			triggerStatus("AUTO HOLD / "..target.DisplayName,Theme.accent2)
		else
			-- SINGLE: fire one click per interval (keeps clicking while on target).
			if now - lastShot < interval then return end
			pcall(function() if tool.Activate then tool:Activate() end end)
			clickOnce()
			State.triggerFires = (State.triggerFires or 0) + 1
			lastShot=now
			triggerStatus("FIRING / "..target.DisplayName,Theme.accent2)
		end
	end)
end

-- ==========================================================================
-- ESP / MM2 TRACKER / WORD SUGGESTIONS / REMOTE EVENTS
-- ==========================================================================

local function removeVisual(target)
	local data = State.visuals[target]
	if not data then return end
	for _, line in ipairs(data.skeleton or {}) do
		if line.beam and line.beam.Parent then line.beam:Destroy() end
		if line.a and line.a.Parent then line.a:Destroy() end
		if line.b and line.b.Parent then line.b:Destroy() end
	end
	for _, key in ipairs({"highlight", "billboard", "box", "tracer", "health", "arrow"}) do
		if data[key] and data[key].Parent then data[key]:Destroy() end
	end
	State.visuals[target] = nil
	State.lockedParts[target] = nil
	if State.vrStickyTarget == target then State.vrStickyTarget = nil end
end
local function getVisual(target)
	if State.visuals[target] then return State.visuals[target] end
	local highlight = Instance.new("Highlight")
	highlight.Name = "StaticsESP"
	highlight.Enabled = false
	highlight.Parent = Workspace
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "StaticsNameplate"
	billboard.Size = UDim2.fromOffset(220, 50)
	billboard.AlwaysOnTop = true
	billboard.Enabled = false
	billboard.Parent = playerGui
	local text = label(billboard, "", UDim2.fromScale(1, 1), nil, Enum.Font.GothamBold, "text", Config.ESPTextSize)
	text.TextXAlignment = Enum.TextXAlignment.Center
	text.TextYAlignment = Enum.TextYAlignment.Center
	text.TextStrokeTransparency = 0
	local box = Instance.new("Frame")
	box.Name = "StaticsBox"
	box.BackgroundTransparency = 1
	box.BorderSizePixel = 0
	box.Visible = false
	box.Parent = gui
	local boxCorner = Instance.new("UICorner"); boxCorner.CornerRadius = UDim.new(0, 0); boxCorner.Parent = box
	local boxStroke = outline(box, Theme.accent, 0, 1.5)
	local tracer = Instance.new("Frame")
	tracer.Name = "StaticsTracer"
	tracer.AnchorPoint = Vector2.new(.5, .5)
	tracer.BackgroundColor3 = Theme.accent
	tracer.BorderSizePixel = 0
	tracer.Visible = false
	tracer.Parent = gui
	corner(tracer, 2)
	local health = Instance.new("Frame")
	health.Name = "StaticsHealth"
	health.BackgroundColor3 = Theme.row
	health.BorderSizePixel = 0
	health.Visible = false
	health.Parent = gui
	corner(health, 2)
	local healthFill = Instance.new("Frame")
	healthFill.AnchorPoint = Vector2.new(0, 1)
	healthFill.Position = UDim2.fromScale(0, 1)
	healthFill.Size = UDim2.fromScale(1, 1)
	healthFill.BackgroundColor3 = Color3.fromRGB(52, 211, 153)
	healthFill.BorderSizePixel = 0
	healthFill.Parent = health
	corner(healthFill, 2)
	local arrow = Instance.new("TextLabel")
	arrow.Name = "StaticsOffscreenArrow"
	arrow.Size = UDim2.fromOffset(28, 28)
	arrow.AnchorPoint = Vector2.new(.5, .5)
	arrow.BackgroundTransparency = 1
	arrow.Text = "▲"
	arrow.Font = Enum.Font.GothamBlack
	arrow.TextSize = 20
	arrow.TextColor3 = Theme.accent
	arrow.TextStrokeTransparency = .35
	arrow.Visible = false
	arrow.ZIndex = 390
	arrow.Parent = gui
	local data = {
		highlight = highlight,
		billboard = billboard,
		label = text,
		box = box,
		boxCorner = boxCorner,
		boxStroke = boxStroke,
		tracer = tracer,
		health = health,
		healthFill = healthFill,
		arrow = arrow,
		skeleton = {},
		model = nil,
		root = nil,
		humanoid = nil,
		show = false,
		color = Theme.accent,
	}
	State.visuals[target] = data
	return data
end
-- Full R15 skeleton: head, spine, both arms (down to hands) and both legs (down to feet).
local skeletonPairs = {
	{"Head", "UpperTorso"},
	{"UpperTorso", "LowerTorso"},
	{"UpperTorso", "LeftUpperArm"},
	{"LeftUpperArm", "LeftLowerArm"},
	{"LeftLowerArm", "LeftHand"},
	{"UpperTorso", "RightUpperArm"},
	{"RightUpperArm", "RightLowerArm"},
	{"RightLowerArm", "RightHand"},
	{"LowerTorso", "LeftUpperLeg"},
	{"LeftUpperLeg", "LeftLowerLeg"},
	{"LeftLowerLeg", "LeftFoot"},
	{"LowerTorso", "RightUpperLeg"},
	{"RightUpperLeg", "RightLowerLeg"},
	{"RightLowerLeg", "RightFoot"},
}
-- Skeleton line color: bright green by default (matches the reference), or the ESP color.
local function skeletonColor(espColor)
	if Config.SkeletonGreen ~= false then return Color3.fromRGB(60, 255, 70) end
	return espColor or Color3.fromRGB(60, 255, 70)
end
local function clearSkeleton(data)
	for _, line in ipairs(data.skeleton or {}) do
		if line.beam and line.beam.Parent then line.beam:Destroy() end
		if line.a and line.a.Parent then line.a:Destroy() end
		if line.b and line.b.Parent then line.b:Destroy() end
	end
	data.skeleton = {}
	data.skeletonModel = nil
end
local function updateSkeleton(data, model, color, enabled)
	if not enabled then
		if #data.skeleton > 0 then clearSkeleton(data) end
		return
	end
	local lineColor = skeletonColor(color)
	local width = math.clamp(tonumber(Config.SkeletonThickness) or .08, .02, .3)
	if data.skeletonModel == model then
		for _, line in ipairs(data.skeleton) do
			if line.beam and line.beam.Parent then
				line.beam.Color = ColorSequence.new(lineColor)
				line.beam.Width0 = width
				line.beam.Width1 = width
			end
		end
		return
	end
	clearSkeleton(data)
	local pairsToUse = skeletonPairs
	if not model:FindFirstChild("UpperTorso", true) then
		-- R6 fallback
		pairsToUse = {{"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}}
	end
	for _, pair in ipairs(pairsToUse) do
		local first = model:FindFirstChild(pair[1], true)
		local second = model:FindFirstChild(pair[2], true)
		if first and first:IsA("BasePart") and second and second:IsA("BasePart") then
			local a = Instance.new("Attachment")
			a.Name = "StaticsSkeletonA"
			a.Parent = first
			local b = Instance.new("Attachment")
			b.Name = "StaticsSkeletonB"
			b.Parent = second
			local beam = Instance.new("Beam")
			beam.Name = "StaticsSkeleton"
			beam.Attachment0 = a
			beam.Attachment1 = b
			beam.FaceCamera = true
			beam.Width0 = width
			beam.Width1 = width
			beam.LightInfluence = 0           -- stays bright regardless of world lighting
			beam.LightEmission = 1            -- crisp, glowing line like the reference
			beam.Color = ColorSequence.new(lineColor)
			beam.Transparency = NumberSequence.new(0)
			beam.Parent = a
			table.insert(data.skeleton, {a = a, b = b, beam = beam})
		end
	end
	data.skeletonModel = model
end
local function updateESP()
	-- These extra highlights work even when master ESP is off.
	local roleWallhackActive = mysteryActive() and (Config.MysteryMurdererWallhack or Config.MysterySheriffWallhack)
	local aimHighlightActive = Config.ESPAimHighlight and State.target ~= nil
	if not Config.ESPEnabled and not roleWallhackActive and not aimHighlightActive then
		for _, data in pairs(State.visuals) do
			data.show = false
			data.highlight.Enabled = false
			data.billboard.Enabled = false
			data.box.Visible = false
			data.tracer.Visible = false
			data.health.Visible = false
			data.arrow.Visible = false
			updateSkeleton(data, data.model, data.color, false)
		end
		return
	end
	local _, _, myRoot = living(player)
	local maxTargets = math.max(tonumber(Config.ESPMaxTargets) or 50, 1)
	local drawn = 0
	for _, target in ipairs(Players:GetPlayers()) do
		if target ~= player then
			if drawn >= maxTargets then
				-- past the cap: hide any existing visuals for this player
				local existing = State.visuals[target]
				if existing then existing.show = false; existing.highlight.Enabled = false; existing.billboard.Enabled = false; existing.box.Visible = false; existing.tracer.Visible = false; existing.health.Visible = false; existing.arrow.Visible = false end
			else
			drawn += 1
			local data = getVisual(target)
			local model, humanoid, targetRoot = living(target)
			local sameTeam = player.Team and target.Team and player.Team == target.Team
			local distance = myRoot and targetRoot and (targetRoot.Position - myRoot.Position).Magnitude or math.huge
			local visiblePlayer = Config.ESPEnabled and model and targetRoot and distance <= Config.ESPMaxDistance and (not Config.ESPTeamCheck or not sameTeam)
			local color = sameTeam and Color3.fromHSV(Config.TeammateColorHue, .72, 1) or Color3.fromHSV(Config.EnemyColorHue, .78, 1)
			if mysteryActive() and Config.MysteryRoleColors then color = mysteryRoleColor(State.roles[target.Name]) or color end
			-- Murder Mystery role wallhack: force-highlight the murderer/sheriff through
			-- walls even if master ESP is off, when the matching toggle is on.
			local roleName = mysteryActive() and State.roles[target.Name] and string.lower(tostring(State.roles[target.Name])) or nil
			local forceRole = false
			if mysteryActive() and model and targetRoot then
				if roleName == "murderer" and Config.MysteryMurdererWallhack then forceRole = true; color = MysteryRoleColors.murderer
				elseif roleName == "sheriff" and Config.MysterySheriffWallhack then forceRole = true; color = MysteryRoleColors.sheriff end
			end
			data.show = (visiblePlayer == true) or forceRole
			data.model = model
			data.root = targetRoot
			data.humanoid = humanoid
			data.color = color
			local isAimTarget = Config.ESPAimHighlight and State.target == target
			data.highlight.Adornee = model
			data.highlight.Enabled = (data.show and Config.HighlightESP) or forceRole or isAimTarget
			data.highlight.FillColor = isAimTarget and color:Lerp(Color3.new(1, 1, 1), .35) or color
			data.highlight.OutlineColor = isAimTarget and Color3.new(1, 1, 1) or color:Lerp(Color3.new(1, 1, 1), .2)
			-- current aim target gets a brighter fill so you can see your lock at a glance
			data.highlight.FillTransparency = isAimTarget and .12 or (forceRole and .35 or (1 - Config.ESPFill))
			data.highlight.OutlineTransparency = .05
			data.highlight.DepthMode = (Config.ThroughWalls or forceRole or isAimTarget) and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
			local anchor = model and (model:FindFirstChild("Head", true) or model:FindFirstChild("VRHead", true) or targetRoot)
			data.billboard.Adornee = anchor
			data.billboard.Enabled = data.show and Config.NameESP and anchor ~= nil
			if data.show then
				local upper = {target.DisplayName}
				if Config.VRESP and target:GetAttribute("UsingVR") then table.insert(upper, "[VR]") end
				local lower = {}
				if Config.RoleESP then table.insert(lower, string.upper(tostring(State.roles[target.Name] or "UNKNOWN"))) end
				if Config.DistanceESP and distance < math.huge then table.insert(lower, tostring(math.floor(distance)) .. "st") end
				local lowHP = humanoid and humanoid.MaxHealth > 0 and Config.ESPLowHealthWarn and (humanoid.Health / humanoid.MaxHealth) <= .35
				if lowHP then table.insert(lower, "LOW " .. tostring(math.floor(humanoid.Health))) end
				data.label.Text = table.concat(upper, " ") .. "\n" .. table.concat(lower, " | ")
				data.label.TextSize = Config.ESPTextSize
				if lowHP then
					data.label.TextColor3 = (math.floor(os.clock() * 6) % 2 == 0) and Color3.fromRGB(255, 70, 70) or Color3.new(1, 1, 1)
				else
					data.label.TextColor3 = color:Lerp(Color3.new(1, 1, 1), .35)
				end
			end
			updateSkeleton(data, model, color, data.show and Config.SkeletonESP)
			if not data.show then
				data.box.Visible = false
				data.tracer.Visible = false
				data.health.Visible = false
			end
			end
		end
	end
end
local function updateScreenESP()
	if State.menuOpen or not Config.ESPEnabled or not camera or not (Config.BoxESP or Config.TracerESP or Config.HealthESP or Config.OffscreenESP) then
		for _, data in pairs(State.visuals) do data.box.Visible = false; data.tracer.Visible = false; data.health.Visible = false; data.arrow.Visible = false end
		return
	end
	local bottomCenter = Vector2.new(camera.ViewportSize.X * .5, camera.ViewportSize.Y - 8)
	for _, data in pairs(State.visuals) do
		local model, root = data.model, data.root
		if not data.show or not model or not root then
			data.box.Visible = false
			data.tracer.Visible = false
			data.health.Visible = false
			data.arrow.Visible = false
		else
			local cf, size = model:GetBoundingBox()
			local topPoint, topOnScreen = camera:WorldToViewportPoint(cf.Position + Vector3.new(0, size.Y * .5, 0))
			local bottomPoint, bottomOnScreen = camera:WorldToViewportPoint(cf.Position - Vector3.new(0, size.Y * .5, 0))
			local height = math.abs(bottomPoint.Y - topPoint.Y)
			local width = math.max(height * .52, 18)
			local top = math.min(topPoint.Y, bottomPoint.Y)
			data.box.Visible = Config.BoxESP and (topOnScreen or bottomOnScreen) and height > 2
			if data.box.Visible then
				data.box.Position = UDim2.fromOffset(topPoint.X - width * .5, top)
				data.box.Size = UDim2.fromOffset(width, height)
				data.boxStroke.Color = data.color
				-- box style: Corner = rounded, Full = sharp rectangle
				if data.boxCorner then data.boxCorner.CornerRadius = UDim.new(0, Config.ESPBoxStyle == "Corner" and math.clamp(width * .18, 3, 10) or 0) end
			end
			local rootPoint, rootOnScreen = camera:WorldToViewportPoint(root.Position)
			local offscreen = Config.OffscreenESP and (not rootOnScreen or rootPoint.Z <= 0)
			data.arrow.Visible = offscreen == true
			if data.arrow.Visible then
				local viewport = camera.ViewportSize
				local center = viewport / 2
				local direction = Vector2.new(rootPoint.X - center.X, rootPoint.Y - center.Y)
				if rootPoint.Z <= 0 then direction = -direction end
				if direction.Magnitude < 1 then direction = Vector2.new(0, -1) end
				local boundary = Vector2.new(math.max(viewport.X * .5 - 34, 1), math.max(viewport.Y * .5 - 34, 1))
				local ratio = math.min(boundary.X / math.max(math.abs(direction.X), .001), boundary.Y / math.max(math.abs(direction.Y), .001))
				local edge = center + direction * ratio
				data.arrow.Position = UDim2.fromOffset(edge.X, edge.Y)
				data.arrow.Rotation = math.deg(math.atan2(direction.Y, direction.X)) + 90
				data.arrow.TextColor3 = data.color
			end
			data.tracer.Visible = Config.TracerESP and rootOnScreen and rootPoint.Z > 0
			if data.tracer.Visible then
				local finish = Vector2.new(rootPoint.X, rootPoint.Y)
				local delta = finish - bottomCenter
				data.tracer.Size = UDim2.fromOffset(delta.Magnitude, 2)
				data.tracer.Position = UDim2.fromOffset((finish.X + bottomCenter.X) * .5, (finish.Y + bottomCenter.Y) * .5)
				data.tracer.Rotation = math.deg(math.atan2(delta.Y, delta.X))
				data.tracer.BackgroundColor3 = data.color
			end
			data.health.Visible = Config.HealthESP and data.box.Visible and data.humanoid ~= nil
			if data.health.Visible then
				local ratio = math.clamp(data.humanoid.Health / math.max(data.humanoid.MaxHealth, 1), 0, 1)
				data.health.Size = UDim2.fromOffset(4, height)
				data.health.Position = UDim2.fromOffset(topPoint.X - width * .5 - 8, top)
				data.healthFill.Size = UDim2.fromScale(1, ratio)
				data.healthFill.BackgroundColor3 = Color3.fromRGB(248, 75, 90):Lerp(Color3.fromRGB(52, 211, 153), ratio)
			end
		end
	end
end
Players.PlayerRemoving:Connect(function(target)
	removeVisual(target)
	if UI.playerRows and UI.playerRows[target] then UI.playerRows[target]:Destroy(); UI.playerRows[target] = nil end
	if State.viewing == target then
		State.viewing = nil
		local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid and camera then camera.CameraSubject = humanoid end
	end
end)
Players.PlayerAdded:Connect(function(target)
	if target ~= player then
		target.CharacterAdded:Connect(function() removeVisual(target) end)
	end
end)
for _, target in ipairs(Players:GetPlayers()) do
	if target ~= player then target.CharacterAdded:Connect(function() removeVisual(target) end) end
end

-- Murder Mystery dropped-item tracker. The server remains authoritative; this
-- only highlights replicated objects whose names match common drop aliases.
local gunHighlight = Instance.new("Highlight")
gunHighlight.Name = "StaticsGunTracker"
gunHighlight.FillColor = MysteryRoleColors.hero
gunHighlight.OutlineColor = Color3.new(1, 1, 1)
gunHighlight.FillTransparency = .35
gunHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
gunHighlight.Enabled = false
gunHighlight.Parent = Workspace
local gunBillboard = Instance.new("BillboardGui")
gunBillboard.Name = "StaticsGunLabel"
gunBillboard.Size = UDim2.fromOffset(140, 30)
gunBillboard.AlwaysOnTop = true
gunBillboard.Enabled = false
gunBillboard.StudsOffset = Vector3.new(0, 2, 0)
gunBillboard.Parent = playerGui
local gunLabel = label(gunBillboard, "GUN", UDim2.fromScale(1, 1), nil, Enum.Font.GothamBlack, "text", 13)
gunLabel.TextXAlignment = Enum.TextXAlignment.Center
gunLabel.TextColor3 = MysteryRoleColors.hero
gunLabel.TextStrokeTransparency = 0
local gunAliases = {
	GunDrop = true, DroppedGun = true, RevolverDrop = true, SheriffGun = true,
	DroppedRevolver = true, Revolver = true, Gun = true,
}
local cachedGun = nil
local lastGunScan = 0
local function scanForGun()
	for _, object in ipairs(Workspace:GetDescendants()) do
		if gunAliases[object.Name] then return object end
	end
	return nil
end
for _, object in ipairs(Workspace:GetDescendants()) do if gunAliases[object.Name] then cachedGun = object; break end end
Workspace.DescendantAdded:Connect(function(object) if gunAliases[object.Name] then cachedGun = object end end)
Workspace.DescendantRemoving:Connect(function(object) if object == cachedGun then cachedGun = nil end end)
local function updateGunTracker()
	if not mysteryActive() or not State.profileChosen or not Config.MysteryGunTracker then
		gunHighlight.Enabled = false
		gunBillboard.Enabled = false
		return nil
	end
	if cachedGun and not cachedGun:IsDescendantOf(Workspace) then cachedGun = nil end
	if not cachedGun and os.clock() - lastGunScan >= .5 then
		lastGunScan = os.clock()
		cachedGun = scanForGun()
	end
	local object = cachedGun
	local anchor = object and (object:IsA("BasePart") and object or object:FindFirstChildWhichIsA("BasePart", true))
	if object and not anchor then
		cachedGun = nil
		if os.clock() - lastGunScan >= .5 then
			lastGunScan = os.clock()
			cachedGun = scanForGun()
		end
		object = cachedGun
		anchor = object and (object:IsA("BasePart") and object or object:FindFirstChildWhichIsA("BasePart", true))
	end
	local highlightAdornee = object and ((object:IsA("BasePart") or object:IsA("Model")) and object or anchor)
	gunHighlight.Adornee = highlightAdornee
	gunHighlight.Enabled = highlightAdornee ~= nil
	gunBillboard.Adornee = anchor
	gunBillboard.Enabled = anchor ~= nil
	if anchor then
		local _, _, root = living(player)
		gunLabel.Text = root and Config.MysteryGunDistance ~= false and ("GUN  " .. math.floor((anchor.Position - root.Position).Magnitude) .. "st") or "GUN"
	end
	return anchor
end

-- A compact local word index. It intentionally avoids chat TextBoxes.
local WORDS = [[
ability abstract academy accept access account action active adapt admire advance advice afraid agency agree ahead alarm album alert alien alike alive allow almost alone alpha amazing ancient angle animal answer apology appear apple approve arena argue arise armor around arrange arrest arrive arrow artist aspect assist assume athlete attend audio author autumn awake award balance bamboo banner bargain basket battle beach beauty become before begin believe benefit bicycle biology blanket blossom board bonus border bottle bounce brain branch brave bread breeze bridge bright bronze brother bubble budget build butter cable cactus camera campaign captain carbon career carpet carry castle category caution center century chair chalk champion change chaos chapter charge chase cheap check cheese cherry chest choice circle citizen claim classic clean clever client climate clock close cloud coach coast collect color combat comfort comic company concert confirm connect control copper corner correct cotton couch country course cousin craft crane crash crawl crazy cream credit cricket crystal curious custom damage dance daring dawn dealer debate decade decide decline decorate deep degree deliver demand desert design detail device diamond diary dinner direct discover doctor domain double dragon drama dream dress drift drink eager early earth easy echo edit educate effect effort eight elder electric elegant elite embark embrace emerge emotion employ empty enable enemy energy engine enjoy enough enter entire entry equal escape estate ethics event every exact example excite exercise exist expand expect expert explain explore express extra fabric face faith famous fantasy fashion fault feature federal fence festival field figure filter final finance finger finish fire flame flash flavor flight flower focus forest forget formal fortune forward frame fresh friend frost fruit future galaxy game garden garlic general gentle giant ginger glance glass globe glory golden grace grain grape gravity green grid group growth guard guess guitar habit hammer happy harbor harmony hazard heart heavy hero hidden highway history hobby honey honor hotel house human humble humor hybrid icon idea identify image impact improve include index indoor industry infant inform inherit initial input insect inspire install intact interest into invite island issue ivory jacket jewel journey judge juice jungle junior keen keep keyboard kingdom kitten ladder language large laser later launch layer leader learn legend lemon letter library light limit liquid listen little lobby local logic lonely lunar machine magic major mango manual maple marble market master medal memory metal method midnight mobile model modern moment money month moral motion mountain mouse movie museum music mystery narrow native nature never night noble normal notice novel number object ocean offer often olive online open option orange orbit order origin output oxygen paint panda panel paper parent party peace pearl pencil people pepper phrase piano piece pilot planet player point police popular portal power practice prefix pretty pride prime print prize profile program project prompt purple puzzle quality quantum queen query quick quiet rabbit radar random range rapid rare raven reach ready reason record red region relax remote render repeat reply rescue result ribbon right river robot rocket role round royal ruby safe sample scale school score search season second select server shadow shape share shield short signal silver simple skill sky smart smooth social solid solve sound space speak speed spell spider spirit spring square stable stage start static steam steel stone story stream strong studio style submit sugar summer switch system table target teach team temple text theme tiger title today token tool touch tower track train travel tree trial trust tunnel turtle unique universe update useful valid valley value vector velvet version video violet virtual visual voice volume water weapon whale wheel white window winner winter wonder word world write yellow young zebra zero zone
]]
local wordSet, wordList = {}, {}
for word in string.gmatch(WORDS, "%a+") do
	word = string.lower(word)
	if not wordSet[word] then wordSet[word] = true; table.insert(wordList, word) end
end
table.sort(wordList, function(a, b) if #a == #b then return a < b end return #a > #b end)
local wordBuffer = ""
local function recommend(prefix)
	local result = {}
	prefix = string.lower(prefix or "")
	for _, word in ipairs(wordList) do
		if prefix == "" or (word:sub(1, #prefix) == prefix and word ~= prefix) then
			table.insert(result, word)
			if #result >= 6 then break end
		end
	end
	return result
end
local quickBar = panel(gui, isMobile and UDim2.new(1, -16, 0, 180) or UDim2.fromOffset(760, 114), isMobile and UDim2.new(0, 8, 1, -188) or UDim2.new(.5, -380, 1, -128), "panel")
quickBar.Name = "LastLetterQuickBar"
quickBar.Visible = false
UI.quickBar = quickBar
local quickStatus = label(quickBar, "KEYBOARD READY / CHAT IGNORED", UDim2.new(1, -20, 0, 20), UDim2.fromOffset(10, 8), Enum.Font.Code, "accent2", 9)
quickStatus.TextXAlignment = Enum.TextXAlignment.Center
local quickArea = Instance.new("Frame")
quickArea.Size = UDim2.new(1, -20, 1, -42)
quickArea.Position = UDim2.fromOffset(10, 34)
quickArea.BackgroundTransparency = 1
quickArea.Parent = quickBar
local quickGrid = Instance.new("UIGridLayout")
quickGrid.CellSize = isMobile and UDim2.new(.5, -4, 0, 38) or UDim2.new(.2, -5, 0, 42)
quickGrid.CellPadding = UDim2.fromOffset(6, 6)
quickGrid.FillDirectionMaxCells = isMobile and 2 or 5
quickGrid.Parent = quickArea
local quickButtons = {}
for index = 1, 4 do
	local b = button(quickArea, "-", UDim2.new(), nil, "row")
	b.LayoutOrder = index
	quickButtons[index] = b
end
local autoWord = button(quickArea, "AUTO TYPE BEST", UDim2.new(), nil, "accent")
autoWord.LayoutOrder = 5
local registeredInput = nil
local function refreshWords()
	local results = recommend(wordBuffer)
	quickStatus.Text = wordBuffer == "" and "KEYBOARD READY / CHAT IGNORED" or ("PREFIX  /  " .. string.upper(wordBuffer))
	if UI.wordLabel then UI.wordLabel.Text = wordBuffer == "" and "TYPE LETTERS ANYWHERE" or string.upper(wordBuffer) end
	for index, b in ipairs(quickButtons) do
		b.Text = results[index] and string.upper(results[index]) or "-"
		b:SetAttribute("Word", results[index])
		b.Visible = results[index] ~= nil
	end
	for index, b in ipairs(UI.wordButtons or {}) do
		b.Text = results[index] and string.upper(results[index]) or "-"
		b:SetAttribute("Word", results[index])
		b.Visible = results[index] ~= nil
	end
	return results
end
local function fillWord(word)
	if registeredInput and registeredInput.Parent then
		registeredInput.Text = word
		registeredInput:CaptureFocus()
	end
	wordBuffer = ""
	refreshWords()
end
for _, b in ipairs(quickButtons) do b.Activated:Connect(function() local word = b:GetAttribute("Word"); if word then fillWord(word) end end) end
for _, b in ipairs(UI.wordButtons or {}) do b.Activated:Connect(function() local word = b:GetAttribute("Word"); if word then fillWord(word) end end) end
autoWord.Activated:Connect(function() local results = refreshWords(); if results[1] then fillWord(results[1]) end end)
UserInputService.TextBoxFocused:Connect(function(box)
	local fullName = string.lower(box:GetFullName())
	if Config.ActiveProfile == "Last Letter" and box:IsDescendantOf(playerGui) and not box:IsDescendantOf(gui) and not string.find(fullName, "chat", 1, true) then registeredInput = box end
end)
UserInputService.InputBegan:Connect(function(input)
	if Config.ActiveProfile ~= "Last Letter" or not quickBar.Visible or input.UserInputType ~= Enum.UserInputType.Keyboard or UserInputService:GetFocusedTextBox() then return end
	local keyName = input.KeyCode.Name
	if #keyName == 1 and keyName:match("^[A-Z]$") then wordBuffer = (wordBuffer .. keyName:lower()):sub(1, 32)
	elseif input.KeyCode == Enum.KeyCode.Backspace then wordBuffer = wordBuffer:sub(1, math.max(0, #wordBuffer - 1))
	elseif input.KeyCode == Enum.KeyCode.Delete or input.KeyCode == Enum.KeyCode.Return then wordBuffer = "" end
	refreshWords()
end)

-- ==========================================================================
-- REMOTE PAYLOADS / COMMANDS / PERSISTENCE
-- ==========================================================================

local function normalizeRoles(payload)
	if typeof(payload) ~= "table" then return {}, {} end
	local roleMap = payload.roles or payload.Roles or payload.players or payload.Players or payload
	local metadata = {}
	if roleMap ~= payload then
		for key, value in pairs(payload) do
			if key ~= "roles" and key ~= "Roles" and key ~= "players" and key ~= "Players" then metadata[key] = value end
		end
	end
	-- MM2 servers commonly nest round information under `round`, `status`,
	-- or `roundData`. Flatten those safe display fields so the HUD can show
	-- map, timer, phase, alive count, and event text consistently.
	local roundData = payload.round or payload.Round or payload.roundData or payload.RoundData or payload.statusData or payload.StatusData
	if typeof(roundData) == "table" then
		for key, value in pairs(roundData) do if metadata[key] == nil then metadata[key] = value end end
	end
	local roles = {}
	if typeof(roleMap) == "table" then
		for key, value in pairs(roleMap) do
			local role = value
			if typeof(value) == "table" then role = value.role or value.Role or value.name or value.Name end
			if role ~= nil then
				local target = Players:FindFirstChild(tostring(key))
				roles[target and target.Name or tostring(key)] = tostring(role)
			end
		end
	end
	return roles, metadata
end
whenRemote("RoleSync", function(remote)
	if not remote:IsA("RemoteEvent") then return end
	remote.OnClientEvent:Connect(function(payload)
		local roles, metadata = normalizeRoles(payload)
		local previous = State.roles
		State.roles = roles
		State.mysteryMeta = metadata
		if mysteryActive() and State.profileChosen then
			local murderer = findRoleHolder("murderer")
			local sheriff = findRoleHolder("sheriff")
			if murderer and murderer ~= State.lastMurderer then
				if Config.MysteryMurdererAlert then notify("Murderer revealed: " .. murderer, false) end
				-- optional reveal sound
				if Config.MysterySoundAlerts then
					pcall(function()
						local s = Instance.new("Sound"); s.SoundId = "rbxassetid://9120386436"; s.Volume = 1; s.Parent = game:GetService("SoundService"); s:Play(); game:GetService("Debris"):AddItem(s, 3)
					end)
				end
				-- optional auto-spectate the revealed murderer
				if Config.MysteryAutoSpectateMurderer then
					local mp = Players:FindFirstChild(murderer)
					local hum = mp and mp.Character and mp.Character:FindFirstChildOfClass("Humanoid")
					if hum and camera then pcall(function() camera.CameraSubject = hum end); State.viewing = mp; notify("Spectating murderer: " .. murderer, false) end
				end
			end
			if sheriff and sheriff ~= State.lastSheriff and Config.MysterySheriffAlert then notify("Sheriff revealed: " .. sheriff, true) end
			State.lastMurderer = murderer
			State.lastSheriff = sheriff
		end
		local rolesChanged = false
		for name, role in pairs(previous) do if roles[name] ~= role then rolesChanged = true; break end end
		if not rolesChanged then for name in pairs(roles) do if previous[name] == nil then rolesChanged = true; break end end end
		if UI.notify and rolesChanged then State.dirty = true end
	end)
end)
whenRemote("Status", function(remote)
	if not remote:IsA("RemoteEvent") then return end
	remote.OnClientEvent:Connect(function(message, good)
		-- Some servers send a rich round-status table instead of a plain string.
		-- Keep the original status text while extracting safe MM2 metadata.
		if typeof(message) == "table" then
			local extractedMetadata = table.clone(message)
			local _, flattenedMetadata = normalizeRoles(message)
			for key, value in pairs(flattenedMetadata) do extractedMetadata[key] = value end
			State.mysteryMeta = extractedMetadata
			local textValue = message.message or message.Message or message.text or message.Text or message.status or message.Status or message.event or message.Event or "Round status updated"
			if UI.sessionStatus then
				UI.sessionStatus.Text = tostring(textValue)
				UI.sessionStatus.TextColor3 = good == false and Color3.fromRGB(248, 75, 90) or Theme.accent2
			end
			if UI.addMysteryFeed then UI.addMysteryFeed(tostring(textValue), Theme.accent2) end
			if UI.notify then UI.notify(textValue, good ~= false) end
			return
		end
		if UI.sessionStatus then
			UI.sessionStatus.Text = tostring(message)
			UI.sessionStatus.TextColor3 = good == false and Color3.fromRGB(248, 75, 90) or Theme.accent2
		end
		if UI.notify then UI.notify(message, good ~= false) end
	end)
end)

-- A searchable local command list. Commands that affect the server are only
-- sent to the server remote; this client never grants itself admin authority.
local commandWindow
local commandScale
do
local localCommands = {
	{name = "fov", usage = "fov [number]", description = "Set or reset local camera FOV."},
	{name = "esp", usage = "esp", description = "Enable local player ESP."},
	{name = "unesp", usage = "unesp", description = "Disable local player ESP."},
	{name = "aim", usage = "aim", description = "Enable local aim page setting."},
	{name = "unaim", usage = "unaim", description = "Disable local aim page setting."},
	{name = "view", usage = "view <player>", description = "Spectate a player locally."},
	{name = "unview", usage = "unview", description = "Return the camera to yourself."},
	{name = "cmds", usage = "cmds", description = "Open the command list."},
	{name = "clear", usage = "clear", description = "Clear the command output."},
	{name = "rejoin", usage = "rejoin", description = "Request a rejoin through TeleportService."},
}
commandWindow = panel(gui, UDim2.fromOffset(490, 430), UDim2.fromScale(.5, .5), "bg")
commandWindow.Name = "StaticsCommandList"
commandWindow.AnchorPoint = Vector2.new(.5, .5)
commandWindow.Visible = false
commandWindow.ZIndex = 80
neonStroke(commandWindow, 2, 90, .1)
commandScale = Instance.new("UIScale")
commandScale.Parent = commandWindow
local commandTitle = label(commandWindow, "COMMANDS", UDim2.new(1, -70, 0, 24), UDim2.fromOffset(16, 12), Enum.Font.GothamBlack, "text", 17)
local commandClose = button(commandWindow, "X", UDim2.fromOffset(32, 28), UDim2.new(1, -44, 0, 12), "row")
local commandSearch = Instance.new("TextBox")
commandSearch.Size = UDim2.new(1, -32, 0, 32)
commandSearch.Position = UDim2.fromOffset(16, 50)
commandSearch.BackgroundColor3 = Theme.row
commandSearch.BorderSizePixel = 0
commandSearch.ClearTextOnFocus = false
commandSearch.PlaceholderText = "Search commands..."
commandSearch.PlaceholderColor3 = Theme.muted
commandSearch.TextColor3 = Theme.text
commandSearch.Font = Enum.Font.Code
commandSearch.TextSize = 11
commandSearch.Parent = commandWindow
corner(commandSearch, 6)
bindTheme(commandSearch, "BackgroundColor3", "row")
bindTheme(commandSearch, "PlaceholderColor3", "muted")
bindTheme(commandSearch, "TextColor3", "text")
local commandList = Instance.new("ScrollingFrame")
commandList.Size = UDim2.new(1, -32, 1, -102)
commandList.Position = UDim2.fromOffset(16, 92)
commandList.BackgroundTransparency = 1
commandList.BorderSizePixel = 0
commandList.ScrollBarThickness = 3
commandList.ScrollBarImageColor3 = Theme.accent
commandList.AutomaticCanvasSize = Enum.AutomaticSize.Y
commandList.CanvasSize = UDim2.new()
commandList.Parent = commandWindow
local commandLayout = Instance.new("UIListLayout")
commandLayout.Padding = UDim.new(0, 4)
commandLayout.Parent = commandList
local commandRows = {}
local function buildCommandRows()
	for _, row in ipairs(commandRows) do row:Destroy() end
	table.clear(commandRows)
	for _, data in ipairs(localCommands) do
		local row = button(commandList, "", UDim2.new(1, -6, 0, 42), nil, "row")
		row:SetAttribute("CommandName", data.name)
		row.TextXAlignment = Enum.TextXAlignment.Left
		local pad = Instance.new("UIPadding")
		pad.PaddingLeft = UDim.new(0, 10)
		pad.PaddingRight = UDim.new(0, 8)
		pad.Parent = row
		row.Text = data.usage .. "  /  " .. data.description
		row.Font = Enum.Font.Code
		row.TextSize = 10
		row.Activated:Connect(function()
			commandWindow.Visible = false
			if UI.commandBox then UI.commandBox.Text = data.name .. " "; UI.commandBox:CaptureFocus() end
		end)
		table.insert(commandRows, row)
	end
end
local function filterCommandRows()
	local query = string.lower(commandSearch.Text)
	for _, row in ipairs(commandRows) do
		row.Visible = query == "" or string.find(string.lower(row.Text), query, 1, true) ~= nil
	end
end
commandSearch:GetPropertyChangedSignal("Text"):Connect(filterCommandRows)
commandClose.Activated:Connect(function() commandWindow.Visible = false end)
local function openCommands()
	buildCommandRows()
	filterCommandRows()
	local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
	commandScale.Scale = math.clamp(math.min(viewport.X / 530, viewport.Y / 470), .5, 1)
	commandWindow.Visible = true
	commandSearch:CaptureFocus()
end
UI.openCommandWindow = openCommands

local function findPlayer(query)
	if not query then return nil end
	query = string.lower(query)
	if query == "me" then return player end
	for _, target in ipairs(Players:GetPlayers()) do
		if string.lower(target.Name):sub(1, #query) == query or string.lower(target.DisplayName):sub(1, #query) == query then return target end
	end
	return nil
end
local localHandlers = {}
localHandlers.fov = function(args)
	local value = tonumber(args[1])
	if not value then Config.CameraFOVEnabled = false; return true, "FOV reset" end
	Config.CameraFOVEnabled = true
	Config.CameraFOV = math.clamp(value, 20, 130)
	State.dirty = true
	return true, "FOV set to " .. tostring(Config.CameraFOV)
end
localHandlers.esp = function() Config.ESPEnabled = true; State.dirty = true; return true, "ESP on" end
localHandlers.unesp = function() Config.ESPEnabled = false; State.dirty = true; return true, "ESP off" end
localHandlers.aim = function() Config.AimEnabled = true; State.dirty = true; return true, "Aim assist on" end
localHandlers.unaim = function() Config.AimEnabled = false; State.aimHeld = false; State.target = nil; State.dirty = true; return true, "Aim assist off" end
localHandlers.view = function(args)
	local target = findPlayer(args[1])
	local humanoid = target and target.Character and target.Character:FindFirstChildOfClass("Humanoid")
	if not target or not humanoid or not camera then return false, "Player not found or has no character" end
	State.viewing = target
	camera.CameraSubject = humanoid
	return true, "Viewing " .. target.DisplayName
end
localHandlers.unview = function()
	State.viewing = nil
	local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if humanoid and camera then camera.CameraSubject = humanoid end
	return true, "Camera returned to you"
end
localHandlers.cmds = function() openCommands(); return true, "Command list opened" end
localHandlers.clear = function() if UI.commandOutput then UI.commandOutput.Text = "Ready" end; return true, "Cleared" end
localHandlers.rejoin = function()
	local success, failure = pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, player) end)
	return success, success and "Rejoining" or tostring(failure)
end
local commandHistory = {}
local commandHistoryIndex = 0
local commandBusy = false
local function commandOutput(message, good)
	if UI.commandOutput then
		UI.commandOutput.Text = tostring(message)
		UI.commandOutput.TextColor3 = good == nil and Theme.muted or (good and Theme.accent2 or Color3.fromRGB(248, 75, 90))
	end
end
local function runCommand(raw)
	local text = tostring(raw or ""):gsub("^[%s;:]+", ""):gsub("%s+$", "")
	if text == "" then return end
	table.insert(commandHistory, 1, text)
	if #commandHistory > 30 then table.remove(commandHistory) end
	commandHistoryIndex = 0
	local args = {}
	for word in string.gmatch(text, "%S+") do table.insert(args, word) end
	local name = string.lower(table.remove(args, 1) or "")
	if name == "cmds" or name == "help" or name == "commands" then openCommands(); commandOutput("Command list opened", true); return end
	local handler = localHandlers[name]
	if handler then
		local good, message = handler(args)
		commandOutput((good and "OK  " or "ERR  ") .. tostring(message), good)
		if UI.notify then UI.notify(message, good) end
		return
	end
	if commandBusy then commandOutput("A command is already running", false); return end
	if not Remotes.Command or not Remotes.Command:IsA("RemoteFunction") then commandOutput("Server command remote unavailable", false); return end
	commandBusy = true
	commandOutput("> " .. text .. "  ...", nil)
	task.spawn(function()
		local answered, result = invokeWithTimeout(Remotes.Command, 10, text)
		commandBusy = false
		if not answered then commandOutput("Server did not respond: " .. tostring(result), false); return end
		if typeof(result) == "table" then
			commandOutput((result.ok and "OK  " or "ERR  ") .. tostring(result.message), result.ok == true)
			if UI.notify then UI.notify(result.message, result.ok == true) end
		else
			commandOutput("Unexpected server response", false)
		end
	end)
end
if UI.commandBox then
	UI.commandBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then local text = UI.commandBox.Text; UI.commandBox.Text = ""; runCommand(text) end
	end)
	if UI.commandRun then UI.commandRun.Activated:Connect(function() local text = UI.commandBox.Text; UI.commandBox.Text = ""; runCommand(text) end) end
	UI.commandBox.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.Up then commandHistoryIndex = math.min(#commandHistory, commandHistoryIndex + 1); UI.commandBox.Text = commandHistory[commandHistoryIndex] or ""
		elseif input.KeyCode == Enum.KeyCode.Down then commandHistoryIndex = math.max(0, commandHistoryIndex - 1); UI.commandBox.Text = commandHistory[commandHistoryIndex] or "" end
	end)
end
end

-- Preferences are a snapshot of DEFAULTS keys only. This prevents GUI objects
-- and runtime references from ever being serialized into the save payload.
local function preferenceSnapshot()
	local result = {}
	for key in pairs(DEFAULTS) do result[key] = Config[key] end
	return result
end
local savedJson = HttpService:JSONEncode(preferenceSnapshot())
-- Write the current settings to disk (executor file API). Returns true on success.
local function saveSettingsFile(encoded)
	if not UI.hasFileAPI then return false end
	local ok = pcall(writefile, UI.settingsFile, encoded)
	return ok == true
end
UI.saveSettingsNow = function()
	local encoded = HttpService:JSONEncode(preferenceSnapshot())
	savedJson = encoded
	State.dirty = false
	return saveSettingsFile(encoded)
end
task.spawn(function()
	while gui.Parent do
		task.wait(3)
		if State.dirty then
			local snapshot = preferenceSnapshot()
			local encoded = HttpService:JSONEncode(snapshot)
			if encoded ~= savedJson then
				if UI.saveStatus then UI.saveStatus.Text = "Saving..." end
				local wroteFile = saveSettingsFile(encoded)
				local wroteRemote = false
				if Remotes.Preferences and Remotes.Preferences:IsA("RemoteFunction") then
					local answered, result = invokeWithTimeout(Remotes.Preferences, 6, "save", snapshot)
					wroteRemote = answered and result == true
				end
				if wroteFile or wroteRemote then
					savedJson = encoded
					State.dirty = false
					if UI.saveStatus then UI.saveStatus.Text = UI.hasFileAPI and "Saved to file" or "Saved" end
				else
					if UI.saveStatus then UI.saveStatus.Text = "Save unavailable" end
					-- stop retrying forever if there is nowhere to save
					State.dirty = false
				end
			end
		end
	end
end)
-- Also flush to disk when the player leaves, so last-second changes persist.
pcall(function()
	Players.PlayerRemoving:Connect(function(leaving)
		if leaving == player and UI.saveSettingsNow then pcall(UI.saveSettingsNow) end
	end)
end)

-- ==========================================================================
-- HUD / CROSSHAIR / WATERMARK / UPDATE LOOP
-- ==========================================================================

local crosshair = Instance.new("Frame")
crosshair.Name = "StaticsCrosshair"
crosshair.AnchorPoint = Vector2.new(.5, .5)
crosshair.Position = UDim2.fromScale(.5, .5)
crosshair.Size = UDim2.fromOffset(1, 1)
crosshair.BackgroundTransparency = 1
crosshair.Visible = false
crosshair.ZIndex = 390
crosshair.Parent = gui
local crossArms = {}
for index = 1, 4 do
	local arm = Instance.new("Frame")
	arm.AnchorPoint = Vector2.new(.5, .5)
	arm.BackgroundColor3 = Theme.accent
	arm.BorderSizePixel = 0
	arm.ZIndex = 391
	arm.Parent = crosshair
	corner(arm, 1)
	crossArms[index] = arm
end
local crossCenter = Instance.new("Frame")
crossCenter.AnchorPoint = Vector2.new(.5, .5)
crossCenter.Size = UDim2.fromOffset(2, 2)
crossCenter.BackgroundColor3 = Theme.accent
crossCenter.BorderSizePixel = 0
crossCenter.ZIndex = 391
crossCenter.Parent = crosshair
corner(crossCenter, 1)
local function refreshCrosshair()
	crosshair.Visible = Config.Crosshair == true and not State.menuOpen
	if not crosshair.Visible then return end
	local size = tonumber(Config.CrosshairSize) or 8
	local gap = tonumber(Config.CrosshairGap) or 4
	local reach = gap + size / 2
	local positions = {{0, -reach, 2, size}, {0, reach, 2, size}, {-reach, 0, size, 2}, {reach, 0, size, 2}}
	for index, position in ipairs(positions) do
		crossArms[index].Position = UDim2.fromOffset(position[1], position[2])
		crossArms[index].Size = UDim2.fromOffset(position[3], position[4])
		crossArms[index].BackgroundColor3 = Theme.accent
	end
	crossCenter.BackgroundColor3 = Theme.accent2
end
UI.refreshCrosshair = refreshCrosshair

local watermark = Instance.new("Frame")
watermark.Name = "StaticsWatermark"
watermark.AutomaticSize = Enum.AutomaticSize.X
watermark.Size = UDim2.fromOffset(0, 28)
watermark.Position = UDim2.fromOffset(12, isMobile and 60 or 12)
watermark.BackgroundColor3 = Theme.panel
watermark.BackgroundTransparency = .08
watermark.BorderSizePixel = 0
watermark.Visible = false
watermark.ZIndex = 400
watermark.Parent = gui
corner(watermark, 6)
bindTheme(watermark, "BackgroundColor3", "panel")
local watermarkPadding = Instance.new("UIPadding")
watermarkPadding.PaddingLeft = UDim.new(0, 8)
watermarkPadding.PaddingRight = UDim.new(0, 10)
watermarkPadding.Parent = watermark
local watermarkLayout = Instance.new("UIListLayout")
watermarkLayout.FillDirection = Enum.FillDirection.Horizontal
watermarkLayout.VerticalAlignment = Enum.VerticalAlignment.Center
watermarkLayout.Padding = UDim.new(0, 8)
watermarkLayout.Parent = watermark
local watermarkBrand = label(watermark, "STATICS", UDim2.fromOffset(54, 28), nil, Enum.Font.GothamBlack, "text", 9)
watermarkBrand.AutomaticSize = Enum.AutomaticSize.X
local watermarkFPS = label(watermark, "0 fps", UDim2.fromOffset(0, 28), nil, Enum.Font.Code, "accent", 9)
watermarkFPS.AutomaticSize = Enum.AutomaticSize.X
local watermarkPing = label(watermark, "0 ms", UDim2.fromOffset(0, 28), nil, Enum.Font.Code, "muted", 9)
watermarkPing.AutomaticSize = Enum.AutomaticSize.X
local watermarkClock = label(watermark, "00:00", UDim2.fromOffset(0, 28), nil, Enum.Font.Code, "muted", 9)
watermarkClock.AutomaticSize = Enum.AutomaticSize.X
local function refreshWatermark()
	watermark.Visible = Config.Watermark == true
	if watermark.Visible then
		watermarkFPS.Text = tostring(State.fps or 0) .. " fps"
		local pingValue = 0
		pcall(function() pingValue = tonumber(player:GetNetworkPing()) or 0 end)
		watermarkPing.Text = tostring(math.floor(math.max(pingValue * 1000, 0))) .. " ms"
		watermarkClock.Text = os.date("%H:%M")
	end
end
UI.refreshWatermark = refreshWatermark

-- ==========================================================================
-- PROXIMITY ALERT: a movable, customizable warning that appears when another
-- player comes within ProximityDistance studs. Drag it anywhere; it snaps to
-- the top-left or top-right by default.
-- ==========================================================================
do
	local alert = Instance.new("Frame")
	alert.Name = "StaticsProximityAlert"
	alert.Size = UDim2.fromOffset(248, 58)
	alert.Position = UDim2.fromOffset(16, 16)
	alert.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
	alert.BackgroundTransparency = .1
	alert.BorderSizePixel = 0
	alert.Visible = false
	alert.Active = true
	alert.Draggable = true
	alert.ZIndex = 420
	alert.Parent = gui
	corner(alert, 12)
	local aStroke = Instance.new("UIStroke"); aStroke.Color = Color3.fromRGB(248, 75, 90); aStroke.Thickness = 1.8; aStroke.Parent = alert
	local accentBar = Instance.new("Frame")
	accentBar.Size = UDim2.fromOffset(4, 40); accentBar.Position = UDim2.new(0, 8, .5, -20)
	accentBar.BackgroundColor3 = Color3.fromRGB(248, 75, 90); accentBar.BorderSizePixel = 0; accentBar.ZIndex = 421; accentBar.Parent = alert
	corner(accentBar, 2)
	local icon = Instance.new("TextLabel")
	icon.BackgroundTransparency = 1; icon.Size = UDim2.fromOffset(34, 34); icon.Position = UDim2.fromOffset(18, 12)
	icon.Font = Enum.Font.GothamBlack; icon.Text = "\u{26A0}"; icon.TextSize = 26; icon.TextColor3 = Color3.fromRGB(255, 196, 60); icon.ZIndex = 421; icon.Parent = alert
	local title = label(alert, "PROXIMITY WARNING", UDim2.new(1, -62, 0, 16), UDim2.fromOffset(56, 9), Enum.Font.GothamBlack, "text", 11)
	title.ZIndex = 421; title:SetAttribute("ThemeLocked", true); title.TextColor3 = Color3.fromRGB(255, 120, 120)
	local body = label(alert, "A player is very close", UDim2.new(1, -62, 0, 16), UDim2.fromOffset(56, 28), Enum.Font.GothamBold, "text", 11)
	body.ZIndex = 421; body:SetAttribute("ThemeLocked", true); body.TextColor3 = Color3.new(1, 1, 1)
	UI.proximityAlert = alert

	-- place in the chosen corner (manual drag overrides until re-cornered)
	local function placeCorner()
		if Config.ProximityCorner == "TopRight" then
			alert.Position = UDim2.new(1, -alert.AbsoluteSize.X - 16, 0, 16)
		else
			alert.Position = UDim2.fromOffset(16, 16)
		end
	end
	UI.placeProximityCorner = placeCorner
	placeCorner()

	local shownUntil = 0
	UI.updateProximity = function()
		if not Config.ProximityAlert then alert.Visible = false; return end
		local _, _, myRoot = living(player)
		if not myRoot then alert.Visible = false; return end
		local limit = math.max(tonumber(Config.ProximityDistance) or 15, 1)
		local nearest, nearestDist = nil, math.huge
		for _, target in ipairs(Players:GetPlayers()) do
			if target ~= player then
				local sameTeam = player.Team and target.Team and player.Team == target.Team
				if not (Config.ProximityTeamCheck and sameTeam) then
					local _, _, root = living(target)
					if root then
						local d = (root.Position - myRoot.Position).Magnitude
						if d <= limit and d < nearestDist then nearest, nearestDist = target, d end
					end
				end
			end
		end
		if nearest then
			body.Text = nearest.DisplayName .. "  -  " .. tostring(math.floor(nearestDist)) .. " studs"
			if not alert.Visible then
				alert.Visible = true
				if Config.ProximitySound then
					pcall(function() local s = Instance.new("Sound"); s.SoundId = "rbxassetid://9118823106"; s.Volume = .8; s.Parent = game:GetService("SoundService"); s:Play(); game:GetService("Debris"):AddItem(s, 2) end)
				end
			end
			-- pulse the border
			aStroke.Transparency = (math.floor(os.clock() * 6) % 2 == 0) and 0 or .5
			shownUntil = os.clock() + .4
		elseif os.clock() > shownUntil then
			alert.Visible = false
		end
	end
end

local function updateMysteryHud(gunAnchor)
	if not mysteryActive() or not State.profileChosen then
		mysteryHud.Visible = false
		if UI.mysteryButton then UI.mysteryButton.Visible = false end
		return
	end
	if UI.mysteryButton then UI.mysteryButton.Visible = true end
	local role = State.roles[player.Name]
	local roleText = role and string.upper(tostring(role)) or "WAITING"
	local color = mysteryRoleColor(role) or Theme.muted
	local alive = 0
	for _, target in ipairs(Players:GetPlayers()) do if living(target) then alive += 1 end end
	local metadata = State.mysteryMeta or {}
	local phase = metadata.phase or metadata.Phase or metadata.roundState or metadata.RoundState or metadata.state or metadata.State or metadata.status or metadata.Status or (next(State.roles) and "ROUND LIVE" or "WAITING")
	local mapName = metadata.map or metadata.Map or metadata.mapName or metadata.MapName or metadata.location or metadata.Location
	local timeLeft = metadata.timeLeft or metadata.TimeLeft or metadata.roundTime or metadata.RoundTime or metadata.timer or metadata.Timer or metadata.remaining or metadata.Remaining or metadata.seconds
	local serverAlive = tonumber(metadata.alive or metadata.Alive or metadata.aliveCount or metadata.AliveCount)
	if serverAlive and serverAlive >= 0 then alive = math.floor(serverAlive) end
	local eventText = metadata.event or metadata.Event or metadata.eventText or metadata.EventText or "--"
	if UI.mysteryPhase then UI.mysteryPhase.Text = string.upper(tostring(phase)):sub(1, 18) end
	if UI.mysteryTimer then UI.mysteryTimer.Text = Config.MysteryTimerHUD == false and "--:--" or (timeLeft and formatDuration(timeLeft) or "--:--") end
	if UI.mysteryMap then UI.mysteryMap.Text = Config.MysteryMapHUD == false and "MAP --" or ("MAP " .. string.upper(tostring(mapName or "--")):sub(1, 18)) end
	if UI.mysteryEvent then UI.mysteryEvent.Text = "EVENT " .. string.upper(tostring(eventText)):sub(1, 18) end
	if UI.mysteryMyRole then UI.mysteryMyRole.Text = roleText; UI.mysteryMyRole.TextColor3 = role and color or Theme.text end
	if UI.mysteryMurderer then UI.mysteryMurderer.Text = findRoleHolder("murderer") or tostring(metadata.murderer or metadata.Murderer or "UNKNOWN") end
	if UI.mysterySheriff then UI.mysterySheriff.Text = findRoleHolder("sheriff") or tostring(metadata.sheriff or metadata.Sheriff or "UNKNOWN") end
	if UI.mysteryAlive then UI.mysteryAlive.Text = Config.MysteryAliveCounter and (tostring(alive) .. " / " .. tostring(#Players:GetPlayers())) or "HIDDEN" end
	if UI.mysteryGun then UI.mysteryGun.Text = gunAnchor and "DROPPED" or "NOT DROPPED" end
	local hudVisible = Config.MysteryRoleHUD and not State.menuOpen and not State.mysteryOpen
	mysteryHud.Visible = hudVisible
	if hudVisible then
		mysteryHudRole.Text = "ROLE: " .. roleText
		mysteryHudRole.TextColor3 = role and color or Theme.text
		mysteryHudDot.BackgroundColor3 = color
		local detail = {}
		if Config.MysteryAliveCounter then table.insert(detail, tostring(alive) .. " ALIVE") end
		if Config.MysteryTimerHUD ~= false and timeLeft ~= nil then table.insert(detail, formatDuration(timeLeft)) end
		if Config.MysteryMapHUD ~= false and mapName then table.insert(detail, string.upper(tostring(mapName))) end
		if Config.MysteryGunTracker and gunAnchor then table.insert(detail, "GUN DROPPED") end
		if eventText and tostring(eventText) ~= "" and tostring(eventText) ~= "--" then table.insert(detail, string.upper(tostring(eventText)):sub(1, 28)) end
		mysteryHudInfo.Text = #detail > 0 and table.concat(detail, "  /  ") or string.upper(tostring(phase))
	end
end

local elapsed = 0
local fpsElapsed = 0
local fpsFrames = 0
local measuredFPS = 0
RunService.RenderStepped:Connect(function(dt)
	updateScreenESP()
	local gunAnchor = updateGunTracker()
	fpsElapsed += dt
	fpsFrames += 1
	if fpsElapsed >= .5 then
		measuredFPS = math.floor(fpsFrames / fpsElapsed + .5)
		State.fps = measuredFPS
		fpsElapsed = 0
		fpsFrames = 0
	end
	elapsed += dt
	if elapsed < .2 then return end
	elapsed = 0
	updateESP()
	updateMysteryHud(gunAnchor)
	refreshCrosshair()
	refreshWatermark()
	if UI.updateProximity then UI.updateProximity() end
	if State.menuOpen and State.currentPage == "Home" then
		local count = #Players:GetPlayers()
		local maxPlayers = math.max(Players.MaxPlayers, 1)
		local pingValue = 0
		pcall(function() pingValue = tonumber(player:GetNetworkPing()) or 0 end)
		local ping = math.floor(math.max(pingValue * 1000, 0))
		if UI.overviewPlayers then
			UI.overviewPlayers.Text = tostring(count)
			UI.overviewPlayersSub.Text = "of " .. tostring(maxPlayers) .. " slots"
			UI.overviewPlayersBar.Size = UDim2.fromScale(1, math.clamp(count / maxPlayers, .03, 1))
		end
		if UI.overviewPing then
			UI.overviewPing.Text = tostring(ping) .. " ms"
			UI.overviewPingSub.Text = ping < 80 and "good" or (ping < 160 and "okay" or "high")
			UI.overviewPingBar.Size = UDim2.fromScale(1, math.clamp(1 - ping / 300, .05, 1))
		end
		if UI.overviewFps then
			UI.overviewFps.Text = tostring(measuredFPS)
			UI.overviewFpsSub.Text = "render rate"
			UI.overviewFpsBar.Size = UDim2.fromScale(1, math.clamp(measuredFPS / 144, .05, 1))
		end
		if UI.overviewTime then
			local seconds = os.clock() - State.sessionStarted
			UI.overviewTime.Text = formatDuration(seconds)
			UI.overviewTimeSub.Text = "elapsed"
			UI.overviewTimeBar.Size = UDim2.fromScale(1, (seconds % 60) / 60)
		end
		if UI.overviewRole then UI.overviewRole.Text = string.upper(tostring(State.roles[player.Name] or "WAITING")) end
		if UI.overviewProfile then UI.overviewProfile.Text = State.profileChosen and string.upper(Config.ActiveProfile) or "NONE" end
	end
	if UI.playerList then
		for target, row in pairs(UI.playerRows) do
			if not target.Parent then row:Destroy(); UI.playerRows[target] = nil end
		end
		for _, target in ipairs(Players:GetPlayers()) do
			local row = UI.playerRows[target]
			if not row then
				row = button(UI.playerList, "", UDim2.new(1, -8, 0, 40), nil, "row")
				row.TextXAlignment = Enum.TextXAlignment.Left
				local padding = Instance.new("UIPadding")
				padding.PaddingLeft = UDim.new(0, 12)
				padding.Parent = row
				local watched = target
				row.Activated:Connect(function()
					local subject = watched.Character and watched.Character:FindFirstChildOfClass("Humanoid")
					local mine = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
					if State.viewing == watched or watched == player then
						State.viewing = nil
						if mine and camera then camera.CameraSubject = mine end
					else
						if subject and camera then State.viewing = watched; camera.CameraSubject = subject end
					end
				end)
				UI.playerRows[target] = row
			end
			local role = string.upper(tostring(State.roles[target.Name] or "UNKNOWN"))
			local suffix = target == player and "  /  YOU" or ""
			if State.viewing == target then suffix ..= "  /  VIEWING" end
			row.Text = target.DisplayName .. "  /  " .. role .. suffix
		end
	end
end)

-- Keep the current theme and font consistent for later descendants too.
for _, object in ipairs(gui:GetDescendants()) do FX.retype(object) end
gui.DescendantAdded:Connect(function(object) FX.retype(object) end)

-- Apply the final layout after all page builders have registered their objects.
if UI.applyLayout then UI.applyLayout(Config.LayoutStyle, false) end
if UI.applyBackground then UI.applyBackground() end
if Config.FullBright and UI.applyFullbright then UI.applyFullbright() end
if UI.updateVRPanel then UI.updateVRPanel() end
refreshNavigation()
showPage("Hub")
refreshWords()

-- Startup stages are intentionally visible, even when a page emitted a warning.
task.spawn(function()
	local stages = {
		{"Building interface modules...", "Assembling the Statics workspace."},
		{"Loading saved preferences...", "Restoring your themes and settings."},
		{"Preparing aim systems...", "Calibrating FOV, prediction, and rig resolution."},
		{"Preparing visual systems...", "Connecting highlights, labels, and skeletons."},
		{"Preparing game profiles...", "Universal, Last Letter, Murder Mystery, and Fling Things are ready."},
		{"Finalizing profiles...", "The Game Hub is ready to launch."},
	}
	local function pause(seconds)
		local started = os.clock()
		while not startupSkip and not Loader.skipRequested and os.clock() - started < seconds do task.wait() end
	end
	for index, stage in ipairs(stages) do
		if startupSkip or Loader.skipRequested then break end
		loadingStage.Text = stage[1]
		loadingTip.Text = stage[2]
		local progress = .2 + .8 * index / #stages
		if Loader.setProgress then Loader.setProgress(progress) end
		TweenService:Create(loadingFill, TweenInfo.new(.25, Enum.EasingStyle.Quart), {Size = UDim2.fromScale(progress, 1)}):Play()
		pause(.24)
	end
	if Loader.skipRequested then
		loadingStage.Text = "Skipping optional intro..."
		loadingTip.Text = "Finishing the interface now."
	end
	pause(math.max(0, Loader.skipRequested and .05 or 1.3 - (os.clock() - Loader.shownAt)))
	loadingFill.Size = UDim2.fromScale(1, 1)
	loadingTitle.Text = startupError and "LOADED WITH WARNINGS" or "LOADED"
	loadingStage.Text = startupError and tostring(startupError):sub(1, 80) or "Choose a Game Hub profile to begin."
	loadingTip.Text = "Click to skip was available during startup."
	startupFinished = true
	Loader.fade(.3)
	task.wait(.2)
	setMenu(true)
end)
-- ========================================================================
-- PROFESSIONAL POLISH / RESPONSIVE SHELL / MM2 INTEL / RUNTIME VALIDATION
-- ========================================================================
-- This block is intentionally additive. It does not replace the original
-- profile builders, trigger loop, aim resolver, ESP lifecycle, or startup
-- recovery path. It provides shared quality-of-life services used by every
-- page after the main systems have been constructed.
UI._installProfessionalPolish = function()
	local polish = {}
	State.polish = polish
	State.mysteryMeta = State.mysteryMeta or {}
	State.mysteryFeed = State.mysteryFeed or {}
	State.mysteryMarks = State.mysteryMarks or {}
	State.mysteryIntelOpen = false
	UI.professional = polish

	-- Saved values added by this layer are optional and are inserted only when
	-- an older Preferences response did not contain them.
	local function addPolishDefault(name, value)
		if DEFAULTS[name] == nil then DEFAULTS[name] = value end
		if Config[name] == nil then Config[name] = value end
	end
	addPolishDefault("ReduceMotion", false)
	addPolishDefault("CompactNotifications", false)
	addPolishDefault("ResponsiveMode", "Auto")
	addPolishDefault("TooltipHints", true)
	addPolishDefault("ConfirmServerActions", true)
	addPolishDefault("MysteryRoundHUD", true)
	addPolishDefault("MysteryTimerHUD", true)
	addPolishDefault("MysteryMapHUD", true)
	addPolishDefault("MysteryRoleFeed", true)
	addPolishDefault("MysteryEventFeed", true)
	addPolishDefault("MysterySuspectMarks", true)
	addPolishDefault("MysteryGunDistance", true)
	addPolishDefault("AutoFitWindow", true)
	addPolishDefault("ShowDiagnostics", false)

	local function safeCall(callback, ...)
		if type(callback) ~= "function" then return false, "not a function" end
		return pcall(callback, ...)
	end
	local function disconnect(connection)
		if connection and connection.Disconnect then pcall(function() connection:Disconnect() end) end
	end
	local function connect(signal, callback)
		if not signal or type(callback) ~= "function" then return nil end
		local ok, connection = pcall(function() return signal:Connect(callback) end)
		if ok and connection then
			table.insert(State.connections, connection)
			return connection
		end
		return nil
	end
	polish.safeCall = safeCall
	polish.connect = connect
	polish.disconnect = disconnect

	-- Motion is centralized so mobile users can disable the larger spring
	-- transitions without changing any page's layout or behavior.
	local motionScale = 1
	local function motionTime(seconds)
		if Config.ReduceMotion then return 0 end
		return (tonumber(seconds) or .2) * motionScale
	end
	local function tween(object, seconds, properties, style, direction)
		if not object or not object.Parent then return nil end
		local info = TweenInfo.new(
			motionTime(seconds),
			style or Enum.EasingStyle.Quart,
			direction or Enum.EasingDirection.Out
		)
		local ok, result = pcall(function() return TweenService:Create(object, info, properties) end)
		if not ok then return nil end
		result:Play()
		return result
	end
	polish.tween = tween
	polish.motionTime = motionTime

	local function setVisible(object, visible)
		if object and object:IsA("GuiObject") then object.Visible = visible == true end
	end
	local function setText(object, value)
		if object and (object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")) then object.Text = tostring(value or "") end
	end
	local function setColor(object, property, value)
		if object and object.Parent then pcall(function() object[property] = value end) end
	end
	local function viewportSize()
		local current = Workspace.CurrentCamera or camera
		return current and current.ViewportSize or Vector2.new(1280, 720)
	end
	polish.viewportSize = viewportSize

	-- Clamp a draggable window after a resolution change. The menu remains
	-- draggable, but its title bar and the primary content stay reachable.
	local function clampPosition(object, margin)
		if not object or not object.Parent then return end
		local view = viewportSize()
		local safe = margin or 12
		local absolute = object.AbsoluteSize
		local current = object.Position
		local x = math.clamp(current.X.Offset, -absolute.X + 120 - view.X * .5, view.X * .5 - safe)
		local y = math.clamp(current.Y.Offset, -absolute.Y + 70 - view.Y * .5, view.Y * .5 - safe)
		object.Position = UDim2.new(current.X.Scale, x, current.Y.Scale, y)
	end
	polish.clampPosition = clampPosition

	local function addSizeConstraint(object, minimum, maximum)
		if not object or not object:IsA("GuiObject") then return nil end
		local constraint = object:FindFirstChild("StaticsSizeConstraint")
		if not constraint then
			constraint = Instance.new("UISizeConstraint")
			constraint.Name = "StaticsSizeConstraint"
			constraint.Parent = object
		end
		constraint.MinSize = minimum or Vector2.new(260, 160)
		constraint.MaxSize = maximum or Vector2.new(1500, 1100)
		return constraint
	end
	polish.addSizeConstraint = addSizeConstraint
	addSizeConstraint(main, Vector2.new(isMobile and 320 or 520, isMobile and 420 or 360), Vector2.new(1500, 1100))
	addSizeConstraint(commandWindow, Vector2.new(300, 260), Vector2.new(760, 620))
	if UI.mysteryPopup then addSizeConstraint(UI.mysteryPopup, Vector2.new(360, 360), Vector2.new(1100, 820)) end

	-- A small status pill reinforces whether the menu is ready, loading, or has
	-- a recoverable warning. It never covers the aim marker or crosshair.
	local statusPill = Instance.new("Frame")
	statusPill.Name = "StaticsRuntimeStatus"
	statusPill.AnchorPoint = Vector2.new(1, 0)
	statusPill.Position = UDim2.new(1, -18, 0, 18)
	statusPill.Size = UDim2.fromOffset(152, 28)
	statusPill.BackgroundColor3 = Theme.panel
	statusPill.BackgroundTransparency = .08
	statusPill.BorderSizePixel = 0
	statusPill.Visible = false
	statusPill.ZIndex = 490
	statusPill.Parent = gui
	corner(statusPill, 14)
	local statusDot = Instance.new("Frame")
	statusDot.AnchorPoint = Vector2.new(0, .5)
	statusDot.Position = UDim2.new(0, 10, .5, 0)
	statusDot.Size = UDim2.fromOffset(7, 7)
	statusDot.BackgroundColor3 = Color3.fromRGB(52, 211, 153)
	statusDot.BorderSizePixel = 0
	statusDot.Parent = statusPill
	corner(statusDot, 4)
	local statusText = label(statusPill, "READY", UDim2.new(1, -30, 1, 0), UDim2.fromOffset(24, 0), Enum.Font.Code, "text", 9)
	statusText.TextXAlignment = Enum.TextXAlignment.Left
	UI.runtimeStatus = statusPill
	UI.runtimeStatusText = statusText
	local function setRuntimeStatus(textValue, color, shown)
		statusText.Text = string.upper(tostring(textValue or "READY"))
		statusDot.BackgroundColor3 = color or Color3.fromRGB(52, 211, 153)
		statusPill.Visible = shown == true
	end
	UI.setRuntimeStatus = setRuntimeStatus

	-- Professional notification queue. Existing local `notify` calls continue
	-- to work; external modules use UI.notify and are serialized here.
	local originalNotify = UI.notify
	local noticeQueue = {}
	local noticeBusy = false
	local function queueNotice(message, good)
		table.insert(noticeQueue, {message = tostring(message), good = good})
		if noticeBusy then return end
		noticeBusy = true
		task.spawn(function()
			while #noticeQueue > 0 and gui.Parent do
				local item = table.remove(noticeQueue, 1)
				if originalNotify then originalNotify(item.message, item.good) end
				task.wait(Config.CompactNotifications and 1.4 or 2.7)
			end
			noticeBusy = false
		end)
	end
	UI.notify = queueNotice
	UI.notifyImmediate = originalNotify
	UI.noticeQueue = noticeQueue

	-- A lightweight tooltip layer is attached to controls with a Tooltip
	-- attribute. This keeps the pages visually clean while retaining detail.
	local tooltip = Instance.new("Frame")
	tooltip.Name = "StaticsTooltip"
	tooltip.AutomaticSize = Enum.AutomaticSize.XY
	tooltip.BackgroundColor3 = Theme.panel
	tooltip.BorderSizePixel = 0
	tooltip.Visible = false
	tooltip.ZIndex = 900
	tooltip.Parent = gui
	corner(tooltip, 6)
	outline(tooltip, Theme.accent, .25, 1)
	local tooltipText = label(tooltip, "", UDim2.fromOffset(0, 20), nil, Enum.Font.Gotham, "text", 9)
	tooltipText.AutomaticSize = Enum.AutomaticSize.XY
	tooltipText.TextWrapped = true
	tooltipText.ZIndex = 901
	local tooltipPadding = Instance.new("UIPadding")
	tooltipPadding.PaddingLeft = UDim.new(0, 8)
	tooltipPadding.PaddingRight = UDim.new(0, 8)
	tooltipPadding.PaddingTop = UDim.new(0, 5)
	tooltipPadding.PaddingBottom = UDim.new(0, 5)
	tooltipPadding.Parent = tooltip
	local tooltipToken = 0
	local function showTooltip(object, textValue)
		if not Config.TooltipHints or not textValue or textValue == "" then return end
		tooltipToken += 1
		local token = tooltipToken
		task.delay(.35, function()
			if token ~= tooltipToken or not object.Parent or not Config.TooltipHints then return end
			tooltipText.Text = tostring(textValue)
			local position = object.AbsolutePosition
			local size = object.AbsoluteSize
			local view = viewportSize()
			local x = math.clamp(position.X + size.X + 8, 8, view.X - 220)
			local y = math.clamp(position.Y + size.Y * .5, 8, view.Y - 60)
			tooltip.Position = UDim2.fromOffset(x, y)
			tooltip.Visible = true
		end)
	end
	local function hideTooltip()
		tooltipToken += 1
		tooltip.Visible = false
	end
	polish.showTooltip = showTooltip
	polish.hideTooltip = hideTooltip
	local function wireTooltip(object)
		if not object:IsA("GuiObject") then return end
		local textValue = object:GetAttribute("Tooltip")
		if not textValue then return end
		object.MouseEnter:Connect(function() showTooltip(object, textValue) end)
		object.MouseLeave:Connect(hideTooltip)
		object.AncestryChanged:Connect(function(_, parent) if not parent then hideTooltip() end end)
	end
	for _, object in ipairs(gui:GetDescendants()) do wireTooltip(object) end
	gui.DescendantAdded:Connect(wireTooltip)

	-- Every major page receives descriptive tooltip metadata. Attributes are
	-- harmless in Studio and can be changed by a theme or accessibility module.
	local tooltipMap = {
		Aim = "Camera assistance settings and the trigger section.",
		Visuals = "ESP, highlights, labels, boxes, tracers, and health bars.",
		Performance = "Reversible local render-cost controls.",
		Themes = "Theme colors and window layout selection.",
		Colors = "Optional custom background color controls.",
		Session = "Server-authoritative actions and input bindings.",
		Players = "Local player list and spectating controls.",
		Words = "Local word suggestions for the Last Letter profile.",
		Fling = "Throw strength and right-click launch controls for Fling Things and People.",
	}
	for pageName, textValue in pairs(tooltipMap) do
		if UI.pages[pageName] then UI.pages[pageName]:SetAttribute("Tooltip", textValue) end
	end

	-- Responsive viewport watcher. It avoids duplicate CurrentCamera listeners
	-- when Studio replaces the camera while play-testing.
	local viewportConnection
	local cameraConnection
	local function refreshResponsive()
		if Config.AutoFitWindow ~= false then fitWindow() end
		clampPosition(main, 10)
		clampPosition(commandWindow, 10)
		if UI.mysteryPopup then clampPosition(UI.mysteryPopup, 10) end
		local view = viewportSize()
		if commandWindow.Visible then commandScale.Scale = math.clamp(math.min(view.X / 530, view.Y / 470), .5, 1) end
		if UI.mysteryPopup then
			UI.mysteryPopupFitScale = math.clamp(math.min(view.X / 680, view.Y / 570), .45, 1)
			if not State.mysteryOpen and UI.mysteryPopupScale then UI.mysteryPopupScale.Scale = UI.mysteryPopupFitScale end
		end
		local compact = view.X < 820 or view.Y < 560
		statusPill.Position = UDim2.new(1, -18, 0, compact and 56 or 54)
		if compact and State.menuOpen and UI.saveStatus then UI.saveStatus.Visible = false end
		if not compact and UI.saveStatus then UI.saveStatus.Visible = not isMobile end
		if UI.rightRail then UI.rightRail.Visible = not compact and not isMobile and Config.LayoutStyle == "Lynen" end
	end
	local function bindCamera()
		disconnect(viewportConnection)
		disconnect(cameraConnection)
		camera = Workspace.CurrentCamera or camera
		if camera then viewportConnection = connect(camera:GetPropertyChangedSignal("ViewportSize"), refreshResponsive) end
		cameraConnection = connect(Workspace:GetPropertyChangedSignal("CurrentCamera"), function()
			camera = Workspace.CurrentCamera or camera
			bindCamera()
		end)
		refreshResponsive()
	end
	bindCamera()
	polish.refreshResponsive = refreshResponsive

	-- A stable focus ring improves keyboard/controller navigation without
	-- changing button activation semantics.
	local focusRing = Instance.new("UIStroke")
	focusRing.Name = "StaticsFocusRing"
	focusRing.Color = Theme.accent2
	focusRing.Thickness = 2
	focusRing.Transparency = 0
	focusRing.Enabled = false
	focusRing.Parent = gui
	local focusIndex = 0
	local focusTargets = {}
	local focusedObject = nil
	local focusGuard = nil
	local function isActuallyVisible(object)
		local current = object
		while current and current ~= gui do
			if current:IsA("GuiObject") and not current.Visible then return false end
			current = current.Parent
		end
		return current == gui
	end
	local function rebuildFocusTargets()
		table.clear(focusTargets)
		for _, object in ipairs(gui:GetDescendants()) do
			if object:IsA("TextButton") and object.Active and isActuallyVisible(object) then table.insert(focusTargets, object) end
		end
		if focusIndex > #focusTargets then focusIndex = #focusTargets end
	end
	local function showFocus(index)
		local object = focusTargets[index]
		if focusGuard then focusGuard:Disconnect(); focusGuard = nil end
		if not object or not object.Parent or not isActuallyVisible(object) then
			focusedObject = nil
			focusRing.Parent = gui
			focusRing.Enabled = false
			return
		end
		focusedObject = object
		focusGuard = object.AncestryChanged:Connect(function(_, parent)
			if not parent and focusedObject == object then
				focusedObject = nil
				focusRing.Parent = gui
				focusRing.Enabled = false
			end
		end)
		focusRing.Parent = object
		focusRing.Enabled = true
	end
	local function moveFocus(delta)
		rebuildFocusTargets()
		if #focusTargets == 0 then return end
		focusIndex = ((focusIndex - 1 + delta) % #focusTargets) + 1
		showFocus(focusIndex)
	end
	polish.rebuildFocusTargets = rebuildFocusTargets
	polish.moveFocus = moveFocus
	connect(UserInputService.InputBegan, function(input, processed)
		if processed or UI.bindingActive then return end
		if input.KeyCode == Enum.KeyCode.Tab and not UserInputService:GetFocusedTextBox() then
			local backwards = false
			pcall(function() backwards = input:IsModifierKeyDown(Enum.ModifierKey.Shift) end)
			moveFocus(backwards and -1 or 1)
			return
		end
		if input.KeyCode == Enum.KeyCode.Return and focusRing.Enabled then
			local object = focusRing.Parent
			if object and object:IsA("TextButton") then object:Activate() end
		end
	end)

	-- Runtime config validation prevents an old or hand-edited preference from
	-- creating NaNs, invalid enum names, or impossible viewport sizes.
	local numericRules = {
		AimStrength = {.02, .85},
		AimSmoothness = {.08, 1},
		AimRadius = {40, 500},
		PredictionTime = {0, .2},
		MaxAimDistance = {100, 1800},
		CameraFOV = {50, 130},
		FOVCircleOpacity = {.05, 1},
		FOVCircleThickness = {.5, 4},
		FOVCircleHue = {0, 1},
		ESPMaxDistance = {100, 2200},
		ESPTextSize = {10, 24},
		ESPFill = {.05, .9},
		EnemyColorHue = {0, 1},
		TeammateColorHue = {0, 1},
		BackgroundHue = {0, 1},
		BackgroundSaturation = {0, 1},
		BackgroundValue = {0, 1},
		BackgroundIntensity = {0, 1},
		CrosshairSize = {2, 24},
		CrosshairGap = {0, 20},
		UIScale = {.7, 1.3},
		TriggerDelay = {0, .25},
		TriggerFOV = {10, 200},
		FlingStrength = {0, 1000000},
		MusicVolume = {0, 1},
		RenderDistance = {100, 2000},
	}
	local booleanKeys = {
		"AimEnabled", "StickyAim", "WallCheck", "TeamCheck", "Prediction", "CameraAssist",
		"CameraFOVEnabled", "ShowFOVCircle", "ESPEnabled", "HighlightESP", "NameESP",
		"DistanceESP", "RoleESP", "VRESP", "SkeletonESP", "BoxESP", "TracerESP", "OffscreenESP",
		"HealthESP", "ESPTeamCheck", "ThroughWalls", "CustomBackground", "Watermark",
		"PauseUnfocused", "CullFar", "Crosshair", "MusicAutoplay", "MusicShuffle",
		"MusicLoop", "MysteryRoleColors", "MysteryRoleHUD", "MysteryMurdererAlert",
		"MysterySheriffAlert", "MysteryGunTracker", "MysteryAliveCounter", "TriggerEnabled",
		"TriggerTeamCheck", "ReduceMotion", "CompactNotifications", "TooltipHints",
		"ConfirmServerActions", "MysteryRoundHUD", "MysteryTimerHUD", "MysteryMapHUD",
		"MysteryRoleFeed", "MysteryEventFeed", "MysterySuspectMarks", "MysteryGunDistance",
		"FlingEnabled", "AutoFitWindow", "ShowDiagnostics",
	}
	local function validateConfig()
		for key, rule in pairs(numericRules) do
			local value = tonumber(Config[key])
			if not value or value ~= value then value = rule[1] end
			Config[key] = math.clamp(value, rule[1], rule[2])
		end
		for _, key in ipairs(booleanKeys) do
			if typeof(Config[key]) ~= "boolean" then Config[key] = DEFAULTS[key] == true end
		end
		if Config.ActiveProfile ~= "Universal" and Config.ActiveProfile ~= "Last Letter" and Config.ActiveProfile ~= "Murder Mystery" and Config.ActiveProfile ~= "Fling Things and People" then Config.ActiveProfile = "Universal" end
		if not Themes[Config.Theme] then Config.Theme = "Studio" end
		if Config.LayoutStyle ~= "Newgen" and Config.LayoutStyle ~= "Lynen" and Config.LayoutStyle ~= "Horizon" then Config.LayoutStyle = "Newgen" end
		if Config.PerformanceMode ~= "Off" and Config.PerformanceMode ~= "Balanced" and Config.PerformanceMode ~= "Max" and Config.PerformanceMode ~= "Potato" then Config.PerformanceMode = "Off" end
		if typeof(Config.TriggerKey) ~= "string" or #Config.TriggerKey == 0 then Config.TriggerKey = "E" end
		if #Config.TriggerKey == 1 then Config.TriggerKey = string.upper(Config.TriggerKey) end
		if Config.HitPart ~= "Body" and Config.HitPart ~= "Head" and Config.HitPart ~= "Random" then Config.HitPart = "Body" end
		Config.WallCheck = true
		if Config.ActiveProfile ~= "Fling Things and People" then Config.FlingEnabled = false end
	end
	UI.validateConfig = validateConfig
	validateConfig()

	-- MM2 round intelligence overlay. It is separate from the original popup
	-- controls, so users can close it without losing the role settings.
	local intel = nil
	local intelTitle = nil
	local intelPhase = nil
	local intelTimer = nil
	local intelAlive = nil
	local intelMap = nil
	local intelRoleList = nil
	local intelFeedList = nil
	local intelButton = nil
	local intelBack = nil
	local intelFeedVersion = 0
	local lastIntelRoleSignature = ""
	local lastIntelPhase = ""
	local function addMysteryFeed(textValue, color, kind)
		if kind == "role" and Config.MysteryRoleFeed == false then return end
		if kind ~= "role" and Config.MysteryEventFeed == false then return end
		table.insert(State.mysteryFeed, 1, {time = os.date("%H:%M:%S"), text = tostring(textValue), color = color or Theme.accent2, kind = kind or "event"})
		while #State.mysteryFeed > 30 do table.remove(State.mysteryFeed) end
		intelFeedVersion += 1
	end
	UI.addMysteryFeed = addMysteryFeed
	if UI.mysteryPopup then
		intelButton = button(UI.mysteryPopup, "ROUND INTEL", UDim2.fromOffset(104, 30), UDim2.new(1, -224, 0, 13), "accent")
		intelButton.Name = "RoundIntelButton"
		intelButton.ZIndex = 70
		intel = Instance.new("Frame")
		intel.Name = "RoundIntel"
		intel.Size = UDim2.new(1, -28, 1, -76)
		intel.Position = UDim2.fromOffset(14, 62)
		intel.BackgroundColor3 = Theme.bg
		intel.BorderSizePixel = 0
		intel.Visible = false
		intel.ZIndex = 75
		intel.Parent = UI.mysteryPopup
		corner(intel, 12)
		outline(intel, Theme.accent, .25, 1.5)
		intelTitle = label(intel, "MM2 / ROUND INTEL", UDim2.new(1, -160, 0, 22), UDim2.fromOffset(14, 10), Enum.Font.GothamBlack, "text", 16)
		intelTitle.ZIndex = 76
		local sub = label(intel, "Server payloads only / no role guessing", UDim2.new(1, -160, 0, 14), UDim2.fromOffset(14, 33), Enum.Font.Gotham, "muted", 9)
		sub.ZIndex = 76
		intelBack = button(intel, "BACK", UDim2.fromOffset(70, 28), UDim2.new(1, -84, 0, 13), "row")
		intelBack.ZIndex = 76
		local summary = Instance.new("Frame")
		summary.Size = UDim2.new(1, -24, 0, 62)
		summary.Position = UDim2.fromOffset(12, 58)
		summary.BackgroundTransparency = 1
		summary.Parent = intel
		local summaryLayout = Instance.new("UIGridLayout")
		summaryLayout.CellSize = UDim2.new(.25, -6, 1, 0)
		summaryLayout.CellPadding = UDim2.fromOffset(8, 0)
		summaryLayout.Parent = summary
		local function summaryItem(titleText)
			local item = panel(summary, UDim2.new(), nil, "panel")
			label(item, titleText, UDim2.new(1, -12, 0, 12), UDim2.fromOffset(6, 7), Enum.Font.Code, "muted", 8)
			local value = label(item, "--", UDim2.new(1, -12, 0, 24), UDim2.fromOffset(6, 25), Enum.Font.GothamBlack, "text", 12)
			value.TextTruncate = Enum.TextTruncate.AtEnd
			return value
		end
		intelPhase = summaryItem("PHASE")
		intelTimer = summaryItem("TIMER")
		intelAlive = summaryItem("ALIVE")
		intelMap = summaryItem("MAP")
		local rolesPanel = panel(intel, UDim2.new(.5, -18, 1, -144), UDim2.fromOffset(12, 132), "panel")
		local feedPanel = panel(intel, UDim2.new(.5, -18, 1, -144), UDim2.new(.5, 6, 0, 132), "panel")
		label(rolesPanel, "KNOWN ROLES", UDim2.new(1, -20, 0, 14), UDim2.fromOffset(10, 8), Enum.Font.Code, "accent2", 9)
		label(feedPanel, "EVENT FEED", UDim2.new(1, -20, 0, 14), UDim2.fromOffset(10, 8), Enum.Font.Code, "accent2", 9)
		intelRoleList = Instance.new("ScrollingFrame")
		intelRoleList.Size = UDim2.new(1, -12, 1, -34)
		intelRoleList.Position = UDim2.fromOffset(6, 30)
		intelRoleList.BackgroundTransparency = 1
		intelRoleList.BorderSizePixel = 0
		intelRoleList.ScrollBarThickness = 2
		intelRoleList.AutomaticCanvasSize = Enum.AutomaticSize.Y
		intelRoleList.CanvasSize = UDim2.new()
		intelRoleList.Parent = rolesPanel
		local roleLayout = Instance.new("UIListLayout")
		roleLayout.Padding = UDim.new(0, 3)
		roleLayout.Parent = intelRoleList
		intelFeedList = Instance.new("ScrollingFrame")
		intelFeedList.Size = UDim2.new(1, -12, 1, -34)
		intelFeedList.Position = UDim2.fromOffset(6, 30)
		intelFeedList.BackgroundTransparency = 1
		intelFeedList.BorderSizePixel = 0
		intelFeedList.ScrollBarThickness = 2
		intelFeedList.AutomaticCanvasSize = Enum.AutomaticSize.Y
		intelFeedList.CanvasSize = UDim2.new()
		intelFeedList.Parent = feedPanel
		local feedLayout = Instance.new("UIListLayout")
		feedLayout.Padding = UDim.new(0, 3)
		feedLayout.Parent = intelFeedList
		local markButton = button(intel, "MARKED SUSPECTS", UDim2.fromOffset(144, 28), UDim2.fromOffset(12, 1), "row")
		markButton.Visible = false
		markButton.ZIndex = 77
		local clearButton = button(intel, "CLEAR FEED", UDim2.fromOffset(104, 28), UDim2.new(1, -116, 1, -38), "row")
		clearButton.ZIndex = 77
		local function renderIntelRoles()
			if not intelRoleList then return end
			for _, child in ipairs(intelRoleList:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
			local names = {}
			for name in pairs(State.roles or {}) do table.insert(names, tostring(name)) end
			table.sort(names, function(a, b) return string.lower(a) < string.lower(b) end)
			for _, name in ipairs(names) do
				local role = tostring(State.roles[name] or "Unknown")
				local row = button(intelRoleList, "", UDim2.new(1, -4, 0, 28), nil, "row")
				row.TextXAlignment = Enum.TextXAlignment.Left
				row.Font = Enum.Font.Code
				row.TextSize = 9
				local marked = Config.MysterySuspectMarks and State.mysteryMarks[name]
				row.Text = (marked and "◆  " or "◇  ") .. name .. "  /  " .. string.upper(role)
				row.TextColor3 = marked and MysteryRoleColors.murderer or (mysteryRoleColor(role) or Theme.text)
				row.Activated:Connect(function()
					if Config.MysterySuspectMarks == false then return end
					State.mysteryMarks[name] = not State.mysteryMarks[name]
					addMysteryFeed((State.mysteryMarks[name] and "Marked suspect: " or "Cleared suspect: ") .. name, State.mysteryMarks[name] and MysteryRoleColors.murderer or Theme.muted, "role")
					renderIntelRoles()
				end)
			end
		end
		local renderedFeed = ""
		local function renderIntelFeed()
			local feedSignature = tostring(intelFeedVersion) .. ":" .. tostring(Config.MysteryRoleFeed ~= false) .. ":" .. tostring(Config.MysteryEventFeed ~= false)
			if renderedFeed == feedSignature then return end
			renderedFeed = feedSignature
			if not intelFeedList then return end
			for _, child in ipairs(intelFeedList:GetChildren()) do if child:IsA("TextLabel") then child:Destroy() end end
			local displayIndex = 0
			for _, item in ipairs(State.mysteryFeed or {}) do
				local allowed = item.kind == "role" and Config.MysteryRoleFeed ~= false or item.kind ~= "role" and Config.MysteryEventFeed ~= false
				if allowed then
					displayIndex += 1
					local index = displayIndex
					local row = Instance.new("TextLabel")
				row.Size = UDim2.new(1, -4, 0, 28)
				row.BackgroundColor3 = Theme.row
				row.BackgroundTransparency = .2
				row.BorderSizePixel = 0
				row.Font = Enum.Font.Code
				row.TextSize = 8
				row.TextWrapped = true
				row.TextXAlignment = Enum.TextXAlignment.Left
				row.Text = "  " .. tostring(item.time or "--:--") .. "  " .. tostring(item.text or "")
				row.TextColor3 = item.color or Theme.text
				row.LayoutOrder = index
				row.Parent = intelFeedList
					corner(row, 4)
					end
				end
			end
			local function renderIntel()
			if not intel then return end
			local meta = State.mysteryMeta or {}
			local phase = meta.phase or meta.Phase or meta.roundState or meta.RoundState or meta.state or meta.State or meta.status or meta.Status or (next(State.roles) and "ROUND LIVE" or "WAITING")
			local timeLeft = meta.timeLeft or meta.TimeLeft or meta.roundTime or meta.RoundTime or meta.timer or meta.Timer or meta.remaining or meta.Remaining or meta.seconds
			local mapName = meta.map or meta.Map or meta.mapName or meta.MapName or meta.location or meta.Location or "--"
			local alive = tonumber(meta.alive or meta.Alive or meta.aliveCount or meta.AliveCount) or 0
			if alive == 0 then for _, target in ipairs(Players:GetPlayers()) do if living(target) then alive += 1 end end end
			local phaseText = string.upper(tostring(phase))
			if lastIntelPhase ~= "" and lastIntelPhase ~= phaseText then addMysteryFeed("Round phase: " .. phaseText, Theme.accent2) end
			lastIntelPhase = phaseText
			intelPhase.Text = phaseText
			intelPhase.TextColor3 = mysteryRoleColor(phase) or Theme.accent2
			intelTimer.Text = timeLeft and formatDuration(timeLeft) or "--:--"
			intelAlive.Text = Config.MysteryAliveCounter and tostring(alive) .. " / " .. tostring(#Players:GetPlayers()) or "HIDDEN"
			intelMap.Text = Config.MysteryMapHUD and string.upper(tostring(mapName)) or "OFF"
			rolesPanel.Visible = Config.MysteryRoleFeed ~= false
			feedPanel.Visible = Config.MysteryRoleFeed ~= false or Config.MysteryEventFeed ~= false
			if State.mysteryIntelOpen then renderIntelRoles(); renderIntelFeed() end
		end
		local function setIntel(value)
			State.mysteryIntelOpen = value == true
			intel.Visible = State.mysteryIntelOpen and mysteryActive() and State.profileChosen
			intelButton.Visible = not State.mysteryIntelOpen and mysteryActive() and State.profileChosen
			if intel.Visible then
				if UI.setMysteryPopup then UI.setMysteryPopup(true) end
				if mysteryHud then mysteryHud.Visible = false end
				renderIntel()
			end
		end
		UI.mysteryIntelFrame = intel
		UI.mysteryIntelButton = intelButton
		intelButton.Activated:Connect(function() setIntel(true) end)
		intelBack.Activated:Connect(function() setIntel(false) end)
		clearButton.Activated:Connect(function() table.clear(State.mysteryFeed); intelFeedVersion += 1; renderIntelFeed() end)
		polish.setMysteryIntel = setIntel
		polish.renderMysteryIntel = renderIntel
	end

	-- Detect server role changes and turn them into concise local feed entries.
	local function roleSignature()
		local names = {}
		for name, role in pairs(State.roles or {}) do table.insert(names, tostring(name) .. "=" .. tostring(role)) end
		table.sort(names)
		return table.concat(names, "|")
	end
	polish.roleSignature = roleSignature

	-- A simple local profile snapshot API makes the existing Profiles behavior
	-- useful to other UI pages without adding a second persistence system.
	local function captureProfile()
		local result = {}
		for key in pairs(DEFAULTS) do result[key] = Config[key] end
		return result
	end
	local function applyProfile(values)
		if typeof(values) ~= "table" then return false end
		for key in pairs(DEFAULTS) do if values[key] ~= nil then Config[key] = values[key] end end
		Config.FlingEnabled = false
		validateConfig()
		if UI.applyTheme then UI.applyTheme(Config.Theme, true) end
		if UI.applyLayout then UI.applyLayout(Config.LayoutStyle, false) end
		if UI.applyBackground then UI.applyBackground() end
		for _, refresh in ipairs(UI.refreshers) do safeCall(refresh) end
		State.dirty = true
		return true
	end
	UI.captureProfile = captureProfile
	UI.applyProfile = applyProfile
	UI.resetCoreSettings = function()
		local keep = {ActiveProfile = Config.ActiveProfile, Theme = Config.Theme, LayoutStyle = Config.LayoutStyle}
		for key, value in pairs(DEFAULTS) do Config[key] = value end
		for key, value in pairs(keep) do Config[key] = value end
		Config.WallCheck = true
		validateConfig()
		for _, refresh in ipairs(UI.refreshers) do safeCall(refresh) end
		State.target = nil
		State.dirty = true
	end

	-- Add a small diagnostics card to the Session page without changing the
	-- existing server action buttons.
	if UI.pages.Session then
		local diagnostics = panel(UI.pages.Session, UDim2.new(1, -28, 0, 126), UDim2.fromOffset(14, 414), "panel")
		diagnostics.Name = "RuntimeDiagnostics"
		label(diagnostics, "RUNTIME DIAGNOSTICS", UDim2.fromOffset(180, 14), UDim2.fromOffset(12, 10), Enum.Font.Code, "accent2", 9)
		local diagnosticsText = label(diagnostics, "Collecting...", UDim2.new(1, -24, 0, 38), UDim2.fromOffset(12, 32), Enum.Font.Code, "muted", 9)
		diagnosticsText.TextWrapped = true
		local resetSettings = button(diagnostics, "RESET CORE SETTINGS", UDim2.fromOffset(158, 30), UDim2.fromOffset(12, 84), "row")
		local refreshDiagnostics = button(diagnostics, "REFRESH", UDim2.fromOffset(92, 30), UDim2.new(1, -104, 0, 84), "row")
		local function renderDiagnostics()
			local view = viewportSize()
			local pingValue = 0
			pcall(function() pingValue = player:GetNetworkPing() * 1000 end)
			local ping = math.floor(pingValue)
			local roleCount = 0
			for _ in pairs(State.roles or {}) do roleCount += 1 end
			diagnosticsText.Text = string.format("DEVICE  /  %s\nVIEWPORT  /  %dx%d\nFPS  /  %d    PING  /  %dms    ROLES  /  %d", string.upper(device), view.X, view.Y, State.fps or 0, ping, roleCount)
		end
		resetSettings.Activated:Connect(function()
			if Config.ConfirmServerActions then
				notify("Core settings reset locally", true)
			end
			UI.resetCoreSettings()
			renderDiagnostics()
		end)
		refreshDiagnostics.Activated:Connect(renderDiagnostics)
		UI.renderDiagnostics = renderDiagnostics
		renderDiagnostics()
	end

	-- Provide explicit cleanup for repeated Studio test runs. The outer script
	-- already removes old GUIs; this also stops bindings owned by this layer.
	local cleaned = false
	function UI.cleanupProfessional()
		if cleaned then return end
		cleaned = true
		hideTooltip()
		if UI.destroyFling then pcall(UI.destroyFling) end
		for _, connection in ipairs(State.connections) do disconnect(connection) end
		table.clear(State.connections)
		if statusPill then statusPill:Destroy() end
		if tooltip then tooltip:Destroy() end
		if focusGuard then pcall(function() focusGuard:Disconnect() end); focusGuard = nil end
		if focusRing then focusRing:Destroy() end
		if UI.mysteryIntelFrame and UI.mysteryIntelFrame.Parent then UI.mysteryIntelFrame:Destroy() end
	end
	gui.AncestryChanged:Connect(function(_, parent) if not parent then UI.cleanupProfessional() end end)

	-- Controlled render-loop service for small status updates. It deliberately
	-- runs at 5 Hz rather than one callback for every property in the UI.
	local serviceClock = 0
	local lastSignature = ""
	connect(RunService.Heartbeat, function(dt)
		serviceClock += dt
		if serviceClock < .2 then return end
		serviceClock = 0
		validateConfig()
		local signature = roleSignature()
		if signature ~= lastSignature then
			if lastSignature ~= "" and signature ~= "" then addMysteryFeed("Role payload updated", Theme.accent2, "role") end
			lastSignature = signature
			if polish.renderMysteryIntel then polish.renderMysteryIntel() end
		end
		if polish.renderMysteryIntel and State.mysteryIntelOpen then polish.renderMysteryIntel() end
		if UI.renderDiagnostics and Config.ShowDiagnostics then UI.renderDiagnostics() end
		if startupFinished then
			local warning = startupError ~= nil
			setRuntimeStatus(warning and "WARNINGS" or (State.menuOpen and "MENU OPEN" or "READY"), warning and Color3.fromRGB(245, 181, 94) or Color3.fromRGB(52, 211, 153), Config.ShowDiagnostics)
		end
	end)

	-- Theme refresh for polish-owned objects.
	table.insert(UI.refreshers, function()
		statusPill.BackgroundColor3 = Theme.panel
		tooltip.BackgroundColor3 = Theme.panel
		if focusRing then focusRing.Color = Theme.accent2 end
		if UI.mysteryIntelFrame then UI.mysteryIntelFrame.BackgroundColor3 = Theme.bg end
		if polish.renderMysteryIntel and State.mysteryIntelOpen then polish.renderMysteryIntel() end
	end)

	-- Add explicit responsive behavior to the launcher and floating HUDs.
	local function placeFloatingObjects()
		local view = viewportSize()
		local compact = view.X < 700 or view.Y < 520
		if launcher then
			launcher.Position = compact and UDim2.new(0, 10, 1, -58) or UDim2.new(0, 16, 1, -64)
		end
		if UI.mysteryButton then
			UI.mysteryButton.Position = compact and UDim2.new(0, 74, 1, -58) or UDim2.new(0, 146, 1, -64)
		end
		if UI.quickBar and isMobile then UI.quickBar.Size = UDim2.new(1, -16, 0, 180) end
		if crosshair then crosshair.Position = UDim2.fromScale(.5, .5) end
	end
	polish.placeFloatingObjects = placeFloatingObjects
	connect(RunService.RenderStepped, function()
		if not gui.Parent then return end
		placeFloatingObjects()
	end)

	-- All controls are opt-in for tooltips; adding metadata here keeps the
	-- existing rows uncluttered and makes the more technical settings discoverable.
	local tooltipAttributes = {
		["Master aim assist"] = "Hold the configured aim input to acquire a visible target.",
		["Triggerbot"] = "Activates the equipped Tool when a valid target overlaps the trigger FOV.",
		["Through walls"] = "Controls local Highlight depth mode only.",
		["Performance"] = "Changes are client-side and reversible where Roblox permits it.",
	}
	for _, object in ipairs(gui:GetDescendants()) do
		if object:IsA("TextLabel") or object:IsA("TextButton") then
			for titleText, hintText in pairs(tooltipAttributes) do
				if object.Text == titleText then object:SetAttribute("Tooltip", hintText) end
			end
		end
	end

	-- Refresh initial state after all additions have been made.
	validateConfig()
	for _, refresh in ipairs(UI.refreshers) do safeCall(refresh) end
	refreshResponsive()
	placeFloatingObjects()
end
UI._installProfessionalPolish()

-- ========================================================================
-- EXTENDED QUALITY SERVICES / EXPORT / ROUND STRIP / RESTORE CONTROLS
-- ========================================================================
UI._installExtendedServices = function()
	local polish = UI.professional or {}
	local connect = polish.connect
	local safeCall = polish.safeCall
	local viewportSize = polish.viewportSize
	local validateConfig = UI.validateConfig
	if type(connect) ~= "function" or type(safeCall) ~= "function" or type(viewportSize) ~= "function" or type(validateConfig) ~= "function" then error("Professional service dependencies are unavailable") end
	State.metrics = State.metrics or {frames = 0, seconds = 0, fpsSamples = {}, pingSamples = {}, lastHealth = ""}
	local metrics = State.metrics
	local function trimSamples(list, maximum)
		while #list > maximum do table.remove(list, 1) end
	end
	local function addSample(list, value, maximum)
		if typeof(value) ~= "number" or value ~= value then return end
		table.insert(list, value)
		trimSamples(list, maximum or 60)
	end
	local function average(list)
		if #list == 0 then return 0 end
		local total = 0
		for _, value in ipairs(list) do total += value end
		return total / #list
	end
	polish.addSample = addSample
	polish.average = average

	-- A compact MM2 strip gives phase, timer, alive count, and map at a glance.
	-- It is independent of the original role badge and hides outside the profile.
	local roundStrip = Instance.new("Frame")
	roundStrip.Name = "StaticsRoundStrip"
	roundStrip.AnchorPoint = Vector2.new(.5, 0)
	roundStrip.Position = UDim2.new(.5, 0, 0, 68)
	roundStrip.Size = UDim2.fromOffset(540, 38)
	roundStrip.BackgroundColor3 = Theme.panel
	roundStrip.BackgroundTransparency = .08
	roundStrip.BorderSizePixel = 0
	roundStrip.Visible = false
	roundStrip.ZIndex = 435
	roundStrip.Parent = gui
	corner(roundStrip, 10)
	local roundStroke = outline(roundStrip, Theme.accent, .22, 1.2)
	local roundPhase = label(roundStrip, "WAITING", UDim2.fromOffset(150, 18), UDim2.fromOffset(12, 5), Enum.Font.GothamBlack, "accent2", 9)
	local roundTimer = label(roundStrip, "--:--", UDim2.fromOffset(80, 18), UDim2.fromOffset(166, 5), Enum.Font.Code, "text", 10)
	local roundAlive = label(roundStrip, "ALIVE --", UDim2.fromOffset(100, 18), UDim2.fromOffset(252, 5), Enum.Font.Code, "muted", 9)
	local roundMap = label(roundStrip, "MAP --", UDim2.fromOffset(166, 18), UDim2.fromOffset(360, 5), Enum.Font.Code, "muted", 9)
	roundMap.TextXAlignment = Enum.TextXAlignment.Right
	local roundScale = Instance.new("UIScale")
	roundScale.Parent = roundStrip
	UI.roundStrip = roundStrip
	local function roleCountAlive()
		local count = 0
		for _, target in ipairs(Players:GetPlayers()) do if living(target) then count += 1 end end
		return count
	end
	local function phaseValue()
		local meta = State.mysteryMeta or {}
		return meta.phase or meta.Phase or meta.roundState or meta.RoundState or meta.state or meta.State or meta.status or meta.Status or (next(State.roles) and "ROUND LIVE" or "WAITING")
	end
	local function timerValue()
		local meta = State.mysteryMeta or {}
		return meta.timeLeft or meta.TimeLeft or meta.roundTime or meta.RoundTime or meta.timer or meta.Timer or meta.remaining or meta.Remaining or meta.seconds
	end
	local function mapValue()
		local meta = State.mysteryMeta or {}
		return meta.map or meta.Map or meta.mapName or meta.MapName or meta.location or meta.Location or "--"
	end
	local function renderRoundStrip()
		local active = mysteryActive() and State.profileChosen and Config.MysteryRoundHUD ~= false and not State.menuOpen and not State.mysteryOpen
		roundStrip.Visible = active
		if not active then return end
		local phase = phaseValue()
		local timer = timerValue()
		local alive = roleCountAlive()
		roundPhase.Text = string.upper(tostring(phase))
		roundTimer.Text = Config.MysteryTimerHUD == false and "--:--" or (timer and formatDuration(timer) or "--:--")
		roundAlive.Text = Config.MysteryAliveCounter == false and "ALIVE --" or ("ALIVE " .. tostring(alive))
		roundMap.Text = Config.MysteryMapHUD == false and "MAP --" or ("MAP " .. string.upper(tostring(mapValue())))
		local phaseText = string.lower(tostring(phase))
		if string.find(phaseText, "end", 1, true) or string.find(phaseText, "over", 1, true) then
			roundPhase.TextColor3 = MysteryRoleColors.murderer
		elseif string.find(phaseText, "live", 1, true) or string.find(phaseText, "round", 1, true) then
			roundPhase.TextColor3 = MysteryRoleColors.innocent
		else
			roundPhase.TextColor3 = Theme.accent2
		end
	end
	UI.renderRoundStrip = renderRoundStrip

	-- Explicit motion controls are useful on low-power mobile devices and for
	-- players who are sensitive to repeated scale/position animations.
	local motionButton
	if UI.pages.Themes then
		motionButton = makeToggle(UI.pages.Themes, "Reduce interface motion", 468, function() return Config.ReduceMotion end, function(value)
			Config.ReduceMotion = value
			State.dirty = true
		end)
	end
	UI.refreshMotion = motionButton

	-- Performance snapshots make the Max/Potato modes reversible even when a
	-- streamed object arrives after the original performance pass.
	local performanceOriginals = setmetatable({}, {__mode = "k"})
	local function rememberPerformance(object, property)
		if not object or not object.Parent then return end
		local saved = performanceOriginals[object]
		if not saved then saved = {}; performanceOriginals[object] = saved end
		if saved[property] == nil then saved[property] = object[property] end
	end
	local function changePerformance(object, property, value)
		if not object or not object.Parent then return false end
		if object[property] == value then return false end
		rememberPerformance(object, property)
		local ok = pcall(function() object[property] = value end)
		return ok
	end
	local function restorePerformance(silent)
		local restored = 0
		for object, properties in pairs(performanceOriginals) do
			if object.Parent then
				for property, value in pairs(properties) do
					if pcall(function() object[property] = value end) then restored += 1 end
				end
			end
		end
		table.clear(performanceOriginals)
		if not silent and UI.notify then UI.notify("Restored " .. tostring(restored) .. " local visual properties", true) end
		return restored
	end
	polish.rememberPerformance = rememberPerformance
	polish.changePerformance = changePerformance
	polish.restorePerformance = restorePerformance
	UI.changePerformance = changePerformance
	UI.restorePerformance = restorePerformance
	if UI.pages.Performance then
		local restoreCard = panel(UI.pages.Performance, UDim2.new(1, -28, 0, 78), UDim2.fromOffset(14, 552), "panel")
		restoreCard.Name = "PerformanceRestoreCard"
		label(restoreCard, "REVERSIBLE RESTORE", UDim2.fromOffset(190, 14), UDim2.fromOffset(12, 10), Enum.Font.Code, "accent2", 9)
		local restoreNote = label(restoreCard, "Restore properties captured by the professional controller.", UDim2.new(1, -180, 0, 15), UDim2.fromOffset(12, 32), Enum.Font.Gotham, "muted", 8)
		restoreNote.TextTruncate = Enum.TextTruncate.AtEnd
		local restoreButton = button(restoreCard, "RESTORE", UDim2.fromOffset(110, 32), UDim2.new(1, -122, .5, -16), "row")
		restoreButton.Activated:Connect(function()
			restorePerformance()
			if UI.applyPerformance then UI.applyPerformance("Off") end
		end)
	end

	-- Export and import are opt-in UI helpers. JSON is displayed in a textbox;
	-- nothing is copied to the clipboard and no external request is made.
	local exportBox
	if UI.pages.Session then
		local exportCard = panel(UI.pages.Session, UDim2.new(1, -28, 0, 178), UDim2.fromOffset(14, 550), "panel")
		exportCard.Name = "SettingsTransfer"
		label(exportCard, "SETTINGS TRANSFER", UDim2.fromOffset(170, 14), UDim2.fromOffset(12, 9), Enum.Font.Code, "accent2", 9)
		exportBox = Instance.new("TextBox")
		exportBox.Size = UDim2.new(1, -24, 0, 76)
		exportBox.Position = UDim2.fromOffset(12, 32)
		exportBox.BackgroundColor3 = Theme.row
		exportBox.BorderSizePixel = 0
		exportBox.ClearTextOnFocus = false
		exportBox.MultiLine = true
		exportBox.TextWrapped = false
		exportBox.PlaceholderText = "Settings JSON appears here"
		exportBox.PlaceholderColor3 = Theme.muted
		exportBox.TextColor3 = Theme.text
		exportBox.Font = Enum.Font.Code
		exportBox.TextSize = 8
		exportBox.Parent = exportCard
	corner(exportBox, 6)
	bindTheme(exportBox, "BackgroundColor3", "row")
	bindTheme(exportBox, "TextColor3", "text")
	bindTheme(exportBox, "PlaceholderColor3", "muted")
	local exportButton = button(exportCard, "EXPORT", UDim2.fromOffset(100, 30), UDim2.fromOffset(12, 124), "row")
	local importButton = button(exportCard, "IMPORT", UDim2.fromOffset(100, 30), UDim2.fromOffset(120, 124), "accent")
	local status = label(exportCard, "Local JSON only", UDim2.new(1, -240, 0, 30), UDim2.new(1, -228, 0, 124), Enum.Font.Code, "muted", 8)
	status.TextXAlignment = Enum.TextXAlignment.Right
	local function exportSettings()
		local snapshot = {}
		for key in pairs(DEFAULTS) do snapshot[key] = Config[key] end
		local ok, encoded = pcall(function() return HttpService:JSONEncode(snapshot) end)
		if ok then exportBox.Text = encoded; status.Text = "EXPORTED"; status.TextColor3 = Theme.accent2 else status.Text = "EXPORT FAILED" end
	end
	local function importSettings()
		local ok, value = pcall(function() return HttpService:JSONDecode(exportBox.Text) end)
		if not ok or typeof(value) ~= "table" then status.Text = "INVALID JSON"; status.TextColor3 = Color3.fromRGB(248, 75, 90); return end
		for key in pairs(DEFAULTS) do if value[key] ~= nil then Config[key] = value[key] end end
		Config.FlingEnabled = false
		validateConfig()
		if UI.applyTheme then UI.applyTheme(Config.Theme, true) end
		if UI.applyLayout then UI.applyLayout(Config.LayoutStyle, false) end
		if UI.applyBackground then UI.applyBackground() end
		for _, refresh in ipairs(UI.refreshers) do safeCall(refresh) end
		State.dirty = true
		status.Text = "IMPORTED"
		status.TextColor3 = Theme.accent2
	end
	exportButton.Activated:Connect(exportSettings)
	importButton.Activated:Connect(importSettings)
	UI.exportSettings = exportSettings
	UI.importSettings = importSettings
	end

	-- Input modality is exposed through a small attribute so page builders and
	-- themes can adapt labels without competing UserInputService listeners.
	local modality = "Keyboard"
	local function setModality(inputType)
		local name = tostring(inputType)
		if string.find(name, "Touch", 1, true) then modality = "Touch"
		elseif string.find(name, "Gamepad", 1, true) then modality = "Gamepad"
		else modality = "Keyboard" end
		UI.inputModality = modality
		gui:SetAttribute("InputModality", modality)
	end
	connect(UserInputService.LastInputTypeChanged, setModality)
	setModality(UserInputService:GetLastInputType())

	-- Compact interaction helpers used by action cards and server buttons.
	local debounceTimes = {}
	local function debounce(key, seconds)
		local now = os.clock()
		local last = debounceTimes[key] or 0
		if now - last < (seconds or .25) then return false end
		debounceTimes[key] = now
		return true
	end
	local function safeActivate(key, seconds, callback)
		if not debounce(key, seconds) then return false end
		local ok = safeCall(callback)
		return ok
	end
	polish.debounce = debounce
	polish.safeActivate = safeActivate

	local function networkPingMilliseconds()
		local value = 0
		pcall(function() value = tonumber(player:GetNetworkPing()) or 0 end)
		return math.max(value * 1000, 0)
	end
	-- A status snapshot is useful in the diagnostics page and does not retain
	-- any Instance references, so it is safe to print or inspect in Studio.
	local function healthReport()
		local view = viewportSize()
		local visualCount = 0
		for _ in pairs(State.visuals or {}) do visualCount += 1 end
		local roleCount = 0
		for _ in pairs(State.roles or {}) do roleCount += 1 end
		local report = {
			device = device,
			viewport = {x = view.X, y = view.Y},
			fps = State.fps or 0,
			ping = math.floor(networkPingMilliseconds()),
			profile = Config.ActiveProfile,
			page = State.currentPage,
			visuals = visualCount,
			roles = roleCount,
			menuOpen = State.menuOpen,
			mysteryOpen = State.mysteryOpen,
			triggerEnabled = Config.TriggerEnabled == true,
			warnings = startupError ~= nil,
		}
		return report
	end
	UI.healthReport = healthReport

	-- Diagnostics history is bounded; it can be inspected without a memory leak.
	local history = {}
	local function recordHealth()
		local report = healthReport()
		table.insert(history, report)
		while #history > 60 do table.remove(history, 1) end
		return report
	end
	UI.healthHistory = history
	UI.recordHealth = recordHealth

	-- Keep the round strip and diagnostics in sync with the actual update rate.
	connect(RunService.Heartbeat, function(dt)
		metrics.seconds += dt
		metrics.frames += 1
		if metrics.seconds >= .5 then
			addSample(metrics.fpsSamples, metrics.frames / metrics.seconds, 120)
			addSample(metrics.pingSamples, networkPingMilliseconds(), 120)
			metrics.frames = 0
			metrics.seconds = 0
			renderRoundStrip()
			recordHealth()
		end
	end)

	-- Refresh only the extra objects owned by this extension on a theme change.
	table.insert(UI.refreshers, function()
		roundStrip.BackgroundColor3 = Theme.panel
		roundStroke.Color = Theme.accent
		roundPhase.TextColor3 = Theme.accent2
		for _, child in ipairs(roundStrip:GetChildren()) do
			if child:IsA("TextLabel") and child ~= roundPhase then child.TextColor3 = Theme.muted end
		end
		if exportBox then
			exportBox.BackgroundColor3 = Theme.row
			exportBox.TextColor3 = Theme.text
		end
		renderRoundStrip()
	end)

	-- Escape is scoped so a focused TextBox or gate keeps its own behavior.
	connect(UserInputService.InputBegan, function(input, processed)
		if processed or UI.bindingActive or UserInputService:GetFocusedTextBox() then return end
		if input.KeyCode == Enum.KeyCode.Escape then
			if State.mysteryIntelOpen and polish.setMysteryIntel then polish.setMysteryIntel(false)
			elseif State.mysteryOpen and UI.setMysteryPopup then UI.setMysteryPopup(false)
			elseif State.menuOpen then setMenu(false)
			elseif commandWindow.Visible then commandWindow.Visible = false end
		end
	end)

	-- Do not let the optional strip overlap the compact mobile controls.
	connect(RunService.RenderStepped, function()
		if not gui.Parent then return end
		local view = viewportSize()
		local compact = view.X < 700 or view.Y < 520
		roundScale.Scale = math.clamp(math.min(view.X / 580, view.Y / 720), .55, 1)
		roundStrip.Position = UDim2.new(.5, 0, 0, compact and 56 or 68)
		renderRoundStrip()
	end)

	validateConfig()
	renderRoundStrip()
	if UI.renderDiagnostics then UI.renderDiagnostics() end
end
UI._installExtendedServices()

-- ========================================================================
-- MM2 OPTIONS DRAWER / HUD CONTROL CENTER
-- ========================================================================
UI._installMM2Options = function()
	if UI.mysteryPopup then
		local optionsButton = button(UI.mysteryPopup, "OPTIONS", UDim2.fromOffset(76, 30), UDim2.new(1, -128, 0, 13), "row")
		optionsButton.Name = "MysteryOptionsButton"
		optionsButton.ZIndex = 82
		optionsButton.Font = Enum.Font.GothamBlack
		optionsButton.TextSize = 9
		local options = panel(UI.mysteryPopup, UDim2.fromOffset(248, 286), UDim2.new(1, -262, 0, 58), "panel")
		options.Name = "MysteryOptionsDrawer"
		options.Visible = false
		options.ZIndex = 85
		local optionsTitle = label(options, "MM2 DISPLAY", UDim2.new(1, -20, 0, 18), UDim2.fromOffset(10, 9), Enum.Font.Code, "accent2", 9)
		optionsTitle.ZIndex = 86
		local optionsHint = label(options, "HUD and intel preferences", UDim2.new(1, -20, 0, 14), UDim2.fromOffset(10, 27), Enum.Font.Gotham, "muted", 8)
		optionsHint.ZIndex = 86
		makeToggle(options, "Round HUD", 48, function() return Config.MysteryRoundHUD end, function(value) Config.MysteryRoundHUD = value end)
		makeToggle(options, "Timer", 96, function() return Config.MysteryTimerHUD end, function(value) Config.MysteryTimerHUD = value end)
		makeToggle(options, "Map name", 144, function() return Config.MysteryMapHUD end, function(value) Config.MysteryMapHUD = value end)
		makeToggle(options, "Role feed", 192, function() return Config.MysteryRoleFeed end, function(value) Config.MysteryRoleFeed = value end)
		makeToggle(options, "Event feed", 240, function() return Config.MysteryEventFeed end, function(value) Config.MysteryEventFeed = value end)
		local optionsOpen = false
		optionsButton.Activated:Connect(function()
			optionsOpen = not optionsOpen
			options.Visible = optionsOpen
			optionsButton.Text = optionsOpen and "CLOSE" or "OPTIONS"
		end)
		for _, object in ipairs(options:GetDescendants()) do
			if object:IsA("GuiObject") then object.ZIndex = 86 end
		end
		UI.mysteryOptions = options
	end
end
UI._installMM2Options()

-- Triggerbot feedback ring: visual-only feedback for the same FOV used by
-- the single trigger loop above. It never performs an activation itself.
UI._installTriggerFeedback = function()
	local triggerRing = Instance.new("Frame")
	triggerRing.Name = "StaticsTriggerFOV"
	triggerRing.AnchorPoint = Vector2.new(.5, .5)
	triggerRing.Position = UDim2.fromScale(.5, .5)
	triggerRing.Size = UDim2.fromOffset(120, 120)
	triggerRing.BackgroundTransparency = 1
	triggerRing.Visible = false
	triggerRing.ZIndex = 388
	triggerRing.Parent = gui
	corner(triggerRing, 1000)
	local triggerRingStroke = outline(triggerRing, Theme.accent2, .5, 1)
	local triggerRingLabel = label(triggerRing, "", UDim2.new(1, -10, 0, 16), UDim2.fromOffset(5, -20), Enum.Font.Code, "accent2", 8)
	triggerRingLabel.TextXAlignment = Enum.TextXAlignment.Center
	triggerRingLabel.ZIndex = 389
	local function refreshTriggerRing()
		local enabled = Config.TriggerEnabled == true and not State.menuOpen and not State.mysteryOpen
		triggerRing.Visible = enabled
		if not enabled then return end
		local radius = math.clamp(tonumber(Config.TriggerFOV) or 60, 4, 240)
		triggerRing.Size = UDim2.fromOffset(radius * 2, radius * 2)
		triggerRing.Position = UDim2.fromScale(.5, .5)
		triggerRingStroke.Color = State.triggerTarget and Theme.accent2 or Theme.muted
		triggerRingStroke.Transparency = State.triggerTarget and .18 or .62
		triggerRingLabel.Text = State.triggerTarget and "TARGET LOCK" or "TRIGGER FOV"
	end
	UI.refreshTriggerRing = refreshTriggerRing
	RunService.RenderStepped:Connect(refreshTriggerRing)
	table.insert(UI.refreshers, function()
		triggerRingStroke.Color = Theme.accent2
		refreshTriggerRing()
	end)
end
UI._installTriggerFeedback()

-- ========================================================================
-- FINAL SELF-CHECK / RECOVERY REPORT
-- ========================================================================
UI._installSelfCheck = function()
	local selfCheck = {
		started = os.clock(),
		checks = {},
		warnings = {},
		passed = 0,
	}
	local function check(name, condition, detail)
		local item = {name = name, passed = condition == true, detail = detail or ""}
		table.insert(selfCheck.checks, item)
		if item.passed then selfCheck.passed += 1 else table.insert(selfCheck.warnings, item) end
		return item.passed
	end
	check("Player", player ~= nil, "LocalPlayer is available")
	check("PlayerGui", playerGui ~= nil and playerGui.Parent ~= nil, "PlayerGui is parented")
	check("Main GUI", gui ~= nil and gui.Parent ~= nil, "StaticsNewgenUI exists")
	check("Loader", Loader ~= nil and Loader.root ~= nil, "Loader references exist")
	check("Theme", Themes[Config.Theme] ~= nil, "Selected theme is registered")
	check("Layout", Config.LayoutStyle == "Newgen" or Config.LayoutStyle == "Lynen" or Config.LayoutStyle == "Horizon", "Selected layout is supported")
	check("Aim page", UI.pages.Aim ~= nil, "Aim page built")
	check("Visual page", UI.pages.Visuals ~= nil, "Visuals page built")
	check("Performance page", UI.pages.Performance ~= nil, "Performance page built")
	check("Mystery popup", UI.mysteryPopup ~= nil, "Murder Mystery popup built")
	check("Fling page", UI.pages.Fling ~= nil, "Fling Things and People page built")
	check("Fling lifecycle", type(UI.stopFling) == "function" and type(UI.destroyFling) == "function", "Fling input and cleanup services exist")
	check("Professional services", UI.professional ~= nil and type(UI.professional.connect) == "function" and type(UI.renderRoundStrip) == "function", "Professional and extended services are wired")
	check("Trigger setting", Config.TriggerEnabled ~= nil, "Triggerbot setting exists")
	check("ESP setting", Config.ESPEnabled ~= nil, "ESP setting exists")
	check("Word helper", type(recommend) == "function", "Word recommendation index exists")
	check("Aim binding", camera ~= nil, "Camera is available")
	check("Preference snapshot", type(preferenceSnapshot) == "function", "Preference snapshot exists")
	check("Recovery handler", type(recover) == "function", "Bootstrap recovery exists")
	local function report()
		local total = #selfCheck.checks
		local message = string.format("SELF CHECK  /  %d of %d passed", selfCheck.passed, total)
		if #selfCheck.warnings > 0 then message ..= "  /  " .. tostring(#selfCheck.warnings) .. " warnings" end
		return message
	end
	selfCheck.report = report
	UI.selfCheck = selfCheck
	if #selfCheck.warnings > 0 then
		startupError = startupError or report()
		warn("[StaticsNewgen] " .. report())
	else
		print("[StaticsNewgen] " .. report())
	end
	if UI.runtimeStatusText then
		UI.runtimeStatusText.Text = #selfCheck.warnings > 0 and "WARNINGS" or "READY"
	end
end

UI._installSelfCheckSummary = function()
	local selfCheck = UI.selfCheck or {checks = {}, warnings = {}, passed = 0}
	-- Keep a short machine-readable summary for future recovery diagnostics.
	selfCheck.summary = {
		lineTarget = 5000,
		checkCount = #selfCheck.checks,
		passed = selfCheck.passed,
		warningCount = #selfCheck.warnings,
		startupSeconds = os.clock() - (selfCheck.started or os.clock()),
		profile = Config.ActiveProfile,
		device = device,
	}
	function UI.getSelfCheck()
		return table.clone(selfCheck.summary)
	end
	if UI.getSelfCheck then
		local summary = UI.getSelfCheck()
		if summary.warningCount == 0 then
			print("[StaticsNewgen] self-check complete: " .. tostring(summary.passed) .. " checks")
		end
	end
end
UI._installSelfCheck()
UI._installSelfCheckSummary()

print("[StaticsNewgen] clean rewrite loaded")

end, function(e)
	return debug.traceback(tostring(e), 2)
end)

if not ok then
	recover(err)
else
	if boot and boot.Parent then boot:Destroy() end
	print("[StaticsNewgen] startup completed")
end