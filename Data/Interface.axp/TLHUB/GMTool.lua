local GMTool_TargetName = "@NoName"
local GMTool_TargetID = "-1"

function GMTool_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function GMTool_OnLoad()

end

function GMTool_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 1004001 then
		GMTool_TargetName = tostring(arg1)
		GMTool_TargetID = tonumber(arg2)
		if this:IsVisible() then
			this:Hide();
			return;
		end
		GMTool_Update()
		this:Show();
	end
	
	
	if event == "PLAYER_LEAVE_WORLD" then
		GMTool_OnHidden();
		return;
	end
end

function GMTool_Update()
	GMTool_InputIDText:SetText("Target Name: #G"..GMTool_TargetName)
	GMTool_InputID_Copy:SetText(GMTool_TargetName)
	GMTool_InputIDDec:SetText("Target ID: #G"..GMTool_TargetID)
	GMTool_InputIDDec_Copy:SetText(GMTool_TargetID)
	
end

function GMTool_CheckItem()
	local ItemID = GMTool_InputItemID:GetText()
	if string.len(ItemID) < 8 then
		PushDebugMessage("Item ID g°m 8 chæ s¯!")
		return
	end
	
	ItemID = tonumber(ItemID)
	
	local ItemName = "#{_ITEM"..ItemID.."}";
	
	GMTool_ItemName:SetText(ItemName);
end

function GMTool_CreateItem()
	local ItemID = tonumber(GMTool_InputItemID:GetText())
	local ItemNum = tonumber(GMTool_InputItemNum:GetText())
	
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("GMToolAction")
	Set_XSCRIPT_ScriptID(045006)
	Set_XSCRIPT_Parameter(0,1) --Create Item
	Set_XSCRIPT_Parameter(1,GMTool_TargetID)
	Set_XSCRIPT_Parameter(2,ItemID)
	Set_XSCRIPT_Parameter(3,ItemNum)
	Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT();
	
	--Clear Input
	GMTool_InputItemID:SetText("")
	GMTool_InputItemNum:SetText("")
end

function GMTool_AddGold()
	local GoldNum = tonumber(GMTool_InputGold:GetText())
	
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("GMToolAction")
	Set_XSCRIPT_ScriptID(045006)
	Set_XSCRIPT_Parameter(0,2) --Add Gold
	Set_XSCRIPT_Parameter(1,GMTool_TargetID)
	Set_XSCRIPT_Parameter(2,GoldNum)
	Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();
	
	--Clear Input
	GMTool_InputGold:SetText("")
	GMTool_ViewGold:SetText("")
end

function GMTool_AddGoldJZ()
	local GoldJZNum = tonumber(GMTool_InputGoldJZ:GetText())
	
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("GMToolAction")
	Set_XSCRIPT_ScriptID(045006)
	Set_XSCRIPT_Parameter(0,3) --Add GoldJZ
	Set_XSCRIPT_Parameter(1,GMTool_TargetID)
	Set_XSCRIPT_Parameter(2,GoldJZNum)
	Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();
	
	--Clear Input
	GMTool_InputGoldJZ:SetText("")
	GMTool_ViewGoldJZ:SetText("")
end

function GMTool_AddYuanbao()
	local YuanbaoNum = tonumber(GMTool_InputYuanbao:GetText())
	
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("GMToolAction")
	Set_XSCRIPT_ScriptID(045006)
	Set_XSCRIPT_Parameter(0,4) --Add Yuanbao
	Set_XSCRIPT_Parameter(1,GMTool_TargetID)
	Set_XSCRIPT_Parameter(2,YuanbaoNum)
	Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();
	
	--Clear Input
	GMTool_InputYuanbao:SetText("")
end

function GMTool_AddYuanbaoJZ()
	local YuanbaoJZNum = tonumber(GMTool_InputYuanbaoJZ:GetText())
	
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("GMToolAction")
	Set_XSCRIPT_ScriptID(045006)
	Set_XSCRIPT_Parameter(0,5) --Add Yuanbao
	Set_XSCRIPT_Parameter(1,GMTool_TargetID)
	Set_XSCRIPT_Parameter(2,YuanbaoJZNum)
	Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();
	
	--Clear Input
	GMTool_InputYuanbaoJZ:SetText("")
end

function GMTool_AddZengdian()
	local ZengdianNum = tonumber(GMTool_InputZengdian:GetText())
	
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("GMToolAction")
	Set_XSCRIPT_ScriptID(045006)
	Set_XSCRIPT_Parameter(0,6) --Add Zengdian
	Set_XSCRIPT_Parameter(1,GMTool_TargetID)
	Set_XSCRIPT_Parameter(2,ZengdianNum)
	Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();
	
	--Clear Input
	GMTool_InputZengdian:SetText("")
end

function GMTool_AddMenpaiPoint()
	local MenpaiPointNum = tonumber(GMTool_InputMenpaiPoint:GetText())
	
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("GMToolAction")
	Set_XSCRIPT_ScriptID(045006)
	Set_XSCRIPT_Parameter(0,7) --Add Menpai Point
	Set_XSCRIPT_Parameter(1,GMTool_TargetID)
	Set_XSCRIPT_Parameter(2,MenpaiPointNum)
	Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();
	
	--Clear Input
	GMTool_InputMenpaiPoint:SetText("")
end

function GMTool_CheckGold()
	local GoldNum = GMTool_InputGold:GetText()
	if string.len(GoldNum) <= 0 then
		PushDebugMessage("S¯ vàng không h÷p l®!")
		return
	end
	
	GoldNum = tonumber(GoldNum)
	
	local GoldStr = GMTool_StrMoney(GoldNum)
	GMTool_ViewGold:SetText(GoldStr)
end

function GMTool_CheckGoldJZ()
	local GoldJZNum = GMTool_InputGoldJZ:GetText()
	if string.len(GoldJZNum) <= 0 then
		PushDebugMessage("S¯ giao tØ không h÷p l®!")
		return
	end
	
	GoldJZNum = tonumber(GoldJZNum)
	
	local GoldJZStr = GMTool_StrBindMoney(GoldJZNum)
	GMTool_ViewGoldJZ:SetText(GoldJZStr)
end

function GMTool_Help()
	PushDebugMessage("Công cø h² trþ ð¡t lñc cho GM!")
end

function GMTool_OnHidden()
	this:Hide()
end

function GMTool_StrMoney(PriceValue)
	local VStr, BStr, DStr = "";
	if string.len(tostring(PriceValue)) <= 7 then
		VStr = tostring(math.floor(PriceValue/10000));
		BStr = tostring(math.mod(math.floor(PriceValue/100),100));
		DStr = tostring(math.mod(PriceValue,100));
	else
		PriceValue = tostring(PriceValue);
		local StrLen = string.len(PriceValue);
		VStr = tonumber(string.sub(PriceValue,1,StrLen-4));
		BStr = tonumber(string.sub(PriceValue,StrLen-3,StrLen-2));
		DStr = tonumber(string.sub(PriceValue,StrLen-1,StrLen));
	end
	
	local StrMoney = "";
	
	if VStr == "0" and BStr ~= "0" then
		StrMoney = BStr.."#-03"..DStr.."#-04";
	elseif VStr == "0" and BStr == "0" then
		StrMoney = DStr.."#-04";
	else
		StrMoney = VStr.."#-02"..BStr.."#-03"..DStr.."#-04";
	end

	return StrMoney;
end

function GMTool_StrBindMoney(PriceValue)
	local VStr, BStr, DStr = "";
	if string.len(tostring(PriceValue)) <= 7 then
		VStr = tostring(math.floor(PriceValue/10000));
		BStr = tostring(math.mod(math.floor(PriceValue/100),100));
		DStr = tostring(math.mod(PriceValue,100));
	else
		PriceValue = tostring(PriceValue);
		local StrLen = string.len(PriceValue);
		VStr = tonumber(string.sub(PriceValue,1,StrLen-4));
		BStr = tonumber(string.sub(PriceValue,StrLen-3,StrLen-2));
		DStr = tonumber(string.sub(PriceValue,StrLen-1,StrLen));
	end

	local StrMoney = "";
	
	if VStr == "0" and BStr ~= "0" then
		StrMoney = BStr.."#-15"..DStr.."#-16";
	elseif VStr == "0" and BStr == "0" then
		StrMoney = DStr.."#-16";
	else
		StrMoney = VStr.."#-14"..BStr.."#-15"..DStr.."#-16";
	end

	return StrMoney;
end