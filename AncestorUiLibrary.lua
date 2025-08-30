local lib = {}
if game:GetService('CoreGui'):FindFirstChild('Ancestor') then 
	game:GetService('CoreGui').Ancestor:Destroy()
	game:GetService('CoreGui').AncestorNotify:Destroy()
	game:GetService('CoreGui').AncestorToolTip:Destroy()
	if game:GetService('CoreGui'):FindFirstChild('AncestorMobile') then
		game:GetService('CoreGui').AncestorMobile:Destroy()
	end
end

function lib:Create(type: string, proprieties: {}, parent: boolean): type
	local instance = Instance.new(type)

	for i, v in next, proprieties do
		if instance[i] and (proprieties ~= "Parent" or parent) then
			instance[i] = v
		end
	end

	return instance
end

lib.SaveFunctions = {}
lib.SaveFunctions.Version = 'Ancestor_v1'
lib.SaveFunctions.Template = {type='',value={},version=lib.SaveFunctions.Version}
lib.SaveFunctions.TemplateTable = function(type,value)
	local temp = table.clone(lib.SaveFunctions.Template)
	temp.type = type
	temp.value = value
	return temp
end
function lib.SaveFunctions:TransformInJson(v: 'Primitive'): {("type" & string) | ("value" & {any}) | ("version" & string)}
	if typeof(v) == 'CFrame' then
		return lib.SaveFunctions.TemplateTable('CFrame',{v:GetComponents()})
	elseif typeof(v) == 'Vector3' then
		return lib.SaveFunctions.TemplateTable('Vector3',{v.X,v.Y,v.Z})
	elseif typeof(v) == 'Vector2' then
		return lib.SaveFunctions.TemplateTable('Vector2',{v.X,v.Y})
	elseif typeof(v) == 'UDim' then
		return lib.SaveFunctions.TemplateTable('UDim',{v.Scale,v.Offset})
	elseif typeof(v) == 'UDim2' then
		return lib.SaveFunctions.TemplateTable('UDim2',{v.X.Scale,v.X.Offset,v.Y.Scale,v.Y.Offset})
	elseif typeof(v) == 'Color3' then
		return lib.SaveFunctions.TemplateTable('Color3',{v.R,v.G,v.B})
	elseif typeof(v) == 'BrickColor' then
		return lib.SaveFunctions.TemplateTable('BrickColor',{v.Number})
	elseif typeof(v) == 'Enum' then
		return lib.SaveFunctions.TemplateTable('Enum',{v.EnumType,v.Name})
	elseif typeof(v) == 'Ray' then
		return lib.SaveFunctions.TemplateTable('Ray',{v.Origin,v.Direction})
	elseif typeof(v) == 'NumberSequence' then
		return lib.SaveFunctions.TemplateTable('NumberSequence',v.Keypoints)
	elseif typeof(v) == 'ColorSequence' then
		return lib.SaveFunctions.TemplateTable('ColorSequence',v.Keypoints)
	elseif typeof(v) == 'Rect' then
		return lib.SaveFunctions.TemplateTable('Rect',{v.Min.X,v.Min.Y,v.Max.X,v.Max.Y})
	elseif typeof(v) == 'Region3' then
		local min, max = v.CFrame.Position - v.Size/2, v.CFrame.Position + v.Size/2
		return lib.SaveFunctions.TemplateTable('Region3',{{min.X,min.Y,min.Z},{max.X,max.Y,max.Z}})
	elseif typeof(v) == 'NumberRange' then
		return lib.SaveFunctions.TemplateTable('NumberRange',{v.Min,v.Max})
	elseif typeof(v) == 'DateTime' then
		return lib.SaveFunctions.TemplateTable('DateTime',v.UnixTimestamp)
	elseif typeof(v) == 'Faces' then
		local faces = {}
		for _,e in pairs(Enum.NormalId:GetEnumItems()) do
			if v[e.Name] then
				table.insert(faces, e.Name)
			end
		end
		return lib.SaveFunctions.TemplateTable('Faces',faces)
	elseif typeof(v) == 'PhysicalProperties' then
		return lib.SaveFunctions.TemplateTable('PhysicalProperties',{v.Density,v.Friction,v.Elasticity,v.FrictionWeight,v.ElasticityWeight})
	end
	return v
end

function lib.SaveFunctions:UnTransformJson(v: {("type" & string) | ("value" & {any}) | ("version" & string)})
	if type(v) == 'table' and v.type ~= nil and (v.version ~= nil and v.version == lib.SaveFunctions.Version) then
		if v.type == 'CFrame' then
			return CFrame.new(unpack(v.value))
		elseif v.type == 'Vector3' then
			return Vector3.new(unpack(v.value))
		elseif v.type == 'Vector2' then
			return Vector2.new(unpack(v.value))
		elseif v.type == 'UDim' then
			return UDim.new(unpack(v.value))
		elseif v.type == 'UDim2' then
			return UDim2.new(unpack(v.value))
		elseif v.type == 'Color3' then
			return Color3.new(unpack(v.value))
		elseif v.type == 'BrickColor' then
			return BrickColor.new(v.value[1])
		elseif v.type == 'Enum' then
			return Enum[v.value[1]][v.value[2]]
		elseif v.type == 'Ray' then
			return Ray.new(unpack(v.value))
		elseif v.type == 'NumberSequence' then
			return NumberSequence.new(v.value)
		elseif v.type == 'ColorSequence' then
			return ColorSequence.new(v.value)
		elseif v.type == 'Rect' then
			return Rect.new(unpack(v.value))
		elseif v.type == 'Region3' then
			return Region3.new(Vector3.new(unpack(v.value[1])),Vector3.new(unpack(v.value[2])))
		elseif v.type == 'NumberRange' then
			return NumberRange.new(unpack(v.value))
		elseif v.type == 'DateTime' then
			return DateTime.fromUnixTimestamp(v.value)
		elseif v.type == 'Faces' then
			for i,v in pairs(v.value) do
				v.value[i] = Enum.NormalId[v]
			end
			return Faces.new(unpack(v.value))
		elseif v.type == 'PhysicalProperties' then
			return PhysicalProperties.new(unpack(v.value))
		end
	end
	return v
end

local CoreGui = game:GetService('CoreGui')
local TweenService = game:GetService("TweenService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local UIS = game:GetService("UserInputService")
local TextSrvice = game:GetService("TextService")
local Debris = game:GetService('Debris')

function GetCenter(frame: Frame)
	return UDim2.new(0.5, -frame.AbsoluteSize.X/2, 0.5, -frame.AbsoluteSize.Y/2)
end

local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos =
			UDim2.new(
				StartPosition.X.Scale,
				StartPosition.X.Offset + Delta.X,
				StartPosition.Y.Scale,
				StartPosition.Y.Offset + Delta.Y
			)
		object.Position = pos
	end

	topbarobject.InputBegan:Connect(
		function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				DragStart = input.Position
				StartPosition = object.Position

				input.Changed:Connect(
					function()
						if input.UserInputState == Enum.UserInputState.End then
							Dragging = false
						end
					end
				)
			end
		end
	)

	topbarobject.InputChanged:Connect(
		function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseMovement or
				input.UserInputType == Enum.UserInputType.Touch
			then
				DragInput = input
			end
		end
	)

	UIS.InputChanged:Connect(
		function(input)
			if input == DragInput and Dragging then
				Update(input)
			end
		end
	)
end

function lib:MobileButton(pos: UDim2)
	local MobileMain = lib:Create('TextButton',{
		Name = 'Mobile',
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Text = '',
		AutoButtonColor = false,
		Position = pos or UDim2.new(0.929049551, 0, 0.0258964151, 0),
		Size = UDim2.new(0, 40, 0, 40)
	})
	MakeDraggable(MobileMain,MobileMain)
	MobileMain.Parent = lib:Create('ScreenGui',{
		Name = 'AncestorMobile',
		ResetOnSpawn = false,
		DisplayOrder = 1
	})
	MobileMain.Parent.Parent = game:GetService('CoreGui')
	lib:Create('UIGradient',{
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(38, 62, 162)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(52, 66, 141))},
		Rotation = 90,
	}).Parent = MobileMain
	local TextFolder = lib:Create('Folder',{
		Name = 'LogoTextFolder'
	})
	TextFolder.Parent = MobileMain
	lib:Create('TextLabel',{
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(-0.0204404835, 0, 0.125, 0),
		Size = UDim2.new(0, 40, 0, 30),
		Font = Enum.Font.GothamMedium,
		Text = 'l',
		TextColor3 = Color3.fromRGB(65, 255, 65),
		TextSize = 27,
		TextTransparency = 0.2
	}).Parent = TextFolder
	lib:Create('TextLabel',{
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0.113, 0, 0.125, 0),
		Size = UDim2.new(0, 28, 0, 30),
		Font = Enum.Font.GothamMedium,
		Text = '-',
		TextColor3 = Color3.fromRGB(17, 124, 255),
		TextSize = 27,
		TextTransparency = 0.2
	}).Parent = TextFolder
	lib:Create('TextLabel',{
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(-0.04, 0, 0.125, 0),
		Size = UDim2.new(0, 36, 0, 30),
		Font = Enum.Font.GothamMedium,
		Text = 'k',
		TextColor3 = Color3.fromRGB(255, 28, 100),
		TextSize = 27,
		TextTransparency = 0.2
	}).Parent = TextFolder
	lib:Create('TextLabel',{
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0.0331138819, 0, 0.125, 0),
		Size = UDim2.new(0, 40, 0, 30),
		Font = Enum.Font.GothamBold,
		Text = 'A',
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 27
	}).Parent = TextFolder
	MobileMain.MouseButton1Click:Connect(function()
		if game:GetService('CoreGui'):FindFirstChild('Ancestor') then
			game:GetService('CoreGui').Ancestor.MainBody.Visible = not game:GetService('CoreGui').Ancestor.MainBody.Visible
		end
	end)
	return MobileMain
end

function Disconnect(v)
	pcall(function()
		v:Disconnect()
	end)
end

local function logError(context, errorMsg)
	local fullError = string.format("[ERROR] %s: %s", context, tostring(errorMsg))
	warn(fullError)
	return false
end
local function SafeCall(name, func, ...)
	local success, result = xpcall(func, function(err)
		return debug.traceback(string.format("Error in %s: %s", name, err))
	end, ...)

	if not success then
		logError(name, result)
		return nil
	end
	return result
end

local MainToolTip = {}
MainToolTip['Holder'] = lib:Create('Frame',{
	BackgroundColor3 = Color3.fromRGB(47, 65, 141),
	Size = UDim2.new(0, 0, 0, 0),
	Visible = false
})
MainToolTip['Holder'].Parent = lib:Create('ScreenGui',{
	Name = 'AncestorToolTip',
	ResetOnSpawn = false,
	DisplayOrder = 1
})

lib:Create('UIListLayout',{
	Padding = UDim.new(0,3),
}).Parent = MainToolTip['Holder']

lib:Create('UIPadding',{
	PaddingBottom = UDim.new(0,5),
	PaddingLeft = UDim.new(0,5),
	PaddingRight = UDim.new(0,5),
	PaddingTop = UDim.new(0,5),
}).Parent = MainToolTip['Holder']

lib:Create('UICorner',{
	CornerRadius = UDim.new(0, 4),
}).Parent = MainToolTip['Holder']

MainToolTip['Title'] = lib:Create('TextLabel',{
	BackgroundTransparency = 1,
	Size = UDim2.new(1, 0, 0, 20),
	Font = Enum.Font.SourceSansBold,
	TextSize = 20,
	Text = 'Title',
	TextColor3 = Color3.new(1, 1, 1),
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
})
MainToolTip.Title.TextWrapped = true
MainToolTip.Title.Parent = MainToolTip['Holder']

lib:Create('UITextSizeConstraint',{}).Parent = MainToolTip['Title']

MainToolTip['Text'] = lib:Create('TextLabel',{
	BackgroundTransparency = 1,
	Size = UDim2.new(0, 9, 0, 15),
	Font = Enum.Font.SourceSans,
	TextSize = 15,
	Text = '...',
	TextColor3 = Color3.new(1, 1, 1),
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
})
MainToolTip.Text.TextWrapped = true
MainToolTip.Text.Parent = MainToolTip['Holder']

lib:Create('UITextSizeConstraint',{}).Parent = MainToolTip['Text']

MainToolTip.Text:GetPropertyChangedSignal('Text'):Connect(function()
	local vec = TextSrvice:GetTextSize(MainToolTip.Text.Text,15,Enum.Font.SourceSans,Vector2.new(230,math.huge))
	if typeof(vec) == 'Vector2' then
		MainToolTip.Text.Size = UDim2.new(0, vec.X, 0, vec.Y)
	end
end)
MainToolTip.Title:GetPropertyChangedSignal('Text'):Connect(function()
	local vec = TextSrvice:GetTextSize(MainToolTip.Title.Text,20,Enum.Font.SourceSansBold,Vector2.new(230,math.huge))
	if typeof(vec) == 'Vector2' then
		MainToolTip.Title.Size = UDim2.new(0, vec.X, 0, vec.Y)
	end
end)
MainToolTip.Holder.UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
	local size = MainToolTip.Holder.UIListLayout.AbsoluteContentSize
	MainToolTip.Holder.Size = UDim2.new(0, math.clamp(size.x+10,0,240), 0, size.Y+10)
end)

MainToolTip.Holder.Parent.Parent = CoreGui

local TTP
TTP = game:GetService('RunService').RenderStepped:Connect(function()
	if MainToolTip['Holder'] == nil or MainToolTip['Holder'].Parent == nil then 
		TTP:Disconnect() 
		for i,v in pairs(MainToolTip) do
			if typeof(v) == 'Instance' then
				Debris:AddItem(v,0)
				MainToolTip[i] = nil
			end
		end
		return
	end
	MainToolTip['Holder'].Position = UDim2.new(0,Mouse.X+12,0,Mouse.Y - (MainToolTip.Holder.AbsoluteSize.Y/2))
end)

--// Notification \\--

local NotificationFrame
pcall(function()
	NotificationFrame = lib:Create('Frame',{
		Name = "Notification",
		BackgroundColor3 = Color3.fromRGB(17, 17, 17),
		BorderColor3 = Color3.fromRGB(47, 47, 47),
		BorderSizePixel = 2,
		Size = UDim2.new(0, 300,0, 200),
		Visible = false,
		ZIndex = 5,
	})
	NotificationFrame.Position = GetCenter(NotificationFrame)
	NotificationFrame.Parent = lib:Create('ScreenGui',{
		Name = 'AncestorNotify',
		ResetOnSpawn = false,
		DisplayOrder = 2
	})
	NotificationFrame.Parent.Parent = CoreGui

	local Top = lib:Create('Frame',{
		Name = "Top",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Size = UDim2.new(0, 300, 0, 30),
		ZIndex = 5,
	})
	Top.Parent = NotificationFrame

	local UIGradient = lib:Create('UIGradient',{
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(38, 62, 162)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(52, 66, 141))},
		Rotation = 90
	})
	UIGradient.Parent = Top

	local Title = lib:Create('TextLabel',{
		Name = "Title",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 9,0, 0),
		Size = UDim2.new(0, 87, 0, 30),
		Font = Enum.Font.GothamBold,
		Text = "Notification",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 20.000,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 5,
	})
	Title.Parent = Top

	local TextHolder = lib:Create('ScrollingFrame',{
		Name = "FieldHolder",
		BackgroundColor3 = Color3.fromRGB(17, 17, 17),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		ScrollBarThickness = 5,
		ScrollBarImageColor3 = Color3.fromRGB(161, 161, 161),
		Position = UDim2.new(0, 0, 0, 34),
		Size = UDim2.new(0, 300, 0, 120),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ZIndex = 5
	})
	TextHolder.Parent = NotificationFrame
	TextHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y

	local UiList = lib:Create('UIListLayout',{
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top
	})
	UiList.Parent = TextHolder

	local Padding = lib:Create('UIPadding',{
		PaddingLeft = UDim.new(0,5),
		PaddingRight = UDim.new(0,5)
	})
	Padding.Parent = TextHolder

	local TextField = lib:Create('TextLabel',{
		Name = "TextField",
		BackgroundColor3 = Color3.fromRGB(17, 17, 17),
		BackgroundTransparency = 0,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 5, 0, 0),
		Size = UDim2.new(0, 290, 0, 120),
		Font = Enum.Font.SourceSans,
		Text = "...",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 22,
		--TextScaled = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		ZIndex = 5,
	})
	TextField.Parent = TextHolder
	TextField.TextWrapped = true
	TextField.RichText = true
	--TextField.AutomaticSize = Enum.AutomaticSize.Y
	TextField.Changed:Connect(function(v)
		if v ~= 'Text' then return end
		local size = TextSrvice:GetTextSize(TextField.Text,22,Enum.Font.SourceSans,Vector2.new(290,math.huge))
		if typeof(size) == 'Vector2' then
			TextField.Size = UDim2.fromOffset(290,size.Y)
		end
	end)

	local TextSize = lib:Create('UITextSizeConstraint',{})
	TextSize.Parent = TextField

	local Button1 = lib:Create('Frame',{
		Name = "Button1",
		BackgroundColor3 = Color3.fromRGB(85, 255, 0),
		BorderColor3 = Color3.fromRGB(40, 210, 0),
		BorderSizePixel = 2,
		Position = UDim2.new(0, 5,0, 163),
		Size = UDim2.new(0, 100, 0, 30),
		Visible = false,
		ZIndex = 5,
	})
	Button1.Parent = NotificationFrame

	local Text_3 = lib:Create('TextButton',{
		Name = "Text",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.SourceSans,
		Text = "Yes",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 20.000,
		TextStrokeTransparency = 0.500,
		ZIndex = 5,
	})
	Text_3.Parent = Button1

	local Button2 = lib:Create('Frame',{
		Name = "Button2",
		BackgroundColor3 = Color3.fromRGB(197, 0, 0),
		BorderColor3 = Color3.fromRGB(137, 0, 0),
		BorderSizePixel = 2,
		Position = UDim2.new(0, 194,0, 163),
		Size = UDim2.new(0, 100, 0, 30),
		Visible = false,
		ZIndex = 5,
	})
	Button2.Parent = NotificationFrame

	local Text = lib:Create('TextButton',{
		Name = "Text",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.SourceSans,
		Text = "No",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 20.000,
		TextStrokeTransparency = 0.500,
		ZIndex = 5.
	})
	Text.Parent = Button2

	local Button3 = lib:Create('Frame',{
		Name = "Button3",
		BackgroundColor3 = Color3.fromRGB(85, 255, 0),
		BorderColor3 = Color3.fromRGB(40, 210, 0),
		BorderSizePixel = 2,
		Position = UDim2.new(0, 95,0, 163),
		Size = UDim2.new(0, 100, 0, 30),
		Visible = false,
		ZIndex = 5,
	})
	Button3.Parent = NotificationFrame

	local Text_2 = lib:Create('TextButton',{
		Name = "Text",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.SourceSans,
		Text = "Ok",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 20.000,
		TextStrokeTransparency = 0.500,
		ZIndex = 5,
	})
	Text_2.Parent = Button3
end)

local NotifyQueq,busy,mainskip,OverTable,LastOptions = {},false,false,{},{}
function lib:Notification(Title: string,Text: string,Buttons: {string},Duration,Options: {('NoWait') -> ('OverWrite') -> ('Custom') -> ('RightSide') -> ('CanBeOverWrite') -> boolean})
	Options = Options or {}
	setmetatable(Options,{__index=function(t,i)
		local Defaults = {
			['NoWait'] = false,
			['OverWrite'] = false,
			['Custom'] = false,
			['RightSide'] = false,
			['CanBeOverWrite'] = true
		}
		local v = rawget(t,string.lower(i))
		return (v ~= nil and v) or Defaults[i]
	end})

	if (string.gsub(Title,' ','') ~= '' or Options.Custom) and ((not Options.Custom and string.gsub(Text,' ','') ~= '') or Options.Custom) then
		local Main = NotificationFrame
		local TitleT = Main.Top.Title
		local Button1 = Main.Button1
		local Button2 = Main.Button2
		local Button3 = Main.Button3
		local Holder = Main.FieldHolder
		local TextField = Holder.TextField

		local CurrentIs = nil

		local function AddTextField()
			local destroyed = false
			local newframe = lib:Create('Frame',{
				Name = 'TextCustom',
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				ZIndex = 5
			})
			newframe.Parent = Holder
			newframe.AutomaticSize = Enum.AutomaticSize.Y

			local UiList = lib:Create('UIListLayout',{
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				FillDirection = Enum.FillDirection.Horizontal
			})
			UiList.Wraps = true
			UiList.Parent = newframe

			return {
				AddText = function(): TextLabel
					if not destroyed then
						local newtext = lib:Create('TextLabel',{
							Name = "TextField",
							BackgroundColor3 = Color3.fromRGB(17, 17, 17),
							BackgroundTransparency = 0,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.new(0, 5, 0, 0),
							Size = UDim2.new(0, 0, 0, 0),
							Font = Enum.Font.SourceSans,
							Text = "...",
							TextColor3 = Color3.fromRGB(255, 255, 255),
							TextSize = 22,
							--TextScaled = true,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Top,
							ZIndex = 5,
						})
						local i = (#newframe:GetChildren()-1)+1
						newtext:SetAttribute('Index',i)
						newtext.Parent = newframe
						newtext.TextWrapped = true
						newtext.RichText = true
						--TextField.AutomaticSize = Enum.AutomaticSize.Y
						newtext.Changed:Connect(function(v)
							if v ~= 'Text' then return end
							local size = TextSrvice:GetTextSize(newtext.Text,22,Enum.Font.SourceSans,Vector2.new(290,math.huge))
							if typeof(size) == 'Vector2' then
								newtext.Size = UDim2.fromOffset(size.X,size.Y)
							end
						end)

						local TextSize = lib:Create('UITextSizeConstraint',{})
						TextSize.Parent = newtext
						return newtext
					end
				end,
				Destroy = function()
					if not destroyed then
						newframe:ClearAllChildren()
						newframe:Destroy()
						destroyed = true
					end
				end
			}
		end

		local function Run(Queq: boolean,Event: BindableEvent)
			local Choice,skip,Conections = nil,false,{}
			local DestroyEvent = Event or Instance.new('BindableEvent')
			TitleT.Text = Title or ''
			LastOptions = Options
			Main.Position = (Options.RightSide and UDim2.new(1,-305,1,-205)) or GetCenter(Main)
			if Options.Custom then
				TextField.Visible = false
				local Texts = (typeof(Text) == 'table' and Text) or {}
				for _,v in pairs(Texts) do
					if type(v) == 'table' then
						local field = AddTextField()
						DestroyEvent.Event:Once(function()
							field.Destroy()
						end)
						for _,v in pairs(v) do
							if v.Text and string.gsub(v.Text,' ','') ~= '' then
								setmetatable(v,{__index=function(t,i)
									local Defaults = {
										['Text'] = '',
										['Color3'] = Color3.new(1, 1, 1),
										['Script'] = nil
									}
									local v = rawget(t,string.lower(i))
									return (v ~= nil and v) or Defaults[i]
								end})
								local Textl = field.AddText()
								if Textl then
									Textl.Text = (Textl:GetAttribute('Index') < 2 and `> {v.Text}`) or v.Text
									Textl.TextColor3 = v.Color3
									if v.Script then
										spawn(function()
											-- for you tath don't understands DestroyEvent is a bindable event, it will fire when the notification ends
											-- Textl Is a textlabel for the function you gave.
											v.Script(Textl,DestroyEvent.Event)
										end)
									end
								end
							end
						end
					end
				end
			else
				TextField.Visible = true
				TextField.Text = Text
			end
			if #Buttons > 0 and #Buttons < 2 then
				Button3.Text.Text = Buttons[1] -- Midle
				Button3.Visible = true
			elseif #Buttons > 0 then
				Button1.Text.Text = Buttons[1] -- Left, Green
				Button1.Visible = true
				Button2.Text.Text = Buttons[2] -- Right, Red
				Button2.Visible = true
			end
			Conections[1] = Button1.Text.MouseButton1Up:Once(function()
				if skip then return end
				Choice = Buttons[1]
				skip = true
			end)
			Conections[2] = Button2.Text.MouseButton1Up:Once(function()
				if skip then return end
				Choice = Buttons[2]
				skip = true
			end)
			Conections[3] = Button3.Text.MouseButton1Up:Once(function()
				if skip then return end
				Choice = Buttons[1]
				skip = true
			end)
			Main.Visible = true
			Holder.CanvasPosition = Vector2.new(0,0)
			DestroyEvent.Event:Once(function()
				skip = true
			end)
			CurrentIs = DestroyEvent
			local t = tick()
			repeat task.wait() until tick()-t >= (tonumber(Duration) or 5) or skip or (mainskip and Options.CanBeOverWrite)
			DestroyEvent:Fire()
			DestroyEvent:Destroy()
			CurrentIs = nil
			LastOptions = {}
			skip = false
			Main.Visible = false
			Button1.Visible = false
			Button2.Visible = false
			Button3.Visible = false
			for _,v in pairs(Conections) do
				Disconnect(v)
			end
			if Queq then
				table.remove(NotifyQueq,1)
			end
			if #NotifyQueq > 0 or mainskip then
				local next = (not mainskip and NotifyQueq[1]) or (mainskip and OverTable)
				mainskip = false
				if next then
					if type(next[3]) == 'function' then
						spawn(function()
							(next[3])((next[1])(next[2],next[4]))
						end)
					else
						spawn(function()
							(next[1])(next[2],next[4])
						end)
					end
				end
			else
				busy = false
			end
			return Choice
		end

		if busy then
			if not Options.OverWrite then
				if Options.NoWait == true then
					local event = Instance.new('BindableEvent')
					NotifyQueq[#NotifyQueq+1] = {[1]=Run,[2]=true,[4]=event}
					return function()
						if event and CurrentIs == event then
							event:Fire()
							return true
						else
							return false
						end
					end
				else
					local s,r = nil,nil
					NotifyQueq[#NotifyQueq+1] = {[1]=Run,[2]=true,[3]=function(v) s=true;r=v end}
					repeat task.wait() until s
					return r
				end
			else
				if Options.NoWait == true then
					local event = Instance.new('BindableEvent')
					OverTable = {[1]=Run,[4]=event}
					mainskip = true
					return function()
						if event and CurrentIs == event then
							event:Fire()
							return true
						else
							return false
						end
					end
				else
					local s,r = nil,nil
					OverTable = {[1]=Run,[3]=function(v) s=true;r=v end}
					mainskip = true
					repeat task.wait() until s
					return r
				end
			end
		else
			busy = true
			if Options.NoWait == true then
				local event = Instance.new('BindableEvent')
				spawn(function()
					Run(false,event)
				end)
				return function()
					if event and CurrentIs == event then
						event:Fire()
						return true
					else
						return false
					end
				end
			else
				return Run(false)
			end
		end
	end
end

function lib:Main(mainsettings)
	local mainsettings = mainsettings or {}
	local main = {}
	local firstC = true
	local keycode = Enum.KeyCode.LeftControl
	setmetatable(mainsettings,{__index=function(t,i)
		local Defaults = {
			['CloseButton'] = true,
			['CloseCall'] = (function() end)
		}
		local v = rawget(t,string.lower(i))
		return (v ~= nil and v) or Defaults[i]
	end})

	main.ScreenGui = lib:Create("ScreenGui", {
		Name = "Ancestor",
		ResetOnSpawn = false,
	})

	main.MainBody = lib:Create("Frame", {
		Name = "MainBody",
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		BorderColor3 = Color3.fromRGB(47, 47, 47),
		BorderSizePixel = 2,
		Size = UDim2.new(0, 554, 0, 304),
	})
	main.MainBody.Position = GetCenter(main.MainBody)

	UIS.InputBegan:Connect(function(k,p)
		if k.KeyCode == keycode and not p then
			main.MainBody.Visible = not main.MainBody.Visible
		end
	end)

	function main:ChangeToggleKey(key: Enum.KeyCode)
		keycode = key
	end
	
	function main:GetGuiVisibility(): boolean
		return main.MainBody.Visible
	end
	
	function main:SetGuiVisibility(v: boolean)
		main.MainBody.Visible = v
	end

	function main:GetGui(): ScreenGui
		return main.ScreenGui
	end

	main.TopBar = lib:Create("Frame", {
		Name = "TopBar",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Size = UDim2.new(0, 554, 0, 40),
	})

	MakeDraggable(main.TopBar,main.MainBody)
	MakeDraggable(main.MainBody,main.MainBody)

	main.TopBarGradient = lib:Create("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(38, 62, 162)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(52, 66, 141))},
		Rotation = 90,
	})

	main.LogoTextFolder = lib:Create("Folder", {
		Name = "LogoTextFolder",
	})

	main.LogoText1 = lib:Create("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		BorderSizePixel = 0,
		Position = UDim2.new(-0.0204402134, 0, 0.125, 0),
		Size = UDim2.new(0, 52, 0, 30),
		Font = Enum.Font.GothamSemibold,
		Text = "l",
		TextColor3 = Color3.fromRGB(65, 255, 65),
		TextSize = 27.000,
		TextTransparency = 0.200,
	})

	main.LogoText2 = lib:Create("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		BorderSizePixel = 0,
		Position = UDim2.new(0.0129673611, 0, 0.125, 0),
		Size = UDim2.new(0, 17, 0, 30),
		Font = Enum.Font.GothamSemibold,
		Text = "-",
		TextColor3 = Color3.fromRGB(17, 124, 255),
		TextSize = 27.000,
		TextTransparency = 0.200,
	})

	main.LogoText3 = lib:Create("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		BorderSizePixel = 0,
		Position = UDim2.new(-0.0204402227, 0, 0.125, 0),
		Size = UDim2.new(0, 47, 0, 30),
		Font = Enum.Font.GothamSemibold,
		Text = "k",
		TextColor3 = Color3.fromRGB(255, 28, 100),
		TextSize = 27.000,
		TextTransparency = 0.200,
	})


	main.LogoText4 = lib:Create("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		BorderSizePixel = 0,
		Position = UDim2.new(0.0331138819, 0, 0.125, 0),
		Size = UDim2.new(0, 87, 0, 30),
		Font = Enum.Font.GothamBold,
		Text = "Ancestor",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 27.000,
	})

	main.LogoText5 = lib:Create("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		BorderSizePixel = 0,
		Position = UDim2.new(0.19138819, 0, 0.105, 0),
		Size = UDim2.new(0, 87, 0, 30),
		Font = Enum.Font.GothamBold,
		Text = '',
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 20.000,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	if mainsettings.CloseButton then
		main.CloseFrame = lib:Create("ImageLabel", {
			Name = "CloseFrame",
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0.958662987, 0, 0.250000001, 0),
			Size = UDim2.new(0, 15, 0, 15),
			Image = "rbxassetid://3570695787",
			ImageColor3 = Color3.fromRGB(255, 0, 4),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(100, 100, 100, 100),
			SliceScale = 0.120,
			ImageTransparency = 1,
		})

		main.Close = lib:Create("TextButton", {
			Name = "Close",
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, -0.466666669, 0),
			Size = UDim2.new(0, 15, 0, 25),
			Font = Enum.Font.SourceSans,
			Text = "x",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 18.000,
		})

		main.Close.MouseEnter:Connect(function()
			TweenService:Create(main.CloseFrame, TweenInfo.new(0.1), {ImageTransparency = 0}):Play()
		end)

		main.Close.MouseLeave:Connect(function()
			TweenService:Create(main.CloseFrame, TweenInfo.new(0.1), {ImageTransparency = 1}):Play()
		end)

		main.CloseFrame.Parent = main.TopBar
		main.Close.Parent = main.CloseFrame
	end

	main.CategoryContainer = lib:Create("ScrollingFrame", {
		Name = "CategoryContainer",
		Active = true,
		BackgroundColor3 = Color3.fromRGB(47, 47, 47),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0.131578952, 0),
		Size = UDim2.new(0, 50, 0, 264),
		CanvasSize = UDim2.new(0, 0, 0, 1),
		ScrollBarThickness = 0,
		ScrollBarImageColor3=Color3.fromRGB(75,75,75)
	})

	main.CategoryPadding = lib:Create("UIPadding", {
		PaddingTop = UDim.new(0, 2),
		PaddingBottom = UDim.new(0, 2),
	})

	main.CategoryLayout = lib:Create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 3),
	})

	function main:Category(ImageId)
		local categories = {}

		categories.Button = lib:Create("ImageButton", {
			Active = false,
			BackgroundColor3 = Color3.fromRGB(65, 65, 65),
			BorderSizePixel = 0,
			Selectable = false,
			Size = UDim2.new(1, 0, 0, 50),
			AutoButtonColor = false,
			Image = "rbxassetid://"..ImageId,
		})

		categories.Container = lib:Create("ScrollingFrame", {
			BackgroundColor3 = Color3.fromRGB(17, 17, 17),
			BorderSizePixel = 0,
			Position = UDim2.new(0.091575101, 0, 0.138557434, 0),
			Selectable = false,
			Size = UDim2.new(0, 503, 0, 262),
			ScrollBarThickness = 7,
			ScrollBarImageColor3=Color3.fromRGB(75,75,75),
			CanvasSize = UDim2.new(0,0,.2,1.3),
			Visible = false,
		})
		categories.Container.AutomaticCanvasSize = Enum.AutomaticSize.Y

		if firstC then
			categories.Container.Visible = true 
		end 

		categories.ContainerLayout = lib:Create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 5),
		})

		categories.ContainerPadding = lib:Create("UIPadding", {
			PaddingLeft = UDim.new(0, 0),
			PaddingBottom = UDim.new(0,5),
		})

		categories.Button.MouseButton1Click:Connect(function()
			for i,v in pairs(main.MainBody:GetChildren()) do 
				if v.Name == "ScrollingFrame" then 
					v.Visible = false 
				end
			end

			categories.Container.Visible = true
		end)

		function categories:Section(Name)
			local sections = {}
			local Keybinds = {}

			sections.LockKeyBind = function(all: boolean,name: string,value: boolean)
				if all == true then
					for _,v in pairs(Keybinds) do
						if v then
							v(value)
						end
					end
				else
					local v = Keybinds[tostring(name)]
					if v then
						v(value)
					end
				end
			end

			sections.sectioncontainer = lib:Create("Frame", {
				Name = `{Name}Section`,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0)
			})
			sections.sectioncontainer.AutomaticSize = Enum.AutomaticSize.Y
			sections.sectioncontainer.Parent = categories.Container

			sections.containerLayout = lib:Create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 5),
			})
			sections.containerLayout.Parent = sections.sectioncontainer

			sections.containerPadding = lib:Create("UIPadding", {
				PaddingLeft = UDim.new(0, 5),
				PaddingBottom = UDim.new(0,5),
			})
			sections.containerPadding.Parent = sections.sectioncontainer

			sections.sectionname = lib:Create("TextLabel", {
				Name = "SectionTitle",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				BorderSizePixel = 0,
				Position = UDim2.new(0.00994035788, 0, 0, 0),
				Size = UDim2.new(0, 105, 0, 30),
				Font = Enum.Font.SourceSansLight,
				Text = Name,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 27.000,
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			sections.sectionname.Parent = sections.sectioncontainer

			function sections:Button(Name, Animated, CallBack)
				local buttons = {}

				buttons.buttonb = lib:Create("ImageLabel", {
					Name = Name.."Button",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0.00415800419, 0, 0.86175108, 0),
					Size = UDim2.new(0, 484, 0, 35),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(65, 65, 65),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				buttons.buttonframe = lib:Create("ImageLabel", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0.009999929, 0, 0.0857142881, 0),
					Size = UDim2.new(0, 476, 0, 29),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(55, 55, 55),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				buttons.button = lib:Create("TextButton", {
					BackgroundColor3 = Color3.fromRGB(55, 55, 55),
					BackgroundTransparency = 1.000,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 476, 0, 29),
					AutoButtonColor = false,
					Text = Name,
					Font = Enum.Font.GothamSemibold,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 16.000,
				})

				buttons.button.MouseButton1Click:Connect(function()
					if CallBack then 
						CallBack()
					end

					if Animated then 
						TweenService:Create(buttons.buttonframe, TweenInfo.new(0.1), {Size = UDim2.new(0, 440,0, 25),  Position = UDim2.new(0.047, 0,0.143, 0)}):Play()
						TweenService:Create(buttons.button, TweenInfo.new(0.1), {Size = UDim2.new(0, 437,0, 25), Position = UDim2.new(0,0,0,0)}):Play()
						wait(0.05)
						TweenService:Create(buttons.buttonframe, TweenInfo.new(0.1), {Size = UDim2.new(0, 476,0, 29), Position = UDim2.new(0.01, 0,0.086, 0)}):Play()
						TweenService:Create(buttons.button, TweenInfo.new(0.1), {Size = UDim2.new(0, 476,0, 29), Position = UDim2.new(0, 0,0, 0)}):Play()
					end
				end)

				buttons.buttonb.Parent = sections.sectioncontainer
				buttons.buttonframe.Parent = buttons.buttonb
				buttons.button.Parent = buttons.buttonframe
				
				return buttons 
			end

			function sections:Toggle(Name, Default, CallBack)
				local toggles = {}
				local toggled = false
				local toggleBlock = false

				toggles.toggle = lib:Create("ImageButton", {
					Name = Name.."Toggle",
					Active = false,
					BackgroundColor3 = Color3.fromRGB(248, 248, 248),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0.00415800419, 0, 0.86175108, 0),
					Selectable = false,
					Size = UDim2.new(0, 484, 0, 35),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(65, 65, 65),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				}) 

				toggles.togglename = lib:Create("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 79, 0, 35),
					Font = Enum.Font.GothamSemibold,
					Position = UDim2.new(0,5,0,0),
					TextXAlignment = Enum.TextXAlignment.Left,
					Text = Name,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 16.000,
					TextScaled = true,
					TextWrapped = true,
				})

				toggles.t1 = lib:Create("ImageLabel", {
					Name = "ToggleFrame",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(1, -58, 0.0857142881, 0),
					Size = UDim2.new(0, 55, 0, 29), -- THE ONE I WANT TO CHANGE
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(55, 55, 55),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				toggles.t2 = lib:Create("ImageLabel", {
					Name = "ToggleFrame",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					AnchorPoint = Vector2.new(0.5,0.5),
					Position = UDim2.new(0.5,0, 0.5,0),
					Size = UDim2.new(0, 43, 0, 21),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(45, 45, 45),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040
				})

				toggles.t3 = lib:Create("ImageLabel", {
					Name = "ToggleFrame",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(0, 12, 0, 21),
					Image = "rbxassetid://3570695787",
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				if Default then 
					toggled = true

					TweenService:Create(toggles.t3, TweenInfo.new(0.1), {Position = UDim2.new(0.700523198, 0, 0, 0)}):Play()

					if CallBack then 
						SafeCall(`Toggle {Name}`,CallBack,toggled)
					end 
				end

				toggles.toggle.Parent = sections.sectioncontainer
				toggles.togglename.Parent = toggles.toggle
				toggles.t1.Parent = toggles.toggle 
				toggles.t2.Parent = toggles.t1 
				toggles.t3.Parent = toggles.t2

				toggles.toggle.MouseButton1Click:Connect(function()
					if not toggleBlock then
						toggled = not toggled

						if toggled then 
							TweenService:Create(toggles.t3, TweenInfo.new(0.1), {Position = UDim2.new(0.700523198, 0, 0, 0)}):Play()
						else 
							TweenService:Create(toggles.t3, TweenInfo.new(0.1), {Position = UDim2.new(0, 0, 0, 0)}):Play()
						end

						if CallBack then 
							SafeCall(`Toggle {Name}`,CallBack,toggled)
						end 
					end
				end)
				
				SafeCall(`Toggle {Name}`,CallBack,toggled)
				return {
					Toggle = function()
						toggled = not toggled

						if toggled then 
							TweenService:Create(toggles.t3, TweenInfo.new(0.1), {Position = UDim2.new(0.700523198, 0, 0, 0)}):Play()
						else 
							TweenService:Create(toggles.t3, TweenInfo.new(0.1), {Position = UDim2.new(0, 0, 0, 0)}):Play()
						end

						if CallBack then 
							CallBack(toggled)
						end
					end,
					ChangeToggle = function(v)
						toggled = v

						if toggled then 
							TweenService:Create(toggles.t3, TweenInfo.new(0.1), {Position = UDim2.new(0.700523198, 0, 0, 0)}):Play()
						else 
							TweenService:Create(toggles.t3, TweenInfo.new(0.1), {Position = UDim2.new(0, 0, 0, 0)}):Play()
						end

						if CallBack then 
							CallBack(toggled)
						end 
					end,
					Lock = function(v)
						toggleBlock = v
					end,
					ToolTip = function(Text)
						if toggles.toggle:FindFirstChild('ToolTip') then
							Debris:AddItem(toggles.toggle.ToolTip,0)
						end
						local t = lib:Create('TextButton',{
							Name = "ToolTip",
							BackgroundColor3 = Color3.fromRGB(55, 55, 55),
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = (toggles.toggle:FindFirstChild('KeyBind') and UDim2.new(0.716, 0, 0.086, 0)) or UDim2.new(0.795, 0, 0.086, 0),
							Size = UDim2.new(0, 29, 0, 29),
							Font = Enum.Font.SourceSans,
							Text = "?",
							AutoButtonColor = false,
							TextColor3 = Color3.fromRGB(255, 255, 255),
							TextSize = 24
						})
						t.Parent = toggles.toggle
						t.MouseButton1Down:Connect(function()
							MainToolTip.Title.Text = Name
							MainToolTip.Text.Text = Text
							MainToolTip.Holder.Visible = true
						end)
						t.MouseLeave:Connect(function()
							MainToolTip.Holder.Visible = false
						end)
						local c = lib:Create('UICorner',{
							CornerRadius = UDim.new(0, 5)
						})
						c.Parent = t
						toggles.toggle.ChildAdded:Connect(function(v)
							if v.Name == 'KeyBind' then
								t.Position = UDim2.new(0.716, 0, 0.086, 0)
							end
						end)
					end,
					KeyBind = function(KeyCode: Enum.KeyCode,callBack: (any))
						if not toggles.toggle:FindFirstChild('KeyBind') then
							local key = nil
							local debounce = false
							local lockkey = false
							
							local t = lib:Create('TextButton',{
								Name = "KeyBind",
								BackgroundColor3 = Color3.fromRGB(55, 55, 55),
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Position = UDim2.new(0.795, 0, 0.086, 0),
								Size = UDim2.new(0, 29, 0, 29),
								Font = Enum.Font.SourceSans,
								Text = 'None',
								AutoButtonColor = false,
								TextColor3 = Color3.fromRGB(255, 255, 255),
								TextSize = 24
							})
							t.Parent = toggles.toggle
							
							if KeyCode then
								key = KeyCode
								t.Text = KeyCode.Name
							end
							
							local Blacklist = {"W","A","S","D","Slash","Tab","Backspace","Escape","Space","Delete","Unknown","Backquote"}
							
							local c
							t.MouseButton1Down:Connect(function()
								if debounce or lockkey then
									return
								end
								debounce = true
								t.Text = '...'
								c = UIS.InputBegan:Connect(function(i)
									if i.UserInputType.Name == "Keyboard" then
										if not table.find(Blacklist, i.KeyCode.Name) then
											t.Text = i.KeyCode.Name
											key = i.KeyCode
											debounce = false
											if c then
												Disconnect(c)
												c = nil
											end
										else
											t.Text = "None"
											key = nil
											if c then
												Disconnect(c)
												c = nil
												debounce = false
											end
										end
									end
								end)
							end)
							game:GetService('UserInputService').InputBegan:Connect(function(k,q)
								if not q and k.KeyCode == key and not toggleBlock then
									toggled = not toggled
									if toggled then 
										TweenService:Create(toggles.t3, TweenInfo.new(0.1), {Position = UDim2.new(0.700523198, 0, 0, 0)}):Play()
									else 
										TweenService:Create(toggles.t3, TweenInfo.new(0.1), {Position = UDim2.new(0, 0, 0, 0)}):Play()
									end
									if CallBack then 
										SafeCall(`Toggle {Name} | Keybind`,CallBack,toggled)
									end
									if callBack then
										SafeCall(`Toggle {Name} | Keybind`,callBack,toggled)
									end
								end
							end)
							return {
								Lock = function(v: boolean)
									toggleBlock = v
								end,
								LockKey = function(v: boolean)
									lockkey = v
								end,
							}
						end
					end,
				}
			end

			function sections:TextLabel(Text,Color)
				local textlabels = {}
				local textlabelfuncs = {}

				textlabels.textlabelframe = lib:Create("ImageLabel", {
					Name = "TextLabel",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0.00415800419, 0, 0.86175108, 0),
					Size = UDim2.new(0, 484, 0, 35),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(65, 65, 65),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				--[[
				textlabels.textlabelframe2 = lib:Create("ImageLabel", {
					Name = "TextLabelFrame",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0.009999929, 0, 0.0857142881, 0),
					Size = UDim2.new(0, 476, 0, 29),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(55, 55, 55),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.04,
				})
				--]]

				textlabels.textlabel = lib:Create("TextLabel", {          
					['BackgroundColor3'] = Color3.fromRGB(255, 255, 255),
					['BackgroundTransparency'] = 1.000,
					['BorderSizePixel'] = 0,
					['Position'] = GetCenter(textlabels.textlabelframe),
					['Size'] = UDim2.new(0, 476, 0, 35),
					['Font'] = Enum.Font.GothamSemibold,
					['Text'] = Text,
					['TextColor3'] = Color or Color3.fromRGB(255, 255, 255),
					['TextSize'] = 16.000
				})
				textlabels.textlabel.TextWrapped = true
				textlabels.textlabel.RichText = true

				textlabels.textlabelframe.Parent = sections.sectioncontainer
				--textlabels.textlabelframe2.Parent = textlabels.textlabelframe
				textlabels.textlabel.Parent = textlabels.textlabelframe

				textlabelfuncs.SetText = function(text: string)
					textlabels.textlabel.Text = text
				end

				return textlabelfuncs
			end

			function sections:Separator()
				local a = lib:Create("Frame", {
					Name = "Seperator1",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0.5, 0, 0, 0),
					Size = UDim2.new(0, 484, 0, 8)
				})
				a.Parent = sections.sectioncontainer

				lib:Create("Frame", {
					Name = "Seperator2",
					BackgroundColor3 = Color3.fromRGB(66, 69, 74),
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 0, 4),
					Size = UDim2.new(1, 0, 0, 1)
				}).Parent = a

				--[[
				local b = lib:Create("Frame", {
					Name = "TextLabelFrame",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Position = UDim2.new(0.009999929, 0, 0.0857142881, 0),
					Size = UDim2.new(0, 476, 0, 29),
				})
				b.Parent = a

				local UIGradient = lib:Create('UIGradient',{
					Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(4, 24, 136)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(6, 35, 197))},
					Rotation = 0
				})
				UIGradient.Parent = b
				--]]
			end

			function sections:Slider(Name, Settings, CallBack)
				local sliders = {}
				local slidervalue = 0
				local Settings = Settings or {}
				setmetatable(Settings,{__index=function(t,i)
					local Defaults = {
						['Max'] = 0,
						['Min'] = 0,
						['Start'] = 0,
						['Precise'] = false,
						['Decimals'] = 1
					}
					local v = rawget(t,string.lower(i))
					return (v ~= nil and v) or Defaults[i]
				end})
				local Max = Settings.Max
				local Min = Settings.Min
				local Default = Settings.Default or Settings.Start
				local Precise = Settings.Precise

				sliders.sliderb = lib:Create("ImageLabel", {
					Name = Name.."Slider",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0.00415800419, 0, 0.86175108, 0),
					Size = UDim2.new(0, 484, 0, 35),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(65, 65, 65),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				sliders.slidertext = lib:Create("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 79, 0, 35),
					TextXAlignment = Enum.TextXAlignment.Left,
					Position = UDim2.new(0, 5, 0, 0),
					Font = Enum.Font.GothamSemibold,
					Text = Name,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 16.000,
					TextScaled = true,
					TextWrapped = true,
				})

				sliders.darkoutline = lib:Create("ImageLabel", {
					Name = "SliderDarkOutline",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(1, -303, 0.0857142881, 0),
					Size = UDim2.new(0, 300, 0, 29),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(55, 55, 55),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				sliders.sliderinnerback = lib:Create("ImageLabel", {
					Name = "SliderInner",
					AnchorPoint = Vector2.new(0,0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 4, 0.5, 0),
					Size = UDim2.new(0, 256, 0, 12),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(45, 45, 45),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				sliders.slider = lib:Create("TextButton", {
					Name = "SliderButton",
					BackgroundColor3 = Color3.fromRGB(55, 55, 55),
					BackgroundTransparency = 1.000,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 0, 12),
					AutoButtonColor = false,
					Font = Enum.Font.SourceSans,
					Text = "",
					TextColor3 = Color3.fromRGB(0, 0, 0),
					TextSize = 14.000,
				})

				sliders.sliderinner = lib:Create("ImageLabel", {
					Name = "SliderInner",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Size = UDim2.new(0, 0, 0, 12),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(24, 116, 255),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				sliders.slidervalue = lib:Create("TextLabel", {
					Name = "SliderValue",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					BorderSizePixel = 0,
					Position = UDim2.new(1, -204, 0, 0),
					Size = UDim2.new(0, 199, 0, 28),
					Font = Enum.Font.Gotham,
					Text = Default or Min,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 16.000,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Right,
				})

				sliders.slider.MouseButton1Down:Connect(function()
					local connection = game:GetService("RunService").Heartbeat:Connect(function()
						local Scale = math.clamp(Mouse.X - sliders.slider.AbsolutePosition.X,0,sliders.slider.AbsoluteSize.X) / sliders.slider.AbsoluteSize.X
						slidervalue = (Precise and math.floor(Min + ((Max-Min) * Scale))) or tonumber(string.format(`%.{Settings.Decimals}f`, tostring(Min + ((Max-Min) * Scale))))
						sliders.slidervalue.Text = tostring(slidervalue)

						if CallBack then
							SafeCall(`Slider {Name}`,CallBack,slidervalue)
						end

						TweenService:Create(sliders.sliderinner, TweenInfo.new(0.04), {Size = UDim2.new(Scale, 0, 1, -2)}):Play()
					end)
					UIS.InputEnded:Connect(function(i)
						if i.UserInputType == Enum.UserInputType.MouseButton1 then
							if connection then
								Disconnect(connection)
								connection = nil
							end
						end
					end)
				end)

				sliders.sliderb.Parent = sections.sectioncontainer
				sliders.slidertext.Parent = sliders.sliderb
				sliders.darkoutline.Parent = sliders.sliderb
				sliders.sliderinnerback.Parent = sliders.darkoutline
				sliders.slider.Parent = sliders.sliderinnerback
				sliders.sliderinner.Parent = sliders.slider
				sliders.slidervalue.Parent = sliders.darkoutline

				local SetValue do
					SetValue = function(v)
						local v = (Precise and math.floor(v or 0)) or (tonumber(string.format(`%.{Settings.Decimals}f`, tostring(v))) or 0)
						local def = math.clamp(v, Min, Max)
						local Porcentage = (def - Min) / (Max - Min)
						TweenService:Create(sliders.sliderinner, TweenInfo.new(0.04), {Size = UDim2.new(Porcentage, 0, 1, -2)}):Play()
						sliders.slidervalue.Text = tostring(v)
						if CallBack then
							SafeCall(`Slider {Name}`,CallBack,tostring(v))
						end
						return SetValue
					end
				end
				SetValue(Default)

				return {SetValue=SetValue}
			end 

			function sections:TextBox(Name, PlaceholderText, AutoName, CallBack)
				local tb = {}
				local returns = {}
				local text
				local wasfocus = false

				tb.textboxback = lib:Create("ImageLabel", {
					Name = Name.."TextBox",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0.00214187521, 0, 0.886178553, 0),
					Size = UDim2.new(0, 484, 0, 35),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(65, 65, 65),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				tb.text = lib:Create("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 79, 0, 35),
					Font = Enum.Font.GothamSemibold,
					Text = Name,
					Position = UDim2.new(0,5,0,0),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 16.000,
					TextScaled = true,
					TextWrapped = true,
				})

				tb.darkoutline = lib:Create("ImageLabel", {
					Name = "TextBoxFrame",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(1, -354, 0.0857142881, 0),
					Size = UDim2.new(0, 350, 0, 29),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(55, 55, 55),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				tb.textbox = lib:Create("TextBox", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 350, 0, 29),
					Font = Enum.Font.GothamSemibold,
					PlaceholderColor3 = Color3.fromRGB(178, 178, 178),
					PlaceholderText = PlaceholderText,
					Text = "",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 16.000,
				})

				tb.textbox.Focused:Connect(function()
					wasfocus = true
				end)

				tb.textbox.FocusLost:Connect(function()
					if not wasfocus then return end
					if string.gsub(tb.textbox.Text,' ','') == '' then
						tb.textbox.Text = text
					else
						if not AutoName and CallBack then
							text = tb.textbox.Text
							SafeCall(`TextBox {Name}`,CallBack,tb.textbox.Text)
						elseif AutoName then
							for i,v in pairs(game.Players:GetChildren()) do
								if string.match(v.Name:lower(),tb.textbox.Text:lower()) then
									tb.textbox.Text = v.Name
									text = v.Name
									break
								end
							end
							if CallBack then
								SafeCall(`TextBox {Name}`,CallBack,tb.textbox.Text)
							end
						end
					end
				end)

				tb.textboxback.Parent = sections.sectioncontainer
				tb.text.Parent = tb.textboxback
				tb.darkoutline.Parent = tb.textboxback
				tb.textbox.Parent = tb.darkoutline

				returns.ToolTip = function(Text)
					local t = lib:Create('TextButton',{
						Name = "ToolTip",
						BackgroundColor3 = Color3.fromRGB(55, 55, 55),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.new(0.196, 0, 0.086, 0),
						Size = UDim2.new(0, 29, 0, 29),
						Font = Enum.Font.SourceSans,
						Text = "?",
						AutoButtonColor = false,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 24
					})
					t.Parent = tb.textboxback
					t.MouseButton1Down:Connect(function()
						MainToolTip.Title.Text = Name
						MainToolTip.Text.Text = Text
						MainToolTip.Holder.Visible = true
					end)
					t.MouseLeave:Connect(function()
						MainToolTip.Holder.Visible = false
					end)
					local c = lib:Create('UICorner',{
						CornerRadius = UDim.new(0, 5)
					})
					c.Parent = t
				end

				returns.SetText = function(txt: string)
					text = txt
					tb.textbox.Text = txt
				end

				return returns
			end

			function sections:KeyBind(Name, Default, CallBack)
				local kb = {}
				local lock = false
				local lockkey = false
				local kbind

				kb.kbback = lib:Create("ImageLabel", {
					Name = Name.."KeyBind",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0.00214187521, 0, 0.886178553, 0),
					Size = UDim2.new(0, 484, 0, 35),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(65, 65, 65),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				kb.kbtext = lib:Create("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 79, 0, 35),
					Font = Enum.Font.GothamSemibold,
					Position = UDim2.new(0,5,0,0),
					TextXAlignment = Enum.TextXAlignment.Left,
					Text = Name,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 16.000,
				})

				kb.darkoutline = lib:Create("ImageLabel", {
					Name = "SelectKeyBindFrame",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(1, -153, 0.0857142881, 0),
					Size = UDim2.new(0, 150, 0, 29),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(55, 55, 55),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				kb.kb = lib:Create("TextButton", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					BorderColor3 = Color3.fromRGB(27, 42, 53),
					BorderSizePixel = 0,
					AnchorPoint = Vector2.new(0,0.5),
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 0.758620679, 0),
					Font = Enum.Font.Gotham,
					Text = "None",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 16.000,
					TextWrapped = true,
				})

				local c

				if Default then 
					kbind = Default
					kb.kb.Text = kbind.Name
				end
				local Blacklist = {"W","A","S","D","Slash","Tab","Backspace","Escape","Space","Delete","Unknown","Backquote"}
				local debounce = false
				kb.kb.MouseButton1Click:Connect(function()
					if debounce or lockkey then 
						return
					end
					debounce = true
					kb.kb.Text = "..."
					c = UIS.InputBegan:Connect(function(i)
						if i.UserInputType.Name == "Keyboard" then
							if not table.find(Blacklist, i.KeyCode.Name) then
								kb.kb.Text = i.KeyCode.Name
								kbind = i.KeyCode
								debounce = false
								if c then
									Disconnect(c)
									c = nil
								end
							else
								kb.kb.Text = "None"
								kbind = nil
								if c then
									Disconnect(c)
									c = nil
									debounce = false
								end
							end
						end
					end)
				end)

				Keybinds[Name] = function(v)
					lock = v
				end

				game:GetService("UserInputService").InputBegan:Connect(function(i, GPE)
					if kbind and i.KeyCode == kbind and not GPE and not lock then
						if CallBack then
							SafeCall(`Keybind {Name}`,CallBack,kbind)
						end
					end
				end)

				kb.kbback.Parent = sections.sectioncontainer
				kb.kbtext.Parent = kb.kbback
				kb.darkoutline.Parent = kb.kbback
				kb.kb.Parent = kb.darkoutline

				-->>>[Functions]<<<--

				kb.Lock = function(v: boolean)
					lock = v
				end

				kb.LockKey = function(v: boolean)
					lockkey = v
				end

				kb.ToolTip = function(Text)
					local t = lib:Create('TextButton',{
						Name = "ToolTip",
						BackgroundColor3 = Color3.fromRGB(55, 55, 55),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.new(0.599, 0, 0.086, 0),
						Size = UDim2.new(0, 29, 0, 29),
						Font = Enum.Font.SourceSans,
						Text = "?",
						AutoButtonColor = false,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 24
					})
					t.Parent = kb.kbback
					t.MouseButton1Down:Connect(function()
						MainToolTip.Title.Text = Name
						MainToolTip.Text.Text = Text
						MainToolTip.Holder.Visible = true
					end)
					t.MouseLeave:Connect(function()
						MainToolTip.Holder.Visible = false
					end)
					local c = lib:Create('UICorner',{
						CornerRadius = UDim.new(0, 5)
					})
					c.Parent = t
				end

				return kb
			end

			function sections:DropDown(Name, Options, CallBack)
				local dd = {}
				local toggled = false
				local dvalue = 'None'
				local optionstable = {}
				local Options = Options or {}
				setmetatable(Options,{__index=function(t,i)
					local Defaults = {
						['Playerlist'] = false,
						['NoLocalPlayer'] = true,
						['Default'] = Name or "None",
						['CallBack'] = (function() end),
						--['Options'] = {},
						['List'] = {}
					}
					local v = rawget(t,string.lower(i))
					return (v ~= nil and v) or Defaults[i]
				end})

				if (Options.Options or Options.List) and not Options.Playerlist then
					optionstable = Options.Options or Options.List
				end

				dd.ddback = lib:Create("ImageLabel", {
					Name = Name.."DropDown",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0.00415800419, 0, 0.86175108, 0),
					Size = UDim2.new(0, 484, 0, 35),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(65, 65, 65),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})
				dd.ddback.AutomaticSize = Enum.AutomaticSize.Y

				dd.dddarkoutline = lib:Create("ImageLabel", {
					Name = "DropDownButtonFrame",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 4, 0, 3),
					Size = UDim2.new(0, 476, 0, 29),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(55, 55, 55),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				dd.ddbutton = lib:Create("TextBox", {
					Name = "DropDownButton",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 350, 0, 29),
					Font = Enum.Font.GothamSemibold,
					PlaceholderColor3 = Color3.fromRGB(178, 178, 178),
					PlaceholderText = "Search...",
					Position = UDim2.new(0.5,0,0.5,0),
					Text = '',
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 16.000,
					AnchorPoint = Vector2.new(0.5,0.5)
				})

				dd.ddmp = lib:Create("TextButton", {
					Name = "AnotherDopDownButton",
					BackgroundColor3 = Color3.fromRGB(55, 55, 55),
					BackgroundTransparency = 1.000,
					BorderSizePixel = 0,
					Position = UDim2.new(0.938519001, 0, 0, 0),
					Size = UDim2.new(0, 28, 0, 29),
					AutoButtonColor = false,
					Font = Enum.Font.Gotham,
					Text = "+",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 20.000,
				})

				dd.dd = lib:Create("ImageLabel", {
					Name = "DropDown",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, -4, 0, 35),
					Size = UDim2.new(0, 484, 0, 0),
					ZIndex = 5,
					Visible = false,
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(65, 65, 65),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})
				dd.dd.AutomaticSize = Enum.AutomaticSize.Y

				dd.ddscrolling = lib:Create("Frame", {
					Name = "SectionConatiner",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					BorderSizePixel = 0,
					Position = UDim2.new(0.002, 0, 0, 2),
					Size = UDim2.new(1, 0, 0, 0),
					ZIndex = 5,
				})

				dd.ddscrollinglayout = lib:Create("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 5),
				})

				dd.ddscrollingpadding = lib:Create("UIPadding", {
					PaddingLeft = UDim.new(0,3)
				})

				local function refreshlist()

					for i,v in next, dd.ddscrolling:GetChildren() do
						if v:IsA("ImageLabel") then
							v:Destroy()
						end
					end

					for i,v in next, optionstable do
						local buttonback = lib:Create("ImageLabel", {
							Name = string.lower(v),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1.000,
							Position = UDim2.new(0.009999929, 0, 0.0857142881, 0),
							Size = UDim2.new(0, 476, 0, 29),
							ZIndex = 5,
							Image = "rbxassetid://3570695787",
							ImageColor3 = Color3.fromRGB(55, 55, 55),
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.040,
						})

						local button = lib:Create("TextButton", {
							Name = "Button",
							BackgroundColor3 = Color3.fromRGB(55, 55, 55),
							BackgroundTransparency = 1.000,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(0, 475, 0, 29),
							ZIndex = 5,
							AutoButtonColor = false,
							Font = Enum.Font.GothamSemibold,
							Text = v,
							TextColor3 = Color3.fromRGB(255, 255, 255),
							TextSize = 16.000,
						})

						buttonback.Parent = dd.ddscrolling
						button.Parent = buttonback

						button.MouseButton1Click:Connect(function()
							if toggled then

								toggled = false
								dd.ddbutton.Text = v

								dvalue = v

								dd.ddmp.Text = "+"
								dd.dd.Visible = false
								TweenService:Create(dd.ddscrolling, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 0)}):Play()
								for i,v in next, dd.ddscrolling:GetChildren() do 
									if v:IsA("ImageLabel") then
										v.Visible = true
									end
								end

								if CallBack then
									SafeCall(`DropDown {Name}`,CallBack,dvalue)
								end
							end
						end)
					end
				end

				if Options.Playerlist then
					local pls = game:GetService("Players")
					pls.PlayerAdded:Connect(function(v)
						if not table.find(optionstable,v.Name) then
							table.insert(optionstable,v.Name)
						end
						table.sort(optionstable,function(a,b) return a:lower() < b:lower() end)
						refreshlist()
					end)
					pls.PlayerRemoving:Connect(function(v)
						local i = table.find(optionstable,v.Name)
						if i then
							table.remove(optionstable,i)
						end
						refreshlist()
					end)
					optionstable = {}
					local list = game.Players:GetChildren()
					for i,v in pairs(list) do
						if v:IsA("Player") then
							if (Options.NoLocalPlayer and v ~= game.Players.LocalPlayer) or not Options.NoLocalPlayer then
								table.insert(optionstable, v.Name)
							end
						end
					end
					table.sort(optionstable,function(a,b) return a:lower() < b:lower() end)
				end
				refreshlist()

				dd.ddbutton.Text = Options.Default
				dvalue = Options.Default

				dd.ddbutton.Focused:Connect(function()
					toggled = true
					--refreshlist()
					dd.ddmp.Text = "-"
					dd.dd.Visible = true
					TweenService:Create(dd.ddscrolling, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, dd.ddscrolling["UIListLayout"].AbsoluteContentSize.Y) + UDim2.new(0,0,0,5)}):Play()
				end)

				dd.ddmp.MouseButton1Click:Connect(function()
					toggled = not toggled
					if toggled then 
						--refreshlist()
						dd.ddmp.Text = "-"
						dd.dd.Visible = true
						dd.ddbutton.Text = ''
						TweenService:Create(dd.ddscrolling, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, dd.ddscrolling["UIListLayout"].AbsoluteContentSize.Y) + UDim2.new(0,0,0,5)}):Play()
					else 
						--refreshlist()
						dd.ddmp.Text = "+"
						dd.dd.Visible = false
						if string.gsub(dd.ddbutton.Text,' ','') == '' then
							dd.ddbutton.Text = dvalue
						end
						TweenService:Create(dd.ddscrolling, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 0)}):Play()
					end
				end)

				dd.ddbutton:GetPropertyChangedSignal("Text"):Connect(function()
					local tosearch,count = dd.ddbutton.Text,0
					for i,v in next, dd.ddscrolling:GetChildren() do 
						if v:IsA("ImageLabel") then
							if v.Name:find(tosearch:lower()) then
								v.Visible = true 
								count=count+1
							else 
								v.Visible = false
							end
						end
					end
					TweenService:Create(dd.ddscrolling, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, count*34)}):Play()
				end)

				dd.ddback.Parent = sections.sectioncontainer
				dd.dddarkoutline.Parent = dd.ddback
				dd.ddbutton.Parent = dd.dddarkoutline
				dd.ddmp.Parent = dd.dddarkoutline
				dd.dd.Parent = dd.dddarkoutline
				dd.ddscrolling.Parent = dd.dd
				dd.ddscrollinglayout.Parent = dd.ddscrolling
				dd.ddscrollingpadding.Parent = dd.ddscrolling

				return {
					SetCurrent = function(v)
						dd.ddbutton.Text = v
						dvalue = v

						if CallBack then
							SafeCall(`DropDown {Name}`,CallBack,dvalue)
						end
					end,
					Refresh = function(v)
						if not Options.Playerlist then
							optionstable = v or {}
							refreshlist()
						end
					end,
					ClearOptions = function()
						for i,v in next, dd.ddscrolling:GetChildren() do
							if v:IsA("ImageLabel") then
								v:Destroy()
							end
						end
					end,
					AddOption = function(text, callback)
						local buttonback = lib:Create("ImageLabel", {
							Name = string.lower(text),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1.000,
							Position = UDim2.new(0.009999929, 0, 0.0857142881, 0),
							Size = UDim2.new(0, 476, 0, 29),
							ZIndex = 5,
							Image = "rbxassetid://3570695787",
							ImageColor3 = Color3.fromRGB(55, 55, 55),
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.040,
						})

						local button = lib:Create("TextButton", {
							Name = "Button",
							BackgroundColor3 = Color3.fromRGB(55, 55, 55),
							BackgroundTransparency = 1.000,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(0, 475, 0, 29),
							ZIndex = 5,
							AutoButtonColor = false,
							Font = Enum.Font.GothamSemibold,
							Text = text,
							TextColor3 = Color3.fromRGB(255, 255, 255),
							TextSize = 16.000,
						})

						buttonback.Parent = dd.ddscrolling
						button.Parent = buttonback

						button.MouseButton1Click:Connect(function()
							if toggled then

								toggled = false
								dd.ddbutton.Text = text

								dvalue = text

								dd.ddmp.Text = "+"
								dd.dd.Visible = false
								TweenService:Create(dd.ddscrolling, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 0)}):Play()
								for i,v in next, dd.ddscrolling:GetChildren() do 
									if v:IsA("ImageLabel") then
										v.Visible = true
									end
								end

								if callback then
									SafeCall(`DropDown {Name} | AddOption {text}`,callback,dvalue)
								end
							end
						end)
						return {
							TextColor = function(col: Color3)
								button.TextColor3 = col
							end,
						}
					end,
				}
			end 

			function sections:ColorPicker(Name, Default, CallBack)
				local colorstuff = {}
				local colorpickeropend = false
				local colorvalue

				colorstuff.colorpickerb = lib:Create("ImageButton", {
					BackgroundColor3 = Color3.fromRGB(55,55,55),
					BackgroundTransparency = 1.000,
					BorderColor3 = Color3.fromRGB(27, 42, 53),
					Position = UDim2.new(0, 11, 0, 125),
					Size = UDim2.new(0, 484, 0, 35),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(65, 65, 65),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				colorstuff.colorpickerbgray = lib:Create("ImageLabel", {
					Name = "ColorpickDarkframe",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0.309917361, 0, 0.0857142881, 0),
					Size = UDim2.new(0, 330, 0, 29),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(55, 55, 55),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				colorstuff.colorpickertext = lib:Create("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 4, 0, 2),
					Size = UDim2.new(0, 200, 0, 30),
					Font = Enum.Font.GothamSemibold,
					Text = Name,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 16.000,
					TextXAlignment = Enum.TextXAlignment.Left,
				})

				colorstuff.colorpickerbutton = lib:Create("ImageLabel", {
					Active = true,
					BackgroundColor3 = Color3.fromRGB(248, 248, 248),
					BackgroundTransparency = 1.000,
					BorderSizePixel = 0,
					Position = UDim2.new(0.0185848344, 0, 0.137931034, 0),
					Selectable = true,
					Size = UDim2.new(0, 318, 0, 21),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(255, 0, 4),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				colorstuff.colorpickerframeb = lib:Create("Frame", {
					Name = "colorframe",
					BackgroundColor3 = Color3.fromRGB(46, 46, 54),
					BorderSizePixel = 0,
					Position = UDim2.new(0, 560, 0, 0),
					Size = UDim2.new(0, 0, 0, 180),
					BackgroundTransparency = 1,
				})
				colorstuff.colorpickerframeb.ClipsDescendants = true

				colorstuff.colorpickerframe = lib:Create("Frame", {
					BackgroundColor3 = Color3.fromRGB(46, 46, 54),
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(0, 190, 0, 180),                            
				})
				colorstuff.colorpickerframe.ClipsDescendants = true

				colorstuff.rback = lib:Create("ImageLabel", {
					Active = true,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 35, 0, 165),
					Selectable = true,
					Size = UDim2.new(0, 50, 0, 20),
					ZIndex = 2,
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(40,40,40),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				colorstuff.rvalue = lib:Create("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 18, 0, 3),
					Size = UDim2.new(0, 25, 0, 15),
					ZIndex = 2,
					Font = Enum.Font.GothamBold,
					Text = "255",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 11.000,
				})

				colorstuff.rtext = lib:Create("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 4, 0, 3),
					Size = UDim2.new(0, 15, 0, 15),
					ZIndex = 2,
					Font = Enum.Font.GothamBold,
					Text = "R:",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 14.000,
				})

				colorstuff.gback = lib:Create("ImageLabel", {
					Active = true,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					BorderSizePixel = 0,
					Position = UDim2.new(0.5, 0, 0, 165),
					Selectable = true,
					Size = UDim2.new(0, 50, 0, 20),
					ZIndex = 2,
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(40,40,40),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				colorstuff.gvalue = lib:Create("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 18, 0, 3),
					Size = UDim2.new(0, 25, 0, 15),
					ZIndex = 2,
					Font = Enum.Font.GothamBold,
					Text = "255",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 11.000,
				})

				colorstuff.gtext = lib:Create("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 4, 0, 3),
					Size = UDim2.new(0, 15, 0, 15),
					ZIndex = 2,
					Font = Enum.Font.GothamBold,
					Text = "G:",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 14.000,
					TextWrapped = true,
				})

				colorstuff.bback = lib:Create("ImageLabel", {
					Active = true,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 155, 0, 165),
					Selectable = true,
					Size = UDim2.new(0, 50, 0, 20),
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(40,40,40),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(100, 100, 100, 100),
					SliceScale = 0.040,
				})

				colorstuff.bvalue = lib:Create("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 18, 0, 3),
					Size = UDim2.new(0, 25, 0, 15),
					ZIndex = 2,
					Font = Enum.Font.GothamBold,
					Text = "255",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 11.000,
				})

				colorstuff.btext = lib:Create("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 4, 0, 3),
					Size = UDim2.new(0, 15, 0, 15),
					ZIndex = 2,
					Font = Enum.Font.GothamBold,
					Text = "B:",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 14.000,
				})

				colorstuff.sback = lib:Create("ImageLabel", {
					BackgroundColor3 = Color3.fromRGB(46, 46, 54),
					BackgroundTransparency = 1.000,
					BorderSizePixel = 0,
					Position = UDim2.new(0.0469999984, 0, 0, 10),
					Size = UDim2.new(0, 140, 0, 140),
					ZIndex = 2,
					Image = "rbxassetid://4695575676",
					ImageColor3 = Color3.fromRGB(46, 46, 54),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(128, 128, 128, 128),
					SliceScale = 0.040,
				})

				colorstuff.sat = lib:Create("ImageButton", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderColor3 = Color3.fromRGB(221, 221, 221),
					BorderSizePixel = 0,
					Size = UDim2.new(0, 140, 0, 140),
					AutoButtonColor = false,
					Image = "http://www.roblox.com/asset/?id=5113592272",
					ImageColor3 = Color3.fromRGB(255, 0, 0),
				})

				colorstuff.light = lib:Create("ImageLabel", {
					BackgroundTransparency = 1.000,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					Image = "http://www.roblox.com/asset/?id=5113600420",
				})

				colorstuff.ring = lib:Create("ImageLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 140, 0, 0),
					Size = UDim2.new(0, 10, 0, 10),
					SizeConstraint = Enum.SizeConstraint.RelativeYY,
					ZIndex = 5,
					Image = "rbxassetid://244221613",
					ImageColor3 = Color3.fromRGB(0, 0, 0),
				})

				colorstuff.rainbowback = lib:Create("ImageLabel", {
					BackgroundColor3 = Color3.fromRGB(46, 46, 54),
					BackgroundTransparency = 1.000,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 160, 0, 10),
					Size = UDim2.new(0, 20, 0, 140),
					ZIndex = 2,
					Image = "rbxassetid://4695575676",
					ImageColor3 = Color3.fromRGB(46, 46, 54),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(128, 128, 128, 128),
					SliceScale = 0.040,
				})

				colorstuff.rainbow = lib:Create("ImageButton", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 20, 0, 140),
					Image = "http://www.roblox.com/asset/?id=5118428654",
				})

				colorstuff.rainbowlocation = lib:Create("Frame", {
					BackgroundColor3 = Color3.fromRGB(23, 23, 23),
					BorderSizePixel = 0,
					Size = UDim2.new(0, 20, 0, 2),
				})

				colorstuff.colorpickerframeb.Parent = main.MainBody
				colorstuff.colorpickerframe.Parent = colorstuff.colorpickerframeb
				colorstuff.rback.Parent = colorstuff.colorpickerframe
				colorstuff.rtext.Parent = colorstuff.rback
				colorstuff.rvalue.Parent = colorstuff.rback
				colorstuff.gback.Parent = colorstuff.colorpickerframe
				colorstuff.gtext.Parent = colorstuff.gback
				colorstuff.gvalue.Parent = colorstuff.gback
				colorstuff.bback.Parent = colorstuff.colorpickerframe
				colorstuff.btext.Parent = colorstuff.bback
				colorstuff.bvalue.Parent = colorstuff.bback
				colorstuff.sback.Parent = colorstuff.colorpickerframe
				colorstuff.sat.Parent = colorstuff.sback
				colorstuff.light.Parent = colorstuff.sat
				colorstuff.ring.Parent = colorstuff.sat
				colorstuff.rainbowback.Parent = colorstuff.colorpickerframe
				colorstuff.rainbow.Parent = colorstuff.rainbowback
				colorstuff.rainbowlocation.Parent = colorstuff.rainbow

				colorstuff.colorpickerb.Parent = sections.sectioncontainer
				colorstuff.colorpickerbgray.Parent = colorstuff.colorpickerb
				colorstuff.colorpickertext.Parent = colorstuff.colorpickerb
				colorstuff.colorpickerbutton.Parent = colorstuff.colorpickerbgray

				colorstuff.colorpickerb.MouseButton1Click:Connect(function()
					colorpickeropend = not colorpickeropend

					for i,v in pairs(main.MainBody:GetChildren()) do
						if v.Name == "colorframe" then
							game:GetService("TweenService"):Create(v, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 205)}):Play()
						end
					end

					if colorpickeropend then 
						game:GetService("TweenService"):Create(colorstuff.colorpickerframeb, TweenInfo.new(0.3), {Size = UDim2.new(0, 190, 0, 205)}):Play()
					end
				end)


				local colorbase = Color3.new(1,0,0)
				colorvalue = colorbase
				local Saturation = 1
				local Darkness = 0
				local colourPickColour = colorbase

				local function UpdateColorPicker()

					colourPickColour = colorbase

					if Darkness == 1 then
						colourPickColour = Color3.new(0,0,0)
						return
					end

					if Saturation < 1 then
						local r = math.clamp(1 + (colourPickColour.r - 1) * Saturation, 0, 1)
						local g = math.clamp(1 + (colourPickColour.g - 1) * Saturation, 0, 1)
						local b = math.clamp(1 + (colourPickColour.b - 1) * Saturation, 0, 1)
						colourPickColour = Color3.new( r, g, b )
					end

					if Darkness > 0 then 
						local r = math.clamp(colourPickColour.r * (1 - Darkness ), 0, 1)
						local g = math.clamp(colourPickColour.g * (1 - Darkness ), 0, 1)
						local b = math.clamp(colourPickColour.b * (1 - Darkness ), 0, 1)
						colourPickColour = Color3.new(r,g,b)
					end

					colorstuff.rvalue.Text = tostring(math.floor(colourPickColour.r * 255))
					colorstuff.gvalue.Text = tostring(math.floor(colourPickColour.g * 255))
					colorstuff.bvalue.Text = tostring(math.floor(colourPickColour.b * 255))

					local rv = tonumber(colorstuff.rvalue.Text)
					local gv = tonumber(colorstuff.gvalue.Text)
					local bv = tonumber(colorstuff.bvalue.Text)

					colorvalue = Color3.fromRGB(rv,gv,bv)

					colorstuff.colorpickerbutton.ImageColor3 = colourPickColour

					if CallBack then
						SafeCall(`ColorPicker {Name}`,CallBack,colorvalue)
					end
				end

				if Default then
					local Default = Color3.fromHSV(Color3.toHSV(Default))
					local r,g,b = math.floor(Default.r * 255),math.floor(Default.g * 255),math.floor(Default.b * 255)
					colorbase = Color3.fromRGB(r,g,b)
					colorstuff.sat.ImageColor3 = colorbase
					UpdateColorPicker()
				end

				local function setPickerColor(y)
					local rY = y - colorstuff.rainbow.AbsolutePosition.Y;
					local cY = math.clamp(rY, 0, colorstuff.rainbow.AbsoluteSize.Y - colorstuff.rainbowlocation.AbsoluteSize.Y);
					local offset = (y - colorstuff.rainbow.AbsolutePosition.Y) - colorstuff.rainbowlocation.AbsoluteSize.Y
					local scale = offset / colorstuff.rainbow.AbsoluteSize.Y
					TweenService:Create(colorstuff.rainbowlocation, TweenInfo.new(0.1), {Position = UDim2.new(0, 0, 0, cY)}):Play()
					local color = Color3.fromHSV(math.clamp(scale, 0, 1), 1, 1)
					local r,g,b = math.floor(color.r * 255), math.floor(color.g * 255), math.floor(color.b * 255)
					colorbase = Color3.fromRGB(r,g,b)

					colorstuff.sat.ImageColor3 = colorbase
					UpdateColorPicker()
				end

				local function setPickerLight(x,y)
					Saturation = x / 140
					Darkness = y / 140

					TweenService:Create(colorstuff.ring, TweenInfo.new(0.1), {Position = UDim2.new(0, x, 0, y)}):Play()

					UpdateColorPicker()
				end

				local rc
				local cc

				UIS.InputEnded:Connect(function(Mouse)
					if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then
						if(cc) then
							Disconnect(cc)
							cc = nil
						end
						if(rc) then 
							Disconnect(rc)
							rc = nil
						end
					end
				end)

				local rainbow = false

				colorstuff.rainbow.MouseButton1Down:Connect(function()
					if not rainbow then 
						rc = game:GetService("RunService").Heartbeat:Connect(function()
							setPickerColor(Mouse.Y)
						end)
					end
				end)

				colorstuff.sat.MouseButton1Down:Connect(function()
					cc = game:GetService("RunService").Heartbeat:Connect(function()
						local v = game:GetService("GuiService"):GetGuiInset()
						local y = math.clamp(Mouse.Y - colorstuff.sat.AbsolutePosition.Y - v.y + 34, 0, 140 )
						local x = math.clamp(Mouse.X - colorstuff.sat.AbsolutePosition.X - v.x, 0, 140 )
						setPickerLight(x,y)
					end)
				end)

				local returns = {}

				returns.SetColor = function(color: Color3)
					local Default = Color3.fromHSV(Color3.toHSV(color))
					local r,g,b = math.floor(Default.r * 255),math.floor(Default.g * 255),math.floor(Default.b * 255)
					colorbase = Color3.fromRGB(r,g,b)
					colorstuff.sat.ImageColor3 = colorbase
					UpdateColorPicker()
				end

				return returns
			end

			return sections
		end

		main.CategoryContainer.CanvasSize = main.CategoryContainer.CanvasSize + UDim2.new(0,0,0,53)

		categories.Button.Parent = main.CategoryContainer
		categories.Container.Parent = main.MainBody
		categories.ContainerLayout.Parent = categories.Container
		categories.ContainerPadding.Parent = categories.Container

		firstC = false

		return categories
	end

	if mainsettings.CloseButton then
		main.Close.MouseButton1Click:Connect(function()
			game:GetService('CoreGui').Ancestor:Destroy()
			game:GetService('CoreGui').AncestorNotify:Destroy()
			game:GetService('CoreGui').AncestorToolTip:Destroy()
			if game:GetService('CoreGui'):FindFirstChild('AncestorMobile') then
				game:GetService('CoreGui').AncestorMobile:Destroy()
			end
			mainsettings.CloseCall()
		end)
	end

	main.ScreenGui.Parent = game:GetService('CoreGui')
	main.MainBody.Parent = main.ScreenGui
	main.TopBar.Parent = main.MainBody
	main.TopBarGradient.Parent = main.TopBar
	main.LogoTextFolder.Parent = main.TopBar
	main.LogoText1.Parent = main.LogoTextFolder
	main.LogoText2.Parent = main.LogoTextFolder
	main.LogoText3.Parent = main.LogoTextFolder
	main.LogoText4.Parent = main.LogoTextFolder
	main.LogoText5.Parent = main.LogoTextFolder
	main.CategoryContainer.Parent = main.MainBody
	main.CategoryPadding.Parent = main.CategoryContainer
	main.CategoryLayout.Parent = main.CategoryContainer

	return main
end

return lib
