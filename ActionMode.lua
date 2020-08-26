local ActionModeActive = false
local ActionCamActive = false
local mouseActions = {
	ActionMode1 = "/targetenemy",
	ActionMode2 = "/cleartarget",
	ActionMode3 = "/targetfriend"
}
local ActionCamOptions = {
	"test_cameraOverShoulder",
	"test_cameraTargetFocusEnemyEnable",
	"test_cameraTargetFocusEnemyStrengthPitch",
	"test_cameraTargetFocusEnemyStrengthYaw",
	"test_cameraTargetFocusInteractEnable",
	"test_cameraTargetFocusInteractStrengthPitch",
	"test_cameraTargetFocusInteractStrengthYaw",
	"test_cameraHeadMovementStrength",
	"test_cameraHeadMovementRangeScale",
	"test_cameraHeadMovementMovingStrength",
	"test_cameraHeadMovementStandingStrength",
	"test_cameraHeadMovementMovingDampRate",
	"test_cameraHeadMovementStandingDampRate",
	"test_cameraHeadMovementFirstPersonDampRate",
	"test_cameraHeadMovementDeadZone",
	"test_cameraDynamicPitch",
	"test_cameraDynamicPitchBaseFovPad",
	"test_cameraDynamicPitchBaseFovPadFlying",
	"test_cameraDynamicPitchBaseFovPadDownScale",
	"test_cameraDynamicPitchSmartPivotCutoffDist"
}

function CheckMacro()
	for key, val in pairs(mouseActions) do
		local name, texture, body = GetMacroInfo(key)
		if (name == nil) then
			local macroId = CreateMacro(key, "INV_MISC_QUESTIONMARK", val, 1, nil);
		end
	end
end

function ActionModeToggle()
	if (ActionModeActive == false) then
		ActionModeActive = true
		MouselookStart()
	else
		ActionModeActive = false
		MouselookStop()
	end
end

--[[function ActionCamToggle()
	if (ActionCamActive == false) then
		ActionCamActive = true
		SetCVar("test_cameraOverShoulder", true)
		ActionModeConfig["test_cameraOverShoulder"] = true
	else
		ActionCamActive = false
		SetCVar("test_cameraOverShoulder", false)
	end
end]]

--[[function MouseDown(click, button, down)
	if (ActionMode == true) then
		if (button == "LeftButton") then
			local name, texture, body = GetMacroInfo("EMPTY")
			print(name)
			print(texture) --134400
			print(body)
		end
	end
end]]

function ActionModeOnLoad()
	--WorldFrame:SetScript("OnMouseDown", MouseDown)
	CheckMacro()
	SetMouselookOverrideBinding("BUTTON1", "MACRO ActionMode1")
	SetMouselookOverrideBinding("BUTTON2", "MACRO ActionMode2")
	SetMouselookOverrideBinding("BUTTON3", "MACRO ActionMode3")
end

function ScrollFrame_OnMouseWheel(self, delta)
	local newValue = self:GetVerticalScroll() - (delta * 50)
	if (newValue < 0) then
		newValue = 0
	elseif (newValue > self:GetVerticalScrollRange()) then
		newValue = self:GetVerticalScrollRange()
	end
	self:SetVerticalScroll(math.floor(newValue))
end

function ActionModeOnEvent(event)
	if (event == "EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED") then
		StaticPopup_Hide("EXPERIMENTAL_CVAR_WARNING")
	end
	if (event == "PLAYER_ENTERING_WORLD") then
		ActionCamInit()
	end
end

function ActionCamInit()
	if (not ActionModeConfig) then
		ActionModeConfig = {}
	end

	local settings = CreateFrame("ScrollFrame", "ActionModeSettings", UIParent, "UIPanelScrollFrameTemplate")
	settings.name = "ActionMode"
	settings.ScrollBar:ClearAllPoints();
	settings.ScrollBar:SetPoint("TOPLEFT", settings, "TOPRIGHT", -13, -21);
	settings.ScrollBar:SetPoint("BOTTOMRIGHT", settings, "BOTTOMRIGHT", -13, 20);
	settings:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel)
	settings:SetSize(100, 100)
	settings:SetPoint("CENTER")
	settings:SetClipsChildren(true)
	settings:EnableMouse(true)
	settings:EnableMouseWheel(true)
	settings:Hide()

	local child = CreateFrame("Frame", nil, settings)
	child:SetSize(100, 100)
	child:SetPoint("CENTER")
	settings:SetScrollChild(child)

	for i, option in ipairs(ActionCamOptions) do
		settings[option] = CreateFrame("CheckButton", nil, child, "UICheckButtonTemplate")
		settings[option].text:SetText(option)
		settings[option]:SetPoint("TOPLEFT", 25, i * -25)

		if (not ActionModeConfig[option]) then
			ActionModeConfig[option] = "off"
			SetCVar(option, false)
		elseif (ActionModeConfig[option] == "on") then
			settings[option]:SetChecked(true)
			SetCVar(option, true)
		else
			settings[option]:SetChecked(false)
			SetCVar(option, false)
		end

		settings[option]:SetScript("OnClick", 
			function(self)
				if (self:GetChecked() == true) then
					ActionModeConfig[option] = "on"
					SetCVar(option, true)
				else
					ActionModeConfig[option] = "off"
					SetCVar(option, false)
				end
			end
		)
	end
	
	InterfaceOptions_AddCategory(settings)

	--[[if (GetCVar("test_cameraOverShoulder") == "0") then
		ActionCamActive = false
	else
		ActionCamActive = true
	end]]
end

--[[function ActionModeViewCheck()
	if (ActionModeActive == true) then
		MouselookStart()
	end
end

local update = 0
local updateTrigger = 50
local firstUpdate = true
function ActionModeOnUpdate()
	if (update > updateTrigger) then
		ActionModeViewCheck()
		updateTrigger = updateTrigger + 50
		if (firstUpdate == true) then
			firstUpdate = false
			local frameCounter = 0
			local frame = EnumerateFrames()
			while frame do
				if ( frame:IsVisible() and frame:IsProtected() ) then
					frameCounter = frameCounter + 1
					print(frame:GetID())
				end
				frame = EnumerateFrames(frame)
			end
			print(frameCounter)
		end
	end
	update = update + 1
end]]