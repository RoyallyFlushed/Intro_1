

--[[
	Introduction Camera Manipulation
	
	- The main script to make the introduction work, note that this is a very
	busy script and small changes that were not coded for can affect the code
	
	(This script was made to work with Filtering Enabled should you desire to use it)
	
	
	24/jul/17
	Client2Server
--]]


local Wait = 250
local FOV = 70
local BlurIntensity = 12

---------------------------------------
------- Editable Settings Above -------
---------------------------------------



local cam = workspace.CurrentCamera
local RunService = game:GetService('RunService')
local character = script.Parent
local sound = Instance.new('Sound',character)
sound.SoundId = 'rbxassetid://444155495'
sound.Volume = 1
local HeadDirection = character.Head.CFrame.lookVector
local X,Y,Z,M = 0,.5,2,0.2



character.Humanoid.WalkSpeed = 0
cam.CameraType = Enum.CameraType.Attach

wait(1)

cam.CameraType = Enum.CameraType.Scriptable
cam.FieldOfView = FOV

local Blur = Instance.new('BlurEffect',game.Lighting)
Blur.Size = 0


function ChangeBlurIntensity(Blur, startVal, endVal, Increment)
	for Intensity = startVal, endVal, Increment do
		Blur.Size = Intensity
		wait(.1)
	end
end

function ChangeTransparency(Obj, startVal, endVal, Increment, Speed, TransparencyType)
	for transparency = startVal,endVal, Increment do
		if TransparencyType == 'bck' then
			Obj.BackgroundTransparency = transparency
		elseif TransparencyType == 'txt' then
			Obj.TextTransparency = transparency
		end
		wait(Speed)
	end
end

oTick = 0
function ZoomOut()
	oTick = oTick + 1
	cam.CameraSubject = character.Humanoid
	cam.CoordinateFrame = cam.CoordinateFrame - ((HeadDirection-Vector3.new(X,Y,Z))*M)
	if oTick >= Wait then
		RunService:UnbindFromRenderStep('ZoomOut')
		MoveOn()
	end
end

local iTick = 0
function ZoomIn()
	iTick = iTick + 1
	cam.CameraSubject = character.Humanoid
	cam.Focus = character.Head.CFrame
	cam.CFrame = cam.CFrame:lerp((character.Head.CFrame - (character.Head.CFrame.lookVector*10)+Vector3.new(0,3,0))*CFrame.fromAxisAngle(Vector3.new(1,0,0),math.rad(-16.97)), iTick/100)
	if iTick >= 50 then
		local UI = game.Players.LocalPlayer.PlayerGui.Introduction_UI
		RunService:UnbindFromRenderStep('ZoomIn')
		ChangeTransparency(UI.BlackFrame,1,0,-.1,.02,'bck')
		local newRoutine = coroutine.wrap(function() 
			ChangeBlurIntensity(Blur,BlurIntensity,0,-1) 
			for volume = 1,0, -.1 do
				wait(.05)
				sound.Volume = volume
				if sound.Volume == 0 then
					wait(.05)
					sound:Destroy()
				end
			end
		end)
		newRoutine() -- Added coroutine to make sure blur loop doesn't interfere with black frame loop
		cam.CameraType = Enum.CameraType.Custom
		cam.FieldOfView = 70
		cam.CameraSubject = character.Humanoid
		cam.Focus = character.Head.CFrame
		wait(.5)
		ChangeTransparency(UI.BlackFrame,0,1,.1,.02,'bck')
		UI:Destroy()
	end
end

RunService:BindToRenderStep('ZoomOut', Enum.RenderPriority.First.Value, ZoomOut)
character.Humanoid.WalkSpeed = 16
sound:Play()

function MoveOn()
	local CUI = script.Introduction_UI 
	CUI.Parent = game.Players.LocalPlayer.PlayerGui
	UI = game.Players.LocalPlayer.PlayerGui.Introduction_UI
	
	MasterFrame = UI.Frame
	SubFrame = MasterFrame.TextFrame
	
	ChangeBlurIntensity(Blur,0,BlurIntensity,1)
	for i,v in pairs(SubFrame:GetChildren()) do
		ChangeTransparency(v,1,0,-.1,.05,'txt')
		wait(.25)
	end
	wait(.5)
	
	MasterFrame.TextButton.Active = true
	MasterFrame.TextButton.Visible = true
	MasterFrame.TextButton.MouseButton1Click:connect(function()
		MasterFrame.TextButton.Active = false
		MasterFrame.TextButton.Visible = false
		for i,v in pairs(SubFrame:GetChildren()) do
			ChangeTransparency(v,0,1,.1,.01,'txt')
			wait(.1)
		end
		wait(.25)
		cam:Interpolate(cam.CoordinateFrame, character.Head.CFrame, 2)
		wait(.75) -- Must keep wait, Interpolation will not work otherwise
		RunService:BindToRenderStep('ZoomIn', Enum.RenderPriority.First.Value, ZoomIn)
	end)
end







