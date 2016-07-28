local name, addon = ...

--Default Load Function triggered by XML
function SnodderbackUI_OnLoad(self)
	--Setup Slash Commands
	SLASH_SNODDERBACK1 = "/snod";
	SLASH_SNODDERBACK2 = "/snodderback";
	SlashCmdList["SNODDERBACK"] = SnodderbackUI_ParseSlashArguments;
	
	--Register Events
	SnodderbackUI_Frame:RegisterEvent("PLAYER_LOGIN");
	SnodderbackUI_Frame:RegisterEvent("ADDON_LOADED");
	SnodderbackUI_Frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	SnodderbackUI_Frame:RegisterEvent("GROUP_ROSTER_UPDATE")
	SnodderbackUI_Frame:RegisterEvent("PLAYER_TARGET_CHANGED")
	SnodderbackUI_Frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
	SnodderbackUI_Frame:RegisterEvent("UNIT_FACTION")
end

--Parse Events
function SnodderbackUI_OnEvent(self, event, ...)
	local arg1, arg2 = ...;
	if ( event == "PLAYER_LOGIN") then
		ChatFrame1:AddMessage('Welcome to |cFFC79C6ESnodderbackUI|r, '..UnitName("Player")..'!\nUse /snodderback for help.');
		SnodderbackUI_Frame:UnregisterEvent("PLAYER_LOGIN");
		SnodderbackUI_AdjustUI();
	end
	if ( event == "ADDON_LOADED" and name == arg1 ) then
		SnodderbackUI_OnInitialize();
	end
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		SnodderbackUI_AdjustUI();
	end
end

--Initialize Function to get Values from SavedVariables
function SnodderbackUI_OnInitialize()
	if( SnodderbackUI_Global == nil ) then
		--First time you log in save default values to SnodderbackUI_Global
		print("Default values assigned..");
		SnodderbackUI_Global = {}
		SnodderbackUI_Global["PLAYER_INFO"] = {}
		SnodderbackUI_Global["PLAYER_INFO"]["RELATIVE_TO"] = "CENTER"
		SnodderbackUI_Global["PLAYER_INFO"]["X"] = -250
		SnodderbackUI_Global["PLAYER_INFO"]["Y"] = -100
		SnodderbackUI_Global["PLAYER_INFO"]["SCALE"] = 1.3
		SnodderbackUI_Global["PLAYER_INFO"]["PORTRAIT"] = "PORTRAIT"
		SnodderbackUI_Global["TARGET_INFO"] = {}
		SnodderbackUI_Global["TARGET_INFO"]["RELATIVE_TO"] = "CENTER"
		SnodderbackUI_Global["TARGET_INFO"]["X"] = 250
		SnodderbackUI_Global["TARGET_INFO"]["Y"] = -100
		SnodderbackUI_Global["TARGET_INFO"]["SCALE"] = 1.3
		SnodderbackUI_Global["TARGET_INFO"]["PORTRAIT"] = "CLASS"
		--Adjust the UI
	else 
		print('SnodderbackUI loaded..')
	end
end

--example /snodderback target_x 55
function SnodderbackUI_ParseSlashArguments( msg )
	local argument = string.upper(msg);
	
	local command_list = { 
		"HELP",
		"TARGET_X",
		"TARGET_X",
		"TARGET_SCALE",
		"TARGET_PORTRAIT_TOGGLE",
		"PLAYER_X",
		"PLAYER_Y",
		"PLAYER_SCALE",
		"PLAYER_PORTRAIT_TOGGLE",
		"PRINT"
	}

	local command, value = argument:match("^(%S*)%s*(.-)$");
	
	local valid_command = 0;
	local value_is_number = 0;
	--check tier 1 command
	for _,v in pairs(command_list) do
		if v == command then
			valid_command = 1;
			break
		end
	end
	--check if value is a number
	if tonumber(value) ~= nil then
		value_is_number = 1
	end;
	
	if valid_command == 0 then
		print("Syntax: /snodderback command value\nUse /snodderback help for a list of commands.");
		return
	else	
		if command == "PRINT" then
			print("SnodderbackUI - Values\n");
			print("Player: ");
			print(" - Relative to " .. SnodderbackUI_Global["PLAYER_INFO"]["RELATIVE_TO"]);
			print(" - X = " .. SnodderbackUI_Global["PLAYER_INFO"]["X"]);
			print(" - Y = " .. SnodderbackUI_Global["PLAYER_INFO"]["Y"]);
			print(" - Scale = " .. SnodderbackUI_Global["PLAYER_INFO"]["SCALE"]);
			print(" - Portrait = " .. SnodderbackUI_Global["PLAYER_INFO"]["PORTRAIT"]);
			print("Target:");
			print(" - Relative to = " .. SnodderbackUI_Global["TARGET_INFO"]["RELATIVE_TO"]);
			print(" - X = " .. SnodderbackUI_Global["TARGET_INFO"]["X"]);
			print(" - Y = " .. SnodderbackUI_Global["TARGET_INFO"]["Y"]);
			print(" - Scale = " .. SnodderbackUI_Global["TARGET_INFO"]["SCALE"]);
			print(" - Portrait = " .. SnodderbackUI_Global["TARGET_INFO"]["PORTRAIT"]);
		end
			
		if command == "HELP" then
			print("SnodderbackUI - Help\n");
			print("Command List:\n - TARGET_X <n>\n - TARGET_Y <n>\n - TARGET_SCALE <n>\n - TARGET_PORTRAIT_TOGGLE\n - PLAYER_X <n>\n - PLAYER_Y <n>\n - PLAYER_SCALE <n>\n - PLAYER_PORTRAIT_TOGGLE")
			return;
		end
		
		if command == "TARGET_X" and value_is_number == 1 then
			SnodderbackUI_Global["TARGET_INFO"]["X"] = tonumber(value);
		end
		if command == "TARGET_Y" and value_is_number == 1 then
			SnodderbackUI_Global["TARGET_INFO"]["Y"] = tonumber(value);
		end
		if command == "TARGET_SCALE" and value_is_number == 1 then
			SnodderbackUI_Global["TARGET_INFO"]["SCALE"] = tonumber(value);
		end
		if command == "PLAYER_X" and value_is_number == 1 then 
			SnodderbackUI_Global["PLAYER_INFO"]["X"] = tonumber(value);
		end
		if command == "PLAYER_Y" and value_is_number == 1 then
			SnodderbackUI_Global["PLAYER_INFO"]["Y"] = tonumber(value);
		end
		if command == "PLAYER_SCALE" and value_is_number == 1 then
			SnodderbackUI_Global["PLAYER_INFO"]["SCALE"] = tonumber(value);
		end
		if command == "PLAYER_PORTRAIT_TOGGLE" then
			if SnodderbackUI_Global["PLAYER_INFO"]["PORTRAIT"] == "CLASS" then
				SnodderbackUI_Global["PLAYER_INFO"]["PORTRAIT"] = "PORTRAIT"
			else
				SnodderbackUI_Global["PLAYER_INFO"]["PORTRAIT"] = "CLASS"
			end
			SnodderbackUI_ReloadPortrait();
		end
		if command == "TARGET_PORTRAIT_TOGGLE" then
			if SnodderbackUI_Global["TARGET_INFO"]["PORTRAIT"] == "CLASS" then
				SnodderbackUI_Global["TARGET_INFO"]["PORTRAIT"] = "PORTRAIT"
			else
				SnodderbackUI_Global["TARGET_INFO"]["PORTRAIT"] = "CLASS"
			end
			SnodderbackUI_ReloadPortrait();
		end
		SnodderbackUI_AdjustUI();
	end
	
end

function SnodderbackUI_AdjustUI()
	PlayerFrame:ClearAllPoints()
	PlayerFrame:SetPoint(SnodderbackUI_Global["PLAYER_INFO"]["RELATIVE_TO"],
						 tonumber(SnodderbackUI_Global["PLAYER_INFO"]["X"]),
						 tonumber(SnodderbackUI_Global["PLAYER_INFO"]["Y"]))
	PlayerFrame:SetScale(tonumber(SnodderbackUI_Global["PLAYER_INFO"]["SCALE"]))
	--PlayerFrame:SetUserPlaced(true)

	TargetFrame:ClearAllPoints()
	TargetFrame:SetPoint(SnodderbackUI_Global["TARGET_INFO"]["RELATIVE_TO"],
						 tonumber(SnodderbackUI_Global["TARGET_INFO"]["X"]),
						 tonumber(SnodderbackUI_Global["TARGET_INFO"]["Y"]))
	TargetFrame:SetScale(tonumber(SnodderbackUI_Global["TARGET_INFO"]["SCALE"]))
end

function SnodderbackUI_ClassColorBackground(self, event, ...)
	if UnitIsPlayer("target") then
		c = RAID_CLASS_COLORS[select(2, UnitClass("target"))]
		TargetFrameNameBackground:SetVertexColor(c.r, c.g, c.b)
	end
	if UnitIsPlayer("focus") then
		c = RAID_CLASS_COLORS[select(2, UnitClass("focus"))]
		FocusFrameNameBackground:SetVertexColor(c.r, c.g, c.b)
	end
	
	for _, BarTextures in pairs({TargetFrameNameBackground, FocusFrameNameBackground}) do
		BarTextures:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
	end
end

function SnodderbackUI_ReloadPortrait()
	local player_as_class = 0;
	local target_as_class = 0;
	if SnodderbackUI_Global["PLAYER_INFO"]["PORTRAIT"] == "CLASS" then
		player_as_class = 1;
	end
	if SnodderbackUI_Global["TARGET_INFO"]["PORTRAIT"] == "CLASS" then
		target_as_class = 1;
	end

	SnodderbackUI_ResetPortrait(PlayerFrame      , "player", player_as_class);
	SnodderbackUI_ResetPortrait(TargetFrame      , "target", target_as_class);
	SnodderbackUI_ResetPortrait(PartyMemberFrame1, "party1", target_as_class);
	SnodderbackUI_ResetPortrait(PartyMemberFrame2, "party2", target_as_class);
	SnodderbackUI_ResetPortrait(PartyMemberFrame3, "party3", target_as_class);
	SnodderbackUI_ResetPortrait(PartyMemberFrame4, "party4", target_as_class);
	SnodderbackUI_ResetPortrait(PartyMemberFrame5, "party5", target_as_class);
end

function SnodderbackUI_ResetPortrait(frame, player, as_class)
	if frame == nil or frame.portrait == nil then
		return
	end
	
	if as_class == 1 then
		SnodderbackUI_Portrait(frame);
	else
		SetPortraitTexture(frame.portrait, player);
		frame.portrait:SetTexCoord(0,1,0,1);
	end
end

function SnodderbackUI_Portrait(self)
    if self.portrait then
        if UnitIsPlayer(self.unit) then 
			--if self.unit == player
			if 
				( 
					self.unit == "player" and 
					SnodderbackUI_Global["PLAYER_INFO"]["PORTRAIT"] == "CLASS" 
				) 
				or
				(
					(
						self.unit == "target" or 
						self.unit == "focus" or 
						self.unit:sub(1,5) == "party"
					) 
					and 
					SnodderbackUI_Global["TARGET_INFO"]["PORTRAIT"] == "CLASS" 
				)
			then
				local t = CLASS_ICON_TCOORDS[select(2,UnitClass(self.unit))]
				if t then
					self.portrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
					self.portrait:SetTexCoord(unpack(t))
				end
			else
				self.portrait:SetTexCoord(0,1,0,1)
			end
        else
            self.portrait:SetTexCoord(0,1,0,1)
        end
    end
end
hooksecurefunc("UnitFramePortrait_Update", SnodderbackUI_Portrait);

function SnodderbackUI_ClassColorHealthbar(statusbar, unit)
	local _, class, c
	if UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and UnitClass(unit) then
		_, class = UnitClass(unit)
		c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
		statusbar:SetStatusBarColor(c.r, c.g, c.b)
		PlayerFrameHealthBar:SetStatusBarColor(0,1,0)
	end
end

function SnodderbackUI_ClassColorHealthbar_Helper(self)
	SnodderbackUI_ClassColorHealthbar(self, self.unit)
end

hooksecurefunc("UnitFrameHealthBar_Update", SnodderbackUI_ClassColorHealthbar)
hooksecurefunc("HealthBar_OnValueChanged", SnodderbackUI_ClassColorHealthbar_Helper)

function SnodderbackUI_HealthbarTextFormatting(statusFrame, textString, value, valueMin, valueMax)
	statusFrame.TextString:SetText(AbbreviateLargeNumbers(value))
end
hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", SnodderbackUI_HealthbarTextFormatting)


--Config Related Stuff 
function SnodderbackUI_Config_OnLoad(self)
	SnodderbackUI_ConfigFrame.name = "Snodderback UI Config"
	SnodderbackUI_ConfigFrame.okay = SnodderbackUI_SaveAllVariables;
	InterfaceOptions_AddCategory(SnodderbackUI_ConfigFrame);
end

function SnodderbackUI_SaveAllVariables()
	SnodderbackUI_Global["PLAYER_INFO"]["X"] = 		tonumber(SnodderbackUI_ConfigFrame_PlayerX_Input:GetText());
	SnodderbackUI_Global["PLAYER_INFO"]["Y"] = 		tonumber(SnodderbackUI_ConfigFrame_PlayerY_Input:GetText());
	SnodderbackUI_Global["PLAYER_INFO"]["SCALE"] = 	tonumber(SnodderbackUI_ConfigFrame_PlayerScale_Input:GetText());
	SnodderbackUI_Global["TARGET_INFO"]["X"] = 		tonumber(SnodderbackUI_ConfigFrame_TargetX_Input:GetText());
	SnodderbackUI_Global["TARGET_INFO"]["Y"] = 		tonumber(SnodderbackUI_ConfigFrame_TargetY_Input:GetText());
	SnodderbackUI_Global["TARGET_INFO"]["SCALE"] = 	tonumber(SnodderbackUI_ConfigFrame_TargetScale_Input:GetText());
	
	SnodderbackUI_ReloadPortrait();
	SnodderbackUI_AdjustUI();
end

function SnodderbackUI_ConfigFrame_PlayerClassPortrait_OnClick(self, button, down)
	SnodderbackUI_Config_HandleClassPortrait(self,"PLAYER");
end

function SnodderbackUI_ConfigFrame_TargetClassPortrait_OnClick(self, button, down)
	SnodderbackUI_Config_HandleClassPortrait(self,"TARGET");
end

function SnodderbackUI_Config_Generic_Ok_Handler(self,button,down)
	--Player
	if self:GetParent():GetName() == "SnodderbackUI_ConfigFrame_PlayerX" then
		local i = _G[self:GetParent():GetName().."_Input"]:GetText();
		if tonumber(i) ~= nil then
			i = tonumber(i);
			SnodderbackUI_Global["PLAYER_INFO"]["X"] = i;
		end;
	end
	if self:GetParent():GetName() == "SnodderbackUI_ConfigFrame_PlayerY" then
		local i = _G[self:GetParent():GetName().."_Input"]:GetText();
		if tonumber(i) ~= nil then
			i = tonumber(i);
			SnodderbackUI_Global["PLAYER_INFO"]["Y"] = i;
		end;
	end
	if self:GetParent():GetName() == "SnodderbackUI_ConfigFrame_PlayerScale" then
		local i = _G[self:GetParent():GetName().."_Input"]:GetText();
		if tonumber(i) ~= nil then
			i = tonumber(i);
			SnodderbackUI_Global["PLAYER_INFO"]["SCALE"] = i;
		end;
	end
	--Target
	if self:GetParent():GetName() == "SnodderbackUI_ConfigFrame_TargetX" then
		local i = _G[self:GetParent():GetName().."_Input"]:GetText();
		if tonumber(i) ~= nil then
			i = tonumber(i);
			SnodderbackUI_Global["TARGET_INFO"]["X"] = i;
		end;
	end
	if self:GetParent():GetName() == "SnodderbackUI_ConfigFrame_TargetY" then
		local i = _G[self:GetParent():GetName().."_Input"]:GetText();
		if tonumber(i) ~= nil then
			i = tonumber(i);
			SnodderbackUI_Global["TARGET_INFO"]["Y"] = i;
		end;
	end
	if self:GetParent():GetName() == "SnodderbackUI_ConfigFrame_TargetScale" then
		local i = _G[self:GetParent():GetName().."_Input"]:GetText();
		if tonumber(i) ~= nil then
			i = tonumber(i);
			SnodderbackUI_Global["TARGET_INFO"]["SCALE"] = i;
		end;
	end
	SnodderbackUI_AdjustUI();
end

function SnodderbackUI_Config_HandleClassPortrait(button, who)
	if who == "TARGET" then
		if button:GetChecked() then
			SnodderbackUI_Global["TARGET_INFO"]["PORTRAIT"] = "CLASS";
		else
			SnodderbackUI_Global["TARGET_INFO"]["PORTRAIT"] = "PORTRAIT";
		end
	elseif who == "PLAYER" then
		if button:GetChecked() then
			SnodderbackUI_Global["PLAYER_INFO"]["PORTRAIT"] = "CLASS";
		else
			SnodderbackUI_Global["PLAYER_INFO"]["PORTRAIT"] = "PORTRAIT";
		end
	end
	SnodderbackUI_ReloadPortrait();
	SnodderbackUI_AdjustUI();
end

function SnodderbackUI_Config_OnShow(self)
	
	--Setup Label Text
	SnodderbackUI_ConfigFrame_PlayerClassPortraitText:SetText("Display the players class as portrait");
	SnodderbackUI_ConfigFrame_TargetClassPortraitText:SetText("Display the targets class as portrait");
	
	SnodderbackUI_ConfigFrame_PlayerX_Label:SetText("Insert PlayerFrame X-Coordinate");
	SnodderbackUI_ConfigFrame_PlayerY_Label:SetText("Insert PlayerFrame Y-Coordinate");
	SnodderbackUI_ConfigFrame_PlayerScale_Label:SetText("Insert PlayerFrame Scale");
	
	SnodderbackUI_ConfigFrame_TargetX_Label:SetText("Insert TargetFrame X-Coordinate");
	SnodderbackUI_ConfigFrame_TargetY_Label:SetText("Insert TargetFrame Y-Coordinate");
	SnodderbackUI_ConfigFrame_TargetScale_Label:SetText("Insert TargetFrame Scale");
	
	SnodderbackUI_ConfigFrame_PlayerX_Input:SetText(	SnodderbackUI_Global["PLAYER_INFO"]["X"]);
	SnodderbackUI_ConfigFrame_PlayerY_Input:SetText(	SnodderbackUI_Global["PLAYER_INFO"]["Y"]);
	SnodderbackUI_ConfigFrame_PlayerScale_Input:SetText(SnodderbackUI_Global["PLAYER_INFO"]["SCALE"]);
	
	SnodderbackUI_ConfigFrame_TargetX_Input:SetText(	SnodderbackUI_Global["TARGET_INFO"]["X"]);
	SnodderbackUI_ConfigFrame_TargetY_Input:SetText(	SnodderbackUI_Global["TARGET_INFO"]["Y"]);
	SnodderbackUI_ConfigFrame_TargetScale_Input:SetText(SnodderbackUI_Global["TARGET_INFO"]["SCALE"]);
	
	--Player Class or Portrait Switch
	if SnodderbackUI_Global["PLAYER_INFO"]["PORTRAIT"] == "CLASS" then
		SnodderbackUI_ConfigFrame_PlayerClassPortrait:SetChecked(true);
	end
	
	if SnodderbackUI_Global["TARGET_INFO"]["PORTRAIT"] == "CLASS" then
		SnodderbackUI_ConfigFrame_TargetClassPortrait:SetChecked(true);
	end
end

