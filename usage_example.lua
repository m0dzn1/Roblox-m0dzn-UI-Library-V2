-- MODERN UI LIBRARY - USAGE EXAMPLE
-- This demonstrates how to use the modernized UI library

local Library = loadstring(game:HttpGet("YOUR_RAW_GITHUB_LINK_HERE"))()

-- Create window with custom configuration
local Window = Library.new({
	Title = "My Awesome Script",  -- Your script title replaces the logo
	Description = "v1.0 | Premium",
	Keybind = Enum.KeyCode.RightControl,  -- Toggle key
	Size = UDim2.new(0, 500, 0, 360),
	AccentColor = Color3.fromRGB(138, 43, 226)  -- Purple accent
})

-- Create tabs
local HomeTab = Window:CreateTab({
	Name = "Home",
	Icon = "home"
})

local CombatTab = Window:CreateTab({
	Name = "Combat",
	Icon = "sword"
})

local VisualsTab = Window:CreateTab({
	Name = "Visuals",
	Icon = "eye"
})

local SettingsTab = Window:CreateTab({
	Name = "Settings",
	Icon = "settings"
})

-- Add elements to Home tab
HomeTab:CreateLabel({
	Text = "Welcome to the modernized UI! Now with smooth drag physics and a cleaner design."
})

HomeTab:CreateButton({
	Name = "Click Me!",
	Callback = function()
		print("Button clicked!")
	end
})

HomeTab:CreateToggle({
	Name = "Auto Farm",
	Default = false,
	Callback = function(value)
		print("Auto Farm:", value)
	end
})

HomeTab:CreateSlider({
	Name = "Walk Speed",
	Min = 16,
	Max = 100,
	Default = 16,
	Increment = 1,
	Callback = function(value)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
	end
})

-- Add elements to Combat tab
CombatTab:CreateLabel({
	Text = "Combat Features"
})

CombatTab:CreateToggle({
	Name = "Aimbot",
	Default = false,
	Callback = function(value)
		print("Aimbot:", value)
	end
})

CombatTab:CreateToggle({
	Name = "Silent Aim",
	Default = false,
	Callback = function(value)
		print("Silent Aim:", value)
	end
})

CombatTab:CreateSlider({
	Name = "FOV Size",
	Min = 50,
	Max = 500,
	Default = 200,
	Increment = 10,
	Callback = function(value)
		print("FOV Size:", value)
	end
})

-- Add elements to Visuals tab
VisualsTab:CreateLabel({
	Text = "ESP & Visual Features"
})

VisualsTab:CreateToggle({
	Name = "Player ESP",
	Default = false,
	Callback = function(value)
		print("Player ESP:", value)
	end
})

VisualsTab:CreateToggle({
	Name = "Chams",
	Default = false,
	Callback = function(value)
		print("Chams:", value)
	end
})

VisualsTab:CreateToggle({
	Name = "Fullbright",
	Default = false,
	Callback = function(value)
		if value then
			game.Lighting.Brightness = 2
			game.Lighting.ClockTime = 14
			game.Lighting.FogEnd = 100000
		else
			game.Lighting.Brightness = 1
			game.Lighting.ClockTime = 12
			game.Lighting.FogEnd = 100000
		end
	end
})

-- Add elements to Settings tab
SettingsTab:CreateLabel({
	Text = "UI Configuration"
})

SettingsTab:CreateButton({
	Name = "Destroy UI",
	Callback = function()
		Window.Close()
	end
})

SettingsTab:CreateToggle({
	Name = "Rainbow Mode",
	Default = false,
	Callback = function(value)
		if value then
			spawn(function()
				while value do
					wait(0.1)
					-- Add rainbow effect logic here
				end
			end)
		end
	end
})

print("Modern UI loaded successfully!")
print("Press RightControl to toggle the UI")
