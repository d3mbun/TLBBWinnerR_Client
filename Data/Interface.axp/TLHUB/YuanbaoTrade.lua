
function YuanbaoTrade_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UPDATE_YUANBAO");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function YuanbaoTrade_OnLoad()

end

function YuanbaoTrade_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 1022001 then

		if this:IsVisible() then
			this:Hide();
			return;
		end
		YuanbaoTrade_Update(-1)
		this:Show();
	end
	
	if event == "UPDATE_YUANBAO" then
		local CharYuanbao = DataPool:GetPlayerMission_DataRound(310)
		YuanbaoTrade_Text2:SetText("Nguyên bäo hi®n có: #G"..CharYuanbao)
	end
	
	if event == "PLAYER_LEAVE_WORLD" then
		YuanbaoTrade_OnHidden();
		return;
	end
end

function YuanbaoTrade_Update(value)

end

function YuanbaoTrade_Change()
	local str = YuanbaoTrade_Value:GetText();
	local strNumber = 0;	
	
	if ( str == nil ) then
		return;
	elseif( str == "" ) then
		strNumber = 1;
	else
		strNumber = tonumber( str );
	end
	
	str = tostring( strNumber );
	YuanbaoTrade_Value:SetTextOriginal( str );
end

function YuanbaoTrade_Buttons_Clicked()
	local str = YuanbaoTrade_Value:GetText();
	if (str==nil or str=="") then
		return
	end
	
	if tonumber(str) < 0 or tonumber(str) > 999999999 then
		PushDebugMessage("S¯ nh§p nguyên bäo không hþp l®!");
		return
	end
	
	local MyYuanbao = DataPool:GetPlayerMission_DataRound(310)
	if tonumber(str) > MyYuanbao then
		PushDebugMessage("Không có ðü s¯ nguyên bäo!");
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnCreateItem")
		Set_XSCRIPT_ScriptID(045050)
		Set_XSCRIPT_Parameter(0, 5)
		Set_XSCRIPT_Parameter(1, tonumber(str))
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

function YuanbaoTrade_Help()
	PushDebugMessage("")
end

function YuanbaoTrade_OnHidden()
	
	this:Hide()
end