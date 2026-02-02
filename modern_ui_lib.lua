-- ICON: https://raw.githubusercontent.com/evoincorp/lucideblox/master/src/modules/util/icons.json

--[[ 
███╗   ███╗ ██████╗ ██████╗ ███████╗███╗   ██╗
████╗ ████║██╔═████╗██╔══██╗╚══███╔╝████╗  ██║
██╔████╔██║██║██╔██║██║  ██║  ███╔╝ ██╔██╗ ██║
██║╚██╔╝██║████╔╝██║██║  ██║ ███╔╝  ██║╚██╗██║
██║ ╚═╝ ██║╚██████╔╝██████╔╝███████╗██║ ╚████║
╚═╝     ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝
           M0DZN LIBRARY V2.0
]]

print([[
script loaded
 ███╗   ███╗  ██████╗  ██████╗  ███████╗ ███╗   ██╗
 ████╗ ████║ ██╔═████╗ ██╔══██╗ ╚══███╔╝ ████╗  ██║
 ██╔████╔██║ ██║██╔██║ ██║  ██║   ███╔╝  ██╔██╗ ██║
 ██║╚██╔╝██║ ████╔╝██║ ██║  ██║  ███╔╝   ██║╚██╗██║
 ██║ ╚═╝ ██║ ╚██████╔╝ ██████╔╝ ███████╗ ██║ ╚████║
 ╚═╝     ╚═╝  ╚═════╝  ╚═════╝  ╚══════╝ ╚═╝  ╚═══╝
               M0DZN LIBRARY V2.0
]])

local Twen = game:GetService('TweenService');
local Input = game:GetService('UserInputService');
local TextServ = game:GetService('TextService');
local LocalPlayer = game:GetService('Players').LocalPlayer;
local CoreGui = (gethui and gethui()) or game:FindFirstChild('CoreGui') or LocalPlayer.PlayerGui;
local RunService = game:GetService('RunService');

local Icons = (function()
	local p,c = pcall(function()
		local Http = game:HttpGetAsync('https://raw.githubusercontent.com/evoincorp/lucideblox/master/src/modules/util/icons.json');
		local Decode = game:GetService('HttpService'):JSONDecode(Http);
		return Decode['icon'];
	end);
	if p then return c end;
	return nil;
end)() or {};

local ElBlurSource = function()
	local GuiSystem = {}
	local RunService = game:GetService('RunService');
	local CurrentCamera = workspace.CurrentCamera;

	function GuiSystem:Hash()
		return string.reverse(string.gsub(game:GetService('HttpService'):GenerateGUID(false),'..',function(aa)
			return string.reverse(aa)
		end))
	end

	local function Hiter(planePos, planeNormal, rayOrigin, rayDirection)
		local n = planeNormal
		local d = rayDirection
		local v = rayOrigin - planePos

		local num = (n.x*v.x) + (n.y*v.y) + (n.z*v.z)
		local den = (n.x*d.x) + (n.y*d.y) + (n.z*d.z)
		local a = -num / den

		return rayOrigin + (a * rayDirection), a;
	end;

	function GuiSystem.new(frame,NoAutoBackground)
		local Part = Instance.new('Part',workspace);
		local DepthOfField = Instance.new('DepthOfFieldEffect',game:GetService('Lighting'));
		local SurfaceGui = Instance.new('SurfaceGui',Part);
		local BlockMesh = Instance.new("BlockMesh");

		BlockMesh.Parent = Part;

		Part.Material = Enum.Material.Glass;
		Part.Transparency = 1;
		Part.Reflectance = 1;
		Part.CastShadow = false;
		Part.Anchored = true;
		Part.CanCollide = false;
		Part.CanQuery = false;
		Part.CollisionGroup = GuiSystem:Hash();
		Part.Size = Vector3.new(1, 1, 1) * 0.01;
		Part.Color = Color3.fromRGB(0,0,0);

		Twen:Create(Part,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{
			Transparency = 0.8;
		}):Play()

		DepthOfField.Enabled = true;
		DepthOfField.FarIntensity = 1;
		DepthOfField.FocusDistance = 0;
		DepthOfField.InFocusRadius = 500;
		DepthOfField.NearIntensity = 1;

		SurfaceGui.AlwaysOnTop = true;
		SurfaceGui.Adornee = Part;
		SurfaceGui.Active = true;
		SurfaceGui.Face = Enum.NormalId.Front;
		SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;

		DepthOfField.Name = GuiSystem:Hash();
		Part.Name = GuiSystem:Hash();
		SurfaceGui.Name = GuiSystem:Hash();

		local C4 = {
			Update = nil,
			Collection = SurfaceGui,
			Enabled = true,
			Instances = {
				BlockMesh = BlockMesh,
				Part = Part,
				DepthOfField = DepthOfField,
				SurfaceGui = SurfaceGui,
			},
			Signal = nil
		};

		local Update = function()
			if not C4.Enabled then
				Twen:Create(Part,TweenInfo.new(1,Enum.EasingStyle.Quint),{
					Transparency = 1;
				}):Play()
			end;

			Twen:Create(Part,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
				Transparency = 0.8;
			}):Play()

			local corner0 = frame.AbsolutePosition;
			local corner1 = corner0 + frame.AbsoluteSize;

			local ray0 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner0.X, corner0.Y, 1);
			local ray1 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner1.X, corner1.Y, 1);

			local planeOrigin = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * (0.05 - CurrentCamera.NearPlaneZ);
			local planeNormal = CurrentCamera.CFrame.LookVector;

			local pos0 = Hiter(planeOrigin, planeNormal, ray0.Origin, ray0.Direction);
			local pos1 = Hiter(planeOrigin, planeNormal, ray1.Origin, ray1.Direction);

			pos0 = CurrentCamera.CFrame:PointToObjectSpace(pos0);
			pos1 = CurrentCamera.CFrame:PointToObjectSpace(pos1);

			local size   = pos1 - pos0;
			local center = (pos0 + pos1) / 2;

			BlockMesh.Offset = center
			BlockMesh.Scale  = size / 0.0101;
			Part.CFrame = CurrentCamera.CFrame;

			if not NoAutoBackground then
				local _,updatec = pcall(function()
					local userSettings = UserSettings():GetService("UserGameSettings")
					local qualityLevel = userSettings.SavedQualityLevel.Value

					if qualityLevel < 8 then
						Twen:Create(frame,TweenInfo.new(1),{
							BackgroundTransparency = 0
						}):Play()
					else
						Twen:Create(frame,TweenInfo.new(1),{
							BackgroundTransparency = 0.4
						}):Play()
					end;
				end)
			end
		end

		C4.Update = Update;
		C4.Signal = RunService.RenderStepped:Connect(Update);

		pcall(function()
			C4.Signal2 = CurrentCamera:GetPropertyChangedSignal('CFrame'):Connect(function()
				Part.CFrame = CurrentCamera.CFrame;
			end);
		end)

		C4.Destroy = function()
			C4.Signal:Disconnect();
			C4.Signal2:Disconnect();
			C4.Update = function() end;

			Twen:Create(Part,TweenInfo.new(1),{
				Transparency = 1
			}):Play();

			DepthOfField:Destroy();
			Part:Destroy()
		end;

		return C4;
	end;

	return GuiSystem
end;

local ElBlurSource = ElBlurSource();

local Config = function(data,default)
	data = data or {};
	for i,v in next,default do
		data[i] = data[i] or v;
	end;
	return data;
end;

local Library = {};

Library['.'] = '2.0';
Library['FetchIcon'] = "https://raw.githubusercontent.com/evoincorp/lucideblox/master/src/modules/util/icons.json";

pcall(function()
	Library['Icons'] = game:GetService('HttpService'):JSONDecode(game:HttpGetAsync(Library.FetchIcon))['icons'];
end)

-- Modern smooth drag system with momentum and spring physics
local function CreateModernDrag(frame)
	local dragToggle = false;
	local dragInput, dragStart, startPos;
	local velocity = Vector2.new(0, 0);
	local lastPosition = Vector2.new(0, 0);
	local lastUpdateTime = tick();
	
	-- Spring physics parameters for smooth feel
	local springStrength = 0.15;
	local dampening = 0.85;
	local momentumDecay = 0.92;
	
	local function updateDrag(input)
		local delta = input.Position - dragStart;
		local targetPos = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		);
		
		-- Smooth spring-based movement
		Twen:Create(frame, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Position = targetPos
		}):Play();
		
		-- Calculate velocity for momentum
		local currentTime = tick();
		local deltaTime = currentTime - lastUpdateTime;
		if deltaTime > 0 then
			local currentPosition = Vector2.new(delta.X, delta.Y);
			velocity = (currentPosition - lastPosition) / deltaTime;
			lastPosition = currentPosition;
			lastUpdateTime = currentTime;
		end
	end
	
	-- Apply momentum when drag ends
	local function applyMomentum()
		if velocity.Magnitude > 5 then
			local momentumVelocity = velocity;
			local currentPos = frame.Position;
			
			-- Animate momentum decay
			task.spawn(function()
				for i = 1, 30 do
					if dragToggle then break end -- Stop if dragging again
					
					momentumVelocity = momentumVelocity * momentumDecay;
					
					if momentumVelocity.Magnitude < 1 then break end
					
					local newPos = UDim2.new(
						currentPos.X.Scale, currentPos.X.Offset + momentumVelocity.X * 0.016,
						currentPos.Y.Scale, currentPos.Y.Offset + momentumVelocity.Y * 0.016
					);
					
					currentPos = newPos;
					Twen:Create(frame, TweenInfo.new(0.016, Enum.EasingStyle.Linear), {
						Position = newPos
					}):Play();
					
					task.wait(0.016);
				end
			end)
		end
	end
	
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragToggle = true;
			dragStart = input.Position;
			startPos = frame.Position;
			lastPosition = Vector2.new(0, 0);
			lastUpdateTime = tick();
			velocity = Vector2.new(0, 0);
			
			-- Scale effect on grab
			Twen:Create(frame, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = frame.Size - UDim2.new(0, 2, 0, 2)
			}):Play();
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false;
					
					-- Return to normal size
					Twen:Create(frame, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Size = frame.Size + UDim2.new(0, 2, 0, 2)
					}):Play();
					
					-- Apply momentum
					applyMomentum();
				end
			end)
		end
	end)
	
	Input.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input;
			if dragToggle then
				updateDrag(input);
			end
		end
	end)
end

function Library.GradientImage(E : Frame , Color)
	local GLImage = Instance.new("ImageLabel")
	local upd = tick();
	local nextU , Speed , speedy , SIZ = 4 , 5 , -5 , 0.8;
	local nextmain = UDim2.new();
	local rng = Random.new(math.random(10,100000) + math.random(100, 1000) + math.sqrt(tick()));
	local int = 1;
	local TPL = 0.55;

	GLImage.Name = "GLImage"
	GLImage.Parent = E
	GLImage.AnchorPoint = Vector2.new(0.5, 0.5)
	GLImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GLImage.BackgroundTransparency = 1.000
	GLImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
	GLImage.BorderSizePixel = 0
	GLImage.Position = UDim2.new(0.5, 0, 0.5, 0)
	GLImage.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
	GLImage.SizeConstraint = Enum.SizeConstraint.RelativeYY
	GLImage.ZIndex = E.ZIndex - 1;
	GLImage.Image = "rbxassetid://867619398"
	GLImage.ImageColor3 = Color or Color3.fromRGB(0, 195, 255)
	GLImage.ImageTransparency = 1;

	local str = 'GL_EFFECT_'..tostring(tick());
	game:GetService('RunService'):BindToRenderStep(str,45,function()
		if (tick() - upd) > nextU then
			nextU = rng:NextNumber(1.1,2.5)
			Speed = rng:NextNumber(-6,6)
			speedy = rng:NextNumber(-6,6)
			TPL = rng:NextNumber(0.2,0.8)
			SIZ = rng:NextNumber(0.6,0.9);
			upd = tick();
			int = 1
		else
			speedy = speedy + rng:NextNumber(-0.1,0.1);
			Speed = Speed + rng:NextNumber(-0.1,0.1);
		end;

		nextmain = nextmain:Lerp(UDim2.new(0.5 + (Speed / 24),0,0.5 + (speedy / 24),0) , .025)
		int = int + 0.1

		Twen:Create(GLImage,TweenInfo.new(1),{
			Rotation = GLImage.Rotation + Speed,
			Position = nextmain,
			Size = UDim2.fromScale(SIZ,SIZ),
			ImageTransparency = TPL
		}):Play()
	end)

	return str
end;

function Library.new(config)
	config = Config(config,{
		Title = "Modern UI",
		Description = "Enhanced Experience",
		Keybind = Enum.KeyCode.LeftControl,
		Size = UDim2.new(0, 480, 0, 340),
		AccentColor = Color3.fromRGB(88, 101, 242) -- Discord-like purple
	});

	local TweenInfo1 = TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.Out);
	local TweenInfo2 = TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out);

	local WindowTable = {};
	
	-- Create main UI structure
	local ScreenGui = Instance.new("ScreenGui")
	local MainFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local MainDropShadow = Instance.new("ImageLabel")
	local Headers = Instance.new("Frame")
	local TitleContainer = Instance.new("Frame")
	local Title = Instance.new("TextLabel")
	local UIGradient = Instance.new("UIGradient")
	local Description = Instance.new("TextLabel")
	local UIGradient_2 = Instance.new("UIGradient")
	local BlockFrame1 = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	local UIGradient_3 = Instance.new("UIGradient")
	local BlockFrame2 = Instance.new("Frame")
	local UICorner_4 = Instance.new("UICorner")
	local UIGradient_4 = Instance.new("UIGradient")
	local Glow = Instance.new("ImageLabel")
	local MinimizeButton = Instance.new("TextButton")
	local UICorner_5 = Instance.new("UICorner")
	local CloseButton = Instance.new("TextButton")
	local UICorner_6 = Instance.new("UICorner")
	local ContentFrame = Instance.new("Frame")
	local UICorner_7 = Instance.new("UICorner")
	local TabsFrame = Instance.new("Frame")
	local UICorner_8 = Instance.new("UICorner")
	local UIListLayout = Instance.new("UIListLayout")
	local UIPadding = Instance.new("UIPadding")
	local Sections = Instance.new("Frame")
	local UICorner_9 = Instance.new("UICorner")
	local UIPageLayout = Instance.new("UIPageLayout")

	-- Properties
	ScreenGui.Name = "ModernUI_"..tostring(tick())
	ScreenGui.Parent = CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false

	MainFrame.Name = "MainFrame"
	MainFrame.Parent = ScreenGui
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.Size = config.Size
	MainFrame.ClipsDescendants = true

	UICorner.CornerRadius = UDim.new(0, 12)
	UICorner.Parent = MainFrame

	-- Enhanced drop shadow
	MainDropShadow.Name = "MainDropShadow"
	MainDropShadow.Parent = MainFrame
	MainDropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	MainDropShadow.BackgroundTransparency = 1
	MainDropShadow.BorderSizePixel = 0
	MainDropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainDropShadow.Size = UDim2.new(1, 40, 1, 40)
	MainDropShadow.ZIndex = 0
	MainDropShadow.Image = "rbxassetid://5554236805"
	MainDropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	MainDropShadow.ImageTransparency = 0.3
	MainDropShadow.ScaleType = Enum.ScaleType.Slice
	MainDropShadow.SliceCenter = Rect.new(23, 23, 277, 277)

	-- Header with modern title design
	Headers.Name = "Headers"
	Headers.Parent = MainFrame
	Headers.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
	Headers.BorderSizePixel = 0
	Headers.Size = UDim2.new(1, 0, 0, 55)
	Headers.ZIndex = 2

	local HeaderCorner = Instance.new("UICorner")
	HeaderCorner.CornerRadius = UDim.new(0, 12)
	HeaderCorner.Parent = Headers

	local HeaderCoverBottom = Instance.new("Frame")
	HeaderCoverBottom.Parent = Headers
	HeaderCoverBottom.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
	HeaderCoverBottom.BorderSizePixel = 0
	HeaderCoverBottom.Position = UDim2.new(0, 0, 0.7, 0)
	HeaderCoverBottom.Size = UDim2.new(1, 0, 0.3, 0)
	HeaderCoverBottom.ZIndex = 2

	-- Title Container (replaces logo)
	TitleContainer.Name = "TitleContainer"
	TitleContainer.Parent = Headers
	TitleContainer.BackgroundTransparency = 1
	TitleContainer.Position = UDim2.new(0, 15, 0, 8)
	TitleContainer.Size = UDim2.new(0.6, 0, 1, -16)
	TitleContainer.ZIndex = 3

	Title.Name = "Title"
	Title.Parent = TitleContainer
	Title.BackgroundTransparency = 1
	Title.Size = UDim2.new(1, 0, 0.5, 0)
	Title.ZIndex = 3
	Title.Font = Enum.Font.GothamBold
	Title.Text = config.Title
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 20
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.RichText = true

	UIGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, config.AccentColor)
	}
	UIGradient.Rotation = 0
	UIGradient.Parent = Title

	Description.Name = "Description"
	Description.Parent = TitleContainer
	Description.BackgroundTransparency = 1
	Description.Position = UDim2.new(0, 0, 0.5, 0)
	Description.Size = UDim2.new(1, 0, 0.5, 0)
	Description.ZIndex = 3
	Description.Font = Enum.Font.Gotham
	Description.Text = config.Description
	Description.TextColor3 = Color3.fromRGB(150, 150, 160)
	Description.TextSize = 12
	Description.TextXAlignment = Enum.TextXAlignment.Left
	Description.TextTransparency = 0.3

	-- Accent blocks (modern design elements)
	BlockFrame1.Name = "BlockFrame1"
	BlockFrame1.Parent = Headers
	BlockFrame1.AnchorPoint = Vector2.new(1, 0)
	BlockFrame1.BackgroundColor3 = config.AccentColor
	BlockFrame1.BorderSizePixel = 0
	BlockFrame1.Position = UDim2.new(1, -90, 0, 12)
	BlockFrame1.Size = UDim2.new(0, 3, 0, 31)
	BlockFrame1.ZIndex = 3

	UICorner_3.CornerRadius = UDim.new(1, 0)
	UICorner_3.Parent = BlockFrame1

	UIGradient_3.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, config.AccentColor),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(config.AccentColor.R * 255 * 0.7, config.AccentColor.G * 255 * 0.7, config.AccentColor.B * 255 * 0.7))
	}
	UIGradient_3.Rotation = 90
	UIGradient_3.Parent = BlockFrame1

	BlockFrame2.Name = "BlockFrame2"
	BlockFrame2.Parent = Headers
	BlockFrame2.AnchorPoint = Vector2.new(1, 0)
	BlockFrame2.BackgroundColor3 = config.AccentColor
	BlockFrame2.BorderSizePixel = 0
	BlockFrame2.Position = UDim2.new(1, -100, 0, 16)
	BlockFrame2.Size = UDim2.new(0, 2, 0, 23)
	BlockFrame2.ZIndex = 3
	BlockFrame2.BackgroundTransparency = 0.4

	UICorner_4.CornerRadius = UDim.new(1, 0)
	UICorner_4.Parent = BlockFrame2

	-- Glow effect
	Glow.Name = "Glow"
	Glow.Parent = Headers
	Glow.BackgroundTransparency = 1
	Glow.Position = UDim2.new(0, 0, 0, 0)
	Glow.Size = UDim2.new(1, 0, 1, 20)
	Glow.ZIndex = 1
	Glow.Image = "rbxassetid://4996891970"
	Glow.ImageColor3 = config.AccentColor
	Glow.ImageTransparency = 0.8
	Glow.ScaleType = Enum.ScaleType.Slice
	Glow.SliceCenter = Rect.new(128, 128, 128, 128)

	-- Window controls
	MinimizeButton.Name = "MinimizeButton"
	MinimizeButton.Parent = Headers
	MinimizeButton.AnchorPoint = Vector2.new(1, 0.5)
	MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	MinimizeButton.BorderSizePixel = 0
	MinimizeButton.Position = UDim2.new(1, -45, 0.5, 0)
	MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
	MinimizeButton.ZIndex = 4
	MinimizeButton.Font = Enum.Font.GothamBold
	MinimizeButton.Text = "−"
	MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
	MinimizeButton.TextSize = 18
	MinimizeButton.AutoButtonColor = false

	UICorner_5.CornerRadius = UDim.new(0, 6)
	UICorner_5.Parent = MinimizeButton

	CloseButton.Name = "CloseButton"
	CloseButton.Parent = Headers
	CloseButton.AnchorPoint = Vector2.new(1, 0.5)
	CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	CloseButton.BorderSizePixel = 0
	CloseButton.Position = UDim2.new(1, -12, 0.5, 0)
	CloseButton.Size = UDim2.new(0, 28, 0, 28)
	CloseButton.ZIndex = 4
	CloseButton.Font = Enum.Font.GothamBold
	CloseButton.Text = "×"
	CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
	CloseButton.TextSize = 20
	CloseButton.AutoButtonColor = false

	UICorner_6.CornerRadius = UDim.new(0, 6)
	UICorner_6.Parent = CloseButton

	-- Button hover effects
	local function setupButtonHover(button, hoverColor, clickColor)
		local originalColor = button.BackgroundColor3
		
		button.MouseEnter:Connect(function()
			Twen:Create(button, TweenInfo.new(0.15), {
				BackgroundColor3 = hoverColor or Color3.fromRGB(55, 55, 65)
			}):Play()
		end)
		
		button.MouseLeave:Connect(function()
			Twen:Create(button, TweenInfo.new(0.15), {
				BackgroundColor3 = originalColor
			}):Play()
		end)
		
		button.MouseButton1Down:Connect(function()
			Twen:Create(button, TweenInfo.new(0.05), {
				BackgroundColor3 = clickColor or Color3.fromRGB(65, 65, 75),
				Size = button.Size - UDim2.new(0, 2, 0, 2)
			}):Play()
		end)
		
		button.MouseButton1Up:Connect(function()
			Twen:Create(button, TweenInfo.new(0.1), {
				Size = button.Size + UDim2.new(0, 2, 0, 2)
			}):Play()
		end)
	end

	setupButtonHover(MinimizeButton)
	setupButtonHover(CloseButton, Color3.fromRGB(220, 60, 60), Color3.fromRGB(180, 40, 40))

	-- Content area
	ContentFrame.Name = "ContentFrame"
	ContentFrame.Parent = MainFrame
	ContentFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
	ContentFrame.BorderSizePixel = 0
	ContentFrame.Position = UDim2.new(0, 8, 0, 63)
	ContentFrame.Size = UDim2.new(1, -16, 1, -71)
	ContentFrame.ZIndex = 2

	UICorner_7.CornerRadius = UDim.new(0, 8)
	UICorner_7.Parent = ContentFrame

	-- Tabs sidebar
	TabsFrame.Name = "TabsFrame"
	TabsFrame.Parent = ContentFrame
	TabsFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
	TabsFrame.BorderSizePixel = 0
	TabsFrame.Size = UDim2.new(0, 140, 1, 0)
	TabsFrame.ZIndex = 3

	UICorner_8.CornerRadius = UDim.new(0, 8)
	UICorner_8.Parent = TabsFrame

	UIListLayout.Parent = TabsFrame
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 4)

	UIPadding.Parent = TabsFrame
	UIPadding.PaddingBottom = UDim.new(0, 8)
	UIPadding.PaddingLeft = UDim.new(0, 8)
	UIPadding.PaddingRight = UDim.new(0, 8)
	UIPadding.PaddingTop = UDim.new(0, 8)

	-- Sections area
	Sections.Name = "Sections"
	Sections.Parent = ContentFrame
	Sections.BackgroundTransparency = 1
	Sections.Position = UDim2.new(0, 148, 0, 8)
	Sections.Size = UDim2.new(1, -156, 1, -16)
	Sections.ZIndex = 3

	UIPageLayout.Parent = Sections
	UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIPageLayout.EasingDirection = Enum.EasingDirection.Out
	UIPageLayout.EasingStyle = Enum.EasingStyle.Quint
	UIPageLayout.Padding = UDim.new(0, 10)
	UIPageLayout.TweenTime = 0.4

	-- Apply modern drag system
	CreateModernDrag(MainFrame)

	-- Window functions
	WindowTable.Minimize = function()
		WindowTable.Minimized = not WindowTable.Minimized
		local targetSize = WindowTable.Minimized and UDim2.new(config.Size.X.Scale, config.Size.X.Offset, 0, 55) or config.Size
		
		Twen:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
			Size = targetSize
		}):Play()
		
		MinimizeButton.Text = WindowTable.Minimized and "+" or "−"
	end

	WindowTable.Close = function()
		Twen:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0)
		}):Play()
		
		task.wait(0.3)
		ScreenGui:Destroy()
	end

	WindowTable.Toggle = function()
		ScreenGui.Enabled = not ScreenGui.Enabled
	end

	MinimizeButton.MouseButton1Click:Connect(WindowTable.Minimize)
	CloseButton.MouseButton1Click:Connect(WindowTable.Close)

	-- Keybind toggle
	Input.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed and input.KeyCode == config.Keybind then
			WindowTable.Toggle()
		end
	end)

	WindowTable.Minimized = false
	WindowTable.MainFrame = MainFrame
	WindowTable.Sections = Sections
	WindowTable.TabsFrame = TabsFrame
	WindowTable.UIPageLayout = UIPageLayout
	WindowTable.ScreenGui = ScreenGui
	WindowTable.AccentColor = config.AccentColor

	-- Entrance animation
	MainFrame.Size = UDim2.new(0, 0, 0, 0)
	Twen:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = config.Size
	}):Play()

	-- Tab creation function
	function WindowTable:CreateTab(tabConfig)
		tabConfig = Config(tabConfig, {
			Name = "Tab",
			Icon = "home"
		})

		local TabButton = Instance.new("TextButton")
		local TabIcon = Instance.new("ImageLabel")
		local TabLabel = Instance.new("TextLabel")
		local TabCorner = Instance.new("UICorner")
		local TabPage = Instance.new("ScrollingFrame")
		local TabPageLayout = Instance.new("UIListLayout")
		local TabPagePadding = Instance.new("UIPadding")

		-- Tab button
		TabButton.Name = tabConfig.Name
		TabButton.Parent = self.TabsFrame
		TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(1, 0, 0, 36)
		TabButton.AutoButtonColor = false
		TabButton.Font = Enum.Font.Gotham
		TabButton.Text = ""
		TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
		TabButton.TextSize = 14
		TabButton.ZIndex = 4

		TabCorner.CornerRadius = UDim.new(0, 6)
		TabCorner.Parent = TabButton

		-- Tab icon
		TabIcon.Name = "Icon"
		TabIcon.Parent = TabButton
		TabIcon.BackgroundTransparency = 1
		TabIcon.Position = UDim2.new(0, 8, 0.5, 0)
		TabIcon.AnchorPoint = Vector2.new(0, 0.5)
		TabIcon.Size = UDim2.new(0, 18, 0, 18)
		TabIcon.Image = Icons[tabConfig.Icon] or "rbxassetid://10734950309"
		TabIcon.ImageColor3 = Color3.fromRGB(150, 150, 160)
		TabIcon.ZIndex = 5

		-- Tab label
		TabLabel.Name = "Label"
		TabLabel.Parent = TabButton
		TabLabel.BackgroundTransparency = 1
		TabLabel.Position = UDim2.new(0, 32, 0, 0)
		TabLabel.Size = UDim2.new(1, -32, 1, 0)
		TabLabel.Font = Enum.Font.GothamMedium
		TabLabel.Text = tabConfig.Name
		TabLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
		TabLabel.TextSize = 13
		TabLabel.TextXAlignment = Enum.TextXAlignment.Left
		TabLabel.ZIndex = 5

		-- Tab page
		TabPage.Name = tabConfig.Name.."Page"
		TabPage.Parent = self.Sections
		TabPage.BackgroundTransparency = 1
		TabPage.BorderSizePixel = 0
		TabPage.Size = UDim2.new(1, 0, 1, 0)
		TabPage.ScrollBarThickness = 4
		TabPage.ScrollBarImageColor3 = self.AccentColor
		TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
		TabPage.ZIndex = 3

		TabPageLayout.Parent = TabPage
		TabPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		TabPageLayout.Padding = UDim.new(0, 8)

		TabPagePadding.Parent = TabPage
		TabPagePadding.PaddingBottom = UDim.new(0, 8)
		TabPagePadding.PaddingLeft = UDim.new(0, 8)
		TabPagePadding.PaddingRight = UDim.new(0, 8)
		TabPagePadding.PaddingTop = UDim.new(0, 8)

		-- Tab switching logic
		local isSelected = false
		
		local function selectTab()
			-- Deselect all tabs
			for _, tab in ipairs(self.TabsFrame:GetChildren()) do
				if tab:IsA("TextButton") then
					Twen:Create(tab, TweenInfo2, {
						BackgroundColor3 = Color3.fromRGB(30, 30, 38)
					}):Play()
					if tab:FindFirstChild("Label") then
						Twen:Create(tab.Label, TweenInfo2, {
							TextColor3 = Color3.fromRGB(180, 180, 190)
						}):Play()
					end
					if tab:FindFirstChild("Icon") then
						Twen:Create(tab.Icon, TweenInfo2, {
							ImageColor3 = Color3.fromRGB(150, 150, 160)
						}):Play()
					end
				end
			end
			
			-- Select this tab
			Twen:Create(TabButton, TweenInfo2, {
				BackgroundColor3 = self.AccentColor
			}):Play()
			Twen:Create(TabLabel, TweenInfo2, {
				TextColor3 = Color3.fromRGB(255, 255, 255)
			}):Play()
			Twen:Create(TabIcon, TweenInfo2, {
				ImageColor3 = Color3.fromRGB(255, 255, 255)
			}):Play()
			
			-- Switch page
			self.UIPageLayout:JumpTo(TabPage)
			isSelected = true
		end

		TabButton.MouseButton1Click:Connect(selectTab)
		
		-- Hover effect
		TabButton.MouseEnter:Connect(function()
			if not isSelected then
				Twen:Create(TabButton, TweenInfo.new(0.15), {
					BackgroundColor3 = Color3.fromRGB(40, 40, 48)
				}):Play()
			end
		end)
		
		TabButton.MouseLeave:Connect(function()
			if not isSelected then
				Twen:Create(TabButton, TweenInfo.new(0.15), {
					BackgroundColor3 = Color3.fromRGB(30, 30, 38)
				}):Play()
			end
		end)

		-- Select first tab by default
		if #self.TabsFrame:GetChildren() == 2 then -- UIListLayout + UIPadding + first tab = 3 total
			selectTab()
		end

		local TabTable = {
			Button = TabButton,
			Page = TabPage,
			Selected = isSelected
		}

		-- Element creation functions
		function TabTable:CreateButton(config)
			config = Config(config, {
				Name = "Button",
				Callback = function() end
			})

			local Button = Instance.new("TextButton")
			local ButtonCorner = Instance.new("UICorner")
			local ButtonLabel = Instance.new("TextLabel")

			Button.Name = config.Name
			Button.Parent = TabPage
			Button.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
			Button.BorderSizePixel = 0
			Button.Size = UDim2.new(1, 0, 0, 36)
			Button.AutoButtonColor = false
			Button.Font = Enum.Font.Gotham
			Button.Text = ""
			Button.ZIndex = 4

			ButtonCorner.CornerRadius = UDim.new(0, 6)
			ButtonCorner.Parent = Button

			ButtonLabel.Name = "Label"
			ButtonLabel.Parent = Button
			ButtonLabel.BackgroundTransparency = 1
			ButtonLabel.Size = UDim2.new(1, -16, 1, 0)
			ButtonLabel.Position = UDim2.new(0, 12, 0, 0)
			ButtonLabel.Font = Enum.Font.GothamMedium
			ButtonLabel.Text = config.Name
			ButtonLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
			ButtonLabel.TextSize = 13
			ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
			ButtonLabel.ZIndex = 5

			Button.MouseButton1Click:Connect(function()
				Twen:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Back), {
					Size = UDim2.new(1, -4, 0, 34)
				}):Play()
				task.wait(0.1)
				Twen:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Back), {
					Size = UDim2.new(1, 0, 0, 36)
				}):Play()
				
				pcall(config.Callback)
			end)

			Button.MouseEnter:Connect(function()
				Twen:Create(Button, TweenInfo.new(0.15), {
					BackgroundColor3 = WindowTable.AccentColor
				}):Play()
				Twen:Create(ButtonLabel, TweenInfo.new(0.15), {
					TextColor3 = Color3.fromRGB(255, 255, 255)
				}):Play()
			end)

			Button.MouseLeave:Connect(function()
				Twen:Create(Button, TweenInfo.new(0.15), {
					BackgroundColor3 = Color3.fromRGB(30, 30, 38)
				}):Play()
				Twen:Create(ButtonLabel, TweenInfo.new(0.15), {
					TextColor3 = Color3.fromRGB(200, 200, 200)
				}):Play()
			end)

			return {
				Button = Button,
				SetText = function(text)
					ButtonLabel.Text = text
				end
			}
		end

		function TabTable:CreateToggle(config)
			config = Config(config, {
				Name = "Toggle",
				Default = false,
				Callback = function() end
			})

			local Toggle = Instance.new("Frame")
			local ToggleCorner = Instance.new("UICorner")
			local ToggleLabel = Instance.new("TextLabel")
			local ToggleButton = Instance.new("TextButton")
			local ToggleButtonCorner = Instance.new("UICorner")
			local ToggleIndicator = Instance.new("Frame")
			local IndicatorCorner = Instance.new("UICorner")

			Toggle.Name = config.Name
			Toggle.Parent = TabPage
			Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
			Toggle.BorderSizePixel = 0
			Toggle.Size = UDim2.new(1, 0, 0, 36)
			Toggle.ZIndex = 4

			ToggleCorner.CornerRadius = UDim.new(0, 6)
			ToggleCorner.Parent = Toggle

			ToggleLabel.Name = "Label"
			ToggleLabel.Parent = Toggle
			ToggleLabel.BackgroundTransparency = 1
			ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
			ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
			ToggleLabel.Font = Enum.Font.GothamMedium
			ToggleLabel.Text = config.Name
			ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
			ToggleLabel.TextSize = 13
			ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
			ToggleLabel.ZIndex = 5

			ToggleButton.Name = "ToggleButton"
			ToggleButton.Parent = Toggle
			ToggleButton.AnchorPoint = Vector2.new(1, 0.5)
			ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
			ToggleButton.Position = UDim2.new(1, -12, 0.5, 0)
			ToggleButton.Size = UDim2.new(0, 42, 0, 20)
			ToggleButton.AutoButtonColor = false
			ToggleButton.Text = ""
			ToggleButton.ZIndex = 5

			ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
			ToggleButtonCorner.Parent = ToggleButton

			ToggleIndicator.Name = "Indicator"
			ToggleIndicator.Parent = ToggleButton
			ToggleIndicator.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
			ToggleIndicator.Position = UDim2.new(0, 2, 0.5, 0)
			ToggleIndicator.AnchorPoint = Vector2.new(0, 0.5)
			ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
			ToggleIndicator.ZIndex = 6

			IndicatorCorner.CornerRadius = UDim.new(1, 0)
			IndicatorCorner.Parent = ToggleIndicator

			local toggled = config.Default

			local function updateToggle()
				if toggled then
					Twen:Create(ToggleButton, TweenInfo2, {
						BackgroundColor3 = WindowTable.AccentColor
					}):Play()
					Twen:Create(ToggleIndicator, TweenInfo2, {
						Position = UDim2.new(1, -2, 0.5, 0),
						AnchorPoint = Vector2.new(1, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					}):Play()
				else
					Twen:Create(ToggleButton, TweenInfo2, {
						BackgroundColor3 = Color3.fromRGB(40, 40, 48)
					}):Play()
					Twen:Create(ToggleIndicator, TweenInfo2, {
						Position = UDim2.new(0, 2, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundColor3 = Color3.fromRGB(60, 60, 70)
					}):Play()
				end
			end

			updateToggle()

			ToggleButton.MouseButton1Click:Connect(function()
				toggled = not toggled
				updateToggle()
				pcall(config.Callback, toggled)
			end)

			return {
				Frame = Toggle,
				SetValue = function(value)
					toggled = value
					updateToggle()
				end,
				GetValue = function()
					return toggled
				end
			}
		end

		function TabTable:CreateSlider(config)
			config = Config(config, {
				Name = "Slider",
				Min = 0,
				Max = 100,
				Default = 50,
				Increment = 1,
				Callback = function() end
			})

			local Slider = Instance.new("Frame")
			local SliderCorner = Instance.new("UICorner")
			local SliderLabel = Instance.new("TextLabel")
			local SliderValue = Instance.new("TextLabel")
			local SliderBar = Instance.new("Frame")
			local SliderBarCorner = Instance.new("UICorner")
			local SliderFill = Instance.new("Frame")
			local SliderFillCorner = Instance.new("UICorner")
			local SliderButton = Instance.new("TextButton")

			Slider.Name = config.Name
			Slider.Parent = TabPage
			Slider.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
			Slider.BorderSizePixel = 0
			Slider.Size = UDim2.new(1, 0, 0, 50)
			Slider.ZIndex = 4

			SliderCorner.CornerRadius = UDim.new(0, 6)
			SliderCorner.Parent = Slider

			SliderLabel.Name = "Label"
			SliderLabel.Parent = Slider
			SliderLabel.BackgroundTransparency = 1
			SliderLabel.Size = UDim2.new(1, -60, 0, 20)
			SliderLabel.Position = UDim2.new(0, 12, 0, 6)
			SliderLabel.Font = Enum.Font.GothamMedium
			SliderLabel.Text = config.Name
			SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
			SliderLabel.TextSize = 13
			SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
			SliderLabel.ZIndex = 5

			SliderValue.Name = "Value"
			SliderValue.Parent = Slider
			SliderValue.BackgroundTransparency = 1
			SliderValue.AnchorPoint = Vector2.new(1, 0)
			SliderValue.Size = UDim2.new(0, 50, 0, 20)
			SliderValue.Position = UDim2.new(1, -12, 0, 6)
			SliderValue.Font = Enum.Font.GothamBold
			SliderValue.Text = tostring(config.Default)
			SliderValue.TextColor3 = WindowTable.AccentColor
			SliderValue.TextSize = 13
			SliderValue.TextXAlignment = Enum.TextXAlignment.Right
			SliderValue.ZIndex = 5

			SliderBar.Name = "Bar"
			SliderBar.Parent = Slider
			SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
			SliderBar.Position = UDim2.new(0, 12, 0, 30)
			SliderBar.Size = UDim2.new(1, -24, 0, 6)
			SliderBar.ZIndex = 5

			SliderBarCorner.CornerRadius = UDim.new(1, 0)
			SliderBarCorner.Parent = SliderBar

			SliderFill.Name = "Fill"
			SliderFill.Parent = SliderBar
			SliderFill.BackgroundColor3 = WindowTable.AccentColor
			SliderFill.Size = UDim2.new(0, 0, 1, 0)
			SliderFill.ZIndex = 6

			SliderFillCorner.CornerRadius = UDim.new(1, 0)
			SliderFillCorner.Parent = SliderFill

			SliderButton.Name = "SliderButton"
			SliderButton.Parent = SliderBar
			SliderButton.BackgroundTransparency = 1
			SliderButton.Size = UDim2.new(1, 0, 1, 0)
			SliderButton.Text = ""
			SliderButton.ZIndex = 7

			local value = config.Default
			local dragging = false

			local function updateSlider()
				local percent = (value - config.Min) / (config.Max - config.Min)
				Twen:Create(SliderFill, TweenInfo.new(0.1), {
					Size = UDim2.new(percent, 0, 1, 0)
				}):Play()
				SliderValue.Text = tostring(value)
			end

			local function setSliderValue(input)
				local percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
				value = math.floor((config.Min + (config.Max - config.Min) * percent) / config.Increment + 0.5) * config.Increment
				value = math.clamp(value, config.Min, config.Max)
				updateSlider()
				pcall(config.Callback, value)
			end

			updateSlider()

			SliderButton.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					setSliderValue(input)
				end
			end)

			SliderButton.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)

			Input.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					setSliderValue(input)
				end
			end)

			return {
				Frame = Slider,
				SetValue = function(newValue)
					value = math.clamp(newValue, config.Min, config.Max)
					updateSlider()
				end,
				GetValue = function()
					return value
				end
			}
		end

		function TabTable:CreateLabel(config)
			config = Config(config, {
				Text = "Label"
			})

			local Label = Instance.new("Frame")
			local LabelCorner = Instance.new("UICorner")
			local LabelText = Instance.new("TextLabel")

			Label.Name = "Label"
			Label.Parent = TabPage
			Label.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
			Label.BorderSizePixel = 0
			Label.Size = UDim2.new(1, 0, 0, 32)
			Label.ZIndex = 4

			LabelCorner.CornerRadius = UDim.new(0, 6)
			LabelCorner.Parent = Label

			LabelText.Name = "Text"
			LabelText.Parent = Label
			LabelText.BackgroundTransparency = 1
			LabelText.Size = UDim2.new(1, -24, 1, 0)
			LabelText.Position = UDim2.new(0, 12, 0, 0)
			LabelText.Font = Enum.Font.Gotham
			LabelText.Text = config.Text
			LabelText.TextColor3 = Color3.fromRGB(180, 180, 190)
			LabelText.TextSize = 12
			LabelText.TextXAlignment = Enum.TextXAlignment.Left
			LabelText.TextWrapped = true
			LabelText.ZIndex = 5

			return {
				Frame = Label,
				SetText = function(text)
					LabelText.Text = text
				end
			}
		end

		return TabTable
	end

	return setmetatable(WindowTable, {
		__index = function(self, key)
			return rawget(self, key)
		end
	})
end

print('[ OK ]: Modern UI Library Loaded v2.0')

return table.freeze(Library);
